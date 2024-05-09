1 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
2 
3 pragma solidity >=0.6.2;
4 
5 interface IUniswapV2Router01 {
6     function factory() external pure returns (address);
7     function WETH() external pure returns (address);
8 
9     function addLiquidity(
10         address tokenA,
11         address tokenB,
12         uint amountADesired,
13         uint amountBDesired,
14         uint amountAMin,
15         uint amountBMin,
16         address to,
17         uint deadline
18     ) external returns (uint amountA, uint amountB, uint liquidity);
19     function addLiquidityETH(
20         address token,
21         uint amountTokenDesired,
22         uint amountTokenMin,
23         uint amountETHMin,
24         address to,
25         uint deadline
26     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
27     function removeLiquidity(
28         address tokenA,
29         address tokenB,
30         uint liquidity,
31         uint amountAMin,
32         uint amountBMin,
33         address to,
34         uint deadline
35     ) external returns (uint amountA, uint amountB);
36     function removeLiquidityETH(
37         address token,
38         uint liquidity,
39         uint amountTokenMin,
40         uint amountETHMin,
41         address to,
42         uint deadline
43     ) external returns (uint amountToken, uint amountETH);
44     function removeLiquidityWithPermit(
45         address tokenA,
46         address tokenB,
47         uint liquidity,
48         uint amountAMin,
49         uint amountBMin,
50         address to,
51         uint deadline,
52         bool approveMax, uint8 v, bytes32 r, bytes32 s
53     ) external returns (uint amountA, uint amountB);
54     function removeLiquidityETHWithPermit(
55         address token,
56         uint liquidity,
57         uint amountTokenMin,
58         uint amountETHMin,
59         address to,
60         uint deadline,
61         bool approveMax, uint8 v, bytes32 r, bytes32 s
62     ) external returns (uint amountToken, uint amountETH);
63     function swapExactTokensForTokens(
64         uint amountIn,
65         uint amountOutMin,
66         address[] calldata path,
67         address to,
68         uint deadline
69     ) external returns (uint[] memory amounts);
70     function swapTokensForExactTokens(
71         uint amountOut,
72         uint amountInMax,
73         address[] calldata path,
74         address to,
75         uint deadline
76     ) external returns (uint[] memory amounts);
77     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
78         external
79         payable
80         returns (uint[] memory amounts);
81     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
82         external
83         returns (uint[] memory amounts);
84     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
85         external
86         returns (uint[] memory amounts);
87     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
88         external
89         payable
90         returns (uint[] memory amounts);
91 
92     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
93     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
94     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
95     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
96     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
97 }
98 
99 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
100 
101 pragma solidity >=0.6.2;
102 
103 
104 interface IUniswapV2Router02 is IUniswapV2Router01 {
105     function removeLiquidityETHSupportingFeeOnTransferTokens(
106         address token,
107         uint liquidity,
108         uint amountTokenMin,
109         uint amountETHMin,
110         address to,
111         uint deadline
112     ) external returns (uint amountETH);
113     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
114         address token,
115         uint liquidity,
116         uint amountTokenMin,
117         uint amountETHMin,
118         address to,
119         uint deadline,
120         bool approveMax, uint8 v, bytes32 r, bytes32 s
121     ) external returns (uint amountETH);
122 
123     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
124         uint amountIn,
125         uint amountOutMin,
126         address[] calldata path,
127         address to,
128         uint deadline
129     ) external;
130     function swapExactETHForTokensSupportingFeeOnTransferTokens(
131         uint amountOutMin,
132         address[] calldata path,
133         address to,
134         uint deadline
135     ) external payable;
136     function swapExactTokensForETHSupportingFeeOnTransferTokens(
137         uint amountIn,
138         uint amountOutMin,
139         address[] calldata path,
140         address to,
141         uint deadline
142     ) external;
143 }
144 
145 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
146 
147 pragma solidity >=0.5.0;
148 
149 interface IUniswapV2Pair {
150     event Approval(address indexed owner, address indexed spender, uint value);
151     event Transfer(address indexed from, address indexed to, uint value);
152 
153     function name() external pure returns (string memory);
154     function symbol() external pure returns (string memory);
155     function decimals() external pure returns (uint8);
156     function totalSupply() external view returns (uint);
157     function balanceOf(address owner) external view returns (uint);
158     function allowance(address owner, address spender) external view returns (uint);
159 
160     function approve(address spender, uint value) external returns (bool);
161     function transfer(address to, uint value) external returns (bool);
162     function transferFrom(address from, address to, uint value) external returns (bool);
163 
164     function DOMAIN_SEPARATOR() external view returns (bytes32);
165     function PERMIT_TYPEHASH() external pure returns (bytes32);
166     function nonces(address owner) external view returns (uint);
167 
168     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
169 
170     event Mint(address indexed sender, uint amount0, uint amount1);
171     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
172     event Swap(
173         address indexed sender,
174         uint amount0In,
175         uint amount1In,
176         uint amount0Out,
177         uint amount1Out,
178         address indexed to
179     );
180     event Sync(uint112 reserve0, uint112 reserve1);
181 
182     function MINIMUM_LIQUIDITY() external pure returns (uint);
183     function factory() external view returns (address);
184     function token0() external view returns (address);
185     function token1() external view returns (address);
186     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
187     function price0CumulativeLast() external view returns (uint);
188     function price1CumulativeLast() external view returns (uint);
189     function kLast() external view returns (uint);
190 
191     function mint(address to) external returns (uint liquidity);
192     function burn(address to) external returns (uint amount0, uint amount1);
193     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
194     function skim(address to) external;
195     function sync() external;
196 
197     function initialize(address, address) external;
198 }
199 
200 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
201 
202 pragma solidity >=0.5.0;
203 
204 interface IUniswapV2Factory {
205     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
206 
207     function feeTo() external view returns (address);
208     function feeToSetter() external view returns (address);
209 
210     function getPair(address tokenA, address tokenB) external view returns (address pair);
211     function allPairs(uint) external view returns (address pair);
212     function allPairsLength() external view returns (uint);
213 
214     function createPair(address tokenA, address tokenB) external returns (address pair);
215 
216     function setFeeTo(address) external;
217     function setFeeToSetter(address) external;
218 }
219 
220 // File: @openzeppelin/contracts/utils/Context.sol
221 
222 
223 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
224 
225 pragma solidity ^0.8.0;
226 
227 /**
228  * @dev Provides information about the current execution context, including the
229  * sender of the transaction and its data. While these are generally available
230  * via msg.sender and msg.data, they should not be accessed in such a direct
231  * manner, since when dealing with meta-transactions the account sending and
232  * paying for execution may not be the actual sender (as far as an application
233  * is concerned).
234  *
235  * This contract is only required for intermediate, library-like contracts.
236  */
237 abstract contract Context {
238     function _msgSender() internal view virtual returns (address) {
239         return msg.sender;
240     }
241 
242     function _msgData() internal view virtual returns (bytes calldata) {
243         return msg.data;
244     }
245 }
246 
247 // File: @openzeppelin/contracts/access/Ownable.sol
248 
249 
250 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
251 
252 pragma solidity ^0.8.0;
253 
254 
255 /**
256  * @dev Contract module which provides a basic access control mechanism, where
257  * there is an account (an owner) that can be granted exclusive access to
258  * specific functions.
259  *
260  * By default, the owner account will be the one that deploys the contract. This
261  * can later be changed with {transferOwnership}.
262  *
263  * This module is used through inheritance. It will make available the modifier
264  * `onlyOwner`, which can be applied to your functions to restrict their use to
265  * the owner.
266  */
267 abstract contract Ownable is Context {
268     address private _owner;
269 
270     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
271 
272     /**
273      * @dev Initializes the contract setting the deployer as the initial owner.
274      */
275     constructor() {
276         _transferOwnership(_msgSender());
277     }
278 
279     /**
280      * @dev Throws if called by any account other than the owner.
281      */
282     modifier onlyOwner() {
283         _checkOwner();
284         _;
285     }
286 
287     /**
288      * @dev Returns the address of the current owner.
289      */
290     function owner() public view virtual returns (address) {
291         return _owner;
292     }
293 
294     /**
295      * @dev Throws if the sender is not the owner.
296      */
297     function _checkOwner() internal view virtual {
298         require(owner() == _msgSender(), "Ownable: caller is not the owner");
299     }
300 
301     /**
302      * @dev Leaves the contract without owner. It will not be possible to call
303      * `onlyOwner` functions. Can only be called by the current owner.
304      *
305      * NOTE: Renouncing ownership will leave the contract without an owner,
306      * thereby disabling any functionality that is only available to the owner.
307      */
308     function renounceOwnership() public virtual onlyOwner {
309         _transferOwnership(address(0));
310     }
311 
312     /**
313      * @dev Transfers ownership of the contract to a new account (`newOwner`).
314      * Can only be called by the current owner.
315      */
316     function transferOwnership(address newOwner) public virtual onlyOwner {
317         require(newOwner != address(0), "Ownable: new owner is the zero address");
318         _transferOwnership(newOwner);
319     }
320 
321     /**
322      * @dev Transfers ownership of the contract to a new account (`newOwner`).
323      * Internal function without access restriction.
324      */
325     function _transferOwnership(address newOwner) internal virtual {
326         address oldOwner = _owner;
327         _owner = newOwner;
328         emit OwnershipTransferred(oldOwner, newOwner);
329     }
330 }
331 
332 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
333 
334 
335 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
336 
337 pragma solidity ^0.8.0;
338 
339 /**
340  * @dev Interface of the ERC20 standard as defined in the EIP.
341  */
342 interface IERC20 {
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
356 
357     /**
358      * @dev Returns the amount of tokens in existence.
359      */
360     function totalSupply() external view returns (uint256);
361 
362     /**
363      * @dev Returns the amount of tokens owned by `account`.
364      */
365     function balanceOf(address account) external view returns (uint256);
366 
367     /**
368      * @dev Moves `amount` tokens from the caller's account to `to`.
369      *
370      * Returns a boolean value indicating whether the operation succeeded.
371      *
372      * Emits a {Transfer} event.
373      */
374     function transfer(address to, uint256 amount) external returns (bool);
375 
376     /**
377      * @dev Returns the remaining number of tokens that `spender` will be
378      * allowed to spend on behalf of `owner` through {transferFrom}. This is
379      * zero by default.
380      *
381      * This value changes when {approve} or {transferFrom} are called.
382      */
383     function allowance(address owner, address spender) external view returns (uint256);
384 
385     /**
386      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
387      *
388      * Returns a boolean value indicating whether the operation succeeded.
389      *
390      * IMPORTANT: Beware that changing an allowance with this method brings the risk
391      * that someone may use both the old and the new allowance by unfortunate
392      * transaction ordering. One possible solution to mitigate this race
393      * condition is to first reduce the spender's allowance to 0 and set the
394      * desired value afterwards:
395      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
396      *
397      * Emits an {Approval} event.
398      */
399     function approve(address spender, uint256 amount) external returns (bool);
400 
401     /**
402      * @dev Moves `amount` tokens from `from` to `to` using the
403      * allowance mechanism. `amount` is then deducted from the caller's
404      * allowance.
405      *
406      * Returns a boolean value indicating whether the operation succeeded.
407      *
408      * Emits a {Transfer} event.
409      */
410     function transferFrom(address from, address to, uint256 amount) external returns (bool);
411 }
412 
413 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
414 
415 
416 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
417 
418 pragma solidity ^0.8.0;
419 
420 
421 /**
422  * @dev Interface for the optional metadata functions from the ERC20 standard.
423  *
424  * _Available since v4.1._
425  */
426 interface IERC20Metadata is IERC20 {
427     /**
428      * @dev Returns the name of the token.
429      */
430     function name() external view returns (string memory);
431 
432     /**
433      * @dev Returns the symbol of the token.
434      */
435     function symbol() external view returns (string memory);
436 
437     /**
438      * @dev Returns the decimals places of the token.
439      */
440     function decimals() external view returns (uint8);
441 }
442 
443 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
444 
445 
446 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
447 
448 pragma solidity ^0.8.0;
449 
450 
451 
452 
453 /**
454  * @dev Implementation of the {IERC20} interface.
455  *
456  * This implementation is agnostic to the way tokens are created. This means
457  * that a supply mechanism has to be added in a derived contract using {_mint}.
458  * For a generic mechanism see {ERC20PresetMinterPauser}.
459  *
460  * TIP: For a detailed writeup see our guide
461  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
462  * to implement supply mechanisms].
463  *
464  * The default value of {decimals} is 18. To change this, you should override
465  * this function so it returns a different value.
466  *
467  * We have followed general OpenZeppelin Contracts guidelines: functions revert
468  * instead returning `false` on failure. This behavior is nonetheless
469  * conventional and does not conflict with the expectations of ERC20
470  * applications.
471  *
472  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
473  * This allows applications to reconstruct the allowance for all accounts just
474  * by listening to said events. Other implementations of the EIP may not emit
475  * these events, as it isn't required by the specification.
476  *
477  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
478  * functions have been added to mitigate the well-known issues around setting
479  * allowances. See {IERC20-approve}.
480  */
481 contract ERC20 is Context, IERC20, IERC20Metadata {
482     mapping(address => uint256) private _balances;
483 
484     mapping(address => mapping(address => uint256)) private _allowances;
485 
486     uint256 private _totalSupply;
487 
488     string private _name;
489     string private _symbol;
490 
491     /**
492      * @dev Sets the values for {name} and {symbol}.
493      *
494      * All two of these values are immutable: they can only be set once during
495      * construction.
496      */
497     constructor(string memory name_, string memory symbol_) {
498         _name = name_;
499         _symbol = symbol_;
500     }
501 
502     /**
503      * @dev Returns the name of the token.
504      */
505     function name() public view virtual override returns (string memory) {
506         return _name;
507     }
508 
509     /**
510      * @dev Returns the symbol of the token, usually a shorter version of the
511      * name.
512      */
513     function symbol() public view virtual override returns (string memory) {
514         return _symbol;
515     }
516 
517     /**
518      * @dev Returns the number of decimals used to get its user representation.
519      * For example, if `decimals` equals `2`, a balance of `505` tokens should
520      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
521      *
522      * Tokens usually opt for a value of 18, imitating the relationship between
523      * Ether and Wei. This is the default value returned by this function, unless
524      * it's overridden.
525      *
526      * NOTE: This information is only used for _display_ purposes: it in
527      * no way affects any of the arithmetic of the contract, including
528      * {IERC20-balanceOf} and {IERC20-transfer}.
529      */
530     function decimals() public view virtual override returns (uint8) {
531         return 18;
532     }
533 
534     /**
535      * @dev See {IERC20-totalSupply}.
536      */
537     function totalSupply() public view virtual override returns (uint256) {
538         return _totalSupply;
539     }
540 
541     /**
542      * @dev See {IERC20-balanceOf}.
543      */
544     function balanceOf(address account) public view virtual override returns (uint256) {
545         return _balances[account];
546     }
547 
548     /**
549      * @dev See {IERC20-transfer}.
550      *
551      * Requirements:
552      *
553      * - `to` cannot be the zero address.
554      * - the caller must have a balance of at least `amount`.
555      */
556     function transfer(address to, uint256 amount) public virtual override returns (bool) {
557         address owner = _msgSender();
558         _transfer(owner, to, amount);
559         return true;
560     }
561 
562     /**
563      * @dev See {IERC20-allowance}.
564      */
565     function allowance(address owner, address spender) public view virtual override returns (uint256) {
566         return _allowances[owner][spender];
567     }
568 
569     /**
570      * @dev See {IERC20-approve}.
571      *
572      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
573      * `transferFrom`. This is semantically equivalent to an infinite approval.
574      *
575      * Requirements:
576      *
577      * - `spender` cannot be the zero address.
578      */
579     function approve(address spender, uint256 amount) public virtual override returns (bool) {
580         address owner = _msgSender();
581         _approve(owner, spender, amount);
582         return true;
583     }
584 
585     /**
586      * @dev See {IERC20-transferFrom}.
587      *
588      * Emits an {Approval} event indicating the updated allowance. This is not
589      * required by the EIP. See the note at the beginning of {ERC20}.
590      *
591      * NOTE: Does not update the allowance if the current allowance
592      * is the maximum `uint256`.
593      *
594      * Requirements:
595      *
596      * - `from` and `to` cannot be the zero address.
597      * - `from` must have a balance of at least `amount`.
598      * - the caller must have allowance for ``from``'s tokens of at least
599      * `amount`.
600      */
601     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
602         address spender = _msgSender();
603         _spendAllowance(from, spender, amount);
604         _transfer(from, to, amount);
605         return true;
606     }
607 
608     /**
609      * @dev Atomically increases the allowance granted to `spender` by the caller.
610      *
611      * This is an alternative to {approve} that can be used as a mitigation for
612      * problems described in {IERC20-approve}.
613      *
614      * Emits an {Approval} event indicating the updated allowance.
615      *
616      * Requirements:
617      *
618      * - `spender` cannot be the zero address.
619      */
620     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
621         address owner = _msgSender();
622         _approve(owner, spender, allowance(owner, spender) + addedValue);
623         return true;
624     }
625 
626     /**
627      * @dev Atomically decreases the allowance granted to `spender` by the caller.
628      *
629      * This is an alternative to {approve} that can be used as a mitigation for
630      * problems described in {IERC20-approve}.
631      *
632      * Emits an {Approval} event indicating the updated allowance.
633      *
634      * Requirements:
635      *
636      * - `spender` cannot be the zero address.
637      * - `spender` must have allowance for the caller of at least
638      * `subtractedValue`.
639      */
640     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
641         address owner = _msgSender();
642         uint256 currentAllowance = allowance(owner, spender);
643         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
644         unchecked {
645             _approve(owner, spender, currentAllowance - subtractedValue);
646         }
647 
648         return true;
649     }
650 
651     /**
652      * @dev Moves `amount` of tokens from `from` to `to`.
653      *
654      * This internal function is equivalent to {transfer}, and can be used to
655      * e.g. implement automatic token fees, slashing mechanisms, etc.
656      *
657      * Emits a {Transfer} event.
658      *
659      * Requirements:
660      *
661      * - `from` cannot be the zero address.
662      * - `to` cannot be the zero address.
663      * - `from` must have a balance of at least `amount`.
664      */
665     function _transfer(address from, address to, uint256 amount) internal virtual {
666         require(from != address(0), "ERC20: transfer from the zero address");
667         require(to != address(0), "ERC20: transfer to the zero address");
668 
669         _beforeTokenTransfer(from, to, amount);
670 
671         uint256 fromBalance = _balances[from];
672         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
673         unchecked {
674             _balances[from] = fromBalance - amount;
675             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
676             // decrementing then incrementing.
677             _balances[to] += amount;
678         }
679 
680         emit Transfer(from, to, amount);
681 
682         _afterTokenTransfer(from, to, amount);
683     }
684 
685     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
686      * the total supply.
687      *
688      * Emits a {Transfer} event with `from` set to the zero address.
689      *
690      * Requirements:
691      *
692      * - `account` cannot be the zero address.
693      */
694     function _mint(address account, uint256 amount) internal virtual {
695         require(account != address(0), "ERC20: mint to the zero address");
696 
697         _beforeTokenTransfer(address(0), account, amount);
698 
699         _totalSupply += amount;
700         unchecked {
701             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
702             _balances[account] += amount;
703         }
704         emit Transfer(address(0), account, amount);
705 
706         _afterTokenTransfer(address(0), account, amount);
707     }
708 
709     /**
710      * @dev Destroys `amount` tokens from `account`, reducing the
711      * total supply.
712      *
713      * Emits a {Transfer} event with `to` set to the zero address.
714      *
715      * Requirements:
716      *
717      * - `account` cannot be the zero address.
718      * - `account` must have at least `amount` tokens.
719      */
720     function _burn(address account, uint256 amount) internal virtual {
721         require(account != address(0), "ERC20: burn from the zero address");
722 
723         _beforeTokenTransfer(account, address(0), amount);
724 
725         uint256 accountBalance = _balances[account];
726         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
727         unchecked {
728             _balances[account] = accountBalance - amount;
729             // Overflow not possible: amount <= accountBalance <= totalSupply.
730             _totalSupply -= amount;
731         }
732 
733         emit Transfer(account, address(0), amount);
734 
735         _afterTokenTransfer(account, address(0), amount);
736     }
737 
738     /**
739      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
740      *
741      * This internal function is equivalent to `approve`, and can be used to
742      * e.g. set automatic allowances for certain subsystems, etc.
743      *
744      * Emits an {Approval} event.
745      *
746      * Requirements:
747      *
748      * - `owner` cannot be the zero address.
749      * - `spender` cannot be the zero address.
750      */
751     function _approve(address owner, address spender, uint256 amount) internal virtual {
752         require(owner != address(0), "ERC20: approve from the zero address");
753         require(spender != address(0), "ERC20: approve to the zero address");
754 
755         _allowances[owner][spender] = amount;
756         emit Approval(owner, spender, amount);
757     }
758 
759     /**
760      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
761      *
762      * Does not update the allowance amount in case of infinite allowance.
763      * Revert if not enough allowance is available.
764      *
765      * Might emit an {Approval} event.
766      */
767     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
768         uint256 currentAllowance = allowance(owner, spender);
769         if (currentAllowance != type(uint256).max) {
770             require(currentAllowance >= amount, "ERC20: insufficient allowance");
771             unchecked {
772                 _approve(owner, spender, currentAllowance - amount);
773             }
774         }
775     }
776 
777     /**
778      * @dev Hook that is called before any transfer of tokens. This includes
779      * minting and burning.
780      *
781      * Calling conditions:
782      *
783      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
784      * will be transferred to `to`.
785      * - when `from` is zero, `amount` tokens will be minted for `to`.
786      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
787      * - `from` and `to` are never both zero.
788      *
789      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
790      */
791     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
792 
793     /**
794      * @dev Hook that is called after any transfer of tokens. This includes
795      * minting and burning.
796      *
797      * Calling conditions:
798      *
799      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
800      * has been transferred to `to`.
801      * - when `from` is zero, `amount` tokens have been minted for `to`.
802      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
803      * - `from` and `to` are never both zero.
804      *
805      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
806      */
807     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
808 }
809 
810 // File: contracts/Token.sol
811 
812 
813 
814 pragma solidity ^0.8.0;
815 
816 
817 
818 
819 
820 
821 contract XRAID is ERC20, Ownable {
822     modifier lockSwap() {
823         _inSwap = true;
824         _;
825         _inSwap = false;
826     }
827 
828     modifier liquidityAdd() {
829         _inLiquidityAdd = true;
830         _;
831         _inLiquidityAdd = false;
832     }
833 
834     uint256 public constant MAX_SUPPLY = 1_000_000_000 ether;
835     uint256 public constant BPS_DENOMINATOR = 10_000;
836     uint256 public constant SNIPE_BLOCKS = 2;
837 
838     IUniswapV2Router02 internal immutable _router;
839     address internal immutable _pair;
840 
841     /// @notice Buy taxes in BPS
842     uint256[2] public buyTaxes = [100, 6000];
843     /// @notice Sell taxes in BPS
844     uint256[2] public sellTaxes = [100, 6000];
845     /// @notice Maximum that can be bought in a single transaction
846     uint256 public maxBuy = 1_000_000 ether;
847     /// @notice tokens that are allocated for each tax
848     uint256[2] public totalTaxes;
849     /// @notice addresses that each tax is sent to
850     address payable[2] public taxWallets;
851     /// @notice Maps each recipient to their tax exlcusion status
852     mapping(address => bool) public taxExcluded;
853     /// @notice Maps each recipient to their blacklist status
854     mapping(address => bool) public blacklist;
855 
856     /// @notice Contract XRAID balance threshold before `_swap` is invoked
857     uint256 public minTokenBalance = 1000 ether;
858     /// @notice Flag for auto-calling `_swap`
859     bool public autoSwap = true;
860     /// @notice Flag indicating whether buys/sells are permitted
861     bool public tradingActive = false;
862     /// @notice Block when trading is first enabled
863     uint256 public tradingBlock;
864 
865     uint256 internal _totalSupply = 0;
866     mapping(address => uint256) private _balances;
867 
868     bool internal _inSwap = false;
869     bool internal _inLiquidityAdd = false;
870 
871     event TaxWalletsChanged(
872         address payable[2] previousWallets,
873         address payable[2] nextWallets
874     );
875     event BuyTaxesChanged(uint256[2] previousTaxes, uint256[2] nextTaxes);
876     event SellTaxesChanged(uint256[2] previousTaxes, uint256[2] nextTaxes);
877     event MinTokenBalanceChanged(uint256 previousMin, uint256 nextMin);
878     event MaxBuyChanged(uint256 previousMax, uint256 nextMax);
879     event TaxesRescued(uint256 index, uint256 amount);
880     event TradingActiveChanged(bool enabled);
881     event TaxExclusionChanged(address user, bool taxExcluded);
882     event BlacklistUpdated(address user, bool previousStatus, bool nextStatus);
883     event AutoSwapChanged(bool enabled);
884 
885     constructor(IUniswapV2Router02 _uniswapRouter, address payable[2] memory _taxWallets, uint256 _goupAmount)
886         ERC20("XRAID", "XRAID")
887         Ownable()
888     {
889         taxExcluded[owner()] = true;
890         taxExcluded[address(this)] = true;
891         taxWallets = _taxWallets;
892 
893         _router = _uniswapRouter;
894         _pair = IUniswapV2Factory(_uniswapRouter.factory()).createPair(
895             address(this),
896             _uniswapRouter.WETH()
897         );
898         _goup(owner(), _goupAmount);
899     }
900 
901     /// @notice Change the address of the tax wallets
902     /// @param _taxWallets The new address of the tax wallets
903     function setTaxWallets(address payable[2] memory _taxWallets)
904         external
905         onlyOwner
906     {
907         emit TaxWalletsChanged(taxWallets, _taxWallets);
908         taxWallets = _taxWallets;
909     }
910 
911     /// @notice Change the buy tax rates
912     /// @param _buyTaxes The new buy tax rates
913     function setBuyTaxes(uint256[2] memory _buyTaxes) external onlyOwner {
914         require(
915             _buyTaxes[0] + _buyTaxes[1] <= BPS_DENOMINATOR,
916             "sum(_buyTaxes) cannot exceed BPS_DENOMINATOR"
917         );
918         emit BuyTaxesChanged(buyTaxes, _buyTaxes);
919         buyTaxes = _buyTaxes;
920     }
921 
922     /// @notice Change the sell tax rates
923     /// @param _sellTaxes The new sell tax rates
924     function setSellTaxes(uint256[2] memory _sellTaxes) external onlyOwner {
925         require(
926             _sellTaxes[0] + _sellTaxes[1] <= BPS_DENOMINATOR,
927             "sum(_sellTaxes) cannot exceed BPS_DENOMINATOR"
928         );
929         emit SellTaxesChanged(sellTaxes, _sellTaxes);
930         sellTaxes = _sellTaxes;
931     }
932 
933     /// @notice Change the minimum contract XRAID balance before `_swap` gets invoked
934     /// @param _minTokenBalance The new minimum balance
935     function setMinTokenBalance(uint256 _minTokenBalance) external onlyOwner {
936         emit MinTokenBalanceChanged(minTokenBalance, _minTokenBalance);
937         minTokenBalance = _minTokenBalance;
938     }
939 
940     /// @notice Change the max buy amount
941     /// @param _maxBuy The new max buy amount
942     function setMaxBuy(uint256 _maxBuy) external onlyOwner {
943         emit MaxBuyChanged(maxBuy, _maxBuy);
944         maxBuy = _maxBuy;
945     }
946 
947     /// @notice Rescue XRAID from the taxes
948     /// @dev Should only be used in an emergency
949     /// @param _index The tax allocation to rescue from
950     /// @param _amount The amount of XRAID to rescue
951     /// @param _recipient The recipient of the rescued XRAID
952     function rescueTaxTokens(
953         uint256 _index,
954         uint256 _amount,
955         address _recipient
956     ) external onlyOwner {
957         require(0 <= _index && _index < totalTaxes.length, "_index OOB");
958         require(
959             _amount <= totalTaxes[_index],
960             "Amount cannot be greater than totalTax"
961         );
962         _rawTransfer(address(this), _recipient, _amount);
963         emit TaxesRescued(_index, _amount);
964         totalTaxes[_index] -= _amount;
965     }
966 
967     function addLiquidity(uint256 tokens)
968         external
969         payable
970         onlyOwner
971         liquidityAdd
972     {
973         _goup(address(this), tokens);
974         _approve(address(this), address(_router), tokens);
975 
976         _router.addLiquidityETH{value: msg.value}(
977             address(this),
978             tokens,
979             0,
980             0,
981             owner(),
982             // solhint-disable-next-line not-rely-on-time
983             block.timestamp
984         );
985     }
986 
987     /// @notice Admin function to update a recipient's blacklist status
988     /// @param user the recipient
989     /// @param status the new status
990     function updateBlacklist(address user, bool status)
991         external
992         virtual
993         onlyOwner
994     {
995         _updateBlacklist(user, status);
996     }
997 
998     function _updateBlacklist(address user, bool status) internal {
999         emit BlacklistUpdated(user, blacklist[user], status);
1000         blacklist[user] = status;
1001     }
1002 
1003     /// @notice Enables or disables trading on Uniswap
1004     function setTradingActive(bool _tradingActive) external onlyOwner {
1005         tradingActive = _tradingActive;
1006         tradingBlock = block.number;
1007         emit TradingActiveChanged(_tradingActive);
1008     }
1009 
1010     /// @notice Updates tax exclusion status
1011     /// @param _account Account to update the tax exclusion status of
1012     /// @param _taxExcluded If true, exclude taxes for this user
1013     function setTaxExcluded(address _account, bool _taxExcluded)
1014         external
1015         onlyOwner
1016     {
1017         taxExcluded[_account] = _taxExcluded;
1018         emit TaxExclusionChanged(_account, _taxExcluded);
1019     }
1020 
1021     /// @notice Enable or disable whether swap occurs during `_transfer`
1022     /// @param _autoSwap If true, enables swap during `_transfer`
1023     function setAutoSwap(bool _autoSwap) external onlyOwner {
1024         autoSwap = _autoSwap;
1025         emit AutoSwapChanged(_autoSwap);
1026     }
1027 
1028     function balanceOf(address account)
1029         public
1030         view
1031         virtual
1032         override
1033         returns (uint256)
1034     {
1035         return _balances[account];
1036     }
1037 
1038     function _addBalance(address account, uint256 amount) internal {
1039         _balances[account] = _balances[account] + amount;
1040     }
1041 
1042     function _subtractBalance(address account, uint256 amount) internal {
1043         _balances[account] = _balances[account] - amount;
1044     }
1045 
1046     function _transfer(
1047         address sender,
1048         address recipient,
1049         uint256 amount
1050     ) internal override {
1051         require(!blacklist[recipient], "Recipient is blacklisted");
1052 
1053         if (taxExcluded[sender] || taxExcluded[recipient]) {
1054             _rawTransfer(sender, recipient, amount);
1055             return;
1056         }
1057 
1058         if (
1059             totalTaxes[0] + totalTaxes[1] >= minTokenBalance &&
1060             !_inSwap &&
1061             sender != _pair &&
1062             autoSwap
1063         ) {
1064             _swap();
1065         }
1066 
1067         uint256 send = amount;
1068         uint256[2] memory taxes;
1069         if (sender == _pair) {
1070             require(tradingActive, "Trading is not yet active");
1071             if (block.number <= tradingBlock + SNIPE_BLOCKS) {
1072                 _updateBlacklist(recipient, true);
1073             }
1074             (send, taxes) = _getTaxAmounts(amount, true);
1075             require(amount <= maxBuy, "Buy amount exceeds maxBuy");
1076         } else if (recipient == _pair) {
1077             require(tradingActive, "Trading is not yet active");
1078             (send, taxes) = _getTaxAmounts(amount, false);
1079         }
1080         _rawTransfer(sender, recipient, send);
1081         _takeTaxes(sender, taxes);
1082     }
1083 
1084     /// @notice Perform a Uniswap v2 swap from XRAID to ETH and handle tax distribution
1085     function _swap() internal lockSwap {
1086         address[] memory path = new address[](2);
1087         path[0] = address(this);
1088         path[1] = _router.WETH();
1089 
1090         uint256 walletTaxes = totalTaxes[0] + totalTaxes[1];
1091 
1092         _approve(address(this), address(_router), walletTaxes);
1093         _router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1094             walletTaxes,
1095             0, // accept any amount of ETH
1096             path,
1097             address(this),
1098             block.timestamp
1099         );
1100         uint256 contractEthBalance = address(this).balance;
1101 
1102         uint256 tax0Eth = (contractEthBalance * totalTaxes[0]) / walletTaxes;
1103         uint256 tax1Eth = (contractEthBalance * totalTaxes[1]) / walletTaxes;
1104         totalTaxes = [0, 0];
1105 
1106         if (tax0Eth > 0) {
1107             taxWallets[0].transfer(tax0Eth);
1108         }
1109         if (tax1Eth > 0) {
1110             taxWallets[1].transfer(tax1Eth);
1111         }
1112     }
1113 
1114     function swapAll() external {
1115         if (!_inSwap) {
1116             _swap();
1117         }
1118     }
1119 
1120     function withdrawAll() external onlyOwner {
1121         payable(owner()).transfer(address(this).balance);
1122     }
1123 
1124     /// @notice Transfers XRAID from an account to this contract for taxes
1125     /// @param _account The account to transfer XRAID from
1126     /// @param _taxAmounts The amount for each tax
1127     function _takeTaxes(address _account, uint256[2] memory _taxAmounts)
1128         internal
1129     {
1130         require(_account != address(0), "taxation from the zero address");
1131 
1132         uint256 totalAmount = _taxAmounts[0] + _taxAmounts[1];
1133         _rawTransfer(_account, address(this), totalAmount);
1134         totalTaxes[0] += _taxAmounts[0];
1135         totalTaxes[1] += _taxAmounts[1];
1136     }
1137 
1138     /// @notice Get a breakdown of send and tax amounts
1139     /// @param amount The amount to tax in wei
1140     /// @return send The raw amount to send
1141     /// @return taxes The raw tax amounts
1142     function _getTaxAmounts(uint256 amount, bool buying)
1143         internal
1144         view
1145         returns (uint256 send, uint256[2] memory taxes)
1146     {
1147         if (buying) {
1148             taxes = [
1149                 (amount * buyTaxes[0]) / BPS_DENOMINATOR,
1150                 (amount * buyTaxes[1]) / BPS_DENOMINATOR
1151             ];
1152         } else {
1153             taxes = [
1154                 (amount * sellTaxes[0]) / BPS_DENOMINATOR,
1155                 (amount * sellTaxes[1]) / BPS_DENOMINATOR
1156             ];
1157         }
1158         send = amount - taxes[0] - taxes[1];
1159     }
1160 
1161     // modified from OpenZeppelin ERC20
1162     function _rawTransfer(
1163         address sender,
1164         address recipient,
1165         uint256 amount
1166     ) internal {
1167         require(sender != address(0), "transfer from the zero address");
1168         require(recipient != address(0), "transfer to the zero address");
1169 
1170         uint256 senderBalance = balanceOf(sender);
1171         require(senderBalance >= amount, "transfer amount exceeds balance");
1172         unchecked {
1173             _subtractBalance(sender, amount);
1174         }
1175         _addBalance(recipient, amount);
1176 
1177         emit Transfer(sender, recipient, amount);
1178     }
1179 
1180     function totalSupply() public view override returns (uint256) {
1181         return _totalSupply;
1182     }
1183 
1184     function _goup(address account, uint256 amount) internal {
1185         require(_totalSupply + amount <= MAX_SUPPLY, "Max supply exceeded");
1186         _totalSupply += amount;
1187         _addBalance(account, amount);
1188         emit Transfer(address(0), account, amount);
1189     }
1190 
1191     receive() external payable {}
1192 }