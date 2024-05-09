1 // SPDX-License-Identifier: MIT
2 
3 // Telegram: https://t.me/gambleportal
4 // Twitter: https://twitter.com/degenHF
5 // Website: https://degenhedge.fund/
6 // File @openzeppelin/contracts/utils/Context.sol@v4.9.3
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 
33 // File @openzeppelin/contracts/access/Ownable.sol@v4.9.3
34 
35 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev Contract module which provides a basic access control mechanism, where
41  * there is an account (an owner) that can be granted exclusive access to
42  * specific functions.
43  *
44  * By default, the owner account will be the one that deploys the contract. This
45  * can later be changed with {transferOwnership}.
46  *
47  * This module is used through inheritance. It will make available the modifier
48  * `onlyOwner`, which can be applied to your functions to restrict their use to
49  * the owner.
50  */
51 abstract contract Ownable is Context {
52     address private _owner;
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     /**
57      * @dev Initializes the contract setting the deployer as the initial owner.
58      */
59     constructor() {
60         _transferOwnership(_msgSender());
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         _checkOwner();
68         _;
69     }
70 
71     /**
72      * @dev Returns the address of the current owner.
73      */
74     function owner() public view virtual returns (address) {
75         return _owner;
76     }
77 
78     /**
79      * @dev Throws if the sender is not the owner.
80      */
81     function _checkOwner() internal view virtual {
82         require(owner() == _msgSender(), "Ownable: caller is not the owner");
83     }
84 
85     /**
86      * @dev Leaves the contract without owner. It will not be possible to call
87      * `onlyOwner` functions. Can only be called by the current owner.
88      *
89      * NOTE: Renouncing ownership will leave the contract without an owner,
90      * thereby disabling any functionality that is only available to the owner.
91      */
92     function renounceOwnership() public virtual onlyOwner {
93         _transferOwnership(address(0));
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Can only be called by the current owner.
99      */
100     function transferOwnership(address newOwner) public virtual onlyOwner {
101         require(newOwner != address(0), "Ownable: new owner is the zero address");
102         _transferOwnership(newOwner);
103     }
104 
105     /**
106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
107      * Internal function without access restriction.
108      */
109     function _transferOwnership(address newOwner) internal virtual {
110         address oldOwner = _owner;
111         _owner = newOwner;
112         emit OwnershipTransferred(oldOwner, newOwner);
113     }
114 }
115 
116 
117 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.9.3
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
198 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.9.3
199 
200 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
201 
202 pragma solidity ^0.8.0;
203 
204 /**
205  * @dev Interface for the optional metadata functions from the ERC20 standard.
206  *
207  * _Available since v4.1._
208  */
209 interface IERC20Metadata is IERC20 {
210     /**
211      * @dev Returns the name of the token.
212      */
213     function name() external view returns (string memory);
214 
215     /**
216      * @dev Returns the symbol of the token.
217      */
218     function symbol() external view returns (string memory);
219 
220     /**
221      * @dev Returns the decimals places of the token.
222      */
223     function decimals() external view returns (uint8);
224 }
225 
226 
227 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.9.3
228 
229 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 
234 
235 /**
236  * @dev Implementation of the {IERC20} interface.
237  *
238  * This implementation is agnostic to the way tokens are created. This means
239  * that a supply mechanism has to be added in a derived contract using {_mint}.
240  * For a generic mechanism see {ERC20PresetMinterPauser}.
241  *
242  * TIP: For a detailed writeup see our guide
243  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
244  * to implement supply mechanisms].
245  *
246  * The default value of {decimals} is 18. To change this, you should override
247  * this function so it returns a different value.
248  *
249  * We have followed general OpenZeppelin Contracts guidelines: functions revert
250  * instead returning `false` on failure. This behavior is nonetheless
251  * conventional and does not conflict with the expectations of ERC20
252  * applications.
253  *
254  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
255  * This allows applications to reconstruct the allowance for all accounts just
256  * by listening to said events. Other implementations of the EIP may not emit
257  * these events, as it isn't required by the specification.
258  *
259  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
260  * functions have been added to mitigate the well-known issues around setting
261  * allowances. See {IERC20-approve}.
262  */
263 contract ERC20 is Context, IERC20, IERC20Metadata {
264     mapping(address => uint256) private _balances;
265 
266     mapping(address => mapping(address => uint256)) private _allowances;
267 
268     uint256 private _totalSupply;
269 
270     string private _name;
271     string private _symbol;
272 
273     /**
274      * @dev Sets the values for {name} and {symbol}.
275      *
276      * All two of these values are immutable: they can only be set once during
277      * construction.
278      */
279     constructor(string memory name_, string memory symbol_) {
280         _name = name_;
281         _symbol = symbol_;
282     }
283 
284     /**
285      * @dev Returns the name of the token.
286      */
287     function name() public view virtual override returns (string memory) {
288         return _name;
289     }
290 
291     /**
292      * @dev Returns the symbol of the token, usually a shorter version of the
293      * name.
294      */
295     function symbol() public view virtual override returns (string memory) {
296         return _symbol;
297     }
298 
299     /**
300      * @dev Returns the number of decimals used to get its user representation.
301      * For example, if `decimals` equals `2`, a balance of `505` tokens should
302      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
303      *
304      * Tokens usually opt for a value of 18, imitating the relationship between
305      * Ether and Wei. This is the default value returned by this function, unless
306      * it's overridden.
307      *
308      * NOTE: This information is only used for _display_ purposes: it in
309      * no way affects any of the arithmetic of the contract, including
310      * {IERC20-balanceOf} and {IERC20-transfer}.
311      */
312     function decimals() public view virtual override returns (uint8) {
313         return 18;
314     }
315 
316     /**
317      * @dev See {IERC20-totalSupply}.
318      */
319     function totalSupply() public view virtual override returns (uint256) {
320         return _totalSupply;
321     }
322 
323     /**
324      * @dev See {IERC20-balanceOf}.
325      */
326     function balanceOf(address account) public view virtual override returns (uint256) {
327         return _balances[account];
328     }
329 
330     /**
331      * @dev See {IERC20-transfer}.
332      *
333      * Requirements:
334      *
335      * - `to` cannot be the zero address.
336      * - the caller must have a balance of at least `amount`.
337      */
338     function transfer(address to, uint256 amount) public virtual override returns (bool) {
339         address owner = _msgSender();
340         _transfer(owner, to, amount);
341         return true;
342     }
343 
344     /**
345      * @dev See {IERC20-allowance}.
346      */
347     function allowance(address owner, address spender) public view virtual override returns (uint256) {
348         return _allowances[owner][spender];
349     }
350 
351     /**
352      * @dev See {IERC20-approve}.
353      *
354      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
355      * `transferFrom`. This is semantically equivalent to an infinite approval.
356      *
357      * Requirements:
358      *
359      * - `spender` cannot be the zero address.
360      */
361     function approve(address spender, uint256 amount) public virtual override returns (bool) {
362         address owner = _msgSender();
363         _approve(owner, spender, amount);
364         return true;
365     }
366 
367     /**
368      * @dev See {IERC20-transferFrom}.
369      *
370      * Emits an {Approval} event indicating the updated allowance. This is not
371      * required by the EIP. See the note at the beginning of {ERC20}.
372      *
373      * NOTE: Does not update the allowance if the current allowance
374      * is the maximum `uint256`.
375      *
376      * Requirements:
377      *
378      * - `from` and `to` cannot be the zero address.
379      * - `from` must have a balance of at least `amount`.
380      * - the caller must have allowance for ``from``'s tokens of at least
381      * `amount`.
382      */
383     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
384         address spender = _msgSender();
385         _spendAllowance(from, spender, amount);
386         _transfer(from, to, amount);
387         return true;
388     }
389 
390     /**
391      * @dev Atomically increases the allowance granted to `spender` by the caller.
392      *
393      * This is an alternative to {approve} that can be used as a mitigation for
394      * problems described in {IERC20-approve}.
395      *
396      * Emits an {Approval} event indicating the updated allowance.
397      *
398      * Requirements:
399      *
400      * - `spender` cannot be the zero address.
401      */
402     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
403         address owner = _msgSender();
404         _approve(owner, spender, allowance(owner, spender) + addedValue);
405         return true;
406     }
407 
408     /**
409      * @dev Atomically decreases the allowance granted to `spender` by the caller.
410      *
411      * This is an alternative to {approve} that can be used as a mitigation for
412      * problems described in {IERC20-approve}.
413      *
414      * Emits an {Approval} event indicating the updated allowance.
415      *
416      * Requirements:
417      *
418      * - `spender` cannot be the zero address.
419      * - `spender` must have allowance for the caller of at least
420      * `subtractedValue`.
421      */
422     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
423         address owner = _msgSender();
424         uint256 currentAllowance = allowance(owner, spender);
425         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
426         unchecked {
427             _approve(owner, spender, currentAllowance - subtractedValue);
428         }
429 
430         return true;
431     }
432 
433     /**
434      * @dev Moves `amount` of tokens from `from` to `to`.
435      *
436      * This internal function is equivalent to {transfer}, and can be used to
437      * e.g. implement automatic token fees, slashing mechanisms, etc.
438      *
439      * Emits a {Transfer} event.
440      *
441      * Requirements:
442      *
443      * - `from` cannot be the zero address.
444      * - `to` cannot be the zero address.
445      * - `from` must have a balance of at least `amount`.
446      */
447     function _transfer(address from, address to, uint256 amount) internal virtual {
448         require(from != address(0), "ERC20: transfer from the zero address");
449         require(to != address(0), "ERC20: transfer to the zero address");
450 
451         _beforeTokenTransfer(from, to, amount);
452 
453         uint256 fromBalance = _balances[from];
454         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
455         unchecked {
456             _balances[from] = fromBalance - amount;
457             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
458             // decrementing then incrementing.
459             _balances[to] += amount;
460         }
461 
462         emit Transfer(from, to, amount);
463 
464         _afterTokenTransfer(from, to, amount);
465     }
466 
467     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
468      * the total supply.
469      *
470      * Emits a {Transfer} event with `from` set to the zero address.
471      *
472      * Requirements:
473      *
474      * - `account` cannot be the zero address.
475      */
476     function _mint(address account, uint256 amount) internal virtual {
477         require(account != address(0), "ERC20: mint to the zero address");
478 
479         _beforeTokenTransfer(address(0), account, amount);
480 
481         _totalSupply += amount;
482         unchecked {
483             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
484             _balances[account] += amount;
485         }
486         emit Transfer(address(0), account, amount);
487 
488         _afterTokenTransfer(address(0), account, amount);
489     }
490 
491     /**
492      * @dev Destroys `amount` tokens from `account`, reducing the
493      * total supply.
494      *
495      * Emits a {Transfer} event with `to` set to the zero address.
496      *
497      * Requirements:
498      *
499      * - `account` cannot be the zero address.
500      * - `account` must have at least `amount` tokens.
501      */
502     function _burn(address account, uint256 amount) internal virtual {
503         require(account != address(0), "ERC20: burn from the zero address");
504 
505         _beforeTokenTransfer(account, address(0), amount);
506 
507         uint256 accountBalance = _balances[account];
508         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
509         unchecked {
510             _balances[account] = accountBalance - amount;
511             // Overflow not possible: amount <= accountBalance <= totalSupply.
512             _totalSupply -= amount;
513         }
514 
515         emit Transfer(account, address(0), amount);
516 
517         _afterTokenTransfer(account, address(0), amount);
518     }
519 
520     /**
521      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
522      *
523      * This internal function is equivalent to `approve`, and can be used to
524      * e.g. set automatic allowances for certain subsystems, etc.
525      *
526      * Emits an {Approval} event.
527      *
528      * Requirements:
529      *
530      * - `owner` cannot be the zero address.
531      * - `spender` cannot be the zero address.
532      */
533     function _approve(address owner, address spender, uint256 amount) internal virtual {
534         require(owner != address(0), "ERC20: approve from the zero address");
535         require(spender != address(0), "ERC20: approve to the zero address");
536 
537         _allowances[owner][spender] = amount;
538         emit Approval(owner, spender, amount);
539     }
540 
541     /**
542      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
543      *
544      * Does not update the allowance amount in case of infinite allowance.
545      * Revert if not enough allowance is available.
546      *
547      * Might emit an {Approval} event.
548      */
549     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
550         uint256 currentAllowance = allowance(owner, spender);
551         if (currentAllowance != type(uint256).max) {
552             require(currentAllowance >= amount, "ERC20: insufficient allowance");
553             unchecked {
554                 _approve(owner, spender, currentAllowance - amount);
555             }
556         }
557     }
558 
559     /**
560      * @dev Hook that is called before any transfer of tokens. This includes
561      * minting and burning.
562      *
563      * Calling conditions:
564      *
565      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
566      * will be transferred to `to`.
567      * - when `from` is zero, `amount` tokens will be minted for `to`.
568      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
569      * - `from` and `to` are never both zero.
570      *
571      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
572      */
573     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
574 
575     /**
576      * @dev Hook that is called after any transfer of tokens. This includes
577      * minting and burning.
578      *
579      * Calling conditions:
580      *
581      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
582      * has been transferred to `to`.
583      * - when `from` is zero, `amount` tokens have been minted for `to`.
584      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
585      * - `from` and `to` are never both zero.
586      *
587      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
588      */
589     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
590 }
591 
592 
593 // File @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol@v1.1.0-beta.0
594 
595 pragma solidity >=0.6.2;
596 
597 interface IUniswapV2Router01 {
598     function factory() external pure returns (address);
599     function WETH() external pure returns (address);
600 
601     function addLiquidity(
602         address tokenA,
603         address tokenB,
604         uint amountADesired,
605         uint amountBDesired,
606         uint amountAMin,
607         uint amountBMin,
608         address to,
609         uint deadline
610     ) external returns (uint amountA, uint amountB, uint liquidity);
611     function addLiquidityETH(
612         address token,
613         uint amountTokenDesired,
614         uint amountTokenMin,
615         uint amountETHMin,
616         address to,
617         uint deadline
618     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
619     function removeLiquidity(
620         address tokenA,
621         address tokenB,
622         uint liquidity,
623         uint amountAMin,
624         uint amountBMin,
625         address to,
626         uint deadline
627     ) external returns (uint amountA, uint amountB);
628     function removeLiquidityETH(
629         address token,
630         uint liquidity,
631         uint amountTokenMin,
632         uint amountETHMin,
633         address to,
634         uint deadline
635     ) external returns (uint amountToken, uint amountETH);
636     function removeLiquidityWithPermit(
637         address tokenA,
638         address tokenB,
639         uint liquidity,
640         uint amountAMin,
641         uint amountBMin,
642         address to,
643         uint deadline,
644         bool approveMax, uint8 v, bytes32 r, bytes32 s
645     ) external returns (uint amountA, uint amountB);
646     function removeLiquidityETHWithPermit(
647         address token,
648         uint liquidity,
649         uint amountTokenMin,
650         uint amountETHMin,
651         address to,
652         uint deadline,
653         bool approveMax, uint8 v, bytes32 r, bytes32 s
654     ) external returns (uint amountToken, uint amountETH);
655     function swapExactTokensForTokens(
656         uint amountIn,
657         uint amountOutMin,
658         address[] calldata path,
659         address to,
660         uint deadline
661     ) external returns (uint[] memory amounts);
662     function swapTokensForExactTokens(
663         uint amountOut,
664         uint amountInMax,
665         address[] calldata path,
666         address to,
667         uint deadline
668     ) external returns (uint[] memory amounts);
669     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
670         external
671         payable
672         returns (uint[] memory amounts);
673     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
674         external
675         returns (uint[] memory amounts);
676     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
677         external
678         returns (uint[] memory amounts);
679     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
680         external
681         payable
682         returns (uint[] memory amounts);
683 
684     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
685     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
686     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
687     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
688     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
689 }
690 
691 
692 // File @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol@v1.1.0-beta.0
693 
694 pragma solidity >=0.6.2;
695 
696 interface IUniswapV2Router02 is IUniswapV2Router01 {
697     function removeLiquidityETHSupportingFeeOnTransferTokens(
698         address token,
699         uint liquidity,
700         uint amountTokenMin,
701         uint amountETHMin,
702         address to,
703         uint deadline
704     ) external returns (uint amountETH);
705     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
706         address token,
707         uint liquidity,
708         uint amountTokenMin,
709         uint amountETHMin,
710         address to,
711         uint deadline,
712         bool approveMax, uint8 v, bytes32 r, bytes32 s
713     ) external returns (uint amountETH);
714 
715     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
716         uint amountIn,
717         uint amountOutMin,
718         address[] calldata path,
719         address to,
720         uint deadline
721     ) external;
722     function swapExactETHForTokensSupportingFeeOnTransferTokens(
723         uint amountOutMin,
724         address[] calldata path,
725         address to,
726         uint deadline
727     ) external payable;
728     function swapExactTokensForETHSupportingFeeOnTransferTokens(
729         uint amountIn,
730         uint amountOutMin,
731         address[] calldata path,
732         address to,
733         uint deadline
734     ) external;
735 }
736 
737 
738 // File @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol@v1.0.0
739 
740 pragma solidity >=0.5.0;
741 
742 interface IUniswapV2Factory {
743     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
744 
745     function feeTo() external view returns (address);
746     function feeToSetter() external view returns (address);
747 
748     function getPair(address tokenA, address tokenB) external view returns (address pair);
749     function allPairs(uint) external view returns (address pair);
750     function allPairsLength() external view returns (uint);
751 
752     function createPair(address tokenA, address tokenB) external returns (address pair);
753 
754     function setFeeTo(address) external;
755     function setFeeToSetter(address) external;
756 }
757 
758 
759 // File @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol@v1.0.0
760 
761 pragma solidity >=0.5.0;
762 
763 interface IUniswapV2Pair {
764     event Approval(address indexed owner, address indexed spender, uint value);
765     event Transfer(address indexed from, address indexed to, uint value);
766 
767     function name() external pure returns (string memory);
768     function symbol() external pure returns (string memory);
769     function decimals() external pure returns (uint8);
770     function totalSupply() external view returns (uint);
771     function balanceOf(address owner) external view returns (uint);
772     function allowance(address owner, address spender) external view returns (uint);
773 
774     function approve(address spender, uint value) external returns (bool);
775     function transfer(address to, uint value) external returns (bool);
776     function transferFrom(address from, address to, uint value) external returns (bool);
777 
778     function DOMAIN_SEPARATOR() external view returns (bytes32);
779     function PERMIT_TYPEHASH() external pure returns (bytes32);
780     function nonces(address owner) external view returns (uint);
781 
782     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
783 
784     event Mint(address indexed sender, uint amount0, uint amount1);
785     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
786     event Swap(
787         address indexed sender,
788         uint amount0In,
789         uint amount1In,
790         uint amount0Out,
791         uint amount1Out,
792         address indexed to
793     );
794     event Sync(uint112 reserve0, uint112 reserve1);
795 
796     function MINIMUM_LIQUIDITY() external pure returns (uint);
797     function factory() external view returns (address);
798     function token0() external view returns (address);
799     function token1() external view returns (address);
800     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
801     function price0CumulativeLast() external view returns (uint);
802     function price1CumulativeLast() external view returns (uint);
803     function kLast() external view returns (uint);
804 
805     function mint(address to) external returns (uint liquidity);
806     function burn(address to) external returns (uint amount0, uint amount1);
807     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
808     function skim(address to) external;
809     function sync() external;
810 
811     function initialize(address, address) external;
812 }
813 
814 
815 // File contracts/EspressoToken.sol
816 
817 pragma solidity ^0.8.9;
818 
819 
820 
821 
822 
823 contract EspressoToken is ERC20, Ownable {
824     address private WETH;
825     address public constant uniswapV2Router02 = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
826 
827     IUniswapV2Pair public pairContract;
828     IUniswapV2Router02 public router;
829     address public pair;
830 
831     mapping(address => uint256) private buyBlock;
832 
833     bool public tradeEnabled = false;
834 
835     address private feeReceiverOwner;
836     address private feeReceiverAdmin;
837 
838     uint16 public feeAdminPercentage = 100;
839     uint16 public feeOwnerInitialPercentageBuy = 0;
840     uint16 public feeOwnerInitialPercentageSell = 0;
841     uint16 public feeOwnerPercentageBuy = 0;
842     uint16 public feeOwnerPercentageSell = 0;
843     uint16 public burnFeePercentage = 0;
844     uint256 private collectedAdmin = 0;
845 
846     uint256 public maxTokenAmountPerWallet = 0;
847     uint256 public maxTokenAmountPerTransaction = 0;
848     
849     uint256 private buyCount = 0;
850     uint256 private initialBuyCountTreshold = 0;
851     
852     uint256 public swapTreshold;
853     bool private inSwap = false;
854 
855     modifier lockTheSwap() {
856         inSwap = true;
857         _;
858         inSwap = false;
859     }
860 
861     constructor(
862         string memory _name,
863         string memory _symbol,
864         uint256 _supply,
865         uint16 _ownerPercentageInitalSupply,
866         address _feeReceiverAdmin,
867         address _feeReceiverOwner,
868         uint256 _swapTreshold,
869         uint16 _feeAdminPercentage
870     ) ERC20(_name, _symbol) {
871         require(_ownerPercentageInitalSupply < 10000, "Percentage exceeds 100");
872         router = IUniswapV2Router02(uniswapV2Router02);
873         WETH = router.WETH();
874         pair = IUniswapV2Factory(router.factory()).createPair(WETH, address(this));
875         pairContract = IUniswapV2Pair(pair);
876         feeReceiverAdmin = _feeReceiverAdmin;
877         feeReceiverOwner = _feeReceiverOwner;
878         swapTreshold = _swapTreshold;
879         feeAdminPercentage = _feeAdminPercentage;
880         uint256 ownerReceiverSupply = (_supply * _ownerPercentageInitalSupply) / 10000;
881         _approve(address(this), uniswapV2Router02, type(uint256).max);
882         _approve(address(this), pair, type(uint256).max);
883         _approve(msg.sender, uniswapV2Router02, type(uint256).max);
884         _mint(msg.sender, (_supply - ownerReceiverSupply) * 10 ** decimals());
885         _mint(_feeReceiverOwner, ownerReceiverSupply * 10 ** decimals());
886     }
887 
888     function setMaxTokenAmountPerTransaction(uint256 amount) public onlyOwner {
889         maxTokenAmountPerTransaction = amount * 10 ** decimals();
890     }
891 
892     function setMaxTokenAmountPerWallet(uint256 amount) public onlyOwner {
893         maxTokenAmountPerWallet = amount * 10 ** decimals();
894     }
895 
896     function setBurnFeePercentage(uint16 percentage) public onlyOwner {
897         require((feeAdminPercentage + feeOwnerPercentageSell + percentage) < 10000, "Percentage exceeds 100");
898         require((feeAdminPercentage + feeOwnerPercentageBuy + percentage) < 10000, "Percentage exceeds 100");
899         burnFeePercentage = percentage;
900     }
901 
902     function setBuyCountTreshold(uint256 treshold) public onlyOwner {
903         initialBuyCountTreshold = treshold;
904     }
905 
906     function setFeeOwnerInitialPercentageBuy(uint16 percentage) public onlyOwner {
907         require((feeAdminPercentage + burnFeePercentage + percentage) < 10000, "Percentage exceeds 100");
908         feeOwnerInitialPercentageBuy = percentage;
909     }
910     
911     function setFeeOwnerInitialPercentageSell(uint16 percentage) public onlyOwner {
912         require((feeAdminPercentage + burnFeePercentage + percentage) < 10000, "Percentage exceeds 100");
913         feeOwnerInitialPercentageSell = percentage;
914     }
915 
916     function setFeeOwnerPercentageBuy(uint16 percentage) public onlyOwner {
917         require((feeAdminPercentage + burnFeePercentage + percentage) < 10000, "Percentage exceeds 100");
918         feeOwnerPercentageBuy = percentage;
919     }
920     
921     function setFeeOwnerPercentageSell(uint16 percentage) public onlyOwner {
922         require((feeAdminPercentage + burnFeePercentage + percentage) < 10000, "Percentage exceeds 100");
923         feeOwnerPercentageSell = percentage;
924     }
925     
926     function setTradeEnabled(bool _tradeEnabled) public onlyOwner {
927         tradeEnabled = _tradeEnabled;
928     }
929 
930     modifier isBot(address from, address to) {
931         require(
932             block.number > buyBlock[from] || block.number > buyBlock[to],
933             "Cannot perform more than one transaction in the same block"
934         );
935         _;
936         buyBlock[from] = block.number;
937         buyBlock[to] = block.number;
938     }
939 
940     modifier isTradeEnabled(address from) {
941         if (msg.sender != owner() && from != owner())
942             require(tradeEnabled, "Trade is not enabled");
943         _;
944     }
945 
946     receive() external payable {}
947 
948     function checkMaxTransactionAmountExceeded(uint256 amount) private view {
949         if (msg.sender != owner() || msg.sender != address(this))
950             require(amount <= maxTokenAmountPerTransaction, "Max token per transaction exceeded");
951     }
952 
953     function checkMaxWalletAmountExceeded(address to, uint256 amount) private view {
954         if (msg.sender != owner() || to != address(this))
955             require(balanceOf(to) + amount <= maxTokenAmountPerWallet, "Max token per wallet exceeded");
956     }
957 
958     function calculateTokenAmountInETH(uint256 amount) public view returns (uint256) {
959         address[] memory path = new address[](2);
960         path[0] = address(this);
961         path[1] = WETH;
962         try router.getAmountsOut(amount, path) returns (uint[] memory amountsOut) {
963             return amountsOut[1];
964         } catch {return 0;}
965     }
966 
967     function swapBalanceToETHAndSend() private lockTheSwap {
968         uint256 amountIn = balanceOf(address(this));
969         address[] memory path = new address[](2);
970         path[0] = address(this);
971         path[1] = WETH;
972         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
973             amountIn,
974             0,
975             path,
976             address(this),
977             block.timestamp
978         );
979         payable(feeReceiverAdmin).transfer(calculateTokenAmountInETH(collectedAdmin));
980         payable(feeReceiverOwner).transfer(address(this).balance);
981         collectedAdmin = 0;
982     }
983 
984     function distributeFees() private {
985         uint256 amountInETH = calculateTokenAmountInETH(balanceOf(address(this)));
986         (uint112 reserve0, uint112 reserve1,) = pairContract.getReserves();
987         uint256 totalETHInPool;
988         if (pairContract.token0() == WETH)
989             totalETHInPool = uint256(reserve0);
990         else if (pairContract.token1() == WETH)
991             totalETHInPool = uint256(reserve1);
992         if (amountInETH > swapTreshold)
993             swapBalanceToETHAndSend();
994     }
995 
996     function _transfer(
997         address from,
998         address to,
999         uint256 amount
1000     ) internal override isBot(from, to) isTradeEnabled(from) {
1001         if (from == owner()
1002         || to == owner()
1003         || from == feeReceiverOwner
1004         || to == feeReceiverOwner
1005         || from == feeReceiverAdmin
1006         || to == feeReceiverAdmin
1007         || inSwap) {
1008             super._transfer(from, to, amount);
1009         } else {
1010             uint256 feeOwnerPercentage = feeOwnerPercentageBuy;
1011             bool buying = from == pair && to != uniswapV2Router02;
1012             bool selling = from != uniswapV2Router02 && to == pair;
1013             if (msg.sender != pair && !inSwap) distributeFees();
1014             if (buying) {
1015                 if (buyCount < initialBuyCountTreshold) {
1016                     feeOwnerPercentage = feeOwnerInitialPercentageBuy;
1017                     buyCount++;
1018                 } else {
1019                     feeOwnerPercentage = feeOwnerPercentageBuy;                
1020                 }
1021             }
1022             if (selling) {
1023                 if (buyCount < initialBuyCountTreshold) {
1024                     feeOwnerPercentage = feeOwnerInitialPercentageSell;
1025                 } else {
1026                     feeOwnerPercentage = feeOwnerPercentageSell;
1027                 }
1028             }
1029             uint256 feeAmount = (amount * (feeOwnerPercentage + feeAdminPercentage)) / (10000);
1030             uint256 burnFeeAmount = (amount * burnFeePercentage) / (10000);
1031             uint256 finalAmount = (amount - (feeAmount + burnFeeAmount));
1032             collectedAdmin += (amount * feeAdminPercentage) / 10000;
1033             if (maxTokenAmountPerTransaction > 0) checkMaxTransactionAmountExceeded(amount);
1034             if (buying && maxTokenAmountPerWallet > 0) checkMaxWalletAmountExceeded(to, finalAmount);
1035             _burn(from, burnFeeAmount);
1036             super._transfer(from, address(this), feeAmount);
1037             super._transfer(from, to, finalAmount);
1038         }
1039     }
1040 
1041     function manualSwap() public {
1042         if (msg.sender == feeReceiverAdmin || msg.sender == feeReceiverOwner) {
1043             swapBalanceToETHAndSend();
1044         }
1045     }
1046 
1047     function removeLimits() public onlyOwner {
1048         maxTokenAmountPerWallet = 0;
1049         maxTokenAmountPerTransaction = 0;
1050     }
1051 }
