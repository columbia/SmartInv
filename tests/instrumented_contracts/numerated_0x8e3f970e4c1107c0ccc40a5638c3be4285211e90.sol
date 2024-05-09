1 // Sources flattened with hardhat v2.15.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.9.2
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v4.9.2
32 
33 
34 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         _checkOwner();
67         _;
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if the sender is not the owner.
79      */
80     function _checkOwner() internal view virtual {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82     }
83 
84     /**
85      * @dev Leaves the contract without owner. It will not be possible to call
86      * `onlyOwner` functions. Can only be called by the current owner.
87      *
88      * NOTE: Renouncing ownership will leave the contract without an owner,
89      * thereby disabling any functionality that is only available to the owner.
90      */
91     function renounceOwnership() public virtual onlyOwner {
92         _transferOwnership(address(0));
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Can only be called by the current owner.
98      */
99     function transferOwnership(address newOwner) public virtual onlyOwner {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         _transferOwnership(newOwner);
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Internal function without access restriction.
107      */
108     function _transferOwnership(address newOwner) internal virtual {
109         address oldOwner = _owner;
110         _owner = newOwner;
111         emit OwnershipTransferred(oldOwner, newOwner);
112     }
113 }
114 
115 
116 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.9.2
117 
118 
119 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev Interface of the ERC20 standard as defined in the EIP.
125  */
126 interface IERC20 {
127     /**
128      * @dev Emitted when `value` tokens are moved from one account (`from`) to
129      * another (`to`).
130      *
131      * Note that `value` may be zero.
132      */
133     event Transfer(address indexed from, address indexed to, uint256 value);
134 
135     /**
136      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
137      * a call to {approve}. `value` is the new allowance.
138      */
139     event Approval(address indexed owner, address indexed spender, uint256 value);
140 
141     /**
142      * @dev Returns the amount of tokens in existence.
143      */
144     function totalSupply() external view returns (uint256);
145 
146     /**
147      * @dev Returns the amount of tokens owned by `account`.
148      */
149     function balanceOf(address account) external view returns (uint256);
150 
151     /**
152      * @dev Moves `amount` tokens from the caller's account to `to`.
153      *
154      * Returns a boolean value indicating whether the operation succeeded.
155      *
156      * Emits a {Transfer} event.
157      */
158     function transfer(address to, uint256 amount) external returns (bool);
159 
160     /**
161      * @dev Returns the remaining number of tokens that `spender` will be
162      * allowed to spend on behalf of `owner` through {transferFrom}. This is
163      * zero by default.
164      *
165      * This value changes when {approve} or {transferFrom} are called.
166      */
167     function allowance(address owner, address spender) external view returns (uint256);
168 
169     /**
170      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
171      *
172      * Returns a boolean value indicating whether the operation succeeded.
173      *
174      * IMPORTANT: Beware that changing an allowance with this method brings the risk
175      * that someone may use both the old and the new allowance by unfortunate
176      * transaction ordering. One possible solution to mitigate this race
177      * condition is to first reduce the spender's allowance to 0 and set the
178      * desired value afterwards:
179      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180      *
181      * Emits an {Approval} event.
182      */
183     function approve(address spender, uint256 amount) external returns (bool);
184 
185     /**
186      * @dev Moves `amount` tokens from `from` to `to` using the
187      * allowance mechanism. `amount` is then deducted from the caller's
188      * allowance.
189      *
190      * Returns a boolean value indicating whether the operation succeeded.
191      *
192      * Emits a {Transfer} event.
193      */
194     function transferFrom(address from, address to, uint256 amount) external returns (bool);
195 }
196 
197 
198 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.9.2
199 
200 
201 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
202 
203 pragma solidity ^0.8.0;
204 
205 /**
206  * @dev Interface for the optional metadata functions from the ERC20 standard.
207  *
208  * _Available since v4.1._
209  */
210 interface IERC20Metadata is IERC20 {
211     /**
212      * @dev Returns the name of the token.
213      */
214     function name() external view returns (string memory);
215 
216     /**
217      * @dev Returns the symbol of the token.
218      */
219     function symbol() external view returns (string memory);
220 
221     /**
222      * @dev Returns the decimals places of the token.
223      */
224     function decimals() external view returns (uint8);
225 }
226 
227 
228 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.9.2
229 
230 
231 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
232 
233 pragma solidity ^0.8.0;
234 
235 
236 
237 /**
238  * @dev Implementation of the {IERC20} interface.
239  *
240  * This implementation is agnostic to the way tokens are created. This means
241  * that a supply mechanism has to be added in a derived contract using {_mint}.
242  * For a generic mechanism see {ERC20PresetMinterPauser}.
243  *
244  * TIP: For a detailed writeup see our guide
245  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
246  * to implement supply mechanisms].
247  *
248  * The default value of {decimals} is 18. To change this, you should override
249  * this function so it returns a different value.
250  *
251  * We have followed general OpenZeppelin Contracts guidelines: functions revert
252  * instead returning `false` on failure. This behavior is nonetheless
253  * conventional and does not conflict with the expectations of ERC20
254  * applications.
255  *
256  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
257  * This allows applications to reconstruct the allowance for all accounts just
258  * by listening to said events. Other implementations of the EIP may not emit
259  * these events, as it isn't required by the specification.
260  *
261  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
262  * functions have been added to mitigate the well-known issues around setting
263  * allowances. See {IERC20-approve}.
264  */
265 contract ERC20 is Context, IERC20, IERC20Metadata {
266     mapping(address => uint256) private _balances;
267 
268     mapping(address => mapping(address => uint256)) private _allowances;
269 
270     uint256 private _totalSupply;
271 
272     string private _name;
273     string private _symbol;
274 
275     /**
276      * @dev Sets the values for {name} and {symbol}.
277      *
278      * All two of these values are immutable: they can only be set once during
279      * construction.
280      */
281     constructor(string memory name_, string memory symbol_) {
282         _name = name_;
283         _symbol = symbol_;
284     }
285 
286     /**
287      * @dev Returns the name of the token.
288      */
289     function name() public view virtual override returns (string memory) {
290         return _name;
291     }
292 
293     /**
294      * @dev Returns the symbol of the token, usually a shorter version of the
295      * name.
296      */
297     function symbol() public view virtual override returns (string memory) {
298         return _symbol;
299     }
300 
301     /**
302      * @dev Returns the number of decimals used to get its user representation.
303      * For example, if `decimals` equals `2`, a balance of `505` tokens should
304      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
305      *
306      * Tokens usually opt for a value of 18, imitating the relationship between
307      * Ether and Wei. This is the default value returned by this function, unless
308      * it's overridden.
309      *
310      * NOTE: This information is only used for _display_ purposes: it in
311      * no way affects any of the arithmetic of the contract, including
312      * {IERC20-balanceOf} and {IERC20-transfer}.
313      */
314     function decimals() public view virtual override returns (uint8) {
315         return 18;
316     }
317 
318     /**
319      * @dev See {IERC20-totalSupply}.
320      */
321     function totalSupply() public view virtual override returns (uint256) {
322         return _totalSupply;
323     }
324 
325     /**
326      * @dev See {IERC20-balanceOf}.
327      */
328     function balanceOf(address account) public view virtual override returns (uint256) {
329         return _balances[account];
330     }
331 
332     /**
333      * @dev See {IERC20-transfer}.
334      *
335      * Requirements:
336      *
337      * - `to` cannot be the zero address.
338      * - the caller must have a balance of at least `amount`.
339      */
340     function transfer(address to, uint256 amount) public virtual override returns (bool) {
341         address owner = _msgSender();
342         _transfer(owner, to, amount);
343         return true;
344     }
345 
346     /**
347      * @dev See {IERC20-allowance}.
348      */
349     function allowance(address owner, address spender) public view virtual override returns (uint256) {
350         return _allowances[owner][spender];
351     }
352 
353     /**
354      * @dev See {IERC20-approve}.
355      *
356      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
357      * `transferFrom`. This is semantically equivalent to an infinite approval.
358      *
359      * Requirements:
360      *
361      * - `spender` cannot be the zero address.
362      */
363     function approve(address spender, uint256 amount) public virtual override returns (bool) {
364         address owner = _msgSender();
365         _approve(owner, spender, amount);
366         return true;
367     }
368 
369     /**
370      * @dev See {IERC20-transferFrom}.
371      *
372      * Emits an {Approval} event indicating the updated allowance. This is not
373      * required by the EIP. See the note at the beginning of {ERC20}.
374      *
375      * NOTE: Does not update the allowance if the current allowance
376      * is the maximum `uint256`.
377      *
378      * Requirements:
379      *
380      * - `from` and `to` cannot be the zero address.
381      * - `from` must have a balance of at least `amount`.
382      * - the caller must have allowance for ``from``'s tokens of at least
383      * `amount`.
384      */
385     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
386         address spender = _msgSender();
387         _spendAllowance(from, spender, amount);
388         _transfer(from, to, amount);
389         return true;
390     }
391 
392     /**
393      * @dev Atomically increases the allowance granted to `spender` by the caller.
394      *
395      * This is an alternative to {approve} that can be used as a mitigation for
396      * problems described in {IERC20-approve}.
397      *
398      * Emits an {Approval} event indicating the updated allowance.
399      *
400      * Requirements:
401      *
402      * - `spender` cannot be the zero address.
403      */
404     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
405         address owner = _msgSender();
406         _approve(owner, spender, allowance(owner, spender) + addedValue);
407         return true;
408     }
409 
410     /**
411      * @dev Atomically decreases the allowance granted to `spender` by the caller.
412      *
413      * This is an alternative to {approve} that can be used as a mitigation for
414      * problems described in {IERC20-approve}.
415      *
416      * Emits an {Approval} event indicating the updated allowance.
417      *
418      * Requirements:
419      *
420      * - `spender` cannot be the zero address.
421      * - `spender` must have allowance for the caller of at least
422      * `subtractedValue`.
423      */
424     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
425         address owner = _msgSender();
426         uint256 currentAllowance = allowance(owner, spender);
427         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
428         unchecked {
429             _approve(owner, spender, currentAllowance - subtractedValue);
430         }
431 
432         return true;
433     }
434 
435     /**
436      * @dev Moves `amount` of tokens from `from` to `to`.
437      *
438      * This internal function is equivalent to {transfer}, and can be used to
439      * e.g. implement automatic token fees, slashing mechanisms, etc.
440      *
441      * Emits a {Transfer} event.
442      *
443      * Requirements:
444      *
445      * - `from` cannot be the zero address.
446      * - `to` cannot be the zero address.
447      * - `from` must have a balance of at least `amount`.
448      */
449     function _transfer(address from, address to, uint256 amount) internal virtual {
450         require(from != address(0), "ERC20: transfer from the zero address");
451         require(to != address(0), "ERC20: transfer to the zero address");
452 
453         _beforeTokenTransfer(from, to, amount);
454 
455         uint256 fromBalance = _balances[from];
456         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
457         unchecked {
458             _balances[from] = fromBalance - amount;
459             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
460             // decrementing then incrementing.
461             _balances[to] += amount;
462         }
463 
464         emit Transfer(from, to, amount);
465 
466         _afterTokenTransfer(from, to, amount);
467     }
468 
469     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
470      * the total supply.
471      *
472      * Emits a {Transfer} event with `from` set to the zero address.
473      *
474      * Requirements:
475      *
476      * - `account` cannot be the zero address.
477      */
478     function _mint(address account, uint256 amount) internal virtual {
479         require(account != address(0), "ERC20: mint to the zero address");
480 
481         _beforeTokenTransfer(address(0), account, amount);
482 
483         _totalSupply += amount;
484         unchecked {
485             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
486             _balances[account] += amount;
487         }
488         emit Transfer(address(0), account, amount);
489 
490         _afterTokenTransfer(address(0), account, amount);
491     }
492 
493     /**
494      * @dev Destroys `amount` tokens from `account`, reducing the
495      * total supply.
496      *
497      * Emits a {Transfer} event with `to` set to the zero address.
498      *
499      * Requirements:
500      *
501      * - `account` cannot be the zero address.
502      * - `account` must have at least `amount` tokens.
503      */
504     function _burn(address account, uint256 amount) internal virtual {
505         require(account != address(0), "ERC20: burn from the zero address");
506 
507         _beforeTokenTransfer(account, address(0), amount);
508 
509         uint256 accountBalance = _balances[account];
510         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
511         unchecked {
512             _balances[account] = accountBalance - amount;
513             // Overflow not possible: amount <= accountBalance <= totalSupply.
514             _totalSupply -= amount;
515         }
516 
517         emit Transfer(account, address(0), amount);
518 
519         _afterTokenTransfer(account, address(0), amount);
520     }
521 
522     /**
523      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
524      *
525      * This internal function is equivalent to `approve`, and can be used to
526      * e.g. set automatic allowances for certain subsystems, etc.
527      *
528      * Emits an {Approval} event.
529      *
530      * Requirements:
531      *
532      * - `owner` cannot be the zero address.
533      * - `spender` cannot be the zero address.
534      */
535     function _approve(address owner, address spender, uint256 amount) internal virtual {
536         require(owner != address(0), "ERC20: approve from the zero address");
537         require(spender != address(0), "ERC20: approve to the zero address");
538 
539         _allowances[owner][spender] = amount;
540         emit Approval(owner, spender, amount);
541     }
542 
543     /**
544      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
545      *
546      * Does not update the allowance amount in case of infinite allowance.
547      * Revert if not enough allowance is available.
548      *
549      * Might emit an {Approval} event.
550      */
551     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
552         uint256 currentAllowance = allowance(owner, spender);
553         if (currentAllowance != type(uint256).max) {
554             require(currentAllowance >= amount, "ERC20: insufficient allowance");
555             unchecked {
556                 _approve(owner, spender, currentAllowance - amount);
557             }
558         }
559     }
560 
561     /**
562      * @dev Hook that is called before any transfer of tokens. This includes
563      * minting and burning.
564      *
565      * Calling conditions:
566      *
567      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
568      * will be transferred to `to`.
569      * - when `from` is zero, `amount` tokens will be minted for `to`.
570      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
571      * - `from` and `to` are never both zero.
572      *
573      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
574      */
575     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
576 
577     /**
578      * @dev Hook that is called after any transfer of tokens. This includes
579      * minting and burning.
580      *
581      * Calling conditions:
582      *
583      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
584      * has been transferred to `to`.
585      * - when `from` is zero, `amount` tokens have been minted for `to`.
586      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
587      * - `from` and `to` are never both zero.
588      *
589      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
590      */
591     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
592 }
593 
594 
595 // File @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol@v1.1.0-beta.0
596 
597 pragma solidity >=0.6.2;
598 
599 interface IUniswapV2Router01 {
600     function factory() external pure returns (address);
601     function WETH() external pure returns (address);
602 
603     function addLiquidity(
604         address tokenA,
605         address tokenB,
606         uint amountADesired,
607         uint amountBDesired,
608         uint amountAMin,
609         uint amountBMin,
610         address to,
611         uint deadline
612     ) external returns (uint amountA, uint amountB, uint liquidity);
613     function addLiquidityETH(
614         address token,
615         uint amountTokenDesired,
616         uint amountTokenMin,
617         uint amountETHMin,
618         address to,
619         uint deadline
620     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
621     function removeLiquidity(
622         address tokenA,
623         address tokenB,
624         uint liquidity,
625         uint amountAMin,
626         uint amountBMin,
627         address to,
628         uint deadline
629     ) external returns (uint amountA, uint amountB);
630     function removeLiquidityETH(
631         address token,
632         uint liquidity,
633         uint amountTokenMin,
634         uint amountETHMin,
635         address to,
636         uint deadline
637     ) external returns (uint amountToken, uint amountETH);
638     function removeLiquidityWithPermit(
639         address tokenA,
640         address tokenB,
641         uint liquidity,
642         uint amountAMin,
643         uint amountBMin,
644         address to,
645         uint deadline,
646         bool approveMax, uint8 v, bytes32 r, bytes32 s
647     ) external returns (uint amountA, uint amountB);
648     function removeLiquidityETHWithPermit(
649         address token,
650         uint liquidity,
651         uint amountTokenMin,
652         uint amountETHMin,
653         address to,
654         uint deadline,
655         bool approveMax, uint8 v, bytes32 r, bytes32 s
656     ) external returns (uint amountToken, uint amountETH);
657     function swapExactTokensForTokens(
658         uint amountIn,
659         uint amountOutMin,
660         address[] calldata path,
661         address to,
662         uint deadline
663     ) external returns (uint[] memory amounts);
664     function swapTokensForExactTokens(
665         uint amountOut,
666         uint amountInMax,
667         address[] calldata path,
668         address to,
669         uint deadline
670     ) external returns (uint[] memory amounts);
671     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
672         external
673         payable
674         returns (uint[] memory amounts);
675     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
676         external
677         returns (uint[] memory amounts);
678     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
679         external
680         returns (uint[] memory amounts);
681     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
682         external
683         payable
684         returns (uint[] memory amounts);
685 
686     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
687     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
688     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
689     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
690     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
691 }
692 
693 
694 // File @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol@v1.1.0-beta.0
695 
696 pragma solidity >=0.6.2;
697 
698 interface IUniswapV2Router02 is IUniswapV2Router01 {
699     function removeLiquidityETHSupportingFeeOnTransferTokens(
700         address token,
701         uint liquidity,
702         uint amountTokenMin,
703         uint amountETHMin,
704         address to,
705         uint deadline
706     ) external returns (uint amountETH);
707     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
708         address token,
709         uint liquidity,
710         uint amountTokenMin,
711         uint amountETHMin,
712         address to,
713         uint deadline,
714         bool approveMax, uint8 v, bytes32 r, bytes32 s
715     ) external returns (uint amountETH);
716 
717     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
718         uint amountIn,
719         uint amountOutMin,
720         address[] calldata path,
721         address to,
722         uint deadline
723     ) external;
724     function swapExactETHForTokensSupportingFeeOnTransferTokens(
725         uint amountOutMin,
726         address[] calldata path,
727         address to,
728         uint deadline
729     ) external payable;
730     function swapExactTokensForETHSupportingFeeOnTransferTokens(
731         uint amountIn,
732         uint amountOutMin,
733         address[] calldata path,
734         address to,
735         uint deadline
736     ) external;
737 }
738 
739 
740 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.9.2
741 
742 
743 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)
744 
745 pragma solidity ^0.8.0;
746 
747 // CAUTION
748 // This version of SafeMath should only be used with Solidity 0.8 or later,
749 // because it relies on the compiler's built in overflow checks.
750 
751 /**
752  * @dev Wrappers over Solidity's arithmetic operations.
753  *
754  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
755  * now has built in overflow checking.
756  */
757 library SafeMath {
758     /**
759      * @dev Returns the addition of two unsigned integers, with an overflow flag.
760      *
761      * _Available since v3.4._
762      */
763     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
764         unchecked {
765             uint256 c = a + b;
766             if (c < a) return (false, 0);
767             return (true, c);
768         }
769     }
770 
771     /**
772      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
773      *
774      * _Available since v3.4._
775      */
776     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
777         unchecked {
778             if (b > a) return (false, 0);
779             return (true, a - b);
780         }
781     }
782 
783     /**
784      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
785      *
786      * _Available since v3.4._
787      */
788     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
789         unchecked {
790             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
791             // benefit is lost if 'b' is also tested.
792             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
793             if (a == 0) return (true, 0);
794             uint256 c = a * b;
795             if (c / a != b) return (false, 0);
796             return (true, c);
797         }
798     }
799 
800     /**
801      * @dev Returns the division of two unsigned integers, with a division by zero flag.
802      *
803      * _Available since v3.4._
804      */
805     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
806         unchecked {
807             if (b == 0) return (false, 0);
808             return (true, a / b);
809         }
810     }
811 
812     /**
813      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
814      *
815      * _Available since v3.4._
816      */
817     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
818         unchecked {
819             if (b == 0) return (false, 0);
820             return (true, a % b);
821         }
822     }
823 
824     /**
825      * @dev Returns the addition of two unsigned integers, reverting on
826      * overflow.
827      *
828      * Counterpart to Solidity's `+` operator.
829      *
830      * Requirements:
831      *
832      * - Addition cannot overflow.
833      */
834     function add(uint256 a, uint256 b) internal pure returns (uint256) {
835         return a + b;
836     }
837 
838     /**
839      * @dev Returns the subtraction of two unsigned integers, reverting on
840      * overflow (when the result is negative).
841      *
842      * Counterpart to Solidity's `-` operator.
843      *
844      * Requirements:
845      *
846      * - Subtraction cannot overflow.
847      */
848     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
849         return a - b;
850     }
851 
852     /**
853      * @dev Returns the multiplication of two unsigned integers, reverting on
854      * overflow.
855      *
856      * Counterpart to Solidity's `*` operator.
857      *
858      * Requirements:
859      *
860      * - Multiplication cannot overflow.
861      */
862     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
863         return a * b;
864     }
865 
866     /**
867      * @dev Returns the integer division of two unsigned integers, reverting on
868      * division by zero. The result is rounded towards zero.
869      *
870      * Counterpart to Solidity's `/` operator.
871      *
872      * Requirements:
873      *
874      * - The divisor cannot be zero.
875      */
876     function div(uint256 a, uint256 b) internal pure returns (uint256) {
877         return a / b;
878     }
879 
880     /**
881      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
882      * reverting when dividing by zero.
883      *
884      * Counterpart to Solidity's `%` operator. This function uses a `revert`
885      * opcode (which leaves remaining gas untouched) while Solidity uses an
886      * invalid opcode to revert (consuming all remaining gas).
887      *
888      * Requirements:
889      *
890      * - The divisor cannot be zero.
891      */
892     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
893         return a % b;
894     }
895 
896     /**
897      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
898      * overflow (when the result is negative).
899      *
900      * CAUTION: This function is deprecated because it requires allocating memory for the error
901      * message unnecessarily. For custom revert reasons use {trySub}.
902      *
903      * Counterpart to Solidity's `-` operator.
904      *
905      * Requirements:
906      *
907      * - Subtraction cannot overflow.
908      */
909     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
910         unchecked {
911             require(b <= a, errorMessage);
912             return a - b;
913         }
914     }
915 
916     /**
917      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
918      * division by zero. The result is rounded towards zero.
919      *
920      * Counterpart to Solidity's `/` operator. Note: this function uses a
921      * `revert` opcode (which leaves remaining gas untouched) while Solidity
922      * uses an invalid opcode to revert (consuming all remaining gas).
923      *
924      * Requirements:
925      *
926      * - The divisor cannot be zero.
927      */
928     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
929         unchecked {
930             require(b > 0, errorMessage);
931             return a / b;
932         }
933     }
934 
935     /**
936      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
937      * reverting with custom message when dividing by zero.
938      *
939      * CAUTION: This function is deprecated because it requires allocating memory for the error
940      * message unnecessarily. For custom revert reasons use {tryMod}.
941      *
942      * Counterpart to Solidity's `%` operator. This function uses a `revert`
943      * opcode (which leaves remaining gas untouched) while Solidity uses an
944      * invalid opcode to revert (consuming all remaining gas).
945      *
946      * Requirements:
947      *
948      * - The divisor cannot be zero.
949      */
950     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
951         unchecked {
952             require(b > 0, errorMessage);
953             return a % b;
954         }
955     }
956 }
957 
958 
959 // File @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol@v1.0.1
960 
961 pragma solidity >=0.5.0;
962 
963 interface IUniswapV2Factory {
964     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
965 
966     function feeTo() external view returns (address);
967     function feeToSetter() external view returns (address);
968 
969     function getPair(address tokenA, address tokenB) external view returns (address pair);
970     function allPairs(uint) external view returns (address pair);
971     function allPairsLength() external view returns (uint);
972 
973     function createPair(address tokenA, address tokenB) external returns (address pair);
974 
975     function setFeeTo(address) external;
976     function setFeeToSetter(address) external;
977 }
978 
979 
980 // File contracts/BAYC.sol
981 
982 
983 
984 pragma solidity 0.8.0;
985 
986 
987 
988 
989 
990 contract BrokeApeYachtClub is Context, ERC20, Ownable {
991     using SafeMath for uint256;
992 
993     IUniswapV2Router02 private _uniswapV2Router02;
994 
995     mapping(address => bool) private _excludedFromFees;
996     mapping(address => bool) private _excludedFromMaxTxAmount;
997 
998     bool public tradingOpen = false;
999     bool private _swapping = false;
1000     bool public swapEnabled = false;
1001     bool public feesEnabled = true;
1002     uint256 private taxTill;
1003 
1004     uint256 public maxBuyAmount;
1005     uint256 public maxSellAmount;
1006     uint256 public maxWalletAmount;
1007 
1008     uint256 private _totalFees;
1009     uint256 private _marketingFee;
1010 
1011     uint256 public buyMarketingFee = 10;
1012     uint256 private _previousBuyMarketingFee = buyMarketingFee;
1013 
1014     uint256 public sellMarketingFee = 15;
1015     uint256 private _previousSellMarketingFee = sellMarketingFee;
1016 
1017     uint256 private _tokensForMarketing;
1018     uint256 private _swapTokensAtAmount = 0;
1019 
1020     address payable public marketingWalletAddress =
1021         payable(0x693d6Bf80Afca0FCDfD5FF664Ad1B63409DFeE08);
1022 
1023     address private _uniswapV2Pair;
1024 
1025     enum TransactionType {
1026         BUY,
1027         SELL,
1028         TRANSFER
1029     }
1030 
1031     modifier lockSwapping() {
1032         _swapping = true;
1033         _;
1034         _swapping = false;
1035     }
1036 
1037     event OpenTrading();
1038     event SetMaxBuyAmount(uint256 newMaxBuyAmount);
1039     event SetMaxSellAmount(uint256 newMaxSellAmount);
1040     event SetMaxWalletAmount(uint256 newMaxWalletAmount);
1041     event SetSwapTokensAtAmount(uint256 newSwapTokensAtAmount);
1042     event SetBuyFee(uint256 buyMarketingFee);
1043     event SetSellFee(uint256 sellMarketingFee);
1044 
1045     constructor() ERC20("BrokeApeYachtClub", "BAYC") {
1046         uint256 _totalSupply = 100_000_000 ether;
1047 
1048         _uniswapV2Router02 = IUniswapV2Router02(
1049             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1050         );
1051 
1052         _approve(address(this), address(_uniswapV2Router02), totalSupply());
1053         _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router02.factory())
1054             .createPair(address(this), _uniswapV2Router02.WETH());
1055         IERC20(_uniswapV2Pair).approve(
1056             address(_uniswapV2Router02),
1057             type(uint256).max
1058         );
1059 
1060         maxBuyAmount = _totalSupply;
1061         maxSellAmount = _totalSupply;
1062         maxWalletAmount = _totalSupply;
1063 
1064         _excludedFromFees[owner()] = true;
1065         _excludedFromFees[address(this)] = true;
1066         _excludedFromFees[address(0xdead)] = true;
1067         _excludedFromFees[marketingWalletAddress] = true;
1068 
1069         _excludedFromMaxTxAmount[owner()] = true;
1070         _excludedFromMaxTxAmount[address(this)] = true;
1071         _excludedFromMaxTxAmount[address(0xdead)] = true;
1072         _excludedFromMaxTxAmount[marketingWalletAddress] = true;
1073 
1074         _mint(owner(), _totalSupply);
1075     }
1076 
1077     receive() external payable {}
1078 
1079     fallback() external payable {}
1080 
1081     function burn(uint256 value) external {
1082         _burn(msg.sender, value);
1083     }
1084 
1085     function _transfer(
1086         address from,
1087         address to,
1088         uint256 amount
1089     ) internal override {
1090         require(from != address(0x0), "ERC20: transfer from the zero address");
1091         require(to != address(0x0), "ERC20: transfer to the zero address");
1092         require(amount > 0, "Transfer amount must be greater than zero");
1093 
1094         bool takeFee = true;
1095         TransactionType txType = (from == _uniswapV2Pair)
1096             ? TransactionType.BUY
1097             : (to == _uniswapV2Pair)
1098             ? TransactionType.SELL
1099             : TransactionType.TRANSFER;
1100         if (
1101             from != owner() &&
1102             to != owner() &&
1103             to != address(0x0) &&
1104             to != address(0xdead) &&
1105             !_swapping
1106         ) {
1107             if (!tradingOpen)
1108                 require(
1109                     _excludedFromFees[from] || _excludedFromFees[to],
1110                     "Trading is not allowed yet."
1111                 );
1112 
1113             if (
1114                 txType == TransactionType.BUY &&
1115                 to != address(_uniswapV2Router02) &&
1116                 !_excludedFromMaxTxAmount[to]
1117             ) {
1118                 require(
1119                     amount <= maxBuyAmount,
1120                     "Transfer amount exceeds the maxBuyAmount."
1121                 );
1122                 require(
1123                     balanceOf(to).add(amount) <= maxWalletAmount,
1124                     "Exceeds maximum wallet token amount."
1125                 );
1126             }
1127 
1128             if (
1129                 txType == TransactionType.SELL &&
1130                 from != address(_uniswapV2Router02) &&
1131                 !_excludedFromMaxTxAmount[from]
1132             )
1133                 require(
1134                     amount <= maxSellAmount,
1135                     "Transfer amount exceeds the maxSellAmount."
1136                 );
1137         }
1138 
1139         if (_excludedFromFees[from] || _excludedFromFees[to] || !feesEnabled)
1140             takeFee = false;
1141 
1142         uint256 contractBalance = balanceOf(address(this));
1143         bool canSwap = (contractBalance > _swapTokensAtAmount) &&
1144             (txType == TransactionType.SELL);
1145 
1146         if (
1147             canSwap &&
1148             swapEnabled &&
1149             !_swapping &&
1150             !_excludedFromFees[from] &&
1151             !_excludedFromFees[to]
1152         ) {
1153             _swapBack(contractBalance);
1154         }
1155 
1156         _tokenTransfer(from, to, amount, takeFee, txType);
1157     }
1158 
1159     function _swapBack(uint256 contractBalance) internal lockSwapping {
1160         bool success;
1161 
1162         if (contractBalance == 0 || _tokensForMarketing == 0) return;
1163 
1164         if (contractBalance > _swapTokensAtAmount.mul(5))
1165             contractBalance = _swapTokensAtAmount.mul(5);
1166 
1167         _swapTokensForETH(contractBalance);
1168 
1169         _tokensForMarketing = 0;
1170 
1171         (success, ) = address(marketingWalletAddress).call{
1172             value: address(this).balance
1173         }("");
1174     }
1175 
1176     function _swapTokensForETH(uint256 tokenAmount) internal {
1177         address[] memory path = new address[](2);
1178         path[0] = address(this);
1179         path[1] = _uniswapV2Router02.WETH();
1180         _approve(address(this), address(_uniswapV2Router02), tokenAmount);
1181         _uniswapV2Router02.swapExactTokensForETHSupportingFeeOnTransferTokens(
1182             tokenAmount,
1183             0,
1184             path,
1185             address(this),
1186             block.timestamp
1187         );
1188     }
1189 
1190     function _sendETHToFee(uint256 amount) internal {
1191         marketingWalletAddress.transfer(amount);
1192     }
1193 
1194     function openTrading() public onlyOwner {
1195         require(!tradingOpen, "Trading is already open");
1196         _swapTokensAtAmount = totalSupply().mul(5).div(10000);
1197         taxTill = block.number + 10;
1198         swapEnabled = true;
1199         tradingOpen = true;
1200         emit OpenTrading();
1201     }
1202 
1203     function setSwapEnabled(bool onoff) public onlyOwner {
1204         swapEnabled = onoff;
1205     }
1206 
1207     function setFeesEnabled(bool onoff) public onlyOwner {
1208         feesEnabled = onoff;
1209     }
1210 
1211     function setMaxBuyAmount(uint256 _maxBuyAmount) public onlyOwner {
1212         require(
1213             _maxBuyAmount >= (totalSupply().mul(1).div(1000)),
1214             "Max buy amount cannot be lower than 0.1% total supply."
1215         );
1216         maxBuyAmount = _maxBuyAmount;
1217         emit SetMaxBuyAmount(maxBuyAmount);
1218     }
1219 
1220     function setMaxSellAmount(uint256 _maxSellAmount) public onlyOwner {
1221         require(
1222             _maxSellAmount >= (totalSupply().mul(1).div(1000)),
1223             "Max sell amount cannot be lower than 0.1% total supply."
1224         );
1225         maxSellAmount = _maxSellAmount;
1226         emit SetMaxSellAmount(maxSellAmount);
1227     }
1228 
1229     function setMaxWalletAmount(uint256 _maxWalletAmount) public onlyOwner {
1230         require(
1231             _maxWalletAmount >= (totalSupply().mul(1).div(1000)),
1232             "Max wallet amount cannot be lower than 0.1% total supply."
1233         );
1234         maxWalletAmount = _maxWalletAmount;
1235         emit SetMaxWalletAmount(maxWalletAmount);
1236     }
1237 
1238     function setSwapTokensAtAmount(
1239         uint256 swapTokensAtAmount
1240     ) public onlyOwner {
1241         require(
1242             swapTokensAtAmount >= (totalSupply().mul(1).div(1000000)),
1243             "Swap amount cannot be lower than 0.0001% total supply."
1244         );
1245         require(
1246             swapTokensAtAmount <= (totalSupply().mul(5).div(1000)),
1247             "Swap amount cannot be higher than 0.5% total supply."
1248         );
1249         _swapTokensAtAmount = swapTokensAtAmount;
1250         emit SetSwapTokensAtAmount(_swapTokensAtAmount);
1251     }
1252 
1253     function setMarketingWalletAddress(
1254         address _marketingWalletAddress
1255     ) public onlyOwner {
1256         require(
1257             _marketingWalletAddress != address(0x0),
1258             "marketingWalletAddress cannot be 0"
1259         );
1260         _excludedFromFees[marketingWalletAddress] = false;
1261         _excludedFromMaxTxAmount[marketingWalletAddress] = false;
1262         marketingWalletAddress = payable(_marketingWalletAddress);
1263         _excludedFromFees[marketingWalletAddress] = true;
1264         _excludedFromMaxTxAmount[marketingWalletAddress] = true;
1265     }
1266 
1267     function excludeFromFees(
1268         address[] memory accounts,
1269         bool isEx
1270     ) public onlyOwner {
1271         for (uint256 i = 0; i < accounts.length; i++)
1272             _excludedFromFees[accounts[i]] = isEx;
1273     }
1274 
1275     function excludeFromMaxTxAmount(
1276         address[] memory accounts,
1277         bool isEx
1278     ) public onlyOwner {
1279         for (uint256 i = 0; i < accounts.length; i++)
1280             _excludedFromMaxTxAmount[accounts[i]] = isEx;
1281     }
1282 
1283     function setBuyFee(uint256 _buyMarketingFee) public onlyOwner {
1284         buyMarketingFee = _buyMarketingFee;
1285         emit SetBuyFee(buyMarketingFee);
1286     }
1287 
1288     function setSellFee(uint256 _sellMarketingFee) public onlyOwner {
1289         sellMarketingFee = _sellMarketingFee;
1290         emit SetSellFee(sellMarketingFee);
1291     }
1292 
1293     function _removeAllFee() internal {
1294         if (buyMarketingFee == 0 && sellMarketingFee == 0) return;
1295 
1296         _previousBuyMarketingFee = buyMarketingFee;
1297         _previousSellMarketingFee = sellMarketingFee;
1298 
1299         buyMarketingFee = 0;
1300         sellMarketingFee = 0;
1301     }
1302 
1303     function _restoreAllFee() internal {
1304         buyMarketingFee = _previousBuyMarketingFee;
1305         sellMarketingFee = _previousSellMarketingFee;
1306     }
1307 
1308     function _tokenTransfer(
1309         address sender,
1310         address recipient,
1311         uint256 amount,
1312         bool takeFee,
1313         TransactionType txType
1314     ) internal {
1315         if (!takeFee) _removeAllFee();
1316         else amount = _takeFees(sender, amount, txType);
1317 
1318         super._transfer(sender, recipient, amount);
1319 
1320         if (!takeFee) _restoreAllFee();
1321     }
1322 
1323     function _takeFees(
1324         address sender,
1325         uint256 amount,
1326         TransactionType txType
1327     ) internal returns (uint256) {
1328         if (txType == TransactionType.SELL) _sell();
1329         else if (txType == TransactionType.BUY) _buy();
1330         else if (txType == TransactionType.TRANSFER) _transfer();
1331         else revert("Invalid transaction type.");
1332 
1333         uint256 fees;
1334         if (_totalFees > 0) {
1335             fees = amount.mul(_totalFees).div(100);
1336             _tokensForMarketing += (fees.mul(_marketingFee)).div(_totalFees);
1337         }
1338 
1339         if (fees > 0) super._transfer(sender, address(this), fees);
1340 
1341         return amount -= fees;
1342     }
1343 
1344     function _sell() internal {
1345         if (block.number < taxTill) {
1346             _marketingFee = 20;
1347             _totalFees = _marketingFee;
1348         } else {
1349             _marketingFee = sellMarketingFee;
1350             _totalFees = _marketingFee;
1351         }
1352     }
1353 
1354     function _buy() internal {
1355         if (block.number < taxTill) {
1356             _marketingFee = 20;
1357             _totalFees = _marketingFee;
1358         } else {
1359             _marketingFee = buyMarketingFee;
1360             _totalFees = _marketingFee;
1361         }
1362     }
1363 
1364     function _transfer() internal {
1365         _marketingFee = 0;
1366         _totalFees = _marketingFee;
1367     }
1368 
1369     function fixClog() public onlyOwner lockSwapping {
1370         _swapTokensForETH(balanceOf(address(this)));
1371         _tokensForMarketing = 0;
1372         bool success;
1373         (success, ) = address(marketingWalletAddress).call{
1374             value: address(this).balance
1375         }("");
1376     }
1377 
1378     function rescueStuckTokens(address tkn) public onlyOwner {
1379         bool success;
1380         if (tkn == address(0))
1381             (success, ) = address(msg.sender).call{
1382                 value: address(this).balance
1383             }("");
1384         else {
1385             require(tkn != address(this), "Cannot withdraw own token");
1386             require(IERC20(tkn).balanceOf(address(this)) > 0, "No tokens");
1387             uint256 amount = IERC20(tkn).balanceOf(address(this));
1388             IERC20(tkn).transfer(msg.sender, amount);
1389         }
1390     }
1391 
1392     function removeLimits() public onlyOwner {
1393         maxBuyAmount = totalSupply();
1394         maxSellAmount = totalSupply();
1395         maxWalletAmount = totalSupply();
1396     }
1397 }