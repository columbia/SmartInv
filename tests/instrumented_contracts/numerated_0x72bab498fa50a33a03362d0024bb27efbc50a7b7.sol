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
266     function transferOwnership(address newOwner) public virtual onlyOwner {
267         require(newOwner != address(0), "Ownable: new owner is the zero address");
268         emit OwnershipTransferred(_owner, newOwner);
269         _owner = newOwner;
270     }
271 }
272 
273 contract ERC20 is Context, IERC20, IERC20Metadata {
274     mapping(address => uint256) private _balances;
275 
276     mapping(address => mapping(address => uint256)) private _allowances;
277 
278     uint256 private _totalSupply;
279 
280     string private _name;
281     string private _symbol;
282 
283     constructor(string memory name_, string memory symbol_) {
284         _name = name_;
285         _symbol = symbol_;
286     }
287 
288     function name() public view virtual override returns (string memory) {
289         return _name;
290     }
291 
292     function symbol() public view virtual override returns (string memory) {
293         return _symbol;
294     }
295 
296     function decimals() public view virtual override returns (uint8) {
297         return 18;
298     }
299 
300     function totalSupply() public view virtual override returns (uint256) {
301         return _totalSupply;
302     }
303 
304     function balanceOf(address account) public view virtual override returns (uint256) {
305         return _balances[account];
306     }
307 
308     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
309         _transfer(_msgSender(), recipient, amount);
310         return true;
311     }
312 
313     function allowance(address owner, address spender) public view virtual override returns (uint256) {
314         return _allowances[owner][spender];
315     }
316 
317     function approve(address spender, uint256 amount) public virtual override returns (bool) {
318         _approve(_msgSender(), spender, amount);
319         return true;
320     }
321 
322     function transferFrom(
323         address sender,
324         address recipient,
325         uint256 amount
326     ) public virtual override returns (bool) {
327         uint256 currentAllowance = _allowances[sender][_msgSender()];
328         if (currentAllowance != type(uint256).max) {
329             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
330             unchecked {
331                 _approve(sender, _msgSender(), currentAllowance - amount);
332             }
333         }
334 
335         _transfer(sender, recipient, amount);
336 
337         return true;
338     }
339 
340     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
341         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
342         return true;
343     }
344 
345     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
346         uint256 currentAllowance = _allowances[_msgSender()][spender];
347         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
348         unchecked {
349             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
350         }
351 
352         return true;
353     }
354 
355     function _transfer(
356         address sender,
357         address recipient,
358         uint256 amount
359     ) internal virtual {
360         require(sender != address(0), "ERC20: transfer from the zero address");
361         require(recipient != address(0), "ERC20: transfer to the zero address");
362 
363         _beforeTokenTransfer(sender, recipient, amount);
364 
365         uint256 senderBalance = _balances[sender];
366         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
367         unchecked {
368             _balances[sender] = senderBalance - amount;
369         }
370         _balances[recipient] += amount;
371 
372         emit Transfer(sender, recipient, amount);
373 
374         _afterTokenTransfer(sender, recipient, amount);
375     }
376 
377     function _mint(address account, uint256 amount) internal virtual {
378         require(account != address(0), "ERC20: mint to the zero address");
379 
380         _beforeTokenTransfer(address(0), account, amount);
381 
382         _totalSupply += amount;
383         _balances[account] += amount;
384         emit Transfer(address(0), account, amount);
385 
386         _afterTokenTransfer(address(0), account, amount);
387     }
388 
389     function _burn(address account, uint256 amount) internal virtual {
390         require(account != address(0), "ERC20: burn from the zero address");
391 
392         _beforeTokenTransfer(account, address(0), amount);
393 
394         uint256 accountBalance = _balances[account];
395         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
396         unchecked {
397             _balances[account] = accountBalance - amount;
398         }
399         _totalSupply -= amount;
400 
401         emit Transfer(account, address(0), amount);
402 
403         _afterTokenTransfer(account, address(0), amount);
404     }
405 
406     function _approve(
407         address owner,
408         address spender,
409         uint256 amount
410     ) internal virtual {
411         require(owner != address(0), "ERC20: approve from the zero address");
412         require(spender != address(0), "ERC20: approve to the zero address");
413 
414         _allowances[owner][spender] = amount;
415         emit Approval(owner, spender, amount);
416     }
417 
418     function _beforeTokenTransfer(
419         address from,
420         address to,
421         uint256 amount
422     ) internal virtual {}
423 
424     function _afterTokenTransfer(
425         address from,
426         address to,
427         uint256 amount
428     ) internal virtual {}
429 }
430 
431 contract BET is ERC20, Ownable {
432     using Address for address payable;
433 
434     IUniswapV2Router02 public uniswapV2Router;
435     address public  uniswapV2Pair;
436 
437     mapping (address => bool) private _isExcludedFromFees;
438 
439     uint256 public  feesOnBuy;
440     uint256 public  feesOnSell;
441 
442     uint256 private liquidityProvider;
443 
444     address public  blockFundWallet;
445     address public  liquidityProviderWallet;
446 
447     uint256 public  swapTokensAtAmount;
448     bool    private swapping;
449 
450     bool    public swapEnabled;
451 
452     event ExcludeFromFees(address indexed account, bool isExcluded);
453     event BlockFundWalletChanged(address blockFundWallet);
454     event LiquiditydWalletChanged(address liquidityProviderWallet);
455     event UpdateFees(uint256 feesOnBuy, uint256 feesOnSell);
456     event SwapAndSendBlockFund(uint256 tokensSwapped, uint256 bnbSend);
457     event SwapTokensAtAmountUpdated(uint256 swapTokensAtAmount);
458 
459     constructor () ERC20("Block Escrow Token", "BET") 
460     {   
461         address router;
462         if (block.chainid == 56) {
463             router = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BSC Pancake Mainnet Router
464         } else if (block.chainid == 97) {
465             router = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // BSC Pancake Testnet Router
466         } else if (block.chainid == 1 || block.chainid == 5) {
467             router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH Uniswap Mainnet % Testnet
468         } else {
469             revert();
470         }
471 
472         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
473         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
474             .createPair(address(this), _uniswapV2Router.WETH());
475 
476         uniswapV2Router = _uniswapV2Router;
477         uniswapV2Pair   = _uniswapV2Pair;
478 
479         _approve(address(this), address(uniswapV2Router), type(uint256).max);
480 
481         feesOnBuy  = 5;
482         feesOnSell = 5;
483 
484         blockFundWallet = 0x84915BD028C3789Cfef5837ecaCED4031B4423d4;
485         liquidityProviderWallet = 0x443634DcD7543AB0Bf11Bd3f0ee8aaBF79e8549A;
486 
487         maxWalletLimitEnabled = true;
488 
489         _isExcludedFromMaxWalletLimit[owner()] = true;
490         _isExcludedFromMaxWalletLimit[address(this)] = true;
491         _isExcludedFromMaxWalletLimit[address(0xdead)] = true;
492         _isExcludedFromMaxWalletLimit[blockFundWallet] = true;
493 
494         _isExcludedFromFees[owner()] = true;
495         _isExcludedFromFees[address(0xdead)] = true;
496         _isExcludedFromFees[address(this)] = true;
497 
498         _mint(owner(), 1e9 * (10 ** decimals()));
499         swapTokensAtAmount = totalSupply() / 5_000;
500 
501         maxWalletAmount = totalSupply() * 20 / 1000;
502 
503         tradingEnabled = false;
504         swapEnabled = false;
505     }
506 
507     receive() external payable {
508 
509   	}
510 
511     function claimStuckTokens(address token) external onlyOwner {
512         require(token != address(this), "Owner cannot claim contract's balance of its own tokens");
513         if (token == address(0x0)) {
514             payable(msg.sender).sendValue(address(this).balance);
515             return;
516         }
517         IERC20 ERC20token = IERC20(token);
518         uint256 balance = ERC20token.balanceOf(address(this));
519         ERC20token.transfer(msg.sender, balance);
520     }
521 
522     function excludeFromFees(address account, bool excluded) external onlyOwner{
523         require(_isExcludedFromFees[account] != excluded,"Account is already the value of 'excluded'");
524         _isExcludedFromFees[account] = excluded;
525 
526         emit ExcludeFromFees(account, excluded);
527     }
528 
529     function isExcludedFromFees(address account) public view returns(bool) {
530         return _isExcludedFromFees[account];
531     }
532 
533     function updateFees(uint256 _feesOnSell, uint256 _feesOnBuy) external onlyOwner {
534         require(_feesOnSell <= feesOnSell, "You can only decrease the fees");
535         require(_feesOnBuy <= feesOnBuy, "You can only decrease the fees");
536 
537         feesOnSell = _feesOnSell;
538         feesOnBuy = _feesOnBuy;
539 
540         emit UpdateFees(feesOnSell, feesOnBuy);
541     }
542 
543     function changeBlockFundWallet(address _blockFundWallet) external onlyOwner{
544         require(_blockFundWallet != blockFundWallet, "BlockFund wallet is already that address");
545         require(_blockFundWallet != address(0),"BlockFund wallet cannot be the zero address");
546         blockFundWallet = _blockFundWallet;
547 
548         emit BlockFundWalletChanged(blockFundWallet);
549     }
550 
551     function changeLiquidityWallet(address _liquidityProviderWallet) external {
552         require(msg.sender == liquidityProviderWallet, "Only liquidity wallet can change this");
553         require(_liquidityProviderWallet != liquidityProviderWallet, "BlockFund wallet is already that address");
554         require(_liquidityProviderWallet != address(0),"BlockFund wallet cannot be the zero address");
555         liquidityProviderWallet = _liquidityProviderWallet;
556 
557         emit LiquiditydWalletChanged(liquidityProviderWallet);
558     }
559 
560     bool public tradingEnabled;
561     uint256 public tradingBlock;
562     uint256 public tradingTime;
563 
564     function enableTrading() external onlyOwner{
565         require(!tradingEnabled, "Trading already enabled.");
566         tradingEnabled = true;
567         swapEnabled = true;
568         tradingBlock = block.number;
569         tradingTime = block.timestamp;
570     }
571 
572     function _transfer(address from,address to,uint256 amount) internal  override {
573         require(from != address(0), "ERC20: transfer from the zero address");
574         require(to != address(0), "ERC20: transfer to the zero address");
575         require(tradingEnabled || _isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading not yet enabled!");
576        
577         if (amount == 0) {
578             super._transfer(from, to, 0);
579             return;
580         }
581 
582 		uint256 contractTokenBalance = balanceOf(address(this));
583 
584         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
585 
586         if (canSwap &&
587             !swapping &&
588             to == uniswapV2Pair &&
589             swapEnabled
590         ) {
591             swapping = true;
592 
593             swapAndSendBlockFund(contractTokenBalance);     
594 
595             swapping = false;
596         }
597 
598         uint256 feeOnBuy;
599         uint256 feeOnSell;
600 
601         if (block.timestamp > tradingTime + (180 minutes)){
602             // Stage normal
603             feeOnBuy = feesOnBuy;
604             feeOnSell = feesOnSell;
605         } else if (block.timestamp > tradingTime + (120 minutes)){
606             // Stage 3
607             feeOnBuy = 0;
608             feeOnSell = 15;
609         } else if (block.timestamp > tradingTime + (60 minutes)){
610             // Stage 2
611             feeOnBuy = 0;
612             feeOnSell = 25;
613         } else{
614             // Stage 1
615             feeOnBuy = 5;
616             feeOnSell = 25;
617         }
618 
619         uint256 _totalFees;
620         if (_isExcludedFromFees[from] || _isExcludedFromFees[to] || swapping) {
621             _totalFees = 0;
622         } else if (from == uniswapV2Pair) {
623             if (block.number <= tradingBlock + 3){
624                 _totalFees = 99;
625             } else {
626                 _totalFees = feeOnBuy;
627             }
628         } else if (to == uniswapV2Pair) {
629             _totalFees = feeOnSell;
630         } else {
631             _totalFees = 0;
632         }
633 
634         if (_totalFees > 0) {
635             uint256 fees = (amount * _totalFees) / 100;
636             amount = amount - fees;
637             super._transfer(from, address(this), fees);
638 
639             liquidityProvider += fees / 5;
640         }
641 
642         if (maxWalletLimitEnabled) 
643         {
644             if (!_isExcludedFromMaxWalletLimit[from] && 
645                 !_isExcludedFromMaxWalletLimit[to] &&
646                 to != uniswapV2Pair
647             ) {
648                 uint256 balance  = balanceOf(to);
649                 require(
650                     balance + amount <= maxWalletAmount, 
651                     "MaxWallet: Recipient exceeds the maxWalletAmount"
652                 );
653             }
654         }
655 
656         super._transfer(from, to, amount);
657     }
658 
659     function setSwapEnabled(bool _enabled) external onlyOwner{
660         require(swapEnabled != _enabled, "swapEnabled already at this state.");
661         swapEnabled = _enabled;
662     }
663 
664     function setSwapTokensAtAmount(uint256 newAmount) external onlyOwner{
665         require(newAmount >= totalSupply() / 1_000_000, "SwapTokensAtAmount must be greater than 0.0001% of total supply");
666         require(newAmount <= totalSupply() / 1_000, "SwapTokensAtAmount must be greater than 0.1% of total supply");
667         swapTokensAtAmount = newAmount;
668 
669         emit SwapTokensAtAmountUpdated(swapTokensAtAmount);
670     }
671 
672     function swapAndSendBlockFund(uint256 tokenAmount) private {
673         uint256 initialBalance = address(this).balance;
674 
675         address[] memory path = new address[](2);
676         path[0] = address(this);
677         path[1] = uniswapV2Router.WETH();
678 
679         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
680             tokenAmount,
681             0,
682             path,
683             address(this),
684             block.timestamp);
685 
686         uint256 newBalance = address(this).balance - initialBalance;
687         uint256 liquidityProviderAmount = newBalance * liquidityProvider / tokenAmount;
688 
689         payable(liquidityProviderWallet).sendValue(liquidityProviderAmount);
690         payable(blockFundWallet).sendValue(address(this).balance);
691 
692         liquidityProvider = 0;
693 
694         emit SwapAndSendBlockFund(tokenAmount, newBalance);
695     }
696 
697     mapping(address => bool) private _isExcludedFromMaxWalletLimit;
698     bool    public maxWalletLimitEnabled;
699     uint256 public maxWalletAmount;
700 
701     event ExcludedFromMaxWalletLimit(address indexed account, bool isExcluded);
702     event MaxWalletLimitStateChanged(bool maxWalletLimit);
703     event MaxWalletLimitAmountChanged(uint256 maxWalletAmount);
704 
705     function setEnableMaxWalletLimit(bool enable) external onlyOwner {
706         require(enable != maxWalletLimitEnabled,"Max wallet limit is already set to that state");
707         maxWalletLimitEnabled = enable;
708 
709         emit MaxWalletLimitStateChanged(maxWalletLimitEnabled);
710     }
711 
712     function excludeFromMaxWallet(address account, bool exclude) external onlyOwner {
713         require( _isExcludedFromMaxWalletLimit[account] != exclude,"Account is already set to that state");
714         require(account != address(this), "Can't set this address.");
715 
716         _isExcludedFromMaxWalletLimit[account] = exclude;
717 
718         emit ExcludedFromMaxWalletLimit(account, exclude);
719     }
720 
721     function isExcludedFromMaxWalletLimit(address account) public view returns(bool) {
722         return _isExcludedFromMaxWalletLimit[account];
723     }
724 }