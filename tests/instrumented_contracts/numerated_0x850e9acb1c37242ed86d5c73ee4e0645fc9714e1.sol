1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.13;
4 
5 interface IERC20 {
6     /**
7      * @dev Returns the amount of tokens in existence.
8      */
9     function totalSupply() external view returns (uint256);
10 
11     /**
12      * @dev Returns the amount of tokens owned by `account`.
13      */
14     function balanceOf(address account) external view returns (uint256);
15 
16     /**
17      * @dev Moves `amount` tokens from the caller's account to `recipient`.
18      *
19      * Returns a boolean value indicating whether the operation succeeded.
20      *
21      * Emits a {Transfer} event.
22      */
23     function transfer(address recipient, uint256 amount) external returns (bool);
24 
25     /**
26      * @dev Returns the remaining number of tokens that `spender` will be
27      * allowed to spend on behalf of `owner` through {transferFrom}. This is
28      * zero by default.
29      *
30      * This value changes when {approve} or {transferFrom} are called.
31      */
32     function allowance(address owner, address spender) external view returns (uint256);
33 
34     /**
35      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * IMPORTANT: Beware that changing an allowance with this method brings the risk
40      * that someone may use both the old and the new allowance by unfortunate
41      * transaction ordering. One possible solution to mitigate this race
42      * condition is to first reduce the spender's allowance to 0 and set the
43      * desired value afterwards:
44      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
45      *
46      * Emits an {Approval} event.
47      */
48     function approve(address spender, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Moves `amount` tokens from `sender` to `recipient` using the
52      * allowance mechanism. `amount` is then deducted from the caller's
53      * allowance.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transferFrom(
60         address sender,
61         address recipient,
62         uint256 amount
63     ) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 interface IERC20Metadata is IERC20 {
81     /**
82      * @dev Returns the name of the token.
83      */
84     function name() external view returns (string memory);
85 
86     /**
87      * @dev Returns the symbol of the token.
88      */
89     function symbol() external view returns (string memory);
90 
91     /**
92      * @dev Returns the decimals places of the token.
93      */
94     function decimals() external view returns (uint8);
95 }
96 
97 abstract contract Context {
98     function _msgSender() internal view virtual returns (address) {
99         return msg.sender;
100     }
101 
102     function _msgData() internal view virtual returns (bytes calldata) {
103         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
104         return msg.data;
105     }
106 }
107 
108 abstract contract Ownable is Context {
109     address private _owner;
110 
111     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
112 
113     /**
114      * @dev Initializes the contract setting the deployer as the initial owner.
115      */
116     constructor () {
117         address msgSender = _msgSender();
118         _owner = msgSender;
119         emit OwnershipTransferred(address(0), msgSender);
120     }
121 
122     /**
123      * @dev Returns the address of the current owner.
124      */
125     function owner() public view returns (address) {
126         return _owner;
127     }
128 
129     /**
130      * @dev Throws if called by any account other than the owner.
131      */
132     modifier onlyOwner() {
133         require(_owner == _msgSender(), "Ownable: caller is not the owner");
134         _;
135     }
136 
137     /**
138      * @dev Leaves the contract without owner. It will not be possible to call
139      * `onlyOwner` functions anymore. Can only be called by the current owner.
140      *
141      * NOTE: Renouncing ownership will leave the contract without an owner,
142      * thereby removing any functionality that is only available to the owner.
143      */
144     function renounceOwnership() public virtual onlyOwner {
145         emit OwnershipTransferred(_owner, address(0));
146         _owner = address(0);
147     }
148 
149     /**
150      * @dev Transfers ownership of the contract to a new account (`newOwner`).
151      * Can only be called by the current owner.
152      */
153     function transferOwnership(address newOwner) public virtual onlyOwner {
154         require(newOwner != address(0), "Ownable: new owner is the zero address");
155         emit OwnershipTransferred(_owner, newOwner);
156         _owner = newOwner;
157     }
158 }
159 
160 contract ERC20 is Context, IERC20, IERC20Metadata {
161     mapping(address => uint256) private _balances;
162 
163     mapping(address => mapping(address => uint256)) private _allowances;
164 
165     uint256 private _totalSupply;
166 
167     string private _name;
168     string private _symbol;
169 
170     /**
171      * @dev Sets the values for {name} and {symbol}.
172      *
173      * The default value of {decimals} is 18. To select a different value for
174      * {decimals} you should overload it.
175      *
176      * All two of these values are immutable: they can only be set once during
177      * construction.
178      */
179     constructor(string memory name_, string memory symbol_) {
180         _name = name_;
181         _symbol = symbol_;
182     }
183 
184     /**
185      * @dev Returns the name of the token.
186      */
187     function name() public view virtual override returns (string memory) {
188         return _name;
189     }
190 
191     /**
192      * @dev Returns the symbol of the token, usually a shorter version of the
193      * name.
194      */
195     function symbol() public view virtual override returns (string memory) {
196         return _symbol;
197     }
198 
199     /**
200      * @dev Returns the number of decimals used to get its user representation.
201      * For example, if `decimals` equals `2`, a balance of `505` tokens should
202      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
203      *
204      * Tokens usually opt for a value of 18, imitating the relationship between
205      * Ether and Wei. This is the value {ERC20} uses, unless this function is
206      * overridden;
207      *
208      * NOTE: This information is only used for _display_ purposes: it in
209      * no way affects any of the arithmetic of the contract, including
210      * {IERC20-balanceOf} and {IERC20-transfer}.
211      */
212     function decimals() public view virtual override returns (uint8) {
213         return 18;
214     }
215 
216     /**
217      * @dev See {IERC20-totalSupply}.
218      */
219     function totalSupply() public view virtual override returns (uint256) {
220         return _totalSupply;
221     }
222 
223     /**
224      * @dev See {IERC20-balanceOf}.
225      */
226     function balanceOf(address account) public view virtual override returns (uint256) {
227         return _balances[account];
228     }
229 
230     /**
231      * @dev See {IERC20-transfer}.
232      *
233      * Requirements:
234      *
235      * - `recipient` cannot be the zero address.
236      * - the caller must have a balance of at least `amount`.
237      */
238     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
239         _transfer(_msgSender(), recipient, amount);
240         return true;
241     }
242 
243     /**
244      * @dev See {IERC20-allowance}.
245      */
246     function allowance(address owner, address spender) public view virtual override returns (uint256) {
247         return _allowances[owner][spender];
248     }
249 
250     /**
251      * @dev See {IERC20-approve}.
252      *
253      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
254      * `transferFrom`. This is semantically equivalent to an infinite approval.
255      *
256      * Requirements:
257      *
258      * - `spender` cannot be the zero address.
259      */
260     function approve(address spender, uint256 amount) public virtual override returns (bool) {
261         _approve(_msgSender(), spender, amount);
262         return true;
263     }
264 
265     /**
266      * @dev See {IERC20-transferFrom}.
267      *
268      * Emits an {Approval} event indicating the updated allowance. This is not
269      * required by the EIP. See the note at the beginning of {ERC20}.
270      *
271      * NOTE: Does not update the allowance if the current allowance
272      * is the maximum `uint256`.
273      *
274      * Requirements:
275      *
276      * - `sender` and `recipient` cannot be the zero address.
277      * - `sender` must have a balance of at least `amount`.
278      * - the caller must have allowance for ``sender``'s tokens of at least
279      * `amount`.
280      */
281     function transferFrom(
282         address sender,
283         address recipient,
284         uint256 amount
285     ) public virtual override returns (bool) {
286         uint256 currentAllowance = _allowances[sender][_msgSender()];
287         if (currentAllowance != type(uint256).max) {
288             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
289             unchecked {
290                 _approve(sender, _msgSender(), currentAllowance - amount);
291             }
292         }
293 
294         _transfer(sender, recipient, amount);
295 
296         return true;
297     }
298 
299     /**
300      * @dev Atomically increases the allowance granted to `spender` by the caller.
301      *
302      * This is an alternative to {approve} that can be used as a mitigation for
303      * problems described in {IERC20-approve}.
304      *
305      * Emits an {Approval} event indicating the updated allowance.
306      *
307      * Requirements:
308      *
309      * - `spender` cannot be the zero address.
310      */
311     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
312         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
313         return true;
314     }
315 
316     /**
317      * @dev Atomically decreases the allowance granted to `spender` by the caller.
318      *
319      * This is an alternative to {approve} that can be used as a mitigation for
320      * problems described in {IERC20-approve}.
321      *
322      * Emits an {Approval} event indicating the updated allowance.
323      *
324      * Requirements:
325      *
326      * - `spender` cannot be the zero address.
327      * - `spender` must have allowance for the caller of at least
328      * `subtractedValue`.
329      */
330     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
331         uint256 currentAllowance = _allowances[_msgSender()][spender];
332         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
333         unchecked {
334             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
335         }
336 
337         return true;
338     }
339 
340     /**
341      * @dev Moves `amount` of tokens from `sender` to `recipient`.
342      *
343      * This internal function is equivalent to {transfer}, and can be used to
344      * e.g. implement automatic token fees, slashing mechanisms, etc.
345      *
346      * Emits a {Transfer} event.
347      *
348      * Requirements:
349      *
350      * - `sender` cannot be the zero address.
351      * - `recipient` cannot be the zero address.
352      * - `sender` must have a balance of at least `amount`.
353      */
354     function _transfer(
355         address sender,
356         address recipient,
357         uint256 amount
358     ) internal virtual {
359         require(sender != address(0), "ERC20: transfer from the zero address");
360         require(recipient != address(0), "ERC20: transfer to the zero address");
361 
362         _beforeTokenTransfer(sender, recipient, amount);
363 
364         uint256 senderBalance = _balances[sender];
365         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
366         unchecked {
367             _balances[sender] = senderBalance - amount;
368         }
369         _balances[recipient] += amount;
370 
371         emit Transfer(sender, recipient, amount);
372 
373         _afterTokenTransfer(sender, recipient, amount);
374     }
375 
376     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
377      * the total supply.
378      *
379      * Emits a {Transfer} event with `from` set to the zero address.
380      *
381      * Requirements:
382      *
383      * - `account` cannot be the zero address.
384      */
385     function _mint(address account, uint256 amount) internal virtual {
386         require(account != address(0), "ERC20: mint to the zero address");
387 
388         _beforeTokenTransfer(address(0), account, amount);
389 
390         _totalSupply += amount;
391         _balances[account] += amount;
392         emit Transfer(address(0), account, amount);
393 
394         _afterTokenTransfer(address(0), account, amount);
395     }
396 
397     /**
398      * @dev Destroys `amount` tokens from `account`, reducing the
399      * total supply.
400      *
401      * Emits a {Transfer} event with `to` set to the zero address.
402      *
403      * Requirements:
404      *
405      * - `account` cannot be the zero address.
406      * - `account` must have at least `amount` tokens.
407      */
408     function _burn(address account, uint256 amount) internal virtual {
409         require(account != address(0), "ERC20: burn from the zero address");
410 
411         _beforeTokenTransfer(account, address(0), amount);
412 
413         uint256 accountBalance = _balances[account];
414         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
415         unchecked {
416             _balances[account] = accountBalance - amount;
417         }
418         _totalSupply -= amount;
419 
420         emit Transfer(account, address(0), amount);
421 
422         _afterTokenTransfer(account, address(0), amount);
423     }
424 
425     /**
426      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
427      *
428      * This internal function is equivalent to `approve`, and can be used to
429      * e.g. set automatic allowances for certain subsystems, etc.
430      *
431      * Emits an {Approval} event.
432      *
433      * Requirements:
434      *
435      * - `owner` cannot be the zero address.
436      * - `spender` cannot be the zero address.
437      */
438     function _approve(
439         address owner,
440         address spender,
441         uint256 amount
442     ) internal virtual {
443         require(owner != address(0), "ERC20: approve from the zero address");
444         require(spender != address(0), "ERC20: approve to the zero address");
445 
446         _allowances[owner][spender] = amount;
447         emit Approval(owner, spender, amount);
448     }
449 
450     /**
451      * @dev Hook that is called before any transfer of tokens. This includes
452      * minting and burning.
453      *
454      * Calling conditions:
455      *
456      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
457      * will be transferred to `to`.
458      * - when `from` is zero, `amount` tokens will be minted for `to`.
459      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
460      * - `from` and `to` are never both zero.
461      *
462      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
463      */
464     function _beforeTokenTransfer(
465         address from,
466         address to,
467         uint256 amount
468     ) internal virtual {}
469 
470     /**
471      * @dev Hook that is called after any transfer of tokens. This includes
472      * minting and burning.
473      *
474      * Calling conditions:
475      *
476      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
477      * has been transferred to `to`.
478      * - when `from` is zero, `amount` tokens have been minted for `to`.
479      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
480      * - `from` and `to` are never both zero.
481      *
482      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
483      */
484     function _afterTokenTransfer(
485         address from,
486         address to,
487         uint256 amount
488     ) internal virtual {}
489 }
490 
491 interface IUniswapV2Factory {
492     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
493 
494     function feeTo() external view returns (address);
495     function feeToSetter() external view returns (address);
496 
497     function getPair(address tokenA, address tokenB) external view returns (address pair);
498     function allPairs(uint) external view returns (address pair);
499     function allPairsLength() external view returns (uint);
500 
501     function createPair(address tokenA, address tokenB) external returns (address pair);
502 
503     function setFeeTo(address) external;
504     function setFeeToSetter(address) external;
505 }
506 
507 interface IUniswapV2Pair {
508     event Approval(address indexed owner, address indexed spender, uint value);
509     event Transfer(address indexed from, address indexed to, uint value);
510 
511     function name() external pure returns (string memory);
512     function symbol() external pure returns (string memory);
513     function decimals() external pure returns (uint8);
514     function totalSupply() external view returns (uint);
515     function balanceOf(address owner) external view returns (uint);
516     function allowance(address owner, address spender) external view returns (uint);
517 
518     function approve(address spender, uint value) external returns (bool);
519     function transfer(address to, uint value) external returns (bool);
520     function transferFrom(address from, address to, uint value) external returns (bool);
521 
522     function DOMAIN_SEPARATOR() external view returns (bytes32);
523     function PERMIT_TYPEHASH() external pure returns (bytes32);
524     function nonces(address owner) external view returns (uint);
525 
526     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
527 
528     event Mint(address indexed sender, uint amount0, uint amount1);
529     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
530     event Swap(
531         address indexed sender,
532         uint amount0In,
533         uint amount1In,
534         uint amount0Out,
535         uint amount1Out,
536         address indexed to
537     );
538     event Sync(uint112 reserve0, uint112 reserve1);
539 
540     function MINIMUM_LIQUIDITY() external pure returns (uint);
541     function factory() external view returns (address);
542     function token0() external view returns (address);
543     function token1() external view returns (address);
544     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
545     function price0CumulativeLast() external view returns (uint);
546     function price1CumulativeLast() external view returns (uint);
547     function kLast() external view returns (uint);
548 
549     function mint(address to) external returns (uint liquidity);
550     function burn(address to) external returns (uint amount0, uint amount1);
551     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
552     function skim(address to) external;
553     function sync() external;
554 
555     function initialize(address, address) external;
556 }
557 
558 interface IUniswapV2Router01 {
559     function factory() external pure returns (address);
560     function WETH() external pure returns (address);
561 
562     function addLiquidity(
563         address tokenA,
564         address tokenB,
565         uint amountADesired,
566         uint amountBDesired,
567         uint amountAMin,
568         uint amountBMin,
569         address to,
570         uint deadline
571     ) external returns (uint amountA, uint amountB, uint liquidity);
572     function addLiquidityETH(
573         address token,
574         uint amountTokenDesired,
575         uint amountTokenMin,
576         uint amountETHMin,
577         address to,
578         uint deadline
579     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
580     function removeLiquidity(
581         address tokenA,
582         address tokenB,
583         uint liquidity,
584         uint amountAMin,
585         uint amountBMin,
586         address to,
587         uint deadline
588     ) external returns (uint amountA, uint amountB);
589     function removeLiquidityETH(
590         address token,
591         uint liquidity,
592         uint amountTokenMin,
593         uint amountETHMin,
594         address to,
595         uint deadline
596     ) external returns (uint amountToken, uint amountETH);
597     function removeLiquidityWithPermit(
598         address tokenA,
599         address tokenB,
600         uint liquidity,
601         uint amountAMin,
602         uint amountBMin,
603         address to,
604         uint deadline,
605         bool approveMax, uint8 v, bytes32 r, bytes32 s
606     ) external returns (uint amountA, uint amountB);
607     function removeLiquidityETHWithPermit(
608         address token,
609         uint liquidity,
610         uint amountTokenMin,
611         uint amountETHMin,
612         address to,
613         uint deadline,
614         bool approveMax, uint8 v, bytes32 r, bytes32 s
615     ) external returns (uint amountToken, uint amountETH);
616     function swapExactTokensForTokens(
617         uint amountIn,
618         uint amountOutMin,
619         address[] calldata path,
620         address to,
621         uint deadline
622     ) external returns (uint[] memory amounts);
623     function swapTokensForExactTokens(
624         uint amountOut,
625         uint amountInMax,
626         address[] calldata path,
627         address to,
628         uint deadline
629     ) external returns (uint[] memory amounts);
630     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
631         external
632         payable
633         returns (uint[] memory amounts);
634     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
635         external
636         returns (uint[] memory amounts);
637     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
638         external
639         returns (uint[] memory amounts);
640     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
641         external
642         payable
643         returns (uint[] memory amounts);
644 
645     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
646     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
647     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
648     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
649     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
650 }
651 
652 interface IUniswapV2Router02 is IUniswapV2Router01 {
653     function removeLiquidityETHSupportingFeeOnTransferTokens(
654         address token,
655         uint liquidity,
656         uint amountTokenMin,
657         uint amountETHMin,
658         address to,
659         uint deadline
660     ) external returns (uint amountETH);
661     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
662         address token,
663         uint liquidity,
664         uint amountTokenMin,
665         uint amountETHMin,
666         address to,
667         uint deadline,
668         bool approveMax, uint8 v, bytes32 r, bytes32 s
669     ) external returns (uint amountETH);
670 
671     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
672         uint amountIn,
673         uint amountOutMin,
674         address[] calldata path,
675         address to,
676         uint deadline
677     ) external;
678     function swapExactETHForTokensSupportingFeeOnTransferTokens(
679         uint amountOutMin,
680         address[] calldata path,
681         address to,
682         uint deadline
683     ) external payable;
684     function swapExactTokensForETHSupportingFeeOnTransferTokens(
685         uint amountIn,
686         uint amountOutMin,
687         address[] calldata path,
688         address to,
689         uint deadline
690     ) external;
691 }
692 
693 contract HodoInu is ERC20, Ownable {
694 
695     IUniswapV2Router02 public uniswapV2Router;
696     address public  uniswapV2Pair;
697 
698     bool private swapping;
699 
700     address public deadWallet = 0x000000000000000000000000000000000000dEaD;
701     address public marketingWallet = 0x79c2D2d773B59a9798fCBa45B33C1d78a8d1e46D;
702 
703     uint256 public swapTokensAtAmount = 200 * (10**18);
704 
705     uint256 public liquidityFee = 15;
706     uint256 public marketingFee = 5;
707     uint256 public buybackFee = 5;
708     uint256 public totalFees = liquidityFee + marketingFee + buybackFee;
709 
710     mapping (address => bool) private _isExcludedFromFees;
711     mapping (address => bool) public automatedMarketMakerPairs;
712 
713     mapping (address => uint256) public lastBuy;
714 
715     uint public accumulatedBuybackETH = 0;
716     uint public ethValueForBuyBurn = 15 * (10**16); // 0.15 ETH
717 
718     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
719     event ExcludeFromFees(address indexed account, bool isExcluded);
720     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
721     event SwapAndLiquify(
722         uint256 tokensSwapped,
723         uint256 ethReceived,
724         uint256 tokensIntoLiquidity
725     );
726 
727     constructor (address _newOwner) ERC20("Hodo Inu", "HODO") {
728         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
729          // Create a uniswap pair for this new token
730         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
731             .createPair(address(this), _uniswapV2Router.WETH());
732 
733         uniswapV2Router = _uniswapV2Router;
734         uniswapV2Pair = _uniswapV2Pair;
735 
736         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
737 
738         excludeFromFees(_newOwner, true);
739         excludeFromFees(address(this), true);
740         
741         _isExcludedFromMaxWalletLimit[_newOwner] = true;
742         _isExcludedFromMaxWalletLimit[address(0)] = true;
743         _isExcludedFromMaxWalletLimit[address(this)] = true;
744         _isExcludedFromMaxWalletLimit[deadWallet] = true;
745 
746         _isExcludedFromMaxTxLimit[_newOwner] = true;
747         _isExcludedFromMaxTxLimit[address(0)] = true;
748         _isExcludedFromMaxTxLimit[address(this)] = true;
749         _isExcludedFromMaxTxLimit[deadWallet] = true;
750 
751         _mint(_newOwner, 1_000_000 * (10**18));
752         transferOwnership(_newOwner);
753     }
754 
755     receive() external payable {
756 
757   	}
758       
759     function updateUniswapV2Router(address newAddress) public onlyOwner {
760         require(newAddress != address(uniswapV2Router), "The router already has that address");
761         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
762         uniswapV2Router = IUniswapV2Router02(newAddress);
763         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
764             .createPair(address(this), uniswapV2Router.WETH());
765         uniswapV2Pair = _uniswapV2Pair;
766     }
767 
768     function excludeFromFees(address account, bool excluded) public onlyOwner {
769         require(_isExcludedFromFees[account] != excluded, "Account is already the value of 'excluded'");
770         _isExcludedFromFees[account] = excluded;
771 
772         emit ExcludeFromFees(account, excluded);
773     }
774 
775     function setSwapTokensAtAmount(uint256 amount) external onlyOwner{
776         require(amount > totalSupply() / 100000, "Amount must be greater than 0.001% of total supply");
777         swapTokensAtAmount = amount;
778     }
779 
780     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
781         require(pair != uniswapV2Pair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
782 
783         _setAutomatedMarketMakerPair(pair, value);
784     }
785  
786     function _setAutomatedMarketMakerPair(address pair, bool value) private {
787         require(automatedMarketMakerPairs[pair] != value, "Automated market maker pair is already set to that value");
788         automatedMarketMakerPairs[pair] = value;
789 
790         emit SetAutomatedMarketMakerPair(pair, value);
791     }
792 
793     function setFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _buybackFee) external onlyOwner {
794         marketingFee = _marketingFee;
795         liquidityFee = _liquidityFee;
796         buybackFee = _buybackFee;
797         totalFees = marketingFee + liquidityFee + buybackFee;
798         require(totalFees <= 25, "Total fees must be lower than 25%");
799     }
800 
801     function setMarketingWallet(address _marketingWallet) external onlyOwner {
802         marketingWallet = _marketingWallet;
803     }
804 
805     function claimStuckTokens(address token) external onlyOwner {
806         require(token != address(this), "Owner cannot claim native tokens");
807         if (token == address(0x0)) {
808             payable(msg.sender).transfer(address(this).balance);
809             return;
810         }
811         IERC20 ERC20token = IERC20(token);
812         uint256 balance = ERC20token.balanceOf(address(this));
813         ERC20token.transfer(msg.sender, balance);
814     }
815 
816     function _transfer(
817         address from,
818         address to,
819         uint256 amount
820     ) internal  override {
821         require(from != address(0), "ERC20: transfer from the zero address");
822         require(to != address(0), "ERC20: transfer to the zero address");
823     
824         if(amount == 0) {
825             super._transfer(from, to, 0);
826             return;
827         }
828         
829         if (maxWalletLimitEnabled) {
830             if (_isExcludedFromMaxWalletLimit[from] == false
831                 && _isExcludedFromMaxWalletLimit[to] == false &&
832                 to != uniswapV2Pair
833             ) {
834                 uint balance  = balanceOf(to);
835                 require(balance + amount <= maxWalletAmount(), "MaxWallet: Transfer amount exceeds the maxWalletAmount");
836             }
837         }
838 
839         if (maxTransactionLimitEnabled) {
840             if (_isExcludedFromMaxTxLimit[from] == false
841                 && _isExcludedFromMaxTxLimit[to] == false
842             ) {
843                 if (from == uniswapV2Pair) {
844                     require(amount <= maxTransferAmountBuy(), "AntiWhale: Transfer amount exceeds the maxTransferAmount");
845                 }else{
846                     require(amount <= maxTransferAmountSell(), "AntiWhale: Transfer amount exceeds the maxTransferAmount");
847                 }
848             }
849         }
850         
851 
852 		uint256 contractTokenBalance = balanceOf(address(this));
853 
854         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
855 
856         if( canSwap &&
857             !swapping &&
858             !automatedMarketMakerPairs[from] &&
859             from != owner() &&
860             to != owner() &&
861             totalFees != 0
862         ) {
863             swapping = true;
864 
865             uint256 liqTokensToAdd = contractTokenBalance * liquidityFee / 2 / totalFees;
866             contractTokenBalance -= liqTokensToAdd;
867 
868             uint initBalance = address(this).balance;
869             swapTokensForEth(contractTokenBalance);
870             uint finalBalance = address(this).balance - (initBalance);
871             uint ethFee = totalFees * 2 - liquidityFee;
872 
873 
874             if(marketingFee > 0) {
875                 uint256 marketingETH = finalBalance * (2 * marketingFee) / ethFee;
876                 payable(marketingWallet).transfer(marketingETH);
877             }
878 
879             if(liquidityFee > 0) {
880                 uint256 liqETH = finalBalance * liquidityFee / ethFee;
881                 addLiquidity(liqTokensToAdd, liqETH);
882             }
883 
884             if(buybackFee > 0) {
885                 uint256 buybackETH = finalBalance * (2 * buybackFee) / ethFee;
886                 accumulatedBuybackETH += buybackETH;
887                 if (accumulatedBuybackETH > ethValueForBuyBurn) {
888                     if(address(this).balance >= accumulatedBuybackETH) {
889                         buyBackAndBurn(accumulatedBuybackETH);
890                     }else{
891                         buyBackAndBurn(address(this).balance);
892                     }
893                     accumulatedBuybackETH = 0;
894                 }
895             }       
896 
897             swapping = false;
898         }
899 
900         bool takeFee = !swapping;
901 
902         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
903             takeFee = false;
904         } 
905 
906         if(from == uniswapV2Pair) {
907             takeFee = false;      
908         }
909         
910         if(block.timestamp - lastBuy[from] > 24 hours) {
911             takeFee = false;
912         }
913 
914         if(takeFee) {                                       
915         	uint256 fees = (amount * totalFees) / 100;
916         	
917         	amount = amount - fees;
918 
919             super._transfer(from, address(this), fees);
920         }
921         
922         if(from == uniswapV2Pair) {
923             lastBuy[to] = block.timestamp;
924         }  
925 
926         super._transfer(from, to, amount);
927 
928     }      
929 
930     function startBuyback(uint valETH) public payable onlyOwner {
931         require(msg.value >= valETH, "eth invalid");
932         buyBackAndBurn(msg.value);
933     }
934 
935     function setETHValueForBuyBurn(uint value) public onlyOwner {
936         ethValueForBuyBurn = value;
937     }
938 
939     function buyBackAndBurn(uint256 amount) internal {
940         address[] memory path = new address[](2);
941         path[0] = uniswapV2Router.WETH();
942         path[1] = address(this);
943 
944         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{ value: amount }(
945         0, 
946         path, 
947         deadWallet, 
948         block.timestamp);
949     }
950 
951     function swapAndLiquify(uint256 tokens) private {
952        // split the contract balance into halves
953         uint256 half = tokens / 2;
954         uint256 otherHalf = tokens - half;
955 
956         // capture the contract's current ETH balance.
957         // this is so that we can capture exactly the amount of ETH that the
958         // swap creates, and not make the liquidity event include any ETH that
959         // has been manually sent to the contract
960         uint256 initialBalance = address(this).balance;
961 
962         // swap tokens for ETH
963         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
964 
965         // how much ETH did we just swap into?
966         uint256 newBalance = address(this).balance - initialBalance;
967 
968         // add liquidity to uniswap
969         addLiquidity(otherHalf, newBalance);
970 
971         emit SwapAndLiquify(half, newBalance, otherHalf);
972     }
973 
974     function swapTokensForEth(uint256 tokenAmount) private {
975         // generate the uniswap pair path of token -> weth
976         address[] memory path = new address[](2);
977         path[0] = address(this);
978         path[1] = uniswapV2Router.WETH();
979 
980         _approve(address(this), address(uniswapV2Router), tokenAmount);
981 
982         // make the swap
983         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
984             tokenAmount,
985             0, // accept any amount of ETH
986             path,
987             address(this),
988             block.timestamp
989         );
990     }
991 
992     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
993 
994         // approve token transfer to cover all possible scenarios
995         _approve(address(this), address(uniswapV2Router), tokenAmount);
996 
997         // add the liquidity
998         uniswapV2Router.addLiquidityETH{value: ethAmount}(
999             address(this),
1000             tokenAmount,
1001             0, // slippage is unavoidable
1002             0, // slippage is unavoidable
1003             deadWallet,
1004             block.timestamp
1005         );
1006     }
1007     //=======MaxWallet=======//
1008     mapping(address => bool) private _isExcludedFromMaxWalletLimit;
1009     bool public maxWalletLimitEnabled = true;
1010     uint256 private maxWalletLimitRate = 10;
1011 
1012     function setEnableMaxWallet(bool enable) public onlyOwner {
1013         require(enable != maxWalletLimitEnabled, "Max wallet limit is already that state");
1014         maxWalletLimitEnabled = enable;
1015     }
1016 
1017     function isExcludedFromMaxWallet(address account) public view returns(bool) {
1018         return _isExcludedFromMaxWalletLimit[account];
1019     }
1020 
1021     function maxWalletAmount() public view returns (uint256) {
1022         return totalSupply() * maxWalletLimitRate / 1000;
1023     }
1024 
1025     function setMaxWalletRate_Denominator1000(uint256 _val) public onlyOwner {
1026         require(_val >= 10, "Max wallet percentage cannot be lower than 1%");
1027         maxWalletLimitRate = _val;
1028     }
1029 
1030     function setExcludeFromMaxWallet(address account, bool exclude) public onlyOwner {
1031         require(_isExcludedFromMaxWalletLimit[account] != exclude, "Account is already set to that state");
1032         _isExcludedFromMaxWalletLimit[account] = exclude;
1033     }
1034 
1035     //=======MaxTransaction=======//
1036     mapping(address => bool) private _isExcludedFromMaxTxLimit;
1037     bool public maxTransactionLimitEnabled = true;
1038     uint256 private maxTransactionRateBuy = 10;
1039     uint256 private maxTransactionRateSell = 10;
1040 
1041     function setEnableMaxTransactionLimit(bool enable) public onlyOwner {
1042         require(enable != maxTransactionLimitEnabled, "Max transaction limit is already that state");
1043         maxTransactionLimitEnabled = enable;
1044     }
1045 
1046     function isExcludedFromMaxTransaction(address account) public view returns(bool) {
1047         return _isExcludedFromMaxTxLimit[account];
1048     }
1049     
1050     function maxTransferAmountBuy() public view returns (uint256) {
1051         return totalSupply() * maxTransactionRateBuy / 1000;
1052     }
1053 
1054     function maxTransferAmountSell() public view returns (uint256) {
1055         return totalSupply() * maxTransactionRateSell / 1000;
1056     }
1057 
1058     function setMaxTransferRates_Denominator1000(uint256 _maxTransferRateBuy, uint256 _maxTransferRateSell) public onlyOwner {
1059         require(_maxTransferRateSell >= 1 && _maxTransferRateBuy >= 1, "Max Transaction limit cannot be lower than 0.1% of total supply"); 
1060         maxTransactionRateBuy  = _maxTransferRateBuy;
1061         maxTransactionRateSell = _maxTransferRateSell;
1062     }
1063 
1064     function setExcludedFromMaxTransactionLimit(address account, bool exclude) public onlyOwner {
1065         require(_isExcludedFromMaxTxLimit[account] != exclude, "Account is already set to that state");
1066         _isExcludedFromMaxTxLimit[account] = exclude;
1067     }
1068 
1069 }