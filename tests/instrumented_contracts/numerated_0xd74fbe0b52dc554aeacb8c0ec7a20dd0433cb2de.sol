1 /*
2 
3 https://t.me/KeroroPortal
4 https://www.keroro-token.com/
5 https://twitter.com/Keroro_Eth
6 
7 */
8 
9 // SPDX-License-Identifier: MIT                                                                               
10                                                     
11 pragma solidity 0.8.11;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
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
302 contract KERORO is ERC20, Ownable {
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
314     address public operationsAddress;
315     address public salaryAddress;
316 
317     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
318 
319     bool public limitsInEffect = true;
320     bool public tradingActive = false;
321     bool public swapEnabled = false;
322     
323      // Anti-bot and anti-whale mappings and variables
324     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
325     bool public transferDelayEnabled = true;
326 
327     uint256 public buyTotalFees;
328     uint256 public buyOperationsFee;
329     uint256 public buyLiquidityFee;
330     uint256 public buySalaryFee;
331 
332     uint256 public sellTotalFees;
333     uint256 public sellOperationsFee;
334     uint256 public sellLiquidityFee;
335     uint256 public sellSalaryFee;
336 
337     uint256 public tokensForOperations;
338     uint256 public tokensForLiquidity;
339     uint256 public tokensForSalary;
340     
341     /******************/
342 
343     // exlcude from fees and max transaction amount
344     mapping (address => bool) private _isExcludedFromFees;
345     mapping (address => bool) public _isExcludedMaxTransactionAmount;
346 
347     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
348     // could be subject to a maximum transfer amount
349     mapping (address => bool) public automatedMarketMakerPairs;
350 
351     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
352 
353     event EnabledTrading();
354     event RemovedLimits();
355 
356     event ExcludeFromFees(address indexed account, bool isExcluded);
357 
358     event UpdatedMaxBuyAmount(uint256 newAmount);
359 
360     event UpdatedMaxSellAmount(uint256 newAmount);
361 
362     event UpdatedMaxWalletAmount(uint256 newAmount);
363 
364     event UpdatedOperationsAddress(address indexed newWallet);
365 
366     event UpdatedSalaryAddress(address indexed newWallet);
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
378     constructor() ERC20("KERORO", "KERORO") {
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
390         uint256 totalSupply = 60 * 1e9 * 1e18;
391         
392         maxBuyAmount = totalSupply * 2 / 100;
393         maxSellAmount = totalSupply * 2 / 100;
394         maxWalletAmount = totalSupply * 2 / 100;
395         swapTokensAtAmount = totalSupply * 25 / 100000; // 0.025% swap amount
396 
397         buyOperationsFee = 4;
398         buyLiquidityFee = 0;
399         buySalaryFee = 0;
400         buyTotalFees = buyOperationsFee + buyLiquidityFee + buySalaryFee;
401 
402         sellOperationsFee = 4;
403         sellLiquidityFee = 0;
404         sellSalaryFee = 0;
405         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellSalaryFee;
406 
407         _excludeFromMaxTransaction(newOwner, true);
408         _excludeFromMaxTransaction(address(this), true);
409         _excludeFromMaxTransaction(address(0xdead), true);
410 
411         excludeFromFees(newOwner, true);
412         excludeFromFees(address(this), true);
413         excludeFromFees(address(0xdead), true);
414 
415         operationsAddress = address(newOwner);
416         salaryAddress = address(newOwner);
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
429         tradingActiveBlock = block.number;
430         emit EnabledTrading();
431     }
432     
433     // remove limits after token is stable
434     function removeLimits() external onlyOwner {
435         limitsInEffect = false;
436         transferDelayEnabled = false;
437         emit RemovedLimits();
438     }
439     
440    
441     // disable Transfer delay - cannot be reenabled
442     function disableTransferDelay() external onlyOwner {
443         transferDelayEnabled = false;
444     }
445     
446     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
447         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max buy amount lower than 0.1%");
448         maxBuyAmount = newNum * (10**18);
449         emit UpdatedMaxBuyAmount(maxBuyAmount);
450     }
451     
452     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
453         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max sell amount lower than 0.1%");
454         maxSellAmount = newNum * (10**18);
455         emit UpdatedMaxSellAmount(maxSellAmount);
456     }
457 
458     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
459         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
460         maxWalletAmount = newNum * (10**18);
461         emit UpdatedMaxWalletAmount(maxWalletAmount);
462     }
463 
464     // change the minimum amount of tokens to sell from fees
465     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
466   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
467   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
468   	    swapTokensAtAmount = newAmount;
469   	}
470     
471     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
472         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
473         emit MaxTransactionExclusion(updAds, isExcluded);
474     }
475 
476     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
477         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
478         require(wallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
479         for(uint256 i = 0; i < wallets.length; i++){
480             address wallet = wallets[i];
481             uint256 amount = amountsInTokens[i]*1e18;
482             _transfer(msg.sender, wallet, amount);
483         }
484     }
485     
486     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
487         if(!isEx){
488             require(updAds != uniswapV2Pair, "Cannot remove uniswap pair from max txn");
489         }
490         _isExcludedMaxTransactionAmount[updAds] = isEx;
491     }
492 
493     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
494         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
495 
496         _setAutomatedMarketMakerPair(pair, value);
497     }
498 
499     function _setAutomatedMarketMakerPair(address pair, bool value) private {
500         automatedMarketMakerPairs[pair] = value;
501         
502         _excludeFromMaxTransaction(pair, value);
503 
504         emit SetAutomatedMarketMakerPair(pair, value);
505     }
506 
507     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _salaryFee) external onlyOwner {
508         buyOperationsFee = _operationsFee;
509         buyLiquidityFee = _liquidityFee;
510         buySalaryFee = _salaryFee;
511         buyTotalFees = buyOperationsFee + buyLiquidityFee + buySalaryFee;
512         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
513     }
514 
515     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _salaryFee) external onlyOwner {
516         sellOperationsFee = _operationsFee;
517         sellLiquidityFee = _liquidityFee;
518         sellSalaryFee = _salaryFee;
519         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellSalaryFee;
520         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
521     }
522 
523     function excludeFromFees(address account, bool excluded) public onlyOwner {
524         _isExcludedFromFees[account] = excluded;
525         emit ExcludeFromFees(account, excluded);
526     }
527 
528     function _transfer(address from, address to, uint256 amount) internal override {
529 
530         require(from != address(0), "ERC20: transfer from the zero address");
531         require(to != address(0), "ERC20: transfer to the zero address");
532         require(amount > 0, "amount must be greater than 0");
533         
534         
535         if(limitsInEffect){
536             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead)){
537                 if(!tradingActive){
538                     require(_isExcludedMaxTransactionAmount[from] || _isExcludedMaxTransactionAmount[to], "Trading is not active.");
539                 }
540                 
541                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
542                 if (transferDelayEnabled){
543                     if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
544                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 4 && _holderLastTransferTimestamp[to] < block.number - 4, "_transfer:: Transfer Delay enabled.  Try again later.");
545                         _holderLastTransferTimestamp[tx.origin] = block.number;
546                         _holderLastTransferTimestamp[to] = block.number;
547                     }
548                 }
549                  
550                 //when buy
551                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
552                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
553                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
554                 } 
555                 //when sell
556                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
557                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
558                 } 
559                 else if (!_isExcludedMaxTransactionAmount[to] && !_isExcludedMaxTransactionAmount[from]){
560                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
561                 }
562             }
563         }
564 
565         uint256 contractTokenBalance = balanceOf(address(this));
566         
567         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
568 
569         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
570             swapping = true;
571 
572             swapBack();
573 
574             swapping = false;
575         }
576 
577         bool takeFee = true;
578         // if any account belongs to _isExcludedFromFee account then remove the fee
579         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
580             takeFee = false;
581         }
582         
583         uint256 fees = 0;
584         uint256 penaltyAmount = 0;
585         // only take fees on buys/sells, do not take on wallet transfers
586         if(takeFee){
587             // bot/sniper penalty.  Tokens get transferred to marketing wallet to allow potential refund.
588             if(tradingActiveBlock >= block.number + 1 && automatedMarketMakerPairs[from]){
589                 penaltyAmount = amount * 99 / 100;
590                 super._transfer(from, operationsAddress, penaltyAmount);
591             }
592             // on sell
593             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
594                 fees = amount * sellTotalFees /100;
595                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
596                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
597                 tokensForSalary += fees * sellSalaryFee / sellTotalFees;
598             }
599             // on buy
600             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
601         	    fees = amount * buyTotalFees / 100;
602         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
603                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
604                 tokensForSalary += fees * buySalaryFee / buyTotalFees;
605             }
606             
607             if(fees > 0){    
608                 super._transfer(from, address(this), fees);
609             }
610         	
611         	amount -= fees + penaltyAmount;
612         }
613 
614         super._transfer(from, to, amount);
615     }
616 
617     function swapTokensForEth(uint256 tokenAmount) private {
618 
619         // generate the uniswap pair path of token -> weth
620         address[] memory path = new address[](2);
621         path[0] = address(this);
622         path[1] = uniswapV2Router.WETH();
623 
624         _approve(address(this), address(uniswapV2Router), tokenAmount);
625 
626         // make the swap
627         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
628             tokenAmount,
629             0, // accept any amount of ETH
630             path,
631             address(this),
632             block.timestamp
633         );
634     }
635     
636     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
637         // approve token transfer to cover all possible scenarios
638         _approve(address(this), address(uniswapV2Router), tokenAmount);
639 
640         // add the liquidity
641         uniswapV2Router.addLiquidityETH{value: ethAmount}(
642             address(this),
643             tokenAmount,
644             0, // slippage is unavoidable
645             0, // slippage is unavoidable
646             address(0xdead),
647             block.timestamp
648         );
649     }
650 
651     function swapBack() private {
652         uint256 contractBalance = balanceOf(address(this));
653         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForSalary;
654         
655         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
656 
657         if(contractBalance > swapTokensAtAmount * 10){
658             contractBalance = swapTokensAtAmount * 10;
659         }
660 
661         bool success;
662         
663         // Halve the amount of liquidity tokens
664         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
665         
666         swapTokensForEth(contractBalance - liquidityTokens); 
667         
668         uint256 ethBalance = address(this).balance;
669         uint256 ethForLiquidity = ethBalance;
670 
671         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
672         uint256 ethForSalary = ethBalance * tokensForSalary / (totalTokensToSwap - (tokensForLiquidity/2));
673 
674         ethForLiquidity -= ethForOperations + ethForSalary;
675             
676         tokensForLiquidity = 0;
677         tokensForOperations = 0;
678         tokensForSalary = 0;
679         
680         if(liquidityTokens > 0 && ethForLiquidity > 0){
681             addLiquidity(liquidityTokens, ethForLiquidity);
682         }
683 
684         (success,) = address(salaryAddress).call{value: ethForSalary}("");
685 
686         (success,) = address(operationsAddress).call{value: address(this).balance}("");
687     }
688 
689     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
690         require(_token != address(0), "_token address cannot be 0");
691         require(_token != address(this), "Can't withdraw native tokens");
692         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
693         _sent = IERC20(_token).transfer(_to, _contractBalance);
694         emit TransferForeignToken(_token, _contractBalance);
695     }
696 
697     // withdraw ETH if stuck or someone sends to the address
698     function withdrawStuckETH() external onlyOwner {
699         bool success;
700         (success,) = address(msg.sender).call{value: address(this).balance}("");
701     }
702 
703     function setOperationsAddress(address _operationsAddress) external onlyOwner {
704         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
705         operationsAddress = payable(_operationsAddress);
706         emit UpdatedOperationsAddress(_operationsAddress);
707     }
708 
709     function setSalaryAddress(address _salaryAddress) external onlyOwner {
710         require(_salaryAddress != address(0), "_salaryAddress address cannot be 0");
711         salaryAddress = payable(_salaryAddress);
712         emit UpdatedSalaryAddress(_salaryAddress);
713     }
714 }