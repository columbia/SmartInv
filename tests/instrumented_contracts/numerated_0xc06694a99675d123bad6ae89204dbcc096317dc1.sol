1 // SPDX-License-Identifier: MIT                                                                               
2                                                     
3 pragma solidity 0.8.11;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a {Transfer} event.
33      */
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     /**
37      * @dev Returns the remaining number of tokens that `spender` will be
38      * allowed to spend on behalf of `owner` through {transferFrom}. This is
39      * zero by default.
40      *
41      * This value changes when {approve} or {transferFrom} are called.
42      */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * IMPORTANT: Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an {Approval} event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transferFrom(
71         address sender,
72         address recipient,
73         uint256 amount
74     ) external returns (bool);
75 
76     /**
77      * @dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to {approve}. `value` is the new allowance.
87      */
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 interface IERC20Metadata is IERC20 {
92     /**
93      * @dev Returns the name of the token.
94      */
95     function name() external view returns (string memory);
96 
97     /**
98      * @dev Returns the symbol of the token.
99      */
100     function symbol() external view returns (string memory);
101 
102     /**
103      * @dev Returns the decimals places of the token.
104      */
105     function decimals() external view returns (uint8);
106 }
107 
108 contract ERC20 is Context, IERC20, IERC20Metadata {
109     mapping(address => uint256) private _balances;
110 
111     mapping(address => mapping(address => uint256)) private _allowances;
112 
113     uint256 private _totalSupply;
114 
115     string private _name;
116     string private _symbol;
117 
118     constructor(string memory name_, string memory symbol_) {
119         _name = name_;
120         _symbol = symbol_;
121     }
122 
123     function name() public view virtual override returns (string memory) {
124         return _name;
125     }
126 
127     function symbol() public view virtual override returns (string memory) {
128         return _symbol;
129     }
130 
131     function decimals() public view virtual override returns (uint8) {
132         return 18;
133     }
134 
135     function totalSupply() public view virtual override returns (uint256) {
136         return _totalSupply;
137     }
138 
139     function balanceOf(address account) public view virtual override returns (uint256) {
140         return _balances[account];
141     }
142 
143     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
144         _transfer(_msgSender(), recipient, amount);
145         return true;
146     }
147 
148     function allowance(address owner, address spender) public view virtual override returns (uint256) {
149         return _allowances[owner][spender];
150     }
151 
152     function approve(address spender, uint256 amount) public virtual override returns (bool) {
153         _approve(_msgSender(), spender, amount);
154         return true;
155     }
156 
157     function transferFrom(
158         address sender,
159         address recipient,
160         uint256 amount
161     ) public virtual override returns (bool) {
162         _transfer(sender, recipient, amount);
163 
164         uint256 currentAllowance = _allowances[sender][_msgSender()];
165         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
166         unchecked {
167             _approve(sender, _msgSender(), currentAllowance - amount);
168         }
169 
170         return true;
171     }
172 
173     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
174         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
175         return true;
176     }
177 
178     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
179         uint256 currentAllowance = _allowances[_msgSender()][spender];
180         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
181         unchecked {
182             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
183         }
184 
185         return true;
186     }
187 
188     function _transfer(
189         address sender,
190         address recipient,
191         uint256 amount
192     ) internal virtual {
193         require(sender != address(0), "ERC20: transfer from the zero address");
194         require(recipient != address(0), "ERC20: transfer to the zero address");
195 
196         uint256 senderBalance = _balances[sender];
197         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
198         unchecked {
199             _balances[sender] = senderBalance - amount;
200         }
201         _balances[recipient] += amount;
202 
203         emit Transfer(sender, recipient, amount);
204     }
205 
206     function _createInitialSupply(address account, uint256 amount) internal virtual {
207         require(account != address(0), "ERC20: mint to the zero address");
208 
209         _totalSupply += amount;
210         _balances[account] += amount;
211         emit Transfer(address(0), account, amount);
212     }
213 
214     function _approve(
215         address owner,
216         address spender,
217         uint256 amount
218     ) internal virtual {
219         require(owner != address(0), "ERC20: approve from the zero address");
220         require(spender != address(0), "ERC20: approve to the zero address");
221 
222         _allowances[owner][spender] = amount;
223         emit Approval(owner, spender, amount);
224     }
225 }
226 
227 contract Ownable is Context {
228     address private _owner;
229 
230     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
231     
232     constructor () {
233         address msgSender = _msgSender();
234         _owner = msgSender;
235         emit OwnershipTransferred(address(0), msgSender);
236     }
237 
238     function owner() public view returns (address) {
239         return _owner;
240     }
241 
242     modifier onlyOwner() {
243         require(_owner == _msgSender(), "Ownable: caller is not the owner");
244         _;
245     }
246 
247     function renounceOwnership() external virtual onlyOwner {
248         emit OwnershipTransferred(_owner, address(0));
249         _owner = address(0);
250     }
251 
252     function transferOwnership(address newOwner) public virtual onlyOwner {
253         require(newOwner != address(0), "Ownable: new owner is the zero address");
254         emit OwnershipTransferred(_owner, newOwner);
255         _owner = newOwner;
256     }
257 }
258 
259 interface IDexRouter {
260     function factory() external pure returns (address);
261     function WETH() external pure returns (address);
262     
263     function swapExactTokensForETHSupportingFeeOnTransferTokens(
264         uint amountIn,
265         uint amountOutMin,
266         address[] calldata path,
267         address to,
268         uint deadline
269     ) external;
270 
271     function addLiquidityETH(
272         address token,
273         uint256 amountTokenDesired,
274         uint256 amountTokenMin,
275         uint256 amountETHMin,
276         address to,
277         uint256 deadline
278     )
279         external
280         payable
281         returns (
282             uint256 amountToken,
283             uint256 amountETH,
284             uint256 liquidity
285         );
286 }
287 
288 interface IDexFactory {
289     function createPair(address tokenA, address tokenB)
290         external
291         returns (address pair);
292 }
293 
294 contract ShibaCapital is ERC20, Ownable {
295 
296     uint256 public maxBuyAmount;
297     uint256 public maxSellAmount;
298     uint256 public maxWalletAmount;
299 
300     IDexRouter public immutable uniswapV2Router;
301     address public immutable uniswapV2Pair;
302 
303     bool private swapping;
304     uint256 public swapTokensAtAmount;
305 
306     address public treasuryAddress;
307     address public cliffAddress;
308 
309     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
310 
311     bool public limitsInEffect = true;
312     bool public tradingActive = false;
313     bool public swapEnabled = true;
314     
315      // Anti-bot and anti-whale mappings and variables
316     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
317     bool public transferDelayEnabled = true;
318 
319     uint256 public buyTotalFees;
320     uint256 public buyTreasuryFee;
321     uint256 public buyLiquidityFee;
322     uint256 public buyCliffFee;
323 
324     uint256 public sellTotalFees;
325     uint256 public sellTreasuryFee;
326     uint256 public sellLiquidityFee;
327     uint256 public sellCliffFee;
328 
329     uint256 public tokensForTreasury;
330     uint256 public tokensForLiquidity;
331     uint256 public tokensForCliff;
332     
333     /******************/
334 
335     // exlcude from fees and max transaction amount
336     mapping (address => bool) private _isExcludedFromFees;
337     mapping (address => bool) public _isExcludedMaxTransactionAmount;
338 
339     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
340     // could be subject to a maximum transfer amount
341     mapping (address => bool) public automatedMarketMakerPairs;
342 
343     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
344 
345     event EnabledTrading();
346     event RemovedLimits();
347 
348     event ExcludeFromFees(address indexed account, bool isExcluded);
349 
350     event UpdatedMaxBuyAmount(uint256 newAmount);
351 
352     event UpdatedMaxSellAmount(uint256 newAmount);
353 
354     event UpdatedMaxWalletAmount(uint256 newAmount);
355 
356     event UpdatedTreasuryAddress(address indexed newWallet);
357 
358     //event UpdatedCliffAddress(address indexed newWallet);
359 
360     event MaxTransactionExclusion(address _address, bool excluded);
361 
362     event SwapAndLiquify(
363         uint256 tokensSwapped,
364         uint256 ethReceived,
365         uint256 tokensIntoLiquidity
366     );
367 
368     event TransferForeignToken(address token, uint256 amount);
369 
370     constructor() ERC20("SHIBACAPITAL", "SHIBACAP") {
371         
372         address newOwner = 0xeD9d43Ac63026619eA40500899609b62240105F3; // can leave alone if owner is deployer.
373         
374         IDexRouter _uniswapV2Router = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
375 
376         _excludeFromMaxTransaction(address(_uniswapV2Router), true);
377         uniswapV2Router = _uniswapV2Router;
378         
379         uniswapV2Pair = IDexFactory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
380         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
381  
382         uint256 totalSupply =  100 * 1e11 * 1e18;
383         
384         maxBuyAmount = totalSupply * 1 / 1000;
385         maxSellAmount = totalSupply * 1 / 1000;
386         maxWalletAmount = totalSupply * 3 / 1000;
387         swapTokensAtAmount = totalSupply * 25 / 100000; // 0.025% swap amount
388         
389         buyTreasuryFee = 5;
390         buyLiquidityFee = 5;
391         buyCliffFee = 2;
392         buyTotalFees = buyTreasuryFee + buyLiquidityFee + buyCliffFee;
393 
394         sellTreasuryFee = 8;
395         sellLiquidityFee = 6;
396         sellCliffFee = 2;
397         sellTotalFees = sellTreasuryFee + sellLiquidityFee + sellCliffFee;
398 
399         _excludeFromMaxTransaction(newOwner, true);
400         _excludeFromMaxTransaction(address(this), true);
401         _excludeFromMaxTransaction(address(0xdead), true);
402 
403         excludeFromFees(newOwner, true);
404         excludeFromFees(address(this), true);
405         excludeFromFees(address(0xdead), true);
406 
407         treasuryAddress = address(newOwner);
408         cliffAddress = 0x81ed317154E4C6E829B0358F59C5578719E95ccB;
409         
410         _createInitialSupply(newOwner, totalSupply);
411         transferOwnership(newOwner);
412     }
413 
414     receive() external payable {}
415 
416     // once enabled, can never be turned off
417     function enableTrading() external onlyOwner {
418         require(!tradingActive, "Cannot reenable trading");
419         tradingActive = true;
420         swapEnabled = true;
421         tradingActiveBlock = block.number;
422         emit EnabledTrading();
423     }
424     
425     // remove limits after token is stable
426     function removeLimits() external onlyOwner {
427         limitsInEffect = false;
428         transferDelayEnabled = false;
429         emit RemovedLimits();
430     }
431     
432    
433     // disable Transfer delay - cannot be reenabled
434     function disableTransferDelay() external onlyOwner {
435         transferDelayEnabled = false;
436     }
437     
438     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
439         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max buy amount lower than 0.1%");
440         maxBuyAmount = newNum * (10**18);
441         emit UpdatedMaxBuyAmount(maxBuyAmount);
442     }
443     
444     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
445         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max sell amount lower than 0.1%");
446         maxSellAmount = newNum * (10**18);
447         emit UpdatedMaxSellAmount(maxSellAmount);
448     }
449 
450     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
451         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
452         maxWalletAmount = newNum * (10**18);
453         emit UpdatedMaxWalletAmount(maxWalletAmount);
454     }
455 
456     // change the minimum amount of tokens to sell from fees
457     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
458   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
459   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
460   	    swapTokensAtAmount = newAmount;
461   	}
462     
463     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
464         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
465         emit MaxTransactionExclusion(updAds, isExcluded);
466     }
467 
468     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
469         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
470         require(wallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
471         for(uint256 i = 0; i < wallets.length; i++){
472             address wallet = wallets[i];
473             uint256 amount = amountsInTokens[i]*1e18;
474             _transfer(msg.sender, wallet, amount);
475         }
476     }
477     
478     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
479         if(!isEx){
480             require(updAds != uniswapV2Pair, "Cannot remove uniswap pair from max txn");
481         }
482         _isExcludedMaxTransactionAmount[updAds] = isEx;
483     }
484 
485     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
486         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
487 
488         _setAutomatedMarketMakerPair(pair, value);
489     }
490 
491     function _setAutomatedMarketMakerPair(address pair, bool value) private {
492         automatedMarketMakerPairs[pair] = value;
493         
494         _excludeFromMaxTransaction(pair, value);
495 
496         emit SetAutomatedMarketMakerPair(pair, value);
497     }
498 
499     function updateBuyFees(uint256 _treasuryFee, uint256 _liquidityFee /*uint256 _cliffFee*/) external onlyOwner {
500         buyTreasuryFee = _treasuryFee;
501         buyLiquidityFee = _liquidityFee;
502         //buyCliffFee = _cliffFee;
503         buyTotalFees = buyTreasuryFee + buyLiquidityFee /*+ buyCliffFee*/;
504         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
505     }
506 
507     function updateSellFees(uint256 _treasuryFee, uint256 _liquidityFee /*, uint256 _cliffFee*/) external onlyOwner {
508         sellTreasuryFee = _treasuryFee;
509         sellLiquidityFee = _liquidityFee;
510         //sellCliffFee = _cliffFee;
511         sellTotalFees = sellTreasuryFee + sellLiquidityFee /*+ sellCliffFee*/;
512         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
513     }
514 
515     function excludeFromFees(address account, bool excluded) public onlyOwner {
516         _isExcludedFromFees[account] = excluded;
517         emit ExcludeFromFees(account, excluded);
518     }
519 
520     function _transfer(address from, address to, uint256 amount) internal override {
521 
522         require(from != address(0), "ERC20: transfer from the zero address");
523         require(to != address(0), "ERC20: transfer to the zero address");
524         require(amount > 0, "amount must be greater than 0");
525         
526         
527         if(limitsInEffect){
528             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead)){
529                 if(!tradingActive){
530                     require(_isExcludedMaxTransactionAmount[from] || _isExcludedMaxTransactionAmount[to], "Trading is not active.");
531                 }
532                 
533                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
534                 if (transferDelayEnabled){
535                     if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
536                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 4 && _holderLastTransferTimestamp[to] < block.number - 4, "_transfer:: Transfer Delay enabled.  Try again later.");
537                         _holderLastTransferTimestamp[tx.origin] = block.number;
538                         _holderLastTransferTimestamp[to] = block.number;
539                     }
540                 }
541                  
542                 //when buy
543                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
544                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
545                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
546                 } 
547                 //when sell
548                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
549                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
550                 } 
551                 else if (!_isExcludedMaxTransactionAmount[to] && !_isExcludedMaxTransactionAmount[from]){
552                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
553                 }
554             }
555         }
556 
557         uint256 contractTokenBalance = balanceOf(address(this));
558         
559         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
560 
561         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
562             swapping = true;
563 
564             swapBack();
565 
566             swapping = false;
567         }
568 
569         bool takeFee = true;
570         // if any account belongs to _isExcludedFromFee account then remove the fee
571         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
572             takeFee = false;
573         }
574         
575         uint256 fees = 0;
576         uint256 penaltyAmount = 0;
577         // only take fees on buys/sells, do not take on wallet transfers
578         if(takeFee){
579             // bot/sniper penalty.  Tokens get transferred to marketing wallet to allow potential refund.
580             if(tradingActiveBlock >= block.number + 1 && automatedMarketMakerPairs[from]){
581                 penaltyAmount = amount * 99 / 100;
582                 super._transfer(from, treasuryAddress, penaltyAmount);
583             }
584             // on sell
585             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
586                 fees = amount * sellTotalFees /100;
587                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
588                 tokensForTreasury += fees * sellTreasuryFee / sellTotalFees;
589                 tokensForCliff += fees * sellCliffFee / sellTotalFees;
590             }
591             // on buy
592             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
593         	    fees = amount * buyTotalFees / 100;
594         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
595                 tokensForTreasury += fees * buyTreasuryFee / buyTotalFees;
596                 tokensForCliff += fees * buyCliffFee / buyTotalFees;
597             }
598             
599             if(fees > 0){    
600                 super._transfer(from, address(this), fees);
601             }
602         	
603         	amount -= fees + penaltyAmount;
604         }
605 
606         super._transfer(from, to, amount);
607     }
608 
609     function swapTokensForEth(uint256 tokenAmount) private {
610 
611         // generate the uniswap pair path of token -> weth
612         address[] memory path = new address[](2);
613         path[0] = address(this);
614         path[1] = uniswapV2Router.WETH();
615 
616         _approve(address(this), address(uniswapV2Router), tokenAmount);
617 
618         // make the swap
619         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
620             tokenAmount,
621             0, // accept any amount of ETH
622             path,
623             address(this),
624             block.timestamp
625         );
626     }
627     
628     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
629         // approve token transfer to cover all possible scenarios
630         _approve(address(this), address(uniswapV2Router), tokenAmount);
631 
632         // add the liquidity
633         uniswapV2Router.addLiquidityETH{value: ethAmount}(
634             address(this),
635             tokenAmount,
636             0, // slippage is unavoidable
637             0, // slippage is unavoidable
638             address(0xdead),
639             block.timestamp
640         );
641     }
642 
643     function swapBack() private {
644         uint256 contractBalance = balanceOf(address(this));
645         uint256 totalTokensToSwap = tokensForLiquidity + tokensForTreasury + tokensForCliff;
646         
647         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
648 
649         if(contractBalance > swapTokensAtAmount * 10){
650             contractBalance = swapTokensAtAmount * 10;
651         }
652 
653         bool success;
654         
655         // Halve the amount of liquidity tokens
656         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
657         
658         swapTokensForEth(contractBalance - liquidityTokens); 
659         
660         uint256 ethBalance = address(this).balance;
661         uint256 ethForLiquidity = ethBalance;
662 
663         uint256 ethForTreasury = ethBalance * tokensForTreasury / (totalTokensToSwap - (tokensForLiquidity/2));
664         uint256 ethForCliff = ethBalance * tokensForCliff / (totalTokensToSwap - (tokensForLiquidity/2));
665 
666         ethForLiquidity -= ethForTreasury + ethForCliff;
667             
668         tokensForLiquidity = 0;
669         tokensForTreasury = 0;
670         tokensForCliff = 0;
671         
672         if(liquidityTokens > 0 && ethForLiquidity > 0){
673             addLiquidity(liquidityTokens, ethForLiquidity);
674         }
675 
676         (success,) = address(cliffAddress).call{value: ethForCliff}("");
677 
678         (success,) = address(treasuryAddress).call{value: address(this).balance}("");
679     }
680 
681     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
682         require(_token != address(0), "_token address cannot be 0");
683         require(_token != address(this), "Can't withdraw native tokens");
684         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
685         _sent = IERC20(_token).transfer(_to, _contractBalance);
686         emit TransferForeignToken(_token, _contractBalance);
687     }
688 
689     // withdraw ETH if stuck or someone sends to the address
690     function withdrawStuckETH() external onlyOwner {
691         bool success;
692         (success,) = address(msg.sender).call{value: address(this).balance}("");
693     }
694 
695     function setTreasuryAddress(address _treasuryAddress) external onlyOwner {
696         require(_treasuryAddress != address(0), "_treasuryAddress address cannot be 0");
697         treasuryAddress = payable(_treasuryAddress);
698         emit UpdatedTreasuryAddress(_treasuryAddress);
699     }
700 
701     // function setCliffAddress(address _cliffAddress) external onlyOwner {
702     //     require(_cliffAddress != address(0), "_cliffAddress address cannot be 0");
703     //     cliffAddress = payable(_cliffAddress);
704     //     emit UpdatedCliffAddress(_cliffAddress);
705     // }
706 }