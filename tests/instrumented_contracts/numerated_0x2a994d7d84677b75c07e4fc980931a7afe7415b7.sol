1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.5.0;
4 
5 interface IUniswapV2Pair {
6     event Approval(address indexed owner, address indexed spender, uint value);
7     event Transfer(address indexed from, address indexed to, uint value);
8 
9     function name() external pure returns (string memory);
10     function symbol() external pure returns (string memory);
11     function decimals() external pure returns (uint8);
12     function totalSupply() external view returns (uint);
13     function balanceOf(address owner) external view returns (uint);
14     function allowance(address owner, address spender) external view returns (uint);
15 
16     function approve(address spender, uint value) external returns (bool);
17     function transfer(address to, uint value) external returns (bool);
18     function transferFrom(address from, address to, uint value) external returns (bool);
19 
20     function DOMAIN_SEPARATOR() external view returns (bytes32);
21     function PERMIT_TYPEHASH() external pure returns (bytes32);
22     function nonces(address owner) external view returns (uint);
23 
24     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
25 
26     event Mint(address indexed sender, uint amount0, uint amount1);
27     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
28     event Swap(
29         address indexed sender,
30         uint amount0In,
31         uint amount1In,
32         uint amount0Out,
33         uint amount1Out,
34         address indexed to
35     );
36     event Sync(uint112 reserve0, uint112 reserve1);
37 
38     function MINIMUM_LIQUIDITY() external pure returns (uint);
39     function factory() external view returns (address);
40     function token0() external view returns (address);
41     function token1() external view returns (address);
42     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
43     function price0CumulativeLast() external view returns (uint);
44     function price1CumulativeLast() external view returns (uint);
45     function kLast() external view returns (uint);
46 
47     function mint(address to) external returns (uint liquidity);
48     function burn(address to) external returns (uint amount0, uint amount1);
49     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
50     function skim(address to) external;
51     function sync() external;
52 
53     function initialize(address, address) external;
54 }
55 
56 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
57 
58 pragma solidity >=0.5.0;
59 
60 interface IUniswapV2Factory {
61     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
62 
63     function feeTo() external view returns (address);
64     function feeToSetter() external view returns (address);
65 
66     function getPair(address tokenA, address tokenB) external view returns (address pair);
67     function allPairs(uint) external view returns (address pair);
68     function allPairsLength() external view returns (uint);
69 
70     function createPair(address tokenA, address tokenB) external returns (address pair);
71 
72     function setFeeTo(address) external;
73     function setFeeToSetter(address) external;
74 }
75 
76 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
77 
78 pragma solidity >=0.6.2;
79 
80 interface IUniswapV2Router01 {
81     function factory() external pure returns (address);
82     function WETH() external pure returns (address);
83 
84     function addLiquidity(
85         address tokenA,
86         address tokenB,
87         uint amountADesired,
88         uint amountBDesired,
89         uint amountAMin,
90         uint amountBMin,
91         address to,
92         uint deadline
93     ) external returns (uint amountA, uint amountB, uint liquidity);
94     function addLiquidityETH(
95         address token,
96         uint amountTokenDesired,
97         uint amountTokenMin,
98         uint amountETHMin,
99         address to,
100         uint deadline
101     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
102     function removeLiquidity(
103         address tokenA,
104         address tokenB,
105         uint liquidity,
106         uint amountAMin,
107         uint amountBMin,
108         address to,
109         uint deadline
110     ) external returns (uint amountA, uint amountB);
111     function removeLiquidityETH(
112         address token,
113         uint liquidity,
114         uint amountTokenMin,
115         uint amountETHMin,
116         address to,
117         uint deadline
118     ) external returns (uint amountToken, uint amountETH);
119     function removeLiquidityWithPermit(
120         address tokenA,
121         address tokenB,
122         uint liquidity,
123         uint amountAMin,
124         uint amountBMin,
125         address to,
126         uint deadline,
127         bool approveMax, uint8 v, bytes32 r, bytes32 s
128     ) external returns (uint amountA, uint amountB);
129     function removeLiquidityETHWithPermit(
130         address token,
131         uint liquidity,
132         uint amountTokenMin,
133         uint amountETHMin,
134         address to,
135         uint deadline,
136         bool approveMax, uint8 v, bytes32 r, bytes32 s
137     ) external returns (uint amountToken, uint amountETH);
138     function swapExactTokensForTokens(
139         uint amountIn,
140         uint amountOutMin,
141         address[] calldata path,
142         address to,
143         uint deadline
144     ) external returns (uint[] memory amounts);
145     function swapTokensForExactTokens(
146         uint amountOut,
147         uint amountInMax,
148         address[] calldata path,
149         address to,
150         uint deadline
151     ) external returns (uint[] memory amounts);
152     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
153         external
154         payable
155         returns (uint[] memory amounts);
156     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
157         external
158         returns (uint[] memory amounts);
159     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
160         external
161         returns (uint[] memory amounts);
162     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
163         external
164         payable
165         returns (uint[] memory amounts);
166 
167     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
168     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
169     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
170     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
171     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
172 }
173 
174 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
175 
176 pragma solidity >=0.6.2;
177 
178 
179 interface IUniswapV2Router02 is IUniswapV2Router01 {
180     function removeLiquidityETHSupportingFeeOnTransferTokens(
181         address token,
182         uint liquidity,
183         uint amountTokenMin,
184         uint amountETHMin,
185         address to,
186         uint deadline
187     ) external returns (uint amountETH);
188     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
189         address token,
190         uint liquidity,
191         uint amountTokenMin,
192         uint amountETHMin,
193         address to,
194         uint deadline,
195         bool approveMax, uint8 v, bytes32 r, bytes32 s
196     ) external returns (uint amountETH);
197 
198     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
199         uint amountIn,
200         uint amountOutMin,
201         address[] calldata path,
202         address to,
203         uint deadline
204     ) external;
205     function swapExactETHForTokensSupportingFeeOnTransferTokens(
206         uint amountOutMin,
207         address[] calldata path,
208         address to,
209         uint deadline
210     ) external payable;
211     function swapExactTokensForETHSupportingFeeOnTransferTokens(
212         uint amountIn,
213         uint amountOutMin,
214         address[] calldata path,
215         address to,
216         uint deadline
217     ) external;
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
810 // File: narco.sol
811 
812 
813 pragma solidity 0.8.20;
814 
815 
816 
817 
818 
819 
820 
821 
822 contract Token is Context, IERC20Metadata, ERC20, Ownable {
823     IUniswapV2Router02 public uniswapV2Router;
824     address public uniswapV2Pair;
825 
826     address public _feesWallet;
827 
828     mapping(address => bool) private _notAllowed;
829     bool private _tradingEnabled;
830     bool private _isInFeeTransfer;
831    
832     mapping(address => uint256) private _walletLastTxBlock;
833     mapping(address => bool) private _earlyWallets;
834 
835     event TradingEnabled(bool enabled);
836     event EarlyWallet(address indexed wallet);
837 
838     constructor() ERC20("Mr. Narco", "NARCO") {
839         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
840         IUniswapV2Factory _uniswapV2Factory = IUniswapV2Factory(_uniswapV2Router.factory());
841         uniswapV2Pair = _uniswapV2Factory.createPair(address(this), _uniswapV2Router.WETH());
842         uniswapV2Router = _uniswapV2Router;
843         
844         _feesWallet = msg.sender;
845         
846         
847                            //mev bots
848         _notAllowed[0x00000000A991C429eE2Ec6df19d40fe0c80088B8] = true;
849         _notAllowed[0x2d2A7d56773ae7d5c7b9f1B57f7Be05039447B4D] = true;
850         _notAllowed[0x0000Cd00001700b10049DfC947103E00E1C62683] = true;
851         _notAllowed[0x5093013aaAEe47c868FA3c317fE7840A3D8F8804] = true;
852         _notAllowed[0xae2Fc483527B8EF99EB5D9B44875F005ba1FaE13] = true;
853         _notAllowed[0x6b75d8AF000000e20B7a7DDf000Ba900b4009A80] = true;
854         _notAllowed[0x4D521577f820525964C392352bB220482F1Aa63b] = true;
855         _notAllowed[0xE8c060F8052E07423f71D445277c61AC5138A2e5] = true;
856         _notAllowed[0x025050C351452d8738fc6ac8792a4B87883Ca055] = true;
857         _notAllowed[0xeC634e1bD59BD3c57376AFd1Eb65dA710117d021] = true;
858         _notAllowed[0xcF46410c12a9FE76c563d991AB1e8b28BD0E1b85] = true;
859         _notAllowed[0x7E3adCA78A9DA982363C27CE556AFa7934B9Bc1b] = true;
860         _notAllowed[0x463D06149E73cba191D1b4cab446c60fC7658513] = true;
861         _notAllowed[0xE16D4e4e3AD1e151E1977bB89fcd3E8791F98210] = true;
862         _notAllowed[0x2259D78c01d58AE40A104f81bFb1152Ec46206F5] = true;
863         _notAllowed[0x4206dB5B280263877F5374304d226B0b69605868] = true;
864         _notAllowed[0x899E5A6E122B2eB0c88531D47eC577A43c29c086] = true;
865 
866         
867         _earlyWallets[_msgSender()] = true;
868         _earlyWallets[address(this)] = true;
869         _earlyWallets[_feesWallet] = true;
870   
871         
872         _mint(_msgSender(), 569_000_000_000_000 ether); // mint all tokens to the deployer wallet
873         
874         
875     }
876 
877     function enableTrading() external onlyOwner {
878         _tradingEnabled = true;
879         emit TradingEnabled(true);
880     }
881 
882     function setEarlyWallets(address[] memory addresses) public onlyOwner {
883       for (uint i=0; i<addresses.length; i++) {
884         _earlyWallets[addresses[i]] = true;
885         emit EarlyWallet(addresses[i]);
886       }
887     }
888 
889     function isEarly(address account) public view returns (bool) {
890         return _earlyWallets[account];
891     }
892 
893 
894     function _beforeTokenTransfer(
895         address sender,
896         address recipient,
897         uint256 amount
898     ) override internal virtual {
899         require(isEarly(sender) || isEarly(recipient) || _tradingEnabled, "Trading has not started");
900         super._beforeTokenTransfer(sender, recipient, amount);
901     }
902 
903     function _transfer(address sender, address recipient, uint256 amount) internal virtual override {
904          require (!_notAllowed[recipient], "bot not allowed");
905          require (!_notAllowed[sender], "bot not allowed");
906         if (isBuy(sender)) {
907           _walletLastTxBlock[recipient] = block.number;
908         }
909         if(isSale(recipient) && isSecondTxInSameBlock(sender)) {
910           transferWithFees(sender, recipient, amount, 5);
911           return;
912         }
913     
914         super._transfer(sender, recipient, amount);
915        
916     }
917 
918     function manageBots (address _newBot, bool value) external onlyOwner {
919       _notAllowed[_newBot] = value;
920     }
921 
922     function updateFeeWallet (address _newWallet) external onlyOwner {
923       require (_newWallet != address(0), "zero address is not allowed");
924       _feesWallet = _newWallet;
925     }
926     
927 
928     function transferWithFees(address sender, address recipient, uint amount, uint8 _percentage) internal {
929         if (_isInFeeTransfer) {
930           return;
931         }
932         uint256 tax = amount * _percentage / 100;
933         uint256 netAmount = amount - tax;
934         _isInFeeTransfer = true;
935         if(netAmount > 0){
936         super._transfer(sender, recipient, netAmount);
937         }
938         super._transfer(sender, _feesWallet, tax);
939         _isInFeeTransfer = false;
940     }
941 
942     function burn (uint256 amount) external {
943       _burn(msg.sender, amount);
944     }
945 
946     function isBuy(address _from) internal view returns(bool) {
947         return uniswapV2Pair == _from;
948     }
949 
950     function isSale(address _to) internal view returns(bool) {
951         return uniswapV2Pair == _to;
952     }
953 
954     function isSecondTxInSameBlock(address _from) internal view returns(bool) {
955         return _walletLastTxBlock[_from] == block.number;
956     }
957 
958 }