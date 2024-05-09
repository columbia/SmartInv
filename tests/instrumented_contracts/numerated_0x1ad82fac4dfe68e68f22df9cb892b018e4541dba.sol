1 // SPDX-License-Identifier: MIT                                                                               
2                                                     
3  pragma solidity 0.8.16;
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
294 contract MarblePrix is ERC20, Ownable {
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
306     address public developmentAddress;
307     address public marketingAddress;
308     address public liquidityAddress;
309 
310     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
311 
312     bool public limitsInEffect = true;
313     bool public tradingActive = false;
314     bool public swapEnabled = false;
315     
316      // Anti-bot and anti-whale mappings and variables
317     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
318     bool public transferDelayEnabled = true;
319 
320     uint256 public buyTotalFees;
321     uint256 public buyDevelopmentFee;
322     uint256 public buyLiquidityFee;
323     uint256 public buyMarketingFee;
324 
325     uint256 public sellTotalFees;
326     uint256 public sellDevelopmentFee;
327     uint256 public sellLiquidityFee;
328     uint256 public sellMarketingFee;
329 
330     uint256 public tokensForDevelopment;
331     uint256 public tokensForLiquidity;
332     uint256 public tokensForMarketing;
333 
334     uint256 public lpWithdrawRequestTimestamp;
335     uint256 public lpWithdrawRequestDuration = 30 days;
336     bool public lpWithdrawRequestPending;
337     uint256 public lpPercToWithDraw;
338     
339     /******************/
340 
341     // exlcude from fees and max transaction amount
342     mapping (address => bool) private _isExcludedFromFees;
343     mapping (address => bool) public _isExcludedMaxTransactionAmount;
344 
345     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
346     // could be subject to a maximum transfer amount
347     mapping (address => bool) public automatedMarketMakerPairs;
348 
349     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
350 
351     event EnabledTrading();
352     event RemovedLimits();
353 
354     event ExcludeFromFees(address indexed account, bool isExcluded);
355 
356     event UpdatedMaxBuyAmount(uint256 newAmount);
357 
358     event UpdatedMaxSellAmount(uint256 newAmount);
359 
360     event UpdatedMaxWalletAmount(uint256 newAmount);
361 
362     event UpdatedDevelopmentAddress(address indexed newWallet);
363 
364     event UpdatedMarketingAddress(address indexed newWallet);
365 
366     event UpdatedLiquidityAddress(address indexed newWallet);
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
378     event RequestedLPWithdraw();
379     event WithdrewLPForMigration();
380     event CanceledLpWithdrawRequest();
381 
382     constructor() ERC20("MARBLEPRIX7", "MARBLEX7") {
383         
384         address newOwner = msg.sender; // can leave alone if owner is deployer.
385         
386         IDexRouter _uniswapV2Router = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // 0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506
387 
388         _excludeFromMaxTransaction(address(_uniswapV2Router), true);
389         uniswapV2Router = _uniswapV2Router;
390         
391         uniswapV2Pair = IDexFactory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
392         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
393  
394         uint256 totalSupply = 5 * 1e8 * 1e18;
395         
396         maxBuyAmount = totalSupply * 10 / 1000;
397         maxSellAmount = totalSupply * 10 / 1000;
398         maxWalletAmount = totalSupply * 10 / 1000;
399         swapTokensAtAmount = totalSupply * 25 / 100000; // 0.025% swap amount
400 
401         buyDevelopmentFee = 300;
402         buyLiquidityFee = 10000;
403         buyMarketingFee = 800;
404         buyTotalFees = buyDevelopmentFee + buyLiquidityFee + buyMarketingFee;
405 
406         sellDevelopmentFee = 300;
407         sellLiquidityFee = 100;
408         sellMarketingFee = 800;
409         sellTotalFees = sellDevelopmentFee + sellLiquidityFee + sellMarketingFee;
410 
411         _excludeFromMaxTransaction(newOwner, true);
412         _excludeFromMaxTransaction(address(this), true);
413         _excludeFromMaxTransaction(address(0xdead), true);
414 
415         excludeFromFees(newOwner, true);
416         excludeFromFees(address(this), true);
417         excludeFromFees(address(0xdead), true);
418 
419         developmentAddress = address(newOwner);
420         marketingAddress = address(newOwner);
421         liquidityAddress = address(newOwner);
422         
423         _createInitialSupply(newOwner, totalSupply);
424         transferOwnership(newOwner);
425     }
426 
427     receive() external payable {}
428 
429     // once enabled, can never be turned off
430     function enableTrading() external onlyOwner {
431         require(!tradingActive, "Cannot reenable trading");
432         tradingActive = true;
433         swapEnabled = true;
434         tradingActiveBlock = block.number;
435         emit EnabledTrading();
436     }
437     
438     // remove limits after token is stable
439     function removeLimits() external onlyOwner {
440         limitsInEffect = false;
441         transferDelayEnabled = false;
442         emit RemovedLimits();
443     }
444     
445    
446     // disable Transfer delay - cannot be reenabled
447     function disableTransferDelay() external onlyOwner {
448         transferDelayEnabled = false;
449     }
450     
451     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
452         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max buy amount lower than 0.1%");
453         maxBuyAmount = newNum * (10**18);
454         emit UpdatedMaxBuyAmount(maxBuyAmount);
455     }
456     
457     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
458         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max sell amount lower than 0.1%");
459         maxSellAmount = newNum * (10**18);
460         emit UpdatedMaxSellAmount(maxSellAmount);
461     }
462 
463     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
464         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set max wallet amount lower than 0.5%");
465         maxWalletAmount = newNum * (10**18);
466         emit UpdatedMaxWalletAmount(maxWalletAmount);
467     }
468 
469     // change the minimum amount of tokens to sell from fees
470     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
471   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
472   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
473   	    swapTokensAtAmount = newAmount;
474   	}
475     
476     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
477         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
478         emit MaxTransactionExclusion(updAds, isExcluded);
479     }
480 
481     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
482         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
483         require(wallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
484         for(uint256 i = 0; i < wallets.length; i++){
485             address wallet = wallets[i];
486             uint256 amount = amountsInTokens[i]*1e18;
487             _transfer(msg.sender, wallet, amount);
488         }
489     }
490     
491     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
492         if(!isEx){
493             require(updAds != uniswapV2Pair, "Cannot remove uniswap pair from max txn");
494         }
495         _isExcludedMaxTransactionAmount[updAds] = isEx;
496     }
497 
498     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
499         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
500 
501         _setAutomatedMarketMakerPair(pair, value);
502     }
503 
504     function _setAutomatedMarketMakerPair(address pair, bool value) private {
505         automatedMarketMakerPairs[pair] = value;
506         
507         _excludeFromMaxTransaction(pair, value);
508 
509         emit SetAutomatedMarketMakerPair(pair, value);
510     }
511 
512     function updateBuyFees(uint256 _developmentFee, uint256 _liquidityFee, uint256 _marketingFee) external onlyOwner {
513         buyDevelopmentFee = _developmentFee;
514         buyLiquidityFee = _liquidityFee;
515         buyMarketingFee = _marketingFee;
516         buyTotalFees = buyDevelopmentFee + buyLiquidityFee + buyMarketingFee;
517         require(buyTotalFees <= 1500, "Must keep fees at 15% or less");
518     }
519 
520     function updateSellFees(uint256 _developmentFee, uint256 _liquidityFee, uint256 _marketingFee) external onlyOwner {
521         sellDevelopmentFee = _developmentFee;
522         sellLiquidityFee = _liquidityFee;
523         sellMarketingFee = _marketingFee;
524         sellTotalFees = sellDevelopmentFee + sellLiquidityFee + sellMarketingFee;
525         require(sellTotalFees <= 1500, "Must keep fees at 15% or less");
526     }
527 
528     function excludeFromFees(address account, bool excluded) public onlyOwner {
529         _isExcludedFromFees[account] = excluded;
530         emit ExcludeFromFees(account, excluded);
531     }
532 
533     function _transfer(address from, address to, uint256 amount) internal override {
534 
535         require(from != address(0), "ERC20: transfer from the zero address");
536         require(to != address(0), "ERC20: transfer to the zero address");
537         require(amount > 0, "amount must be greater than 0");
538         
539         
540         if(limitsInEffect){
541             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead)){
542                 if(!tradingActive){
543                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
544                 }
545                 
546                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
547                 if (transferDelayEnabled){
548                     if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
549                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 4 && _holderLastTransferTimestamp[to] < block.number - 4, "_transfer:: Transfer Delay enabled.  Try again later.");
550                         _holderLastTransferTimestamp[tx.origin] = block.number;
551                         _holderLastTransferTimestamp[to] = block.number;
552                     }
553                 }
554                  
555                 //when buy
556                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
557                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
558                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
559                 } 
560                 //when sell
561                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
562                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
563                 } 
564                 else if (!_isExcludedMaxTransactionAmount[to] && !_isExcludedMaxTransactionAmount[from]){
565                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
566                 }
567             }
568         }
569 
570         uint256 contractTokenBalance = balanceOf(address(this));
571         
572         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
573 
574         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
575             swapping = true;
576 
577             swapBack();
578 
579             swapping = false;
580         }
581 
582         bool takeFee = true;
583         // if any account belongs to _isExcludedFromFee account then remove the fee
584         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
585             takeFee = false;
586         }
587         
588         uint256 fees = 0;
589         uint256 penaltyAmount = 0;
590         // only take fees on buys/sells, do not take on wallet transfers
591         if(takeFee){
592             // bot/sniper penalty.  Tokens get transferred to marketing wallet to allow potential refund.
593             if(tradingActiveBlock >= block.number + 1 && automatedMarketMakerPairs[from]){
594                 penaltyAmount = amount * 99 / 100;
595                 super._transfer(from, developmentAddress, penaltyAmount);
596             }
597             // on sell
598             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
599                 fees = amount * sellTotalFees /10000;
600                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
601                 tokensForDevelopment += fees * sellDevelopmentFee / sellTotalFees;
602                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
603             }
604             // on buy
605             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
606         	    fees = amount * buyTotalFees / 10000;
607         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
608                 tokensForDevelopment += fees * buyDevelopmentFee / buyTotalFees;
609                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
610             }
611             
612             if(fees > 0){    
613                 super._transfer(from, address(this), fees);
614             }
615         	
616         	amount -= fees + penaltyAmount;
617         }
618 
619         super._transfer(from, to, amount);
620     }
621 
622     function swapTokensForEth(uint256 tokenAmount) private {
623 
624         // generate the uniswap pair path of token -> weth
625         address[] memory path = new address[](2);
626         path[0] = address(this);
627         path[1] = uniswapV2Router.WETH();
628 
629         _approve(address(this), address(uniswapV2Router), tokenAmount);
630 
631         // make the swap
632         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
633             tokenAmount,
634             0, // accept any amount of ETH
635             path,
636             address(this),
637             block.timestamp
638         );
639     }
640     
641     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
642         // approve token transfer to cover all possible scenarios
643         _approve(address(this), address(uniswapV2Router), tokenAmount);
644 
645         // add the liquidity
646         uniswapV2Router.addLiquidityETH{value: ethAmount}(
647             address(this),
648             tokenAmount,
649             0, // slippage is unavoidable
650             0, // slippage is unavoidable
651             address(liquidityAddress),
652             block.timestamp
653         );
654     }
655 
656     function swapBack() private {
657         uint256 contractBalance = balanceOf(address(this));
658         uint256 totalTokensToSwap = tokensForLiquidity + tokensForDevelopment + tokensForMarketing;
659         
660         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
661 
662         if(contractBalance > swapTokensAtAmount * 10){
663             contractBalance = swapTokensAtAmount * 10;
664         }
665 
666         bool success;
667         
668         // Halve the amount of liquidity tokens
669         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
670         
671         swapTokensForEth(contractBalance - liquidityTokens); 
672         
673         uint256 ethBalance = address(this).balance;
674         uint256 ethForLiquidity = ethBalance;
675 
676         uint256 ethForDevelopment = ethBalance * tokensForDevelopment / (totalTokensToSwap - (tokensForLiquidity/2));
677         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
678 
679         ethForLiquidity -= ethForDevelopment + ethForMarketing;
680             
681         tokensForLiquidity = 0;
682         tokensForDevelopment = 0;
683         tokensForMarketing = 0;
684         
685         if(liquidityTokens > 0 && ethForLiquidity > 0){
686             addLiquidity(liquidityTokens, ethForLiquidity);
687         }
688 
689         (success,) = address(marketingAddress).call{value: ethForMarketing}("");
690 
691         (success,) = address(developmentAddress).call{value: address(this).balance}("");
692     }
693 
694     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
695         require(_token != address(0), "_token address cannot be 0");
696         require(_token != address(this), "Can't withdraw native tokens");
697         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
698         _sent = IERC20(_token).transfer(_to, _contractBalance);
699         emit TransferForeignToken(_token, _contractBalance);
700     }
701 
702     // withdraw ETH if stuck or someone sends to the address
703     function withdrawStuckETH() external onlyOwner {
704         bool success;
705         (success,) = address(msg.sender).call{value: address(this).balance}("");
706     }
707 
708     function setDevelopmentAddress(address _developmentAddress) external onlyOwner {
709         require(_developmentAddress != address(0), "_developmentAddress address cannot be 0");
710         developmentAddress = payable(_developmentAddress);
711         emit UpdatedDevelopmentAddress(_developmentAddress);
712     }
713 
714     function setMarketingAddress(address _marketingAddress) external onlyOwner {
715         require(_marketingAddress != address(0), "_marketingAddress address cannot be 0");
716         marketingAddress = payable(_marketingAddress);
717         emit UpdatedMarketingAddress(_marketingAddress);
718     }
719 
720      function setLiquidityAddress(address _liquidityAddress) external onlyOwner {
721         require(_liquidityAddress != address(0), "address cannot be 0");
722         liquidityAddress = payable(_liquidityAddress);
723         emit UpdatedLiquidityAddress(_liquidityAddress);
724     }
725 
726     function requestToWithdrawLP(uint256 percToWithdraw) external onlyOwner {
727         require(!lpWithdrawRequestPending, "Cannot request again until first request is over.");
728         require(percToWithdraw <= 100 && percToWithdraw > 0, "Need to set between 1-100%");
729         lpWithdrawRequestTimestamp = block.timestamp;
730         lpWithdrawRequestPending = true;
731         lpPercToWithDraw = percToWithdraw;
732         emit RequestedLPWithdraw();
733     }
734 
735     function nextAvailableLpWithdrawDate() public view returns (uint256){
736         if(lpWithdrawRequestPending){
737             return lpWithdrawRequestTimestamp + lpWithdrawRequestDuration;
738         }
739         else {
740             return 0;  // 0 means no open requests
741         }
742     }
743 
744     function withdrawRequestedLP() external onlyOwner {
745         require(block.timestamp >= nextAvailableLpWithdrawDate() && nextAvailableLpWithdrawDate() > 0, "Must request and wait.");
746         lpWithdrawRequestTimestamp = 0;
747         lpWithdrawRequestPending = false;
748 
749         uint256 amtToWithdraw = IERC20(address(uniswapV2Pair)).balanceOf(address(this)) * lpPercToWithDraw / 100;
750         
751         lpPercToWithDraw = 0;
752 
753         IERC20(uniswapV2Pair).transfer(msg.sender, amtToWithdraw);
754     }
755 
756     function cancelLPWithdrawRequest() external onlyOwner {
757         lpWithdrawRequestPending = false;
758         lpPercToWithDraw = 0;
759         lpWithdrawRequestTimestamp = 0;
760         emit CanceledLpWithdrawRequest();
761     }
762 }