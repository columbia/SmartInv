1 /***
2 
3 Official website: https://www.crossbot.app/
4 Linktree: https://linktr.ee/crossbot
5 
6 💰 Early bird campaign. Check it out here: https://medium.com/@crossbot/earlybirdcampaign-ac921e130d9d
7 
8 ***/
9 
10 // SPDX-License-Identifier: UNLICENSED
11 // Sources flattened with hardhat v2.17.0 https://hardhat.org
12 
13 // File @openzeppelin/contracts/utils/Context.sol@v4.9.2
14 
15 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
16 
17 pragma solidity ^0.8.0;
18 
19 /**
20  * @dev Provides information about the current execution context, including the
21  * sender of the transaction and its data. While these are generally available
22  * via msg.sender and msg.data, they should not be accessed in such a direct
23  * manner, since when dealing with meta-transactions the account sending and
24  * paying for execution may not be the actual sender (as far as an application
25  * is concerned).
26  *
27  * This contract is only required for intermediate, library-like contracts.
28  */
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes calldata) {
35         return msg.data;
36     }
37 }
38 
39 
40 // File @openzeppelin/contracts/access/Ownable.sol@v4.9.2
41 
42 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
43 
44 pragma solidity ^0.8.0;
45 
46 /**
47  * @dev Contract module which provides a basic access control mechanism, where
48  * there is an account (an owner) that can be granted exclusive access to
49  * specific functions.
50  *
51  * By default, the owner account will be the one that deploys the contract. This
52  * can later be changed with {transferOwnership}.
53  *
54  * This module is used through inheritance. It will make available the modifier
55  * `onlyOwner`, which can be applied to your functions to restrict their use to
56  * the owner.
57  */
58 abstract contract Ownable is Context {
59     address private _owner;
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     /**
64      * @dev Initializes the contract setting the deployer as the initial owner.
65      */
66     constructor() {
67         _transferOwnership(_msgSender());
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         _checkOwner();
75         _;
76     }
77 
78     /**
79      * @dev Returns the address of the current owner.
80      */
81     function owner() public view virtual returns (address) {
82         return _owner;
83     }
84 
85     /**
86      * @dev Throws if the sender is not the owner.
87      */
88     function _checkOwner() internal view virtual {
89         require(owner() == _msgSender(), "Ownable: caller is not the owner");
90     }
91 
92     /**
93      * @dev Leaves the contract without owner. It will not be possible to call
94      * `onlyOwner` functions. Can only be called by the current owner.
95      *
96      * NOTE: Renouncing ownership will leave the contract without an owner,
97      * thereby disabling any functionality that is only available to the owner.
98      */
99     function renounceOwnership() public virtual onlyOwner {
100         _transferOwnership(address(0));
101     }
102 
103     /**
104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
105      * Can only be called by the current owner.
106      */
107     function transferOwnership(address newOwner) public virtual onlyOwner {
108         require(newOwner != address(0), "Ownable: new owner is the zero address");
109         _transferOwnership(newOwner);
110     }
111 
112     /**
113      * @dev Transfers ownership of the contract to a new account (`newOwner`).
114      * Internal function without access restriction.
115      */
116     function _transferOwnership(address newOwner) internal virtual {
117         address oldOwner = _owner;
118         _owner = newOwner;
119         emit OwnershipTransferred(oldOwner, newOwner);
120     }
121 }
122 
123 
124 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.9.2
125 
126 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
127 
128 pragma solidity ^0.8.0;
129 
130 /**
131  * @dev Interface of the ERC20 standard as defined in the EIP.
132  */
133 interface IERC20 {
134     /**
135      * @dev Emitted when `value` tokens are moved from one account (`from`) to
136      * another (`to`).
137      *
138      * Note that `value` may be zero.
139      */
140     event Transfer(address indexed from, address indexed to, uint256 value);
141 
142     /**
143      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
144      * a call to {approve}. `value` is the new allowance.
145      */
146     event Approval(address indexed owner, address indexed spender, uint256 value);
147 
148     /**
149      * @dev Returns the amount of tokens in existence.
150      */
151     function totalSupply() external view returns (uint256);
152 
153     /**
154      * @dev Returns the amount of tokens owned by `account`.
155      */
156     function balanceOf(address account) external view returns (uint256);
157 
158     /**
159      * @dev Moves `amount` tokens from the caller's account to `to`.
160      *
161      * Returns a boolean value indicating whether the operation succeeded.
162      *
163      * Emits a {Transfer} event.
164      */
165     function transfer(address to, uint256 amount) external returns (bool);
166 
167     /**
168      * @dev Returns the remaining number of tokens that `spender` will be
169      * allowed to spend on behalf of `owner` through {transferFrom}. This is
170      * zero by default.
171      *
172      * This value changes when {approve} or {transferFrom} are called.
173      */
174     function allowance(address owner, address spender) external view returns (uint256);
175 
176     /**
177      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
178      *
179      * Returns a boolean value indicating whether the operation succeeded.
180      *
181      * IMPORTANT: Beware that changing an allowance with this method brings the risk
182      * that someone may use both the old and the new allowance by unfortunate
183      * transaction ordering. One possible solution to mitigate this race
184      * condition is to first reduce the spender's allowance to 0 and set the
185      * desired value afterwards:
186      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
187      *
188      * Emits an {Approval} event.
189      */
190     function approve(address spender, uint256 amount) external returns (bool);
191 
192     /**
193      * @dev Moves `amount` tokens from `from` to `to` using the
194      * allowance mechanism. `amount` is then deducted from the caller's
195      * allowance.
196      *
197      * Returns a boolean value indicating whether the operation succeeded.
198      *
199      * Emits a {Transfer} event.
200      */
201     function transferFrom(address from, address to, uint256 amount) external returns (bool);
202 }
203 
204 
205 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.9.2
206 
207 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
208 
209 pragma solidity ^0.8.0;
210 
211 /**
212  * @dev Interface for the optional metadata functions from the ERC20 standard.
213  *
214  * _Available since v4.1._
215  */
216 interface IERC20Metadata is IERC20 {
217     /**
218      * @dev Returns the name of the token.
219      */
220     function name() external view returns (string memory);
221 
222     /**
223      * @dev Returns the symbol of the token.
224      */
225     function symbol() external view returns (string memory);
226 
227     /**
228      * @dev Returns the decimals places of the token.
229      */
230     function decimals() external view returns (uint8);
231 }
232 
233 
234 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.9.2
235 
236 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
237 
238 pragma solidity ^0.8.0;
239 
240 
241 
242 /**
243  * @dev Implementation of the {IERC20} interface.
244  *
245  * This implementation is agnostic to the way tokens are created. This means
246  * that a supply mechanism has to be added in a derived contract using {_mint}.
247  * For a generic mechanism see {ERC20PresetMinterPauser}.
248  *
249  * TIP: For a detailed writeup see our guide
250  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
251  * to implement supply mechanisms].
252  *
253  * The default value of {decimals} is 18. To change this, you should override
254  * this function so it returns a different value.
255  *
256  * We have followed general OpenZeppelin Contracts guidelines: functions revert
257  * instead returning `false` on failure. This behavior is nonetheless
258  * conventional and does not conflict with the expectations of ERC20
259  * applications.
260  *
261  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
262  * This allows applications to reconstruct the allowance for all accounts just
263  * by listening to said events. Other implementations of the EIP may not emit
264  * these events, as it isn't required by the specification.
265  *
266  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
267  * functions have been added to mitigate the well-known issues around setting
268  * allowances. See {IERC20-approve}.
269  */
270 contract ERC20 is Context, IERC20, IERC20Metadata {
271     mapping(address => uint256) private _balances;
272 
273     mapping(address => mapping(address => uint256)) private _allowances;
274 
275     uint256 private _totalSupply;
276 
277     string private _name;
278     string private _symbol;
279 
280     /**
281      * @dev Sets the values for {name} and {symbol}.
282      *
283      * All two of these values are immutable: they can only be set once during
284      * construction.
285      */
286     constructor(string memory name_, string memory symbol_) {
287         _name = name_;
288         _symbol = symbol_;
289     }
290 
291     /**
292      * @dev Returns the name of the token.
293      */
294     function name() public view virtual override returns (string memory) {
295         return _name;
296     }
297 
298     /**
299      * @dev Returns the symbol of the token, usually a shorter version of the
300      * name.
301      */
302     function symbol() public view virtual override returns (string memory) {
303         return _symbol;
304     }
305 
306     /**
307      * @dev Returns the number of decimals used to get its user representation.
308      * For example, if `decimals` equals `2`, a balance of `505` tokens should
309      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
310      *
311      * Tokens usually opt for a value of 18, imitating the relationship between
312      * Ether and Wei. This is the default value returned by this function, unless
313      * it's overridden.
314      *
315      * NOTE: This information is only used for _display_ purposes: it in
316      * no way affects any of the arithmetic of the contract, including
317      * {IERC20-balanceOf} and {IERC20-transfer}.
318      */
319     function decimals() public view virtual override returns (uint8) {
320         return 18;
321     }
322 
323     /**
324      * @dev See {IERC20-totalSupply}.
325      */
326     function totalSupply() public view virtual override returns (uint256) {
327         return _totalSupply;
328     }
329 
330     /**
331      * @dev See {IERC20-balanceOf}.
332      */
333     function balanceOf(address account) public view virtual override returns (uint256) {
334         return _balances[account];
335     }
336 
337     /**
338      * @dev See {IERC20-transfer}.
339      *
340      * Requirements:
341      *
342      * - `to` cannot be the zero address.
343      * - the caller must have a balance of at least `amount`.
344      */
345     function transfer(address to, uint256 amount) public virtual override returns (bool) {
346         address owner = _msgSender();
347         _transfer(owner, to, amount);
348         return true;
349     }
350 
351     /**
352      * @dev See {IERC20-allowance}.
353      */
354     function allowance(address owner, address spender) public view virtual override returns (uint256) {
355         return _allowances[owner][spender];
356     }
357 
358     /**
359      * @dev See {IERC20-approve}.
360      *
361      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
362      * `transferFrom`. This is semantically equivalent to an infinite approval.
363      *
364      * Requirements:
365      *
366      * - `spender` cannot be the zero address.
367      */
368     function approve(address spender, uint256 amount) public virtual override returns (bool) {
369         address owner = _msgSender();
370         _approve(owner, spender, amount);
371         return true;
372     }
373 
374     /**
375      * @dev See {IERC20-transferFrom}.
376      *
377      * Emits an {Approval} event indicating the updated allowance. This is not
378      * required by the EIP. See the note at the beginning of {ERC20}.
379      *
380      * NOTE: Does not update the allowance if the current allowance
381      * is the maximum `uint256`.
382      *
383      * Requirements:
384      *
385      * - `from` and `to` cannot be the zero address.
386      * - `from` must have a balance of at least `amount`.
387      * - the caller must have allowance for ``from``'s tokens of at least
388      * `amount`.
389      */
390     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
391         address spender = _msgSender();
392         _spendAllowance(from, spender, amount);
393         _transfer(from, to, amount);
394         return true;
395     }
396 
397     /**
398      * @dev Atomically increases the allowance granted to `spender` by the caller.
399      *
400      * This is an alternative to {approve} that can be used as a mitigation for
401      * problems described in {IERC20-approve}.
402      *
403      * Emits an {Approval} event indicating the updated allowance.
404      *
405      * Requirements:
406      *
407      * - `spender` cannot be the zero address.
408      */
409     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
410         address owner = _msgSender();
411         _approve(owner, spender, allowance(owner, spender) + addedValue);
412         return true;
413     }
414 
415     /**
416      * @dev Atomically decreases the allowance granted to `spender` by the caller.
417      *
418      * This is an alternative to {approve} that can be used as a mitigation for
419      * problems described in {IERC20-approve}.
420      *
421      * Emits an {Approval} event indicating the updated allowance.
422      *
423      * Requirements:
424      *
425      * - `spender` cannot be the zero address.
426      * - `spender` must have allowance for the caller of at least
427      * `subtractedValue`.
428      */
429     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
430         address owner = _msgSender();
431         uint256 currentAllowance = allowance(owner, spender);
432         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
433         unchecked {
434             _approve(owner, spender, currentAllowance - subtractedValue);
435         }
436 
437         return true;
438     }
439 
440     /**
441      * @dev Moves `amount` of tokens from `from` to `to`.
442      *
443      * This internal function is equivalent to {transfer}, and can be used to
444      * e.g. implement automatic token fees, slashing mechanisms, etc.
445      *
446      * Emits a {Transfer} event.
447      *
448      * Requirements:
449      *
450      * - `from` cannot be the zero address.
451      * - `to` cannot be the zero address.
452      * - `from` must have a balance of at least `amount`.
453      */
454     function _transfer(address from, address to, uint256 amount) internal virtual {
455         require(from != address(0), "ERC20: transfer from the zero address");
456         require(to != address(0), "ERC20: transfer to the zero address");
457 
458         _beforeTokenTransfer(from, to, amount);
459 
460         uint256 fromBalance = _balances[from];
461         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
462         unchecked {
463             _balances[from] = fromBalance - amount;
464             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
465             // decrementing then incrementing.
466             _balances[to] += amount;
467         }
468 
469         emit Transfer(from, to, amount);
470 
471         _afterTokenTransfer(from, to, amount);
472     }
473 
474     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
475      * the total supply.
476      *
477      * Emits a {Transfer} event with `from` set to the zero address.
478      *
479      * Requirements:
480      *
481      * - `account` cannot be the zero address.
482      */
483     function _mint(address account, uint256 amount) internal virtual {
484         require(account != address(0), "ERC20: mint to the zero address");
485 
486         _beforeTokenTransfer(address(0), account, amount);
487 
488         _totalSupply += amount;
489         unchecked {
490             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
491             _balances[account] += amount;
492         }
493         emit Transfer(address(0), account, amount);
494 
495         _afterTokenTransfer(address(0), account, amount);
496     }
497 
498     /**
499      * @dev Destroys `amount` tokens from `account`, reducing the
500      * total supply.
501      *
502      * Emits a {Transfer} event with `to` set to the zero address.
503      *
504      * Requirements:
505      *
506      * - `account` cannot be the zero address.
507      * - `account` must have at least `amount` tokens.
508      */
509     function _burn(address account, uint256 amount) internal virtual {
510         require(account != address(0), "ERC20: burn from the zero address");
511 
512         _beforeTokenTransfer(account, address(0), amount);
513 
514         uint256 accountBalance = _balances[account];
515         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
516         unchecked {
517             _balances[account] = accountBalance - amount;
518             // Overflow not possible: amount <= accountBalance <= totalSupply.
519             _totalSupply -= amount;
520         }
521 
522         emit Transfer(account, address(0), amount);
523 
524         _afterTokenTransfer(account, address(0), amount);
525     }
526 
527     /**
528      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
529      *
530      * This internal function is equivalent to `approve`, and can be used to
531      * e.g. set automatic allowances for certain subsystems, etc.
532      *
533      * Emits an {Approval} event.
534      *
535      * Requirements:
536      *
537      * - `owner` cannot be the zero address.
538      * - `spender` cannot be the zero address.
539      */
540     function _approve(address owner, address spender, uint256 amount) internal virtual {
541         require(owner != address(0), "ERC20: approve from the zero address");
542         require(spender != address(0), "ERC20: approve to the zero address");
543 
544         _allowances[owner][spender] = amount;
545         emit Approval(owner, spender, amount);
546     }
547 
548     /**
549      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
550      *
551      * Does not update the allowance amount in case of infinite allowance.
552      * Revert if not enough allowance is available.
553      *
554      * Might emit an {Approval} event.
555      */
556     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
557         uint256 currentAllowance = allowance(owner, spender);
558         if (currentAllowance != type(uint256).max) {
559             require(currentAllowance >= amount, "ERC20: insufficient allowance");
560             unchecked {
561                 _approve(owner, spender, currentAllowance - amount);
562             }
563         }
564     }
565 
566     /**
567      * @dev Hook that is called before any transfer of tokens. This includes
568      * minting and burning.
569      *
570      * Calling conditions:
571      *
572      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
573      * will be transferred to `to`.
574      * - when `from` is zero, `amount` tokens will be minted for `to`.
575      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
576      * - `from` and `to` are never both zero.
577      *
578      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
579      */
580     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
581 
582     /**
583      * @dev Hook that is called after any transfer of tokens. This includes
584      * minting and burning.
585      *
586      * Calling conditions:
587      *
588      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
589      * has been transferred to `to`.
590      * - when `from` is zero, `amount` tokens have been minted for `to`.
591      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
592      * - `from` and `to` are never both zero.
593      *
594      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
595      */
596     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
597 }
598 
599 
600 // File @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol@v1.1.0-beta.0
601 
602 pragma solidity >=0.6.2;
603 
604 interface IUniswapV2Router01 {
605     function factory() external pure returns (address);
606     function WETH() external pure returns (address);
607 
608     function addLiquidity(
609         address tokenA,
610         address tokenB,
611         uint amountADesired,
612         uint amountBDesired,
613         uint amountAMin,
614         uint amountBMin,
615         address to,
616         uint deadline
617     ) external returns (uint amountA, uint amountB, uint liquidity);
618     function addLiquidityETH(
619         address token,
620         uint amountTokenDesired,
621         uint amountTokenMin,
622         uint amountETHMin,
623         address to,
624         uint deadline
625     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
626     function removeLiquidity(
627         address tokenA,
628         address tokenB,
629         uint liquidity,
630         uint amountAMin,
631         uint amountBMin,
632         address to,
633         uint deadline
634     ) external returns (uint amountA, uint amountB);
635     function removeLiquidityETH(
636         address token,
637         uint liquidity,
638         uint amountTokenMin,
639         uint amountETHMin,
640         address to,
641         uint deadline
642     ) external returns (uint amountToken, uint amountETH);
643     function removeLiquidityWithPermit(
644         address tokenA,
645         address tokenB,
646         uint liquidity,
647         uint amountAMin,
648         uint amountBMin,
649         address to,
650         uint deadline,
651         bool approveMax, uint8 v, bytes32 r, bytes32 s
652     ) external returns (uint amountA, uint amountB);
653     function removeLiquidityETHWithPermit(
654         address token,
655         uint liquidity,
656         uint amountTokenMin,
657         uint amountETHMin,
658         address to,
659         uint deadline,
660         bool approveMax, uint8 v, bytes32 r, bytes32 s
661     ) external returns (uint amountToken, uint amountETH);
662     function swapExactTokensForTokens(
663         uint amountIn,
664         uint amountOutMin,
665         address[] calldata path,
666         address to,
667         uint deadline
668     ) external returns (uint[] memory amounts);
669     function swapTokensForExactTokens(
670         uint amountOut,
671         uint amountInMax,
672         address[] calldata path,
673         address to,
674         uint deadline
675     ) external returns (uint[] memory amounts);
676     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
677         external
678         payable
679         returns (uint[] memory amounts);
680     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
681         external
682         returns (uint[] memory amounts);
683     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
684         external
685         returns (uint[] memory amounts);
686     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
687         external
688         payable
689         returns (uint[] memory amounts);
690 
691     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
692     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
693     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
694     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
695     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
696 }
697 
698 
699 // File @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol@v1.1.0-beta.0
700 
701 pragma solidity >=0.6.2;
702 
703 interface IUniswapV2Router02 is IUniswapV2Router01 {
704     function removeLiquidityETHSupportingFeeOnTransferTokens(
705         address token,
706         uint liquidity,
707         uint amountTokenMin,
708         uint amountETHMin,
709         address to,
710         uint deadline
711     ) external returns (uint amountETH);
712     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
713         address token,
714         uint liquidity,
715         uint amountTokenMin,
716         uint amountETHMin,
717         address to,
718         uint deadline,
719         bool approveMax, uint8 v, bytes32 r, bytes32 s
720     ) external returns (uint amountETH);
721 
722     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
723         uint amountIn,
724         uint amountOutMin,
725         address[] calldata path,
726         address to,
727         uint deadline
728     ) external;
729     function swapExactETHForTokensSupportingFeeOnTransferTokens(
730         uint amountOutMin,
731         address[] calldata path,
732         address to,
733         uint deadline
734     ) external payable;
735     function swapExactTokensForETHSupportingFeeOnTransferTokens(
736         uint amountIn,
737         uint amountOutMin,
738         address[] calldata path,
739         address to,
740         uint deadline
741     ) external;
742 }
743 
744 
745 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.9.2
746 
747 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)
748 
749 pragma solidity ^0.8.0;
750 
751 // CAUTION
752 // This version of SafeMath should only be used with Solidity 0.8 or later,
753 // because it relies on the compiler's built in overflow checks.
754 
755 /**
756  * @dev Wrappers over Solidity's arithmetic operations.
757  *
758  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
759  * now has built in overflow checking.
760  */
761 library SafeMath {
762     /**
763      * @dev Returns the addition of two unsigned integers, with an overflow flag.
764      *
765      * _Available since v3.4._
766      */
767     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
768         unchecked {
769             uint256 c = a + b;
770             if (c < a) return (false, 0);
771             return (true, c);
772         }
773     }
774 
775     /**
776      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
777      *
778      * _Available since v3.4._
779      */
780     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
781         unchecked {
782             if (b > a) return (false, 0);
783             return (true, a - b);
784         }
785     }
786 
787     /**
788      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
789      *
790      * _Available since v3.4._
791      */
792     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
793         unchecked {
794             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
795             // benefit is lost if 'b' is also tested.
796             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
797             if (a == 0) return (true, 0);
798             uint256 c = a * b;
799             if (c / a != b) return (false, 0);
800             return (true, c);
801         }
802     }
803 
804     /**
805      * @dev Returns the division of two unsigned integers, with a division by zero flag.
806      *
807      * _Available since v3.4._
808      */
809     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
810         unchecked {
811             if (b == 0) return (false, 0);
812             return (true, a / b);
813         }
814     }
815 
816     /**
817      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
818      *
819      * _Available since v3.4._
820      */
821     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
822         unchecked {
823             if (b == 0) return (false, 0);
824             return (true, a % b);
825         }
826     }
827 
828     /**
829      * @dev Returns the addition of two unsigned integers, reverting on
830      * overflow.
831      *
832      * Counterpart to Solidity's `+` operator.
833      *
834      * Requirements:
835      *
836      * - Addition cannot overflow.
837      */
838     function add(uint256 a, uint256 b) internal pure returns (uint256) {
839         return a + b;
840     }
841 
842     /**
843      * @dev Returns the subtraction of two unsigned integers, reverting on
844      * overflow (when the result is negative).
845      *
846      * Counterpart to Solidity's `-` operator.
847      *
848      * Requirements:
849      *
850      * - Subtraction cannot overflow.
851      */
852     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
853         return a - b;
854     }
855 
856     /**
857      * @dev Returns the multiplication of two unsigned integers, reverting on
858      * overflow.
859      *
860      * Counterpart to Solidity's `*` operator.
861      *
862      * Requirements:
863      *
864      * - Multiplication cannot overflow.
865      */
866     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
867         return a * b;
868     }
869 
870     /**
871      * @dev Returns the integer division of two unsigned integers, reverting on
872      * division by zero. The result is rounded towards zero.
873      *
874      * Counterpart to Solidity's `/` operator.
875      *
876      * Requirements:
877      *
878      * - The divisor cannot be zero.
879      */
880     function div(uint256 a, uint256 b) internal pure returns (uint256) {
881         return a / b;
882     }
883 
884     /**
885      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
886      * reverting when dividing by zero.
887      *
888      * Counterpart to Solidity's `%` operator. This function uses a `revert`
889      * opcode (which leaves remaining gas untouched) while Solidity uses an
890      * invalid opcode to revert (consuming all remaining gas).
891      *
892      * Requirements:
893      *
894      * - The divisor cannot be zero.
895      */
896     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
897         return a % b;
898     }
899 
900     /**
901      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
902      * overflow (when the result is negative).
903      *
904      * CAUTION: This function is deprecated because it requires allocating memory for the error
905      * message unnecessarily. For custom revert reasons use {trySub}.
906      *
907      * Counterpart to Solidity's `-` operator.
908      *
909      * Requirements:
910      *
911      * - Subtraction cannot overflow.
912      */
913     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
914         unchecked {
915             require(b <= a, errorMessage);
916             return a - b;
917         }
918     }
919 
920     /**
921      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
922      * division by zero. The result is rounded towards zero.
923      *
924      * Counterpart to Solidity's `/` operator. Note: this function uses a
925      * `revert` opcode (which leaves remaining gas untouched) while Solidity
926      * uses an invalid opcode to revert (consuming all remaining gas).
927      *
928      * Requirements:
929      *
930      * - The divisor cannot be zero.
931      */
932     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
933         unchecked {
934             require(b > 0, errorMessage);
935             return a / b;
936         }
937     }
938 
939     /**
940      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
941      * reverting with custom message when dividing by zero.
942      *
943      * CAUTION: This function is deprecated because it requires allocating memory for the error
944      * message unnecessarily. For custom revert reasons use {tryMod}.
945      *
946      * Counterpart to Solidity's `%` operator. This function uses a `revert`
947      * opcode (which leaves remaining gas untouched) while Solidity uses an
948      * invalid opcode to revert (consuming all remaining gas).
949      *
950      * Requirements:
951      *
952      * - The divisor cannot be zero.
953      */
954     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
955         unchecked {
956             require(b > 0, errorMessage);
957             return a % b;
958         }
959     }
960 }
961 
962 
963 // File @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol@v1.0.1
964 
965 pragma solidity >=0.5.0;
966 
967 interface IUniswapV2Factory {
968     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
969 
970     function feeTo() external view returns (address);
971     function feeToSetter() external view returns (address);
972 
973     function getPair(address tokenA, address tokenB) external view returns (address pair);
974     function allPairs(uint) external view returns (address pair);
975     function allPairsLength() external view returns (uint);
976 
977     function createPair(address tokenA, address tokenB) external returns (address pair);
978 
979     function setFeeTo(address) external;
980     function setFeeToSetter(address) external;
981 }
982 
983 
984 // File contracts/CBOT.sol
985 
986 
987 pragma solidity =0.8.19;
988 
989 
990 
991 
992 
993 contract CBOT is ERC20, Ownable {
994     using SafeMath for uint256;
995 
996     IUniswapV2Router02 public immutable uniswapV2Router;
997     address public immutable uniswapV2Pair;
998     address public constant deadAddress = address(0xdead);
999 
1000     bool private swapping;
1001 
1002     address public administrator;
1003     address public revShareWallet;
1004     address public teamWallet;
1005     address public liquidityWallet;
1006 
1007     uint256 public maxTransactionAmount;
1008     uint256 public swapTokensAtAmount;
1009     uint256 public maxWallet;
1010 
1011     bool public limitsInEffect = true;
1012     bool public tradingActive = false;
1013     bool public swapEnabled = false;
1014 
1015     uint256 public buyTotalFees;
1016     uint256 public buyRevShareFee;
1017     uint256 public buyLiquidityFee;
1018     uint256 public buyTeamFee;
1019 
1020     uint256 public sellTotalFees;
1021     uint256 public sellRevShareFee;
1022     uint256 public sellLiquidityFee;
1023     uint256 public sellTeamFee;
1024 
1025     uint256 public tokensForRevShare;
1026     uint256 public tokensForLiquidity;
1027     uint256 public tokensForTeam;
1028 
1029     // exclude from fees and max transaction amount
1030     mapping(address => bool) private _isExcludedFromFees;
1031     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1032 
1033     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1034     // could be subject to a maximum transfer amount
1035     mapping(address => bool) public automatedMarketMakerPairs;
1036 
1037     bool public preMigrationPhase = true;
1038     mapping(address => bool) public preMigrationTransferrable;
1039 
1040     event UpdateUniswapV2Router(
1041         address indexed newAddress,
1042         address indexed oldAddress
1043     );
1044 
1045     event ExcludeFromFees(address indexed account, bool isExcluded);
1046 
1047     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1048 
1049     event revShareWalletUpdated(
1050         address indexed newWallet,
1051         address indexed oldWallet
1052     );
1053 
1054     event teamWalletUpdated(
1055         address indexed newWallet,
1056         address indexed oldWallet
1057     );
1058 
1059     event liquidityWalletUpdated(
1060         address indexed newWallet,
1061         address indexed oldWallet
1062     );
1063 
1064     event administratorUpdated(
1065         address indexed newAdministrator,
1066         address indexed oldAdministrator
1067     );
1068 
1069     event SwapAndLiquify(
1070         uint256 tokensSwapped,
1071         uint256 ethReceived,
1072         uint256 tokensIntoLiquidity
1073     );
1074 
1075     modifier onlyAdmin() {
1076         require(administrator == _msgSender(), 'Only admin');
1077         _;
1078     }
1079 
1080     constructor(
1081         address _revShareWallet,
1082         address _liquidityWallet
1083     ) ERC20('CrossBot Token', 'CBOT') {
1084         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1085             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1086         );
1087 
1088         administrator = owner();
1089 
1090         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1091         uniswapV2Router = _uniswapV2Router;
1092 
1093         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1094             .createPair(address(this), _uniswapV2Router.WETH());
1095         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1096         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1097 
1098         uint256 _buyRevShareFee = 1;
1099         uint256 _buyLiquidityFee = 2;
1100         uint256 _buyTeamFee = 2;
1101 
1102         uint256 _sellRevShareFee = 1;
1103         uint256 _sellLiquidityFee = 2;
1104         uint256 _sellTeamFee = 2;
1105 
1106         uint256 totalSupply = 1_000_000 * 1e18;
1107 
1108         maxTransactionAmount = 30_000 * 1e18; // 3%
1109         maxWallet = 30_000 * 1e18; // 3%
1110         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1%
1111 
1112         buyRevShareFee = _buyRevShareFee;
1113         buyLiquidityFee = _buyLiquidityFee;
1114         buyTeamFee = _buyTeamFee;
1115         buyTotalFees = buyRevShareFee + buyLiquidityFee + buyTeamFee;
1116 
1117         sellRevShareFee = _sellRevShareFee;
1118         sellLiquidityFee = _sellLiquidityFee;
1119         sellTeamFee = _sellTeamFee;
1120         sellTotalFees = sellRevShareFee + sellLiquidityFee + sellTeamFee;
1121 
1122         revShareWallet = _revShareWallet;
1123         liquidityWallet = _liquidityWallet;
1124         teamWallet = owner(); // set as team wallet
1125 
1126         // exclude from paying fees or having max transaction amount
1127         excludeFromFees(owner(), true);
1128         excludeFromFees(address(this), true);
1129         excludeFromFees(address(0xdead), true);
1130 
1131         excludeFromMaxTransaction(owner(), true);
1132         excludeFromMaxTransaction(address(this), true);
1133         excludeFromMaxTransaction(address(0xdead), true);
1134 
1135         preMigrationTransferrable[owner()] = true;
1136 
1137         /*
1138             _mint is an internal function in ERC20.sol that is only called here,
1139             and CANNOT be called ever again
1140         */
1141         _mint(msg.sender, totalSupply);
1142     }
1143 
1144     receive() external payable {}
1145 
1146     // once enabled, can never be turned off
1147     function enableTrading() external onlyAdmin {
1148         tradingActive = true;
1149         swapEnabled = true;
1150         preMigrationPhase = false;
1151     }
1152 
1153     // remove limits after token is stable
1154     function removeLimits() external onlyAdmin returns (bool) {
1155         limitsInEffect = false;
1156         return true;
1157     }
1158 
1159     // change the minimum amount of tokens to sell from fees
1160     function updateSwapTokensAtAmount(
1161         uint256 newAmount
1162     ) external onlyAdmin returns (bool) {
1163         require(
1164             newAmount >= (totalSupply() * 1) / 100000,
1165             'Swap amount cannot be lower than 0.001% total supply.'
1166         );
1167         require(
1168             newAmount <= (totalSupply() * 5) / 1000,
1169             'Swap amount cannot be higher than 0.5% total supply.'
1170         );
1171         swapTokensAtAmount = newAmount;
1172         return true;
1173     }
1174 
1175     function updateMaxTxnAmount(uint256 newNum) external onlyAdmin {
1176         require(
1177             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1178             'Cannot set maxTransactionAmount lower than 0.5%'
1179         );
1180         maxTransactionAmount = newNum * (10 ** 18);
1181     }
1182 
1183     function updateMaxWalletAmount(uint256 newNum) external onlyAdmin {
1184         require(
1185             newNum >= ((totalSupply() * 10) / 1000) / 1e18,
1186             'Cannot set maxWallet lower than 1.0%'
1187         );
1188         maxWallet = newNum * (10 ** 18);
1189     }
1190 
1191     function excludeFromMaxTransaction(
1192         address updAds,
1193         bool isEx
1194     ) public onlyAdmin {
1195         _isExcludedMaxTransactionAmount[updAds] = isEx;
1196     }
1197 
1198     // only use to disable contract sales if absolutely necessary (emergency use only)
1199     function updateSwapEnabled(bool enabled) external onlyAdmin {
1200         swapEnabled = enabled;
1201     }
1202 
1203     function updateBuyFees(
1204         uint256 _revShareFee,
1205         uint256 _liquidityFee,
1206         uint256 _teamFee
1207     ) external onlyAdmin {
1208         buyRevShareFee = _revShareFee;
1209         buyLiquidityFee = _liquidityFee;
1210         buyTeamFee = _teamFee;
1211         buyTotalFees = buyRevShareFee + buyLiquidityFee + buyTeamFee;
1212         require(buyTotalFees <= 5, 'Buy fees must be <= 5.');
1213     }
1214 
1215     function updateSellFees(
1216         uint256 _revShareFee,
1217         uint256 _liquidityFee,
1218         uint256 _teamFee
1219     ) external onlyAdmin {
1220         sellRevShareFee = _revShareFee;
1221         sellLiquidityFee = _liquidityFee;
1222         sellTeamFee = _teamFee;
1223         sellTotalFees = sellRevShareFee + sellLiquidityFee + sellTeamFee;
1224         require(sellTotalFees <= 5, 'Sell fees must be <= 5.');
1225     }
1226 
1227     function excludeFromFees(address account, bool excluded) public onlyAdmin {
1228         _isExcludedFromFees[account] = excluded;
1229         emit ExcludeFromFees(account, excluded);
1230     }
1231 
1232     function setAutomatedMarketMakerPair(
1233         address pair,
1234         bool value
1235     ) public onlyAdmin {
1236         require(
1237             pair != uniswapV2Pair,
1238             'The pair cannot be removed from automatedMarketMakerPairs'
1239         );
1240 
1241         _setAutomatedMarketMakerPair(pair, value);
1242     }
1243 
1244     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1245         automatedMarketMakerPairs[pair] = value;
1246 
1247         emit SetAutomatedMarketMakerPair(pair, value);
1248     }
1249 
1250     function updateRevShareWallet(
1251         address newRevShareWallet
1252     ) external onlyAdmin {
1253         emit revShareWalletUpdated(newRevShareWallet, revShareWallet);
1254         revShareWallet = newRevShareWallet;
1255     }
1256 
1257     function transferRevShareWallet(address newWallet) external {
1258         require(
1259             msg.sender == revShareWallet,
1260             'Only revShare wallet can transfer.'
1261         );
1262         emit revShareWalletUpdated(newWallet, revShareWallet);
1263         revShareWallet = newWallet;
1264     }
1265 
1266     function updateTeamWallet(address newWallet) external onlyAdmin {
1267         emit teamWalletUpdated(newWallet, teamWallet);
1268         teamWallet = newWallet;
1269     }
1270 
1271     function transferTeamWallet(address newWallet) external {
1272         require(msg.sender == teamWallet, 'Only team wallet can transfer.');
1273         emit teamWalletUpdated(newWallet, teamWallet);
1274         teamWallet = newWallet;
1275     }
1276 
1277     function updateLiquidityWallet(address newWallet) external onlyAdmin {
1278         emit liquidityWalletUpdated(newWallet, liquidityWallet);
1279         liquidityWallet = newWallet;
1280     }
1281 
1282     function transferLiquidityWallet(address newWallet) external {
1283         require(
1284             msg.sender == liquidityWallet,
1285             'Only liquidity wallet can transfer.'
1286         );
1287         emit liquidityWalletUpdated(newWallet, liquidityWallet);
1288         liquidityWallet = newWallet;
1289     }
1290 
1291     function setAdmin(address newAdmin) external onlyOwner {
1292         emit administratorUpdated(newAdmin, administrator);
1293         administrator = newAdmin;
1294     }
1295 
1296     function transferAdmin(address newAdmin) external onlyAdmin {
1297         emit administratorUpdated(newAdmin, administrator);
1298         administrator = newAdmin;
1299     }
1300 
1301     function renounceAdmin() external onlyAdmin {
1302         emit administratorUpdated(address(0), administrator);
1303         administrator = address(0);
1304     }
1305 
1306     function isExcludedFromFees(address account) public view returns (bool) {
1307         return _isExcludedFromFees[account];
1308     }
1309 
1310     function _transfer(
1311         address from,
1312         address to,
1313         uint256 amount
1314     ) internal override {
1315         require(from != address(0), 'ERC20: transfer from the zero address');
1316         require(to != address(0), 'ERC20: transfer to the zero address');
1317 
1318         if (preMigrationPhase) {
1319             require(
1320                 preMigrationTransferrable[from],
1321                 'Not authorized to transfer pre-migration.'
1322             );
1323         }
1324 
1325         if (amount == 0) {
1326             super._transfer(from, to, 0);
1327             return;
1328         }
1329 
1330         if (limitsInEffect) {
1331             if (
1332                 from != owner() &&
1333                 to != owner() &&
1334                 to != address(0) &&
1335                 to != address(0xdead) &&
1336                 !swapping
1337             ) {
1338                 if (!tradingActive) {
1339                     require(
1340                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1341                         'Trading is not active.'
1342                     );
1343                 }
1344 
1345                 //when buy
1346                 if (
1347                     automatedMarketMakerPairs[from] &&
1348                     !_isExcludedMaxTransactionAmount[to]
1349                 ) {
1350                     require(
1351                         amount <= maxTransactionAmount,
1352                         'Buy transfer amount exceeds the maxTransactionAmount.'
1353                     );
1354                     require(
1355                         amount + balanceOf(to) <= maxWallet,
1356                         'Max wallet exceeded'
1357                     );
1358                 }
1359                 //when sell
1360                 else if (
1361                     automatedMarketMakerPairs[to] &&
1362                     !_isExcludedMaxTransactionAmount[from]
1363                 ) {
1364                     require(
1365                         amount <= maxTransactionAmount,
1366                         'Sell transfer amount exceeds the maxTransactionAmount.'
1367                     );
1368                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1369                     require(
1370                         amount + balanceOf(to) <= maxWallet,
1371                         'Max wallet exceeded'
1372                     );
1373                 }
1374             }
1375         }
1376 
1377         uint256 contractTokenBalance = balanceOf(address(this));
1378 
1379         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1380 
1381         if (
1382             canSwap &&
1383             swapEnabled &&
1384             !swapping &&
1385             !automatedMarketMakerPairs[from] &&
1386             !_isExcludedFromFees[from] &&
1387             !_isExcludedFromFees[to]
1388         ) {
1389             swapping = true;
1390 
1391             swapBack();
1392 
1393             swapping = false;
1394         }
1395 
1396         bool takeFee = !swapping;
1397 
1398         // if any account belongs to _isExcludedFromFee account then remove the fee
1399         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1400             takeFee = false;
1401         }
1402 
1403         uint256 fees = 0;
1404         // only take fees on buys/sells, do not take on wallet transfers
1405         if (takeFee) {
1406             // on sell
1407             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1408                 fees = amount.mul(sellTotalFees).div(100);
1409                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1410                 tokensForTeam += (fees * sellTeamFee) / sellTotalFees;
1411                 tokensForRevShare += (fees * sellRevShareFee) / sellTotalFees;
1412             }
1413             // on buy
1414             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1415                 fees = amount.mul(buyTotalFees).div(100);
1416                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1417                 tokensForTeam += (fees * buyTeamFee) / buyTotalFees;
1418                 tokensForRevShare += (fees * buyRevShareFee) / buyTotalFees;
1419             }
1420 
1421             if (fees > 0) {
1422                 super._transfer(from, address(this), fees);
1423             }
1424 
1425             amount -= fees;
1426         }
1427 
1428         super._transfer(from, to, amount);
1429     }
1430 
1431     function swapTokensForEth(uint256 tokenAmount) private {
1432         // generate the uniswap pair path of token -> weth
1433         address[] memory path = new address[](2);
1434         path[0] = address(this);
1435         path[1] = uniswapV2Router.WETH();
1436 
1437         _approve(address(this), address(uniswapV2Router), tokenAmount);
1438 
1439         // make the swap
1440         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1441             tokenAmount,
1442             0, // accept any amount of ETH
1443             path,
1444             address(this),
1445             block.timestamp
1446         );
1447     }
1448 
1449     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1450         // approve token transfer to cover all possible scenarios
1451         _approve(address(this), address(uniswapV2Router), tokenAmount);
1452 
1453         // add the liquidity
1454         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1455             address(this),
1456             tokenAmount,
1457             0, // slippage is unavoidable
1458             0, // slippage is unavoidable
1459             liquidityWallet,
1460             block.timestamp
1461         );
1462     }
1463 
1464     function swapBack() private {
1465         uint256 contractBalance = balanceOf(address(this));
1466         uint256 totalTokensToSwap = tokensForLiquidity +
1467             tokensForRevShare +
1468             tokensForTeam;
1469         bool success;
1470 
1471         if (contractBalance == 0 || totalTokensToSwap == 0) {
1472             return;
1473         }
1474 
1475         if (contractBalance > swapTokensAtAmount * 20) {
1476             contractBalance = swapTokensAtAmount * 20;
1477         }
1478 
1479         // Halve the amount of liquidity tokens
1480         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1481             totalTokensToSwap /
1482             2;
1483         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1484 
1485         uint256 initialETHBalance = address(this).balance;
1486 
1487         swapTokensForEth(amountToSwapForETH);
1488 
1489         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1490 
1491         uint256 ethForRevShare = ethBalance.mul(tokensForRevShare).div(
1492             totalTokensToSwap - (tokensForLiquidity / 2)
1493         );
1494 
1495         uint256 ethForTeam = ethBalance.mul(tokensForTeam).div(
1496             totalTokensToSwap - (tokensForLiquidity / 2)
1497         );
1498 
1499         uint256 ethForLiquidity = ethBalance - ethForRevShare - ethForTeam;
1500 
1501         tokensForLiquidity = 0;
1502         tokensForRevShare = 0;
1503         tokensForTeam = 0;
1504 
1505         (success, ) = address(teamWallet).call{value: ethForTeam}('');
1506 
1507         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1508             addLiquidity(liquidityTokens, ethForLiquidity);
1509             emit SwapAndLiquify(
1510                 amountToSwapForETH,
1511                 ethForLiquidity,
1512                 tokensForLiquidity
1513             );
1514         }
1515 
1516         (success, ) = address(revShareWallet).call{
1517             value: address(this).balance
1518         }('');
1519     }
1520 
1521     function withdrawStuckToken(
1522         address _token,
1523         address _to
1524     ) external onlyAdmin {
1525         require(_token != address(0), '_token address cannot be 0');
1526         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1527         IERC20(_token).transfer(_to, _contractBalance);
1528     }
1529 
1530     function withdrawStuckEth(address toAddr) external onlyAdmin {
1531         (bool success, ) = toAddr.call{value: address(this).balance}('');
1532         require(success);
1533     }
1534 
1535     function setPreMigrationTransferable(
1536         address _addr,
1537         bool isAuthorized
1538     ) public onlyAdmin {
1539         preMigrationTransferrable[_addr] = isAuthorized;
1540         excludeFromFees(_addr, isAuthorized);
1541         excludeFromMaxTransaction(_addr, isAuthorized);
1542     }
1543 }