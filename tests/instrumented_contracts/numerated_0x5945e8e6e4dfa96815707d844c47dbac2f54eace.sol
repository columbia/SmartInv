1 //  ####### ### ######  #######  #####     #    ######  #     # 
2 //  #        #  #     # #       #     #   # #   #     #  #   #  
3 //  #        #  #     # #       #        #   #  #     #   # #   
4 //  #####    #  ######  #####   #  #### #     # ######     #    
5 //  #        #  #   #   #       #     # ####### #   #      #    
6 //  #        #  #    #  #       #     # #     # #    #     #    
7 //  #       ### #     # #######  #####  #     # #     #    #    
8                                                              
9 //https://firegary.org/
10 //https://twitter.com/FireGaryERC
11 //https://t.co/lKMeHSnu5a
12 
13 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
14 
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @dev Interface of the ERC20 standard as defined in the EIP.
19  */
20 interface IERC20 {
21     /**
22      * @dev Emitted when `value` tokens are moved from one account (`from`) to
23      * another (`to`).
24      *
25      * Note that `value` may be zero.
26      */
27     event Transfer(address indexed from, address indexed to, uint256 value);
28 
29     /**
30      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
31      * a call to {approve}. `value` is the new allowance.
32      */
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 
35     /**
36      * @dev Returns the amount of tokens in existence.
37      */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41      * @dev Returns the amount of tokens owned by `account`.
42      */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46      * @dev Moves `amount` tokens from the caller's account to `to`.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * Emits a {Transfer} event.
51      */
52     function transfer(address to, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     /**
64      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Moves `amount` tokens from `from` to `to` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(
89         address from,
90         address to,
91         uint256 amount
92     ) external returns (bool);
93 }
94 
95 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
96 
97 
98 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
99 
100 pragma solidity ^0.8.0;
101 
102 
103 /**
104  * @dev Interface for the optional metadata functions from the ERC20 standard.
105  *
106  * _Available since v4.1._
107  */
108 interface IERC20Metadata is IERC20 {
109     /**
110      * @dev Returns the name of the token.
111      */
112     function name() external view returns (string memory);
113 
114     /**
115      * @dev Returns the symbol of the token.
116      */
117     function symbol() external view returns (string memory);
118 
119     /**
120      * @dev Returns the decimals places of the token.
121      */
122     function decimals() external view returns (uint8);
123 }
124 
125 // File: @openzeppelin/contracts/utils/Context.sol
126 
127 
128 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
129 
130 pragma solidity ^0.8.0;
131 
132 /**
133  * @dev Provides information about the current execution context, including the
134  * sender of the transaction and its data. While these are generally available
135  * via msg.sender and msg.data, they should not be accessed in such a direct
136  * manner, since when dealing with meta-transactions the account sending and
137  * paying for execution may not be the actual sender (as far as an application
138  * is concerned).
139  *
140  * This contract is only required for intermediate, library-like contracts.
141  */
142 abstract contract Context {
143     function _msgSender() internal view virtual returns (address) {
144         return msg.sender;
145     }
146 
147     function _msgData() internal view virtual returns (bytes calldata) {
148         return msg.data;
149     }
150 }
151 
152 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
153 
154 
155 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
156 
157 pragma solidity ^0.8.0;
158 
159 
160 
161 
162 /**
163  * @dev Implementation of the {IERC20} interface.
164  *
165  * This implementation is agnostic to the way tokens are created. This means
166  * that a supply mechanism has to be added in a derived contract using {_mint}.
167  * For a generic mechanism see {ERC20PresetMinterPauser}.
168  *
169  * TIP: For a detailed writeup see our guide
170  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
171  * to implement supply mechanisms].
172  *
173  * We have followed general OpenZeppelin Contracts guidelines: functions revert
174  * instead returning `false` on failure. This behavior is nonetheless
175  * conventional and does not conflict with the expectations of ERC20
176  * applications.
177  *
178  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
179  * This allows applications to reconstruct the allowance for all accounts just
180  * by listening to said events. Other implementations of the EIP may not emit
181  * these events, as it isn't required by the specification.
182  *
183  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
184  * functions have been added to mitigate the well-known issues around setting
185  * allowances. See {IERC20-approve}.
186  */
187 contract ERC20 is Context, IERC20, IERC20Metadata {
188     mapping(address => uint256) private _balances;
189 
190     mapping(address => mapping(address => uint256)) private _allowances;
191 
192     uint256 private _totalSupply;
193 
194     string private _name;
195     string private _symbol;
196 
197     /**
198      * @dev Sets the values for {name} and {symbol}.
199      *
200      * The default value of {decimals} is 18. To select a different value for
201      * {decimals} you should overload it.
202      *
203      * All two of these values are immutable: they can only be set once during
204      * construction.
205      */
206     constructor(string memory name_, string memory symbol_) {
207         _name = name_;
208         _symbol = symbol_;
209     }
210 
211     /**
212      * @dev Returns the name of the token.
213      */
214     function name() public view virtual override returns (string memory) {
215         return _name;
216     }
217 
218     /**
219      * @dev Returns the symbol of the token, usually a shorter version of the
220      * name.
221      */
222     function symbol() public view virtual override returns (string memory) {
223         return _symbol;
224     }
225 
226     /**
227      * @dev Returns the number of decimals used to get its user representation.
228      * For example, if `decimals` equals `2`, a balance of `505` tokens should
229      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
230      *
231      * Tokens usually opt for a value of 18, imitating the relationship between
232      * Ether and Wei. This is the value {ERC20} uses, unless this function is
233      * overridden;
234      *
235      * NOTE: This information is only used for _display_ purposes: it in
236      * no way affects any of the arithmetic of the contract, including
237      * {IERC20-balanceOf} and {IERC20-transfer}.
238      */
239     function decimals() public view virtual override returns (uint8) {
240         return 18;
241     }
242 
243     /**
244      * @dev See {IERC20-totalSupply}.
245      */
246     function totalSupply() public view virtual override returns (uint256) {
247         return _totalSupply;
248     }
249 
250     /**
251      * @dev See {IERC20-balanceOf}.
252      */
253     function balanceOf(address account) public view virtual override returns (uint256) {
254         return _balances[account];
255     }
256 
257     /**
258      * @dev See {IERC20-transfer}.
259      *
260      * Requirements:
261      *
262      * - `to` cannot be the zero address.
263      * - the caller must have a balance of at least `amount`.
264      */
265     function transfer(address to, uint256 amount) public virtual override returns (bool) {
266         address owner = _msgSender();
267         _transfer(owner, to, amount);
268         return true;
269     }
270 
271     /**
272      * @dev See {IERC20-allowance}.
273      */
274     function allowance(address owner, address spender) public view virtual override returns (uint256) {
275         return _allowances[owner][spender];
276     }
277 
278     /**
279      * @dev See {IERC20-approve}.
280      *
281      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
282      * `transferFrom`. This is semantically equivalent to an infinite approval.
283      *
284      * Requirements:
285      *
286      * - `spender` cannot be the zero address.
287      */
288     function approve(address spender, uint256 amount) public virtual override returns (bool) {
289         address owner = _msgSender();
290         _approve(owner, spender, amount);
291         return true;
292     }
293 
294     /**
295      * @dev See {IERC20-transferFrom}.
296      *
297      * Emits an {Approval} event indicating the updated allowance. This is not
298      * required by the EIP. See the note at the beginning of {ERC20}.
299      *
300      * NOTE: Does not update the allowance if the current allowance
301      * is the maximum `uint256`.
302      *
303      * Requirements:
304      *
305      * - `from` and `to` cannot be the zero address.
306      * - `from` must have a balance of at least `amount`.
307      * - the caller must have allowance for ``from``'s tokens of at least
308      * `amount`.
309      */
310     function transferFrom(
311         address from,
312         address to,
313         uint256 amount
314     ) public virtual override returns (bool) {
315         address spender = _msgSender();
316         _spendAllowance(from, spender, amount);
317         _transfer(from, to, amount);
318         return true;
319     }
320 
321     /**
322      * @dev Atomically increases the allowance granted to `spender` by the caller.
323      *
324      * This is an alternative to {approve} that can be used as a mitigation for
325      * problems described in {IERC20-approve}.
326      *
327      * Emits an {Approval} event indicating the updated allowance.
328      *
329      * Requirements:
330      *
331      * - `spender` cannot be the zero address.
332      */
333     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
334         address owner = _msgSender();
335         _approve(owner, spender, allowance(owner, spender) + addedValue);
336         return true;
337     }
338 
339     /**
340      * @dev Atomically decreases the allowance granted to `spender` by the caller.
341      *
342      * This is an alternative to {approve} that can be used as a mitigation for
343      * problems described in {IERC20-approve}.
344      *
345      * Emits an {Approval} event indicating the updated allowance.
346      *
347      * Requirements:
348      *
349      * - `spender` cannot be the zero address.
350      * - `spender` must have allowance for the caller of at least
351      * `subtractedValue`.
352      */
353     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
354         address owner = _msgSender();
355         uint256 currentAllowance = allowance(owner, spender);
356         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
357         unchecked {
358             _approve(owner, spender, currentAllowance - subtractedValue);
359         }
360 
361         return true;
362     }
363 
364     /**
365      * @dev Moves `amount` of tokens from `from` to `to`.
366      *
367      * This internal function is equivalent to {transfer}, and can be used to
368      * e.g. implement automatic token fees, slashing mechanisms, etc.
369      *
370      * Emits a {Transfer} event.
371      *
372      * Requirements:
373      *
374      * - `from` cannot be the zero address.
375      * - `to` cannot be the zero address.
376      * - `from` must have a balance of at least `amount`.
377      */
378     function _transfer(
379         address from,
380         address to,
381         uint256 amount
382     ) internal virtual {
383         require(from != address(0), "ERC20: transfer from the zero address");
384         require(to != address(0), "ERC20: transfer to the zero address");
385 
386         _beforeTokenTransfer(from, to, amount);
387 
388         uint256 fromBalance = _balances[from];
389         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
390         unchecked {
391             _balances[from] = fromBalance - amount;
392             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
393             // decrementing then incrementing.
394             _balances[to] += amount;
395         }
396 
397         emit Transfer(from, to, amount);
398 
399         _afterTokenTransfer(from, to, amount);
400     }
401 
402     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
403      * the total supply.
404      *
405      * Emits a {Transfer} event with `from` set to the zero address.
406      *
407      * Requirements:
408      *
409      * - `account` cannot be the zero address.
410      */
411     function _mint(address account, uint256 amount) internal virtual {
412         require(account != address(0), "ERC20: mint to the zero address");
413 
414         _beforeTokenTransfer(address(0), account, amount);
415 
416         _totalSupply += amount;
417         unchecked {
418             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
419             _balances[account] += amount;
420         }
421         emit Transfer(address(0), account, amount);
422 
423         _afterTokenTransfer(address(0), account, amount);
424     }
425 
426     /**
427      * @dev Destroys `amount` tokens from `account`, reducing the
428      * total supply.
429      *
430      * Emits a {Transfer} event with `to` set to the zero address.
431      *
432      * Requirements:
433      *
434      * - `account` cannot be the zero address.
435      * - `account` must have at least `amount` tokens.
436      */
437     function _burn(address account, uint256 amount) internal virtual {
438         require(account != address(0), "ERC20: burn from the zero address");
439 
440         _beforeTokenTransfer(account, address(0), amount);
441 
442         uint256 accountBalance = _balances[account];
443         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
444         unchecked {
445             _balances[account] = accountBalance - amount;
446             // Overflow not possible: amount <= accountBalance <= totalSupply.
447             _totalSupply -= amount;
448         }
449 
450         emit Transfer(account, address(0), amount);
451 
452         _afterTokenTransfer(account, address(0), amount);
453     }
454 
455     /**
456      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
457      *
458      * This internal function is equivalent to `approve`, and can be used to
459      * e.g. set automatic allowances for certain subsystems, etc.
460      *
461      * Emits an {Approval} event.
462      *
463      * Requirements:
464      *
465      * - `owner` cannot be the zero address.
466      * - `spender` cannot be the zero address.
467      */
468     function _approve(
469         address owner,
470         address spender,
471         uint256 amount
472     ) internal virtual {
473         require(owner != address(0), "ERC20: approve from the zero address");
474         require(spender != address(0), "ERC20: approve to the zero address");
475 
476         _allowances[owner][spender] = amount;
477         emit Approval(owner, spender, amount);
478     }
479 
480     /**
481      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
482      *
483      * Does not update the allowance amount in case of infinite allowance.
484      * Revert if not enough allowance is available.
485      *
486      * Might emit an {Approval} event.
487      */
488     function _spendAllowance(
489         address owner,
490         address spender,
491         uint256 amount
492     ) internal virtual {
493         uint256 currentAllowance = allowance(owner, spender);
494         if (currentAllowance != type(uint256).max) {
495             require(currentAllowance >= amount, "ERC20: insufficient allowance");
496             unchecked {
497                 _approve(owner, spender, currentAllowance - amount);
498             }
499         }
500     }
501 
502     /**
503      * @dev Hook that is called before any transfer of tokens. This includes
504      * minting and burning.
505      *
506      * Calling conditions:
507      *
508      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
509      * will be transferred to `to`.
510      * - when `from` is zero, `amount` tokens will be minted for `to`.
511      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
512      * - `from` and `to` are never both zero.
513      *
514      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
515      */
516     function _beforeTokenTransfer(
517         address from,
518         address to,
519         uint256 amount
520     ) internal virtual {}
521 
522     /**
523      * @dev Hook that is called after any transfer of tokens. This includes
524      * minting and burning.
525      *
526      * Calling conditions:
527      *
528      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
529      * has been transferred to `to`.
530      * - when `from` is zero, `amount` tokens have been minted for `to`.
531      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
532      * - `from` and `to` are never both zero.
533      *
534      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
535      */
536     function _afterTokenTransfer(
537         address from,
538         address to,
539         uint256 amount
540     ) internal virtual {}
541 }
542 
543 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
544 
545 
546 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
547 
548 pragma solidity ^0.8.0;
549 
550 
551 
552 /**
553  * @dev Extension of {ERC20} that allows token holders to destroy both their own
554  * tokens and those that they have an allowance for, in a way that can be
555  * recognized off-chain (via event analysis).
556  */
557 abstract contract ERC20Burnable is Context, ERC20 {
558     /**
559      * @dev Destroys `amount` tokens from the caller.
560      *
561      * See {ERC20-_burn}.
562      */
563     function burn(uint256 amount) public virtual {
564         _burn(_msgSender(), amount);
565     }
566 
567     /**
568      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
569      * allowance.
570      *
571      * See {ERC20-_burn} and {ERC20-allowance}.
572      *
573      * Requirements:
574      *
575      * - the caller must have allowance for ``accounts``'s tokens of at least
576      * `amount`.
577      */
578     function burnFrom(address account, uint256 amount) public virtual {
579         _spendAllowance(account, _msgSender(), amount);
580         _burn(account, amount);
581     }
582 }
583 
584 // File: @openzeppelin/contracts/access/Ownable.sol
585 
586 
587 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
588 
589 pragma solidity ^0.8.0;
590 
591 
592 /**
593  * @dev Contract module which provides a basic access control mechanism, where
594  * there is an account (an owner) that can be granted exclusive access to
595  * specific functions.
596  *
597  * By default, the owner account will be the one that deploys the contract. This
598  * can later be changed with {transferOwnership}.
599  *
600  * This module is used through inheritance. It will make available the modifier
601  * `onlyOwner`, which can be applied to your functions to restrict their use to
602  * the owner.
603  */
604 abstract contract Ownable is Context {
605     address private _owner;
606 
607     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
608 
609     /**
610      * @dev Initializes the contract setting the deployer as the initial owner.
611      */
612     constructor() {
613         _transferOwnership(_msgSender());
614     }
615 
616     /**
617      * @dev Throws if called by any account other than the owner.
618      */
619     modifier onlyOwner() {
620         _checkOwner();
621         _;
622     }
623 
624     /**
625      * @dev Returns the address of the current owner.
626      */
627     function owner() public view virtual returns (address) {
628         return _owner;
629     }
630 
631     /**
632      * @dev Throws if the sender is not the owner.
633      */
634     function _checkOwner() internal view virtual {
635         require(owner() == _msgSender(), "Ownable: caller is not the owner");
636     }
637 
638     /**
639      * @dev Leaves the contract without owner. It will not be possible to call
640      * `onlyOwner` functions anymore. Can only be called by the current owner.
641      *
642      * NOTE: Renouncing ownership will leave the contract without an owner,
643      * thereby removing any functionality that is only available to the owner.
644      */
645     function renounceOwnership() public virtual onlyOwner {
646         _transferOwnership(address(0));
647     }
648 
649     /**
650      * @dev Transfers ownership of the contract to a new account (`newOwner`).
651      * Can only be called by the current owner.
652      */
653     function transferOwnership(address newOwner) public virtual onlyOwner {
654         require(newOwner != address(0), "Ownable: new owner is the zero address");
655         _transferOwnership(newOwner);
656     }
657 
658     /**
659      * @dev Transfers ownership of the contract to a new account (`newOwner`).
660      * Internal function without access restriction.
661      */
662     function _transferOwnership(address newOwner) internal virtual {
663         address oldOwner = _owner;
664         _owner = newOwner;
665         emit OwnershipTransferred(oldOwner, newOwner);
666     }
667 }
668 
669 // File: firegary.sol
670 
671 
672 
673 
674 
675  
676 pragma solidity ^0.8.0;
677  
678 contract FireGary is Ownable, ERC20 {
679     IUniswapV2Router02 public uniswapV2Router;
680     bool public limited;
681     bool public taxesEnabled = true;
682     bool public pause = true;
683     uint256 public maxHoldingAmount;
684     uint256 public minHoldingAmount;
685     uint256 public taxPercent = 5; 
686  
687     bool inSwapAndLiq;
688  
689     address public marketingWallet = 0xCAD14A2bc771f682Fcd7Bd96487e82d8106a96b2;
690     address public uniswapV2Pair;
691     mapping(address => bool) public blacklists;
692     mapping(address => bool) public _isExcludedFromFees;
693  
694     modifier lockTheSwap() {
695         inSwapAndLiq = true;
696         _;
697         inSwapAndLiq = false;
698     }
699  
700     constructor() ERC20("FireGary", "FIREGARY") {
701         _mint(msg.sender, 89000000000000000000000000000);
702         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
703             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
704         );
705         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
706             .createPair(address(this), _uniswapV2Router.WETH());
707  
708         uniswapV2Router = _uniswapV2Router;
709         uniswapV2Pair = _uniswapV2Pair;
710  
711         _isExcludedFromFees[msg.sender] = true;
712         _isExcludedFromFees[marketingWallet] = true;
713         _isExcludedFromFees[uniswapV2Pair] = true;
714  
715         marketingWallet = 0xCAD14A2bc771f682Fcd7Bd96487e82d8106a96b2;
716     }
717  
718     function _transfer(
719         address from,
720         address to,
721         uint256 amount
722     ) internal override {
723         require(from != address(0), "ERC20: transfer from the zero address");
724         require(to != address(0), "ERC20: transfer to the zero address");
725         require(amount > 0, "ERC20: transfer must be greater than 0");
726  
727         uint256 taxAmount;
728         if (taxesEnabled) {
729             if (from == uniswapV2Pair) {
730                 //Buy
731  
732                 if (!_isExcludedFromFees[to])
733                     taxAmount = (amount * taxPercent) / 100;
734             }
735             // Sell
736             if (to == uniswapV2Pair) {
737                 if (!_isExcludedFromFees[from])
738                     taxAmount = (amount * taxPercent) / 100;
739             }
740         }
741  
742         uint256 contractTokenBalance = balanceOf(address(this));
743         bool overMinTokenBalance = contractTokenBalance >=
744             (totalSupply() * 3) / 1000;
745  
746         if (overMinTokenBalance && !inSwapAndLiq && from != uniswapV2Pair) {
747             handleTax();
748         }
749  
750         // Fees
751         if (taxAmount > 0) {
752             uint256 userAmount = amount - taxAmount;
753             super._transfer(from, address(this), taxAmount);
754             super._transfer(from, to, userAmount);
755         } else {
756             super._transfer(from, to, amount);
757         }
758     }
759  
760     function handleTax() internal lockTheSwap {
761         // generate the uniswap pair path of token -> weth
762         address[] memory path = new address[](2);
763         path[0] = address(this);
764         path[1] = uniswapV2Router.WETH();
765  
766         _approve(
767             address(this),
768             address(uniswapV2Router),
769             balanceOf(address(this))
770         );
771  
772         // make the swap
773         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
774             balanceOf(address(this)),
775             0, // accept any amount of ETH
776             path,
777             marketingWallet,
778             block.timestamp
779         );
780     }
781  
782     function _beforeTokenTransfer(
783         address from,
784         address to,
785         uint256 amount
786     ) internal virtual override {
787         require(!blacklists[to] && !blacklists[from], "Blacklisted");
788                 
789         if (pause) {
790             require(from == owner() || to == owner(), "trading is not started");
791             return;
792         }
793         
794         if (limited && from == uniswapV2Pair) {
795             require(
796                 super.balanceOf(to) + amount <= maxHoldingAmount &&
797                     super.balanceOf(to) + amount >= minHoldingAmount,
798                 "Forbid"
799             );
800         }
801     }
802  
803     function changeMarketingWallet(
804         address _newMarketingWallet
805     ) external onlyOwner {
806         marketingWallet = _newMarketingWallet;
807     }
808  
809     function changeTaxPercent(uint256 _newTaxPercent) external onlyOwner {
810         taxPercent = _newTaxPercent;
811     }
812 
813     function togglePause() external onlyOwner{	
814         pause = !pause;	
815     }	
816  
817     function excludeFromFees(
818         address _address,
819         bool _isExcluded
820     ) external onlyOwner {
821         _isExcludedFromFees[_address] = _isExcluded;
822     }
823  
824     function burn(uint256 value) external {
825         _burn(msg.sender, value);
826     }
827  
828     function enableTaxes(bool _enable) external onlyOwner {
829         taxesEnabled = _enable;
830     }
831  
832     function toggleLimited() external onlyOwner {
833         limited = !limited;
834     }
835  
836     function blacklist(
837         address _address,
838         bool _isBlacklisting
839     ) external onlyOwner {
840         blacklists[_address] = _isBlacklisting;
841     }
842  
843     function setRule(
844         bool _limited,
845         uint256 _maxHoldingAmount,
846         uint256 _minHoldingAmount
847     ) external onlyOwner {
848         limited = _limited;
849         maxHoldingAmount = _maxHoldingAmount;
850         minHoldingAmount = _minHoldingAmount;
851     }
852 }
853  
854 // Interfaces
855 interface IUniswapV2Factory {
856     event PairCreated(
857         address indexed token0,
858         address indexed token1,
859         address pair,
860         uint
861     );
862  
863     function feeTo() external view returns (address);
864  
865     function feeToSetter() external view returns (address);
866  
867     function getPair(
868         address tokenA,
869         address tokenB
870     ) external view returns (address pair);
871  
872     function allPairs(uint) external view returns (address pair);
873  
874     function allPairsLength() external view returns (uint);
875  
876     function createPair(
877         address tokenA,
878         address tokenB
879     ) external returns (address pair);
880  
881     function setFeeTo(address) external;
882  
883     function setFeeToSetter(address) external;
884 }
885  
886 interface IUniswapV2Pair {
887     event Approval(address indexed owner, address indexed spender, uint value);
888     event Transfer(address indexed from, address indexed to, uint value);
889  
890     function name() external pure returns (string memory);
891  
892     function symbol() external pure returns (string memory);
893  
894     function decimals() external pure returns (uint8);
895  
896     function totalSupply() external view returns (uint);
897  
898     function balanceOf(address owner) external view returns (uint);
899  
900     function allowance(
901         address owner,
902         address spender
903     ) external view returns (uint);
904  
905     function approve(address spender, uint value) external returns (bool);
906  
907     function transfer(address to, uint value) external returns (bool);
908  
909     function transferFrom(
910         address from,
911         address to,
912         uint value
913     ) external returns (bool);
914  
915     function DOMAIN_SEPARATOR() external view returns (bytes32);
916  
917     function PERMIT_TYPEHASH() external pure returns (bytes32);
918  
919     function nonces(address owner) external view returns (uint);
920  
921     function permit(
922         address owner,
923         address spender,
924         uint value,
925         uint deadline,
926         uint8 v,
927         bytes32 r,
928         bytes32 s
929     ) external;
930  
931     event Mint(address indexed sender, uint amount0, uint amount1);
932     event Burn(
933         address indexed sender,
934         uint amount0,
935         uint amount1,
936         address indexed to
937     );
938     event Swap(
939         address indexed sender,
940         uint amount0In,
941         uint amount1In,
942         uint amount0Out,
943         uint amount1Out,
944         address indexed to
945     );
946     event Sync(uint112 reserve0, uint112 reserve1);
947  
948     function MINIMUM_LIQUIDITY() external pure returns (uint);
949  
950     function factory() external view returns (address);
951  
952     function token0() external view returns (address);
953  
954     function token1() external view returns (address);
955  
956     function getReserves()
957         external
958         view
959         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
960  
961     function price0CumulativeLast() external view returns (uint);
962  
963     function price1CumulativeLast() external view returns (uint);
964  
965     function kLast() external view returns (uint);
966  
967     function mint(address to) external returns (uint liquidity);
968  
969     function burn(address to) external returns (uint amount0, uint amount1);
970  
971     function swap(
972         uint amount0Out,
973         uint amount1Out,
974         address to,
975         bytes calldata data
976     ) external;
977  
978     function skim(address to) external;
979  
980     function sync() external;
981  
982     function initialize(address, address) external;
983 }
984  
985 interface IUniswapV2Router01 {
986     function factory() external pure returns (address);
987  
988     function WETH() external pure returns (address);
989  
990     function addLiquidity(
991         address tokenA,
992         address tokenB,
993         uint amountADesired,
994         uint amountBDesired,
995         uint amountAMin,
996         uint amountBMin,
997         address to,
998         uint deadline
999     ) external returns (uint amountA, uint amountB, uint liquidity);
1000  
1001     function addLiquidityETH(
1002         address token,
1003         uint amountTokenDesired,
1004         uint amountTokenMin,
1005         uint amountETHMin,
1006         address to,
1007         uint deadline
1008     )
1009         external
1010         payable
1011         returns (uint amountToken, uint amountETH, uint liquidity);
1012  
1013     function removeLiquidity(
1014         address tokenA,
1015         address tokenB,
1016         uint liquidity,
1017         uint amountAMin,
1018         uint amountBMin,
1019         address to,
1020         uint deadline
1021     ) external returns (uint amountA, uint amountB);
1022  
1023     function removeLiquidityETH(
1024         address token,
1025         uint liquidity,
1026         uint amountTokenMin,
1027         uint amountETHMin,
1028         address to,
1029         uint deadline
1030     ) external returns (uint amountToken, uint amountETH);
1031  
1032     function removeLiquidityWithPermit(
1033         address tokenA,
1034         address tokenB,
1035         uint liquidity,
1036         uint amountAMin,
1037         uint amountBMin,
1038         address to,
1039         uint deadline,
1040         bool approveMax,
1041         uint8 v,
1042         bytes32 r,
1043         bytes32 s
1044     ) external returns (uint amountA, uint amountB);
1045  
1046     function removeLiquidityETHWithPermit(
1047         address token,
1048         uint liquidity,
1049         uint amountTokenMin,
1050         uint amountETHMin,
1051         address to,
1052         uint deadline,
1053         bool approveMax,
1054         uint8 v,
1055         bytes32 r,
1056         bytes32 s
1057     ) external returns (uint amountToken, uint amountETH);
1058  
1059     function swapExactTokensForTokens(
1060         uint amountIn,
1061         uint amountOutMin,
1062         address[] calldata path,
1063         address to,
1064         uint deadline
1065     ) external returns (uint[] memory amounts);
1066  
1067     function swapTokensForExactTokens(
1068         uint amountOut,
1069         uint amountInMax,
1070         address[] calldata path,
1071         address to,
1072         uint deadline
1073     ) external returns (uint[] memory amounts);
1074  
1075     function swapExactETHForTokens(
1076         uint amountOutMin,
1077         address[] calldata path,
1078         address to,
1079         uint deadline
1080     ) external payable returns (uint[] memory amounts);
1081  
1082     function swapTokensForExactETH(
1083         uint amountOut,
1084         uint amountInMax,
1085         address[] calldata path,
1086         address to,
1087         uint deadline
1088     ) external returns (uint[] memory amounts);
1089  
1090     function swapExactTokensForETH(
1091         uint amountIn,
1092         uint amountOutMin,
1093         address[] calldata path,
1094         address to,
1095         uint deadline
1096     ) external returns (uint[] memory amounts);
1097  
1098     function swapETHForExactTokens(
1099         uint amountOut,
1100         address[] calldata path,
1101         address to,
1102         uint deadline
1103     ) external payable returns (uint[] memory amounts);
1104  
1105     function quote(
1106         uint amountA,
1107         uint reserveA,
1108         uint reserveB
1109     ) external pure returns (uint amountB);
1110  
1111     function getAmountOut(
1112         uint amountIn,
1113         uint reserveIn,
1114         uint reserveOut
1115     ) external pure returns (uint amountOut);
1116  
1117     function getAmountIn(
1118         uint amountOut,
1119         uint reserveIn,
1120         uint reserveOut
1121     ) external pure returns (uint amountIn);
1122  
1123     function getAmountsOut(
1124         uint amountIn,
1125         address[] calldata path
1126     ) external view returns (uint[] memory amounts);
1127  
1128     function getAmountsIn(
1129         uint amountOut,
1130         address[] calldata path
1131     ) external view returns (uint[] memory amounts);
1132 }
1133  
1134 interface IUniswapV2Router02 is IUniswapV2Router01 {
1135     function removeLiquidityETHSupportingFeeOnTransferTokens(
1136         address token,
1137         uint liquidity,
1138         uint amountTokenMin,
1139         uint amountETHMin,
1140         address to,
1141         uint deadline
1142     ) external returns (uint amountETH);
1143  
1144     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1145         address token,
1146         uint liquidity,
1147         uint amountTokenMin,
1148         uint amountETHMin,
1149         address to,
1150         uint deadline,
1151         bool approveMax,
1152         uint8 v,
1153         bytes32 r,
1154         bytes32 s
1155     ) external returns (uint amountETH);
1156  
1157     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1158         uint amountIn,
1159         uint amountOutMin,
1160         address[] calldata path,
1161         address to,
1162         uint deadline
1163     ) external;
1164  
1165     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1166         uint amountOutMin,
1167         address[] calldata path,
1168         address to,
1169         uint deadline
1170     ) external payable;
1171  
1172     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1173         uint amountIn,
1174         uint amountOutMin,
1175         address[] calldata path,
1176         address to,
1177         uint deadline
1178     ) external;
1179 }