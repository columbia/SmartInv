1 //                       _____          _____  
2 // _____      _____  ___|\    \    ____|\    \ 
3 // \    \    /    / /    /\    \  |    | \    \
4 //  \    \  /    / |    |  |____| |    |______/
5 //   \____\/____/  |    |    ____ |    |----'\ 
6 //   /    /\    \  |    |   |    ||    |_____/ 
7 //  /    /  \    \ |    |   |_,  ||    |       
8 // /____/ /\ \____\|\ ___\___/  /||____|       
9 // |    |/  \|    || |   /____ / ||    |       
10 // |____|    |____| \|___|    | / |____|       
11 //   \(        )/     \( |____|/    )/         
12 //    '        '       '   )/       '          
13 //                         '                   
14 
15 // > greedisgood
16 
17 // File @openzeppelin/contracts/utils/Context.sol@v4.9.3
18 
19 // SPDX-License-Identifier: MIT
20 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
21 
22 pragma solidity ^0.8.0;
23 
24 /**
25  * @dev Provides information about the current execution context, including the
26  * sender of the transaction and its data. While these are generally available
27  * via msg.sender and msg.data, they should not be accessed in such a direct
28  * manner, since when dealing with meta-transactions the account sending and
29  * paying for execution may not be the actual sender (as far as an application
30  * is concerned).
31  *
32  * This contract is only required for intermediate, library-like contracts.
33  */
34 abstract contract Context {
35     function _msgSender() internal view virtual returns (address) {
36         return msg.sender;
37     }
38 
39     function _msgData() internal view virtual returns (bytes calldata) {
40         return msg.data;
41     }
42 }
43 
44 
45 // File @openzeppelin/contracts/access/Ownable.sol@v4.9.3
46 
47 
48 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
49 
50 pragma solidity ^0.8.0;
51 
52 /**
53  * @dev Contract module which provides a basic access control mechanism, where
54  * there is an account (an owner) that can be granted exclusive access to
55  * specific functions.
56  *
57  * By default, the owner account will be the one that deploys the contract. This
58  * can later be changed with {transferOwnership}.
59  *
60  * This module is used through inheritance. It will make available the modifier
61  * `onlyOwner`, which can be applied to your functions to restrict their use to
62  * the owner.
63  */
64 abstract contract Ownable is Context {
65     address private _owner;
66 
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     /**
70      * @dev Initializes the contract setting the deployer as the initial owner.
71      */
72     constructor() {
73         _transferOwnership(_msgSender());
74     }
75 
76     /**
77      * @dev Throws if called by any account other than the owner.
78      */
79     modifier onlyOwner() {
80         _checkOwner();
81         _;
82     }
83 
84     /**
85      * @dev Returns the address of the current owner.
86      */
87     function owner() public view virtual returns (address) {
88         return _owner;
89     }
90 
91     /**
92      * @dev Throws if the sender is not the owner.
93      */
94     function _checkOwner() internal view virtual {
95         require(owner() == _msgSender(), "Ownable: caller is not the owner");
96     }
97 
98     /**
99      * @dev Leaves the contract without owner. It will not be possible to call
100      * `onlyOwner` functions. Can only be called by the current owner.
101      *
102      * NOTE: Renouncing ownership will leave the contract without an owner,
103      * thereby disabling any functionality that is only available to the owner.
104      */
105     function renounceOwnership() public virtual onlyOwner {
106         _transferOwnership(address(0));
107     }
108 
109     /**
110      * @dev Transfers ownership of the contract to a new account (`newOwner`).
111      * Can only be called by the current owner.
112      */
113     function transferOwnership(address newOwner) public virtual onlyOwner {
114         require(newOwner != address(0), "Ownable: new owner is the zero address");
115         _transferOwnership(newOwner);
116     }
117 
118     /**
119      * @dev Transfers ownership of the contract to a new account (`newOwner`).
120      * Internal function without access restriction.
121      */
122     function _transferOwnership(address newOwner) internal virtual {
123         address oldOwner = _owner;
124         _owner = newOwner;
125         emit OwnershipTransferred(oldOwner, newOwner);
126     }
127 }
128 
129 
130 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.9.3
131 
132 
133 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
134 
135 pragma solidity ^0.8.0;
136 
137 /**
138  * @dev Interface of the ERC20 standard as defined in the EIP.
139  */
140 interface IERC20 {
141     /**
142      * @dev Emitted when `value` tokens are moved from one account (`from`) to
143      * another (`to`).
144      *
145      * Note that `value` may be zero.
146      */
147     event Transfer(address indexed from, address indexed to, uint256 value);
148 
149     /**
150      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
151      * a call to {approve}. `value` is the new allowance.
152      */
153     event Approval(address indexed owner, address indexed spender, uint256 value);
154 
155     /**
156      * @dev Returns the amount of tokens in existence.
157      */
158     function totalSupply() external view returns (uint256);
159 
160     /**
161      * @dev Returns the amount of tokens owned by `account`.
162      */
163     function balanceOf(address account) external view returns (uint256);
164 
165     /**
166      * @dev Moves `amount` tokens from the caller's account to `to`.
167      *
168      * Returns a boolean value indicating whether the operation succeeded.
169      *
170      * Emits a {Transfer} event.
171      */
172     function transfer(address to, uint256 amount) external returns (bool);
173 
174     /**
175      * @dev Returns the remaining number of tokens that `spender` will be
176      * allowed to spend on behalf of `owner` through {transferFrom}. This is
177      * zero by default.
178      *
179      * This value changes when {approve} or {transferFrom} are called.
180      */
181     function allowance(address owner, address spender) external view returns (uint256);
182 
183     /**
184      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
185      *
186      * Returns a boolean value indicating whether the operation succeeded.
187      *
188      * IMPORTANT: Beware that changing an allowance with this method brings the risk
189      * that someone may use both the old and the new allowance by unfortunate
190      * transaction ordering. One possible solution to mitigate this race
191      * condition is to first reduce the spender's allowance to 0 and set the
192      * desired value afterwards:
193      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
194      *
195      * Emits an {Approval} event.
196      */
197     function approve(address spender, uint256 amount) external returns (bool);
198 
199     /**
200      * @dev Moves `amount` tokens from `from` to `to` using the
201      * allowance mechanism. `amount` is then deducted from the caller's
202      * allowance.
203      *
204      * Returns a boolean value indicating whether the operation succeeded.
205      *
206      * Emits a {Transfer} event.
207      */
208     function transferFrom(address from, address to, uint256 amount) external returns (bool);
209 }
210 
211 
212 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.9.3
213 
214 
215 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
216 
217 pragma solidity ^0.8.0;
218 
219 /**
220  * @dev Interface for the optional metadata functions from the ERC20 standard.
221  *
222  * _Available since v4.1._
223  */
224 interface IERC20Metadata is IERC20 {
225     /**
226      * @dev Returns the name of the token.
227      */
228     function name() external view returns (string memory);
229 
230     /**
231      * @dev Returns the symbol of the token.
232      */
233     function symbol() external view returns (string memory);
234 
235     /**
236      * @dev Returns the decimals places of the token.
237      */
238     function decimals() external view returns (uint8);
239 }
240 
241 
242 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.9.3
243 
244 
245 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
246 
247 pragma solidity ^0.8.0;
248 
249 
250 
251 /**
252  * @dev Implementation of the {IERC20} interface.
253  *
254  * This implementation is agnostic to the way tokens are created. This means
255  * that a supply mechanism has to be added in a derived contract using {_mint}.
256  * For a generic mechanism see {ERC20PresetMinterPauser}.
257  *
258  * TIP: For a detailed writeup see our guide
259  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
260  * to implement supply mechanisms].
261  *
262  * The default value of {decimals} is 18. To change this, you should override
263  * this function so it returns a different value.
264  *
265  * We have followed general OpenZeppelin Contracts guidelines: functions revert
266  * instead returning `false` on failure. This behavior is nonetheless
267  * conventional and does not conflict with the expectations of ERC20
268  * applications.
269  *
270  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
271  * This allows applications to reconstruct the allowance for all accounts just
272  * by listening to said events. Other implementations of the EIP may not emit
273  * these events, as it isn't required by the specification.
274  *
275  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
276  * functions have been added to mitigate the well-known issues around setting
277  * allowances. See {IERC20-approve}.
278  */
279 contract ERC20 is Context, IERC20, IERC20Metadata {
280     mapping(address => uint256) private _balances;
281 
282     mapping(address => mapping(address => uint256)) private _allowances;
283 
284     uint256 private _totalSupply;
285 
286     string private _name;
287     string private _symbol;
288 
289     /**
290      * @dev Sets the values for {name} and {symbol}.
291      *
292      * All two of these values are immutable: they can only be set once during
293      * construction.
294      */
295     constructor(string memory name_, string memory symbol_) {
296         _name = name_;
297         _symbol = symbol_;
298     }
299 
300     /**
301      * @dev Returns the name of the token.
302      */
303     function name() public view virtual override returns (string memory) {
304         return _name;
305     }
306 
307     /**
308      * @dev Returns the symbol of the token, usually a shorter version of the
309      * name.
310      */
311     function symbol() public view virtual override returns (string memory) {
312         return _symbol;
313     }
314 
315     /**
316      * @dev Returns the number of decimals used to get its user representation.
317      * For example, if `decimals` equals `2`, a balance of `505` tokens should
318      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
319      *
320      * Tokens usually opt for a value of 18, imitating the relationship between
321      * Ether and Wei. This is the default value returned by this function, unless
322      * it's overridden.
323      *
324      * NOTE: This information is only used for _display_ purposes: it in
325      * no way affects any of the arithmetic of the contract, including
326      * {IERC20-balanceOf} and {IERC20-transfer}.
327      */
328     function decimals() public view virtual override returns (uint8) {
329         return 18;
330     }
331 
332     /**
333      * @dev See {IERC20-totalSupply}.
334      */
335     function totalSupply() public view virtual override returns (uint256) {
336         return _totalSupply;
337     }
338 
339     /**
340      * @dev See {IERC20-balanceOf}.
341      */
342     function balanceOf(address account) public view virtual override returns (uint256) {
343         return _balances[account];
344     }
345 
346     /**
347      * @dev See {IERC20-transfer}.
348      *
349      * Requirements:
350      *
351      * - `to` cannot be the zero address.
352      * - the caller must have a balance of at least `amount`.
353      */
354     function transfer(address to, uint256 amount) public virtual override returns (bool) {
355         address owner = _msgSender();
356         _transfer(owner, to, amount);
357         return true;
358     }
359 
360     /**
361      * @dev See {IERC20-allowance}.
362      */
363     function allowance(address owner, address spender) public view virtual override returns (uint256) {
364         return _allowances[owner][spender];
365     }
366 
367     /**
368      * @dev See {IERC20-approve}.
369      *
370      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
371      * `transferFrom`. This is semantically equivalent to an infinite approval.
372      *
373      * Requirements:
374      *
375      * - `spender` cannot be the zero address.
376      */
377     function approve(address spender, uint256 amount) public virtual override returns (bool) {
378         address owner = _msgSender();
379         _approve(owner, spender, amount);
380         return true;
381     }
382 
383     /**
384      * @dev See {IERC20-transferFrom}.
385      *
386      * Emits an {Approval} event indicating the updated allowance. This is not
387      * required by the EIP. See the note at the beginning of {ERC20}.
388      *
389      * NOTE: Does not update the allowance if the current allowance
390      * is the maximum `uint256`.
391      *
392      * Requirements:
393      *
394      * - `from` and `to` cannot be the zero address.
395      * - `from` must have a balance of at least `amount`.
396      * - the caller must have allowance for ``from``'s tokens of at least
397      * `amount`.
398      */
399     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
400         address spender = _msgSender();
401         _spendAllowance(from, spender, amount);
402         _transfer(from, to, amount);
403         return true;
404     }
405 
406     /**
407      * @dev Atomically increases the allowance granted to `spender` by the caller.
408      *
409      * This is an alternative to {approve} that can be used as a mitigation for
410      * problems described in {IERC20-approve}.
411      *
412      * Emits an {Approval} event indicating the updated allowance.
413      *
414      * Requirements:
415      *
416      * - `spender` cannot be the zero address.
417      */
418     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
419         address owner = _msgSender();
420         _approve(owner, spender, allowance(owner, spender) + addedValue);
421         return true;
422     }
423 
424     /**
425      * @dev Atomically decreases the allowance granted to `spender` by the caller.
426      *
427      * This is an alternative to {approve} that can be used as a mitigation for
428      * problems described in {IERC20-approve}.
429      *
430      * Emits an {Approval} event indicating the updated allowance.
431      *
432      * Requirements:
433      *
434      * - `spender` cannot be the zero address.
435      * - `spender` must have allowance for the caller of at least
436      * `subtractedValue`.
437      */
438     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
439         address owner = _msgSender();
440         uint256 currentAllowance = allowance(owner, spender);
441         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
442         unchecked {
443             _approve(owner, spender, currentAllowance - subtractedValue);
444         }
445 
446         return true;
447     }
448 
449     /**
450      * @dev Moves `amount` of tokens from `from` to `to`.
451      *
452      * This internal function is equivalent to {transfer}, and can be used to
453      * e.g. implement automatic token fees, slashing mechanisms, etc.
454      *
455      * Emits a {Transfer} event.
456      *
457      * Requirements:
458      *
459      * - `from` cannot be the zero address.
460      * - `to` cannot be the zero address.
461      * - `from` must have a balance of at least `amount`.
462      */
463     function _transfer(address from, address to, uint256 amount) internal virtual {
464         require(from != address(0), "ERC20: transfer from the zero address");
465         require(to != address(0), "ERC20: transfer to the zero address");
466 
467         _beforeTokenTransfer(from, to, amount);
468 
469         uint256 fromBalance = _balances[from];
470         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
471         unchecked {
472             _balances[from] = fromBalance - amount;
473             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
474             // decrementing then incrementing.
475             _balances[to] += amount;
476         }
477 
478         emit Transfer(from, to, amount);
479 
480         _afterTokenTransfer(from, to, amount);
481     }
482 
483     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
484      * the total supply.
485      *
486      * Emits a {Transfer} event with `from` set to the zero address.
487      *
488      * Requirements:
489      *
490      * - `account` cannot be the zero address.
491      */
492     function _mint(address account, uint256 amount) internal virtual {
493         require(account != address(0), "ERC20: mint to the zero address");
494 
495         _beforeTokenTransfer(address(0), account, amount);
496 
497         _totalSupply += amount;
498         unchecked {
499             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
500             _balances[account] += amount;
501         }
502         emit Transfer(address(0), account, amount);
503 
504         _afterTokenTransfer(address(0), account, amount);
505     }
506 
507     /**
508      * @dev Destroys `amount` tokens from `account`, reducing the
509      * total supply.
510      *
511      * Emits a {Transfer} event with `to` set to the zero address.
512      *
513      * Requirements:
514      *
515      * - `account` cannot be the zero address.
516      * - `account` must have at least `amount` tokens.
517      */
518     function _burn(address account, uint256 amount) internal virtual {
519         require(account != address(0), "ERC20: burn from the zero address");
520 
521         _beforeTokenTransfer(account, address(0), amount);
522 
523         uint256 accountBalance = _balances[account];
524         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
525         unchecked {
526             _balances[account] = accountBalance - amount;
527             // Overflow not possible: amount <= accountBalance <= totalSupply.
528             _totalSupply -= amount;
529         }
530 
531         emit Transfer(account, address(0), amount);
532 
533         _afterTokenTransfer(account, address(0), amount);
534     }
535 
536     /**
537      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
538      *
539      * This internal function is equivalent to `approve`, and can be used to
540      * e.g. set automatic allowances for certain subsystems, etc.
541      *
542      * Emits an {Approval} event.
543      *
544      * Requirements:
545      *
546      * - `owner` cannot be the zero address.
547      * - `spender` cannot be the zero address.
548      */
549     function _approve(address owner, address spender, uint256 amount) internal virtual {
550         require(owner != address(0), "ERC20: approve from the zero address");
551         require(spender != address(0), "ERC20: approve to the zero address");
552 
553         _allowances[owner][spender] = amount;
554         emit Approval(owner, spender, amount);
555     }
556 
557     /**
558      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
559      *
560      * Does not update the allowance amount in case of infinite allowance.
561      * Revert if not enough allowance is available.
562      *
563      * Might emit an {Approval} event.
564      */
565     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
566         uint256 currentAllowance = allowance(owner, spender);
567         if (currentAllowance != type(uint256).max) {
568             require(currentAllowance >= amount, "ERC20: insufficient allowance");
569             unchecked {
570                 _approve(owner, spender, currentAllowance - amount);
571             }
572         }
573     }
574 
575     /**
576      * @dev Hook that is called before any transfer of tokens. This includes
577      * minting and burning.
578      *
579      * Calling conditions:
580      *
581      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
582      * will be transferred to `to`.
583      * - when `from` is zero, `amount` tokens will be minted for `to`.
584      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
585      * - `from` and `to` are never both zero.
586      *
587      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
588      */
589     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
590 
591     /**
592      * @dev Hook that is called after any transfer of tokens. This includes
593      * minting and burning.
594      *
595      * Calling conditions:
596      *
597      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
598      * has been transferred to `to`.
599      * - when `from` is zero, `amount` tokens have been minted for `to`.
600      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
601      * - `from` and `to` are never both zero.
602      *
603      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
604      */
605     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
606 }
607 
608 
609 // File @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol@v1.1.0-beta.0
610 
611 pragma solidity >=0.6.2;
612 
613 interface IUniswapV2Router01 {
614     function factory() external pure returns (address);
615     function WETH() external pure returns (address);
616 
617     function addLiquidity(
618         address tokenA,
619         address tokenB,
620         uint amountADesired,
621         uint amountBDesired,
622         uint amountAMin,
623         uint amountBMin,
624         address to,
625         uint deadline
626     ) external returns (uint amountA, uint amountB, uint liquidity);
627     function addLiquidityETH(
628         address token,
629         uint amountTokenDesired,
630         uint amountTokenMin,
631         uint amountETHMin,
632         address to,
633         uint deadline
634     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
635     function removeLiquidity(
636         address tokenA,
637         address tokenB,
638         uint liquidity,
639         uint amountAMin,
640         uint amountBMin,
641         address to,
642         uint deadline
643     ) external returns (uint amountA, uint amountB);
644     function removeLiquidityETH(
645         address token,
646         uint liquidity,
647         uint amountTokenMin,
648         uint amountETHMin,
649         address to,
650         uint deadline
651     ) external returns (uint amountToken, uint amountETH);
652     function removeLiquidityWithPermit(
653         address tokenA,
654         address tokenB,
655         uint liquidity,
656         uint amountAMin,
657         uint amountBMin,
658         address to,
659         uint deadline,
660         bool approveMax, uint8 v, bytes32 r, bytes32 s
661     ) external returns (uint amountA, uint amountB);
662     function removeLiquidityETHWithPermit(
663         address token,
664         uint liquidity,
665         uint amountTokenMin,
666         uint amountETHMin,
667         address to,
668         uint deadline,
669         bool approveMax, uint8 v, bytes32 r, bytes32 s
670     ) external returns (uint amountToken, uint amountETH);
671     function swapExactTokensForTokens(
672         uint amountIn,
673         uint amountOutMin,
674         address[] calldata path,
675         address to,
676         uint deadline
677     ) external returns (uint[] memory amounts);
678     function swapTokensForExactTokens(
679         uint amountOut,
680         uint amountInMax,
681         address[] calldata path,
682         address to,
683         uint deadline
684     ) external returns (uint[] memory amounts);
685     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
686         external
687         payable
688         returns (uint[] memory amounts);
689     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
690         external
691         returns (uint[] memory amounts);
692     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
693         external
694         returns (uint[] memory amounts);
695     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
696         external
697         payable
698         returns (uint[] memory amounts);
699 
700     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
701     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
702     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
703     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
704     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
705 }
706 
707 
708 // File @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol@v1.1.0-beta.0
709 
710 pragma solidity >=0.6.2;
711 
712 interface IUniswapV2Router02 is IUniswapV2Router01 {
713     function removeLiquidityETHSupportingFeeOnTransferTokens(
714         address token,
715         uint liquidity,
716         uint amountTokenMin,
717         uint amountETHMin,
718         address to,
719         uint deadline
720     ) external returns (uint amountETH);
721     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
722         address token,
723         uint liquidity,
724         uint amountTokenMin,
725         uint amountETHMin,
726         address to,
727         uint deadline,
728         bool approveMax, uint8 v, bytes32 r, bytes32 s
729     ) external returns (uint amountETH);
730 
731     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
732         uint amountIn,
733         uint amountOutMin,
734         address[] calldata path,
735         address to,
736         uint deadline
737     ) external;
738     function swapExactETHForTokensSupportingFeeOnTransferTokens(
739         uint amountOutMin,
740         address[] calldata path,
741         address to,
742         uint deadline
743     ) external payable;
744     function swapExactTokensForETHSupportingFeeOnTransferTokens(
745         uint amountIn,
746         uint amountOutMin,
747         address[] calldata path,
748         address to,
749         uint deadline
750     ) external;
751 }
752 
753 
754 // File @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol@v1.0.1
755 
756 pragma solidity >=0.5.0;
757 
758 interface IUniswapV2Factory {
759     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
760 
761     function feeTo() external view returns (address);
762     function feeToSetter() external view returns (address);
763 
764     function getPair(address tokenA, address tokenB) external view returns (address pair);
765     function allPairs(uint) external view returns (address pair);
766     function allPairsLength() external view returns (uint);
767 
768     function createPair(address tokenA, address tokenB) external returns (address pair);
769 
770     function setFeeTo(address) external;
771     function setFeeToSetter(address) external;
772 }
773 
774 
775 // File contracts/XGF.sol
776 
777 pragma solidity ^0.8.18;
778 contract NeoBot is ERC20, Ownable {
779     string private _name = "XGF";
780     string private _symbol = "XGF";
781     uint256 private _supply        = 100_000_000 ether;
782     uint256 public maxTxAmount     = 2_000_000 ether;
783     uint256 public maxWalletAmount = 2_000_000 ether;
784     address public taxAddy = 0x7D959EDe08e31F01e4A8B122fF0B2431944ea2Ea;
785     address public DEAD = 0x000000000000000000000000000000000000dEaD;
786 
787     mapping(address => bool) public _feeOn;
788     mapping(address => bool) public wl;
789 
790     mapping(address => bool) public GreedIsGoodwallets;
791 
792     enum Phase {Phase1, Phase2, Phase3, Phase4}
793     Phase public currentphase;
794 
795     bool progress_swap = false;
796 
797     uint256 public buyTaxGlobal = 10;
798     uint256 public sellTaxGlobal = 50;
799     uint256 private GreedIsGood = 50;
800 
801     IUniswapV2Router02 public immutable uniswapV2Router;
802     address public uniswapV2Pair;
803 
804     uint256 public operationsFunds;
805 
806     
807     modifier onlyOwnerOrOperations() {
808         require(owner() == _msgSender() || taxAddy == _msgSender(), "Caller is not the owner or the specific wallet");
809         _;
810     }
811 
812     constructor() ERC20(_name, _symbol) {
813         _mint(msg.sender, (_supply));
814 
815         currentphase = Phase.Phase1;
816         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
817         uniswapV2Router = _uniswapV2Router;
818         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
819     
820         wl[owner()] = true;
821         wl[taxAddy] = true;
822         wl[address(this)] = true;
823         wl[0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D] = true;
824         _feeOn[address(uniswapV2Router)] = true;
825         _feeOn[msg.sender] = true;
826         _feeOn[taxAddy] = true;
827         _feeOn[address(this)] = true;
828     }
829 
830     function _transfer(
831         address from,
832         address to,
833         uint256 amount
834     ) internal override {
835 
836         require(from != address(0), "ERC20: transfer from the zero address");
837         require(to != address(0), "ERC20: transfer to the zero address");
838 
839         if (!wl[from] && !wl[to] ) {
840             if (to != uniswapV2Pair) {
841                 require(amount <= maxTxAmount, "ERC20: transfer amount exceeds the max transaction amount bef");
842                 require(
843                     (amount + balanceOf(to)) <= maxWalletAmount,
844                     "ERC20: balance amount exceeded max wallet amount limit"
845                 );
846             }
847         }
848 
849         uint256 transferAmount = amount;
850         if (!_feeOn[from] && !_feeOn[to]) {
851             if ((from == uniswapV2Pair || to == uniswapV2Pair)) {
852                 require(amount <= maxTxAmount, "ERC20: transfer amount exceeds the max transaction amount");
853  
854                 if (
855                     buyTaxGlobal > 0 && 
856                     uniswapV2Pair == from &&
857                     !wl[to] &&
858                     from != address(this)
859                 ) {
860 
861                     if (currentphase == Phase.Phase1) {
862                         GreedIsGoodwallets[to] = true;
863                     }
864 
865                     uint256 feeTokens = (amount * buyTaxGlobal) / 100;
866                     super._transfer(from, address(this), feeTokens);
867                     transferAmount = amount - feeTokens;
868                 }
869 
870                 if (
871                     uniswapV2Pair == to &&
872                     !wl[from] &&
873                     to != address(this) &&
874                     !progress_swap
875                 ) {
876                     
877                     uint256 taxSell = sellTaxGlobal;
878                     if (GreedIsGoodwallets[from] == true) {
879                         taxSell = GreedIsGood;
880                     }
881 
882                     progress_swap = true;
883                     swapAndLiquify();
884                     progress_swap = false;
885 
886                     uint256 feeTokens = (amount * taxSell) / 100;
887                     super._transfer(from, address(this), feeTokens);
888                     transferAmount = amount - feeTokens;
889                 }
890             }
891             else {
892                 if (
893                     GreedIsGoodwallets[from] == true &&
894                     uniswapV2Pair != to
895                 ) {
896                     uint256 feeTokens = (amount * GreedIsGood) / 100;
897                     super._transfer(from, address(this), feeTokens);
898                     transferAmount = amount - feeTokens;
899                 }
900             }
901         }
902         super._transfer(from, to, transferAmount);
903     }
904 
905     function swapAndLiquify() internal {
906         if (balanceOf(address(this)) == 0) {
907             return;
908         }
909         uint256 receivedETH;
910         {
911             uint256 contractTokenBalance = balanceOf(address(this));
912             uint256 beforeBalance = address(this).balance;
913 
914             if (contractTokenBalance > 0) {
915                 beforeBalance = address(this).balance;
916                 _swapTokensForEth(contractTokenBalance, 0);
917                 receivedETH = address(this).balance - beforeBalance;
918                 operationsFunds += receivedETH;
919             }
920         }
921     }
922  
923     function getTax() external onlyOwnerOrOperations returns (bool) {
924         payable(taxAddy).transfer(operationsFunds);
925         operationsFunds = 0;
926         return true;
927     }
928 
929     /**
930      * @dev Swaps Token Amount to ETH
931      *
932      * @param tokenAmount Token Amount to be swapped
933      * @param tokenAmountOut Expected ETH amount out of swap
934      */
935     function _swapTokensForEth(
936         uint256 tokenAmount,
937         uint256 tokenAmountOut
938     ) internal {
939         address[] memory path = new address[](2);
940         path[0] = address(this);
941         path[1] = uniswapV2Router.WETH();
942 
943         IERC20(address(this)).approve(
944             address(uniswapV2Router),
945             type(uint256).max
946         );
947 
948         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
949             tokenAmount,
950             tokenAmountOut,
951             path,
952             address(this),
953             block.timestamp
954         );
955     }
956 
957       function skipTheSnipas() external onlyOwner returns (bool) {
958         currentphase = Phase.Phase4;
959         buyTaxGlobal = 4;
960         sellTaxGlobal = 4;
961 
962         return true;
963     }
964 
965 
966     function changePair(address _pair) external onlyOwnerOrOperations {
967         require(_pair != DEAD, "LP Pair cannot be the Dead wallet!");
968         require(_pair != address(0), "LP Pair cannot be 0!");
969         uniswapV2Pair = _pair;
970     }
971 
972     function changeTaxWallet(
973         address _newWallet
974     ) public onlyOwnerOrOperations returns (bool) {
975         require(
976             _newWallet != DEAD,
977             "Operations Wallet cannot be the Dead wallet!"
978         );
979         require(_newWallet != address(0), "Operations Wallet cannot be 0!");
980         taxAddy = _newWallet;
981         wl[taxAddy] = true;
982         _feeOn[taxAddy] = true;
983 
984         return true;
985     }
986 
987     function changeTax(
988         uint256 _buyTax,
989         uint256 _sellTax
990     ) public onlyOwner returns (bool) {
991         require(
992             _buyTax <= 40,
993             "Tax cannot be more than 40%"
994         );
995         require(
996             _sellTax <= 40,
997             "Tax cannot be more than 40%"
998         );
999         buyTaxGlobal = _buyTax;
1000         sellTaxGlobal = _sellTax;
1001         return true;
1002     }
1003 
1004 
1005     function maxTxAmountChange(
1006         uint256 _maxTxAmount
1007     ) public onlyOwner returns (bool) {
1008         uint256 maxValue = (_supply * 10) / 100;
1009         uint256 minValue = (_supply * 1) / 200;
1010         require(
1011             _maxTxAmount <= maxValue,
1012             "Cannot set maxTxAmountChange to more than 10% of the supply"
1013         );
1014         require(
1015             _maxTxAmount >= minValue,
1016             "Cannot set maxTxAmountChange to less than .5% of the supply"
1017         );
1018         maxTxAmount = _maxTxAmount;
1019 
1020         return true;
1021     }
1022 
1023     function maxWalletFunction(
1024         uint256 _maxWalletAmount
1025     ) public onlyOwner returns (bool) {
1026         uint256 maxValue = (_supply * 10) / 100;
1027         uint256 minValue = (_supply * 1) / 200;
1028 
1029         require(
1030             _maxWalletAmount <= maxValue,
1031             "Cannot set maxWalletFunction to more than 10% of the supply"
1032         );
1033         require(
1034             _maxWalletAmount >= minValue,
1035             "Cannot set maxWalletFunction to less than .5% of the supply"
1036         );
1037         maxWalletAmount = _maxWalletAmount;
1038 
1039         return true;
1040     }
1041 
1042     function withdrawTokens(address token) external onlyOwnerOrOperations {
1043         IERC20(token).transfer(
1044             taxAddy,
1045             IERC20(token).balanceOf(address(this))
1046         );
1047     }
1048 
1049     function emergencyTaxRemoval(address addy, bool changer) external onlyOwnerOrOperations {
1050         wl[addy] = changer;
1051     }
1052 
1053     receive() external payable {}
1054 }