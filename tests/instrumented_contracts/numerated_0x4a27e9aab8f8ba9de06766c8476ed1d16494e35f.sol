1 // SPDX-License-Identifier: MIT                                                                               
2 // The most memeable token on ethereum
3 //https://pepe.gold/
4 //https://t.me/PEPEGOLDERC20
5 /*                            .-----.
6                             /7  .  (
7                            /   .-.  \
8                           /   /   \  \
9                          / `  )   (   )
10                         / `   )   ).  \
11                       .'  _.   \_/  . |
12      .--.           .' _.' )`.        |
13     (    `---...._.'   `---.'_)    ..  \
14      \            `----....___    `. \  |
15       `.           _ ----- _   `._  )/  |
16         `.       /"  \   /"  \`.  `._   |
17           `.    ((O)` ) ((O)` ) `.   `._\
18             `-- '`---'   `---' )  `.    `-.
19                /                  ` \      `-.
20              .'                      `.       `.
21             /                     `  ` `.       `-.
22      .--.   \ ===._____.======. `    `   `. .___.--`     .''''.
23     ' .` `-. `.                )`. `   ` ` \          .' . '  8)
24    (8  .  ` `-.`.               ( .  ` `  .`\      .'  '    ' /
25     \  `. `    `-.               ) ` .   ` ` \  .'   ' .  '  /
26      \ ` `.  ` . \`.    .--.     |  ` ) `   .``/   '  // .  /
27       `.  ``. .   \ \   .-- `.  (  ` /_   ` . / ' .  '/   .'
28         `. ` \  `  \ \  '-.   `-'  .'  `-.  `   .  .'/  .'
29           \ `.`.  ` \ \    ) /`._.`       `.  ` .  .'  /
30     LGB    |  `.`. . \ \  (.'               `.   .'  .'
31         __/  .. \ \ ` ) \                     \.' .. \__
32  .-._.-'     '"  ) .-'   `.                   (  '"     `-._.--.
33 (_________.-====' / .' /\_)`--..__________..-- `====-. _________)
34                  (.'(.'
35 */                     
36 pragma solidity 0.8.15;
37 
38 abstract contract Context {
39     function _msgSender() internal view virtual returns (address) {
40         return msg.sender;
41     }
42 
43     function _msgData() internal view virtual returns (bytes calldata) {
44         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
45         return msg.data;
46     }
47 }
48 
49 interface IERC20 {
50     /**
51      * @dev Returns the amount of tokens in existence.
52      */
53     function totalSupply() external view returns (uint256);
54 
55     /**
56      * @dev Returns the amount of tokens owned by `account`.
57      */
58     function balanceOf(address account) external view returns (uint256);
59 
60     /**
61      * @dev Moves `amount` tokens from the caller's account to `recipient`.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transfer(address recipient, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Returns the remaining number of tokens that `spender` will be
71      * allowed to spend on behalf of `owner` through {transferFrom}. This is
72      * zero by default.
73      *
74      * This value changes when {approve} or {transferFrom} are called.
75      */
76     function allowance(address owner, address spender) external view returns (uint256);
77 
78     /**
79      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * IMPORTANT: Beware that changing an allowance with this method brings the risk
84      * that someone may use both the old and the new allowance by unfortunate
85      * transaction ordering. One possible solution to mitigate this race
86      * condition is to first reduce the spender's allowance to 0 and set the
87      * desired value afterwards:
88      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
89      *
90      * Emits an {Approval} event.
91      */
92     function approve(address spender, uint256 amount) external returns (bool);
93 
94     /**
95      * @dev Moves `amount` tokens from `sender` to `recipient` using the
96      * allowance mechanism. `amount` is then deducted from the caller's
97      * allowance.
98      *
99      * Returns a boolean value indicating whether the operation succeeded.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transferFrom(
104         address sender,
105         address recipient,
106         uint256 amount
107     ) external returns (bool);
108 
109     /**
110      * @dev Emitted when `value` tokens are moved from one account (`from`) to
111      * another (`to`).
112      *
113      * Note that `value` may be zero.
114      */
115     event Transfer(address indexed from, address indexed to, uint256 value);
116 
117     /**
118      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
119      * a call to {approve}. `value` is the new allowance.
120      */
121     event Approval(address indexed owner, address indexed spender, uint256 value);
122 }
123 
124 interface IERC20Metadata is IERC20 {
125     /**
126      * @dev Returns the name of the token.
127      */
128     function name() external view returns (string memory);
129 
130     /**
131      * @dev Returns the symbol of the token.
132      */
133     function symbol() external view returns (string memory);
134 
135     /**
136      * @dev Returns the decimals places of the token.
137      */
138     function decimals() external view returns (uint8);
139 }
140 
141 contract ERC20 is Context, IERC20, IERC20Metadata {
142     mapping(address => uint256) private _balances;
143 
144     mapping(address => mapping(address => uint256)) private _allowances;
145 
146     uint256 private _totalSupply;
147 
148     string private _name;
149     string private _symbol;
150 
151     constructor(string memory name_, string memory symbol_) {
152         _name = name_;
153         _symbol = symbol_;
154     }
155 
156     function name() public view virtual override returns (string memory) {
157         return _name;
158     }
159 
160     function symbol() public view virtual override returns (string memory) {
161         return _symbol;
162     }
163 
164     function decimals() public view virtual override returns (uint8) {
165         return 18;
166     }
167 
168     function totalSupply() public view virtual override returns (uint256) {
169         return _totalSupply;
170     }
171 
172     function balanceOf(address account) public view virtual override returns (uint256) {
173         return _balances[account];
174     }
175 
176     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
177         _transfer(_msgSender(), recipient, amount);
178         return true;
179     }
180 
181     function allowance(address owner, address spender) public view virtual override returns (uint256) {
182         return _allowances[owner][spender];
183     }
184 
185     function approve(address spender, uint256 amount) public virtual override returns (bool) {
186         _approve(_msgSender(), spender, amount);
187         return true;
188     }
189 
190     function transferFrom(
191         address sender,
192         address recipient,
193         uint256 amount
194     ) public virtual override returns (bool) {
195         _transfer(sender, recipient, amount);
196 
197         uint256 currentAllowance = _allowances[sender][_msgSender()];
198         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
199         unchecked {
200             _approve(sender, _msgSender(), currentAllowance - amount);
201         }
202 
203         return true;
204     }
205 
206     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
207         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
208         return true;
209     }
210 
211     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
212         uint256 currentAllowance = _allowances[_msgSender()][spender];
213         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
214         unchecked {
215             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
216         }
217 
218         return true;
219     }
220 
221     function _transfer(
222         address sender,
223         address recipient,
224         uint256 amount
225     ) internal virtual {
226         require(sender != address(0), "ERC20: transfer from the zero address");
227         require(recipient != address(0), "ERC20: transfer to the zero address");
228 
229         uint256 senderBalance = _balances[sender];
230         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
231         unchecked {
232             _balances[sender] = senderBalance - amount;
233         }
234         _balances[recipient] += amount;
235 
236         emit Transfer(sender, recipient, amount);
237     }
238 
239     function _createInitialSupply(address account, uint256 amount) internal virtual {
240         require(account != address(0), "ERC20: mint to the zero address");
241 
242         _totalSupply += amount;
243         _balances[account] += amount;
244         emit Transfer(address(0), account, amount);
245     }
246 
247     function _approve(
248         address owner,
249         address spender,
250         uint256 amount
251     ) internal virtual {
252         require(owner != address(0), "ERC20: approve from the zero address");
253         require(spender != address(0), "ERC20: approve to the zero address");
254 
255         _allowances[owner][spender] = amount;
256         emit Approval(owner, spender, amount);
257     }
258 }
259 
260 contract Ownable is Context {
261     address private _owner;
262 
263     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
264     
265     constructor () {
266         address msgSender = _msgSender();
267         _owner = msgSender;
268         emit OwnershipTransferred(address(0), msgSender);
269     }
270 
271     function owner() public view returns (address) {
272         return _owner;
273     }
274 
275     modifier onlyOwner() {
276         require(_owner == _msgSender(), "Ownable: caller is not the owner");
277         _;
278     }
279 
280     function renounceOwnership() external virtual onlyOwner {
281         emit OwnershipTransferred(_owner, address(0));
282         _owner = address(0);
283     }
284 
285     function transferOwnership(address newOwner) public virtual onlyOwner {
286         require(newOwner != address(0), "Ownable: new owner is the zero address");
287         emit OwnershipTransferred(_owner, newOwner);
288         _owner = newOwner;
289     }
290 }
291 
292 interface IDexRouter {
293     function factory() external pure returns (address);
294     function WETH() external pure returns (address);
295     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
296     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
297     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
298     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
299     function removeLiquidityETH(address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external returns (uint amountToken, uint amountETH);
300 }
301 
302 interface IDexFactory {
303     function createPair(address tokenA, address tokenB) external returns (address pair);
304 }
305 
306 contract PEPEGOLD is ERC20, Ownable {
307 
308     IDexRouter public dexRouter;
309     address public lpPair;
310 
311     bool private swapping;
312     uint256 public swapTokensAtAmount;
313 
314     address public communityAddress;
315     address public devAddress;
316 
317     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
318 
319     bool public tradingActive = false;
320     bool public swapEnabled = false;
321 
322     uint256 public buyTotalFees;
323     uint256 public buyCommunityFee;
324     uint256 public buyLiquidityFee;
325     uint256 public buyBurnFee;
326 
327     uint256 public sellTotalFees;
328     uint256 public sellCommunityFee;
329     uint256 public sellLiquidityFee;
330     uint256 public sellBurnFee;
331 
332     uint256 public constant FEE_DIVISOR = 10000;
333 
334     uint256 public tokensForCommunity;
335     uint256 public tokensForLiquidity;
336 
337     uint256 public lpWithdrawRequestTimestamp;
338     uint256 public lpWithdrawRequestDuration = 30 days;
339     bool public lpWithdrawRequestPending;
340     uint256 public lpPercToWithDraw;
341 
342     uint256 public percentForLPBurn = 25; // 25 = .25%
343     bool public lpBurnEnabled = false;
344     uint256 public lpBurnFrequency = 360000 seconds;
345     uint256 public lastLpBurnTime;
346     
347     uint256 public manualBurnFrequency = 1 seconds;
348     uint256 public lastManualLpBurnTime;
349     
350     /******************/
351 
352     // exlcude from fees and max transaction amount
353     mapping (address => bool) private _isExcludedFromFees;
354 
355     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
356     // could be subject to a maximum transfer amount
357     mapping (address => bool) public automatedMarketMakerPairs;
358 
359     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
360 
361     event EnabledTrading();
362 
363     event ExcludeFromFees(address indexed account, bool isExcluded);
364 
365     event UpdatedMaxBuyAmount(uint256 newAmount);
366 
367     event UpdatedMaxSellAmount(uint256 newAmount);
368 
369     event UpdatedMaxWalletAmount(uint256 newAmount);
370 
371     event UpdatedCommunityAddress(address indexed newWallet);
372 
373     event UpdatedDevAddress(address indexed newWallet);
374 
375     event OwnerForcedSwapBack(uint256 timestamp);
376 
377     event SwapAndLiquify(
378         uint256 tokensSwapped,
379         uint256 ethReceived,
380         uint256 tokensIntoLiquidity
381     );
382 
383     event AutoBurnLP(uint256 indexed tokensBurned);
384 
385     event ManualBurnLP(uint256 indexed tokensBurned);
386 
387     event TransferForeignToken(address token, uint256 amount);
388 
389     event RequestedLPWithdraw();
390     
391     event WithdrewLPForMigration();
392 
393     event CanceledLpWithdrawRequest();
394 
395     constructor() ERC20("PEPEGOLD", "PEPE") payable {
396         
397         address newOwner = msg.sender; // can leave alone if owner is deployer.
398         address _dexRouter;
399 
400         if(block.chainid == 1){
401             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
402         } else if(block.chainid == 4){
403             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
404         } else if(block.chainid == 56){
405             _dexRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BNB Chain: PCS V2
406         } else if(block.chainid == 97){
407             _dexRouter = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // BNB Chain: PCS V2
408         } else if(block.chainid == 42161){
409             _dexRouter = 0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506; // Arbitrum: SushiSwap
410         } else {
411             revert("Chain not configured");
412         }
413 
414         // initialize router
415         dexRouter = IDexRouter(_dexRouter);
416         // create pair
417         lpPair = IDexFactory(dexRouter.factory()).createPair(address(this), dexRouter.WETH());
418         _setAutomatedMarketMakerPair(address(lpPair), true);
419 
420         uint256 totalSupply = 10 * 1e9 * (10 ** decimals());
421         
422         swapTokensAtAmount = totalSupply * 25 / 100000;
423 
424         buyCommunityFee = 100;
425         buyLiquidityFee = 100;
426         buyBurnFee = 50;
427         buyTotalFees = buyCommunityFee + buyLiquidityFee + buyBurnFee;
428 
429         sellCommunityFee = 450;
430         sellLiquidityFee = 500;
431         sellBurnFee = 50;
432         sellTotalFees = sellCommunityFee + sellLiquidityFee + sellBurnFee;
433 
434         communityAddress = address(msg.sender);
435         devAddress = address(msg.sender);
436 
437         excludeFromFees(newOwner, true);
438         excludeFromFees(address(this), true);
439         excludeFromFees(address(0xdead), true);
440         excludeFromFees(address(communityAddress), true);
441         excludeFromFees(address(dexRouter), true);
442 
443         _createInitialSupply(newOwner, totalSupply);
444         transferOwnership(newOwner);
445     }
446 
447     receive() external payable {}
448     
449     function enableTrading() external onlyOwner {
450         require(!tradingActive, "Cannot reenable trading");
451         tradingActive = true;
452         swapEnabled = true;
453         tradingActiveBlock = block.number;
454         emit EnabledTrading();
455     }
456 
457     // change the minimum amount of tokens to sell from fees
458     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
459   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
460   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
461   	    swapTokensAtAmount = newAmount;
462   	}
463     
464     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
465         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
466         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
467         for(uint256 i = 0; i < wallets.length; i++){
468             address wallet = wallets[i];
469             uint256 amount = amountsInTokens[i];
470             super._transfer(msg.sender, wallet, amount);
471         }
472     }
473 
474     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
475         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
476         _setAutomatedMarketMakerPair(pair, value);
477         emit SetAutomatedMarketMakerPair(pair, value);
478     }
479 
480     function _setAutomatedMarketMakerPair(address pair, bool value) private {
481         automatedMarketMakerPairs[pair] = value;
482         emit SetAutomatedMarketMakerPair(pair, value);
483     }
484 
485     function updateBuyFees(uint256 _communityFee, uint256 _liquidityFee, uint256 _burnFee) external onlyOwner {
486         buyCommunityFee = _communityFee;
487         buyLiquidityFee = _liquidityFee;
488         buyBurnFee = _burnFee;
489         buyTotalFees = buyCommunityFee + buyLiquidityFee + buyBurnFee;
490         require(buyTotalFees <= 3 * FEE_DIVISOR / 100, "Must keep fees at 3% or less");
491     }
492 
493     function updateSellFees(uint256 _communityFee, uint256 _liquidityFee, uint256 _burnFee) external onlyOwner {
494         sellCommunityFee = _communityFee;
495         sellLiquidityFee = _liquidityFee;
496         sellBurnFee = _burnFee;
497         sellTotalFees = sellCommunityFee + sellLiquidityFee + sellBurnFee;
498         require(sellTotalFees <= 3 * FEE_DIVISOR / 100, "Must keep fees at 3% or less");
499     }
500 
501     function massExcludeFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
502         for(uint256 i = 0; i < accounts.length; i++){
503             _isExcludedFromFees[accounts[i]] = excluded;
504             emit ExcludeFromFees(accounts[i], excluded);
505         }
506     }
507 
508     function excludeFromFees(address account, bool excluded) public onlyOwner {
509         _isExcludedFromFees[account] = excluded;
510         emit ExcludeFromFees(account, excluded);
511     }
512 
513     function _transfer(address from, address to, uint256 amount) internal override {
514 
515         require(from != address(0), "ERC20: transfer from the zero address");
516         require(to != address(0), "ERC20: transfer to the zero address");
517         require(amount > 0, "amount must be greater than 0");
518         
519         if(!tradingActive){
520             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
521         }
522 
523         uint256 contractTokenBalance = balanceOf(address(this));
524         
525         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
526 
527         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
528             swapping = true;
529             swapBack();
530             swapping = false;
531         }
532 
533         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
534             autoBurnLiquidityPairTokens();
535         }
536 
537         bool takeFee = true;
538         // if any account belongs to _isExcludedFromFee account then remove the fee
539         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
540             takeFee = false;
541         }
542         
543         uint256 fees = 0;
544         uint256 tokensToBurn = 0;
545 
546         // only take fees on buys/sells, do not take on wallet transfers
547         if(takeFee){
548             // on sell
549            if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
550                 fees = amount * sellTotalFees / FEE_DIVISOR;
551                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
552                 tokensForCommunity += fees * sellCommunityFee / sellTotalFees;
553                 tokensToBurn = fees * sellBurnFee / sellTotalFees;
554             }
555 
556             // on buy
557             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
558         	    fees = amount * buyTotalFees / FEE_DIVISOR;
559         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
560                 tokensForCommunity += fees * buyCommunityFee / buyTotalFees;
561                 tokensToBurn = fees * buyBurnFee / buyTotalFees;
562             }
563             
564             if(fees > 0){    
565                 super._transfer(from, address(this), fees);
566                 if(tokensToBurn > 0){
567                     super._transfer(address(this), address(0xdead), tokensToBurn);
568                 }
569             }
570         	
571         	amount -= fees;
572         }
573 
574         super._transfer(from, to, amount);
575     }
576 
577     function swapTokensForEth(uint256 tokenAmount) private {
578 
579         // generate the uniswap pair path of token -> weth
580         address[] memory path = new address[](2);
581         path[0] = address(this);
582         path[1] = dexRouter.WETH();
583 
584         _approve(address(this), address(dexRouter), tokenAmount);
585 
586         // make the swap
587         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
588             tokenAmount,
589             0, // accept any amount of ETH
590             path,
591             address(this),
592             block.timestamp
593         );
594     }
595     
596     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
597         // approve token transfer to cover all possible scenarios
598         _approve(address(this), address(dexRouter), tokenAmount);
599 
600         // add the liquidity
601         dexRouter.addLiquidityETH{value: ethAmount}(
602             address(this),
603             tokenAmount,
604             0, // slippage is unavoidable
605             0, // slippage is unavoidable
606             address(this),
607             block.timestamp
608         );
609     }
610 
611     function swapBack() private {
612 
613         uint256 contractBalance = balanceOf(address(this));
614         uint256 totalTokensToSwap = tokensForLiquidity + tokensForCommunity;
615         
616         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
617 
618         if(contractBalance > swapTokensAtAmount * 10){
619             contractBalance = swapTokensAtAmount * 10;
620         }
621 
622         bool success;
623         
624         // Halve the amount of liquidity tokens
625         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
626         
627         swapTokensForEth(contractBalance - liquidityTokens); 
628         
629         uint256 ethBalance = address(this).balance;
630         uint256 ethForLiquidity = ethBalance;
631 
632         uint256 ethForCommunity = ethBalance * tokensForCommunity / (totalTokensToSwap - (tokensForLiquidity/2));
633 
634         ethForLiquidity -= ethForCommunity;
635             
636         tokensForLiquidity = 0;
637         tokensForCommunity = 0;
638        
639         
640         if(liquidityTokens > 0 && ethForLiquidity > 0){
641             addLiquidity(liquidityTokens, ethForLiquidity);
642         }
643 
644         (success,) = address(communityAddress).call{value: address(this).balance}("");
645     }
646 
647     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
648         require(_token != address(0), "_token address cannot be 0");
649         require((_token != address(this) && _token != address(lpPair)) || !tradingActive, "Can't withdraw native tokens or LP while trading is active");
650         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
651         _sent = IERC20(_token).transfer(_to, _contractBalance);
652         emit TransferForeignToken(_token, _contractBalance);
653     }
654 
655     // withdraw ETH if stuck or someone sends to the address
656     function withdrawStuckETH() external onlyOwner {
657         bool success;
658         (success,) = address(msg.sender).call{value: address(this).balance}("");
659     }
660 
661     function setCommunityAddress(address _communityAddress) external onlyOwner {
662         require(_communityAddress != address(0), "_communityAddress address cannot be 0");
663         communityAddress = payable(_communityAddress);
664         emit UpdatedCommunityAddress(_communityAddress);
665     }
666 
667     // force Swap back if slippage issues.
668     function forceSwapBack() external onlyOwner {
669         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
670         swapping = true;
671         swapBack();
672         swapping = false;
673         emit OwnerForcedSwapBack(block.timestamp);
674     }
675 
676     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
677         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
678         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
679         lpBurnFrequency = _frequencyInSeconds;
680         percentForLPBurn = _percent;
681         lpBurnEnabled = _Enabled;
682     }
683     
684     function autoBurnLiquidityPairTokens() internal {
685         
686         lastLpBurnTime = block.timestamp;
687         
688         lastManualLpBurnTime = block.timestamp;
689         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
690         uint256 tokenBalance = balanceOf(address(this));
691         uint256 lpAmount = lpBalance * percentForLPBurn / 10000;
692         uint256 initialEthBalance = address(this).balance;
693 
694         // approve token transfer to cover all possible scenarios
695         IERC20(lpPair).approve(address(dexRouter), lpAmount);
696 
697         // remove the liquidity
698         dexRouter.removeLiquidityETH(
699             address(this),
700             lpAmount,
701             1, // slippage is unavoidable
702             1, // slippage is unavoidable
703             address(this),
704             block.timestamp
705         );
706 
707         uint256 deltaTokenBalance = balanceOf(address(this)) - tokenBalance;
708         if(deltaTokenBalance > 0){
709             super._transfer(address(this), address(0xdead), deltaTokenBalance);
710         }
711 
712         uint256 deltaEthBalance = address(this).balance - initialEthBalance;
713 
714         if(deltaEthBalance > 0){
715             buyBackTokens(deltaEthBalance);
716         }
717 
718         emit AutoBurnLP(lpAmount);
719     }
720 
721     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner {
722         require(percent <=2000, "May not burn more than 20% of contract's LP at a time");
723         require(lastManualLpBurnTime <= block.timestamp - manualBurnFrequency, "Burn too soon");
724         lastManualLpBurnTime = block.timestamp;
725         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
726         uint256 tokenBalance = balanceOf(address(this));
727         uint256 lpAmount = lpBalance * percent / 10000;
728         uint256 initialEthBalance = address(this).balance;
729 
730         // approve token transfer to cover all possible scenarios
731         IERC20(lpPair).approve(address(dexRouter), lpAmount);
732 
733         // remove the liquidity
734         dexRouter.removeLiquidityETH(
735             address(this),
736             lpAmount,
737             1, // slippage is unavoidable
738             1, // slippage is unavoidable
739             address(this),
740             block.timestamp
741         );
742 
743         uint256 deltaTokenBalance = balanceOf(address(this)) - tokenBalance;
744         if(deltaTokenBalance > 0){
745             super._transfer(address(this), address(0xdead), deltaTokenBalance);
746         }
747 
748         uint256 deltaEthBalance = address(this).balance - initialEthBalance;
749 
750         if(deltaEthBalance > 0){
751             buyBackTokens(deltaEthBalance);
752         }
753 
754         emit ManualBurnLP(lpAmount);
755     }
756 
757     function buyBackTokens(uint256 amountInWei) internal {
758         address[] memory path = new address[](2);
759         path[0] = dexRouter.WETH();
760         path[1] = address(this);
761 
762         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
763             0,
764             path,
765             address(0xdead),
766             block.timestamp
767         );
768     }
769 
770     function requestToWithdrawLP(uint256 percToWithdraw) external onlyOwner {
771         require(!lpWithdrawRequestPending, "Cannot request again until first request is over.");
772         require(percToWithdraw <= 100 && percToWithdraw > 0, "Need to set between 1-100%");
773         lpWithdrawRequestTimestamp = block.timestamp;
774         lpWithdrawRequestPending = true;
775         lpPercToWithDraw = percToWithdraw;
776         emit RequestedLPWithdraw();
777     }
778 
779     function nextAvailableLpWithdrawDate() public view returns (uint256){
780         if(lpWithdrawRequestPending){
781             return lpWithdrawRequestTimestamp + lpWithdrawRequestDuration;
782         }
783         else {
784             return 0;  // 0 means no open requests
785         }
786     }
787 
788     function withdrawRequestedLP() external onlyOwner {
789         require(block.timestamp >= nextAvailableLpWithdrawDate() && nextAvailableLpWithdrawDate() > 0, "Must request and wait.");
790         lpWithdrawRequestTimestamp = 0;
791         lpWithdrawRequestPending = false;
792 
793         uint256 amtToWithdraw = IERC20(address(lpPair)).balanceOf(address(this)) * lpPercToWithDraw / 100;
794         
795         lpPercToWithDraw = 0;
796 
797         IERC20(lpPair).transfer(msg.sender, amtToWithdraw);
798     }
799 
800     function cancelLPWithdrawRequest() external onlyOwner {
801         lpWithdrawRequestPending = false;
802         lpPercToWithDraw = 0;
803         lpWithdrawRequestTimestamp = 0;
804         emit CanceledLpWithdrawRequest();
805     }
806 }