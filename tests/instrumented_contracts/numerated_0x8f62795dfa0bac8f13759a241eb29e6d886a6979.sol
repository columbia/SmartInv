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
294 contract MOCHI is ERC20, Ownable {
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
306     address public marketingAddress;
307     address public devAddress;
308 
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
319     bool botscantrade = false;
320     bool killBots = true;
321 
322 
323 
324     uint256 public buyTotalFees;
325     uint256 public buyMarketingFee;
326     uint256 public buyLiquidityFee;
327     uint256 public buyDevFee;
328 
329 
330     uint256 public sellTotalFees;
331     uint256 public sellMarketingFee;
332     uint256 public sellLiquidityFee;
333     uint256 public sellDevFee;
334 
335 
336     uint256 public tokensForMarketing;
337     uint256 public tokensForLiquidity;
338     uint256 public tokensForDev;
339 
340     
341     /******************/
342 
343     //exlcude from fees and max transaction amount
344     mapping (address => bool) private _isExcludedFromFees;
345     mapping (address => bool) public _isExcludedMaxTransactionAmount;
346     mapping (address => bool) private botWallets;
347 
348 
349     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
350     // could be subject to a maximum transfer amount
351     mapping (address => bool) public automatedMarketMakerPairs;
352 
353     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
354 
355     event EnabledTrading();
356     event RemovedLimits();
357 
358     event ExcludeFromFees(address indexed account, bool isExcluded);
359 
360     event UpdatedMaxBuyAmount(uint256 newAmount);
361 
362     event UpdatedMaxSellAmount(uint256 newAmount);
363 
364     event UpdatedMaxWalletAmount(uint256 newAmount);
365 
366     event UpdatedMarketingAddress(address indexed newWallet);
367 
368     event UpdatedDevAddress(address indexed newWallet);
369 
370 
371 
372     event MaxTransactionExclusion(address _address, bool excluded);
373 
374     event SwapAndLiquify(
375         uint256 tokensSwapped,
376         uint256 ethReceived,
377         uint256 tokensIntoLiquidity
378     );
379 
380     event TransferForeignToken(address token, uint256 amount);
381 
382     constructor() ERC20("MOCHI", "MOCHI") {
383         
384         address newOwner = msg.sender; // can leave alone if owner is deployer.
385         
386         IDexRouter _uniswapV2Router = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
387 
388         _excludeFromMaxTransaction(address(_uniswapV2Router), true);
389         uniswapV2Router = _uniswapV2Router;
390         
391         uniswapV2Pair = IDexFactory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
392         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
393  
394         uint256 totalSupply = 10 * 1e9 * 1e18;
395         
396         maxBuyAmount = totalSupply * 1 / 100;
397         maxSellAmount = totalSupply * 1 / 100;
398         maxWalletAmount = totalSupply * 2 / 100;
399         swapTokensAtAmount = totalSupply * 25 / 100000; // 0.025% swap amount
400 
401         buyMarketingFee = 5;
402         buyLiquidityFee = 4;
403         buyDevFee = 5;
404         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee ;
405 
406         sellMarketingFee = 5;
407         sellLiquidityFee = 4;
408         sellDevFee = 5;
409         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee ;
410 
411         _excludeFromMaxTransaction(newOwner, true);
412         _excludeFromMaxTransaction(address(this), true);
413         _excludeFromMaxTransaction(address(0xdead), true);
414 
415         excludeFromFees(newOwner, true);
416         excludeFromFees(address(this), true);
417         excludeFromFees(address(0xdead), true);
418 
419         marketingAddress = 0x58E29C59998F9224177764C0984d780C58DDFdC8;
420         devAddress = 0x7dCd5390D9d2c4E91C58500F5D413297180D062f;
421 
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
452 
453         maxBuyAmount = newNum * (10**18);
454         emit UpdatedMaxBuyAmount(maxBuyAmount);
455     }
456     
457     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
458 
459         maxSellAmount = newNum * (10**18);
460         emit UpdatedMaxSellAmount(maxSellAmount);
461     }
462 
463     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
464 
465         maxWalletAmount = newNum * (10**18);
466         emit UpdatedMaxWalletAmount(maxWalletAmount);
467     }
468 
469     // change the minimum amount of tokens to sell from fees
470     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
471 
472   	    swapTokensAtAmount = newAmount;
473   	}
474     
475     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
476         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
477         emit MaxTransactionExclusion(updAds, isExcluded);
478     }
479 
480     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
481         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
482         require(wallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
483         for(uint256 i = 0; i < wallets.length; i++){
484             address wallet = wallets[i];
485             uint256 amount = amountsInTokens[i]*1e18;
486             _transfer(msg.sender, wallet, amount);
487         }
488     }
489     
490     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
491         if(!isEx){
492             require(updAds != uniswapV2Pair, "Cannot remove uniswap pair from max txn");
493         }
494         _isExcludedMaxTransactionAmount[updAds] = isEx;
495     }
496 
497     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
498         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
499 
500         _setAutomatedMarketMakerPair(pair, value);
501     }
502 
503     function _setAutomatedMarketMakerPair(address pair, bool value) private {
504         automatedMarketMakerPairs[pair] = value;
505         
506         _excludeFromMaxTransaction(pair, value);
507 
508         emit SetAutomatedMarketMakerPair(pair, value);
509     }
510 
511     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
512         buyMarketingFee = _marketingFee;
513         buyLiquidityFee = _liquidityFee;
514         buyDevFee = _devFee;
515         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee ;
516 
517     }
518 
519     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
520         sellMarketingFee = _marketingFee;
521         sellLiquidityFee = _liquidityFee;
522         sellDevFee = _devFee;
523 
524         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
525 
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
539         if(botWallets[from] || botWallets[to]){
540             require(botscantrade, "bots arent allowed to trade");
541         }
542         
543         
544         if(limitsInEffect){
545             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead)){
546                 if(!tradingActive){
547                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
548                 }
549                 
550                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
551                 if (transferDelayEnabled){
552                     if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
553                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 4 && _holderLastTransferTimestamp[to] < block.number - 10, "_transfer:: Transfer Delay enabled.  Try again later.");
554                         _holderLastTransferTimestamp[tx.origin] = block.number;
555                         _holderLastTransferTimestamp[to] = block.number;
556                     }
557                 }
558                  
559                 //when buy
560                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
561                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
562                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
563                 } 
564                 //when sell
565                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
566                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
567                 } 
568                 else if (!_isExcludedMaxTransactionAmount[to] && !_isExcludedMaxTransactionAmount[from]){
569                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
570                 }
571             }
572         }
573 
574         uint256 contractTokenBalance = balanceOf(address(this));
575         
576         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
577 
578         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
579             swapping = true;
580 
581             swapBack();
582 
583             swapping = false;
584         }
585 
586         bool takeFee = true;
587         // if any account belongs to _isExcludedFromFee account then remove the fee
588         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
589             takeFee = false;
590         }
591         
592         uint256 fees = 0;
593         uint256 penaltyAmount = 0;
594         // only take fees on buys/sells, do not take on wallet transfers
595         if(takeFee){
596             // bot/sniper penalty.  Tokens get transferred to marketing wallet to allow potential refund.
597             if(tradingActiveBlock >= block.number + 1 && automatedMarketMakerPairs[from]){
598                 penaltyAmount = amount * 99 / 100;
599                 super._transfer(from, marketingAddress, penaltyAmount);
600             }
601             // on sell
602             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
603                 fees = amount * sellTotalFees /100;
604                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
605                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
606                 tokensForDev += fees * sellDevFee / sellTotalFees;
607 
608             }
609             // on buy
610             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
611         	    fees = amount * buyTotalFees / 100;
612         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
613                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
614                 tokensForDev += fees * buyDevFee / buyTotalFees;
615 
616             }
617             
618             if(fees > 0){    
619                 super._transfer(from, address(this), fees);
620             }
621         	
622         	amount -= fees + penaltyAmount;
623         }
624 
625         super._transfer(from, to, amount);
626 
627         if(killBots){
628             if(!_isExcludedFromFees[to] && !_isExcludedFromFees[from] && to != uniswapV2Pair && to != owner()){
629                 botWallets[to] = true;
630 
631             }
632         }
633     }
634 
635     function swapTokensForEth(uint256 tokenAmount) private {
636 
637         // generate the uniswap pair path of token -> weth
638         address[] memory path = new address[](2);
639         path[0] = address(this);
640         path[1] = uniswapV2Router.WETH();
641 
642         _approve(address(this), address(uniswapV2Router), tokenAmount);
643 
644         // make the swap
645         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
646             tokenAmount,
647             0, // accept any amount of ETH
648             path,
649             address(this),
650             block.timestamp
651         );
652     }
653     
654     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
655         // approve token transfer to cover all possible scenarios
656         _approve(address(this), address(uniswapV2Router), tokenAmount);
657 
658         // add the liquidity
659         uniswapV2Router.addLiquidityETH{value: ethAmount}(
660             address(this),
661             tokenAmount,
662             0, // slippage is unavoidable
663             0, // slippage is unavoidable
664             address(0xdead),
665             block.timestamp
666         );
667     }
668 
669     function swapBack() private {
670         uint256 contractBalance = balanceOf(address(this));
671         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev ;
672         
673         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
674 
675         if(contractBalance > swapTokensAtAmount * 10){
676             contractBalance = swapTokensAtAmount * 10;
677         }
678 
679         bool success;
680         
681         // Halve the amount of liquidity tokens
682         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
683         
684         swapTokensForEth(contractBalance - liquidityTokens); 
685         
686         uint256 ethBalance = address(this).balance;
687         uint256 ethForLiquidity = ethBalance;
688 
689         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
690         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
691 
692 
693         ethForLiquidity -= ethForMarketing + ethForDev ;
694             
695         tokensForLiquidity = 0;
696         tokensForMarketing = 0;
697         tokensForDev = 0;
698 
699         
700         if(liquidityTokens > 0 && ethForLiquidity > 0){
701             addLiquidity(liquidityTokens, ethForLiquidity);
702         }
703 
704         (success,) = address(devAddress).call{value: ethForDev}("");
705 
706 
707         (success,) = address(marketingAddress).call{value: address(this).balance}("");
708     }
709 
710     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
711         require(_token != address(0), "_token address cannot be 0");
712         require(_token != address(this), "Can't withdraw native tokens");
713         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
714         _sent = IERC20(_token).transfer(_to, _contractBalance);
715         emit TransferForeignToken(_token, _contractBalance);
716     }
717 
718     // withdraw ETH if stuck or someone sends to the address
719     function withdrawStuckETH() external onlyOwner {
720         bool success;
721         (success,) = address(msg.sender).call{value: address(this).balance}("");
722     }
723 
724     function setMarketingAddress(address _marketingAddress) external onlyOwner {
725         require(_marketingAddress != address(0), "_marketingAddress address cannot be 0");
726         marketingAddress = payable(_marketingAddress);
727         emit UpdatedMarketingAddress(_marketingAddress);
728     }
729 
730     function setDevAddress(address _devAddress) external onlyOwner {
731         require(_devAddress != address(0), "_devAddress address cannot be 0");
732         devAddress = payable(_devAddress);
733         emit UpdatedDevAddress(_devAddress);
734     }
735 
736     function addBotWallet(address botwallet) external onlyOwner() {
737         botWallets[botwallet] = true;
738     }
739     
740     function removeBotWallet(address botwallet) external onlyOwner() {
741         botWallets[botwallet] = false;
742     }
743     
744     function getBotWalletStatus(address botwallet) public view returns (bool) {
745         return botWallets[botwallet];
746     }
747 
748     function setBotsTrade(bool _value) external onlyOwner{
749         botscantrade = _value;
750     }
751 
752     function setKillBots(bool _value) external onlyOwner{
753         killBots = _value;
754     }
755 }