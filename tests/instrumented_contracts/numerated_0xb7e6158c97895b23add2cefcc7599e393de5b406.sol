1 pragma solidity ^0.8.0;
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7 
8     function _msgData() internal view virtual returns (bytes calldata) {
9         return msg.data;
10     }
11 }
12 
13 abstract contract Ownable is Context {
14     address private _owner;
15 
16     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18     /**
19      * @dev Initializes the contract setting the deployer as the initial owner.
20      */
21     constructor() {
22         _transferOwnership(_msgSender());
23     }
24 
25     /**
26      * @dev Returns the address of the current owner.
27      */
28     function owner() public view virtual returns (address) {
29         return _owner;
30     }
31 
32     /**
33      * @dev Throws if called by any account other than the owner.
34      */
35     modifier onlyOwner() {
36         require(owner() == _msgSender(), "Ownable: caller is not the owner");
37         _;
38     }
39 
40     /**
41      * @dev Leaves the contract without owner. It will not be possible to call
42      * `onlyOwner` functions anymore. Can only be called by the current owner.
43      *
44      * NOTE: Renouncing ownership will leave the contract without an owner,
45      * thereby removing any functionality that is only available to the owner.
46      */
47     function renounceOwnership() public virtual onlyOwner {
48         _transferOwnership(address(0));
49     }
50 
51     /**
52      * @dev Transfers ownership of the contract to a new account (`newOwner`).
53      * Can only be called by the current owner.
54      */
55     function transferOwnership(address newOwner) public virtual onlyOwner {
56         require(newOwner != address(0), "Ownable: new owner is the zero address");
57         _transferOwnership(newOwner);
58     }
59 
60     /**
61      * @dev Transfers ownership of the contract to a new account (`newOwner`).
62      * Internal function without access restriction.
63      */
64     function _transferOwnership(address newOwner) internal virtual {
65         address oldOwner = _owner;
66         _owner = newOwner;
67         emit OwnershipTransferred(oldOwner, newOwner);
68     }
69 }
70 
71 interface IUniswapV2Pair {
72     event Approval(address indexed owner, address indexed spender, uint value);
73     event Transfer(address indexed from, address indexed to, uint value);
74 
75     function name() external pure returns (string memory);
76     function symbol() external pure returns (string memory);
77     function decimals() external pure returns (uint8);
78     function totalSupply() external view returns (uint);
79     function balanceOf(address owner) external view returns (uint);
80     function allowance(address owner, address spender) external view returns (uint);
81 
82     function approve(address spender, uint value) external returns (bool);
83     function transfer(address to, uint value) external returns (bool);
84     function transferFrom(address from, address to, uint value) external returns (bool);
85 
86     function DOMAIN_SEPARATOR() external view returns (bytes32);
87     function PERMIT_TYPEHASH() external pure returns (bytes32);
88     function nonces(address owner) external view returns (uint);
89 
90     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
91 
92     event Mint(address indexed sender, uint amount0, uint amount1);
93     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
94     event Swap(
95         address indexed sender,
96         uint amount0In,
97         uint amount1In,
98         uint amount0Out,
99         uint amount1Out,
100         address indexed to
101     );
102     event Sync(uint112 reserve0, uint112 reserve1);
103 
104     function MINIMUM_LIQUIDITY() external pure returns (uint);
105     function factory() external view returns (address);
106     function token0() external view returns (address);
107     function token1() external view returns (address);
108     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
109     function price0CumulativeLast() external view returns (uint);
110     function price1CumulativeLast() external view returns (uint);
111     function kLast() external view returns (uint);
112 
113     function mint(address to) external returns (uint liquidity);
114     function burn(address to) external returns (uint amount0, uint amount1);
115     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
116     function skim(address to) external;
117     function sync() external;
118 
119     function initialize(address, address) external;
120 }
121 
122 interface IUniswapV2Factory {
123     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
124 
125     function feeTo() external view returns (address);
126     function feeToSetter() external view returns (address);
127 
128     function getPair(address tokenA, address tokenB) external view returns (address pair);
129     function allPairs(uint) external view returns (address pair);
130     function allPairsLength() external view returns (uint);
131 
132     function createPair(address tokenA, address tokenB) external returns (address pair);
133 
134     function setFeeTo(address) external;
135     function setFeeToSetter(address) external;
136 }
137 
138 interface IUniswapV2Router01 {
139     function factory() external pure returns (address);
140     function WETH() external pure returns (address);
141 
142     function addLiquidity(
143         address tokenA,
144         address tokenB,
145         uint amountADesired,
146         uint amountBDesired,
147         uint amountAMin,
148         uint amountBMin,
149         address to,
150         uint deadline
151     ) external returns (uint amountA, uint amountB, uint liquidity);
152     function addLiquidityETH(
153         address token,
154         uint amountTokenDesired,
155         uint amountTokenMin,
156         uint amountETHMin,
157         address to,
158         uint deadline
159     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
160     function removeLiquidity(
161         address tokenA,
162         address tokenB,
163         uint liquidity,
164         uint amountAMin,
165         uint amountBMin,
166         address to,
167         uint deadline
168     ) external returns (uint amountA, uint amountB);
169     function removeLiquidityETH(
170         address token,
171         uint liquidity,
172         uint amountTokenMin,
173         uint amountETHMin,
174         address to,
175         uint deadline
176     ) external returns (uint amountToken, uint amountETH);
177     function removeLiquidityWithPermit(
178         address tokenA,
179         address tokenB,
180         uint liquidity,
181         uint amountAMin,
182         uint amountBMin,
183         address to,
184         uint deadline,
185         bool approveMax, uint8 v, bytes32 r, bytes32 s
186     ) external returns (uint amountA, uint amountB);
187     function removeLiquidityETHWithPermit(
188         address token,
189         uint liquidity,
190         uint amountTokenMin,
191         uint amountETHMin,
192         address to,
193         uint deadline,
194         bool approveMax, uint8 v, bytes32 r, bytes32 s
195     ) external returns (uint amountToken, uint amountETH);
196     function swapExactTokensForTokens(
197         uint amountIn,
198         uint amountOutMin,
199         address[] calldata path,
200         address to,
201         uint deadline
202     ) external returns (uint[] memory amounts);
203     function swapTokensForExactTokens(
204         uint amountOut,
205         uint amountInMax,
206         address[] calldata path,
207         address to,
208         uint deadline
209     ) external returns (uint[] memory amounts);
210     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
211         external
212         payable
213         returns (uint[] memory amounts);
214     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
215         external
216         returns (uint[] memory amounts);
217     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
218         external
219         returns (uint[] memory amounts);
220     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
221         external
222         payable
223         returns (uint[] memory amounts);
224 
225     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
226     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
227     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
228     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
229     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
230 }
231 
232 interface IUniswapV2Router02 is IUniswapV2Router01 {
233     function removeLiquidityETHSupportingFeeOnTransferTokens(
234         address token,
235         uint liquidity,
236         uint amountTokenMin,
237         uint amountETHMin,
238         address to,
239         uint deadline
240     ) external returns (uint amountETH);
241     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
242         address token,
243         uint liquidity,
244         uint amountTokenMin,
245         uint amountETHMin,
246         address to,
247         uint deadline,
248         bool approveMax, uint8 v, bytes32 r, bytes32 s
249     ) external returns (uint amountETH);
250 
251     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
252         uint amountIn,
253         uint amountOutMin,
254         address[] calldata path,
255         address to,
256         uint deadline
257     ) external;
258     function swapExactETHForTokensSupportingFeeOnTransferTokens(
259         uint amountOutMin,
260         address[] calldata path,
261         address to,
262         uint deadline
263     ) external payable;
264     function swapExactTokensForETHSupportingFeeOnTransferTokens(
265         uint amountIn,
266         uint amountOutMin,
267         address[] calldata path,
268         address to,
269         uint deadline
270     ) external;
271 }
272 
273 interface IERC20 {
274     /**
275      * @dev Returns the amount of tokens in existence.
276      */
277     function totalSupply() external view returns (uint256);
278 
279     /**
280      * @dev Returns the amount of tokens owned by `account`.
281      */
282     function balanceOf(address account) external view returns (uint256);
283 
284     /**
285      * @dev Moves `amount` tokens from the caller's account to `recipient`.
286      *
287      * Returns a boolean value indicating whether the operation succeeded.
288      *
289      * Emits a {Transfer} event.
290      */
291     function transfer(address recipient, uint256 amount) external returns (bool);
292 
293     /**
294      * @dev Returns the remaining number of tokens that `spender` will be
295      * allowed to spend on behalf of `owner` through {transferFrom}. This is
296      * zero by default.
297      *
298      * This value changes when {approve} or {transferFrom} are called.
299      */
300     function allowance(address owner, address spender) external view returns (uint256);
301 
302     /**
303      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
304      *
305      * Returns a boolean value indicating whether the operation succeeded.
306      *
307      * IMPORTANT: Beware that changing an allowance with this method brings the risk
308      * that someone may use both the old and the new allowance by unfortunate
309      * transaction ordering. One possible solution to mitigate this race
310      * condition is to first reduce the spender's allowance to 0 and set the
311      * desired value afterwards:
312      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
313      *
314      * Emits an {Approval} event.
315      */
316     function approve(address spender, uint256 amount) external returns (bool);
317 
318     /**
319      * @dev Moves `amount` tokens from `sender` to `recipient` using the
320      * allowance mechanism. `amount` is then deducted from the caller's
321      * allowance.
322      *
323      * Returns a boolean value indicating whether the operation succeeded.
324      *
325      * Emits a {Transfer} event.
326      */
327     function transferFrom(
328         address sender,
329         address recipient,
330         uint256 amount
331     ) external returns (bool);
332 
333     /**
334      * @dev Emitted when `value` tokens are moved from one account (`from`) to
335      * another (`to`).
336      *
337      * Note that `value` may be zero.
338      */
339     event Transfer(address indexed from, address indexed to, uint256 value);
340 
341     /**
342      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
343      * a call to {approve}. `value` is the new allowance.
344      */
345     event Approval(address indexed owner, address indexed spender, uint256 value);
346 }
347 
348 interface IERC20Metadata is IERC20 {
349     /**
350      * @dev Returns the name of the token.
351      */
352     function name() external view returns (string memory);
353 
354     /**
355      * @dev Returns the symbol of the token.
356      */
357     function symbol() external view returns (string memory);
358 
359     /**
360      * @dev Returns the decimals places of the token.
361      */
362     function decimals() external view returns (uint8);
363 }
364 
365 contract ERC20 is Context, IERC20, IERC20Metadata {
366     mapping(address => uint256) private _balances;
367 
368     mapping(address => mapping(address => uint256)) private _allowances;
369 
370     uint256 private _totalSupply;
371 
372     string private _name;
373     string private _symbol;
374 
375     /**
376      * @dev Sets the values for {name} and {symbol}.
377      *
378      * The default value of {decimals} is 18. To select a different value for
379      * {decimals} you should overload it.
380      *
381      * All two of these values are immutable: they can only be set once during
382      * construction.
383      */
384     constructor(string memory name_, string memory symbol_) {
385         _name = name_;
386         _symbol = symbol_;
387     }
388 
389     /**
390      * @dev Returns the name of the token.
391      */
392     function name() public view virtual override returns (string memory) {
393         return _name;
394     }
395 
396     /**
397      * @dev Returns the symbol of the token, usually a shorter version of the
398      * name.
399      */
400     function symbol() public view virtual override returns (string memory) {
401         return _symbol;
402     }
403 
404     /**
405      * @dev Returns the number of decimals used to get its user representation.
406      * For example, if `decimals` equals `2`, a balance of `505` tokens should
407      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
408      *
409      * Tokens usually opt for a value of 18, imitating the relationship between
410      * Ether and Wei. This is the value {ERC20} uses, unless this function is
411      * overridden;
412      *
413      * NOTE: This information is only used for _display_ purposes: it in
414      * no way affects any of the arithmetic of the contract, including
415      * {IERC20-balanceOf} and {IERC20-transfer}.
416      */
417     function decimals() public view virtual override returns (uint8) {
418         return 18;
419     }
420 
421     /**
422      * @dev See {IERC20-totalSupply}.
423      */
424     function totalSupply() public view virtual override returns (uint256) {
425         return _totalSupply;
426     }
427 
428     /**
429      * @dev See {IERC20-balanceOf}.
430      */
431     function balanceOf(address account) public view virtual override returns (uint256) {
432         return _balances[account];
433     }
434 
435     /**
436      * @dev See {IERC20-transfer}.
437      *
438      * Requirements:
439      *
440      * - `to` cannot be the zero address.
441      * - the caller must have a balance of at least `amount`.
442      */
443     function transfer(address to, uint256 amount) public virtual override returns (bool) {
444         address owner = _msgSender();
445         _transfer(owner, to, amount);
446         return true;
447     }
448 
449     /**
450      * @dev See {IERC20-allowance}.
451      */
452     function allowance(address owner, address spender) public view virtual override returns (uint256) {
453         return _allowances[owner][spender];
454     }
455 
456     /**
457      * @dev See {IERC20-approve}.
458      *
459      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
460      * `transferFrom`. This is semantically equivalent to an infinite approval.
461      *
462      * Requirements:
463      *
464      * - `spender` cannot be the zero address.
465      */
466     function approve(address spender, uint256 amount) public virtual override returns (bool) {
467         address owner = _msgSender();
468         _approve(owner, spender, amount);
469         return true;
470     }
471 
472     /**
473      * @dev See {IERC20-transferFrom}.
474      *
475      * Emits an {Approval} event indicating the updated allowance. This is not
476      * required by the EIP. See the note at the beginning of {ERC20}.
477      *
478      * NOTE: Does not update the allowance if the current allowance
479      * is the maximum `uint256`.
480      *
481      * Requirements:
482      *
483      * - `from` and `to` cannot be the zero address.
484      * - `from` must have a balance of at least `amount`.
485      * - the caller must have allowance for ``from``'s tokens of at least
486      * `amount`.
487      */
488     function transferFrom(
489         address from,
490         address to,
491         uint256 amount
492     ) public virtual override returns (bool) {
493         address spender = _msgSender();
494         _spendAllowance(from, spender, amount);
495         _transfer(from, to, amount);
496         return true;
497     }
498 
499     /**
500      * @dev Atomically increases the allowance granted to `spender` by the caller.
501      *
502      * This is an alternative to {approve} that can be used as a mitigation for
503      * problems described in {IERC20-approve}.
504      *
505      * Emits an {Approval} event indicating the updated allowance.
506      *
507      * Requirements:
508      *
509      * - `spender` cannot be the zero address.
510      */
511     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
512         address owner = _msgSender();
513         _approve(owner, spender, _allowances[owner][spender] + addedValue);
514         return true;
515     }
516 
517     /**
518      * @dev Atomically decreases the allowance granted to `spender` by the caller.
519      *
520      * This is an alternative to {approve} that can be used as a mitigation for
521      * problems described in {IERC20-approve}.
522      *
523      * Emits an {Approval} event indicating the updated allowance.
524      *
525      * Requirements:
526      *
527      * - `spender` cannot be the zero address.
528      * - `spender` must have allowance for the caller of at least
529      * `subtractedValue`.
530      */
531     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
532         address owner = _msgSender();
533         uint256 currentAllowance = _allowances[owner][spender];
534         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
535         unchecked {
536             _approve(owner, spender, currentAllowance - subtractedValue);
537         }
538 
539         return true;
540     }
541 
542     /**
543      * @dev Moves `amount` of tokens from `sender` to `recipient`.
544      *
545      * This internal function is equivalent to {transfer}, and can be used to
546      * e.g. implement automatic token fees, slashing mechanisms, etc.
547      *
548      * Emits a {Transfer} event.
549      *
550      * Requirements:
551      *
552      * - `from` cannot be the zero address.
553      * - `to` cannot be the zero address.
554      * - `from` must have a balance of at least `amount`.
555      */
556     function _transfer(
557         address from,
558         address to,
559         uint256 amount
560     ) internal virtual {
561         require(from != address(0), "ERC20: transfer from the zero address");
562         require(to != address(0), "ERC20: transfer to the zero address");
563 
564         _beforeTokenTransfer(from, to, amount);
565 
566         uint256 fromBalance = _balances[from];
567         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
568         unchecked {
569             _balances[from] = fromBalance - amount;
570         }
571         _balances[to] += amount;
572 
573         emit Transfer(from, to, amount);
574 
575         _afterTokenTransfer(from, to, amount);
576     }
577 
578     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
579      * the total supply.
580      *
581      * Emits a {Transfer} event with `from` set to the zero address.
582      *
583      * Requirements:
584      *
585      * - `account` cannot be the zero address.
586      */
587     function _mint(address account, uint256 amount) internal virtual {
588         require(account != address(0), "ERC20: mint to the zero address");
589 
590         _beforeTokenTransfer(address(0), account, amount);
591 
592         _totalSupply += amount;
593         _balances[account] += amount;
594         emit Transfer(address(0), account, amount);
595 
596         _afterTokenTransfer(address(0), account, amount);
597     }
598 
599     /**
600      * @dev Destroys `amount` tokens from `account`, reducing the
601      * total supply.
602      *
603      * Emits a {Transfer} event with `to` set to the zero address.
604      *
605      * Requirements:
606      *
607      * - `account` cannot be the zero address.
608      * - `account` must have at least `amount` tokens.
609      */
610     function _burn(address account, uint256 amount) internal virtual {
611         require(account != address(0), "ERC20: burn from the zero address");
612 
613         _beforeTokenTransfer(account, address(0), amount);
614 
615         uint256 accountBalance = _balances[account];
616         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
617         unchecked {
618             _balances[account] = accountBalance - amount;
619         }
620         _totalSupply -= amount;
621 
622         emit Transfer(account, address(0), amount);
623 
624         _afterTokenTransfer(account, address(0), amount);
625     }
626 
627     /**
628      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
629      *
630      * This internal function is equivalent to `approve`, and can be used to
631      * e.g. set automatic allowances for certain subsystems, etc.
632      *
633      * Emits an {Approval} event.
634      *
635      * Requirements:
636      *
637      * - `owner` cannot be the zero address.
638      * - `spender` cannot be the zero address.
639      */
640     function _approve(
641         address owner,
642         address spender,
643         uint256 amount
644     ) internal virtual {
645         require(owner != address(0), "ERC20: approve from the zero address");
646         require(spender != address(0), "ERC20: approve to the zero address");
647 
648         _allowances[owner][spender] = amount;
649         emit Approval(owner, spender, amount);
650     }
651 
652     /**
653      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
654      *
655      * Does not update the allowance amount in case of infinite allowance.
656      * Revert if not enough allowance is available.
657      *
658      * Might emit an {Approval} event.
659      */
660     function _spendAllowance(
661         address owner,
662         address spender,
663         uint256 amount
664     ) internal virtual {
665         uint256 currentAllowance = allowance(owner, spender);
666         if (currentAllowance != type(uint256).max) {
667             require(currentAllowance >= amount, "ERC20: insufficient allowance");
668             unchecked {
669                 _approve(owner, spender, currentAllowance - amount);
670             }
671         }
672     }
673 
674     /**
675      * @dev Hook that is called before any transfer of tokens. This includes
676      * minting and burning.
677      *
678      * Calling conditions:
679      *
680      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
681      * will be transferred to `to`.
682      * - when `from` is zero, `amount` tokens will be minted for `to`.
683      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
684      * - `from` and `to` are never both zero.
685      *
686      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
687      */
688     function _beforeTokenTransfer(
689         address from,
690         address to,
691         uint256 amount
692     ) internal virtual {}
693 
694     /**
695      * @dev Hook that is called after any transfer of tokens. This includes
696      * minting and burning.
697      *
698      * Calling conditions:
699      *
700      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
701      * has been transferred to `to`.
702      * - when `from` is zero, `amount` tokens have been minted for `to`.
703      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
704      * - `from` and `to` are never both zero.
705      *
706      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
707      */
708     function _afterTokenTransfer(
709         address from,
710         address to,
711         uint256 amount
712     ) internal virtual {}
713 }
714 
715 contract AcceptCrypto is ERC20, Ownable {
716 
717     IUniswapV2Router02 public uniswapV2Router;
718     address public immutable uniswapV2Pair;
719 
720     bool private swapping;
721 
722     bool public isTradingEnabled;
723     bool public isBuyFeeDisabled;
724     bool public isSellFeeDisabled;
725     uint256 public startBlock;
726 
727     uint256 public maxTxAmount = 3 * 10**9 * (10**18); //0.3% of total supply
728     uint256 public maxWalletSize = 10**10 * (10**18); //1% of total supply
729 
730     uint256 public swapTokensAtAmount = 10**9 * (10**18);
731 
732     mapping (address => bool) private _isExcluded;
733     mapping (address => bool) private _isBlacklisted;
734 
735     uint256 public buybackBuyFee;
736     uint256 public liquidityBuyFee;
737     uint256 public devBuyFee;
738     uint256 public marketingBuyFee;
739     uint256 public totalBuyFees;
740 
741     uint256 public buybackSellFee;
742     uint256 public liquiditySellFee;
743     uint256 public devSellFee;
744     uint256 public marketingSellFee;
745     uint256 public totalSellFees;
746 
747     uint256 public buybackTokens;
748     uint256 public liquidityTokens;
749     uint256 public devTokens;
750     uint256 public marketingTokens;
751 
752     address public marketingWallet = 0x17c0490B57254e80DD5F7e24E0BC383faA349dc0;
753     address public devWallet = 0x125F0f61800E5e34a76313EFDd4FD5aa9A8Aed39;
754     address constant deadAddress = 0x000000000000000000000000000000000000dEaD;
755 
756     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);
757 
758     constructor() ERC20("AcceptCrypto", "ACEPT") {
759     	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
760         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
761             .createPair(address(this), _uniswapV2Router.WETH());
762 
763         uniswapV2Router = _uniswapV2Router;
764         uniswapV2Pair = _uniswapV2Pair;
765 
766         _isExcluded[owner()] = true;
767         _isExcluded[address(this)] = true;
768         _isExcluded[marketingWallet] = true;
769         _isExcluded[devWallet] = true;
770 
771         _isBlacklisted[address(0)] = true;
772 
773         buybackBuyFee = 200;
774         liquidityBuyFee = 200;
775         devBuyFee = 300;
776         marketingBuyFee = 300;
777         totalBuyFees = 1000;
778 
779         buybackSellFee = 200;
780         liquiditySellFee = 200;
781         devSellFee = 300;
782         marketingSellFee = 300;
783         totalSellFees = 1000;
784 
785         _mint(owner(), 10**12 * (10**18));
786     }
787 
788     receive() external payable {
789 
790   	}
791 
792     function _transfer(
793         address from,
794         address to,
795         uint256 amount
796     ) internal override {
797         require(!_isBlacklisted[from] && !_isBlacklisted[to], "To or From address is blacklisted.");
798 
799         if(amount == 0) {
800             super._transfer(from, to, 0);
801             return;
802         }
803 
804         if (!isTradingEnabled) {
805             require(_isExcluded[to] || _isExcluded[from], "Trading is not yet enabled. Be patient!");
806             if (to == uniswapV2Pair) {
807                 isTradingEnabled = true;
808                 startBlock = block.number;
809             }
810         } else if (!_isExcluded[to] && !_isExcluded[from]) {
811             require(amount <= maxTxAmount, "Over max tx amt.");
812             if (to != address(uniswapV2Router) && to != uniswapV2Pair) {
813                 require(balanceOf(to) + amount <= maxWalletSize, "Transfer amount too high. Cannot exceed max wallet size.");
814             }
815         }
816 
817 		    bool canSwap = balanceOf(address(this)) >= swapTokensAtAmount;
818 
819         if(
820             canSwap &&
821             !swapping &&
822             from != uniswapV2Pair &&
823             from != owner() &&
824             to != owner()
825         ) {
826 
827             swapping = true;
828 
829             swapAndLiquify(liquidityTokens);
830             swapAndSendDividends(buybackTokens + devTokens + marketingTokens);
831 
832             swapping = false;
833         }
834 
835         bool takeFee = !swapping;
836 
837         if(_isExcluded[from] || _isExcluded[to]) {
838             takeFee = false;
839         }
840 
841         if(takeFee) {
842             uint256 fees;
843             if (to == uniswapV2Pair && !isSellFeeDisabled) { //sell
844                 if (block.number <= startBlock + 2 ){ //within the first 2 blocks of trading
845                     fees = amount * 10000 / 11000;
846                 } else {
847                     fees = amount * totalSellFees / 10000;
848                 }
849                 buybackTokens += fees * buybackSellFee / totalSellFees;
850                 liquidityTokens += fees * liquiditySellFee / totalSellFees;
851                 devTokens += fees * devSellFee / totalSellFees;
852                 marketingTokens += fees * marketingSellFee / totalSellFees;
853             } else if (from == uniswapV2Pair && !isBuyFeeDisabled) { //buy
854                 if (block.number <= startBlock + 2 ){ //within the first 2 blocks of trading
855                     fees = amount * 10000 / 11000;
856                 } else {
857                     fees = amount * totalBuyFees / 10000;
858                 }
859                 buybackTokens += fees * buybackBuyFee / totalBuyFees;
860                 liquidityTokens += fees * liquidityBuyFee / totalBuyFees;
861                 devTokens += fees * devBuyFee / totalBuyFees;
862                 marketingTokens += fees * marketingBuyFee / totalBuyFees;
863             }
864 
865             amount -= fees;
866             super._transfer(from, address(this), fees);
867         }
868 
869         super._transfer(from, to, amount);
870 
871     }
872 
873     function swapAndLiquify(uint256 tokens) private {
874         uint256 half = tokens / 2;
875         uint256 otherHalf = tokens - half;
876         uint256 initialBalance = address(this).balance;
877         liquidityTokens = 0;
878         swapTokensForEth(half);
879         uint256 newBalance = address(this).balance - initialBalance;
880         addLiquidity(otherHalf, newBalance);
881         emit SwapAndLiquify(half, newBalance, otherHalf);
882     }
883 
884     function swapTokensForEth(uint256 tokenAmount) private {
885         address[] memory path = new address[](2);
886         path[0] = address(this);
887         path[1] = uniswapV2Router.WETH();
888         _approve(address(this), address(uniswapV2Router), tokenAmount);
889         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
890             tokenAmount,
891             0,
892             path,
893             address(this),
894             block.timestamp
895         );
896 
897     }
898 
899     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
900         _approve(address(this), address(uniswapV2Router), tokenAmount);
901         uniswapV2Router.addLiquidityETH{value: ethAmount}(
902             address(this),
903             tokenAmount,
904             0,
905             0,
906             deadAddress,
907             block.timestamp
908         );
909     }
910 
911     function swapAndSendDividends(uint256 tokens) private {
912         swapTokensForEth(tokens);
913         uint256 buyback = address(this).balance * buybackTokens / tokens;
914         uint256 dev = address(this).balance * devTokens / tokens;
915         uint256 marketing = address(this).balance - buyback - dev;
916         buybackTokens = 0;
917         buyBackAndBurn(buyback);
918         devTokens = 0;
919         payable(devWallet).transfer(dev);
920         marketingTokens = 0;
921         payable(marketingWallet).transfer(marketing);
922     }
923 
924     function buyBackAndBurn(uint256 amount) private {
925         address[] memory path = new address[](2);
926         path[0] = uniswapV2Router.WETH();
927         path[1] = address(this);
928         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
929             0,
930             path,
931             deadAddress,
932             block.timestamp
933         );
934 
935     }
936 
937     function setExcluded(address account, bool value) external onlyOwner {
938         _isExcluded[account] = value;
939     }
940 
941     function setBlacklist(address account, bool value) external onlyOwner {
942         _isBlacklisted[account] = value;
943     }
944 
945     function setSellFeeDisabled(bool value) external onlyOwner {
946         isSellFeeDisabled = value;
947     }
948 
949     function setBuyFeeDisabled(bool value) external onlyOwner {
950         isBuyFeeDisabled = value;
951     }
952 
953     function setMaxWalletSize(uint256 amount) external onlyOwner {
954         maxWalletSize = amount;
955     }
956 
957     function setMaxTxAmount(uint256 amount) external onlyOwner {
958         maxTxAmount = amount;
959     }
960 
961     function setSwapAtAmount(uint256 amount) external onlyOwner {
962         swapTokensAtAmount = amount;
963     }
964 
965     function setMarketingWallet(address account) external onlyOwner {
966         marketingWallet = account;
967     }
968 
969     function setDevWallet(address account) external onlyOwner {
970         devWallet = account;
971     }
972 
973     function setSellFees(uint256 buyback, uint256 liquidity, uint256 dev, uint256 marketing) external onlyOwner {
974         uint256 total = buyback + liquidity + dev + marketing;
975         require(total <= 1200, "The total tax cannot be more than 12%.");
976         buybackSellFee = buyback;
977         liquiditySellFee = liquidity;
978         devSellFee = dev;
979         marketingSellFee = marketing;
980         totalSellFees = total;
981     }
982 
983     function setBuyFees(uint256 buyback, uint256 liquidity, uint256 dev, uint256 marketing) external onlyOwner {
984         uint256 total = buyback + liquidity + dev + marketing;
985         require(total <= 1000, "The total tax cannot be more than 10%.");
986         buybackBuyFee = buyback;
987         liquidityBuyFee = liquidity;
988         devBuyFee = dev;
989         marketingBuyFee = marketing;
990         totalBuyFees = total;
991     }
992 
993     function transferOwnership(address newOwner) public override onlyOwner {
994         _isExcluded[owner()] = false;
995         _isExcluded[newOwner] = true;
996         super.transferOwnership(newOwner);
997     }
998 
999 }