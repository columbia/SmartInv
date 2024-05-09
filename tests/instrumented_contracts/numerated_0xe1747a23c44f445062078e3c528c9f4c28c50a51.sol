1 /**
2  *Submitted for verification at Etherscan.io on 2021-12-03
3 */
4 
5 // File: token.sol
6 
7 
8 // File: @openzeppelin/contracts/utils/Context.sol
9 
10 
11 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
12 
13 pragma solidity ^0.8.0;
14 
15 /**
16  * @dev Provides information about the current execution context, including the
17  * sender of the transaction and its data. While these are generally available
18  * via msg.sender and msg.data, they should not be accessed in such a direct
19  * manner, since when dealing with meta-transactions the account sending and
20  * paying for execution may not be the actual sender (as far as an application
21  * is concerned).
22  *
23  * This contract is only required for intermediate, library-like contracts.
24  */
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes calldata) {
31         return msg.data;
32     }
33 }
34 
35 // File: @openzeppelin/contracts/access/Ownable.sol
36 
37 
38 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
39 
40 pragma solidity ^0.8.0;
41 
42 
43 /**
44  * @dev Contract module which provides a basic access control mechanism, where
45  * there is an account (an owner) that can be granted exclusive access to
46  * specific functions.
47  *
48  * By default, the owner account will be the one that deploys the contract. This
49  * can later be changed with {transferOwnership}.
50  *
51  * This module is used through inheritance. It will make available the modifier
52  * `onlyOwner`, which can be applied to your functions to restrict their use to
53  * the owner.
54  */
55 abstract contract Ownable is Context {
56     address private _owner;
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60     /**
61      * @dev Initializes the contract setting the deployer as the initial owner.
62      */
63     constructor() {
64         _transferOwnership(_msgSender());
65     }
66 
67     /**
68      * @dev Returns the address of the current owner.
69      */
70     function owner() public view virtual returns (address) {
71         return _owner;
72     }
73 
74     /**
75      * @dev Throws if called by any account other than the owner.
76      */
77     modifier onlyOwner() {
78         require(owner() == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
114 
115 
116 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev Interface of the ERC20 standard as defined in the EIP.
122  */
123 interface IERC20 {
124     /**
125      * @dev Returns the amount of tokens in existence.
126      */
127     function totalSupply() external view returns (uint256);
128 
129     /**
130      * @dev Returns the amount of tokens owned by `account`.
131      */
132     function balanceOf(address account) external view returns (uint256);
133 
134     /**
135      * @dev Moves `amount` tokens from the caller's account to `recipient`.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * Emits a {Transfer} event.
140      */
141     function transfer(address recipient, uint256 amount) external returns (bool);
142 
143     /**
144      * @dev Returns the remaining number of tokens that `spender` will be
145      * allowed to spend on behalf of `owner` through {transferFrom}. This is
146      * zero by default.
147      *
148      * This value changes when {approve} or {transferFrom} are called.
149      */
150     function allowance(address owner, address spender) external view returns (uint256);
151 
152     /**
153      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * IMPORTANT: Beware that changing an allowance with this method brings the risk
158      * that someone may use both the old and the new allowance by unfortunate
159      * transaction ordering. One possible solution to mitigate this race
160      * condition is to first reduce the spender's allowance to 0 and set the
161      * desired value afterwards:
162      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163      *
164      * Emits an {Approval} event.
165      */
166     function approve(address spender, uint256 amount) external returns (bool);
167 
168     /**
169      * @dev Moves `amount` tokens from `sender` to `recipient` using the
170      * allowance mechanism. `amount` is then deducted from the caller's
171      * allowance.
172      *
173      * Returns a boolean value indicating whether the operation succeeded.
174      *
175      * Emits a {Transfer} event.
176      */
177     function transferFrom(
178         address sender,
179         address recipient,
180         uint256 amount
181     ) external returns (bool);
182 
183     /**
184      * @dev Emitted when `value` tokens are moved from one account (`from`) to
185      * another (`to`).
186      *
187      * Note that `value` may be zero.
188      */
189     event Transfer(address indexed from, address indexed to, uint256 value);
190 
191     /**
192      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
193      * a call to {approve}. `value` is the new allowance.
194      */
195     event Approval(address indexed owner, address indexed spender, uint256 value);
196 }
197 
198 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
199 
200 
201 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
202 
203 pragma solidity ^0.8.0;
204 
205 
206 /**
207  * @dev Interface for the optional metadata functions from the ERC20 standard.
208  *
209  * _Available since v4.1._
210  */
211 interface IERC20Metadata is IERC20 {
212     /**
213      * @dev Returns the name of the token.
214      */
215     function name() external view returns (string memory);
216 
217     /**
218      * @dev Returns the symbol of the token.
219      */
220     function symbol() external view returns (string memory);
221 
222     /**
223      * @dev Returns the decimals places of the token.
224      */
225     function decimals() external view returns (uint8);
226 }
227 
228 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
229 
230 
231 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
232 
233 pragma solidity ^0.8.0;
234 
235 
236 
237 
238 /**
239  * @dev Implementation of the {IERC20} interface.
240  *
241  * This implementation is agnostic to the way tokens are created. This means
242  * that a supply mechanism has to be added in a derived contract using {_mint}.
243  * For a generic mechanism see {ERC20PresetMinterPauser}.
244  *
245  * TIP: For a detailed writeup see our guide
246  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
247  * to implement supply mechanisms].
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
276      * The default value of {decimals} is 18. To select a different value for
277      * {decimals} you should overload it.
278      *
279      * All two of these values are immutable: they can only be set once during
280      * construction.
281      */
282     constructor(string memory name_, string memory symbol_) {
283         _name = name_;
284         _symbol = symbol_;
285     }
286 
287     /**
288      * @dev Returns the name of the token.
289      */
290     function name() public view virtual override returns (string memory) {
291         return _name;
292     }
293 
294     /**
295      * @dev Returns the symbol of the token, usually a shorter version of the
296      * name.
297      */
298     function symbol() public view virtual override returns (string memory) {
299         return _symbol;
300     }
301 
302     /**
303      * @dev Returns the number of decimals used to get its user representation.
304      * For example, if `decimals` equals `2`, a balance of `505` tokens should
305      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
306      *
307      * Tokens usually opt for a value of 18, imitating the relationship between
308      * Ether and Wei. This is the value {ERC20} uses, unless this function is
309      * overridden;
310      *
311      * NOTE: This information is only used for _display_ purposes: it in
312      * no way affects any of the arithmetic of the contract, including
313      * {IERC20-balanceOf} and {IERC20-transfer}.
314      */
315     function decimals() public view virtual override returns (uint8) {
316         return 18;
317     }
318 
319     /**
320      * @dev See {IERC20-totalSupply}.
321      */
322     function totalSupply() public view virtual override returns (uint256) {
323         return _totalSupply;
324     }
325 
326     /**
327      * @dev See {IERC20-balanceOf}.
328      */
329     function balanceOf(address account) public view virtual override returns (uint256) {
330         return _balances[account];
331     }
332 
333     /**
334      * @dev See {IERC20-transfer}.
335      *
336      * Requirements:
337      *
338      * - `recipient` cannot be the zero address.
339      * - the caller must have a balance of at least `amount`.
340      */
341     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
342         _transfer(_msgSender(), recipient, amount);
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
356      * Requirements:
357      *
358      * - `spender` cannot be the zero address.
359      */
360     function approve(address spender, uint256 amount) public virtual override returns (bool) {
361         _approve(_msgSender(), spender, amount);
362         return true;
363     }
364 
365     /**
366      * @dev See {IERC20-transferFrom}.
367      *
368      * Emits an {Approval} event indicating the updated allowance. This is not
369      * required by the EIP. See the note at the beginning of {ERC20}.
370      *
371      * Requirements:
372      *
373      * - `sender` and `recipient` cannot be the zero address.
374      * - `sender` must have a balance of at least `amount`.
375      * - the caller must have allowance for ``sender``'s tokens of at least
376      * `amount`.
377      */
378     function transferFrom(
379         address sender,
380         address recipient,
381         uint256 amount
382     ) public virtual override returns (bool) {
383         uint256 currentAllowance = _allowances[sender][_msgSender()];
384         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
385         unchecked {
386             _approve(sender, _msgSender(), currentAllowance - amount);
387         }
388         _transfer(sender, recipient, amount);
389 
390         return true;
391     }
392 
393     /**
394      * @dev Atomically increases the allowance granted to `spender` by the caller.
395      *
396      * This is an alternative to {approve} that can be used as a mitigation for
397      * problems described in {IERC20-approve}.
398      *
399      * Emits an {Approval} event indicating the updated allowance.
400      *
401      * Requirements:
402      *
403      * - `spender` cannot be the zero address.
404      */
405     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
406         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
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
425         uint256 currentAllowance = _allowances[_msgSender()][spender];
426         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
427         unchecked {
428             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
429         }
430 
431         return true;
432     }
433 
434     /**
435      * @dev Moves `amount` of tokens from `sender` to `recipient`.
436      *
437      * This internal function is equivalent to {transfer}, and can be used to
438      * e.g. implement automatic token fees, slashing mechanisms, etc.
439      *
440      * Emits a {Transfer} event.
441      *
442      * Requirements:
443      *
444      * - `sender` cannot be the zero address.
445      * - `recipient` cannot be the zero address.
446      * - `sender` must have a balance of at least `amount`.
447      */
448     function _transfer(
449         address sender,
450         address recipient,
451         uint256 amount
452     ) internal virtual {
453         require(sender != address(0), "ERC20: transfer from the zero address");
454         require(recipient != address(0), "ERC20: transfer to the zero address");
455 
456         _beforeTokenTransfer(sender, recipient, amount);
457 
458         uint256 senderBalance = _balances[sender];
459         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
460         unchecked {
461             _balances[sender] = senderBalance - amount;
462         }
463         _balances[recipient] += amount;
464 
465         emit Transfer(sender, recipient, amount);
466 
467         _afterTokenTransfer(sender, recipient, amount);
468     }
469 
470     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
471      * the total supply.
472      *
473      * Emits a {Transfer} event with `from` set to the zero address.
474      *
475      * Requirements:
476      *
477      * - `account` cannot be the zero address.
478      */
479     function _mint(address account, uint256 amount) internal virtual {
480         require(account != address(0), "ERC20: mint to the zero address");
481 
482         _beforeTokenTransfer(address(0), account, amount);
483 
484         _totalSupply += amount;
485         _balances[account] += amount;
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
511         }
512         _totalSupply -= amount;
513 
514         emit Transfer(account, address(0), amount);
515 
516         _afterTokenTransfer(account, address(0), amount);
517     }
518 
519     /**
520      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
521      *
522      * This internal function is equivalent to `approve`, and can be used to
523      * e.g. set automatic allowances for certain subsystems, etc.
524      *
525      * Emits an {Approval} event.
526      *
527      * Requirements:
528      *
529      * - `owner` cannot be the zero address.
530      * - `spender` cannot be the zero address.
531      */
532     function _approve(
533         address owner,
534         address spender,
535         uint256 amount
536     ) internal virtual {
537         require(owner != address(0), "ERC20: approve from the zero address");
538         require(spender != address(0), "ERC20: approve to the zero address");
539 
540         _allowances[owner][spender] = amount;
541         emit Approval(owner, spender, amount);
542     }
543 
544     /**
545      * @dev Hook that is called before any transfer of tokens. This includes
546      * minting and burning.
547      *
548      * Calling conditions:
549      *
550      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
551      * will be transferred to `to`.
552      * - when `from` is zero, `amount` tokens will be minted for `to`.
553      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
554      * - `from` and `to` are never both zero.
555      *
556      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
557      */
558     function _beforeTokenTransfer(
559         address from,
560         address to,
561         uint256 amount
562     ) internal virtual {}
563 
564     /**
565      * @dev Hook that is called after any transfer of tokens. This includes
566      * minting and burning.
567      *
568      * Calling conditions:
569      *
570      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
571      * has been transferred to `to`.
572      * - when `from` is zero, `amount` tokens have been minted for `to`.
573      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
574      * - `from` and `to` are never both zero.
575      *
576      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
577      */
578     function _afterTokenTransfer(
579         address from,
580         address to,
581         uint256 amount
582     ) internal virtual {}
583 }
584 
585 // File: IUniswapV2Router.sol
586 
587 
588 
589 pragma solidity ^0.8.0;
590 
591 interface IUniswapV2Router01 {
592     function factory() external pure returns (address);
593     function WETH() external pure returns (address);
594 
595     function addLiquidity(
596         address tokenA,
597         address tokenB,
598         uint amountADesired,
599         uint amountBDesired,
600         uint amountAMin,
601         uint amountBMin,
602         address to,
603         uint deadline
604     ) external returns (uint amountA, uint amountB, uint liquidity);
605     function addLiquidityETH(
606         address token,
607         uint amountTokenDesired,
608         uint amountTokenMin,
609         uint amountETHMin,
610         address to,
611         uint deadline
612     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
613     function removeLiquidity(
614         address tokenA,
615         address tokenB,
616         uint liquidity,
617         uint amountAMin,
618         uint amountBMin,
619         address to,
620         uint deadline
621     ) external returns (uint amountA, uint amountB);
622     function removeLiquidityETH(
623         address token,
624         uint liquidity,
625         uint amountTokenMin,
626         uint amountETHMin,
627         address to,
628         uint deadline
629     ) external returns (uint amountToken, uint amountETH);
630     function removeLiquidityWithPermit(
631         address tokenA,
632         address tokenB,
633         uint liquidity,
634         uint amountAMin,
635         uint amountBMin,
636         address to,
637         uint deadline,
638         bool approveMax, uint8 v, bytes32 r, bytes32 s
639     ) external returns (uint amountA, uint amountB);
640     function removeLiquidityETHWithPermit(
641         address token,
642         uint liquidity,
643         uint amountTokenMin,
644         uint amountETHMin,
645         address to,
646         uint deadline,
647         bool approveMax, uint8 v, bytes32 r, bytes32 s
648     ) external returns (uint amountToken, uint amountETH);
649     function swapExactTokensForTokens(
650         uint amountIn,
651         uint amountOutMin,
652         address[] calldata path,
653         address to,
654         uint deadline
655     ) external returns (uint[] memory amounts);
656     function swapTokensForExactTokens(
657         uint amountOut,
658         uint amountInMax,
659         address[] calldata path,
660         address to,
661         uint deadline
662     ) external returns (uint[] memory amounts);
663     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
664         external
665         payable
666         returns (uint[] memory amounts);
667     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
668         external
669         returns (uint[] memory amounts);
670     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
671         external
672         returns (uint[] memory amounts);
673     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
674         external
675         payable
676         returns (uint[] memory amounts);
677 
678     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
679     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
680     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
681     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
682     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
683 }
684 
685 
686 
687 // pragma solidity >=0.6.2;
688 
689 interface IUniswapV2Router02 is IUniswapV2Router01 {
690     function removeLiquidityETHSupportingFeeOnTransferTokens(
691         address token,
692         uint liquidity,
693         uint amountTokenMin,
694         uint amountETHMin,
695         address to,
696         uint deadline
697     ) external returns (uint amountETH);
698     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
699         address token,
700         uint liquidity,
701         uint amountTokenMin,
702         uint amountETHMin,
703         address to,
704         uint deadline,
705         bool approveMax, uint8 v, bytes32 r, bytes32 s
706     ) external returns (uint amountETH);
707 
708     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
709         uint amountIn,
710         uint amountOutMin,
711         address[] calldata path,
712         address to,
713         uint deadline
714     ) external;
715     function swapExactETHForTokensSupportingFeeOnTransferTokens(
716         uint amountOutMin,
717         address[] calldata path,
718         address to,
719         uint deadline
720     ) external payable;
721     function swapExactTokensForETHSupportingFeeOnTransferTokens(
722         uint amountIn,
723         uint amountOutMin,
724         address[] calldata path,
725         address to,
726         uint deadline
727     ) external;
728 }
729 
730 // File: IUniswapV2Factory.sol
731 
732 
733 
734 pragma solidity ^0.8.0;
735 
736 interface IUniswapV2Factory {
737     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
738 
739     function feeTo() external view returns (address);
740     function feeToSetter() external view returns (address);
741 
742     function getPair(address tokenA, address tokenB) external view returns (address pair);
743     function allPairs(uint) external view returns (address pair);
744     function allPairsLength() external view returns (uint);
745 
746     function createPair(address tokenA, address tokenB) external returns (address pair);
747 
748     function setFeeTo(address) external;
749     function setFeeToSetter(address) external;
750 }
751 
752 // File: IUniswapV2Pair.sol
753 
754 
755 
756 pragma solidity ^0.8.0;
757 
758 interface IUniswapV2Pair {
759     event Approval(address indexed owner, address indexed spender, uint value);
760     event Transfer(address indexed from, address indexed to, uint value);
761 
762     function name() external pure returns (string memory);
763     function symbol() external pure returns (string memory);
764     function decimals() external pure returns (uint8);
765     function totalSupply() external view returns (uint);
766     function balanceOf(address owner) external view returns (uint);
767     function allowance(address owner, address spender) external view returns (uint);
768 
769     function approve(address spender, uint value) external returns (bool);
770     function transfer(address to, uint value) external returns (bool);
771     function transferFrom(address from, address to, uint value) external returns (bool);
772 
773     function DOMAIN_SEPARATOR() external view returns (bytes32);
774     function PERMIT_TYPEHASH() external pure returns (bytes32);
775     function nonces(address owner) external view returns (uint);
776 
777     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
778 
779     event Mint(address indexed sender, uint amount0, uint amount1);
780     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
781     event Swap(
782         address indexed sender,
783         uint amount0In,
784         uint amount1In,
785         uint amount0Out,
786         uint amount1Out,
787         address indexed to
788     );
789     event Sync(uint112 reserve0, uint112 reserve1);
790 
791     function MINIMUM_LIQUIDITY() external pure returns (uint);
792     function factory() external view returns (address);
793     function token0() external view returns (address);
794     function token1() external view returns (address);
795     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
796     function price0CumulativeLast() external view returns (uint);
797     function price1CumulativeLast() external view returns (uint);
798     function kLast() external view returns (uint);
799 
800     function mint(address to) external returns (uint liquidity);
801     function burn(address to) external returns (uint amount0, uint amount1);
802     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
803     function skim(address to) external;
804     function sync() external;
805 
806     function initialize(address, address) external;
807 }
808 
809 // File: token.sol
810 
811 /*
812     SPDX-License-Identifier: MIT
813     
814 */
815 
816 pragma solidity ^0.8.0;
817 
818 
819 contract Token is ERC20, Ownable {
820 
821     IUniswapV2Router02 public uniswapV2Router;
822     address public uniswapV2Pair;
823     
824     address public marketingWallet;
825     address public devWallet;
826     address public stakingWallet;
827     address public liquidityWallet;
828 
829     uint256 public marketingFee;
830     uint256 public devFee;
831     uint256 public stakingFee;
832     uint256 public liquidityFee;
833     uint256 public totalFees;
834 
835     bool public noBuyTax;
836 
837     uint256 immutable public maxTotalFees;
838 
839     uint256 public minAmountToSwap;
840     bool private swapping;
841 
842     // Allow swapAndLiquify execution sequence
843     bool canSwapAndLiquify = true;
844     bool canBuyBack = true;
845     uint256 public buyBackAmount = 10**15;
846     address public deadAddress = 0x000000000000000000000000000000000000dEaD;
847 
848     // store addresses that a automatic market maker pairs.
849     mapping (address => bool) public automatedMarketMakerPairs;
850 
851     // exclude from fees
852     // useful if you need to list the token on a CEX or stake it
853     mapping (address => bool) private _isExcludedFromFees;
854 
855     // exclude from fees and swapAndLiquify
856     // Useful for bridges, or when we need to have a clean transfer
857     mapping (address => bool) private _isExcludedFromFeesAndSwapLiquify;
858 
859     // events
860     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
861     event ExcludeFromFees(address indexed account, bool isExcluded);
862     event ExcludeFromFeesAndSwapLiquify(address indexed account, bool isExcluded);
863     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
864 
865     event MarketingWalletUpdated(address indexed newMarketingWallet, address indexed oldMarketingWallet);
866     event DevWalletUpdated(address indexed newDevWalletWallet, address indexed devWalletUpdated);
867     event StakingWalletUpdated(address indexed newStakingWallet, address indexed stakingWalletUpdated);
868     event LiquidityWalletUpdated(address indexed newLiquidityWallet, address indexed liquidityWalletUpdated);
869 
870     event MarketingFeeUpdated(uint256 indexed newmarketingFee);
871     event DevFeeUpdated(uint256 indexed newDevFee);
872     event StakingFeeUpdated(uint256 indexed newStakingFee);
873     event LiquidityFeeUpdated(uint256 indexed newLiquidityFee);
874 
875     event SwapAndLiquify(
876     uint256 tokensSwapped,
877     uint256 ethReceived,
878     uint256 tokensIntoLiqudity
879     );
880 
881     modifier lockTheSwap {
882         swapping = true;
883         _;
884         swapping = false;
885     }
886 
887     constructor() ERC20("Eterna", "EHX") {
888         marketingFee = 60;
889         devFee = 60;
890         stakingFee = 60;
891         liquidityFee = 70;
892         totalFees = marketingFee + devFee + stakingFee + liquidityFee;
893         maxTotalFees = totalFees;
894         minAmountToSwap = 1_000;
895 
896         marketingWallet = 0xe75A8bdd32aCBbF0F8EA0A31954413132Bb0F4F6;
897         devWallet = 0xbC95F136E7FCA6FeCd1619c7561a6F4Eef9d5936;
898         stakingWallet = 0x7203E6951f7cb4E8089bbD1e556B9E20EB21C3aD;
899         liquidityWallet = 0x14F4366c86ec577c3daE0aDb6abeF0c13c4cfb74;
900 
901         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
902 
903         // _mint is an internal function in ERC20.sol that is only called here,
904         // and CANNOT be called ever again
905         _mint(owner(), 1_000_000_000 * (10**18));
906 
907          // Create a uniswap pair for this new token
908         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
909             .createPair(address(this), _uniswapV2Router.WETH());
910 
911         uniswapV2Router = _uniswapV2Router;
912         uniswapV2Pair = _uniswapV2Pair;
913 
914         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
915 
916         // exclude from paying fees
917         excludeFromFees(marketingWallet, true);
918         excludeFromFees(devWallet, true);
919         excludeFromFees(stakingWallet, true);
920         excludeFromFees(address(this), true);
921 
922 
923 
924     }
925 
926     // fallback function to receive eth
927     receive() external payable {
928     }
929 
930     // This is needed if we want to change DEX, or if Uniswap goes V4
931     function updateUniswapV2Router(address newAddress) public onlyOwner {
932         require(newAddress != address(uniswapV2Router), "the router already has that address");
933         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
934         uniswapV2Router = IUniswapV2Router02(newAddress);
935     }
936 
937     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
938         require(pair != uniswapV2Pair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
939 
940         _setAutomatedMarketMakerPair(pair, value);
941     }
942 
943     function _setAutomatedMarketMakerPair(address pair, bool value) private {
944         require(automatedMarketMakerPairs[pair] != value, "automated market maker pair is already set to that value");
945         automatedMarketMakerPairs[pair] = value;
946 
947         emit SetAutomatedMarketMakerPair(pair, value);
948     }
949 
950     function excludeFromFees(address account, bool excluded) public onlyOwner {
951         _isExcludedFromFees[account] = excluded;
952         emit ExcludeFromFees(account, excluded);
953     }
954 
955     function excludeFromFeesAndSwapLiquify(address account, bool excluded) public onlyOwner {
956         _isExcludedFromFeesAndSwapLiquify[account] = excluded;
957         emit ExcludeFromFeesAndSwapLiquify(account, excluded);
958     }
959 
960     // Update wallets
961     function updateMarketingWallet(address newMarketingWallet) public onlyOwner {
962         require(newMarketingWallet != marketingWallet, "the marketing wallet is already this address");
963         excludeFromFees(newMarketingWallet, true);
964         emit MarketingWalletUpdated(newMarketingWallet, marketingWallet);
965         marketingWallet = newMarketingWallet;
966     }
967 
968     function updateDevWallet(address newDevWallet) public onlyOwner {
969         require(newDevWallet != devWallet, ": The dev wallet is already this address");
970         excludeFromFees(newDevWallet, true);
971         emit LiquidityWalletUpdated(newDevWallet, devWallet);
972         devWallet = newDevWallet;
973     }
974 
975     function updateStakingWallet(address newStakingWallet) public onlyOwner {
976         require(newStakingWallet != stakingWallet, ": The liquidity wallet is already this address");
977         excludeFromFees(newStakingWallet, true);
978         emit LiquidityWalletUpdated(newStakingWallet, stakingWallet);
979         stakingWallet = newStakingWallet;
980     }
981 
982     function updateLiquidityWallet(address newLiquidityWallet) public onlyOwner {
983         require(newLiquidityWallet != liquidityWallet, ": The liquidity wallet is already this address");
984         excludeFromFees(newLiquidityWallet, true);
985         emit LiquidityWalletUpdated(newLiquidityWallet, liquidityWallet);
986         liquidityWallet = newLiquidityWallet;
987     }
988 
989     function updateMarketingFee(uint256 newMarketingFee) public onlyOwner {
990         marketingFee = newMarketingFee;
991         totalFees = marketingFee + liquidityFee + devFee + stakingFee;
992         require(totalFees <= maxTotalFees);
993         emit MarketingFeeUpdated(newMarketingFee);
994     }
995 
996     function updateLiquidityFee(uint256 newLiquidityFee) public onlyOwner {
997         liquidityFee = newLiquidityFee;
998         totalFees = marketingFee + liquidityFee + devFee + stakingFee;
999         require(totalFees <= maxTotalFees);
1000         emit LiquidityFeeUpdated(newLiquidityFee);
1001     }
1002 
1003     function updateDevFee(uint256 newDevFee) public onlyOwner {
1004         devFee = newDevFee;
1005         totalFees = marketingFee + liquidityFee + devFee + stakingFee;
1006         require(totalFees <= maxTotalFees);
1007         emit DevFeeUpdated(newDevFee);
1008     }
1009 
1010     function updatestakingFee(uint256 newStakingFee) public onlyOwner {
1011         stakingFee = newStakingFee;
1012         totalFees = marketingFee + liquidityFee + devFee + stakingFee;
1013         require(totalFees <= maxTotalFees);
1014         emit StakingFeeUpdated(newStakingFee);
1015     }
1016 
1017     // Allows to stop the automatic swap of fees
1018     function updateCanSwapAndLiquify(bool _canSwapAndLiquify) external onlyOwner {
1019         canSwapAndLiquify = _canSwapAndLiquify;
1020     }
1021 
1022      // Allows to stop the automatic buyback of fees
1023     function updateCanBuyBack(bool _canBuyBack) external onlyOwner {
1024         canBuyBack = _canBuyBack;
1025     }
1026 
1027     function updateBuyBackAmount(uint256 _buyBackAmount) public onlyOwner {
1028         buyBackAmount = _buyBackAmount;
1029     }
1030 
1031     // Updates the minimum amount of tokens needed to swapAndLiquidify
1032     function updateMinAmountToSwap(uint256 _minAmountToSwap) external onlyOwner {
1033         minAmountToSwap = _minAmountToSwap;
1034     }
1035 
1036     function isExcludedFromFees(address account) public view returns(bool) {
1037         return _isExcludedFromFees[account];
1038     }
1039 
1040     function isExcludedFromFeesAndSwapAndLiquify(address account) public view returns(bool) {
1041         return _isExcludedFromFeesAndSwapLiquify[account];
1042     }
1043 
1044     function removeBuyTax(bool _noBuyTax) external onlyOwner {
1045         noBuyTax = _noBuyTax;
1046     }
1047 
1048     function _transfer(
1049         address from,
1050         address to,
1051         uint256 amount
1052     ) internal override {
1053         require(from != address(0), "ERC20: transfer from the zero address");
1054         require(to != address(0), "ERC20: transfer to the zero address");
1055 
1056         if(amount == 0) {
1057             super._transfer(from, to, 0);
1058             return;
1059         }
1060 
1061         // Remove the buy tax in case we need it
1062         if(automatedMarketMakerPairs[from] && noBuyTax) {
1063             super._transfer(from, to, amount);
1064             return;
1065         }
1066 
1067         // Simple transfer from/to whitelisted addresses
1068         if(_isExcludedFromFeesAndSwapLiquify[from] || _isExcludedFromFeesAndSwapLiquify[to]) {
1069             super._transfer(from, to, amount);
1070             return;
1071         }
1072 
1073         // We don't swap if the contract is empty
1074         uint256 contractTokenBalance = balanceOf(address(this));
1075         bool canSwap = contractTokenBalance >= minAmountToSwap;
1076 
1077         if(
1078             canSwap &&
1079             !swapping &&
1080             !automatedMarketMakerPairs[from] &&
1081             from != devWallet &&
1082             to != devWallet &&
1083             from != marketingWallet &&
1084             to != marketingWallet &&
1085             from != stakingWallet &&
1086             to != stakingWallet &&
1087             canSwapAndLiquify
1088         ) {
1089 
1090             // We avoid a recursion loop
1091             swapping = true;
1092             
1093             uint256 tokensForLiquidity = (contractTokenBalance * liquidityFee / 2) / (totalFees);
1094             
1095             uint256 tokensForMarketing = (contractTokenBalance * marketingFee) / totalFees;
1096             uint256 tokensForDev = (contractTokenBalance * devFee) / totalFees;
1097             uint256 tokensForStaking = (contractTokenBalance * stakingFee) / totalFees;
1098             //Send tokens to the staking contract
1099             super._transfer(address(this), stakingWallet, tokensForStaking);
1100 
1101             // We swap the tokens for ETH
1102             uint256 ETHBefore = address(this).balance;
1103             uint256 tokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1104 
1105             swapTokensForEth(tokensToSwap);
1106             uint256 EthSwapped = address(this).balance - ETHBefore; // How much did we get?
1107 
1108             // This is for math purposes
1109             uint256 swappedFees = totalFees - liquidityFee/2 - stakingFee;
1110             // Eth if we swapped all tokens
1111             uint256 hypotheticalEthBalance = (EthSwapped * totalFees) / swappedFees;
1112             // We compute the amount of Eth to send to each wallet
1113             uint256 ethForLiquidity = (hypotheticalEthBalance * liquidityFee / 2) / totalFees;
1114             uint256 ethForMarketing = hypotheticalEthBalance * marketingFee / totalFees;
1115             uint256 ethForDev = hypotheticalEthBalance * devFee / totalFees;
1116 
1117             // We use the eth
1118             addLiquidity(tokensForLiquidity, ethForLiquidity);
1119 
1120             payable(marketingWallet).transfer(ethForMarketing);
1121             payable(devWallet).transfer(ethForDev);
1122 
1123             // We resume normal operations
1124             swapping = false;
1125         }
1126 
1127         if(canBuyBack && address(this).balance > buyBackAmount * 10 && !automatedMarketMakerPairs[from] && !swapping){
1128                 buyBackTokens(buyBackAmount);
1129         }
1130 
1131         bool takeFee = !swapping;
1132         // if any account belongs to _isExcludedFromFee account then remove the fee
1133         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1134             takeFee = false;
1135         }
1136 
1137         if(takeFee) {
1138             uint256 fees = amount*totalFees/1000;
1139             amount = amount - fees;
1140 
1141             super._transfer(from, address(this), fees);
1142         }
1143 
1144         super._transfer(from, to, amount);
1145     }
1146 
1147     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1148         // approve token transfer to cover all possible scenarios
1149         _approve(address(this), address(uniswapV2Router), tokenAmount);
1150         
1151         // add the liquidity
1152         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1153             address(this),
1154             tokenAmount,
1155             0, // slippage is unavoidable
1156             0, // slippage is unavoidable
1157             liquidityWallet,
1158             block.timestamp
1159         );
1160         
1161     }
1162 
1163     function swapTokensForEth(uint256 tokenAmount) private {
1164 
1165         // generate the uniswap pair path of token -> weth
1166         address[] memory path = new address[](2);
1167         path[0] = address(this);
1168         path[1] = uniswapV2Router.WETH();
1169 
1170         _approve(address(this), address(uniswapV2Router), tokenAmount);
1171 
1172         // make the swap
1173         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1174             tokenAmount,
1175             0, // accept any amount of ETH
1176             path,
1177             address(this),
1178             block.timestamp
1179         );
1180     }
1181 
1182     function buyBackTokens(uint256 amount) private lockTheSwap{
1183         if (amount > 0) {
1184             swapETHForTokens(amount);
1185         }
1186     }
1187 
1188     function swapETHForTokens(uint256 amount) private {
1189     // generate the unisw   ap pair path of token -> weth
1190         address[] memory path = new address[](2);
1191         path[0] = uniswapV2Router.WETH();
1192         path[1] = address(this);
1193 
1194         // make the swap
1195         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
1196             0, // accept any amount of Tokens
1197             path,
1198             deadAddress,
1199             block.timestamp
1200         );
1201     }
1202 
1203 
1204 }