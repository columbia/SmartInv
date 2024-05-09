1 // SPDX-License-Identifier: Unlicensed
2 
3 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
4 
5 pragma solidity >=0.5.0;
6 
7 interface IUniswapV2Factory {
8     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
9 
10     function feeTo() external view returns (address);
11     function feeToSetter() external view returns (address);
12 
13     function getPair(address tokenA, address tokenB) external view returns (address pair);
14     function allPairs(uint) external view returns (address pair);
15     function allPairsLength() external view returns (uint);
16 
17     function createPair(address tokenA, address tokenB) external returns (address pair);
18 
19     function setFeeTo(address) external;
20     function setFeeToSetter(address) external;
21 }
22 
23 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
24 
25 pragma solidity >=0.6.2;
26 
27 interface IUniswapV2Router01 {
28     function factory() external pure returns (address);
29     function WETH() external pure returns (address);
30 
31     function addLiquidity(
32         address tokenA,
33         address tokenB,
34         uint amountADesired,
35         uint amountBDesired,
36         uint amountAMin,
37         uint amountBMin,
38         address to,
39         uint deadline
40     ) external returns (uint amountA, uint amountB, uint liquidity);
41     function addLiquidityETH(
42         address token,
43         uint amountTokenDesired,
44         uint amountTokenMin,
45         uint amountETHMin,
46         address to,
47         uint deadline
48     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
49     function removeLiquidity(
50         address tokenA,
51         address tokenB,
52         uint liquidity,
53         uint amountAMin,
54         uint amountBMin,
55         address to,
56         uint deadline
57     ) external returns (uint amountA, uint amountB);
58     function removeLiquidityETH(
59         address token,
60         uint liquidity,
61         uint amountTokenMin,
62         uint amountETHMin,
63         address to,
64         uint deadline
65     ) external returns (uint amountToken, uint amountETH);
66     function removeLiquidityWithPermit(
67         address tokenA,
68         address tokenB,
69         uint liquidity,
70         uint amountAMin,
71         uint amountBMin,
72         address to,
73         uint deadline,
74         bool approveMax, uint8 v, bytes32 r, bytes32 s
75     ) external returns (uint amountA, uint amountB);
76     function removeLiquidityETHWithPermit(
77         address token,
78         uint liquidity,
79         uint amountTokenMin,
80         uint amountETHMin,
81         address to,
82         uint deadline,
83         bool approveMax, uint8 v, bytes32 r, bytes32 s
84     ) external returns (uint amountToken, uint amountETH);
85     function swapExactTokensForTokens(
86         uint amountIn,
87         uint amountOutMin,
88         address[] calldata path,
89         address to,
90         uint deadline
91     ) external returns (uint[] memory amounts);
92     function swapTokensForExactTokens(
93         uint amountOut,
94         uint amountInMax,
95         address[] calldata path,
96         address to,
97         uint deadline
98     ) external returns (uint[] memory amounts);
99     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
100         external
101         payable
102         returns (uint[] memory amounts);
103     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
104         external
105         returns (uint[] memory amounts);
106     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
107         external
108         returns (uint[] memory amounts);
109     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
110         external
111         payable
112         returns (uint[] memory amounts);
113 
114     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
115     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
116     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
117     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
118     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
119 }
120 
121 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
122 
123 pragma solidity >=0.6.2;
124 
125 
126 interface IUniswapV2Router02 is IUniswapV2Router01 {
127     function removeLiquidityETHSupportingFeeOnTransferTokens(
128         address token,
129         uint liquidity,
130         uint amountTokenMin,
131         uint amountETHMin,
132         address to,
133         uint deadline
134     ) external returns (uint amountETH);
135     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
136         address token,
137         uint liquidity,
138         uint amountTokenMin,
139         uint amountETHMin,
140         address to,
141         uint deadline,
142         bool approveMax, uint8 v, bytes32 r, bytes32 s
143     ) external returns (uint amountETH);
144 
145     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
146         uint amountIn,
147         uint amountOutMin,
148         address[] calldata path,
149         address to,
150         uint deadline
151     ) external;
152     function swapExactETHForTokensSupportingFeeOnTransferTokens(
153         uint amountOutMin,
154         address[] calldata path,
155         address to,
156         uint deadline
157     ) external payable;
158     function swapExactTokensForETHSupportingFeeOnTransferTokens(
159         uint amountIn,
160         uint amountOutMin,
161         address[] calldata path,
162         address to,
163         uint deadline
164     ) external;
165 }
166 
167 // File: @openzeppelin/contracts/utils/Context.sol
168 
169 
170 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
171 
172 pragma solidity ^0.8.0;
173 
174 /**
175  * @dev Provides information about the current execution context, including the
176  * sender of the transaction and its data. While these are generally available
177  * via msg.sender and msg.data, they should not be accessed in such a direct
178  * manner, since when dealing with meta-transactions the account sending and
179  * paying for execution may not be the actual sender (as far as an application
180  * is concerned).
181  *
182  * This contract is only required for intermediate, library-like contracts.
183  */
184 abstract contract Context {
185     function _msgSender() internal view virtual returns (address) {
186         return msg.sender;
187     }
188 
189     function _msgData() internal view virtual returns (bytes calldata) {
190         return msg.data;
191     }
192 }
193 
194 // File: @openzeppelin/contracts/access/Ownable.sol
195 
196 
197 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
198 
199 pragma solidity ^0.8.0;
200 
201 
202 /**
203  * @dev Contract module which provides a basic access control mechanism, where
204  * there is an account (an owner) that can be granted exclusive access to
205  * specific functions.
206  *
207  * By default, the owner account will be the one that deploys the contract. This
208  * can later be changed with {transferOwnership}.
209  *
210  * This module is used through inheritance. It will make available the modifier
211  * `onlyOwner`, which can be applied to your functions to restrict their use to
212  * the owner.
213  */
214 abstract contract Ownable is Context {
215     address private _owner;
216 
217     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
218 
219     /**
220      * @dev Initializes the contract setting the deployer as the initial owner.
221      */
222     constructor() {
223         _transferOwnership(_msgSender());
224     }
225 
226     /**
227      * @dev Returns the address of the current owner.
228      */
229     function owner() public view virtual returns (address) {
230         return _owner;
231     }
232 
233     /**
234      * @dev Throws if called by any account other than the owner.
235      */
236     modifier onlyOwner() {
237         require(owner() == _msgSender(), "Ownable: caller is not the owner");
238         _;
239     }
240 
241     /**
242      * @dev Leaves the contract without owner. It will not be possible to call
243      * `onlyOwner` functions anymore. Can only be called by the current owner.
244      *
245      * NOTE: Renouncing ownership will leave the contract without an owner,
246      * thereby removing any functionality that is only available to the owner.
247      */
248     function renounceOwnership() public virtual onlyOwner {
249         _transferOwnership(address(0));
250     }
251 
252     /**
253      * @dev Transfers ownership of the contract to a new account (`newOwner`).
254      * Can only be called by the current owner.
255      */
256     function transferOwnership(address newOwner) public virtual onlyOwner {
257         require(newOwner != address(0), "Ownable: new owner is the zero address");
258         _transferOwnership(newOwner);
259     }
260 
261     /**
262      * @dev Transfers ownership of the contract to a new account (`newOwner`).
263      * Internal function without access restriction.
264      */
265     function _transferOwnership(address newOwner) internal virtual {
266         address oldOwner = _owner;
267         _owner = newOwner;
268         emit OwnershipTransferred(oldOwner, newOwner);
269     }
270 }
271 
272 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
273 
274 
275 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
276 
277 pragma solidity ^0.8.0;
278 
279 /**
280  * @dev Interface of the ERC20 standard as defined in the EIP.
281  */
282 interface IERC20 {
283     /**
284      * @dev Returns the amount of tokens in existence.
285      */
286     function totalSupply() external view returns (uint256);
287 
288     /**
289      * @dev Returns the amount of tokens owned by `account`.
290      */
291     function balanceOf(address account) external view returns (uint256);
292 
293     /**
294      * @dev Moves `amount` tokens from the caller's account to `recipient`.
295      *
296      * Returns a boolean value indicating whether the operation succeeded.
297      *
298      * Emits a {Transfer} event.
299      */
300     function transfer(address recipient, uint256 amount) external returns (bool);
301 
302     /**
303      * @dev Returns the remaining number of tokens that `spender` will be
304      * allowed to spend on behalf of `owner` through {transferFrom}. This is
305      * zero by default.
306      *
307      * This value changes when {approve} or {transferFrom} are called.
308      */
309     function allowance(address owner, address spender) external view returns (uint256);
310 
311     /**
312      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
313      *
314      * Returns a boolean value indicating whether the operation succeeded.
315      *
316      * IMPORTANT: Beware that changing an allowance with this method brings the risk
317      * that someone may use both the old and the new allowance by unfortunate
318      * transaction ordering. One possible solution to mitigate this race
319      * condition is to first reduce the spender's allowance to 0 and set the
320      * desired value afterwards:
321      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
322      *
323      * Emits an {Approval} event.
324      */
325     function approve(address spender, uint256 amount) external returns (bool);
326 
327     /**
328      * @dev Moves `amount` tokens from `sender` to `recipient` using the
329      * allowance mechanism. `amount` is then deducted from the caller's
330      * allowance.
331      *
332      * Returns a boolean value indicating whether the operation succeeded.
333      *
334      * Emits a {Transfer} event.
335      */
336     function transferFrom(
337         address sender,
338         address recipient,
339         uint256 amount
340     ) external returns (bool);
341 
342     /**
343      * @dev Emitted when `value` tokens are moved from one account (`from`) to
344      * another (`to`).
345      *
346      * Note that `value` may be zero.
347      */
348     event Transfer(address indexed from, address indexed to, uint256 value);
349 
350     /**
351      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
352      * a call to {approve}. `value` is the new allowance.
353      */
354     event Approval(address indexed owner, address indexed spender, uint256 value);
355 }
356 
357 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
358 
359 
360 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
361 
362 pragma solidity ^0.8.0;
363 
364 
365 /**
366  * @dev Interface for the optional metadata functions from the ERC20 standard.
367  *
368  * _Available since v4.1._
369  */
370 interface IERC20Metadata is IERC20 {
371     /**
372      * @dev Returns the name of the token.
373      */
374     function name() external view returns (string memory);
375 
376     /**
377      * @dev Returns the symbol of the token.
378      */
379     function symbol() external view returns (string memory);
380 
381     /**
382      * @dev Returns the decimals places of the token.
383      */
384     function decimals() external view returns (uint8);
385 }
386 
387 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
388 
389 
390 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
391 
392 pragma solidity ^0.8.0;
393 
394 
395 
396 
397 /**
398  * @dev Implementation of the {IERC20} interface.
399  *
400  * This implementation is agnostic to the way tokens are created. This means
401  * that a supply mechanism has to be added in a derived contract using {_mint}.
402  * For a generic mechanism see {ERC20PresetMinterPauser}.
403  *
404  * TIP: For a detailed writeup see our guide
405  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
406  * to implement supply mechanisms].
407  *
408  * We have followed general OpenZeppelin Contracts guidelines: functions revert
409  * instead returning `false` on failure. This behavior is nonetheless
410  * conventional and does not conflict with the expectations of ERC20
411  * applications.
412  *
413  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
414  * This allows applications to reconstruct the allowance for all accounts just
415  * by listening to said events. Other implementations of the EIP may not emit
416  * these events, as it isn't required by the specification.
417  *
418  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
419  * functions have been added to mitigate the well-known issues around setting
420  * allowances. See {IERC20-approve}.
421  */
422 contract ERC20 is Context, IERC20, IERC20Metadata {
423     mapping(address => uint256) private _balances;
424 
425     mapping(address => mapping(address => uint256)) private _allowances;
426 
427     uint256 private _totalSupply;
428 
429     string private _name;
430     string private _symbol;
431 
432     /**
433      * @dev Sets the values for {name} and {symbol}.
434      *
435      * The default value of {decimals} is 18. To select a different value for
436      * {decimals} you should overload it.
437      *
438      * All two of these values are immutable: they can only be set once during
439      * construction.
440      */
441     constructor(string memory name_, string memory symbol_) {
442         _name = name_;
443         _symbol = symbol_;
444     }
445 
446     /**
447      * @dev Returns the name of the token.
448      */
449     function name() public view virtual override returns (string memory) {
450         return _name;
451     }
452 
453     /**
454      * @dev Returns the symbol of the token, usually a shorter version of the
455      * name.
456      */
457     function symbol() public view virtual override returns (string memory) {
458         return _symbol;
459     }
460 
461     /**
462      * @dev Returns the number of decimals used to get its user representation.
463      * For example, if `decimals` equals `2`, a balance of `505` tokens should
464      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
465      *
466      * Tokens usually opt for a value of 18, imitating the relationship between
467      * Ether and Wei. This is the value {ERC20} uses, unless this function is
468      * overridden;
469      *
470      * NOTE: This information is only used for _display_ purposes: it in
471      * no way affects any of the arithmetic of the contract, including
472      * {IERC20-balanceOf} and {IERC20-transfer}.
473      */
474     function decimals() public view virtual override returns (uint8) {
475         return 18;
476     }
477 
478     /**
479      * @dev See {IERC20-totalSupply}.
480      */
481     function totalSupply() public view virtual override returns (uint256) {
482         return _totalSupply;
483     }
484 
485     /**
486      * @dev See {IERC20-balanceOf}.
487      */
488     function balanceOf(address account) public view virtual override returns (uint256) {
489         return _balances[account];
490     }
491 
492     /**
493      * @dev See {IERC20-transfer}.
494      *
495      * Requirements:
496      *
497      * - `to` cannot be the zero address.
498      * - the caller must have a balance of at least `amount`.
499      */
500     function transfer(address to, uint256 amount) public virtual override returns (bool) {
501         address owner = _msgSender();
502         _transfer(owner, to, amount);
503         return true;
504     }
505 
506     /**
507      * @dev See {IERC20-allowance}.
508      */
509     function allowance(address owner, address spender) public view virtual override returns (uint256) {
510         return _allowances[owner][spender];
511     }
512 
513     /**
514      * @dev See {IERC20-approve}.
515      *
516      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
517      * `transferFrom`. This is semantically equivalent to an infinite approval.
518      *
519      * Requirements:
520      *
521      * - `spender` cannot be the zero address.
522      */
523     function approve(address spender, uint256 amount) public virtual override returns (bool) {
524         address owner = _msgSender();
525         _approve(owner, spender, amount);
526         return true;
527     }
528 
529     /**
530      * @dev See {IERC20-transferFrom}.
531      *
532      * Emits an {Approval} event indicating the updated allowance. This is not
533      * required by the EIP. See the note at the beginning of {ERC20}.
534      *
535      * NOTE: Does not update the allowance if the current allowance
536      * is the maximum `uint256`.
537      *
538      * Requirements:
539      *
540      * - `from` and `to` cannot be the zero address.
541      * - `from` must have a balance of at least `amount`.
542      * - the caller must have allowance for ``from``'s tokens of at least
543      * `amount`.
544      */
545     function transferFrom(
546         address from,
547         address to,
548         uint256 amount
549     ) public virtual override returns (bool) {
550         address spender = _msgSender();
551         _spendAllowance(from, spender, amount);
552         _transfer(from, to, amount);
553         return true;
554     }
555 
556     /**
557      * @dev Atomically increases the allowance granted to `spender` by the caller.
558      *
559      * This is an alternative to {approve} that can be used as a mitigation for
560      * problems described in {IERC20-approve}.
561      *
562      * Emits an {Approval} event indicating the updated allowance.
563      *
564      * Requirements:
565      *
566      * - `spender` cannot be the zero address.
567      */
568     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
569         address owner = _msgSender();
570         _approve(owner, spender, _allowances[owner][spender] + addedValue);
571         return true;
572     }
573 
574     /**
575      * @dev Atomically decreases the allowance granted to `spender` by the caller.
576      *
577      * This is an alternative to {approve} that can be used as a mitigation for
578      * problems described in {IERC20-approve}.
579      *
580      * Emits an {Approval} event indicating the updated allowance.
581      *
582      * Requirements:
583      *
584      * - `spender` cannot be the zero address.
585      * - `spender` must have allowance for the caller of at least
586      * `subtractedValue`.
587      */
588     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
589         address owner = _msgSender();
590         uint256 currentAllowance = _allowances[owner][spender];
591         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
592         unchecked {
593             _approve(owner, spender, currentAllowance - subtractedValue);
594         }
595 
596         return true;
597     }
598 
599     /**
600      * @dev Moves `amount` of tokens from `sender` to `recipient`.
601      *
602      * This internal function is equivalent to {transfer}, and can be used to
603      * e.g. implement automatic token fees, slashing mechanisms, etc.
604      *
605      * Emits a {Transfer} event.
606      *
607      * Requirements:
608      *
609      * - `from` cannot be the zero address.
610      * - `to` cannot be the zero address.
611      * - `from` must have a balance of at least `amount`.
612      */
613     function _transfer(
614         address from,
615         address to,
616         uint256 amount
617     ) internal virtual {
618         require(from != address(0), "ERC20: transfer from the zero address");
619         require(to != address(0), "ERC20: transfer to the zero address");
620 
621         _beforeTokenTransfer(from, to, amount);
622 
623         uint256 fromBalance = _balances[from];
624         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
625         unchecked {
626             _balances[from] = fromBalance - amount;
627         }
628         _balances[to] += amount;
629 
630         emit Transfer(from, to, amount);
631 
632         _afterTokenTransfer(from, to, amount);
633     }
634 
635     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
636      * the total supply.
637      *
638      * Emits a {Transfer} event with `from` set to the zero address.
639      *
640      * Requirements:
641      *
642      * - `account` cannot be the zero address.
643      */
644     function _mint(address account, uint256 amount) internal virtual {
645         require(account != address(0), "ERC20: mint to the zero address");
646 
647         _beforeTokenTransfer(address(0), account, amount);
648 
649         _totalSupply += amount;
650         _balances[account] += amount;
651         emit Transfer(address(0), account, amount);
652 
653         _afterTokenTransfer(address(0), account, amount);
654     }
655 
656     /**
657      * @dev Destroys `amount` tokens from `account`, reducing the
658      * total supply.
659      *
660      * Emits a {Transfer} event with `to` set to the zero address.
661      *
662      * Requirements:
663      *
664      * - `account` cannot be the zero address.
665      * - `account` must have at least `amount` tokens.
666      */
667     function _burn(address account, uint256 amount) internal virtual {
668         require(account != address(0), "ERC20: burn from the zero address");
669 
670         _beforeTokenTransfer(account, address(0), amount);
671 
672         uint256 accountBalance = _balances[account];
673         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
674         unchecked {
675             _balances[account] = accountBalance - amount;
676         }
677         _totalSupply -= amount;
678 
679         emit Transfer(account, address(0), amount);
680 
681         _afterTokenTransfer(account, address(0), amount);
682     }
683 
684     /**
685      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
686      *
687      * This internal function is equivalent to `approve`, and can be used to
688      * e.g. set automatic allowances for certain subsystems, etc.
689      *
690      * Emits an {Approval} event.
691      *
692      * Requirements:
693      *
694      * - `owner` cannot be the zero address.
695      * - `spender` cannot be the zero address.
696      */
697     function _approve(
698         address owner,
699         address spender,
700         uint256 amount
701     ) internal virtual {
702         require(owner != address(0), "ERC20: approve from the zero address");
703         require(spender != address(0), "ERC20: approve to the zero address");
704 
705         _allowances[owner][spender] = amount;
706         emit Approval(owner, spender, amount);
707     }
708 
709     /**
710      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
711      *
712      * Does not update the allowance amount in case of infinite allowance.
713      * Revert if not enough allowance is available.
714      *
715      * Might emit an {Approval} event.
716      */
717     function _spendAllowance(
718         address owner,
719         address spender,
720         uint256 amount
721     ) internal virtual {
722         uint256 currentAllowance = allowance(owner, spender);
723         if (currentAllowance != type(uint256).max) {
724             require(currentAllowance >= amount, "ERC20: insufficient allowance");
725             unchecked {
726                 _approve(owner, spender, currentAllowance - amount);
727             }
728         }
729     }
730 
731     /**
732      * @dev Hook that is called before any transfer of tokens. This includes
733      * minting and burning.
734      *
735      * Calling conditions:
736      *
737      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
738      * will be transferred to `to`.
739      * - when `from` is zero, `amount` tokens will be minted for `to`.
740      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
741      * - `from` and `to` are never both zero.
742      *
743      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
744      */
745     function _beforeTokenTransfer(
746         address from,
747         address to,
748         uint256 amount
749     ) internal virtual {}
750 
751     /**
752      * @dev Hook that is called after any transfer of tokens. This includes
753      * minting and burning.
754      *
755      * Calling conditions:
756      *
757      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
758      * has been transferred to `to`.
759      * - when `from` is zero, `amount` tokens have been minted for `to`.
760      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
761      * - `from` and `to` are never both zero.
762      *
763      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
764      */
765     function _afterTokenTransfer(
766         address from,
767         address to,
768         uint256 amount
769     ) internal virtual {}
770 }
771 
772 // File: BRLv2.sol
773 
774 
775 
776 pragma solidity ^0.8.9;
777 
778 
779 
780 
781 
782 contract BullRunFeeHandler is Ownable {
783 
784     IUniswapV2Router02 public immutable uniswapV2Router;
785     IERC20 public usdc;
786     IERC20 public brlToken;
787 
788     address public marketingWallet;
789     address public opsWallet;
790 
791     uint256 residualTokens;
792 
793     event SwapAndLiquify(uint256 tokensSwapped,uint256 ethReceived,uint256 tokensIntoLiqudity);
794 
795     constructor(address _brlToken, address _marketingWallet, address _opsWallet) {
796         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
797 
798         uniswapV2Router = _uniswapV2Router;
799 
800         brlToken = IERC20(_brlToken);
801         marketingWallet = _marketingWallet;
802         opsWallet = _opsWallet;
803 
804         usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
805         IERC20(usdc).approve(address(_uniswapV2Router), type(uint256).max);
806 
807     }
808 
809     function processFees(uint256 liquidityTokens, uint256 opsTokens, uint256 marketingTokens) external onlyOwner {
810 
811         liquidityTokens += residualTokens;
812         residualTokens = 0;
813         uint256 half = liquidityTokens / 2;
814         uint256 otherHalf = liquidityTokens - half;
815 
816         uint256 total = half + opsTokens + marketingTokens;
817 
818         IERC20(brlToken).approve(address(uniswapV2Router), total + otherHalf);
819 
820         address[] memory path = new address[](2);
821         path[0] = address(brlToken);
822         path[1] = address(usdc);
823 
824         // make the swap
825         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
826             total,
827             0, // accept any amount of USDC
828             path,
829             address(this),
830             block.timestamp
831         );
832 
833         uint256 usdcBalance = IERC20(usdc).balanceOf(address(this));
834         uint256 liquidity = usdcBalance * half / total;
835         uint256 marketing = usdcBalance * marketingTokens / total;
836         uint256 ops = usdcBalance - liquidity - marketing;
837 
838         (uint256 amountA,,) = uniswapV2Router.addLiquidity(
839             address(brlToken),
840             address(usdc),
841             otherHalf,
842             liquidity,
843             0,
844             0,
845             address(0xdead),
846             block.timestamp
847         );
848         residualTokens += (otherHalf - amountA);
849 
850         emit SwapAndLiquify(half, liquidity, otherHalf);
851 
852         usdc.transfer(marketingWallet, marketing);
853         usdc.transfer(opsWallet, ops);
854 
855     }
856 
857     function updateMarketingWallet(address newWallet) external onlyOwner {
858         marketingWallet = newWallet;
859     }
860 
861     function updateOpsWallet(address newWallet) external onlyOwner {
862         opsWallet = newWallet;
863     }
864 
865 }
866 
867 error InvalidTransfer(address from, address to);
868 error TransferDelayEnabled(uint256 currentBlock, uint256 enabledBlock);
869 error ExceedsMaxTxAmount(uint256 attempt, uint256 max);
870 error ExceedsMaxWalletAmount(uint256 attempt, uint256 max);
871 error InvalidConfiguration();
872 error TradingNotEnabled();
873 
874 contract BullRun is ERC20, Ownable {
875 
876     mapping (address => bool) private _isExcludedFromFees;
877     mapping (address => bool) public _isExcludedMaxTransactionAmount;
878     mapping (address => bool) public _isExcludedFromDelay;
879     mapping (address => bool) public _isBlacklisted;
880     mapping (address => uint256) private _holderLastTxBlock;
881 
882     IUniswapV2Router02 public uniswapV2Router;
883     address public immutable uniswapV2Pair;
884 
885     BullRunFeeHandler public brlFeeHandler;
886 
887     bool private swapping;
888     bool public swapEnabled = true;
889     bool public isTradingEnabled;
890 
891     uint256 public burnBuyFee = 100;
892     uint256 public liquidityBuyFee = 400;
893     uint256 public opsBuyFee = 300;
894     uint256 public marketingBuyFee = 200;
895     uint256 public totalBuyFees = 1000;
896 
897     uint256 public burnSellFee = 100;
898     uint256 public liquiditySellFee = 500;
899     uint256 public opsSellFee = 300;
900     uint256 public marketingSellFee = 300;
901     uint256 public totalSellFees = 1200;
902 
903     uint256 public liquidityTokens;
904     uint256 public opsTokens;
905     uint256 public marketingTokens;
906 
907     uint256 public maxTransactionAmount = 5000 * 10**18; //0.5% of total supply
908     uint256 public swapTokensAtAmount = 500 * 10**18; //0.05% of total supply
909     uint256 public maxWallet = 10000 * 10**18; //1% of total supply
910 
911     uint256 public buyDelay = 2;
912     uint256 public sellDelay = 5;
913     uint256 public transferDelay = 1;
914 
915     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
916     event SwapAndLiquifyEnabledUpdated(bool enabled);
917     event UpdateFeeHandler(address indexed newAddress, address indexed oldAddress);
918 
919     constructor(address _marketingWallet, address _opsWallet) ERC20("BullRun", "BRL") {
920         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
921 
922         uniswapV2Router = _uniswapV2Router;
923 
924         address usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
925 
926         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
927             .createPair(address(this), usdc);
928 
929         brlFeeHandler = new BullRunFeeHandler(address(this), _marketingWallet, _opsWallet);
930 
931         _isBlacklisted[address(0)] = true;
932 
933         _isExcludedFromFees[owner()] = true;
934         _isExcludedFromFees[address(this)] = true;
935         _isExcludedFromFees[address(brlFeeHandler)] = true;
936         _isExcludedFromFees[address(0xdead)] = true;
937 
938         _isExcludedMaxTransactionAmount[owner()] = true;
939         _isExcludedMaxTransactionAmount[address(this)] = true;
940         _isExcludedMaxTransactionAmount[address(brlFeeHandler)] = true;
941         _isExcludedMaxTransactionAmount[address(0xdead)] = true;
942 
943         _isExcludedMaxTransactionAmount[address(_uniswapV2Router)] = true;
944         _isExcludedMaxTransactionAmount[address(uniswapV2Pair)] = true;
945 
946         _mint(owner(), 10**6 * 10**18);
947     }
948 
949     function _transfer(
950         address from,
951         address to,
952         uint256 amount
953     ) internal override {
954         if (_isBlacklisted[from] || _isBlacklisted[to]) {
955             revert InvalidTransfer(from, to);
956         }
957 
958         if(amount == 0) {
959             super._transfer(from, to, 0);
960             return;
961         }
962 
963         if (
964             from != owner() &&
965             to != owner() &&
966             to != address(0xdead) &&
967             !swapping
968         ){
969 
970             if (!isTradingEnabled) {
971                revert TradingNotEnabled();
972             }
973 
974             uint256 delayedUntil = _holderLastTxBlock[tx.origin];
975             if (from == uniswapV2Pair) {
976                 delayedUntil += buyDelay;
977             } else if (to == uniswapV2Pair) {
978                 delayedUntil += sellDelay;
979             } else if (!_isExcludedFromDelay[from] && !_isExcludedFromDelay[to]) {
980                 delayedUntil += transferDelay;
981             }
982 
983             if (delayedUntil > block.number) {
984                 revert TransferDelayEnabled(block.number, delayedUntil);
985             }
986             _holderLastTxBlock[tx.origin] = block.number;
987 
988             if (from == uniswapV2Pair && !_isExcludedMaxTransactionAmount[to]) { //buys
989                 if (amount > maxTransactionAmount) {
990                     revert ExceedsMaxTxAmount(amount, maxTransactionAmount);
991                 }
992                 uint256 potentialBalance = amount + balanceOf(to);
993                 if (potentialBalance > maxWallet) {
994                     revert ExceedsMaxWalletAmount(potentialBalance, maxWallet);
995                 }
996 
997             } else if (to == uniswapV2Pair && !_isExcludedMaxTransactionAmount[from]) { //sells
998                 if (amount > maxTransactionAmount) {
999                     revert ExceedsMaxTxAmount(amount, maxTransactionAmount);
1000                 }
1001             } else if(!_isExcludedMaxTransactionAmount[to]){
1002                 uint256 potentialBalance = amount + balanceOf(to);
1003                 if (potentialBalance > maxWallet) {
1004                     revert ExceedsMaxWalletAmount(potentialBalance, maxWallet);
1005                 }
1006             }
1007         }
1008 
1009 		    bool canSwap = balanceOf(address(brlFeeHandler)) >= swapTokensAtAmount;
1010 
1011         if (
1012             canSwap &&
1013             !swapping &&
1014             swapEnabled &&
1015             from != uniswapV2Pair &&
1016             !_isExcludedFromFees[from] &&
1017             !_isExcludedFromFees[to]
1018         ) {
1019             swapping = true;
1020 
1021             uint256 total = liquidityTokens + opsTokens + marketingTokens;
1022             uint256 liqToSwap = swapTokensAtAmount * liquidityTokens / total;
1023             uint256 opsToSwap = swapTokensAtAmount * opsTokens / total;
1024             uint256 marToSwap = swapTokensAtAmount * marketingTokens / total;
1025 
1026             brlFeeHandler.processFees(liqToSwap, opsToSwap, marToSwap);
1027 
1028             liquidityTokens -= liqToSwap;
1029             marketingTokens -= marToSwap;
1030             opsTokens -= opsToSwap;
1031 
1032             swapping = false;
1033         }
1034 
1035         if(!swapping && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
1036             uint256 fees;
1037             uint256 burnTokens;
1038             if (to == uniswapV2Pair && totalSellFees != 0) { //sell
1039                 fees = amount * totalSellFees / 10000;
1040                 burnTokens += fees * burnSellFee / totalSellFees;
1041                 liquidityTokens += fees * liquiditySellFee / totalSellFees;
1042                 opsTokens += fees * opsSellFee / totalSellFees;
1043                 marketingTokens += fees * marketingSellFee / totalSellFees;
1044             } else if (from == uniswapV2Pair && totalBuyFees != 0) { //buy
1045                 fees = amount * totalBuyFees / 10000;
1046                 burnTokens += fees * burnBuyFee / totalBuyFees;
1047                 liquidityTokens += fees * liquidityBuyFee / totalBuyFees;
1048                 opsTokens += fees * opsBuyFee / totalBuyFees;
1049                 marketingTokens += fees * marketingBuyFee / totalBuyFees;
1050             }
1051             if (fees > 0) {
1052                 amount -= fees;
1053                 super._transfer(from, address(brlFeeHandler), fees);
1054                 super._burn(address(brlFeeHandler), burnTokens);
1055             }
1056 
1057         }
1058 
1059         super._transfer(from, to, amount);
1060 
1061     }
1062 
1063     function setBlacklist(address account, bool value) external onlyOwner {
1064         _isBlacklisted[account] = value;
1065     }
1066 
1067     function blacklistMany(address[] memory accounts) external onlyOwner {
1068         uint256 len = accounts.length;
1069         for (uint256 i = 0; i < len; i++) {
1070             _isBlacklisted[accounts[i]] = true;
1071         }
1072     }
1073 
1074     function updateDelayBlocks(uint256 _buy, uint256 _sell, uint256 _tx) external onlyOwner {
1075         buyDelay = _buy;
1076         sellDelay = _sell;
1077         transferDelay = _tx;
1078     }
1079 
1080     function setExcludedFromMaxTransaction(address account, bool value) public onlyOwner {
1081         _isExcludedMaxTransactionAmount[account] = value;
1082     }
1083 
1084     function excludeManyFromMaxTransaction(address[] memory accounts) public onlyOwner {
1085         uint256 len = accounts.length;
1086         for (uint256 i = 0; i < len; i++) {
1087             _isExcludedMaxTransactionAmount[accounts[i]] = true;
1088         }
1089     }
1090 
1091     function setExcludedFromFees(address account, bool value) public onlyOwner {
1092         _isExcludedFromFees[account] = value;
1093     }
1094 
1095     function excludeManyFromFees(address[] memory accounts) public onlyOwner {
1096         uint256 len = accounts.length;
1097         for (uint256 i = 0; i < len; i++) {
1098             _isExcludedFromFees[accounts[i]] = true;
1099         }
1100     }
1101 
1102     function setExcludedFromDelay(address account, bool value) public onlyOwner {
1103         _isExcludedFromDelay[account] = value;
1104     }
1105 
1106     function setSellFees(uint256 burn, uint256 liquidity, uint256 ops, uint256 marketing) external onlyOwner {
1107         uint256 total = burn + liquidity + ops + marketing;
1108         if (total > 2500) {
1109             revert InvalidConfiguration();
1110         }
1111         burnSellFee = burn;
1112         liquiditySellFee = liquidity;
1113         opsSellFee = ops;
1114         marketingSellFee = marketing;
1115         totalSellFees = total;
1116     }
1117 
1118     function setBuyFees(uint256 burn, uint256 liquidity, uint256 ops, uint256 marketing) external onlyOwner {
1119         uint256 total = burn + liquidity + ops + marketing;
1120         if (total > 2500) {
1121             revert InvalidConfiguration();
1122         }
1123         burnBuyFee = burn;
1124         liquidityBuyFee = liquidity;
1125         opsBuyFee = ops;
1126         marketingBuyFee = marketing;
1127         totalBuyFees = total;
1128     }
1129 
1130     function airdrop(address[] memory _user, uint256[] memory _amount) external onlyOwner {
1131         uint256 len = _user.length;
1132         if (len != _amount.length) {
1133             revert InvalidConfiguration();
1134         }
1135         for (uint256 i = 0; i < len; i++) {
1136             super._transfer(_msgSender(), _user[i], _amount[i]);
1137         }
1138     }
1139 
1140     function setSwapAtAmount(uint256 amount) external onlyOwner {
1141         swapTokensAtAmount = amount;
1142     }
1143 
1144     function setMaxTxAmount(uint256 _maxTxAmt) external onlyOwner() {
1145         maxTransactionAmount = _maxTxAmt;
1146     }
1147 
1148     function setMaxWalletSize(uint256 _maxWalletSize) external onlyOwner() {
1149         maxWallet = _maxWalletSize;
1150     }
1151 
1152     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1153         swapEnabled = _enabled;
1154         emit SwapAndLiquifyEnabledUpdated(_enabled);
1155     }
1156 
1157     function updateMarketingWallet(address newWallet) external onlyOwner {
1158         brlFeeHandler.updateMarketingWallet(newWallet);
1159     }
1160 
1161     function updateOpsWallet(address newWallet) external onlyOwner {
1162         brlFeeHandler.updateOpsWallet(newWallet);
1163     }
1164 
1165     function enableTrading() external onlyOwner {
1166         if (isTradingEnabled) {
1167             revert InvalidConfiguration();
1168         }
1169         isTradingEnabled = true;
1170     }
1171 
1172     function updateFeeHandler(address newAddress) public onlyOwner {
1173         if (newAddress == address(brlFeeHandler)) {
1174             revert InvalidConfiguration();
1175         }
1176 
1177         BullRunFeeHandler newFeeHandler = BullRunFeeHandler(newAddress);
1178 
1179         if (newFeeHandler.owner() != address(this)) {
1180             revert InvalidConfiguration();
1181         }
1182 
1183         setExcludedFromMaxTransaction(address(newFeeHandler), true);
1184         setExcludedFromFees(address(newFeeHandler), true);
1185 
1186         brlFeeHandler = newFeeHandler;
1187 
1188         emit UpdateFeeHandler(newAddress, address(brlFeeHandler));
1189     }
1190 
1191 }