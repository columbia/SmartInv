1 // SPDX-License-Identifier: MIT
2 
3 /*
4     https://t.me/ignoreERC
5 */
6 
7 pragma solidity 0.8.10;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes calldata) {
15         return msg.data;
16     }
17 }
18 
19 abstract contract Ownable is Context {
20     address private _owner;
21 
22     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23 
24     constructor() {
25         _transferOwnership(_msgSender());
26     }
27 
28     function owner() public view virtual returns (address) {
29         return _owner;
30     }
31 
32     modifier onlyOwner() {
33         require(owner() == _msgSender(), "Ownable: caller is not the owner");
34         _;
35     }
36 
37     function renounceOwnership() public virtual onlyOwner {
38         _transferOwnership(address(0));
39     }
40 
41     function transferOwnership(address newOwner) public virtual onlyOwner {
42         require(newOwner != address(0), "Ownable: new owner is the zero address");
43         _transferOwnership(newOwner);
44     }
45     function _transferOwnership(address newOwner) internal virtual {
46         address oldOwner = _owner;
47         _owner = newOwner;
48         emit OwnershipTransferred(oldOwner, newOwner);
49     }
50 }
51 
52 interface IERC20 {
53     function totalSupply() external view returns (uint256);
54     function balanceOf(address account) external view returns (uint256);
55     function transfer(address recipient, uint256 amount) external returns (bool);
56     function allowance(address owner, address spender) external view returns (uint256);
57     function approve(address spender, uint256 amount) external returns (bool);
58     function transferFrom(
59         address sender,
60         address recipient,
61         uint256 amount
62     ) external returns (bool);
63     event Transfer(address indexed from, address indexed to, uint256 value);
64     event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 interface IERC20Metadata is IERC20 {
68     function name() external view returns (string memory);
69     function symbol() external view returns (string memory);
70     function decimals() external view returns (uint8);
71 }
72 
73 contract ERC20 is Context, IERC20, IERC20Metadata {
74     mapping(address => uint256) private _balances;
75     mapping(address => mapping(address => uint256)) private _allowances;
76 
77     uint256 private _totalSupply;
78     string private _name;
79     string private _symbol;
80 
81     constructor(string memory name_, string memory symbol_) {
82         _name = name_;
83         _symbol = symbol_;
84     }
85 
86 
87     function name() public view virtual override returns (string memory) {
88         return _name;
89     }
90 
91     function symbol() public view virtual override returns (string memory) {
92         return _symbol;
93     }
94 
95     function decimals() public view virtual override returns (uint8) {
96         return 18;
97     }
98 
99     function totalSupply() public view virtual override returns (uint256) {
100         return _totalSupply;
101     }
102 
103     function balanceOf(address account) public view virtual override returns (uint256) {
104         return _balances[account];
105     }
106 
107     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
108         _transfer(_msgSender(), recipient, amount);
109         return true;
110     }
111 
112     function allowance(address owner, address spender) public view virtual override returns (uint256) {
113         return _allowances[owner][spender];
114     }
115 
116     function approve(address spender, uint256 amount) public virtual override returns (bool) {
117         _approve(_msgSender(), spender, amount);
118         return true;
119     }
120 
121     function transferFrom(
122         address sender,
123         address recipient,
124         uint256 amount
125     ) public virtual override returns (bool) {
126         _transfer(sender, recipient, amount);
127 
128         uint256 currentAllowance = _allowances[sender][_msgSender()];
129         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
130         unchecked {
131             _approve(sender, _msgSender(), currentAllowance - amount);
132         }
133 
134         return true;
135     }
136 
137     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
138         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
139         return true;
140     }
141 
142     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
143         uint256 currentAllowance = _allowances[_msgSender()][spender];
144         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
145         unchecked {
146             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
147         }
148 
149         return true;
150     }
151 
152     function _transfer(
153         address sender,
154         address recipient,
155         uint256 amount
156     ) internal virtual {
157         require(sender != address(0), "ERC20: transfer from the zero address");
158         require(recipient != address(0), "ERC20: transfer to the zero address");
159 
160         _beforeTokenTransfer(sender, recipient, amount);
161 
162         uint256 senderBalance = _balances[sender];
163         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
164         unchecked {
165             _balances[sender] = senderBalance - amount;
166         }
167         _balances[recipient] += amount;
168 
169         emit Transfer(sender, recipient, amount);
170 
171         _afterTokenTransfer(sender, recipient, amount);
172     }
173 
174     function _mint(address account, uint256 amount) internal virtual {
175         require(account != address(0), "ERC20: mint to the zero address");
176 
177         _beforeTokenTransfer(address(0), account, amount);
178 
179         _totalSupply += amount;
180         _balances[account] += amount;
181         emit Transfer(address(0), account, amount);
182 
183         _afterTokenTransfer(address(0), account, amount);
184     }
185 
186     function _burn(address account, uint256 amount) internal virtual {
187         require(account != address(0), "ERC20: burn from the zero address");
188 
189         _beforeTokenTransfer(account, address(0), amount);
190 
191         uint256 accountBalance = _balances[account];
192         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
193         unchecked {
194             _balances[account] = accountBalance - amount;
195         }
196         _totalSupply -= amount;
197 
198         emit Transfer(account, address(0), amount);
199 
200         _afterTokenTransfer(account, address(0), amount);
201     }
202 
203     function _approve(
204         address owner,
205         address spender,
206         uint256 amount
207     ) internal virtual {
208         require(owner != address(0), "ERC20: approve from the zero address");
209         require(spender != address(0), "ERC20: approve to the zero address");
210 
211         _allowances[owner][spender] = amount;
212         emit Approval(owner, spender, amount);
213     }
214 
215     function _beforeTokenTransfer(
216         address from,
217         address to,
218         uint256 amount
219     ) internal virtual {}
220 
221     function _afterTokenTransfer(
222         address from,
223         address to,
224         uint256 amount
225     ) internal virtual {}
226 }
227 
228 interface IUniswapV2Factory {
229     function createPair(address tokenA, address tokenB)
230         external
231         returns (address pair);
232 }
233 
234 interface IUniswapV2Router02 {
235     function factory() external pure returns (address);
236 
237     function WETH() external pure returns (address);
238 
239     function addLiquidityETH(
240         address token,
241         uint256 amountTokenDesired,
242         uint256 amountTokenMin,
243         uint256 amountETHMin,
244         address to,
245         uint256 deadline
246     )
247         external
248         payable
249         returns (
250             uint256 amountToken,
251             uint256 amountETH,
252             uint256 liquidity
253         );
254 
255     function swapExactTokensForETHSupportingFeeOnTransferTokens(
256         uint256 amountIn,
257         uint256 amountOutMin,
258         address[] calldata path,
259         address to,
260         uint256 deadline
261     ) external;
262 }
263 
264 contract IgnoreAll is ERC20, Ownable {
265     IUniswapV2Router02 public immutable uniswapV2Router;
266     address public immutable uniswapV2Pair;
267 
268     bool private swapping;
269 
270     address public devWallet;
271 
272     uint256 public maxTransactionAmount;
273     uint256 public swapTokensAtAmount;
274     uint256 public maxWallet;
275 
276     bool public limitsInEffect = true;
277     bool public tradingActive = false;
278     bool public swapEnabled = false;
279 
280     uint256 public buyTotalFees;
281     uint256 public buyLiquidityFee;
282     uint256 public buyMarketingFee;
283 
284     uint256 public sellTotalFees;
285     uint256 public sellLiquidityFee;
286     uint256 public sellMarketingFee;
287 
288 	uint256 public tokensForLiquidity;
289     uint256 public tokensForMarketing;
290 
291     // exclude from fees and max transaction amount
292     mapping(address => bool) private _isExcludedFromFees;
293     mapping(address => bool) public _isExcludedFromMaxTx;
294 
295     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
296     // could be subject to a maximum transfer amount
297     mapping(address => bool) public automatedMarketMakerPairs;
298 
299     event ExcludeFromFees(address indexed account, bool isExcluded);
300 
301     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
302 
303     event SwapAndLiquify(
304         uint256 tokensSwapped,
305         uint256 ethReceived,
306         uint256 tokensIntoLiquidity
307     );
308 
309     constructor() ERC20("ignoreall", "ignore") {
310         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
311             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
312         );
313 
314         _isExcludedFromMaxTx[address(_uniswapV2Router)] = true;
315         uniswapV2Router = _uniswapV2Router;
316 
317         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
318             .createPair(address(this), _uniswapV2Router.WETH());
319         _isExcludedFromMaxTx[address(uniswapV2Pair)] = true;
320         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
321 
322         uint256 _buyLiquidityFee = 0;
323         uint256 _buyMarketingFee = 0;
324 
325         uint256 _sellLiquidityFee = 0;
326         uint256 _sellMarketingFee = 0;
327 
328         uint256 totalSupply = 100 * 1e7 * 1e18;
329 
330         maxTransactionAmount = 140 * 1e7 * 1e18; //2 %
331         maxWallet = 140 * 1e7 * 1e18; //2%
332         swapTokensAtAmount = (totalSupply * 10) / 1000; 
333 
334         buyLiquidityFee = _buyLiquidityFee;
335         buyMarketingFee = _buyMarketingFee;
336         buyTotalFees = buyLiquidityFee + buyMarketingFee;
337 
338         sellLiquidityFee = _sellLiquidityFee;
339         sellMarketingFee = _sellMarketingFee;
340         sellTotalFees = sellLiquidityFee + sellMarketingFee;
341 
342         devWallet = address(0x20cA06CE8029c83da6A8eF1b0b45F34c66162d67); 
343 
344         // exclude from paying fees or having max transaction amount
345         excludeFromFees(owner(), true);
346         excludeFromFees(address(this), true);
347         excludeFromFees(address(0xdead), true);
348 
349         _isExcludedFromMaxTx[owner()] = true;
350         _isExcludedFromMaxTx[address(this)] = true;
351         _isExcludedFromMaxTx[address(0xdead)] = true;
352 
353         _mint(msg.sender, totalSupply);
354     }
355 
356     receive() external payable {}
357 
358     // once enabled, can never be turned off
359     function enableTrade() external onlyOwner {
360         tradingActive = true;
361         swapEnabled = true;
362     }
363 
364     function updateFees(uint256 _buyLiquidityFee,uint256 _buyMarketingFee,uint256 _sellLiquidityFee,uint256 _sellMarketingFee) external onlyOwner {
365         buyLiquidityFee = _buyLiquidityFee;
366         buyMarketingFee = _buyMarketingFee;
367         buyTotalFees = buyLiquidityFee + buyMarketingFee;
368 
369         sellLiquidityFee = _sellLiquidityFee;
370         sellMarketingFee = _sellMarketingFee;
371         sellTotalFees = sellLiquidityFee + sellMarketingFee;
372     }
373 
374     // remove limits after token is stable
375     function removeLimits() external onlyOwner returns (bool) {
376         limitsInEffect = false;
377         return true;
378     }
379 
380     // change the minimum amount of tokens to sell from fees
381     function updateSwapTokensAtAmount(uint256 newAmount)
382         external
383         onlyOwner
384         returns (bool)
385     {
386         require(
387             newAmount >= (totalSupply() * 1) / 100000,
388             "Swap amount cannot be lower than 0.001% total supply."
389         );
390         require(
391             newAmount <= (totalSupply() * 5) / 1000,
392             "Swap amount cannot be higher than 0.5% total supply."
393         );
394         swapTokensAtAmount = newAmount;
395         return true;
396     }
397 	
398     function excludeFromMaxTransaction(address updAds, bool isEx)
399         external
400         onlyOwner
401     {
402         _isExcludedFromMaxTx[updAds] = isEx;
403     }
404 
405     // only use to disable contract sales if absolutely necessary (emergency use only)
406     function updateSwapEnabled(bool enabled) external onlyOwner {
407         swapEnabled = enabled;
408     }
409 
410     function excludeFromFees(address account, bool excluded) public onlyOwner {
411         _isExcludedFromFees[account] = excluded;
412         emit ExcludeFromFees(account, excluded);
413     }
414 
415     function setAutomatedMarketMakerPair(address pair, bool value)
416         public
417         onlyOwner
418     {
419         require(
420             pair != uniswapV2Pair,
421             "The pair cannot be removed from automatedMarketMakerPairs"
422         );
423 
424         _setAutomatedMarketMakerPair(pair, value);
425     }
426 
427     function _setAutomatedMarketMakerPair(address pair, bool value) private {
428         automatedMarketMakerPairs[pair] = value;
429 
430         emit SetAutomatedMarketMakerPair(pair, value);
431     }
432 
433     function isExcludedFromFees(address account) public view returns (bool) {
434         return _isExcludedFromFees[account];
435     }
436 
437     function _transfer(
438         address from,
439         address to,
440         uint256 amount
441     ) internal override {
442         require(from != address(0), "ERC20: transfer from the zero address");
443         require(to != address(0), "ERC20: transfer to the zero address");
444 
445         if (amount == 0) {
446             super._transfer(from, to, 0);
447             return;
448         }
449 
450         if (limitsInEffect) {
451             if (
452                 from != owner() &&
453                 to != owner() &&
454                 to != address(0) &&
455                 to != address(0xdead) &&
456                 !swapping
457             ) {
458                 if (!tradingActive) {
459                     require(
460                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
461                         "Trading is not active."
462                     );
463                 }
464 
465                 //when buy
466                 if (
467                     automatedMarketMakerPairs[from] &&
468                     !_isExcludedFromMaxTx[to]
469                 ) {
470                     require(
471                         amount <= maxTransactionAmount,
472                         "Buy transfer amount exceeds the maxTransactionAmount."
473                     );
474                     require(
475                         amount + balanceOf(to) <= maxWallet,
476                         "Max wallet exceeded"
477                     );
478                 }
479                 //when sell
480                 else if (
481                     automatedMarketMakerPairs[to] &&
482                     !_isExcludedFromMaxTx[from]
483                 ) {
484                     require(
485                         amount <= maxTransactionAmount,
486                         "Sell transfer amount exceeds the maxTransactionAmount."
487                     );
488                 } else if (!_isExcludedFromMaxTx[to]) {
489                     require(
490                         amount + balanceOf(to) <= maxWallet,
491                         "Max wallet exceeded"
492                     );
493                 }
494             }
495         }
496 
497         uint256 contractTokenBalance = balanceOf(address(this));
498 
499         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
500 
501         if (
502             canSwap &&
503             swapEnabled &&
504             !swapping &&
505             !automatedMarketMakerPairs[from] &&
506             !_isExcludedFromFees[from] &&
507             !_isExcludedFromFees[to]
508         ) {
509             swapping = true;
510 
511             swapBack();
512 
513             swapping = false;
514         }
515 
516         bool takeFee = !swapping;
517 
518         // if any account belongs to _isExcludedFromFee account then remove the fee
519         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
520             takeFee = false;
521         }
522 
523         uint256 fees = 0;
524         // only take fees on buys/sells, do not take on wallet transfers
525         if (takeFee) {
526             // on sell
527             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
528                 fees = amount * sellTotalFees / 100;
529                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
530                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;                
531             }
532             // on buy
533             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
534                 fees = amount * buyTotalFees / 100;
535                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
536                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
537             }
538 
539             if (fees > 0) {
540                 super._transfer(from, address(this), fees);
541             }
542 
543             amount -= fees;
544         }
545 
546         super._transfer(from, to, amount);
547     }
548 
549     function swapTokensForEth(uint256 tokenAmount) private {
550         // generate the uniswap pair path of token -> weth
551         address[] memory path = new address[](2);
552         path[0] = address(this);
553         path[1] = uniswapV2Router.WETH();
554 
555         _approve(address(this), address(uniswapV2Router), tokenAmount);
556 
557         // make the swap
558         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
559             tokenAmount,
560             0, // accept any amount of ETH
561             path,
562             address(this),
563             block.timestamp
564         );
565     }
566 
567     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
568         // approve token transfer to cover all possible scenarios
569         _approve(address(this), address(uniswapV2Router), tokenAmount);
570 
571         // add the liquidity
572         uniswapV2Router.addLiquidityETH{value: ethAmount}(
573             address(this),
574             tokenAmount,
575             0, // slippage is unavoidable
576             0, // slippage is unavoidable
577             devWallet,
578             block.timestamp
579         );
580     }
581 
582     function setDevWallet(address wallet) external onlyOwner {
583         devWallet = wallet; 
584     }
585 
586     function swapBack() private {
587         uint256 contractBalance = balanceOf(address(this));
588         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
589         bool success;
590 
591         if (contractBalance == 0 || totalTokensToSwap == 0) {
592             return;
593         }
594 
595         if (contractBalance > swapTokensAtAmount * 20) {
596             contractBalance = swapTokensAtAmount * 20;
597         }
598 
599         // Halve the amount of liquidity tokens
600         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
601         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
602 
603         uint256 initialETHBalance = address(this).balance;
604 
605         swapTokensForEth(amountToSwapForETH);
606 
607         uint256 ethBalance = address(this).balance - initialETHBalance;
608 	
609         uint256 ethForMarketing = ethBalance * tokensForMarketing / totalTokensToSwap;
610 
611         uint256 ethForLiquidity = ethBalance - ethForMarketing;
612 
613         tokensForLiquidity = 0;
614         tokensForMarketing = 0;
615 
616         if (liquidityTokens > 0 && ethForLiquidity > 0) {
617             addLiquidity(liquidityTokens, ethForLiquidity);
618             emit SwapAndLiquify(
619                 amountToSwapForETH,
620                 ethForLiquidity,
621                 tokensForLiquidity
622             );
623         }
624         //there will be no leftover eth in the contract 
625         (success, ) = address(devWallet).call{value: address(this).balance}("");
626     }
627 
628 }