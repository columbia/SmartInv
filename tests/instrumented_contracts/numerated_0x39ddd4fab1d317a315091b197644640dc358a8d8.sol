1 /*
2 
3 ██████╗  ██████╗  ██████╗ ███████╗██╗     ███████╗███╗   ██╗ █████╗ ███╗   ███╗ █████╗ ██████╗ ███████╗
4 ██╔══██╗██╔═══██╗██╔════╝ ██╔════╝██║     ██╔════╝████╗  ██║██╔══██╗████╗ ████║██╔══██╗██╔══██╗██╔════╝
5 ██║  ██║██║   ██║██║  ███╗█████╗  ██║     █████╗  ██╔██╗ ██║███████║██╔████╔██║███████║██████╔╝███████╗
6 ██║  ██║██║   ██║██║   ██║██╔══╝  ██║     ██╔══╝  ██║╚██╗██║██╔══██║██║╚██╔╝██║██╔══██║██╔══██╗╚════██║
7 ██████╔╝╚██████╔╝╚██████╔╝███████╗███████╗███████╗██║ ╚████║██║  ██║██║ ╚═╝ ██║██║  ██║██║  ██║███████║
8 ╚═════╝  ╚═════╝  ╚═════╝ ╚══════╝╚══════╝╚══════╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
9   
10 Website:
11 https://www.dogelenamars.com
12 
13 */
14 
15 // SPDX-License-Identifier: MIT
16 pragma solidity ^0.8.9;
17 
18 /**
19  * @dev Interface of the ERC20 standard as defined in the EIP.
20  */
21 interface IERC20 {
22     /**
23      * @dev Returns the amount of tokens in existence.
24      */
25     function totalSupply() external view returns (uint256);
26 
27     /**
28      * @dev Returns the amount of tokens owned by `account`.
29      */
30     function balanceOf(address account) external view returns (uint256);
31 
32     /**
33    
34      */
35     function transfer(address recipient, uint256 amount) external returns (bool);
36 
37     /**
38     
39      */
40     function allowance(address owner, address spender) external view returns (uint256);
41 
42     /**
43 
44      */
45     function approve(address spender, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Moves `amount` tokens from `sender` to `recipient` using the
49      * allowance mechanism. `amount` is then deducted from the caller's
50      * allowance.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transferFrom(
57         address sender,
58         address recipient,
59         uint256 amount
60     ) external returns (bool);
61 
62     /**
63      * @dev Emitted when `value` tokens are moved from one account (`from`) to
64      * another (`to`).
65      *
66      * Note that `value` may be zero.
67      */
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 
70     /**
71      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
72      * a call to {approve}. `value` is the new allowance.
73      */
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 /**
78  * @dev Interface for the optional metadata functions from the ERC20 standard.
79  *
80  * _Available since v4.1._
81  */
82 interface IERC20Metadata is IERC20 {
83     /**
84      * @dev Returns the name of the token.
85      */
86     function name() external view returns (string memory);
87 
88     /**
89      * @dev Returns the symbol of the token.
90      */
91     function symbol() external view returns (string memory);
92 
93     /**
94      * @dev Returns the decimals places of the token.
95      */
96     function decimals() external view returns (uint8);
97 }
98 
99 /*
100 
101  */
102 abstract contract Context {
103     function _msgSender() internal view virtual returns (address) {
104         return msg.sender;
105     }
106 
107     function _msgData() internal view virtual returns (bytes calldata) {
108         return msg.data;
109     }
110 }
111 
112 /**
113  * @dev Implementation of the {IERC20} interface.
114  *
115  * This implementation is agnostic to the way tokens are created. This means
116  * that a supply mechanism has to be added in a derived contract using {_mint}.
117  * For a generic mechanism see {ERC20PresetMinterPauser}.
118  */
119 contract ERC20 is Context, IERC20, IERC20Metadata {
120     mapping(address => uint256) private _balances;
121 
122     mapping(address => mapping(address => uint256)) private _allowances;
123 
124     uint256 private _totalSupply;
125 
126     string private _name;
127     string private _symbol;
128 
129     /**
130  
131      */
132     constructor(string memory name_, string memory symbol_) {
133         _name = name_;
134         _symbol = symbol_;
135     }
136 
137     /**
138      * @dev Returns the name of the token.
139      */
140     function name() public view virtual override returns (string memory) {
141         return _name;
142     }
143 
144     /**
145      * @dev Returns the symbol of the token, usually a shorter version of the
146      * name.
147      */
148     function symbol() public view virtual override returns (string memory) {
149         return _symbol;
150     }
151 
152     /**
153     
154      */
155     function decimals() public view virtual override returns (uint8) {
156         return 18;
157     }
158 
159     /**
160      * @dev See {IERC20-totalSupply}.
161      */
162     function totalSupply() public view virtual override returns (uint256) {
163         return _totalSupply;
164     }
165 
166     /**
167      * @dev See {IERC20-balanceOf}.
168      */
169     function balanceOf(address account) public view virtual override returns (uint256) {
170         return _balances[account];
171     }
172 
173     /**
174      * @dev See {IERC20-transfer}.
175      *
176      * Requirements:
177      *
178      * - `recipient` cannot be the zero address.
179      * - the caller must have a balance of at least `amount`.
180      */
181     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
182         _transfer(_msgSender(), recipient, amount);
183         return true;
184     }
185 
186     /**
187      * @dev See {IERC20-allowance}.
188      */
189     function allowance(address owner, address spender) public view virtual override returns (uint256) {
190         return _allowances[owner][spender];
191     }
192 
193     /**
194      * @dev See {IERC20-approve}.
195      *
196      * Requirements:
197      *
198      * - `spender` cannot be the zero address.
199      */
200     function approve(address spender, uint256 amount) public virtual override returns (bool) {
201         _approve(_msgSender(), spender, amount);
202         return true;
203     }
204 
205     /**
206     
207      */
208     function transferFrom(
209         address sender,
210         address recipient,
211         uint256 amount
212     ) public virtual override returns (bool) {
213         _transfer(sender, recipient, amount);
214 
215         uint256 currentAllowance = _allowances[sender][_msgSender()];
216         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
217         unchecked {
218             _approve(sender, _msgSender(), currentAllowance - amount);
219         }
220 
221         return true;
222     }
223 
224     /**
225     
226      */
227     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
228         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
229         return true;
230     }
231 
232     /**
233     
234      */
235     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
236         uint256 currentAllowance = _allowances[_msgSender()][spender];
237         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
238         unchecked {
239             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
240         }
241 
242         return true;
243     }
244 
245     /**
246      
247      */
248     function _transfer(
249         address sender,
250         address recipient,
251         uint256 amount
252     ) internal virtual {
253         require(sender != address(0), "ERC20: transfer from the zero address");
254         require(recipient != address(0), "ERC20: transfer to the zero address");
255 
256         _beforeTokenTransfer(sender, recipient, amount);
257 
258         uint256 senderBalance = _balances[sender];
259         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
260         unchecked {
261             _balances[sender] = senderBalance - amount;
262         }
263         _balances[recipient] += amount;
264 
265         emit Transfer(sender, recipient, amount);
266 
267         _afterTokenTransfer(sender, recipient, amount);
268     }
269 
270     /** 
271     
272      */
273     function _mint(address account, uint256 amount) internal virtual {
274         require(account != address(0), "ERC20: mint to the zero address");
275 
276         _beforeTokenTransfer(address(0), account, amount);
277 
278         _totalSupply += amount;
279         _balances[account] += amount;
280         emit Transfer(address(0), account, amount);
281 
282         _afterTokenTransfer(address(0), account, amount);
283     }
284 
285     /**
286     
287      */
288     function _burn(address account, uint256 amount) internal virtual {
289         require(account != address(0), "ERC20: burn from the zero address");
290 
291         _beforeTokenTransfer(account, address(0), amount);
292 
293         uint256 accountBalance = _balances[account];
294         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
295         unchecked {
296             _balances[account] = accountBalance - amount;
297         }
298         _totalSupply -= amount;
299 
300         emit Transfer(account, address(0), amount);
301 
302         _afterTokenTransfer(account, address(0), amount);
303     }
304 
305     /**
306 
307      */
308     function _approve(
309         address owner,
310         address spender,
311         uint256 amount
312     ) internal virtual {
313         require(owner != address(0), "ERC20: approve from the zero address");
314         require(spender != address(0), "ERC20: approve to the zero address");
315 
316         _allowances[owner][spender] = amount;
317         emit Approval(owner, spender, amount);
318     }
319 
320     /**
321    
322      */
323     function _beforeTokenTransfer(
324         address from,
325         address to,
326         uint256 amount
327     ) internal virtual {}
328 
329     /**
330  
331      */
332     function _afterTokenTransfer(
333         address from,
334         address to,
335         uint256 amount
336     ) internal virtual {}
337 }
338 
339 /**
340 
341  */
342 abstract contract Ownable is Context {
343     address private _owner;
344 
345     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
346 
347     /**
348      * @dev Initializes the contract setting the deployer as the initial owner.
349      */
350     constructor() {
351     }
352 
353     /**
354      * @dev Returns the address of the current owner.
355      */
356     function owner() public view virtual returns (address) {
357         return _owner;
358     }
359 
360     /**
361      * @dev Throws if called by any account other than the owner.
362      */
363     modifier onlyOwner() {
364         require(owner() == _msgSender(), "Ownable: caller is not the owner");
365         _;
366     }
367 
368     /**
369 
370      */
371     function renounceOwnership() public virtual onlyOwner {
372         _setOwner(address(0));
373     }
374 
375     /**
376      * @dev Transfers ownership of the contract to a new account (`newOwner`).
377      * Can only be called by the current owner.
378      */
379     function transferOwnership(address newOwner) public virtual onlyOwner {
380         require(newOwner != address(0), "Ownable: new owner is the zero address");
381         _setOwner(newOwner);
382     }
383 
384     function _setOwner(address newOwner) internal {
385         address oldOwner = _owner;
386         _owner = newOwner;
387         emit OwnershipTransferred(oldOwner, newOwner);
388     }
389 }
390 
391 /**
392 
393  */
394 abstract contract Pausable is Context {
395     /**
396      * @dev Emitted when the pause is triggered by `account`.
397      */
398     event Paused(address account);
399 
400     /**
401      * @dev Emitted when the pause is lifted by `account`.
402      */
403     event Unpaused(address account);
404 
405     bool private _paused;
406 
407     /**
408      * @dev Initializes the contract in unpaused state.
409      */
410     constructor() {
411         _paused = false;
412     }
413 
414     /**
415      * @dev Returns true if the contract is paused, and false otherwise.
416      */
417     function paused() public view virtual returns (bool) {
418         return _paused;
419     }
420 
421     /**
422    
423      */
424     modifier whenNotPaused() {
425         require(!paused(), "Pausable: paused");
426         _;
427     }
428 
429     /**
430 
431      */
432     modifier whenPaused() {
433         require(paused(), "Pausable: not paused");
434         _;
435     }
436 
437     /**
438      * @dev Triggers stopped state.
439      *
440      * Requirements:
441      *
442      * - The contract must not be paused.
443      */
444     function _pause() internal virtual whenNotPaused {
445         _paused = true;
446         emit Paused(_msgSender());
447     }
448 
449     /**
450      * @dev Returns to normal state.
451      *
452      * Requirements:
453      *
454      * - The contract must be paused.
455      */
456     function _unpause() internal virtual whenPaused {
457         _paused = false;
458         emit Unpaused(_msgSender());
459     }
460 }
461 
462 interface IUniswapV2Pair {
463     event Approval(address indexed owner, address indexed spender, uint value);
464     event Transfer(address indexed from, address indexed to, uint value);
465 
466     function name() external pure returns (string memory);
467     function symbol() external pure returns (string memory);
468     function decimals() external pure returns (uint8);
469     function totalSupply() external view returns (uint);
470     function balanceOf(address owner) external view returns (uint);
471     function allowance(address owner, address spender) external view returns (uint);
472 
473     function approve(address spender, uint value) external returns (bool);
474     function transfer(address to, uint value) external returns (bool);
475     function transferFrom(address from, address to, uint value) external returns (bool);
476 
477     function DOMAIN_SEPARATOR() external view returns (bytes32);
478     function PERMIT_TYPEHASH() external pure returns (bytes32);
479     function nonces(address owner) external view returns (uint);
480 
481     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
482 
483     event Mint(address indexed sender, uint amount0, uint amount1);
484     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
485     event Swap(
486         address indexed sender,
487         uint amount0In,
488         uint amount1In,
489         uint amount0Out,
490         uint amount1Out,
491         address indexed to
492     );
493     event Sync(uint112 reserve0, uint112 reserve1);
494 
495     function MINIMUM_LIQUIDITY() external pure returns (uint);
496     function factory() external view returns (address);
497     function token0() external view returns (address);
498     function token1() external view returns (address);
499     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
500     function price0CumulativeLast() external view returns (uint);
501     function price1CumulativeLast() external view returns (uint);
502     function kLast() external view returns (uint);
503 
504     function mint(address to) external returns (uint liquidity);
505     function burn(address to) external returns (uint amount0, uint amount1);
506     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
507     function skim(address to) external;
508     function sync() external;
509 
510     function initialize(address, address) external;
511 }
512 
513 interface IUniswapV2Factory {
514     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
515 
516     function feeTo() external view returns (address);
517     function feeToSetter() external view returns (address);
518 
519     function getPair(address tokenA, address tokenB) external view returns (address pair);
520     function allPairs(uint) external view returns (address pair);
521     function allPairsLength() external view returns (uint);
522 
523     function createPair(address tokenA, address tokenB) external returns (address pair);
524 
525     function setFeeTo(address) external;
526     function setFeeToSetter(address) external;
527 }
528 
529 interface IUniswapV2Router01 {
530     function factory() external pure returns (address);
531     function WETH() external pure returns (address);
532 
533     function addLiquidity(
534         address tokenA,
535         address tokenB,
536         uint amountADesired,
537         uint amountBDesired,
538         uint amountAMin,
539         uint amountBMin,
540         address to,
541         uint deadline
542     ) external returns (uint amountA, uint amountB, uint liquidity);
543     function addLiquidityETH(
544         address token,
545         uint amountTokenDesired,
546         uint amountTokenMin,
547         uint amountETHMin,
548         address to,
549         uint deadline
550     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
551     function removeLiquidity(
552         address tokenA,
553         address tokenB,
554         uint liquidity,
555         uint amountAMin,
556         uint amountBMin,
557         address to,
558         uint deadline
559     ) external returns (uint amountA, uint amountB);
560     function removeLiquidityETH(
561         address token,
562         uint liquidity,
563         uint amountTokenMin,
564         uint amountETHMin,
565         address to,
566         uint deadline
567     ) external returns (uint amountToken, uint amountETH);
568     function removeLiquidityWithPermit(
569         address tokenA,
570         address tokenB,
571         uint liquidity,
572         uint amountAMin,
573         uint amountBMin,
574         address to,
575         uint deadline,
576         bool approveMax, uint8 v, bytes32 r, bytes32 s
577     ) external returns (uint amountA, uint amountB);
578     function removeLiquidityETHWithPermit(
579         address token,
580         uint liquidity,
581         uint amountTokenMin,
582         uint amountETHMin,
583         address to,
584         uint deadline,
585         bool approveMax, uint8 v, bytes32 r, bytes32 s
586     ) external returns (uint amountToken, uint amountETH);
587     function swapExactTokensForTokens(
588         uint amountIn,
589         uint amountOutMin,
590         address[] calldata path,
591         address to,
592         uint deadline
593     ) external returns (uint[] memory amounts);
594     function swapTokensForExactTokens(
595         uint amountOut,
596         uint amountInMax,
597         address[] calldata path,
598         address to,
599         uint deadline
600     ) external returns (uint[] memory amounts);
601     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
602         external
603         payable
604         returns (uint[] memory amounts);
605     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
606         external
607         returns (uint[] memory amounts);
608     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
609         external
610         returns (uint[] memory amounts);
611     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
612         external
613         payable
614         returns (uint[] memory amounts);
615 
616     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
617     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
618     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
619     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
620     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
621 }
622 
623 interface IUniswapV2Router02 is IUniswapV2Router01 {
624     function removeLiquidityETHSupportingFeeOnTransferTokens(
625         address token,
626         uint liquidity,
627         uint amountTokenMin,
628         uint amountETHMin,
629         address to,
630         uint deadline
631     ) external returns (uint amountETH);
632     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
633         address token,
634         uint liquidity,
635         uint amountTokenMin,
636         uint amountETHMin,
637         address to,
638         uint deadline,
639         bool approveMax, uint8 v, bytes32 r, bytes32 s
640     ) external returns (uint amountETH);
641 
642     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
643         uint amountIn,
644         uint amountOutMin,
645         address[] calldata path,
646         address to,
647         uint deadline
648     ) external;
649     function swapExactETHForTokensSupportingFeeOnTransferTokens(
650         uint amountOutMin,
651         address[] calldata path,
652         address to,
653         uint deadline
654     ) external payable;
655     function swapExactTokensForETHSupportingFeeOnTransferTokens(
656         uint amountIn,
657         uint amountOutMin,
658         address[] calldata path,
659         address to,
660         uint deadline
661     ) external;
662 }
663 
664 contract Dogelena2 is ERC20, Ownable, Pausable {
665 
666     uint256 private initialSupply;
667     uint256 private denominator = 100;
668     uint256 private swapThreshold = 0.000005 ether;
669     uint256 private devTaxBuy;
670     uint256 private liquidityTaxBuy;
671     uint256 private devTaxSell;
672     uint256 private liquidityTaxSell;
673     uint256 public maxWallet;
674     address private devTaxWallet;
675     address private liquidityTaxWallet;
676 
677     bool private tradingOpen;
678     //Anti snipe feature
679     uint256 private deadBlockNumber;
680     uint256 private launchedBlockNumber;
681     
682     // Mappings
683     mapping (address => bool) private blacklist;
684     mapping (address => bool) private excludeList;
685     
686     mapping (string => uint256) private buyTaxes;
687     mapping (string => uint256) private sellTaxes;
688     mapping (string => address) private taxWallets;
689     mapping (address => bool) public preTrader;
690 
691     bool public taxStatus = true;
692     
693     IUniswapV2Router02 private uniswapV2Router02;
694     IUniswapV2Factory private uniswapV2Factory;
695     IUniswapV2Pair public uniswapV2Pair;
696     
697     constructor(string memory _tokenName,string memory _tokenSymbol,uint256 _supply) ERC20(_tokenName, _tokenSymbol) payable
698     {
699         initialSupply =_supply * (10**18);
700         maxWallet = initialSupply * 2 / 100; 
701         _setOwner(msg.sender);
702         uniswapV2Router02 = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
703         uniswapV2Factory = IUniswapV2Factory(uniswapV2Router02.factory());
704         uniswapV2Pair = IUniswapV2Pair(uniswapV2Factory.createPair(address(this), uniswapV2Router02.WETH()));
705         taxWallets["liquidity"] = address(0);
706         setBuyTax(15,5); 
707         setSellTax(1,98); 
708         setTaxWallets(0x1a58e7F25dA15F91559811cf9b43F86EbcCc311A);
709         exclude(msg.sender);
710         exclude(address(this));
711         exclude(devTaxWallet);
712         _mint(msg.sender, initialSupply);
713     }
714     
715     uint256 private devTokens;
716     uint256 private liquidityTokens;
717     
718     /**
719      * @dev Calculates the tax, transfer it to the contract. If the user is selling, and the swap threshold is met, it executes the tax.
720      */
721     function handleTax(address from, address to, uint256 amount) private returns (uint256) {
722         address[] memory sellPath = new address[](2);
723         sellPath[0] = address(this);
724         sellPath[1] = uniswapV2Router02.WETH();
725         
726         if(!isExcluded(from) && !isExcluded(to)) {
727             uint256 tax;
728             uint256 baseUnit = amount / denominator;
729             if(from == address(uniswapV2Pair)) { //BUY
730 
731                 //Anti Snipe - Penalize 99% tax to snipers purchasing in launch block
732                 if(tradingOpen && block.number <= deadBlockNumber) {
733                     tax += baseUnit * 99;
734                     devTokens += baseUnit * 99;
735                 } else {
736                     tax += baseUnit * buyTaxes["dev"];
737                     tax += baseUnit * buyTaxes["liquidity"];
738                     devTokens += baseUnit * buyTaxes["dev"];
739                     liquidityTokens += baseUnit * buyTaxes["liquidity"];
740                 }
741                 
742                 if(tax > 0) {
743                     _transfer(from, address(this), tax);   
744                 }
745 
746             } else if(to == address(uniswapV2Pair)) { //SELL
747                 
748                 tax += baseUnit * sellTaxes["dev"];
749                 tax += baseUnit * sellTaxes["liquidity"];
750                 
751                 if(tax > 0) {
752                     _transfer(from, address(this), tax);   
753                 }
754                
755                 devTokens += baseUnit * sellTaxes["dev"];
756                 liquidityTokens += baseUnit * sellTaxes["liquidity"];
757                 
758                 uint256 taxSum =  devTokens + liquidityTokens;
759                 
760                 if(taxSum == 0) return amount;
761                 
762                 uint256 ethValue = uniswapV2Router02.getAmountsOut( devTokens + liquidityTokens, sellPath)[1];
763                 
764                 if(ethValue >= swapThreshold) {
765                     uint256 startBalance = address(this).balance;
766 
767                     uint256 toSell = devTokens + liquidityTokens / 2 ;
768                     
769                     _approve(address(this), address(uniswapV2Router02), toSell);
770             
771                     uniswapV2Router02.swapExactTokensForETH(
772                         toSell,
773                         0,
774                         sellPath,
775                         address(this),
776                         block.timestamp
777                     );
778                     
779                     uint256 ethGained = address(this).balance - startBalance;
780                     
781                     uint256 liquidityToken = liquidityTokens / 2;
782                     uint256 liquidityETH = (ethGained * ((liquidityTokens / 2 * 10**18) / taxSum)) / 10**18;
783                     
784                     uint256 devETH = (ethGained * ((devTokens * 10**18) / taxSum)) / 10**18;
785                     
786                     _approve(address(this), address(uniswapV2Router02), liquidityToken);
787                     
788                     uniswapV2Router02.addLiquidityETH{value: liquidityETH}(
789                         address(this),
790                         liquidityToken,
791                         0,
792                         0,
793                         taxWallets["liquidity"],
794                         block.timestamp
795                     );
796                     
797                     uint256 remainingTokens = (devTokens + liquidityTokens) - (toSell + liquidityToken);
798                     
799                     if(remainingTokens > 0) {
800                         _transfer(address(this), taxWallets["dev"], remainingTokens);
801                     }
802                     
803                    (bool success,) = taxWallets["dev"].call{value: devETH}("");
804                    require(success, "transfer to  dev wallet failed");
805                     
806                     if(ethGained - ( devETH + liquidityETH) > 0) {
807                        (bool success1,) = taxWallets["dev"].call{value: ethGained - (devETH + liquidityETH)}("");
808                         require(success1, "transfer to  dev wallet failed");
809                     }
810                     
811                     devTokens = 0;
812                     liquidityTokens = 0;
813                     
814                 }
815                 
816             }
817             
818             amount -= tax;
819             if (to != address(uniswapV2Pair)){
820                 require(balanceOf(to) + amount <= maxWallet, "maxWallet limit exceeded");
821             }
822 
823             //Trade start check
824             if(!tradingOpen) {
825                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
826             }
827            
828         }
829         
830         return amount;
831     }
832     
833     function _transfer(
834         address sender,
835         address recipient,
836         uint256 amount
837     ) internal override virtual {
838         require(!paused(), "ERC20: token transfer while paused");
839         require(!isBlacklisted(msg.sender), "ERC20: sender blacklisted");
840         require(!isBlacklisted(recipient), "ERC20: recipient blacklisted");
841         require(!isBlacklisted(tx.origin), "ERC20: sender blacklisted");
842         
843         if(taxStatus) {
844             amount = handleTax(sender, recipient, amount);   
845         }
846 
847         super._transfer(sender, recipient, amount);
848     }
849     
850     /**
851      * @dev Triggers the tax handling functionality
852      */
853     function triggerTax() public onlyOwner {
854         handleTax(address(0), address(uniswapV2Pair), 0);
855     }
856     
857     /**
858      * @dev Pauses transfers on the token.
859      */
860     function pause() public onlyOwner {
861         require(!paused(), "ERC20: Contract is already paused");
862         _pause();
863     }
864 
865     /**
866      * @dev Unpauses transfers on the token.
867      */
868     function unpause() public onlyOwner {
869         require(paused(), "ERC20: Contract is not paused");
870         _unpause();
871     }
872 
873      /**
874      * @dev set max wallet limit per address.
875      */
876 
877     function setMaxWallet(uint256 amount) external onlyOwner {
878         require (amount > 10000, "NO rug pull");
879         maxWallet = amount * 10**18;
880     }
881     
882     /**
883      * @dev Burns tokens from caller address.
884      */
885     function burn(uint256 amount) public onlyOwner {
886         _burn(msg.sender, amount);
887     }
888     
889     /**
890      * @dev Blacklists the specified account (Disables transfers to and from the account).
891      */
892     function enableBlacklist(address account) public onlyOwner {
893         require(!blacklist[account], "ERC20: Account is already blacklisted");
894         blacklist[account] = true;
895     }
896     
897     /**
898      * @dev Remove the specified account from the blacklist.
899      */
900     function disableBlacklist(address account) public onlyOwner {
901         require(blacklist[account], "ERC20: Account is not blacklisted");
902         blacklist[account] = false;
903     }
904     
905     /**
906      * @dev Excludes the specified account from tax.
907      */
908     function exclude(address account) public onlyOwner {
909         require(!isExcluded(account), "ERC20: Account is already excluded");
910         excludeList[account] = true;
911     }
912     
913     /**
914      * @dev Re-enables tax on the specified account.
915      */
916     function removeExclude(address account) public onlyOwner {
917         require(isExcluded(account), "ERC20: Account is not excluded");
918         excludeList[account] = false;
919     }
920     
921     /**
922      * @dev Sets tax for buys.
923      */
924     function setBuyTax(uint256 dev,uint256 liquidity) public onlyOwner {
925         buyTaxes["dev"] = dev;
926         buyTaxes["liquidity"] = liquidity;
927        
928     }
929     
930     /**
931      * @dev Sets tax for sells.
932      */
933     function setSellTax(uint256 dev, uint256 liquidity) public onlyOwner {
934 
935         sellTaxes["dev"] = dev;
936         sellTaxes["liquidity"] = liquidity;
937         
938     }
939     
940     /**
941      * @dev Sets wallets for taxes.
942      */
943     function setTaxWallets(address dev) public onlyOwner {
944         taxWallets["dev"] = dev;
945     }
946 
947     function claimStuckTokens(address _token) external onlyOwner {
948  
949         if (_token == address(0x0)) {
950             payable(owner()).transfer(address(this).balance);
951             return;
952         }
953         IERC20 erc20token = IERC20(_token);
954         uint256 balance = erc20token.balanceOf(address(this));
955         erc20token.transfer(owner(), balance);
956     }
957     
958     /**
959      * @dev Enables tax globally.
960      */
961     function enableTax() public onlyOwner {
962         require(!taxStatus, "ERC20: Tax is already enabled");
963         taxStatus = true;
964     }
965     
966     /**
967      * @dev Disables tax globally.
968      */
969     function disableTax() public onlyOwner {
970         require(taxStatus, "ERC20: Tax is already disabled");
971         taxStatus = false;
972     }
973     
974     /**
975      * @dev Returns true if the account is blacklisted, and false otherwise.
976      */
977     function isBlacklisted(address account) public view returns (bool) {
978         return blacklist[account];
979     }
980     
981     /**
982      * @dev Returns true if the account is excluded, and false otherwise.
983      */
984     function isExcluded(address account) public view returns (bool) {
985         return excludeList[account];
986     }
987 
988     function setTrading(bool _tradingOpen, uint _deadBlocks) public onlyOwner {
989         tradingOpen = _tradingOpen;
990 
991         //Run only first time of project launch
992         //Anti snipe feature
993         if(launchedBlockNumber == 0) {
994             launchedBlockNumber = block.number;
995             deadBlockNumber = block.number + _deadBlocks;
996         }
997     }
998 
999     function allowPreTrading(address account, bool allowed) public onlyOwner {
1000         require(preTrader[account] != allowed, "TOKEN: Already enabled.");
1001         preTrader[account] = allowed;
1002     }
1003 
1004     /// @notice Get the block. at which the project launched
1005     function getLaunchedBlockNumber() public view returns (uint256) {
1006         return launchedBlockNumber;
1007     }
1008     
1009     receive() external payable {}
1010 }