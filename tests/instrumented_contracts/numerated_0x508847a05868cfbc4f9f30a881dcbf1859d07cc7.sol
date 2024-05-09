1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
107 
108 
109 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 /**
114  * @dev Interface of the ERC20 standard as defined in the EIP.
115  */
116 interface IERC20 {
117     /**
118      * @dev Returns the amount of tokens in existence.
119      */
120     function totalSupply() external view returns (uint256);
121 
122     /**
123      * @dev Returns the amount of tokens owned by `account`.
124      */
125     function balanceOf(address account) external view returns (uint256);
126 
127     /**
128      * @dev Moves `amount` tokens from the caller's account to `to`.
129      *
130      * Returns a boolean value indicating whether the operation succeeded.
131      *
132      * Emits a {Transfer} event.
133      */
134     function transfer(address to, uint256 amount) external returns (bool);
135 
136     /**
137      * @dev Returns the remaining number of tokens that `spender` will be
138      * allowed to spend on behalf of `owner` through {transferFrom}. This is
139      * zero by default.
140      *
141      * This value changes when {approve} or {transferFrom} are called.
142      */
143     function allowance(address owner, address spender) external view returns (uint256);
144 
145     /**
146      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
147      *
148      * Returns a boolean value indicating whether the operation succeeded.
149      *
150      * IMPORTANT: Beware that changing an allowance with this method brings the risk
151      * that someone may use both the old and the new allowance by unfortunate
152      * transaction ordering. One possible solution to mitigate this race
153      * condition is to first reduce the spender's allowance to 0 and set the
154      * desired value afterwards:
155      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156      *
157      * Emits an {Approval} event.
158      */
159     function approve(address spender, uint256 amount) external returns (bool);
160 
161     /**
162      * @dev Moves `amount` tokens from `from` to `to` using the
163      * allowance mechanism. `amount` is then deducted from the caller's
164      * allowance.
165      *
166      * Returns a boolean value indicating whether the operation succeeded.
167      *
168      * Emits a {Transfer} event.
169      */
170     function transferFrom(
171         address from,
172         address to,
173         uint256 amount
174     ) external returns (bool);
175 
176     /**
177      * @dev Emitted when `value` tokens are moved from one account (`from`) to
178      * another (`to`).
179      *
180      * Note that `value` may be zero.
181      */
182     event Transfer(address indexed from, address indexed to, uint256 value);
183 
184     /**
185      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
186      * a call to {approve}. `value` is the new allowance.
187      */
188     event Approval(address indexed owner, address indexed spender, uint256 value);
189 }
190 
191 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
192 
193 
194 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
195 
196 pragma solidity ^0.8.0;
197 
198 
199 /**
200  * @dev Interface for the optional metadata functions from the ERC20 standard.
201  *
202  * _Available since v4.1._
203  */
204 interface IERC20Metadata is IERC20 {
205     /**
206      * @dev Returns the name of the token.
207      */
208     function name() external view returns (string memory);
209 
210     /**
211      * @dev Returns the symbol of the token.
212      */
213     function symbol() external view returns (string memory);
214 
215     /**
216      * @dev Returns the decimals places of the token.
217      */
218     function decimals() external view returns (uint8);
219 }
220 
221 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
222 
223 
224 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
225 
226 pragma solidity ^0.8.0;
227 
228 
229 
230 
231 /**
232  * @dev Implementation of the {IERC20} interface.
233  *
234  * This implementation is agnostic to the way tokens are created. This means
235  * that a supply mechanism has to be added in a derived contract using {_mint}.
236  * For a generic mechanism see {ERC20PresetMinterPauser}.
237  *
238  * TIP: For a detailed writeup see our guide
239  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
240  * to implement supply mechanisms].
241  *
242  * We have followed general OpenZeppelin Contracts guidelines: functions revert
243  * instead returning `false` on failure. This behavior is nonetheless
244  * conventional and does not conflict with the expectations of ERC20
245  * applications.
246  *
247  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
248  * This allows applications to reconstruct the allowance for all accounts just
249  * by listening to said events. Other implementations of the EIP may not emit
250  * these events, as it isn't required by the specification.
251  *
252  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
253  * functions have been added to mitigate the well-known issues around setting
254  * allowances. See {IERC20-approve}.
255  */
256 contract ERC20 is Context, IERC20, IERC20Metadata {
257     mapping(address => uint256) private _balances;
258 
259     mapping(address => mapping(address => uint256)) private _allowances;
260 
261     uint256 private _totalSupply;
262 
263     string private _name;
264     string private _symbol;
265 
266     /**
267      * @dev Sets the values for {name} and {symbol}.
268      *
269      * The default value of {decimals} is 18. To select a different value for
270      * {decimals} you should overload it.
271      *
272      * All two of these values are immutable: they can only be set once during
273      * construction.
274      */
275     constructor(string memory name_, string memory symbol_) {
276         _name = name_;
277         _symbol = symbol_;
278     }
279 
280     /**
281      * @dev Returns the name of the token.
282      */
283     function name() public view virtual override returns (string memory) {
284         return _name;
285     }
286 
287     /**
288      * @dev Returns the symbol of the token, usually a shorter version of the
289      * name.
290      */
291     function symbol() public view virtual override returns (string memory) {
292         return _symbol;
293     }
294 
295     /**
296      * @dev Returns the number of decimals used to get its user representation.
297      * For example, if `decimals` equals `2`, a balance of `505` tokens should
298      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
299      *
300      * Tokens usually opt for a value of 18, imitating the relationship between
301      * Ether and Wei. This is the value {ERC20} uses, unless this function is
302      * overridden;
303      *
304      * NOTE: This information is only used for _display_ purposes: it in
305      * no way affects any of the arithmetic of the contract, including
306      * {IERC20-balanceOf} and {IERC20-transfer}.
307      */
308     function decimals() public view virtual override returns (uint8) {
309         return 18;
310     }
311 
312     /**
313      * @dev See {IERC20-totalSupply}.
314      */
315     function totalSupply() public view virtual override returns (uint256) {
316         return _totalSupply;
317     }
318 
319     /**
320      * @dev See {IERC20-balanceOf}.
321      */
322     function balanceOf(address account) public view virtual override returns (uint256) {
323         return _balances[account];
324     }
325 
326     /**
327      * @dev See {IERC20-transfer}.
328      *
329      * Requirements:
330      *
331      * - `to` cannot be the zero address.
332      * - the caller must have a balance of at least `amount`.
333      */
334     function transfer(address to, uint256 amount) public virtual override returns (bool) {
335         address owner = _msgSender();
336         _transfer(owner, to, amount);
337         return true;
338     }
339 
340     /**
341      * @dev See {IERC20-allowance}.
342      */
343     function allowance(address owner, address spender) public view virtual override returns (uint256) {
344         return _allowances[owner][spender];
345     }
346 
347     /**
348      * @dev See {IERC20-approve}.
349      *
350      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
351      * `transferFrom`. This is semantically equivalent to an infinite approval.
352      *
353      * Requirements:
354      *
355      * - `spender` cannot be the zero address.
356      */
357     function approve(address spender, uint256 amount) public virtual override returns (bool) {
358         address owner = _msgSender();
359         _approve(owner, spender, amount);
360         return true;
361     }
362 
363     /**
364      * @dev See {IERC20-transferFrom}.
365      *
366      * Emits an {Approval} event indicating the updated allowance. This is not
367      * required by the EIP. See the note at the beginning of {ERC20}.
368      *
369      * NOTE: Does not update the allowance if the current allowance
370      * is the maximum `uint256`.
371      *
372      * Requirements:
373      *
374      * - `from` and `to` cannot be the zero address.
375      * - `from` must have a balance of at least `amount`.
376      * - the caller must have allowance for ``from``'s tokens of at least
377      * `amount`.
378      */
379     function transferFrom(
380         address from,
381         address to,
382         uint256 amount
383     ) public virtual override returns (bool) {
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
404         _approve(owner, spender, _allowances[owner][spender] + addedValue);
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
424         uint256 currentAllowance = _allowances[owner][spender];
425         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
426         unchecked {
427             _approve(owner, spender, currentAllowance - subtractedValue);
428         }
429 
430         return true;
431     }
432 
433     /**
434      * @dev Moves `amount` of tokens from `sender` to `recipient`.
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
447     function _transfer(
448         address from,
449         address to,
450         uint256 amount
451     ) internal virtual {
452         require(from != address(0), "ERC20: transfer from the zero address");
453         require(to != address(0), "ERC20: transfer to the zero address");
454 
455         _beforeTokenTransfer(from, to, amount);
456 
457         uint256 fromBalance = _balances[from];
458         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
459         unchecked {
460             _balances[from] = fromBalance - amount;
461         }
462         _balances[to] += amount;
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
545      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
546      *
547      * Does not update the allowance amount in case of infinite allowance.
548      * Revert if not enough allowance is available.
549      *
550      * Might emit an {Approval} event.
551      */
552     function _spendAllowance(
553         address owner,
554         address spender,
555         uint256 amount
556     ) internal virtual {
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
580     function _beforeTokenTransfer(
581         address from,
582         address to,
583         uint256 amount
584     ) internal virtual {}
585 
586     /**
587      * @dev Hook that is called after any transfer of tokens. This includes
588      * minting and burning.
589      *
590      * Calling conditions:
591      *
592      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
593      * has been transferred to `to`.
594      * - when `from` is zero, `amount` tokens have been minted for `to`.
595      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
596      * - `from` and `to` are never both zero.
597      *
598      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
599      */
600     function _afterTokenTransfer(
601         address from,
602         address to,
603         uint256 amount
604     ) internal virtual {}
605 }
606 
607 
608 
609 //SPDX-License-Identifier: Unlicensed
610 pragma solidity ^0.8.17;
611 
612 
613 
614 
615 interface IUniswapV2Router01 {
616     function factory() external pure returns (address);
617     function WETH() external pure returns (address);
618 
619     function addLiquidity(
620         address tokenA,
621         address tokenB,
622         uint amountADesired,
623         uint amountBDesired,
624         uint amountAMin,
625         uint amountBMin,
626         address to,
627         uint deadline
628     ) external returns (uint amountA, uint amountB, uint liquidity);
629     function addLiquidityETH(
630         address token,
631         uint amountTokenDesired,
632         uint amountTokenMin,
633         uint amountETHMin,
634         address to,
635         uint deadline
636     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
637     function removeLiquidity(
638         address tokenA,
639         address tokenB,
640         uint liquidity,
641         uint amountAMin,
642         uint amountBMin,
643         address to,
644         uint deadline
645     ) external returns (uint amountA, uint amountB);
646     function removeLiquidityETH(
647         address token,
648         uint liquidity,
649         uint amountTokenMin,
650         uint amountETHMin,
651         address to,
652         uint deadline
653     ) external returns (uint amountToken, uint amountETH);
654     function removeLiquidityWithPermit(
655         address tokenA,
656         address tokenB,
657         uint liquidity,
658         uint amountAMin,
659         uint amountBMin,
660         address to,
661         uint deadline,
662         bool approveMax, uint8 v, bytes32 r, bytes32 s
663     ) external returns (uint amountA, uint amountB);
664     function removeLiquidityETHWithPermit(
665         address token,
666         uint liquidity,
667         uint amountTokenMin,
668         uint amountETHMin,
669         address to,
670         uint deadline,
671         bool approveMax, uint8 v, bytes32 r, bytes32 s
672     ) external returns (uint amountToken, uint amountETH);
673     function swapExactTokensForTokens(
674         uint amountIn,
675         uint amountOutMin,
676         address[] calldata path,
677         address to,
678         uint deadline
679     ) external returns (uint[] memory amounts);
680     function swapTokensForExactTokens(
681         uint amountOut,
682         uint amountInMax,
683         address[] calldata path,
684         address to,
685         uint deadline
686     ) external returns (uint[] memory amounts);
687     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
688         external
689         payable
690         returns (uint[] memory amounts);
691     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
692         external
693         returns (uint[] memory amounts);
694     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
695         external
696         returns (uint[] memory amounts);
697     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
698         external
699         payable
700         returns (uint[] memory amounts);
701 
702     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
703     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
704     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
705     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
706     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
707 }
708 
709 interface IUniswapV2Router02 is IUniswapV2Router01 {
710     function removeLiquidityETHSupportingFeeOnTransferTokens(
711         address token,
712         uint liquidity,
713         uint amountTokenMin,
714         uint amountETHMin,
715         address to,
716         uint deadline
717     ) external returns (uint amountETH);
718     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
719         address token,
720         uint liquidity,
721         uint amountTokenMin,
722         uint amountETHMin,
723         address to,
724         uint deadline,
725         bool approveMax, uint8 v, bytes32 r, bytes32 s
726     ) external returns (uint amountETH);
727 
728     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
729         uint amountIn,
730         uint amountOutMin,
731         address[] calldata path,
732         address to,
733         uint deadline
734     ) external;
735     function swapExactETHForTokensSupportingFeeOnTransferTokens(
736         uint amountOutMin,
737         address[] calldata path,
738         address to,
739         uint deadline
740     ) external payable;
741     function swapExactTokensForETHSupportingFeeOnTransferTokens(
742         uint amountIn,
743         uint amountOutMin,
744         address[] calldata path,
745         address to,
746         uint deadline
747     ) external;
748 }
749 
750 interface IUniswapV2Factory {
751     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
752 
753     function feeTo() external view returns (address);
754     function feeToSetter() external view returns (address);
755 
756     function getPair(address tokenA, address tokenB) external view returns (address pair);
757     function allPairs(uint) external view returns (address pair);
758     function allPairsLength() external view returns (uint);
759 
760     function createPair(address tokenA, address tokenB) external returns (address pair);
761 
762     function setFeeTo(address) external;
763     function setFeeToSetter(address) external;
764 }
765 
766 contract WAGMII is ERC20, Ownable {
767     IUniswapV2Router02 public uniswapV2Router;
768     address public immutable uniswapV2Pair;
769 
770     uint256 public swapTokensAtAmount = 500000 * (10**18);
771     uint256 public maxTransactionAmount = 20000000 * (10**18);
772     uint256 public maxWalletToken = 20000000 * (10**18);
773 
774     uint256 public liquidityFee = 1;
775     uint256 public marketingFee = 3;
776     uint256 public teamFee = 1;
777     uint256 private totalFees = liquidityFee+marketingFee+teamFee;
778     uint256 private _totalSupply = 1000000000 * (10**18); // 1 Billion tokens
779     
780 
781     bool private inSwapAndLiquify;
782     bool public swapAndLiquifyEnabled = true;
783 
784     address payable public marketingWallet = payable(0x9C29fCe80B857CE96fE757B93AedE86A95F22e43);
785     address payable public teamWallet = payable(0x3B675FB4bC5f4b7C86597C57826085996D037EF6);
786 
787     // exlcude from fees and max wallet
788     mapping (address => bool) private _isExcludedFromFees;
789 
790     event SwapAndLiquifyEnabledUpdated(bool enabled);
791     event SwapAndLiquify(uint256 tokensIntoLiqudity, uint256 ethReceived);
792     event ExcludeFromFees(address indexed account, bool isExcluded);
793    
794     modifier lockTheSwap {
795         inSwapAndLiquify = true;
796         _;
797         inSwapAndLiquify = false;
798     }
799 
800     constructor() ERC20("WAGMI Inc", "WAGMII") {
801     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
802          // Create a uniswap pair for this new token
803         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
804             .createPair(address(this), _uniswapV2Router.WETH());
805 
806         uniswapV2Router = _uniswapV2Router;
807         uniswapV2Pair = _uniswapV2Pair;
808 
809         // exclude from paying fees or having max wallet limit
810         excludeFromFees(owner(), true);
811         excludeFromFees(marketingWallet, true);
812         excludeFromFees(teamWallet, true);
813         excludeFromFees(address(this), true);
814         
815         /*
816             _mint is internal function that's called only once during deployment to mint maxSupply. No more tokens
817             can be created ever by any means.
818         */
819         _mint(owner(), _totalSupply);
820     }
821 
822     function totalSupply() public view virtual override returns (uint256) {
823         return _totalSupply;
824     }
825 
826     function _transfer(
827         address from,
828         address to,
829         uint256 amount
830     ) internal override {
831         require(from != address(0), "ERC20: transfer from the zero address");
832         require(to != address(0), "ERC20: transfer to the zero address");
833 
834         if(amount == 0) {
835             super._transfer(from, to, 0);
836             return;
837         }
838 
839         if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
840             require(amount <= maxTransactionAmount, "amount must be less than or equal to maxTx limit");
841         }
842 
843         if(from==uniswapV2Pair && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
844             uint256 contractBalanceRecepient = balanceOf(to);
845             require(contractBalanceRecepient + amount <= maxWalletToken, "Exceeds maximum wallet token amount.");
846         }
847 
848     	uint256 contractTokenBalance = balanceOf(address(this));
849         
850         bool overMinTokenBalance = contractTokenBalance >= swapTokensAtAmount;
851        
852         if(
853             overMinTokenBalance &&
854             !inSwapAndLiquify &&
855             to==uniswapV2Pair && 
856             swapAndLiquifyEnabled
857         ) {
858             contractTokenBalance = swapTokensAtAmount;
859             swapAndLiquify(contractTokenBalance);
860         }
861 
862          // if any account belongs to _isExcludedFromFee account then remove the fee
863         if(
864             !_isExcludedFromFees[from] && 
865             !_isExcludedFromFees[to] &&
866             (from==uniswapV2Pair || to==uniswapV2Pair)
867         ) {
868             uint256 fees = amount*totalFees/100;
869             amount = amount-fees;
870 
871             if(fees > 0) {
872                 super._transfer(from, address(this), fees); 
873             }
874              
875         }
876 
877         super._transfer(from, to, amount);
878 
879     }
880 
881     //handle tax tokens conversion for autoLP and Wallets
882 
883      function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
884         uint256 tokensForLiquidity = contractTokenBalance*liquidityFee/totalFees;
885         // split the Liquidity token balance into halves
886         uint256 half = tokensForLiquidity/2;
887         uint256 otherHalf = tokensForLiquidity-half;
888 
889         // capture the contract's current ETH balance.
890         uint256 initialBalance = address(this).balance;
891 
892         // swap tokens for ETH
893         swapTokensForEth(half); 
894 
895         // how much ETH did we just swap into?
896         uint256 newBalance = address(this).balance-initialBalance;
897 
898         // add liquidity to uniswap
899         addLiquidity(otherHalf, newBalance);
900 
901         emit SwapAndLiquify(half, newBalance);
902 
903         // swap and Send ether to team and marketing wallets
904         
905         swapTokensForEth(contractTokenBalance-tokensForLiquidity);
906         uint256 walletEth = address(this).balance;
907         uint256 teamShare = walletEth*teamFee/(totalFees-liquidityFee);
908         (bool teamS,) = teamWallet.call{value: teamShare}("");
909         require (teamS, "eth to team wallet failed");
910         (bool marketS,) = marketingWallet.call{value: walletEth - teamShare}("");
911         require (marketS, "eth to marketing wallet failed");
912         
913     }
914 
915     //converts taxed tokens to eth 
916 
917     function swapTokensForEth(uint256 tokenAmount) private {
918         // generate the uniswap pair path of token -> weth
919         address[] memory path = new address[](2);
920         path[0] = address(this);
921         path[1] = uniswapV2Router.WETH();
922 
923         if(allowance(address(this), address(uniswapV2Router)) < tokenAmount) {
924           _approve(address(this), address(uniswapV2Router), ~uint256(0));
925         }
926 
927         // make the swap
928         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
929             tokenAmount,
930             0, // accept any amount of ETH
931             path,
932             address(this),
933             block.timestamp
934         );
935         
936     }
937 
938     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
939         // add the liquidity
940         uniswapV2Router.addLiquidityETH{value: ethAmount}(
941             address(this),
942             tokenAmount,
943             0, // slippage is unavoidable
944             0, // slippage is unavoidable
945             owner(),
946             block.timestamp
947         );
948         
949     }
950 
951     function excludeFromFees(address account, bool excluded) public onlyOwner {
952         require(_isExcludedFromFees[account] != excluded, "Account is already the value of 'excluded'");
953         _isExcludedFromFees[account] = excluded;
954 
955         emit ExcludeFromFees(account, excluded);
956     }
957     
958     function isExcludedFromFees(address account) public view returns(bool) {
959         return _isExcludedFromFees[account];
960     }
961    
962     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
963         swapAndLiquifyEnabled = _enabled;
964         emit SwapAndLiquifyEnabledUpdated(_enabled);
965     }
966 
967     function setSwapTokensAtAmouunt(uint256 _newAmount) public onlyOwner {
968         swapTokensAtAmount = _newAmount;
969     }
970 
971     function setMaxWalletLimit(uint256 _newLimit) public onlyOwner {
972         maxWalletToken = _newLimit;
973         require(maxWalletToken >= totalSupply()/500, "value too low");
974     }
975 
976     function updateFee(uint256 _liqFee, uint256 _markFee, uint256 _teamFee) public onlyOwner {
977         liquidityFee = _liqFee;
978         marketingFee = _markFee;
979         teamFee = _teamFee;
980         totalFees = liquidityFee+marketingFee+teamFee;
981         require(totalFees <= 6, "tax too high");
982     }
983 
984     function updateWallets(address payable _marketing, address payable _team) public onlyOwner {
985         require (_marketing != address(0) || _team != address(0) , "marketing or team wallet can't be a zero address");
986         marketingWallet = _marketing;
987         teamWallet = _team;
988     }
989  // function to clear stucked ether from contract
990      function clearStuckedEther () external onlyOwner {
991         uint256 balance = address(this).balance;
992         (bool sent,) = owner().call{value: balance}("");
993         require (sent, "transfer failed");
994     }
995  // function to claim other erc20 token from contract if accidently sent by someone.
996     function claimOtherERC20token (address _token) external onlyOwner {
997         require (_token != address(0), "not a valid token");
998         IERC20 otherErc20Token = IERC20 (_token);
999         uint256 balance = otherErc20Token.balanceOf(address(this));
1000         otherErc20Token.transfer(owner(), balance);
1001 
1002     }
1003 
1004       receive() external payable {
1005 
1006   	}
1007 
1008 
1009   
1010 }