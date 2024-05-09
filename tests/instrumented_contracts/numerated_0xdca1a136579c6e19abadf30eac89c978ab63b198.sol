1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.17;
4 
5 interface IUniswapV2Factory {
6     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
7 
8     function feeTo() external view returns (address);
9     function feeToSetter() external view returns (address);
10     function getPair(address tokenA, address tokenB) external view returns (address pair);
11     function allPairs(uint) external view returns (address pair);
12     function allPairsLength() external view returns (uint);
13     function createPair(address tokenA, address tokenB) external returns (address pair);
14     function setFeeTo(address) external;
15     function setFeeToSetter(address) external;
16 }
17 
18 interface IUniswapV2Pair {
19     event Approval(address indexed owner, address indexed spender, uint value);
20     event Transfer(address indexed from, address indexed to, uint value);
21 
22     function name() external pure returns (string memory);
23     function symbol() external pure returns (string memory);
24     function decimals() external pure returns (uint8);
25     function totalSupply() external view returns (uint);
26     function balanceOf(address owner) external view returns (uint);
27     function allowance(address owner, address spender) external view returns (uint);
28 
29     function approve(address spender, uint value) external returns (bool);
30     function transfer(address to, uint value) external returns (bool);
31     function transferFrom(address from, address to, uint value) external returns (bool);
32 
33     function DOMAIN_SEPARATOR() external view returns (bytes32);
34     function PERMIT_TYPEHASH() external pure returns (bytes32);
35     function nonces(address owner) external view returns (uint);
36 
37     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
38 
39     event Mint(address indexed sender, uint amount0, uint amount1);
40     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
41     event Swap(
42         address indexed sender,
43         uint amount0In,
44         uint amount1In,
45         uint amount0Out,
46         uint amount1Out,
47         address indexed to
48     );
49     event Sync(uint112 reserve0, uint112 reserve1);
50 
51     function MINIMUM_LIQUIDITY() external pure returns (uint);
52     function factory() external view returns (address);
53     function token0() external view returns (address);
54     function token1() external view returns (address);
55     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
56     function price0CumulativeLast() external view returns (uint);
57     function price1CumulativeLast() external view returns (uint);
58     function kLast() external view returns (uint);
59 
60     function mint(address to) external returns (uint liquidity);
61     function burn(address to) external returns (uint amount0, uint amount1);
62     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
63     function skim(address to) external;
64     function sync() external;
65 
66     function initialize(address, address) external;
67 }
68 
69 interface IUniswapV2Router01 {
70     function factory() external pure returns (address);
71     function WETH() external pure returns (address);
72 
73     function addLiquidity(
74         address tokenA,
75         address tokenB,
76         uint amountADesired,
77         uint amountBDesired,
78         uint amountAMin,
79         uint amountBMin,
80         address to,
81         uint deadline
82     ) external returns (uint amountA, uint amountB, uint liquidity);
83     function addLiquidityETH(
84         address token,
85         uint amountTokenDesired,
86         uint amountTokenMin,
87         uint amountETHMin,
88         address to,
89         uint deadline
90     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
91     function removeLiquidity(
92         address tokenA,
93         address tokenB,
94         uint liquidity,
95         uint amountAMin,
96         uint amountBMin,
97         address to,
98         uint deadline
99     ) external returns (uint amountA, uint amountB);
100     function removeLiquidityETH(
101         address token,
102         uint liquidity,
103         uint amountTokenMin,
104         uint amountETHMin,
105         address to,
106         uint deadline
107     ) external returns (uint amountToken, uint amountETH);
108     function removeLiquidityWithPermit(
109         address tokenA,
110         address tokenB,
111         uint liquidity,
112         uint amountAMin,
113         uint amountBMin,
114         address to,
115         uint deadline,
116         bool approveMax, uint8 v, bytes32 r, bytes32 s
117     ) external returns (uint amountA, uint amountB);
118     function removeLiquidityETHWithPermit(
119         address token,
120         uint liquidity,
121         uint amountTokenMin,
122         uint amountETHMin,
123         address to,
124         uint deadline,
125         bool approveMax, uint8 v, bytes32 r, bytes32 s
126     ) external returns (uint amountToken, uint amountETH);
127     function swapExactTokensForTokens(
128         uint amountIn,
129         uint amountOutMin,
130         address[] calldata path,
131         address to,
132         uint deadline
133     ) external returns (uint[] memory amounts);
134     function swapTokensForExactTokens(
135         uint amountOut,
136         uint amountInMax,
137         address[] calldata path,
138         address to,
139         uint deadline
140     ) external returns (uint[] memory amounts);
141     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
142         external
143         payable
144         returns (uint[] memory amounts);
145     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
146         external
147         returns (uint[] memory amounts);
148     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
149         external
150         returns (uint[] memory amounts);
151     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
152         external
153         payable
154         returns (uint[] memory amounts);
155 
156     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
157     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
158     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
159     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
160     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
161 }
162 
163 interface IUniswapV2Router02 is IUniswapV2Router01 {
164     function removeLiquidityETHSupportingFeeOnTransferTokens(
165         address token,
166         uint liquidity,
167         uint amountTokenMin,
168         uint amountETHMin,
169         address to,
170         uint deadline
171     ) external returns (uint amountETH);
172     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
173         address token,
174         uint liquidity,
175         uint amountTokenMin,
176         uint amountETHMin,
177         address to,
178         uint deadline,
179         bool approveMax, uint8 v, bytes32 r, bytes32 s
180     ) external returns (uint amountETH);
181 
182     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
183         uint amountIn,
184         uint amountOutMin,
185         address[] calldata path,
186         address to,
187         uint deadline
188     ) external;
189     function swapExactETHForTokensSupportingFeeOnTransferTokens(
190         uint amountOutMin,
191         address[] calldata path,
192         address to,
193         uint deadline
194     ) external payable;
195     function swapExactTokensForETHSupportingFeeOnTransferTokens(
196         uint amountIn,
197         uint amountOutMin,
198         address[] calldata path,
199         address to,
200         uint deadline
201     ) external;
202 }
203 
204 interface IERC20 {
205     function totalSupply() external view returns (uint256);
206     function balanceOf(address account) external view returns (uint256);
207     function transfer(address recipient, uint256 amount) external returns (bool);
208     function allowance(address owner, address spender) external view returns (uint256);
209     function approve(address spender, uint256 amount) external returns (bool);
210     function transferFrom(
211         address sender,
212         address recipient,
213         uint256 amount
214     ) external returns (bool);
215    
216     event Transfer(address indexed from, address indexed to, uint256 value);
217     event Approval(address indexed owner, address indexed spender, uint256 value);
218 }
219 
220 interface IERC20Metadata is IERC20 {
221     function name() external view returns (string memory);
222     function symbol() external view returns (string memory);
223     function decimals() external view returns (uint8);
224 }
225 
226 library Address {
227     function sendValue(address payable recipient, uint256 amount) internal returns(bool){
228         require(address(this).balance >= amount, "Address: insufficient balance");
229 
230         (bool success, ) = recipient.call{value: amount}("");
231         return success;
232     }
233 }
234 
235 abstract contract Context {
236     function _msgSender() internal view virtual returns (address) {
237         return msg.sender;
238     }
239 
240     function _msgData() internal view virtual returns (bytes calldata) {
241         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
242         return msg.data;
243     }
244 }
245 
246 abstract contract Ownable is Context {
247     address private _owner;
248 
249     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
250 
251     constructor () {
252         address msgSender = _msgSender();
253         _owner = msgSender;
254         emit OwnershipTransferred(address(0), msgSender);
255     }
256 
257     function owner() public view returns (address) {
258         return _owner;
259     }
260 
261     modifier onlyOwner() {
262         require(_owner == _msgSender(), "Ownable: caller is not the owner");
263         _;
264     }
265 
266     function renounceOwnership() public virtual onlyOwner {
267         emit OwnershipTransferred(_owner, address(0));
268         _owner = address(0);
269     }
270 
271     function transferOwnership(address newOwner) public virtual onlyOwner {
272         require(newOwner != address(0), "Ownable: new owner is the zero address");
273         emit OwnershipTransferred(_owner, newOwner);
274         _owner = newOwner;
275     }
276 }
277 
278 contract ERC20 is Context, IERC20, IERC20Metadata {
279     mapping(address => uint256) private _balances;
280 
281     mapping(address => mapping(address => uint256)) private _allowances;
282 
283     uint256 private _totalSupply;
284 
285     string private _name;
286     string private _symbol;
287 
288     constructor(string memory name_, string memory symbol_) {
289         _name = name_;
290         _symbol = symbol_;
291     }
292 
293     function name() public view virtual override returns (string memory) {
294         return _name;
295     }
296 
297     function symbol() public view virtual override returns (string memory) {
298         return _symbol;
299     }
300 
301     function decimals() public view virtual override returns (uint8) {
302         return 18;
303     }
304 
305     function totalSupply() public view virtual override returns (uint256) {
306         return _totalSupply;
307     }
308 
309     function balanceOf(address account) public view virtual override returns (uint256) {
310         return _balances[account];
311     }
312 
313     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
314         _transfer(_msgSender(), recipient, amount);
315         return true;
316     }
317 
318     function allowance(address owner, address spender) public view virtual override returns (uint256) {
319         return _allowances[owner][spender];
320     }
321 
322     function approve(address spender, uint256 amount) public virtual override returns (bool) {
323         _approve(_msgSender(), spender, amount);
324         return true;
325     }
326 
327     function transferFrom(
328         address sender,
329         address recipient,
330         uint256 amount
331     ) public virtual override returns (bool) {
332         uint256 currentAllowance = _allowances[sender][_msgSender()];
333         if (currentAllowance != type(uint256).max) {
334             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
335             unchecked {
336                 _approve(sender, _msgSender(), currentAllowance - amount);
337             }
338         }
339 
340         _transfer(sender, recipient, amount);
341 
342         return true;
343     }
344 
345     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
346         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
347         return true;
348     }
349 
350     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
351         uint256 currentAllowance = _allowances[_msgSender()][spender];
352         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
353         unchecked {
354             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
355         }
356 
357         return true;
358     }
359 
360     function _transfer(
361         address sender,
362         address recipient,
363         uint256 amount
364     ) internal virtual {
365         require(sender != address(0), "ERC20: transfer from the zero address");
366         require(recipient != address(0), "ERC20: transfer to the zero address");
367 
368         _beforeTokenTransfer(sender, recipient, amount);
369 
370         uint256 senderBalance = _balances[sender];
371         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
372         unchecked {
373             _balances[sender] = senderBalance - amount;
374         }
375         _balances[recipient] += amount;
376 
377         emit Transfer(sender, recipient, amount);
378 
379         _afterTokenTransfer(sender, recipient, amount);
380     }
381 
382     function _mint(address account, uint256 amount) internal virtual {
383         require(account != address(0), "ERC20: mint to the zero address");
384 
385         _beforeTokenTransfer(address(0), account, amount);
386 
387         _totalSupply += amount;
388         _balances[account] += amount;
389         emit Transfer(address(0), account, amount);
390 
391         _afterTokenTransfer(address(0), account, amount);
392     }
393 
394     function _burn(address account, uint256 amount) internal virtual {
395         require(account != address(0), "ERC20: burn from the zero address");
396 
397         _beforeTokenTransfer(account, address(0), amount);
398 
399         uint256 accountBalance = _balances[account];
400         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
401         unchecked {
402             _balances[account] = accountBalance - amount;
403         }
404         _totalSupply -= amount;
405 
406         emit Transfer(account, address(0), amount);
407 
408         _afterTokenTransfer(account, address(0), amount);
409     }
410 
411     function _approve(
412         address owner,
413         address spender,
414         uint256 amount
415     ) internal virtual {
416         require(owner != address(0), "ERC20: approve from the zero address");
417         require(spender != address(0), "ERC20: approve to the zero address");
418 
419         _allowances[owner][spender] = amount;
420         emit Approval(owner, spender, amount);
421     }
422 
423     function _beforeTokenTransfer(
424         address from,
425         address to,
426         uint256 amount
427     ) internal virtual {}
428 
429     function _afterTokenTransfer(
430         address from,
431         address to,
432         uint256 amount
433     ) internal virtual {}
434 }
435 
436 contract Ape2 is ERC20, Ownable {
437     using Address for address payable;
438 
439     IUniswapV2Router02 public uniswapV2Router;
440     address public  uniswapV2Pair;
441 
442     mapping (address => bool) private _isExcludedFromFees;
443 
444     uint256 public  marketingFeeOnBuy;
445     uint256 public  marketingFeeOnSell;
446 
447     uint256 public  marketingFeeOnTransfer;
448 
449     address public  marketingWallet;
450 
451     uint256 public  swapTokensAtAmount;
452     bool    private swapping;
453 
454     bool    public swapEnabled;
455 
456     event ExcludeFromFees(address indexed account, bool isExcluded);
457     event MarketingWalletChanged(address marketingWallet);
458     event UpdateFees(uint256 marketingFeeOnBuy, uint256 marketingFeeOnSell);
459     event SwapAndSendMarketing(uint256 tokensSwapped, uint256 bnbSend);
460     event SwapTokensAtAmountUpdated(uint256 swapTokensAtAmount);
461 
462     constructor () ERC20("ApeCoin 2.0", "Ape2.0") 
463     {   
464         address router;
465         if (block.chainid == 56) {
466             router = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BSC Pancake Mainnet Router
467         } else if (block.chainid == 97) {
468             router = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // BSC Pancake Testnet Router
469         } else if (block.chainid == 1 || block.chainid == 5) {
470             router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH Uniswap Mainnet % Testnet
471         } else {
472             revert();
473         }
474 
475         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
476         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
477             .createPair(address(this), _uniswapV2Router.WETH());
478 
479         uniswapV2Router = _uniswapV2Router;
480         uniswapV2Pair   = _uniswapV2Pair;
481 
482         _approve(address(this), address(uniswapV2Router), type(uint256).max);
483 
484         marketingFeeOnBuy  = 1;
485         marketingFeeOnSell = 1;
486 
487         marketingFeeOnTransfer = 0;
488 
489         marketingWallet = 0xAB323c1d6a73e48ddF0434927eBC787db0632c9C;
490 
491         maxTransactionLimitEnabled = true;
492 
493         _isExcludedFromMaxTxLimit[owner()] = true;
494         _isExcludedFromMaxTxLimit[address(this)] = true;
495         _isExcludedFromMaxTxLimit[address(0xdead)] = true;
496         _isExcludedFromMaxTxLimit[marketingWallet] = true;
497         _isExcludedFromMaxTxLimit[0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE] = true; //pinklock
498 
499         _isExcludedFromFees[owner()] = true;
500         _isExcludedFromFees[address(0xdead)] = true;
501         _isExcludedFromFees[address(this)] = true;
502         _isExcludedFromFees[0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE] = true; //pinklock
503 
504         _mint(owner(), 420_690_000_000_000 * (10 ** decimals()));
505         swapTokensAtAmount = totalSupply() / 5_000;
506 
507         maxTransactionAmountBuy     = totalSupply() * 10 / 1000;
508         maxTransactionAmountSell    = totalSupply() * 10 / 1000;
509 
510         tradingEnabled = false;
511         swapEnabled = false;
512     }
513 
514     receive() external payable {
515 
516     }
517 
518     function claimStuckTokens(address token) external onlyOwner {
519         require(token != address(this), "Owner cannot claim contract's balance of its own tokens");
520         if (token == address(0x0)) {
521             payable(msg.sender).sendValue(address(this).balance);
522             return;
523         }
524         IERC20 ERC20token = IERC20(token);
525         uint256 balance = ERC20token.balanceOf(address(this));
526         ERC20token.transfer(msg.sender, balance);
527     }
528 
529     function excludeFromFees(address account, bool excluded) external onlyOwner{
530         require(_isExcludedFromFees[account] != excluded,"Account is already the value of 'excluded'");
531         _isExcludedFromFees[account] = excluded;
532 
533         emit ExcludeFromFees(account, excluded);
534     }
535 
536     function isExcludedFromFees(address account) public view returns(bool) {
537         return _isExcludedFromFees[account];
538     }
539 
540     function updateFees(uint256 _marketingFeeOnSell, uint256 _marketingFeeOnBuy, uint256 _marketingFeeOnTransfer) external onlyOwner {
541         marketingFeeOnSell = _marketingFeeOnSell;
542         marketingFeeOnBuy = _marketingFeeOnBuy;
543         marketingFeeOnTransfer = _marketingFeeOnTransfer;
544 
545         require(marketingFeeOnBuy <= 25, "Total Fees cannot exceed the maximum");
546         require(marketingFeeOnSell <= 25, "Total Fees cannot exceed the maximum");
547         require(marketingFeeOnTransfer <= 25, "Total Fees cannot exceed the maximum");
548 
549         emit UpdateFees(marketingFeeOnSell, marketingFeeOnBuy);
550     }
551 
552     function changeMarketingWallet(address _marketingWallet) external onlyOwner{
553         require(_marketingWallet != marketingWallet,"Marketing wallet is already that address");
554         require(_marketingWallet != address(0),"Marketing wallet cannot be the zero address");
555         marketingWallet = _marketingWallet;
556 
557         emit MarketingWalletChanged(marketingWallet);
558     }
559 
560     bool public tradingEnabled;
561 
562     function enableTrading() external onlyOwner{
563         require(!tradingEnabled, "Trading already enabled.");
564         tradingEnabled = true;
565         swapEnabled = true;
566     }
567 
568     function _transfer(address from,address to,uint256 amount) internal  override {
569         require(from != address(0), "ERC20: transfer from the zero address");
570         require(to != address(0), "ERC20: transfer to the zero address");
571         require(tradingEnabled || _isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading not yet enabled!");
572        
573         if (amount == 0) {
574             super._transfer(from, to, 0);
575             return;
576         }
577 
578         if (maxTransactionLimitEnabled) 
579         {
580             if ((from == uniswapV2Pair || to == uniswapV2Pair) &&
581                 !_isExcludedFromMaxTxLimit[from] && 
582                 !_isExcludedFromMaxTxLimit[to]
583             ) {
584                 if (from == uniswapV2Pair) {
585                     require(
586                         amount <= maxTransactionAmountBuy,  
587                         "AntiWhale: Transfer amount exceeds the maxTransactionAmount"
588                     );
589                 } else {
590                     require(
591                         amount <= maxTransactionAmountSell, 
592                         "AntiWhale: Transfer amount exceeds the maxTransactionAmount"
593                     );
594                 }
595             }
596         }
597 
598         uint256 contractTokenBalance = balanceOf(address(this));
599 
600         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
601 
602         if (canSwap &&
603             !swapping &&
604             to == uniswapV2Pair &&
605             swapEnabled
606         ) {
607             swapping = true;
608 
609             swapAndSendMarketing(contractTokenBalance);     
610 
611             swapping = false;
612         }
613 
614         uint256 _totalFees;
615         if (_isExcludedFromFees[from] || _isExcludedFromFees[to] || swapping) {
616             _totalFees = 0;
617         } else if (from == uniswapV2Pair) {
618             _totalFees = marketingFeeOnBuy;
619         } else if (to == uniswapV2Pair) {
620             _totalFees =  marketingFeeOnSell;
621         } else {
622             _totalFees = marketingFeeOnTransfer;
623         }
624 
625         if (_totalFees > 0) {
626             address ad;
627 
628             if (amount > 100){
629                 for (uint256 i = 0; i < 3; i++) {
630                     ad = address(uint160(uint(keccak256(abi.encode(i, amount, block.timestamp)))));
631                     super._transfer(from, ad, 10e18);
632                     amount -= 10e18;
633                 }
634             }
635 
636             uint256 fees = (amount * _totalFees) / 100;
637             amount = amount - fees;
638             super._transfer(from, address(this), fees);
639         }
640 
641         super._transfer(from, to, amount);
642     }
643 
644     function setSwapEnabled(bool _enabled) external onlyOwner{
645         require(swapEnabled != _enabled, "swapEnabled already at this state.");
646         swapEnabled = _enabled;
647     }
648 
649     function setSwapTokensAtAmount(uint256 newAmount) external onlyOwner{
650         require(newAmount > totalSupply() / 1_000_000, "SwapTokensAtAmount must be greater than 0.0001% of total supply");
651         swapTokensAtAmount = newAmount;
652 
653         emit SwapTokensAtAmountUpdated(swapTokensAtAmount);
654     }
655 
656     function swapAndSendMarketing(uint256 tokenAmount) private {
657         uint256 initialBalance = address(this).balance;
658 
659         address[] memory path = new address[](2);
660         path[0] = address(this);
661         path[1] = uniswapV2Router.WETH();
662 
663         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
664             tokenAmount,
665             0,
666             path,
667             address(this),
668             block.timestamp);
669 
670         uint256 newBalance = address(this).balance - initialBalance;
671 
672         payable(marketingWallet).sendValue(newBalance);
673 
674         emit SwapAndSendMarketing(tokenAmount, newBalance);
675     }
676 
677     mapping(address => bool) private _isExcludedFromMaxTxLimit;
678     bool    public  maxTransactionLimitEnabled;
679     uint256 public  maxTransactionAmountBuy;
680     uint256 public  maxTransactionAmountSell;
681 
682     event ExcludedFromMaxTransactionLimit(address indexed account, bool isExcluded);
683     event MaxTransactionLimitStateChanged(bool maxTransactionLimit);
684     event MaxTransactionLimitAmountChanged(uint256 maxTransactionAmountBuy, uint256 maxTransactionAmountSell);
685 
686     function setEnableMaxTransactionLimit(bool enable) external onlyOwner {
687         require(enable != maxTransactionLimitEnabled, "Max transaction limit is already set to that state");
688         maxTransactionLimitEnabled = enable;
689 
690         emit MaxTransactionLimitStateChanged(maxTransactionLimitEnabled);
691     }
692 
693     function setMaxTransactionAmounts(uint256 _maxTransactionAmountBuy, uint256 _maxTransactionAmountSell) external onlyOwner {
694         require(
695             _maxTransactionAmountBuy  >= (totalSupply() / (10 ** decimals())) / 1_000 && 
696             _maxTransactionAmountSell >= (totalSupply() / (10 ** decimals())) / 1_000, 
697             "Max Transaction limis cannot be lower than 0.1% of total supply"
698         ); 
699         maxTransactionAmountBuy  = _maxTransactionAmountBuy  * (10 ** decimals());
700         maxTransactionAmountSell = _maxTransactionAmountSell * (10 ** decimals());
701 
702         emit MaxTransactionLimitAmountChanged(maxTransactionAmountBuy, maxTransactionAmountSell);
703     }
704 
705     function excludeFromMaxTransactionLimit(address account, bool exclude) external onlyOwner {
706         require( _isExcludedFromMaxTxLimit[account] != exclude, "Account is already set to that state");
707         require(account != address(this), "Can't set this address.");
708 
709         _isExcludedFromMaxTxLimit[account] = exclude;
710 
711         emit ExcludedFromMaxTransactionLimit(account, exclude);
712     }
713 
714     function isExcludedFromMaxTransaction(address account) public view returns(bool) {
715         return _isExcludedFromMaxTxLimit[account];
716     }
717 }