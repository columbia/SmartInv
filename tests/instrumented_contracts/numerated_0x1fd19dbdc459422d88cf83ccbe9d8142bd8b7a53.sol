1 // SPDX-License-Identifier: MIT                                                                               
2                                                     
3 pragma solidity 0.8.13;
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
259 interface ILpPair {
260     function sync() external;
261 }
262 
263 interface IDexRouter {
264     function factory() external pure returns (address);
265     function WETH() external pure returns (address);
266     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
267     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
268     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
269     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
270     function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
271     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
272 }
273 
274 interface IDexFactory {
275     function createPair(address tokenA, address tokenB) external returns (address pair);
276 }
277 
278 contract TokenHandler is Ownable {
279     function sendTokenToOwner(address token) external onlyOwner {
280         if(IERC20(token).balanceOf(address(this)) > 0){
281             IERC20(token).transfer(owner(), IERC20(token).balanceOf(address(this)));
282         }
283     }
284 }
285 
286 contract SCIDAO is ERC20, Ownable {
287 
288     uint256 public maxBuyAmount;
289     uint256 public maxSellAmount;
290     uint256 public maxWalletAmount;
291 
292     IDexRouter public immutable dexRouter;
293     address public immutable lpPair;
294 
295     TokenHandler public immutable tokenHandler;
296 
297     bool private swapping;
298     uint256 public swapTokensAtAmount;
299 
300     address public operationsAddress;
301     address public yashaAddress;
302 
303     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
304 
305     bool public limitsInEffect = true;
306     bool public tradingActive = false;
307     bool public swapEnabled = false;
308     
309      // Anti-bot and anti-whale mappings and variables
310     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
311     bool public transferDelayEnabled = true;
312 
313     IERC20 public constant USDC = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48); // Testnet: 0xeb8f08a975Ab53E34D8a0330E0D34de942C95926  //Mainnet: 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
314 
315     uint256 public buyTotalFees;
316     uint256 public buyOperationsFee;
317     uint256 public buyLiquidityFee;
318     uint256 public buyYashaFee;
319 
320     uint256 public sellTotalFees;
321     uint256 public sellOperationsFee;
322     uint256 public sellLiquidityFee;
323     uint256 public sellYashaFee;
324 
325     uint256 public tokensForOperations;
326     uint256 public tokensForLiquidity;
327     uint256 public tokensForYasha;
328 
329     uint256 public lpWithdrawRequestTimestamp;
330     uint256 public lpWithdrawRequestDuration = 3 days;
331     bool public lpWithdrawRequestPending;
332     uint256 public lpPercToWithDraw;
333     
334     /******************/
335 
336     // exlcude from fees and max transaction amount
337     mapping (address => bool) private _isExcludedFromFees;
338     mapping (address => bool) public _isExcludedMaxTransactionAmount;
339 
340     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
341     // could be subject to a maximum transfer amount
342     mapping (address => bool) public automatedMarketMakerPairs;
343 
344     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
345 
346     event EnabledTrading();
347     event RemovedLimits();
348 
349     event ExcludeFromFees(address indexed account, bool isExcluded);
350 
351     event UpdatedMaxBuyAmount(uint256 newAmount);
352 
353     event UpdatedMaxSellAmount(uint256 newAmount);
354 
355     event UpdatedMaxWalletAmount(uint256 newAmount);
356 
357     event UpdatedOperationsAddress(address indexed newWallet);
358 
359     event UpdatedYashaAddress(address indexed newWallet);
360 
361     event MaxTransactionExclusion(address _address, bool excluded);
362 
363     event RequestedLPWithdraw();
364 
365     event SwapAndLiquify(
366         uint256 tokensSwapped,
367         uint256 ethReceived,
368         uint256 tokensIntoLiquidity
369     );
370 
371     event TransferForeignToken(address token, uint256 amount);
372 
373     constructor() ERC20("THEORY", "THRY") {
374         
375         address newOwner = msg.sender; // can leave alone if owner is deployer.
376         
377         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
378 
379         _excludeFromMaxTransaction(address(_dexRouter), true);
380         dexRouter = _dexRouter;
381         
382         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), address(USDC));
383         _setAutomatedMarketMakerPair(address(lpPair), true);
384 
385         tokenHandler = new TokenHandler();
386  
387         uint256 totalSupply = 1 * 1e9 * 1e18;
388         
389         maxBuyAmount = totalSupply * 1 / 1000;
390         maxSellAmount = totalSupply * 1 / 1000;
391         maxWalletAmount = totalSupply * 2 / 1000;
392         swapTokensAtAmount = totalSupply * 25 / 100000; // 0.025% swap amount
393 
394         buyOperationsFee = 20;
395         buyLiquidityFee = 5;
396         buyYashaFee = 0;
397         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyYashaFee;
398 
399         sellOperationsFee = 20;
400         sellLiquidityFee = 5;
401         sellYashaFee = 0;
402         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellYashaFee;
403 
404         _excludeFromMaxTransaction(newOwner, true);
405         _excludeFromMaxTransaction(address(this), true);
406         _excludeFromMaxTransaction(address(0xdead), true);
407 
408         excludeFromFees(newOwner, true);
409         excludeFromFees(address(this), true);
410         excludeFromFees(address(0xdead), true);
411 
412         operationsAddress = address(newOwner);
413         yashaAddress = address(newOwner);
414         
415         _createInitialSupply(newOwner, totalSupply);
416         transferOwnership(newOwner);
417     }
418 
419     receive() external payable {}
420 
421     // once enabled, can never be turned off
422     function enableTrading() external onlyOwner {
423         require(!tradingActive, "Cannot reenable trading");
424         tradingActive = true;
425         swapEnabled = true;
426         tradingActiveBlock = block.number;
427         emit EnabledTrading();
428     }
429     
430     // remove limits after token is stable
431     function removeLimits() external onlyOwner {
432         limitsInEffect = false;
433         transferDelayEnabled = false;
434         emit RemovedLimits();
435     }
436     
437    
438     // disable Transfer delay - cannot be reenabled
439     function disableTransferDelay() external onlyOwner {
440         transferDelayEnabled = false;
441     }
442     
443     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
444         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max buy amount lower than 0.1%");
445         maxBuyAmount = newNum * (10**18);
446         emit UpdatedMaxBuyAmount(maxBuyAmount);
447     }
448     
449     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
450         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max sell amount lower than 0.1%");
451         maxSellAmount = newNum * (10**18);
452         emit UpdatedMaxSellAmount(maxSellAmount);
453     }
454 
455     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
456         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
457         maxWalletAmount = newNum * (10**18);
458         emit UpdatedMaxWalletAmount(maxWalletAmount);
459     }
460 
461     // change the minimum amount of tokens to sell from fees
462     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
463   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
464   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
465   	    swapTokensAtAmount = newAmount;
466   	}
467     
468     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
469         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
470         emit MaxTransactionExclusion(updAds, isExcluded);
471     }
472 
473     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
474         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
475         require(wallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
476         for(uint256 i = 0; i < wallets.length; i++){
477             address wallet = wallets[i];
478             uint256 amount = amountsInTokens[i]*1e18;
479             _transfer(msg.sender, wallet, amount);
480         }
481     }
482     
483     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
484         if(!isEx){
485             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
486         }
487         _isExcludedMaxTransactionAmount[updAds] = isEx;
488     }
489 
490     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
491         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
492 
493         _setAutomatedMarketMakerPair(pair, value);
494     }
495 
496     function _setAutomatedMarketMakerPair(address pair, bool value) private {
497         automatedMarketMakerPairs[pair] = value;
498         
499         _excludeFromMaxTransaction(pair, value);
500 
501         emit SetAutomatedMarketMakerPair(pair, value);
502     }
503 
504     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _yashaFee) external onlyOwner {
505         buyOperationsFee = _operationsFee;
506         buyLiquidityFee = _liquidityFee;
507         buyYashaFee = _yashaFee;
508         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyYashaFee;
509         require(buyTotalFees <= 30, "Must keep fees at 30% or less");
510     }
511 
512     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _yashaFee) external onlyOwner {
513         sellOperationsFee = _operationsFee;
514         sellLiquidityFee = _liquidityFee;
515         sellYashaFee = _yashaFee;
516         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellYashaFee;
517         require(sellTotalFees <= 50, "Must keep fees at 50% or less");
518     }
519 
520     function excludeFromFees(address account, bool excluded) public onlyOwner {
521         _isExcludedFromFees[account] = excluded;
522         emit ExcludeFromFees(account, excluded);
523     }
524 
525     function _transfer(address from, address to, uint256 amount) internal override {
526 
527         require(from != address(0), "ERC20: transfer from the zero address");
528         require(to != address(0), "ERC20: transfer to the zero address");
529         require(amount > 0, "amount must be greater than 0");
530         
531         
532         if(limitsInEffect){
533             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead)){
534                 if(!tradingActive){
535                     require(_isExcludedMaxTransactionAmount[from] || _isExcludedMaxTransactionAmount[to], "Trading is not active.");
536                 }
537                 
538                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
539                 if (transferDelayEnabled){
540                     if (to != address(dexRouter) && to != address(lpPair)){
541                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 4 && _holderLastTransferTimestamp[to] < block.number - 4, "_transfer:: Transfer Delay enabled.  Try again later.");
542                         _holderLastTransferTimestamp[tx.origin] = block.number;
543                         _holderLastTransferTimestamp[to] = block.number;
544                     }
545                 }
546                  
547                 //when buy
548                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
549                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
550                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
551                 } 
552                 //when sell
553                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
554                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
555                 } 
556                 else if (!_isExcludedMaxTransactionAmount[to] && !_isExcludedMaxTransactionAmount[from]){
557                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
558                 }
559             }
560         }
561 
562         uint256 contractTokenBalance = balanceOf(address(this));
563         
564         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
565 
566         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
567             swapping = true;
568 
569             swapBack();
570 
571             swapping = false;
572         }
573 
574         bool takeFee = true;
575         // if any account belongs to _isExcludedFromFee account then remove the fee
576         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
577             takeFee = false;
578         }
579         
580         uint256 fees = 0;
581         uint256 penaltyAmount = 0;
582         // only take fees on buys/sells, do not take on wallet transfers
583         if(takeFee){
584             // bot/sniper penalty.  Tokens get transferred to marketing wallet to allow potential refund.
585             if(tradingActiveBlock + 1 >= block.number && automatedMarketMakerPairs[from]){
586                 penaltyAmount = amount * 99 / 100;
587                 super._transfer(from, operationsAddress, penaltyAmount);
588             }
589             // on sell
590             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
591                 fees = amount * sellTotalFees /100;
592                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
593                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
594                 tokensForYasha += fees * sellYashaFee / sellTotalFees;
595             }
596             // on buy
597             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
598         	    fees = amount * buyTotalFees / 100;
599         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
600                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
601                 tokensForYasha += fees * buyYashaFee / buyTotalFees;
602             }
603             
604             if(fees > 0){    
605                 super._transfer(from, address(this), fees);
606             }
607         	
608         	amount -= fees + penaltyAmount;
609         }
610 
611         super._transfer(from, to, amount);
612     }
613 
614     function swapTokensForEth(uint256 tokenAmount) private {
615 
616         // generate the uniswap pair path of token -> weth
617         address[] memory path = new address[](2);
618         path[0] = address(this);
619         path[1] = dexRouter.WETH();
620 
621         _approve(address(this), address(dexRouter), tokenAmount);
622 
623         // make the swap
624         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
625             tokenAmount,
626             0, // accept any amount of ETH
627             path,
628             address(this),
629             block.timestamp
630         );
631     }
632     
633     function addLiquidity(uint256 tokenAmount, uint256 usdcAmount) private {
634         // approve token transfer to cover all possible scenarios
635         _approve(address(this), address(dexRouter), tokenAmount);
636         USDC.approve(address(dexRouter), usdcAmount);
637 
638         // add the liquidity
639         dexRouter.addLiquidity(address(this), address(USDC), tokenAmount, usdcAmount, 0,  0,  address(this), block.timestamp);
640     }
641 
642     function swapBack() private {
643         uint256 contractBalance = balanceOf(address(this));
644         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForYasha;
645         
646         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
647 
648         if(contractBalance > swapTokensAtAmount * 10){
649             contractBalance = swapTokensAtAmount * 10;
650         }
651         
652         // Halve the amount of liquidity tokens
653         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
654         
655         swapTokensForUSDC(contractBalance - liquidityTokens); 
656 
657         tokenHandler.sendTokenToOwner(address(USDC));
658         
659         uint256 usdcBalance = USDC.balanceOf(address(this));
660         uint256 usdcForLiquidity = usdcBalance;
661 
662         uint256 usdcForOperations = usdcBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
663         uint256 usdcForYasha = usdcBalance * tokensForYasha / (totalTokensToSwap - (tokensForLiquidity/2));
664 
665         usdcForLiquidity -= usdcForOperations + usdcForYasha;
666             
667         tokensForLiquidity = 0;
668         tokensForOperations = 0;
669         tokensForYasha = 0;
670         
671         if(liquidityTokens > 0 && usdcForLiquidity > 0){
672             addLiquidity(liquidityTokens, usdcForLiquidity);
673         }
674 
675         if(usdcForYasha > 0){
676             USDC.transfer(yashaAddress, usdcForYasha);
677         }
678 
679         if(USDC.balanceOf(address(this)) > 0){
680             USDC.transfer(operationsAddress, USDC.balanceOf(address(this)));
681         }
682     }
683 
684     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
685         require(_token != address(0), "_token address cannot be 0");
686         require(_token != address(this), "Can't withdraw native tokens");
687         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
688         _sent = IERC20(_token).transfer(_to, _contractBalance);
689         emit TransferForeignToken(_token, _contractBalance);
690     }
691 
692     function swapTokensForUSDC(uint256 tokenAmount) private {
693 
694         // generate the uniswap pair path of token -> weth
695         address[] memory path = new address[](2);
696         path[0] = address(this);
697         path[1] = address(USDC);
698 
699         _approve(address(this), address(dexRouter), tokenAmount);
700 
701         // make the swap
702         dexRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
703             tokenAmount,
704             0, // accept any amount of ETH
705             path,
706             address(tokenHandler),
707             block.timestamp
708         );
709     }
710 
711     // withdraw ETH if stuck or someone sends to the address
712     function withdrawStuckETH() external onlyOwner {
713         bool success;
714         (success,) = address(msg.sender).call{value: address(this).balance}("");
715     }
716 
717     function setOperationsAddress(address _operationsAddress) external onlyOwner {
718         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
719         operationsAddress = payable(_operationsAddress);
720         emit UpdatedOperationsAddress(_operationsAddress);
721     }
722 
723     function setYashaAddress(address _yashaAddress) external onlyOwner {
724         require(_yashaAddress != address(0), "_yashaAddress address cannot be 0");
725         yashaAddress = payable(_yashaAddress);
726         emit UpdatedYashaAddress(_yashaAddress);
727     }
728 
729     function requestToWithdrawLP(uint256 percToWithdraw) external onlyOwner {
730         require(!lpWithdrawRequestPending, "Cannot request again until first request is over.");
731         require(percToWithdraw <= 100 && percToWithdraw > 0, "Need to set between 1-100%");
732         lpWithdrawRequestTimestamp = block.timestamp;
733         lpWithdrawRequestPending = true;
734         lpPercToWithDraw = percToWithdraw;
735         emit RequestedLPWithdraw();
736     }
737 
738     function nextAvailableLpWithdrawDate() public view returns (uint256){
739         if(lpWithdrawRequestPending){
740             return lpWithdrawRequestTimestamp + lpWithdrawRequestDuration;
741         }
742         else {
743             return 0;  // 0 means no open requests
744         }
745     }
746 
747     function withdrawRequestedLP() external onlyOwner {
748         require(block.timestamp >= nextAvailableLpWithdrawDate() && nextAvailableLpWithdrawDate() > 0, "Must request and wait.");
749         lpWithdrawRequestTimestamp = 0;
750         lpWithdrawRequestPending = false;
751 
752         uint256 amtToWithdraw = IERC20(address(lpPair)).balanceOf(address(this)) * lpPercToWithDraw / 100;
753         
754         lpPercToWithDraw = 0;
755 
756         IERC20(lpPair).transfer(msg.sender, amtToWithdraw);
757     }
758 
759     function cancelLPWithdrawRequest() external onlyOwner {
760         lpWithdrawRequestPending = false;
761     }
762 }