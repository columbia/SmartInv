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
436 contract FLORKY is ERC20, Ownable {
437     using Address for address payable;
438 
439     IUniswapV2Router02 public uniswapV2Router;
440     address public  uniswapV2Pair;
441 
442     mapping (address => bool) private _isExcludedFromFees;
443 
444     uint256 public  liquidityFeeOnBuy;
445     uint256 public  liquidityFeeOnSell;
446 
447     uint256 public  marketingFeeOnBuy;
448     uint256 public  marketingFeeOnSell;
449 
450     uint256 private _totalFeesOnBuy;
451     uint256 private _totalFeesOnSell;
452 
453     address public  marketingWallet;
454 
455     uint256 public  swapTokensAtAmount;
456     bool    private swapping;
457 
458     bool    public swapEnabled;
459 
460     uint256 public launchTime;
461     bool    public ladderTaxEnabled;
462 
463     event ExcludeFromFees(address indexed account, bool isExcluded);
464     event MarketingWalletChanged(address marketingWallet);
465     event UpdateBuyFees(uint256 liquidityFeeOnBuy, uint256 marketingFeeOnBuy);
466     event UpdateSellFees(uint256 liquidityFeeOnSell, uint256 marketingFeeOnSell);
467     event UpdateWalletToWalletTransferFee(uint256 walletToWalletTransferFee);
468     event SwapAndLiquify(uint256 tokensSwapped,uint256 bnbReceived,uint256 tokensIntoLiqudity);
469     event SwapAndSendMarketing(uint256 tokensSwapped, uint256 bnbSend);
470     event SwapTokensAtAmountUpdated(uint256 swapTokensAtAmount);
471 
472     constructor () ERC20("Florky", "FLORKY") 
473     {   
474         address router;
475         if (block.chainid == 56) {
476             router = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BSC Pancake Mainnet Router
477         } else if (block.chainid == 97) {
478             router = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // BSC Pancake Testnet Router
479         } else if (block.chainid == 1 || block.chainid == 5) {
480             router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH Uniswap Mainnet % Testnet
481         } else {
482             revert();
483         }
484 
485         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
486         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
487             .createPair(address(this), _uniswapV2Router.WETH());
488 
489         uniswapV2Router = _uniswapV2Router;
490         uniswapV2Pair   = _uniswapV2Pair;
491 
492         _approve(address(this), address(uniswapV2Router), type(uint256).max);
493 
494         liquidityFeeOnBuy  = 0;
495         liquidityFeeOnSell = 0;
496 
497         marketingFeeOnBuy  = 4000;
498         marketingFeeOnSell = 4000;
499 
500         _totalFeesOnBuy    = liquidityFeeOnBuy  + marketingFeeOnBuy;
501         _totalFeesOnSell   = liquidityFeeOnSell + marketingFeeOnSell;
502 
503         marketingWallet = 0xabf8961DfB78c9204D0e446E74d2C94C390db091;
504 
505         maxTransactionLimitEnabled = true;
506 
507         _isExcludedFromMaxTxLimit[owner()] = true;
508         _isExcludedFromMaxTxLimit[address(this)] = true;
509         _isExcludedFromMaxTxLimit[address(0xdead)] = true;
510         _isExcludedFromMaxTxLimit[marketingWallet] = true;
511         _isExcludedFromMaxTxLimit[0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE] = true; //pinklock
512 
513         maxWalletLimitEnabled = true;
514 
515         _isExcludedFromMaxWalletLimit[owner()] = true;
516         _isExcludedFromMaxWalletLimit[address(this)] = true;
517         _isExcludedFromMaxWalletLimit[address(0xdead)] = true;
518         _isExcludedFromMaxWalletLimit[marketingWallet] = true;
519         _isExcludedFromMaxWalletLimit[0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE] = true; //pinklock
520 
521         _isExcludedFromFees[owner()] = true;
522         _isExcludedFromFees[address(0xdead)] = true;
523         _isExcludedFromFees[address(this)] = true;
524         _isExcludedFromFees[0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE] = true; //pinklock
525 
526         _mint(owner(), 369_000_000_000 * (10 ** decimals()));
527         swapTokensAtAmount = totalSupply() / 5_000;
528 	
529         maxTransactionAmountBuy     = totalSupply() * 30 / 1000;
530         maxTransactionAmountSell    = totalSupply() * 30 / 1000;
531 	
532         maxWalletAmount             = totalSupply() * 30 / 1000;
533 
534         tradingEnabled = false;
535         swapEnabled = false;
536     }
537 
538     receive() external payable {
539 
540   	}
541 
542     function claimStuckTokens(address token) external onlyOwner {
543         require(token != address(this), "Owner cannot claim contract's balance of its own tokens");
544         if (token == address(0x0)) {
545             payable(msg.sender).sendValue(address(this).balance);
546             return;
547         }
548         IERC20 ERC20token = IERC20(token);
549         uint256 balance = ERC20token.balanceOf(address(this));
550         ERC20token.transfer(msg.sender, balance);
551     }
552 
553     function excludeFromFees(address account, bool excluded) external onlyOwner{
554         require(_isExcludedFromFees[account] != excluded,"Account is already the value of 'excluded'");
555         _isExcludedFromFees[account] = excluded;
556 
557         emit ExcludeFromFees(account, excluded);
558     }
559 
560     function isExcludedFromFees(address account) public view returns(bool) {
561         return _isExcludedFromFees[account];
562     }
563 
564     function updateBuyFees(uint256 _liquidityFeeOnBuy, uint256 _marketingFeeOnBuy) external onlyOwner {
565         liquidityFeeOnBuy = _liquidityFeeOnBuy;
566         marketingFeeOnBuy = _marketingFeeOnBuy;
567 
568         _totalFeesOnBuy   = liquidityFeeOnBuy + marketingFeeOnBuy;
569 
570         require(_totalFeesOnBuy + _totalFeesOnSell <= 40000, "Total Fees cannot exceed the maximum");
571 
572         emit UpdateBuyFees(liquidityFeeOnBuy, marketingFeeOnBuy);
573     }
574 
575     function updateSellFees(uint256 _liquidityFeeOnSell, uint256 _marketingFeeOnSell) external onlyOwner {
576         liquidityFeeOnSell = _liquidityFeeOnSell;
577         marketingFeeOnSell = _marketingFeeOnSell;
578 
579         _totalFeesOnSell   = liquidityFeeOnSell + marketingFeeOnSell;
580 
581         require(_totalFeesOnBuy + _totalFeesOnSell <= 40000, "Total Fees cannot exceed the maximum");
582 
583         emit UpdateSellFees(liquidityFeeOnSell, marketingFeeOnSell);
584     }
585 
586     function serLadderTaxEnabled(bool _enabled) external onlyOwner {
587         ladderTaxEnabled = _enabled;
588     }
589 
590     function changeMarketingWallet(address _marketingWallet) external onlyOwner{
591         require(_marketingWallet != marketingWallet,"Marketing wallet is already that address");
592         require(_marketingWallet != address(0),"Marketing wallet cannot be the zero address");
593         marketingWallet = _marketingWallet;
594 
595         emit MarketingWalletChanged(marketingWallet);
596     }
597 
598     bool public tradingEnabled;
599 
600     function enableTrading() external onlyOwner{
601         require(!tradingEnabled, "Trading already enabled.");
602         tradingEnabled = true;
603         swapEnabled = true;
604         launchTime = block.timestamp;
605         ladderTaxEnabled = true;
606     }
607 
608     function _transfer(address from,address to,uint256 amount) internal  override {
609         require(from != address(0), "ERC20: transfer from the zero address");
610         require(to != address(0), "ERC20: transfer to the zero address");
611         require(tradingEnabled || _isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading not yet enabled!");
612        
613         if (amount == 0) {
614             super._transfer(from, to, 0);
615             return;
616         }
617 
618         if (maxTransactionLimitEnabled) 
619         {
620             if ((from == uniswapV2Pair || to == uniswapV2Pair) &&
621                 !_isExcludedFromMaxTxLimit[from] && 
622                 !_isExcludedFromMaxTxLimit[to]
623             ) {
624                 if (from == uniswapV2Pair) {
625                     require(
626                         amount <= maxTransactionAmountBuy,  
627                         "AntiWhale: Transfer amount exceeds the maxTransactionAmount"
628                     );
629                 } else {
630                     require(
631                         amount <= maxTransactionAmountSell, 
632                         "AntiWhale: Transfer amount exceeds the maxTransactionAmount"
633                     );
634                 }
635             }
636         }
637 
638         if(ladderTaxEnabled) {
639             if(launchTime + 3000 < block.timestamp){
640                 liquidityFeeOnBuy  = 69; // 0.69
641                 liquidityFeeOnSell = 0; // 0
642 
643                 marketingFeeOnBuy  = 0; // 0
644                 marketingFeeOnSell = 0; // 0
645 
646                 _totalFeesOnBuy    = liquidityFeeOnBuy  + marketingFeeOnBuy;
647                 _totalFeesOnSell   = liquidityFeeOnSell + marketingFeeOnSell;
648 
649                 ladderTaxEnabled = false;
650             } else if(launchTime + 2400 < block.timestamp){
651                 liquidityFeeOnBuy  = 0; // 0
652                 liquidityFeeOnSell = 0; // 0
653 
654                 marketingFeeOnBuy  = 500; // 5
655                 marketingFeeOnSell = 500; // 5
656 
657                 _totalFeesOnBuy    = liquidityFeeOnBuy  + marketingFeeOnBuy;
658                 _totalFeesOnSell   = liquidityFeeOnSell + marketingFeeOnSell;
659             } else if(launchTime + 1800 < block.timestamp){
660                 liquidityFeeOnBuy  = 0; // 0
661                 liquidityFeeOnSell = 0; // 0
662 
663                 marketingFeeOnBuy  = 1000; // 10
664                 marketingFeeOnSell = 1000; // 10
665 
666                 _totalFeesOnBuy    = liquidityFeeOnBuy  + marketingFeeOnBuy;
667                 _totalFeesOnSell   = liquidityFeeOnSell + marketingFeeOnSell;
668             } else if(launchTime + 1200 < block.timestamp){
669                 liquidityFeeOnBuy  = 0; // 0
670                 liquidityFeeOnSell = 0; // 0
671 
672                 marketingFeeOnBuy  = 2000; // 20
673                 marketingFeeOnSell = 2000; // 20
674 
675                 _totalFeesOnBuy    = liquidityFeeOnBuy  + marketingFeeOnBuy;
676                 _totalFeesOnSell   = liquidityFeeOnSell + marketingFeeOnSell;
677             } else if(launchTime + 600 < block.timestamp){
678                 liquidityFeeOnBuy  = 0; // 0
679                 liquidityFeeOnSell = 0; // 0
680 
681                 marketingFeeOnBuy  = 3000; // 30
682                 marketingFeeOnSell = 3000; // 30
683 
684                 _totalFeesOnBuy    = liquidityFeeOnBuy  + marketingFeeOnBuy;
685                 _totalFeesOnSell   = liquidityFeeOnSell + marketingFeeOnSell;
686             }
687         }
688 
689 		uint256 contractTokenBalance = balanceOf(address(this));
690 
691         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
692 
693         if (canSwap &&
694             !swapping &&
695             to == uniswapV2Pair &&
696             _totalFeesOnBuy + _totalFeesOnSell > 0 &&
697             swapEnabled
698         ) {
699             swapping = true;
700 
701             uint256 totalFee = _totalFeesOnBuy + _totalFeesOnSell;
702             uint256 liquidityShare = liquidityFeeOnBuy + liquidityFeeOnSell;
703             uint256 marketingShare = marketingFeeOnBuy + marketingFeeOnSell;
704 
705             if (liquidityShare > 0) {
706                 uint256 liquidityTokens = contractTokenBalance * liquidityShare / totalFee;
707                 swapAndLiquify(liquidityTokens);
708             }
709             
710             if (marketingShare > 0) {
711                 uint256 marketingTokens = contractTokenBalance * marketingShare / totalFee;
712                 swapAndSendMarketing(marketingTokens);
713             }          
714 
715             swapping = false;
716         }
717 
718         uint256 _totalFees;
719         if (_isExcludedFromFees[from] || _isExcludedFromFees[to] || swapping) {
720             _totalFees = 0;
721         } else if (from == uniswapV2Pair) {
722             _totalFees = _totalFeesOnBuy;
723         } else if (to == uniswapV2Pair) {
724             _totalFees = _totalFeesOnSell;
725         } else {
726             _totalFees = 0;
727         }
728 
729         if (_totalFees > 0) {
730             uint256 fees = (amount * _totalFees) / 10_000;
731             amount = amount - fees;
732             super._transfer(from, address(this), fees);
733         }
734 
735         if (maxWalletLimitEnabled) 
736         {
737             if (!_isExcludedFromMaxWalletLimit[from] && 
738                 !_isExcludedFromMaxWalletLimit[to] &&
739                 to != uniswapV2Pair
740             ) {
741                 uint256 balance  = balanceOf(to);
742                 require(
743                     balance + amount <= maxWalletAmount, 
744                     "MaxWallet: Recipient exceeds the maxWalletAmount"
745                 );
746             }
747         }
748 
749         super._transfer(from, to, amount);
750     }
751 
752     function setSwapEnabled(bool _enabled) external onlyOwner{
753         require(swapEnabled != _enabled, "swapEnabled already at this state.");
754         swapEnabled = _enabled;
755     }
756 
757     function setSwapTokensAtAmount(uint256 newAmount) external onlyOwner{
758         require(newAmount > totalSupply() / 1_000_000, "SwapTokensAtAmount must be greater than 0.0001% of total supply");
759         swapTokensAtAmount = newAmount;
760 
761         emit SwapTokensAtAmountUpdated(swapTokensAtAmount);
762     }
763 
764     function swapAndLiquify(uint256 tokens) private {
765         uint256 half = tokens / 2;
766         uint256 otherHalf = tokens - half;
767 
768         uint256 initialBalance = address(this).balance;
769 
770         address[] memory path = new address[](2);
771         path[0] = address(this);
772         path[1] = uniswapV2Router.WETH();
773 
774         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
775             half,
776             0,
777             path,
778             address(this),
779             block.timestamp);
780         
781         uint256 newBalance = address(this).balance - initialBalance;
782 
783         uniswapV2Router.addLiquidityETH{value: newBalance}(
784             address(this),
785             otherHalf,
786             0,
787             0,
788             address(0xdead),
789             block.timestamp
790         );
791 
792         emit SwapAndLiquify(half, newBalance, otherHalf);
793     }
794 
795     function swapAndSendMarketing(uint256 tokenAmount) private {
796         uint256 initialBalance = address(this).balance;
797 
798         address[] memory path = new address[](2);
799         path[0] = address(this);
800         path[1] = uniswapV2Router.WETH();
801 
802         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
803             tokenAmount,
804             0,
805             path,
806             address(this),
807             block.timestamp);
808 
809         uint256 newBalance = address(this).balance - initialBalance;
810 
811         payable(marketingWallet).sendValue(newBalance);
812 
813         emit SwapAndSendMarketing(tokenAmount, newBalance);
814     }
815 
816     mapping(address => bool) private _isExcludedFromMaxWalletLimit;
817     bool    public maxWalletLimitEnabled;
818     uint256 public maxWalletAmount;
819 
820     event ExcludedFromMaxWalletLimit(address indexed account, bool isExcluded);
821     event MaxWalletLimitStateChanged(bool maxWalletLimit);
822     event MaxWalletLimitAmountChanged(uint256 maxWalletAmount);
823 
824     function setEnableMaxWalletLimit(bool enable) external onlyOwner {
825         require(enable != maxWalletLimitEnabled,"Max wallet limit is already set to that state");
826         maxWalletLimitEnabled = enable;
827 
828         emit MaxWalletLimitStateChanged(maxWalletLimitEnabled);
829     }
830 
831     function setMaxWalletAmount(uint256 _maxWalletAmount) external onlyOwner {
832         require(_maxWalletAmount >= (totalSupply() / (10 ** decimals())) / 100, "Max wallet percentage cannot be lower than 1%");
833         maxWalletAmount = _maxWalletAmount * (10 ** decimals());
834 
835         emit MaxWalletLimitAmountChanged(maxWalletAmount);
836     }
837 
838     function excludeFromMaxWallet(address account, bool exclude) external onlyOwner {
839         require( _isExcludedFromMaxWalletLimit[account] != exclude,"Account is already set to that state");
840         _isExcludedFromMaxWalletLimit[account] = exclude;
841 
842         emit ExcludedFromMaxWalletLimit(account, exclude);
843     }
844 
845     function isExcludedFromMaxWalletLimit(address account) public view returns(bool) {
846         return _isExcludedFromMaxWalletLimit[account];
847     }
848 
849     mapping(address => bool) private _isExcludedFromMaxTxLimit;
850     bool    public  maxTransactionLimitEnabled;
851     uint256 public  maxTransactionAmountBuy;
852     uint256 public  maxTransactionAmountSell;
853 
854     event ExcludedFromMaxTransactionLimit(address indexed account, bool isExcluded);
855     event MaxTransactionLimitStateChanged(bool maxTransactionLimit);
856     event MaxTransactionLimitAmountChanged(uint256 maxTransactionAmountBuy, uint256 maxTransactionAmountSell);
857 
858     function setEnableMaxTransactionLimit(bool enable) external onlyOwner {
859         require(enable != maxTransactionLimitEnabled, "Max transaction limit is already set to that state");
860         maxTransactionLimitEnabled = enable;
861 
862         emit MaxTransactionLimitStateChanged(maxTransactionLimitEnabled);
863     }
864 
865     function setMaxTransactionAmounts(uint256 _maxTransactionAmountBuy, uint256 _maxTransactionAmountSell) external onlyOwner {
866         require(
867             _maxTransactionAmountBuy  >= (totalSupply() / (10 ** decimals())) / 1_000 && 
868             _maxTransactionAmountSell >= (totalSupply() / (10 ** decimals())) / 1_000, 
869             "Max Transaction limis cannot be lower than 0.1% of total supply"
870         ); 
871         maxTransactionAmountBuy  = _maxTransactionAmountBuy  * (10 ** decimals());
872         maxTransactionAmountSell = _maxTransactionAmountSell * (10 ** decimals());
873 
874         emit MaxTransactionLimitAmountChanged(maxTransactionAmountBuy, maxTransactionAmountSell);
875     }
876 
877     function excludeFromMaxTransactionLimit(address account, bool exclude) external onlyOwner {
878         require( _isExcludedFromMaxTxLimit[account] != exclude, "Account is already set to that state");
879         require(account != address(this), "Can't set this address.");
880 
881         _isExcludedFromMaxTxLimit[account] = exclude;
882 
883         emit ExcludedFromMaxTransactionLimit(account, exclude);
884     }
885 
886     function isExcludedFromMaxTransaction(address account) public view returns(bool) {
887         return _isExcludedFromMaxTxLimit[account];
888     }
889 }