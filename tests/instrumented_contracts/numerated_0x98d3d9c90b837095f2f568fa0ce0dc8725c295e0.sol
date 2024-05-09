1 // SPDX-License-Identifier: MIT
2 
3 /*
4 For all you motherfuckers who are too lazy to bridge Doge to Dogechain this is for you!
5 
6 Max tx: 1%
7 Max wallet: 2%
8 Taxes: 0/0 + 24hr 24% jeet-tax ( 8% LP, 8% auto-burn, 8% marketing)
9 twitter.com/LazyDogechain
10 
11 Whats the tg you ask? Im too fucking lazy to set one up. If you want one figure that shit out yourself thanks. Im sure the community will appreciate your efforts.
12 
13 - Lazy Dev
14 */
15 
16 
17 pragma solidity 0.8.1;
18 
19 interface IERC20 {
20     /**
21      * @dev Returns the amount of tokens in existence.
22      */
23     function totalSupply() external view returns (uint256);
24 
25     /**
26      * @dev Returns the amount of tokens owned by `account`.
27      */
28     function balanceOf(address account) external view returns (uint256);
29 
30     /**
31      * @dev Moves `amount` tokens from the caller's account to `recipient`.
32      *
33      * Returns a boolean value indicating whether the operation succeeded.
34      *
35      * Emits a {Transfer} event.
36      */
37     function transfer(address recipient, uint256 amount) external returns (bool);
38 
39     /**
40      * @dev Returns the remaining number of tokens that `spender` will be
41      * allowed to spend on behalf of `owner` through {transferFrom}. This is
42      * zero by default.
43      *
44      * This value changes when {approve} or {transferFrom} are called.
45      */
46     function allowance(address owner, address spender) external view returns (uint256);
47 
48     /**
49      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * IMPORTANT: Beware that changing an allowance with this method brings the risk
54      * that someone may use both the old and the new allowance by unfortunate
55      * transaction ordering. One possible solution to mitigate this race
56      * condition is to first reduce the spender's allowance to 0 and set the
57      * desired value afterwards:
58      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
59      *
60      * Emits an {Approval} event.
61      */
62     function approve(address spender, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Moves `amount` tokens from `sender` to `recipient` using the
66      * allowance mechanism. `amount` is then deducted from the caller's
67      * allowance.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transferFrom(
74         address sender,
75         address recipient,
76         uint256 amount
77     ) external returns (bool);
78 
79     /**
80      * @dev Emitted when `value` tokens are moved from one account (`from`) to
81      * another (`to`).
82      *
83      * Note that `value` may be zero.
84      */
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     /**
88      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
89      * a call to {approve}. `value` is the new allowance.
90      */
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 interface IERC20Metadata is IERC20 {
95     /**
96      * @dev Returns the name of the token.
97      */
98     function name() external view returns (string memory);
99 
100     /**
101      * @dev Returns the symbol of the token.
102      */
103     function symbol() external view returns (string memory);
104 
105     /**
106      * @dev Returns the decimals places of the token.
107      */
108     function decimals() external view returns (uint8);
109 }
110 
111 abstract contract Context {
112     function _msgSender() internal view virtual returns (address) {
113         return msg.sender;
114     }
115 
116     function _msgData() internal view virtual returns (bytes calldata) {
117         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
118         return msg.data;
119     }
120 }
121 
122 abstract contract Ownable is Context {
123     address private _owner;
124 
125     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
126 
127     /**
128      * @dev Initializes the contract setting the deployer as the initial owner.
129      */
130     constructor () {
131         address msgSender = _msgSender();
132         _owner = msgSender;
133         emit OwnershipTransferred(address(0), msgSender);
134     }
135 
136     /**
137      * @dev Returns the address of the current owner.
138      */
139     function owner() public view returns (address) {
140         return _owner;
141     }
142 
143     /**
144      * @dev Throws if called by any account other than the owner.
145      */
146     modifier onlyOwner() {
147         require(_owner == _msgSender(), "Ownable: caller is not the owner");
148         _;
149     }
150 
151     /**
152      * @dev Leaves the contract without owner. It will not be possible to call
153      * `onlyOwner` functions anymore. Can only be called by the current owner.
154      *
155      * NOTE: Renouncing ownership will leave the contract without an owner,
156      * thereby removing any functionality that is only available to the owner.
157      */
158     function renounceOwnership() public virtual onlyOwner {
159         emit OwnershipTransferred(_owner, address(0));
160         _owner = address(0);
161     }
162 
163     /**
164      * @dev Transfers ownership of the contract to a new account (`newOwner`).
165      * Can only be called by the current owner.
166      */
167     function transferOwnership(address newOwner) public virtual onlyOwner {
168         require(newOwner != address(0), "Ownable");
169         emit OwnershipTransferred(_owner, newOwner);
170         _owner = newOwner;
171     }
172 }
173 
174 contract ERC20 is Context, IERC20, IERC20Metadata {
175     mapping(address => uint256) private _balances;
176 
177     mapping(address => mapping(address => uint256)) private _allowances;
178 
179     uint256 private _totalSupply;
180 
181     string private _name;
182     string private _symbol;
183 
184     /**
185      * @dev Sets the values for {name} and {symbol}.
186      *
187      * The default value of {decimals} is 18. To select a different value for
188      * {decimals} you should overload it.
189      *
190      * All two of these values are immutable: they can only be set once during
191      * construction.
192      */
193     constructor(string memory name_, string memory symbol_) {
194         _name = name_;
195         _symbol = symbol_;
196     }
197 
198     /**
199      * @dev Returns the name of the token.
200      */
201     function name() public view virtual override returns (string memory) {
202         return _name;
203     }
204 
205     /**
206      * @dev Returns the symbol of the token, usually a shorter version of the
207      * name.
208      */
209     function symbol() public view virtual override returns (string memory) {
210         return _symbol;
211     }
212 
213     /**
214      * @dev Returns the number of decimals used to get its user representation.
215      * For example, if `decimals` equals `2`, a balance of `505` tokens should
216      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
217      *
218      * Tokens usually opt for a value of 18, imitating the relationship between
219      * Ether and Wei. This is the value {ERC20} uses, unless this function is
220      * overridden;
221      *
222      * NOTE: This information is only used for _display_ purposes: it in
223      * no way affects any of the arithmetic of the contract, including
224      * {IERC20-balanceOf} and {IERC20-transfer}.
225      */
226     function decimals() public view virtual override returns (uint8) {
227         return 18;
228     }
229 
230     /**
231      * @dev See {IERC20-totalSupply}.
232      */
233     function totalSupply() public view virtual override returns (uint256) {
234         return _totalSupply;
235     }
236 
237     /**
238      * @dev See {IERC20-balanceOf}.
239      */
240     function balanceOf(address account) public view virtual override returns (uint256) {
241         return _balances[account];
242     }
243 
244     /**
245      * @dev See {IERC20-transfer}.
246      *
247      * Requirements:
248      *
249      * - `recipient` cannot be the zero address.
250      * - the caller must have a balance of at least `amount`.
251      */
252     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
253         _transfer(_msgSender(), recipient, amount);
254         return true;
255     }
256 
257     /**
258      * @dev See {IERC20-allowance}.
259      */
260     function allowance(address owner, address spender) public view virtual override returns (uint256) {
261         return _allowances[owner][spender];
262     }
263 
264     /**
265      * @dev See {IERC20-approve}.
266      *
267      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
268      * `transferFrom`. This is semantically equivalent to an infinite approval.
269      *
270      * Requirements:
271      *
272      * - `spender` cannot be the zero address.
273      */
274     function approve(address spender, uint256 amount) public virtual override returns (bool) {
275         _approve(_msgSender(), spender, amount);
276         return true;
277     }
278 
279     /**
280      * @dev See {IERC20-transferFrom}.
281      *
282      * Emits an {Approval} event indicating the updated allowance. This is not
283      * required by the EIP. See the note at the beginning of {ERC20}.
284      *
285      * NOTE: Does not update the allowance if the current allowance
286      * is the maximum `uint256`.
287      *
288      * Requirements:
289      *
290      * - `sender` and `recipient` cannot be the zero address.
291      * - `sender` must have a balance of at least `amount`.
292      * - the caller must have allowance for ``sender``'s tokens of at least
293      * `amount`.
294      */
295     function transferFrom(
296         address sender,
297         address recipient,
298         uint256 amount
299     ) public virtual override returns (bool) {
300         uint256 currentAllowance = _allowances[sender][_msgSender()];
301         if (currentAllowance != type(uint256).max) {
302             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
303             unchecked {
304                 _approve(sender, _msgSender(), currentAllowance - amount);
305             }
306         }
307 
308         _transfer(sender, recipient, amount);
309 
310         return true;
311     }
312 
313     /**
314      * @dev Atomically increases the allowance granted to `spender` by the caller.
315      *
316      * This is an alternative to {approve} that can be used as a mitigation for
317      * problems described in {IERC20-approve}.
318      *
319      * Emits an {Approval} event indicating the updated allowance.
320      *
321      * Requirements:
322      *
323      * - `spender` cannot be the zero address.
324      */
325     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
326         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
327         return true;
328     }
329 
330     /**
331      * @dev Atomically decreases the allowance granted to `spender` by the caller.
332      *
333      * This is an alternative to {approve} that can be used as a mitigation for
334      * problems described in {IERC20-approve}.
335      *
336      * Emits an {Approval} event indicating the updated allowance.
337      *
338      * Requirements:
339      *
340      * - `spender` cannot be the zero address.
341      * - `spender` must have allowance for the caller of at least
342      * `subtractedValue`.
343      */
344     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
345         uint256 currentAllowance = _allowances[_msgSender()][spender];
346         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
347         unchecked {
348             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
349         }
350 
351         return true;
352     }
353 
354     /**
355      * @dev Moves `amount` of tokens from `sender` to `recipient`.
356      *
357      * This internal function is equivalent to {transfer}, and can be used to
358      * e.g. implement automatic token fees, slashing mechanisms, etc.
359      *
360      * Emits a {Transfer} event.
361      *
362      * Requirements:
363      *
364      * - `sender` cannot be the zero address.
365      * - `recipient` cannot be the zero address.
366      * - `sender` must have a balance of at least `amount`.
367      */
368     function _transfer(
369         address sender,
370         address recipient,
371         uint256 amount
372     ) internal virtual {
373         require(sender != address(0), "ERC20: transfer from the zero address");
374         require(recipient != address(0), "ERC20: transfer to the zero address");
375 
376         _beforeTokenTransfer(sender, recipient, amount);
377 
378         uint256 senderBalance = _balances[sender];
379         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
380         unchecked {
381             _balances[sender] = senderBalance - amount;
382         }
383         _balances[recipient] += amount;
384 
385         emit Transfer(sender, recipient, amount);
386 
387         _afterTokenTransfer(sender, recipient, amount);
388     }
389 
390     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
391      * the total supply.
392      *
393      * Emits a {Transfer} event with `from` set to the zero address.
394      *
395      * Requirements:
396      *
397      * - `account` cannot be the zero address.
398      */
399     function _mint(address account, uint256 amount) internal virtual {
400         require(account != address(0), "ERC20: mint to the zero address");
401 
402         _beforeTokenTransfer(address(0), account, amount);
403 
404         _totalSupply += amount;
405         _balances[account] += amount;
406         emit Transfer(address(0), account, amount);
407 
408         _afterTokenTransfer(address(0), account, amount);
409     }
410 
411     /**
412      * @dev Destroys `amount` tokens from `account`, reducing the
413      * total supply.
414      *
415      * Emits a {Transfer} event with `to` set to the zero address.
416      *
417      * Requirements:
418      *
419      * - `account` cannot be the zero address.
420      * - `account` must have at least `amount` tokens.
421      */
422     function _burn(address account, uint256 amount) internal virtual {
423         require(account != address(0));
424 
425         _beforeTokenTransfer(account, address(0), amount);
426 
427         uint256 accountBalance = _balances[account];
428         require(accountBalance >= amount);
429         unchecked {
430             _balances[account] = accountBalance - amount;
431         }
432         _totalSupply -= amount;
433 
434         emit Transfer(account, address(0), amount);
435 
436         _afterTokenTransfer(account, address(0), amount);
437     }
438 
439     /**
440      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
441      *
442      * This internal function is equivalent to `approve`, and can be used to
443      * e.g. set automatic allowances for certain subsystems, etc.
444      *
445      * Emits an {Approval} event.
446      *
447      * Requirements:
448      *
449      * - `owner` cannot be the zero address.
450      * - `spender` cannot be the zero address.
451      */
452     function _approve(
453         address owner,
454         address spender,
455         uint256 amount
456     ) internal virtual {
457         require(owner != address(0), "ERC20: approve from the zero address");
458         require(spender != address(0), "ERC20: approve to the zero address");
459 
460         _allowances[owner][spender] = amount;
461         emit Approval(owner, spender, amount);
462     }
463 
464     /**
465      * @dev Hook that is called before any transfer of tokens. This includes
466      * minting and burning.
467      *
468      * Calling conditions:
469      *
470      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
471      * will be transferred to `to`.
472      * - when `from` is zero, `amount` tokens will be minted for `to`.
473      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
474      * - `from` and `to` are never both zero.
475      *
476      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
477      */
478     function _beforeTokenTransfer(
479         address from,
480         address to,
481         uint256 amount
482     ) internal virtual {}
483 
484     /**
485      * @dev Hook that is called after any transfer of tokens. This includes
486      * minting and burning.
487      *
488      * Calling conditions:
489      *
490      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
491      * has been transferred to `to`.
492      * - when `from` is zero, `amount` tokens have been minted for `to`.
493      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
494      * - `from` and `to` are never both zero.
495      *
496      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
497      */
498     function _afterTokenTransfer(
499         address from,
500         address to,
501         uint256 amount
502     ) internal virtual {}
503 }
504 
505 interface IUniswapV2Factory {
506     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
507 
508     function feeTo() external view returns (address);
509     function feeToSetter() external view returns (address);
510 
511     function getPair(address tokenA, address tokenB) external view returns (address pair);
512     function allPairs(uint) external view returns (address pair);
513     function allPairsLength() external view returns (uint);
514 
515     function createPair(address tokenA, address tokenB) external returns (address pair);
516 
517     function setFeeTo(address) external;
518     function setFeeToSetter(address) external;
519 }
520 
521 interface IUniswapV2Pair {
522     event Approval(address indexed owner, address indexed spender, uint value);
523     event Transfer(address indexed from, address indexed to, uint value);
524 
525     function name() external pure returns (string memory);
526     function symbol() external pure returns (string memory);
527     function decimals() external pure returns (uint8);
528     function totalSupply() external view returns (uint);
529     function balanceOf(address owner) external view returns (uint);
530     function allowance(address owner, address spender) external view returns (uint);
531 
532     function approve(address spender, uint value) external returns (bool);
533     function transfer(address to, uint value) external returns (bool);
534     function transferFrom(address from, address to, uint value) external returns (bool);
535 
536     function DOMAIN_SEPARATOR() external view returns (bytes32);
537     function PERMIT_TYPEHASH() external pure returns (bytes32);
538     function nonces(address owner) external view returns (uint);
539 
540     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
541 
542     event Mint(address indexed sender, uint amount0, uint amount1);
543     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
544     event Swap(
545         address indexed sender,
546         uint amount0In,
547         uint amount1In,
548         uint amount0Out,
549         uint amount1Out,
550         address indexed to
551     );
552     event Sync(uint112 reserve0, uint112 reserve1);
553 
554     function MINIMUM_LIQUIDITY() external pure returns (uint);
555     function factory() external view returns (address);
556     function token0() external view returns (address);
557     function token1() external view returns (address);
558     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
559     function price0CumulativeLast() external view returns (uint);
560     function price1CumulativeLast() external view returns (uint);
561     function kLast() external view returns (uint);
562 
563     function mint(address to) external returns (uint liquidity);
564     function burn(address to) external returns (uint amount0, uint amount1);
565     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
566     function skim(address to) external;
567     function sync() external;
568 
569     function initialize(address, address) external;
570 }
571 
572 interface IUniswapV2Router01 {
573     function factory() external pure returns (address);
574     function WETH() external pure returns (address);
575 
576     function addLiquidity(
577         address tokenA,
578         address tokenB,
579         uint amountADesired,
580         uint amountBDesired,
581         uint amountAMin,
582         uint amountBMin,
583         address to,
584         uint deadline
585     ) external returns (uint amountA, uint amountB, uint liquidity);
586     function addLiquidityETH(
587         address token,
588         uint amountTokenDesired,
589         uint amountTokenMin,
590         uint amountETHMin,
591         address to,
592         uint deadline
593     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
594     function removeLiquidity(
595         address tokenA,
596         address tokenB,
597         uint liquidity,
598         uint amountAMin,
599         uint amountBMin,
600         address to,
601         uint deadline
602     ) external returns (uint amountA, uint amountB);
603     function removeLiquidityETH(
604         address token,
605         uint liquidity,
606         uint amountTokenMin,
607         uint amountETHMin,
608         address to,
609         uint deadline
610     ) external returns (uint amountToken, uint amountETH);
611     function removeLiquidityWithPermit(
612         address tokenA,
613         address tokenB,
614         uint liquidity,
615         uint amountAMin,
616         uint amountBMin,
617         address to,
618         uint deadline,
619         bool approveMax, uint8 v, bytes32 r, bytes32 s
620     ) external returns (uint amountA, uint amountB);
621     function removeLiquidityETHWithPermit(
622         address token,
623         uint liquidity,
624         uint amountTokenMin,
625         uint amountETHMin,
626         address to,
627         uint deadline,
628         bool approveMax, uint8 v, bytes32 r, bytes32 s
629     ) external returns (uint amountToken, uint amountETH);
630     function swapExactTokensForTokens(
631         uint amountIn,
632         uint amountOutMin,
633         address[] calldata path,
634         address to,
635         uint deadline
636     ) external returns (uint[] memory amounts);
637     function swapTokensForExactTokens(
638         uint amountOut,
639         uint amountInMax,
640         address[] calldata path,
641         address to,
642         uint deadline
643     ) external returns (uint[] memory amounts);
644     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
645         external
646         payable
647         returns (uint[] memory amounts);
648     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
649         external
650         returns (uint[] memory amounts);
651     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
652         external
653         returns (uint[] memory amounts);
654     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
655         external
656         payable
657         returns (uint[] memory amounts);
658 
659     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
660     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
661     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
662     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
663     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
664 }
665 
666 interface IUniswapV2Router02 is IUniswapV2Router01 {
667     function removeLiquidityETHSupportingFeeOnTransferTokens(
668         address token,
669         uint liquidity,
670         uint amountTokenMin,
671         uint amountETHMin,
672         address to,
673         uint deadline
674     ) external returns (uint amountETH);
675     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
676         address token,
677         uint liquidity,
678         uint amountTokenMin,
679         uint amountETHMin,
680         address to,
681         uint deadline,
682         bool approveMax, uint8 v, bytes32 r, bytes32 s
683     ) external returns (uint amountETH);
684 
685     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
686         uint amountIn,
687         uint amountOutMin,
688         address[] calldata path,
689         address to,
690         uint deadline
691     ) external;
692     function swapExactETHForTokensSupportingFeeOnTransferTokens(
693         uint amountOutMin,
694         address[] calldata path,
695         address to,
696         uint deadline
697     ) external payable;
698     function swapExactTokensForETHSupportingFeeOnTransferTokens(
699         uint amountIn,
700         uint amountOutMin,
701         address[] calldata path,
702         address to,
703         uint deadline
704     ) external;
705 }
706 
707 contract LazyDogechain is ERC20, Ownable {
708 
709     IUniswapV2Router02 public uniswapV2Router;
710     address public  uniswapV2Pair;
711 
712     bool private swapping;
713     bool public tradingActive = false;
714 
715     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
716     uint256 public blockForPenaltyEnd = 0;
717     
718 
719     address public deadWallet = 0x000000000000000000000000000000000000dEaD;
720     address public marketingWallet = 0x5Cfad705aAB49055549Ca3E581842Ba9Cc9fE8B3;
721 
722     uint256 public swapTokensAtAmount = 200 * (10**18);
723 
724     uint256 public liquidityFee = 8;
725     uint256 public marketingFee = 8;
726     uint256 public buybackFee = 8;
727     uint256 public totalFees = liquidityFee + marketingFee + buybackFee;
728 
729     mapping (address => bool) private _isExcludedFromFees;
730     mapping (address => bool) public automatedMarketMakerPairs;
731     mapping (address => bool) public restrictedWallet;
732 
733     mapping (address => uint256) public lastBuy;
734 
735     uint public accumulatedBuybackETH = 0;
736     uint public ethValueForBuyBurn = 15 * (10**16); // 0.15 ETH
737 
738     
739     event SwapAndLiquify(
740         uint256 tokensSwapped,
741         uint256 ethReceived,
742         uint256 tokensIntoLiquidity
743     );
744     event EnabledTrading();
745     
746 
747     constructor (address _newOwner) ERC20("LazyDogechain Token", "LDC") {
748         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
749          // Create a uniswap pair for this new token
750         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
751             .createPair(address(this), _uniswapV2Router.WETH());
752 
753         uniswapV2Router = _uniswapV2Router;
754         uniswapV2Pair = _uniswapV2Pair;
755 
756         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
757 
758         excludeFromFees(_newOwner, true);
759         excludeFromFees(address(this), true);
760         
761         _isExcludedFromMaxWalletLimit[_newOwner] = true;
762         _isExcludedFromMaxWalletLimit[address(0)] = true;
763         _isExcludedFromMaxWalletLimit[address(this)] = true;
764         _isExcludedFromMaxWalletLimit[deadWallet] = true;
765 
766         _isExcludedFromMaxTxLimit[_newOwner] = true;
767         _isExcludedFromMaxTxLimit[address(0)] = true;
768         _isExcludedFromMaxTxLimit[address(this)] = true;
769         _isExcludedFromMaxTxLimit[deadWallet] = true;
770 
771         _mint(_newOwner, 1_000_000_000 * (10**18));
772         transferOwnership(_newOwner);
773     }
774 
775     receive() external payable {
776 
777   	}
778       
779     function updateUniswapV2Router(address newAddress) public onlyOwner {
780         require(newAddress != address(uniswapV2Router), "The router already has that address");
781        
782         uniswapV2Router = IUniswapV2Router02(newAddress);
783         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
784             .createPair(address(this), uniswapV2Router.WETH());
785         uniswapV2Pair = _uniswapV2Pair;
786     }
787 
788     function excludeFromFees(address account, bool excluded) public onlyOwner {
789         require(_isExcludedFromFees[account] != excluded, "Account is already the value of 'excluded'");
790         _isExcludedFromFees[account] = excluded;
791 
792     }
793 
794     function setSwapTokensAtAmount(uint256 amount) external onlyOwner{
795         require(amount > totalSupply() / 100000, "Amount must be greater than 0.001% of total supply");
796         swapTokensAtAmount = amount;
797     }
798 
799     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
800         require(pair != uniswapV2Pair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
801 
802         _setAutomatedMarketMakerPair(pair, value);
803        
804     }
805  
806     function _setAutomatedMarketMakerPair(address pair, bool value) private {
807         require(automatedMarketMakerPairs[pair] != value, "Automated market maker pair is already set to that value");
808         automatedMarketMakerPairs[pair] = value;
809 
810        
811     }
812 
813     function setFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _buybackFee) external onlyOwner {
814         marketingFee = _marketingFee;
815         liquidityFee = _liquidityFee;
816         buybackFee = _buybackFee;
817         totalFees = marketingFee + liquidityFee + buybackFee;
818         require(totalFees <= 25, "fees < 25%");
819     }
820 
821     function setMarketingWallet(address _marketingWallet) external onlyOwner {
822         marketingWallet = _marketingWallet;
823     }
824 
825     function claimStuckTokens(address token) external onlyOwner {
826         require(token != address(this), "Owner cannot claim");
827         if (token == address(0x0)) {
828             payable(msg.sender).transfer(address(this).balance);
829             return;
830         }
831         IERC20 ERC20token = IERC20(token);
832         uint256 balance = ERC20token.balanceOf(address(this));
833         ERC20token.transfer(msg.sender, balance);
834     }
835 
836     function earlyBuyPenaltyInEffect() public view returns (bool){
837         return block.number < blockForPenaltyEnd;
838     }
839 
840     function manageRestrictedWallets(address[] calldata wallets, bool restricted) external onlyOwner {
841         for(uint256 i = 0; i < wallets.length; i++){
842             restrictedWallet[wallets[i]] = restricted;
843         }
844     }
845 
846     function _transfer(
847         address from,
848         address to,
849         uint256 amount
850     ) internal  override {
851         require(from != address(0), "from 0 add");
852         require(to != address(0), "to 0 add");
853     
854         if(amount == 0) {
855             super._transfer(from, to, 0);
856             return;
857         }
858           if(!tradingActive){
859             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
860         }
861         if(earlyBuyPenaltyInEffect()&& !_isExcludedFromFees[to]){
862             if(!restrictedWallet[to]){
863                     restrictedWallet[to] = true;
864                     
865                    
866                 }
867         }
868 
869         if(!earlyBuyPenaltyInEffect() && blockForPenaltyEnd > 0){
870             require(!restrictedWallet[from] || to == owner() || to == address(0xdead), "Bot");
871         }
872 
873         if (maxWalletLimitEnabled) {
874             if (_isExcludedFromMaxWalletLimit[from] == false
875                 && _isExcludedFromMaxWalletLimit[to] == false &&
876                 to != uniswapV2Pair
877             ) {
878                 uint balance  = balanceOf(to);
879                 require(balance + amount <= maxWalletAmount(), "MaxWallet");
880             }
881         }
882 
883         if (maxTransactionLimitEnabled) {
884             if (_isExcludedFromMaxTxLimit[from] == false
885                 && _isExcludedFromMaxTxLimit[to] == false
886             ) {
887                 if (from == uniswapV2Pair) {
888                     require(amount <= maxTransferAmountBuy(), "AntiWhale");
889                 }else{
890                     require(amount <= maxTransferAmountSell(), "AntiWhale");
891                 }
892             }
893         }
894         
895 
896 		uint256 contractTokenBalance = balanceOf(address(this));
897 
898         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
899 
900         if( canSwap &&
901             !swapping &&
902             !automatedMarketMakerPairs[from] &&
903             from != owner() &&
904             to != owner() &&
905             totalFees != 0
906         ) {
907             swapping = true;
908 
909             uint256 liqTokensToAdd = contractTokenBalance * liquidityFee / 2 / totalFees;
910             contractTokenBalance -= liqTokensToAdd;
911 
912             uint initBalance = address(this).balance;
913             swapTokensForEth(contractTokenBalance);
914             uint finalBalance = address(this).balance - (initBalance);
915             uint ethFee = totalFees * 2 - liquidityFee;
916 
917 
918             if(marketingFee > 0) {
919                 uint256 marketingETH = finalBalance * (2 * marketingFee) / ethFee;
920                 payable(marketingWallet).transfer(marketingETH);
921             }
922 
923             if(liquidityFee > 0) {
924                 uint256 liqETH = finalBalance * liquidityFee / ethFee;
925                 addLiquidity(liqTokensToAdd, liqETH);
926             }
927 
928             if(buybackFee > 0) {
929                 uint256 buybackETH = finalBalance * (2 * buybackFee) / ethFee;
930                 accumulatedBuybackETH += buybackETH;
931                 if (accumulatedBuybackETH > ethValueForBuyBurn) {
932                     if(address(this).balance >= accumulatedBuybackETH) {
933                         buyBackAndBurn(accumulatedBuybackETH);
934                     }else{
935                         buyBackAndBurn(address(this).balance);
936                     }
937                     accumulatedBuybackETH = 0;
938                 }
939             }       
940 
941             swapping = false;
942         }
943 
944         bool takeFee = !swapping;
945 
946         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
947             takeFee = false;
948         } 
949 
950         if(from == uniswapV2Pair) {
951             takeFee = false;      
952         }
953         
954         if(block.timestamp - lastBuy[from] > 24 hours) {
955             takeFee = false;
956         }
957 
958         if(takeFee) {                                       
959         	uint256 fees = (amount * totalFees) / 100;
960         	
961         	amount = amount - fees;
962 
963             super._transfer(from, address(this), fees);
964         }
965         
966         if(from == uniswapV2Pair) {
967             lastBuy[to] = block.timestamp;
968         }  
969 
970         super._transfer(from, to, amount);
971 
972     }      
973 
974     function startBuyback(uint valETH) public payable onlyOwner {
975         require(msg.value >= valETH, "eth invalid");
976         buyBackAndBurn(msg.value);
977     }
978 
979     function setETHValueForBuyBurn(uint value) public onlyOwner {
980         ethValueForBuyBurn = value;
981     }
982 
983     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
984         require(blockForPenaltyEnd == 0);
985         tradingActive = true;
986         tradingActiveBlock = block.number;
987         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
988         emit EnabledTrading();
989     }
990 
991     function buyBackAndBurn(uint256 amount) internal {
992         address[] memory path = new address[](2);
993         path[0] = uniswapV2Router.WETH();
994         path[1] = address(this);
995 
996         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{ value: amount }(
997         0, 
998         path, 
999         deadWallet, 
1000         block.timestamp);
1001     }
1002 
1003     function swapAndLiquify(uint256 tokens) private {
1004        // split the contract balance into halves
1005         uint256 half = tokens / 2;
1006         uint256 otherHalf = tokens - half;
1007 
1008         // capture the contract's current ETH balance.
1009         // this is so that we can capture exactly the amount of ETH that the
1010         // swap creates, and not make the liquidity event include any ETH that
1011         // has been manually sent to the contract
1012         uint256 initialBalance = address(this).balance;
1013 
1014         // swap tokens for ETH
1015         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1016 
1017         // how much ETH did we just swap into?
1018         uint256 newBalance = address(this).balance - initialBalance;
1019 
1020         // add liquidity to uniswap
1021         addLiquidity(otherHalf, newBalance);
1022 
1023         emit SwapAndLiquify(half, newBalance, otherHalf);
1024     }
1025 
1026     function swapTokensForEth(uint256 tokenAmount) private {
1027         // generate the uniswap pair path of token -> weth
1028         address[] memory path = new address[](2);
1029         path[0] = address(this);
1030         path[1] = uniswapV2Router.WETH();
1031 
1032         _approve(address(this), address(uniswapV2Router), tokenAmount);
1033 
1034         // make the swap
1035         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1036             tokenAmount,
1037             0, // accept any amount of ETH
1038             path,
1039             address(this),
1040             block.timestamp
1041         );
1042     }
1043 
1044     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1045 
1046         // approve token transfer to cover all possible scenarios
1047         _approve(address(this), address(uniswapV2Router), tokenAmount);
1048 
1049         // add the liquidity
1050         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1051             address(this),
1052             tokenAmount,
1053             0, // slippage is unavoidable
1054             0, // slippage is unavoidable
1055             deadWallet,
1056             block.timestamp
1057         );
1058     }
1059     //=======MaxWallet=======//
1060     mapping(address => bool) private _isExcludedFromMaxWalletLimit;
1061     bool public maxWalletLimitEnabled = true;
1062     uint256 private maxWalletLimitRate = 20;
1063 
1064     function setEnableMaxWallet(bool enable) public onlyOwner {
1065         require(enable != maxWalletLimitEnabled);
1066         maxWalletLimitEnabled = enable;
1067     }
1068 
1069     function isExcludedFromMaxWallet(address account) public view returns(bool) {
1070         return _isExcludedFromMaxWalletLimit[account];
1071     }
1072 
1073     function maxWalletAmount() public view returns (uint256) {
1074         return totalSupply() * maxWalletLimitRate / 1000;
1075     }
1076 
1077     function setMaxWalletRate_Denominator1000(uint256 _val) public onlyOwner {
1078         require(_val >= 10);
1079         maxWalletLimitRate = _val;
1080     }
1081 
1082     function setExcludeFromMaxWallet(address account, bool exclude) public onlyOwner {
1083         require(_isExcludedFromMaxWalletLimit[account] != exclude);
1084         _isExcludedFromMaxWalletLimit[account] = exclude;
1085     }
1086 
1087     //=======MaxTransaction=======//
1088     mapping(address => bool) private _isExcludedFromMaxTxLimit;
1089     bool public maxTransactionLimitEnabled = true;
1090     uint256 private maxTransactionRateBuy = 10;
1091     uint256 private maxTransactionRateSell = 10;
1092 
1093     function setEnableMaxTransactionLimit(bool enable) public onlyOwner {
1094         require(enable != maxTransactionLimitEnabled);
1095         maxTransactionLimitEnabled = enable;
1096     }
1097 
1098     function isExcludedFromMaxTransaction(address account) public view returns(bool) {
1099         return _isExcludedFromMaxTxLimit[account];
1100     }
1101     
1102     function maxTransferAmountBuy() public view returns (uint256) {
1103         return totalSupply() * maxTransactionRateBuy / 1000;
1104     }
1105 
1106     function maxTransferAmountSell() public view returns (uint256) {
1107         return totalSupply() * maxTransactionRateSell / 1000;
1108     }
1109 
1110     function setMaxTransferRates_Denominator1000(uint256 _maxTransferRateBuy, uint256 _maxTransferRateSell) public onlyOwner {
1111         require(_maxTransferRateSell >= 1 && _maxTransferRateBuy >= 1, "Max Transaction limit cannot be lower than 0.1% of total supply"); 
1112         maxTransactionRateBuy  = _maxTransferRateBuy;
1113         maxTransactionRateSell = _maxTransferRateSell;
1114     }
1115 
1116     function setExcludedFromMaxTransactionLimit(address account, bool exclude) public onlyOwner {
1117         require(_isExcludedFromMaxTxLimit[account] != exclude, "Account is already set to that state");
1118         _isExcludedFromMaxTxLimit[account] = exclude;
1119     }
1120 
1121 }