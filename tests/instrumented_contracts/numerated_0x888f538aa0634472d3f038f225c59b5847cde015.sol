1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity 0.8.9;
3 
4 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
5 
6 pragma solidity >=0.5.0;
7 
8 interface IUniswapV2Factory {
9     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
10 
11     function feeTo() external view returns (address);
12     function feeToSetter() external view returns (address);
13 
14     function getPair(address tokenA, address tokenB) external view returns (address pair);
15     function allPairs(uint) external view returns (address pair);
16     function allPairsLength() external view returns (uint);
17 
18     function createPair(address tokenA, address tokenB) external returns (address pair);
19 
20     function setFeeTo(address) external;
21     function setFeeToSetter(address) external;
22 }
23 
24 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
25 
26 pragma solidity >=0.6.2;
27 
28 interface IUniswapV2Router01 {
29     function factory() external pure returns (address);
30     function WETH() external pure returns (address);
31 
32     function addLiquidity(
33         address tokenA,
34         address tokenB,
35         uint amountADesired,
36         uint amountBDesired,
37         uint amountAMin,
38         uint amountBMin,
39         address to,
40         uint deadline
41     ) external returns (uint amountA, uint amountB, uint liquidity);
42     function addLiquidityETH(
43         address token,
44         uint amountTokenDesired,
45         uint amountTokenMin,
46         uint amountETHMin,
47         address to,
48         uint deadline
49     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
50     function removeLiquidity(
51         address tokenA,
52         address tokenB,
53         uint liquidity,
54         uint amountAMin,
55         uint amountBMin,
56         address to,
57         uint deadline
58     ) external returns (uint amountA, uint amountB);
59     function removeLiquidityETH(
60         address token,
61         uint liquidity,
62         uint amountTokenMin,
63         uint amountETHMin,
64         address to,
65         uint deadline
66     ) external returns (uint amountToken, uint amountETH);
67     function removeLiquidityWithPermit(
68         address tokenA,
69         address tokenB,
70         uint liquidity,
71         uint amountAMin,
72         uint amountBMin,
73         address to,
74         uint deadline,
75         bool approveMax, uint8 v, bytes32 r, bytes32 s
76     ) external returns (uint amountA, uint amountB);
77     function removeLiquidityETHWithPermit(
78         address token,
79         uint liquidity,
80         uint amountTokenMin,
81         uint amountETHMin,
82         address to,
83         uint deadline,
84         bool approveMax, uint8 v, bytes32 r, bytes32 s
85     ) external returns (uint amountToken, uint amountETH);
86     function swapExactTokensForTokens(
87         uint amountIn,
88         uint amountOutMin,
89         address[] calldata path,
90         address to,
91         uint deadline
92     ) external returns (uint[] memory amounts);
93     function swapTokensForExactTokens(
94         uint amountOut,
95         uint amountInMax,
96         address[] calldata path,
97         address to,
98         uint deadline
99     ) external returns (uint[] memory amounts);
100     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
101         external
102         payable
103         returns (uint[] memory amounts);
104     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
105         external
106         returns (uint[] memory amounts);
107     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
108         external
109         returns (uint[] memory amounts);
110     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
111         external
112         payable
113         returns (uint[] memory amounts);
114 
115     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
116     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
117     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
118     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
119     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
120 }
121 
122 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
123 
124 pragma solidity >=0.6.2;
125 
126 
127 interface IUniswapV2Router02 is IUniswapV2Router01 {
128     function removeLiquidityETHSupportingFeeOnTransferTokens(
129         address token,
130         uint liquidity,
131         uint amountTokenMin,
132         uint amountETHMin,
133         address to,
134         uint deadline
135     ) external returns (uint amountETH);
136     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
137         address token,
138         uint liquidity,
139         uint amountTokenMin,
140         uint amountETHMin,
141         address to,
142         uint deadline,
143         bool approveMax, uint8 v, bytes32 r, bytes32 s
144     ) external returns (uint amountETH);
145 
146     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
147         uint amountIn,
148         uint amountOutMin,
149         address[] calldata path,
150         address to,
151         uint deadline
152     ) external;
153     function swapExactETHForTokensSupportingFeeOnTransferTokens(
154         uint amountOutMin,
155         address[] calldata path,
156         address to,
157         uint deadline
158     ) external payable;
159     function swapExactTokensForETHSupportingFeeOnTransferTokens(
160         uint amountIn,
161         uint amountOutMin,
162         address[] calldata path,
163         address to,
164         uint deadline
165     ) external;
166 }
167 
168 // File: @openzeppelin/contracts/utils/Context.sol
169 
170 
171 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
172 
173 pragma solidity ^0.8.0;
174 
175 /**
176  * @dev Provides information about the current execution context, including the
177  * sender of the transaction and its data. While these are generally available
178  * via msg.sender and msg.data, they should not be accessed in such a direct
179  * manner, since when dealing with meta-transactions the account sending and
180  * paying for execution may not be the actual sender (as far as an application
181  * is concerned).
182  *
183  * This contract is only required for intermediate, library-like contracts.
184  */
185 abstract contract Context {
186     function _msgSender() internal view virtual returns (address) {
187         return msg.sender;
188     }
189 
190     function _msgData() internal view virtual returns (bytes calldata) {
191         return msg.data;
192     }
193 }
194 
195 // File: @openzeppelin/contracts/access/Ownable.sol
196 
197 
198 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
199 
200 pragma solidity ^0.8.0;
201 
202 
203 /**
204  * @dev Contract module which provides a basic access control mechanism, where
205  * there is an account (an owner) that can be granted exclusive access to
206  * specific functions.
207  *
208  * By default, the owner account will be the one that deploys the contract. This
209  * can later be changed with {transferOwnership}.
210  *
211  * This module is used through inheritance. It will make available the modifier
212  * `onlyOwner`, which can be applied to your functions to restrict their use to
213  * the owner.
214  */
215 abstract contract Ownable is Context {
216     address private _owner;
217 
218     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
219 
220     /**
221      * @dev Initializes the contract setting the deployer as the initial owner.
222      */
223     constructor() {
224         _transferOwnership(_msgSender());
225     }
226 
227     /**
228      * @dev Returns the address of the current owner.
229      */
230     function owner() public view virtual returns (address) {
231         return _owner;
232     }
233 
234     /**
235      * @dev Throws if called by any account other than the owner.
236      */
237     modifier onlyOwner() {
238         require(owner() == _msgSender(), "Ownable: caller is not the owner");
239         _;
240     }
241 
242     /**
243      * @dev Leaves the contract without owner. It will not be possible to call
244      * `onlyOwner` functions anymore. Can only be called by the current owner.
245      *
246      * NOTE: Renouncing ownership will leave the contract without an owner,
247      * thereby removing any functionality that is only available to the owner.
248      */
249     function renounceOwnership() public virtual onlyOwner {
250         _transferOwnership(address(0));
251     }
252 
253     /**
254      * @dev Transfers ownership of the contract to a new account (`newOwner`).
255      * Can only be called by the current owner.
256      */
257     function transferOwnership(address newOwner) public virtual onlyOwner {
258         require(newOwner != address(0), "Ownable: new owner is the zero address");
259         _transferOwnership(newOwner);
260     }
261 
262     /**
263      * @dev Transfers ownership of the contract to a new account (`newOwner`).
264      * Internal function without access restriction.
265      */
266     function _transferOwnership(address newOwner) internal virtual {
267         address oldOwner = _owner;
268         _owner = newOwner;
269         emit OwnershipTransferred(oldOwner, newOwner);
270     }
271 }
272 
273 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
274 
275 
276 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
277 
278 pragma solidity ^0.8.0;
279 
280 /**
281  * @dev Interface of the ERC20 standard as defined in the EIP.
282  */
283 interface IERC20 {
284     /**
285      * @dev Returns the amount of tokens in existence.
286      */
287     function totalSupply() external view returns (uint256);
288 
289     /**
290      * @dev Returns the amount of tokens owned by `account`.
291      */
292     function balanceOf(address account) external view returns (uint256);
293 
294     /**
295      * @dev Moves `amount` tokens from the caller's account to `recipient`.
296      *
297      * Returns a boolean value indicating whether the operation succeeded.
298      *
299      * Emits a {Transfer} event.
300      */
301     function transfer(address recipient, uint256 amount) external returns (bool);
302 
303     /**
304      * @dev Returns the remaining number of tokens that `spender` will be
305      * allowed to spend on behalf of `owner` through {transferFrom}. This is
306      * zero by default.
307      *
308      * This value changes when {approve} or {transferFrom} are called.
309      */
310     function allowance(address owner, address spender) external view returns (uint256);
311 
312     /**
313      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
314      *
315      * Returns a boolean value indicating whether the operation succeeded.
316      *
317      * IMPORTANT: Beware that changing an allowance with this method brings the risk
318      * that someone may use both the old and the new allowance by unfortunate
319      * transaction ordering. One possible solution to mitigate this race
320      * condition is to first reduce the spender's allowance to 0 and set the
321      * desired value afterwards:
322      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
323      *
324      * Emits an {Approval} event.
325      */
326     function approve(address spender, uint256 amount) external returns (bool);
327 
328     /**
329      * @dev Moves `amount` tokens from `sender` to `recipient` using the
330      * allowance mechanism. `amount` is then deducted from the caller's
331      * allowance.
332      *
333      * Returns a boolean value indicating whether the operation succeeded.
334      *
335      * Emits a {Transfer} event.
336      */
337     function transferFrom(
338         address sender,
339         address recipient,
340         uint256 amount
341     ) external returns (bool);
342 
343     /**
344      * @dev Emitted when `value` tokens are moved from one account (`from`) to
345      * another (`to`).
346      *
347      * Note that `value` may be zero.
348      */
349     event Transfer(address indexed from, address indexed to, uint256 value);
350 
351     /**
352      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
353      * a call to {approve}. `value` is the new allowance.
354      */
355     event Approval(address indexed owner, address indexed spender, uint256 value);
356 }
357 
358 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
359 
360 
361 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
362 
363 pragma solidity ^0.8.0;
364 
365 
366 /**
367  * @dev Interface for the optional metadata functions from the ERC20 standard.
368  *
369  * _Available since v4.1._
370  */
371 interface IERC20Metadata is IERC20 {
372     /**
373      * @dev Returns the name of the token.
374      */
375     function name() external view returns (string memory);
376 
377     /**
378      * @dev Returns the symbol of the token.
379      */
380     function symbol() external view returns (string memory);
381 
382     /**
383      * @dev Returns the decimals places of the token.
384      */
385     function decimals() external view returns (uint8);
386 }
387 
388 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
389 
390 
391 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
392 
393 pragma solidity ^0.8.0;
394 
395 
396 
397 
398 /**
399  * @dev Implementation of the {IERC20} interface.
400  *
401  * This implementation is agnostic to the way tokens are created. This means
402  * that a supply mechanism has to be added in a derived contract using {_mint}.
403  * For a generic mechanism see {ERC20PresetMinterPauser}.
404  *
405  * TIP: For a detailed writeup see our guide
406  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
407  * to implement supply mechanisms].
408  *
409  * We have followed general OpenZeppelin Contracts guidelines: functions revert
410  * instead returning `false` on failure. This behavior is nonetheless
411  * conventional and does not conflict with the expectations of ERC20
412  * applications.
413  *
414  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
415  * This allows applications to reconstruct the allowance for all accounts just
416  * by listening to said events. Other implementations of the EIP may not emit
417  * these events, as it isn't required by the specification.
418  *
419  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
420  * functions have been added to mitigate the well-known issues around setting
421  * allowances. See {IERC20-approve}.
422  */
423 contract ERC20 is Context, IERC20, IERC20Metadata {
424     mapping(address => uint256) private _balances;
425 
426     mapping(address => mapping(address => uint256)) private _allowances;
427 
428     uint256 private _totalSupply;
429 
430     string private _name;
431     string private _symbol;
432 
433     /**
434      * @dev Sets the values for {name} and {symbol}.
435      *
436      * The default value of {decimals} is 18. To select a different value for
437      * {decimals} you should overload it.
438      *
439      * All two of these values are immutable: they can only be set once during
440      * construction.
441      */
442     constructor(string memory name_, string memory symbol_) {
443         _name = name_;
444         _symbol = symbol_;
445     }
446 
447     /**
448      * @dev Returns the name of the token.
449      */
450     function name() public view virtual override returns (string memory) {
451         return _name;
452     }
453 
454     /**
455      * @dev Returns the symbol of the token, usually a shorter version of the
456      * name.
457      */
458     function symbol() public view virtual override returns (string memory) {
459         return _symbol;
460     }
461 
462     /**
463      * @dev Returns the number of decimals used to get its user representation.
464      * For example, if `decimals` equals `2`, a balance of `505` tokens should
465      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
466      *
467      * Tokens usually opt for a value of 18, imitating the relationship between
468      * Ether and Wei. This is the value {ERC20} uses, unless this function is
469      * overridden;
470      *
471      * NOTE: This information is only used for _display_ purposes: it in
472      * no way affects any of the arithmetic of the contract, including
473      * {IERC20-balanceOf} and {IERC20-transfer}.
474      */
475     function decimals() public view virtual override returns (uint8) {
476         return 18;
477     }
478 
479     /**
480      * @dev See {IERC20-totalSupply}.
481      */
482     function totalSupply() public view virtual override returns (uint256) {
483         return _totalSupply;
484     }
485 
486     /**
487      * @dev See {IERC20-balanceOf}.
488      */
489     function balanceOf(address account) public view virtual override returns (uint256) {
490         return _balances[account];
491     }
492 
493     /**
494      * @dev See {IERC20-transfer}.
495      *
496      * Requirements:
497      *
498      * - `to` cannot be the zero address.
499      * - the caller must have a balance of at least `amount`.
500      */
501     function transfer(address to, uint256 amount) public virtual override returns (bool) {
502         address owner = _msgSender();
503         _transfer(owner, to, amount);
504         return true;
505     }
506 
507     /**
508      * @dev See {IERC20-allowance}.
509      */
510     function allowance(address owner, address spender) public view virtual override returns (uint256) {
511         return _allowances[owner][spender];
512     }
513 
514     /**
515      * @dev See {IERC20-approve}.
516      *
517      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
518      * `transferFrom`. This is semantically equivalent to an infinite approval.
519      *
520      * Requirements:
521      *
522      * - `spender` cannot be the zero address.
523      */
524     function approve(address spender, uint256 amount) public virtual override returns (bool) {
525         address owner = _msgSender();
526         _approve(owner, spender, amount);
527         return true;
528     }
529 
530     /**
531      * @dev See {IERC20-transferFrom}.
532      *
533      * Emits an {Approval} event indicating the updated allowance. This is not
534      * required by the EIP. See the note at the beginning of {ERC20}.
535      *
536      * NOTE: Does not update the allowance if the current allowance
537      * is the maximum `uint256`.
538      *
539      * Requirements:
540      *
541      * - `from` and `to` cannot be the zero address.
542      * - `from` must have a balance of at least `amount`.
543      * - the caller must have allowance for ``from``'s tokens of at least
544      * `amount`.
545      */
546     function transferFrom(
547         address from,
548         address to,
549         uint256 amount
550     ) public virtual override returns (bool) {
551         address spender = _msgSender();
552         _spendAllowance(from, spender, amount);
553         _transfer(from, to, amount);
554         return true;
555     }
556 
557     /**
558      * @dev Atomically increases the allowance granted to `spender` by the caller.
559      *
560      * This is an alternative to {approve} that can be used as a mitigation for
561      * problems described in {IERC20-approve}.
562      *
563      * Emits an {Approval} event indicating the updated allowance.
564      *
565      * Requirements:
566      *
567      * - `spender` cannot be the zero address.
568      */
569     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
570         address owner = _msgSender();
571         _approve(owner, spender, _allowances[owner][spender] + addedValue);
572         return true;
573     }
574 
575     /**
576      * @dev Atomically decreases the allowance granted to `spender` by the caller.
577      *
578      * This is an alternative to {approve} that can be used as a mitigation for
579      * problems described in {IERC20-approve}.
580      *
581      * Emits an {Approval} event indicating the updated allowance.
582      *
583      * Requirements:
584      *
585      * - `spender` cannot be the zero address.
586      * - `spender` must have allowance for the caller of at least
587      * `subtractedValue`.
588      */
589     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
590         address owner = _msgSender();
591         uint256 currentAllowance = _allowances[owner][spender];
592         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
593         unchecked {
594             _approve(owner, spender, currentAllowance - subtractedValue);
595         }
596 
597         return true;
598     }
599 
600     /**
601      * @dev Moves `amount` of tokens from `sender` to `recipient`.
602      *
603      * This internal function is equivalent to {transfer}, and can be used to
604      * e.g. implement automatic token fees, slashing mechanisms, etc.
605      *
606      * Emits a {Transfer} event.
607      *
608      * Requirements:
609      *
610      * - `from` cannot be the zero address.
611      * - `to` cannot be the zero address.
612      * - `from` must have a balance of at least `amount`.
613      */
614     function _transfer(
615         address from,
616         address to,
617         uint256 amount
618     ) internal virtual {
619         require(from != address(0), "ERC20: transfer from the zero address");
620         require(to != address(0), "ERC20: transfer to the zero address");
621 
622         _beforeTokenTransfer(from, to, amount);
623 
624         uint256 fromBalance = _balances[from];
625         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
626         unchecked {
627             _balances[from] = fromBalance - amount;
628         }
629         _balances[to] += amount;
630 
631         emit Transfer(from, to, amount);
632 
633         _afterTokenTransfer(from, to, amount);
634     }
635 
636     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
637      * the total supply.
638      *
639      * Emits a {Transfer} event with `from` set to the zero address.
640      *
641      * Requirements:
642      *
643      * - `account` cannot be the zero address.
644      */
645     function _mint(address account, uint256 amount) internal virtual {
646         require(account != address(0), "ERC20: mint to the zero address");
647 
648         _beforeTokenTransfer(address(0), account, amount);
649 
650         _totalSupply += amount;
651         _balances[account] += amount;
652         emit Transfer(address(0), account, amount);
653 
654         _afterTokenTransfer(address(0), account, amount);
655     }
656 
657     /**
658      * @dev Destroys `amount` tokens from `account`, reducing the
659      * total supply.
660      *
661      * Emits a {Transfer} event with `to` set to the zero address.
662      *
663      * Requirements:
664      *
665      * - `account` cannot be the zero address.
666      * - `account` must have at least `amount` tokens.
667      */
668     function _burn(address account, uint256 amount) internal virtual {
669         require(account != address(0), "ERC20: burn from the zero address");
670 
671         _beforeTokenTransfer(account, address(0), amount);
672 
673         uint256 accountBalance = _balances[account];
674         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
675         unchecked {
676             _balances[account] = accountBalance - amount;
677         }
678         _totalSupply -= amount;
679 
680         emit Transfer(account, address(0), amount);
681 
682         _afterTokenTransfer(account, address(0), amount);
683     }
684 
685     /**
686      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
687      *
688      * This internal function is equivalent to `approve`, and can be used to
689      * e.g. set automatic allowances for certain subsystems, etc.
690      *
691      * Emits an {Approval} event.
692      *
693      * Requirements:
694      *
695      * - `owner` cannot be the zero address.
696      * - `spender` cannot be the zero address.
697      */
698     function _approve(
699         address owner,
700         address spender,
701         uint256 amount
702     ) internal virtual {
703         require(owner != address(0), "ERC20: approve from the zero address");
704         require(spender != address(0), "ERC20: approve to the zero address");
705 
706         _allowances[owner][spender] = amount;
707         emit Approval(owner, spender, amount);
708     }
709 
710     /**
711      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
712      *
713      * Does not update the allowance amount in case of infinite allowance.
714      * Revert if not enough allowance is available.
715      *
716      * Might emit an {Approval} event.
717      */
718     function _spendAllowance(
719         address owner,
720         address spender,
721         uint256 amount
722     ) internal virtual {
723         uint256 currentAllowance = allowance(owner, spender);
724         if (currentAllowance != type(uint256).max) {
725             require(currentAllowance >= amount, "ERC20: insufficient allowance");
726             unchecked {
727                 _approve(owner, spender, currentAllowance - amount);
728             }
729         }
730     }
731 
732     /**
733      * @dev Hook that is called before any transfer of tokens. This includes
734      * minting and burning.
735      *
736      * Calling conditions:
737      *
738      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
739      * will be transferred to `to`.
740      * - when `from` is zero, `amount` tokens will be minted for `to`.
741      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
742      * - `from` and `to` are never both zero.
743      *
744      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
745      */
746     function _beforeTokenTransfer(
747         address from,
748         address to,
749         uint256 amount
750     ) internal virtual {}
751 
752     /**
753      * @dev Hook that is called after any transfer of tokens. This includes
754      * minting and burning.
755      *
756      * Calling conditions:
757      *
758      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
759      * has been transferred to `to`.
760      * - when `from` is zero, `amount` tokens have been minted for `to`.
761      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
762      * - `from` and `to` are never both zero.
763      *
764      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
765      */
766     function _afterTokenTransfer(
767         address from,
768         address to,
769         uint256 amount
770     ) internal virtual {}
771 }
772 
773 error FeeCapExceeded();
774 error AccountIsBlacklisted();
775 error MaxWalletExceeded();
776 
777 contract NGN is ERC20, Ownable {
778 
779     address payable public marketingAddress;
780     address payable public teamAddress;
781     address public liquidityAddress; // Receives LP tokens
782 
783     mapping(address => bool) public _isExcludedFromFees;
784     mapping(address => bool) public _isBlacklisted;
785     mapping(address => bool) public isExcludedMaxWalletAmount;
786 
787     mapping(address => uint256) private _lastBuyTime;
788 
789     uint256 teamBuyFee = 100;
790     uint256 liquidityBuyFee = 400;
791     uint256 marketingBuyFee = 500;
792     uint256 totalBuyFees = 1000;
793 
794     uint256 teamSellFee = 100;
795     uint256 liquiditySellFee = 400;
796     uint256 marketingSellFee = 500;
797     uint256 totalSellFees = 1000;
798 
799     uint256 liquidityPumpAndDumpFee = 1500;
800     uint256 marketingPumpAndDumpFee = 1500;
801     uint256 totalPumpAndDumpFee = 3000;
802 
803     uint256 residualTokens;
804 
805     uint256 public liquidityTokens;
806     uint256 public marketingTokens;
807     uint256 public teamTokens;
808 
809     uint256 public swapTokensAtAmount = 400 * 10**18;
810     uint256 public maxWallet = 777777 * 10**16;
811     bool public swapEnabled = true;
812 
813     IUniswapV2Router02 public uniswapV2Router;
814     address public uniswapV2Pair;
815 
816     bool inSwapAndLiquify;
817 
818     event UpdateMaxWallet(uint256 maxWallet);
819     event setSwapTokensAtAmount(uint256 swapTokensAtAmount);
820     event ExcludedMaxWalletAmount(address indexed account, bool isExcluded);
821     event ExcludedFromFee(address account, bool _isExcludedFromFees);
822 
823     event UpdateTeamAddress(address teamAddress);
824     event UpdateMarketingFeeAddress(address _marketingFeeAddress);
825     event UpdateLiquidityAddress(address _liquidityAddress);
826     event SwapAndLiquify(uint256 tokensAutoLiq, uint256 ethAutoLiq);
827     event SwapAndLiquifyEnabledUpdated(bool enabled);
828 
829     constructor(address _marketingWallet, address _teamWallet, address _liquidityWallet) ERC20("Next Generation Network", "NGN") {
830 
831         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
832 
833         uniswapV2Router = _uniswapV2Router;
834         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this),_uniswapV2Router.WETH());
835 
836         _isBlacklisted[address(0)] = true;
837 
838         marketingAddress = payable(_marketingWallet);
839         teamAddress = payable(_teamWallet);
840         liquidityAddress = _liquidityWallet;
841 
842         _isExcludedFromFees[_msgSender()] = true;
843         _isExcludedFromFees[address(this)] = true;
844 
845         isExcludedMaxWalletAmount[_msgSender()] = true;
846         isExcludedMaxWalletAmount[address(this)] = true;
847         isExcludedMaxWalletAmount[address(uniswapV2Pair)] = true;
848         isExcludedMaxWalletAmount[address(_uniswapV2Router)] = true;
849 
850         _mint(msg.sender, 777777 * 10**18);
851 
852     }
853 
854     function _transfer(
855         address from,
856         address to,
857         uint256 amount
858     ) internal override {
859 
860         if(_isBlacklisted[from] || _isBlacklisted[to])
861         revert AccountIsBlacklisted();
862 
863         if(amount == 0) {
864             return;
865         }
866 
867         if (from == uniswapV2Pair)
868             _lastBuyTime[tx.origin] = block.timestamp;
869 
870                 //enforce max wallet on non-sells
871         if (to != uniswapV2Pair && !isExcludedMaxWalletAmount[to] && amount + balanceOf(to) > maxWallet) {
872             revert MaxWalletExceeded();
873         }
874 
875         bool overMinimumTokenBalance = balanceOf(address(this)) >= swapTokensAtAmount;
876 
877         if (
878             swapEnabled  &&
879             !inSwapAndLiquify &&
880             overMinimumTokenBalance &&
881             from != uniswapV2Pair &&
882             !_isExcludedFromFees[from] &&
883             !_isExcludedFromFees[to]
884 
885         ) {
886 
887             uint256 total = liquidityTokens + marketingTokens + teamTokens;
888             uint256 liqToSwap = swapTokensAtAmount * liquidityTokens / total;
889             uint256 marketingToSwap = swapTokensAtAmount * marketingTokens / total;
890             uint256 teamToSwap = swapTokensAtAmount * teamTokens / total;
891 
892             processFees(liqToSwap, marketingToSwap, teamToSwap);
893 
894             liquidityTokens -= liqToSwap;
895             marketingTokens -= marketingToSwap;
896             teamTokens -= teamToSwap;
897         }
898 
899         if (!inSwapAndLiquify && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
900 
901             uint256 fees;
902             if (from != uniswapV2Pair && totalPumpAndDumpFee !=0 && _lastBuyTime[tx.origin] + 24 hours > block.timestamp) {
903                 fees = amount  * totalPumpAndDumpFee / 10000;
904                 liquidityTokens += fees * liquidityPumpAndDumpFee / totalPumpAndDumpFee;
905                 marketingTokens += fees * marketingPumpAndDumpFee / totalPumpAndDumpFee;
906             }
907 
908             else if (to == uniswapV2Pair && totalSellFees != 0) { //sell
909                 fees = amount * totalSellFees / 10000;
910                 teamTokens += fees * teamSellFee / totalSellFees;
911                 liquidityTokens += fees * liquiditySellFee / totalSellFees;
912                 marketingTokens += fees * marketingSellFee / totalSellFees;
913             } else if (from == uniswapV2Pair && totalBuyFees != 0) { //buy
914                 fees = amount * totalBuyFees / 10000;
915                 teamTokens += fees * teamBuyFee / totalBuyFees;
916                 liquidityTokens += fees * liquidityBuyFee / totalBuyFees;
917                 marketingTokens += fees * marketingBuyFee / totalBuyFees;
918             }
919             if (fees > 0) {
920                 amount -= fees;
921                 super._transfer(from, address(this), fees);
922             }
923 
924         }
925 
926         super._transfer(from, to, amount);
927 
928     }
929 
930     function processFees(uint256 _liquidityTokens, uint256 _marketingTokens, uint256 _teamTokens) private {
931 
932         inSwapAndLiquify = true;
933 
934         _liquidityTokens += residualTokens;
935         residualTokens = 0;
936 
937         uint256 halfLiquidity = _liquidityTokens / 2;
938         uint256 otherHalfLiquidity = _liquidityTokens - halfLiquidity;
939 
940         uint256 swappingTotal = halfLiquidity + _marketingTokens + _teamTokens;
941 
942         _approve(address(this), address(uniswapV2Router), swappingTotal + otherHalfLiquidity);
943 
944         swapTokensForETH(swappingTotal);
945 
946         uint256 ETHBalance = address(this).balance;
947 
948         uint256 ETHForMarketing = ETHBalance * _marketingTokens / swappingTotal;
949         uint256 ETHForTeam = ETHBalance * _teamTokens / swappingTotal;
950         uint256 ETHForLiquidity = ETHBalance - ETHForMarketing - ETHForTeam;
951 
952         uint256 liquidityTokenAmount = addLiquidity(otherHalfLiquidity, ETHForLiquidity);
953 
954         residualTokens += (otherHalfLiquidity - liquidityTokenAmount);
955         emit SwapAndLiquify(otherHalfLiquidity, ETHForLiquidity);
956 
957         address(teamAddress).call{value: ETHForTeam}("");
958         address(marketingAddress).call{value: ETHForMarketing}("");
959 
960         inSwapAndLiquify = false;
961     }
962 
963     function swapTokensForETH(uint256 tokenAmount) private {
964         address[] memory path = new address[](2);
965         path[0] = address(this);
966         path[1] = uniswapV2Router.WETH();
967         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
968             tokenAmount,
969             0, // accept any amount of ETH
970             path,
971             address(this),
972             block.timestamp
973         );
974     }
975 
976     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private returns (uint256) {
977         (uint256 amountA,,) = uniswapV2Router.addLiquidityETH{value: ethAmount}(
978             address(this),
979             tokenAmount,
980             0, // slippage is unavoidable
981             0, // slippage is unavoidable
982             liquidityAddress,
983             block.timestamp
984         );
985         return amountA;
986     }
987 
988     function setBlacklist(address account, bool value) external onlyOwner {
989         _isBlacklisted[account] = value;
990     }
991 
992     function setBuyFees(uint256 team, uint256 liquidity, uint256 marketing) external onlyOwner {
993         uint256 total = team + liquidity + marketing;
994 
995         if (total > 3000)
996         revert FeeCapExceeded();
997 
998         teamBuyFee = team;
999         liquidityBuyFee = liquidity;
1000         marketingBuyFee = marketing;
1001         totalBuyFees = total;
1002     }
1003 
1004     function setSellFees(uint256 team, uint256 liquidity, uint256 marketing) external onlyOwner {
1005         uint256 total = team + liquidity + marketing;
1006 
1007         if (total > 3000)
1008         revert FeeCapExceeded();
1009 
1010         teamSellFee = team;
1011         liquiditySellFee = liquidity;
1012         marketingSellFee = marketing;
1013         totalSellFees = total;
1014     }
1015 
1016     function setPumpAndDumpFees(uint256 liquidity, uint256 marketing) external onlyOwner {
1017         uint256 total = liquidity + marketing;
1018         if (total > 10000)
1019         revert FeeCapExceeded();
1020 
1021         liquidityPumpAndDumpFee = liquidity;
1022         marketingPumpAndDumpFee = marketing;
1023         totalPumpAndDumpFee = total;
1024     }
1025 
1026     function updateMaxWallet(uint256 _maxWallet) external onlyOwner {
1027         maxWallet = _maxWallet;
1028         emit UpdateMaxWallet(_maxWallet);
1029     }
1030 
1031     function excludeFromMaxWallet(address account, bool value) public onlyOwner {
1032         isExcludedMaxWalletAmount[account] = value;
1033         emit ExcludedMaxWalletAmount(account, value);
1034     }
1035 
1036     function setExcludedFromFees(address account, bool value) external onlyOwner {
1037         _isExcludedFromFees[account] = value;
1038         emit ExcludedFromFee(account, value);
1039     }
1040 
1041     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1042         swapEnabled = _enabled;
1043         emit SwapAndLiquifyEnabledUpdated(_enabled);
1044     }
1045 
1046     function setSwapAtAmount(uint256 _swapTokensAtAmount) external onlyOwner {
1047         swapTokensAtAmount = _swapTokensAtAmount;
1048         emit setSwapTokensAtAmount(_swapTokensAtAmount);
1049     }
1050 
1051     function updateTeamAddress(address _teamAddress) external onlyOwner {
1052         teamAddress = payable(_teamAddress);
1053         emit UpdateTeamAddress(_teamAddress);
1054     }
1055 
1056     function updateMarketingFeeAddress(address _marketingFeeAddress) external onlyOwner {
1057         marketingAddress = payable(_marketingFeeAddress);
1058         emit UpdateMarketingFeeAddress(_marketingFeeAddress);
1059     }
1060 
1061     function updateLiquidityAddress(address _liquidityAddress) external onlyOwner {
1062         liquidityAddress = (_liquidityAddress);
1063         emit UpdateLiquidityAddress(_liquidityAddress);
1064     }
1065 
1066     receive() external payable {}
1067 }