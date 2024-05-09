1 /**
2 ███    ███  █████  ██████  ██      ███████ ██    ██ 
3 ████  ████ ██   ██ ██   ██ ██      ██       ██  ██  
4 ██ ████ ██ ███████ ██████  ██      █████     ████   
5 ██  ██  ██ ██   ██ ██   ██ ██      ██         ██    
6 ██      ██ ██   ██ ██   ██ ███████ ███████    ██ 
7 */
8 
9 // SPDX-License-Identifier: MIT                                                                               
10                                                     
11 pragma solidity 0.8.19;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         this; 
20         return msg.data;
21     }
22 }
23 
24 interface IERC20 {
25     /**
26      * @dev Returns the amount of tokens in existence.
27      */
28     function totalSupply() external view returns (uint256);
29 
30     /**
31      * @dev Returns the amount of tokens owned by `account`.
32      */
33     function balanceOf(address account) external view returns (uint256);
34 
35     /**
36      * @dev Moves `amount` tokens from the caller's account to `recipient`.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * Emits a {Transfer} event.
41      */
42     function transfer(address recipient, uint256 amount) external returns (bool);
43 
44     /**
45      * @dev Returns the remaining number of tokens that `spender` will be
46      * allowed to spend on behalf of `owner` through {transferFrom}. This is
47      * zero by default.
48      *
49      * This value changes when {approve} or {transferFrom} are called.
50      */
51     function allowance(address owner, address spender) external view returns (uint256);
52 
53     /**
54      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * IMPORTANT: Beware that changing an allowance with this method brings the risk
59      * that someone may use both the old and the new allowance by unfortunate
60      * transaction ordering. One possible solution to mitigate this race
61      * condition is to first reduce the spender's allowance to 0 and set the
62      * desired value afterwards:
63      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
64      *
65      * Emits an {Approval} event.
66      */
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Moves `amount` tokens from `sender` to `recipient` using the
71      * allowance mechanism. `amount` is then deducted from the caller's
72      * allowance.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a {Transfer} event.
77      */
78     function transferFrom(
79         address sender,
80         address recipient,
81         uint256 amount
82     ) external returns (bool);
83 
84     /**
85      * @dev Emitted when `value` tokens are moved from one account (`from`) to
86      * another (`to`).
87      *
88      * Note that `value` may be zero.
89      */
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     /**
93      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
94      * a call to {approve}. `value` is the new allowance.
95      */
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 interface IERC20Metadata is IERC20 {
100     /**
101      * @dev Returns the name of the token.
102      */
103     function name() external view returns (string memory);
104 
105     /**
106      * @dev Returns the symbol of the token.
107      */
108     function symbol() external view returns (string memory);
109 
110     /**
111      * @dev Returns the decimals places of the token.
112      */
113     function decimals() external view returns (uint8);
114 }
115 
116 contract ERC20 is Context, IERC20, IERC20Metadata {
117     mapping(address => uint256) private _balances;
118 
119     mapping(address => mapping(address => uint256)) private _allowances;
120 
121     uint256 private _totalSupply;
122 
123     string private _name;
124     string private _symbol;
125 
126     constructor(string memory name_, string memory symbol_) {
127         _name = name_;
128         _symbol = symbol_;
129     }
130 
131     function name() public view virtual override returns (string memory) {
132         return _name;
133     }
134 
135     function symbol() public view virtual override returns (string memory) {
136         return _symbol;
137     }
138 
139     function decimals() public view virtual override returns (uint8) {
140         return 18;
141     }
142 
143     function totalSupply() public view virtual override returns (uint256) {
144         return _totalSupply;
145     }
146 
147     function balanceOf(address account) public view virtual override returns (uint256) {
148         return _balances[account];
149     }
150 
151     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
152         _transfer(_msgSender(), recipient, amount);
153         return true;
154     }
155 
156     function allowance(address owner, address spender) public view virtual override returns (uint256) {
157         return _allowances[owner][spender];
158     }
159 
160     function approve(address spender, uint256 amount) public virtual override returns (bool) {
161         _approve(_msgSender(), spender, amount);
162         return true;
163     }
164 
165     function transferFrom(
166         address sender,
167         address recipient,
168         uint256 amount
169     ) public virtual override returns (bool) {
170         _transfer(sender, recipient, amount);
171 
172         uint256 currentAllowance = _allowances[sender][_msgSender()];
173         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
174         unchecked {
175             _approve(sender, _msgSender(), currentAllowance - amount);
176         }
177 
178         return true;
179     }
180 
181     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
182         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
183         return true;
184     }
185 
186     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
187         uint256 currentAllowance = _allowances[_msgSender()][spender];
188         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
189         unchecked {
190             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
191         }
192 
193         return true;
194     }
195 
196     function _transfer(
197         address sender,
198         address recipient,
199         uint256 amount
200     ) internal virtual {
201         require(sender != address(0), "ERC20: transfer from the zero address");
202         require(recipient != address(0), "ERC20: transfer to the zero address");
203 
204         uint256 senderBalance = _balances[sender];
205         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
206         unchecked {
207             _balances[sender] = senderBalance - amount;
208         }
209         _balances[recipient] += amount;
210 
211         emit Transfer(sender, recipient, amount);
212     }
213 
214     function _createInitialSupply(address account, uint256 amount) internal virtual {
215         require(account != address(0), "ERC20: mint to the zero address");
216 
217         _totalSupply += amount;
218         _balances[account] += amount;
219         emit Transfer(address(0), account, amount);
220     }
221 
222     function _approve(
223         address owner,
224         address spender,
225         uint256 amount
226     ) internal virtual {
227         require(owner != address(0), "ERC20: approve from the zero address");
228         require(spender != address(0), "ERC20: approve to the zero address");
229 
230         _allowances[owner][spender] = amount;
231         emit Approval(owner, spender, amount);
232     }
233 }
234 
235 contract Ownable is Context {
236     address private _owner;
237 
238     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
239     
240     constructor () {
241         address msgSender = _msgSender();
242         _owner = msgSender;
243         emit OwnershipTransferred(address(0), msgSender);
244     }
245 
246     function owner() public view returns (address) {
247         return _owner;
248     }
249 
250     modifier onlyOwner() {
251         require(_owner == _msgSender(), "Ownable: caller is not the owner");
252         _;
253     }
254 
255     function renounceOwnership() external virtual onlyOwner {
256         emit OwnershipTransferred(_owner, address(0));
257         _owner = address(0);
258     }
259 
260     function transferOwnership(address newOwner) public virtual onlyOwner {
261         require(newOwner != address(0), "Ownable: new owner is the zero address");
262         emit OwnershipTransferred(_owner, newOwner);
263         _owner = newOwner;
264     }
265 }
266 
267 interface IDexRouter {
268     function factory() external pure returns (address);
269     function WETH() external pure returns (address);
270     
271     function swapExactTokensForETHSupportingFeeOnTransferTokens(
272         uint amountIn,
273         uint amountOutMin,
274         address[] calldata path,
275         address to,
276         uint deadline
277     ) external;
278 
279     function addLiquidityETH(
280         address token,
281         uint256 amountTokenDesired,
282         uint256 amountTokenMin,
283         uint256 amountETHMin,
284         address to,
285         uint256 deadline
286     )
287         external
288         payable
289         returns (
290             uint256 amountToken,
291             uint256 amountETH,
292             uint256 liquidity
293         );
294 }
295 
296 interface IDexFactory {
297     function createPair(address tokenA, address tokenB)
298         external
299         returns (address pair);
300 }
301 
302 contract MARLEY is ERC20, Ownable {
303 
304     uint256 public maxBuyAmount;
305     uint256 public maxSellAmount;
306     uint256 public maxWalletAmount;
307 
308     IDexRouter public immutable uniswapV2Router;
309     address public immutable uniswapV2Pair;
310 
311     bool private swapping;
312     uint256 public swapTokensAtAmount;
313 
314     address public marketingAddress;
315 
316 
317 
318     bool public tradingActive = false;
319     bool public swapEnabled = false;
320     
321   
322 
323     uint256 private buyTotalFees;
324     uint256 public buyMarketingFee;
325     uint256 public buyLiquidityFee;
326     uint256 public buyBurnFee;
327 
328 
329     uint256 private sellTotalFees;
330     uint256 public sellMarketingFee;
331     uint256 public sellLiquidityFee;
332     uint256 public sellBurnFee;
333 
334 
335     uint256 public tokensForMarketing;
336     uint256 public tokensForLiquidity;
337     uint256 public tokensForBurn;
338 
339     
340     /******************/
341 
342     //exlcude from fees and max transaction amount
343     mapping (address => bool) private _isExcludedFromFees;
344     mapping (address => bool) public _isExcludedMaxTransactionAmount;
345 
346 
347     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
348     // could be subject to a maximum transfer amount
349     mapping (address => bool) public automatedMarketMakerPairs;
350 
351     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
352 
353     event EnabledTrading();
354 
355     event ExcludeFromFees(address indexed account, bool isExcluded);
356 
357     event UpdatedMaxBuyAmount(uint256 newAmount);
358 
359     event UpdatedMaxSellAmount(uint256 newAmount);
360 
361     event UpdatedMaxWalletAmount(uint256 newAmount);
362 
363     event UpdatedMarketingAddress(address indexed newWallet);
364 
365 
366 
367 
368     event MaxTransactionExclusion(address _address, bool excluded);
369 
370     event SwapAndLiquify(
371         uint256 tokensSwapped,
372         uint256 ethReceived,
373         uint256 tokensIntoLiquidity
374     );
375 
376     event TransferForeignToken(address token, uint256 amount);
377 
378     constructor() ERC20("Marley", "MARLEY") {
379         
380         address newOwner = msg.sender; // can leave alone if owner is deployer.
381         
382         IDexRouter _uniswapV2Router = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
383 
384         _excludeFromMaxTransaction(address(_uniswapV2Router), true);
385         uniswapV2Router = _uniswapV2Router;
386         
387         uniswapV2Pair = IDexFactory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
388         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
389  
390         uint256 totalSupply = 10000000000 * 1e18;
391         
392         maxBuyAmount = totalSupply * 100 / 100;
393         maxSellAmount = totalSupply * 100 / 100;
394         maxWalletAmount = totalSupply * 100 / 100;
395         swapTokensAtAmount = totalSupply * 100 / 100000; // 0.1% swap amount
396 
397         buyMarketingFee = 4;
398         buyLiquidityFee = 1;
399         buyBurnFee = 1;
400         buyTotalFees = buyMarketingFee + buyLiquidityFee;
401 
402         sellMarketingFee = 4;
403         sellLiquidityFee = 1;
404         sellBurnFee = 1;
405         sellTotalFees = sellMarketingFee + sellLiquidityFee;
406 
407         _excludeFromMaxTransaction(newOwner, true);
408         _excludeFromMaxTransaction(address(this), true);
409         _excludeFromMaxTransaction(address(0xdead), true);
410 
411         excludeFromFees(newOwner, true);
412         excludeFromFees(address(this), true);
413         excludeFromFees(address(0xdead), true);
414 
415         marketingAddress = 0x5D282f41fc77A7514A9454669fE52BBe61758848;
416 
417 
418         _createInitialSupply(newOwner, totalSupply);
419         transferOwnership(newOwner);
420     }
421 
422     receive() external payable {}
423 
424     // once enabled, can never be turned off
425     function enableTrading() external onlyOwner {
426         require(!tradingActive, "Cannot reenable trading");
427         tradingActive = true;
428         swapEnabled = true;
429         emit EnabledTrading();
430     }
431          
432     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
433         require(newNum >= (totalSupply() * 25 / 10000)/1e18, "Cannot set maxBuy lower than 0.25%");
434         maxBuyAmount = newNum * (10**18);
435         emit UpdatedMaxBuyAmount(maxBuyAmount);
436     }
437     
438     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
439         require(newNum >= (totalSupply() * 25 / 10000)/1e18, "Cannot set maxSell lower than 0.25%");
440         maxSellAmount = newNum * (10**18);
441         emit UpdatedMaxSellAmount(maxSellAmount);
442     }
443 
444     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
445         require(newNum >= (totalSupply() * 25 / 10000)/1e18, "Cannot set maxWallet lower than 0.25%");
446         maxWalletAmount = newNum * (10**18);
447         emit UpdatedMaxWalletAmount(maxWalletAmount);
448     }
449 
450     // change the minimum amount of tokens to sell from fees
451     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
452         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
453         require(newAmount <= totalSupply() * 3 / 100, "Swap amount cannot be higher than 3% total supply.");
454   	    swapTokensAtAmount = newAmount * (10**18);
455   	}
456     
457     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
458         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
459         emit MaxTransactionExclusion(updAds, isExcluded);
460     }
461 
462         function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
463         if(!isEx){
464             require(updAds != uniswapV2Pair, "Cannot remove uniswap pair from max txn");
465         }
466         _isExcludedMaxTransactionAmount[updAds] = isEx;
467     }
468 
469     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
470         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
471 
472         _setAutomatedMarketMakerPair(pair, value);
473     }
474 
475     function _setAutomatedMarketMakerPair(address pair, bool value) private {
476         automatedMarketMakerPairs[pair] = value;
477         
478         _excludeFromMaxTransaction(pair, value);
479 
480         emit SetAutomatedMarketMakerPair(pair, value);
481     }
482 
483     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _burnFee) external onlyOwner {
484         buyMarketingFee = _marketingFee;
485         buyLiquidityFee = _liquidityFee;
486         buyBurnFee = _burnFee;
487         buyTotalFees = buyMarketingFee + buyLiquidityFee;
488         require((buyTotalFees + buyBurnFee) <= 25,"Total buy fees cannot be greater than 25%");
489     }
490 
491     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _burnFee) external onlyOwner {
492         sellMarketingFee = _marketingFee;
493         sellLiquidityFee = _liquidityFee;
494         sellBurnFee = _burnFee;
495         sellTotalFees = sellMarketingFee + sellLiquidityFee;
496         require((sellTotalFees + sellBurnFee) <= 25,"Total sell fees cannot be greater than 25%");
497     }
498 
499     function excludeFromFees(address account, bool excluded) public onlyOwner {
500         _isExcludedFromFees[account] = excluded;
501         emit ExcludeFromFees(account, excluded);
502     }
503 
504     function _transfer(address from, address to, uint256 amount) internal override {
505 
506         require(from != address(0), "ERC20: transfer from the zero address");
507         require(to != address(0), "ERC20: transfer to the zero address");
508         require(amount > 0, "amount must be greater than 0");
509                    
510     
511             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead)){
512                 if(!tradingActive){
513                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
514                 }
515                             
516                 //when buy
517                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
518                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
519                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
520                 } 
521                 //when sell
522                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
523                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
524                 } 
525                 else if (!_isExcludedMaxTransactionAmount[to] && !_isExcludedMaxTransactionAmount[from]){
526                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
527                 }
528             }
529         
530 
531         uint256 contractTokenBalance = balanceOf(address(this));
532         
533         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
534 
535         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
536             swapping = true;
537 
538             swapBack();
539 
540             swapping = false;
541         }
542 
543         bool takeFee = true;
544         // if any account belongs to _isExcludedFromFee account then remove the fee
545         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
546             takeFee = false;
547         }
548         
549         uint256 fees = 0;
550         // only take fees on buys/sells, do not take on wallet transfers
551         if(takeFee){
552             
553             // on sell
554              if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
555                 fees = amount * sellTotalFees /100;
556                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
557                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
558                 tokensForBurn += amount * sellBurnFee / 100;
559 
560             }
561             // on buy
562             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
563         	    fees = amount * buyTotalFees / 100;
564         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
565                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
566                 tokensForBurn += amount * sellBurnFee / 100;
567             }
568             
569             if(fees > 0){    
570                  super._transfer(from, address(this), fees);
571             }
572                 super._transfer(from, address(0xdead), tokensForBurn);
573 
574 
575         	amount -= (fees + tokensForBurn);
576             tokensForBurn = 0;
577         }
578             
579         super._transfer(from, to, amount);
580     }
581 
582     function swapTokensForEth(uint256 tokenAmount) private {
583 
584         // generate the uniswap pair path of token -> weth
585         address[] memory path = new address[](2);
586         path[0] = address(this);
587         path[1] = uniswapV2Router.WETH();
588 
589         _approve(address(this), address(uniswapV2Router), tokenAmount);
590 
591         // make the swap
592         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
593             tokenAmount,
594             0, // accept any amount of ETH
595             path,
596             address(this),
597             block.timestamp
598         );
599     }
600     
601     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
602         // approve token transfer to cover all possible scenarios
603         _approve(address(this), address(uniswapV2Router), tokenAmount);
604 
605         // add the liquidity
606         uniswapV2Router.addLiquidityETH{value: ethAmount}(
607             address(this),
608             tokenAmount,
609             0, // slippage is unavoidable
610             0, // slippage is unavoidable
611             address(owner()),
612             block.timestamp
613         );
614     }
615 
616     function swapBack() private {
617         uint256 contractBalance = balanceOf(address(this));
618         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
619         
620         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
621 
622         if(contractBalance > swapTokensAtAmount * 10){
623             contractBalance = swapTokensAtAmount * 10;
624         }
625 
626         bool success;
627         
628         // Halve the amount of liquidity tokens
629         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
630         
631         swapTokensForEth(contractBalance - liquidityTokens); 
632         
633         uint256 ethBalance = address(this).balance;
634         uint256 ethForLiquidity = ethBalance;
635 
636         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
637 
638         ethForLiquidity -= ethForMarketing;
639             
640         tokensForLiquidity = 0;
641         tokensForMarketing = 0;
642 
643         
644         if(liquidityTokens > 0 && ethForLiquidity > 0){
645             addLiquidity(liquidityTokens, ethForLiquidity);
646         }
647 
648         (success,) = address(marketingAddress).call{value: address(this).balance}("");
649     }
650 
651     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
652         require(_token != address(this), "Can't withdraw native tokens");
653         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
654         _sent = IERC20(_token).transfer(_to, _contractBalance);
655         emit TransferForeignToken(_token, _contractBalance);
656     }
657 
658     // withdraw ETH if stuck or someone sends to the address
659     function withdrawStuckETH() external onlyOwner {
660         bool success;
661         (success,) = address(msg.sender).call{value: address(this).balance}("");
662     }
663 
664     function setMarketingAddress(address _marketingAddress) external onlyOwner {
665         require(_marketingAddress != address(0), "_marketingAddress address cannot be 0");
666         marketingAddress = payable(_marketingAddress);
667         emit UpdatedMarketingAddress(_marketingAddress);
668     }
669 
670 }