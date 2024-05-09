1 /**    
2                 Yours truly,
3                         -Oracle      
4 */
5 
6 // SPDX-License-Identifier: Unlicense                                                                           
7 pragma solidity 0.8.11;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes calldata) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 interface IERC20 {
21     /**
22      * @dev Returns the amount of tokens in existence.
23      */
24     function totalSupply() external view returns (uint256);
25 
26     /**
27      * @dev Returns the amount of tokens owned by `account`.
28      */
29     function balanceOf(address account) external view returns (uint256);
30 
31     /**
32      * @dev Moves `amount` tokens from the caller's account to `recipient`.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * Emits a {Transfer} event.
37      */
38     function transfer(address recipient, uint256 amount) external returns (bool);
39 
40     /**
41      * @dev Returns the remaining number of tokens that `spender` will be
42      * allowed to spend on behalf of `owner` through {transferFrom}. This is
43      * zero by default.
44      *
45      * This value changes when {approve} or {transferFrom} are called.
46      */
47     function allowance(address owner, address spender) external view returns (uint256);
48 
49     /**
50      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * IMPORTANT: Beware that changing an allowance with this method brings the risk
55      * that someone may use both the old and the new allowance by unfortunate
56      * transaction ordering. One possible solution to mitigate this race
57      * condition is to first reduce the spender's allowance to 0 and set the
58      * desired value afterwards:
59      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
60      *
61      * Emits an {Approval} event.
62      */
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Moves `amount` tokens from `sender` to `recipient` using the
67      * allowance mechanism. `amount` is then deducted from the caller's
68      * allowance.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transferFrom(
75         address sender,
76         address recipient,
77         uint256 amount
78     ) external returns (bool);
79 
80     /**
81      * @dev Emitted when `value` tokens are moved from one account (`from`) to
82      * another (`to`).
83      *
84      * Note that `value` may be zero.
85      */
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 
88     /**
89      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
90      * a call to {approve}. `value` is the new allowance.
91      */
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 interface IERC20Metadata is IERC20 {
96     /**
97      * @dev Returns the name of the token.
98      */
99     function name() external view returns (string memory);
100 
101     /**
102      * @dev Returns the symbol of the token.
103      */
104     function symbol() external view returns (string memory);
105 
106     /**
107      * @dev Returns the decimals places of the token.
108      */
109     function decimals() external view returns (uint8);
110 }
111 
112 contract ERC20 is Context, IERC20, IERC20Metadata {
113     mapping(address => uint256) private _balances;
114 
115     mapping(address => mapping(address => uint256)) private _allowances;
116 
117     uint256 private _totalSupply;
118 
119     string private _name;
120     string private _symbol;
121 
122     constructor(string memory name_, string memory symbol_) {
123         _name = name_;
124         _symbol = symbol_;
125     }
126 
127     function name() public view virtual override returns (string memory) {
128         return _name;
129     }
130 
131     function symbol() public view virtual override returns (string memory) {
132         return _symbol;
133     }
134 
135     function decimals() public view virtual override returns (uint8) {
136         return 18;
137     }
138 
139     function totalSupply() public view virtual override returns (uint256) {
140         return _totalSupply;
141     }
142 
143     function balanceOf(address account) public view virtual override returns (uint256) {
144         return _balances[account];
145     }
146 
147     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
148         _transfer(_msgSender(), recipient, amount);
149         return true;
150     }
151 
152     function allowance(address owner, address spender) public view virtual override returns (uint256) {
153         return _allowances[owner][spender];
154     }
155 
156     function approve(address spender, uint256 amount) public virtual override returns (bool) {
157         _approve(_msgSender(), spender, amount);
158         return true;
159     }
160 
161     function transferFrom(
162         address sender,
163         address recipient,
164         uint256 amount
165     ) public virtual override returns (bool) {
166         _transfer(sender, recipient, amount);
167 
168         uint256 currentAllowance = _allowances[sender][_msgSender()];
169         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
170         unchecked {
171             _approve(sender, _msgSender(), currentAllowance - amount);
172         }
173 
174         return true;
175     }
176 
177     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
178         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
179         return true;
180     }
181 
182     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
183         uint256 currentAllowance = _allowances[_msgSender()][spender];
184         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
185         unchecked {
186             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
187         }
188 
189         return true;
190     }
191 
192     function _transfer(
193         address sender,
194         address recipient,
195         uint256 amount
196     ) internal virtual {
197         require(sender != address(0), "ERC20: transfer from the zero address");
198         require(recipient != address(0), "ERC20: transfer to the zero address");
199 
200         uint256 senderBalance = _balances[sender];
201         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
202         unchecked {
203             _balances[sender] = senderBalance - amount;
204         }
205         _balances[recipient] += amount;
206 
207         emit Transfer(sender, recipient, amount);
208     }
209 
210     function _createInitialSupply(address account, uint256 amount) internal virtual {
211         require(account != address(0), "ERC20: mint to the zero address");
212 
213         _totalSupply += amount;
214         _balances[account] += amount;
215         emit Transfer(address(0), account, amount);
216     }
217 
218     function _approve(
219         address owner,
220         address spender,
221         uint256 amount
222     ) internal virtual {
223         require(owner != address(0), "ERC20: approve from the zero address");
224         require(spender != address(0), "ERC20: approve to the zero address");
225 
226         _allowances[owner][spender] = amount;
227         emit Approval(owner, spender, amount);
228     }
229 }
230 
231 contract Ownable is Context {
232     address private _owner;
233 
234     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
235     
236     constructor () {
237         address msgSender = _msgSender();
238         _owner = msgSender;
239         emit OwnershipTransferred(address(0), msgSender);
240     }
241 
242     function owner() public view returns (address) {
243         return _owner;
244     }
245 
246     modifier onlyOwner() {
247         require(_owner == _msgSender(), "Ownable: caller is not the owner");
248         _;
249     }
250 
251     function renounceOwnership() external virtual onlyOwner {
252         emit OwnershipTransferred(_owner, address(0));
253         _owner = address(0);
254     }
255 
256     function transferOwnership(address newOwner) public virtual onlyOwner {
257         require(newOwner != address(0), "Ownable: new owner is the zero address");
258         emit OwnershipTransferred(_owner, newOwner);
259         _owner = newOwner;
260     }
261 }
262 
263 interface IDexRouter {
264     function factory() external pure returns (address);
265     function WETH() external pure returns (address);
266     
267     function swapExactTokensForETHSupportingFeeOnTransferTokens(
268         uint amountIn,
269         uint amountOutMin,
270         address[] calldata path,
271         address to,
272         uint deadline
273     ) external;
274 
275     function addLiquidityETH(
276         address token,
277         uint256 amountTokenDesired,
278         uint256 amountTokenMin,
279         uint256 amountETHMin,
280         address to,
281         uint256 deadline
282     )
283         external
284         payable
285         returns (
286             uint256 amountToken,
287             uint256 amountETH,
288             uint256 liquidity
289         );
290 }
291 
292 interface IDexFactory {
293     function createPair(address tokenA, address tokenB)
294         external
295         returns (address pair);
296 }
297 
298 contract LEAP is ERC20, Ownable {
299 
300     uint256 public maxBuyAmount;
301     uint256 public maxSellAmount;
302     uint256 public maxWalletAmount;
303 
304     IDexRouter public immutable uniswapV2Router;
305     address public immutable uniswapV2Pair;
306 
307     bool private swapping;
308     uint256 public swapTokensAtAmount;
309 
310     address public operationsAddress;
311     address public TaxAddress;
312 
313     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
314 
315     bool public limitsInEffect = true;
316     bool public tradingActive = false;
317     bool public swapEnabled = false;
318     
319      // Anti-bot and anti-whale mappings and variables
320     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
321     bool public transferDelayEnabled = true;
322 
323     uint256 public buyTotalFees;
324     uint256 public buyOperationsFee;
325     uint256 public buyLiquidityFee;
326     uint256 public buyTaxFee;
327 
328     uint256 public sellTotalFees;
329     uint256 public sellOperationsFee;
330     uint256 public sellLiquidityFee;
331     uint256 public sellTaxFee;
332 
333     uint256 public tokensForOperations;
334     uint256 public tokensForLiquidity;
335     uint256 public tokensForTax;
336     
337     /******************/
338 
339     // exlcude from fees and max transaction amount
340     mapping (address => bool) private _isExcludedFromFees;
341     mapping (address => bool) public _isExcludedMaxTransactionAmount;
342 
343     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
344     // could be subject to a maximum transfer amount
345     mapping (address => bool) public automatedMarketMakerPairs;
346 
347     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
348 
349     event EnabledTrading();
350     event RemovedLimits();
351 
352     event ExcludeFromFees(address indexed account, bool isExcluded);
353 
354     event UpdatedMaxBuyAmount(uint256 newAmount);
355 
356     event UpdatedMaxSellAmount(uint256 newAmount);
357 
358     event UpdatedMaxWalletAmount(uint256 newAmount);
359 
360     event UpdatedOperationsAddress(address indexed newWallet);
361 
362     event UpdatedTaxAddress(address indexed newWallet);
363 
364     event MaxTransactionExclusion(address _address, bool excluded);
365 
366     event SwapAndLiquify(
367         uint256 tokensSwapped,
368         uint256 ethReceived,
369         uint256 tokensIntoLiquidity
370     );
371 
372     event TransferForeignToken(address token, uint256 amount);
373 
374     constructor() ERC20( "Leap of Faith", "LEAP") {
375         
376         address newOwner = msg.sender;
377         
378         IDexRouter _uniswapV2Router = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
379 
380         _excludeFromMaxTransaction(address(_uniswapV2Router), true);
381         uniswapV2Router = _uniswapV2Router;
382         
383         uniswapV2Pair = IDexFactory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
384         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
385  
386         uint256 totalSupply = 1 * 1e8 * 1e18;
387         
388         maxBuyAmount = totalSupply * 20 / 1000; 
389         maxSellAmount = totalSupply * 15 / 1000; 
390         maxWalletAmount = totalSupply * 20 / 1000;
391         swapTokensAtAmount = totalSupply * 20 / 100000; 
392 
393         buyOperationsFee = 1;
394         buyLiquidityFee = 2;
395         buyTaxFee = 0;
396         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTaxFee;
397 
398         sellOperationsFee = 1;
399         sellLiquidityFee = 2;
400         sellTaxFee = 0;
401         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTaxFee;
402 
403         _excludeFromMaxTransaction(newOwner, true);
404         _excludeFromMaxTransaction(address(this), true);
405         _excludeFromMaxTransaction(address(0xdead), true);
406 
407         excludeFromFees(newOwner, true);
408         excludeFromFees(address(this), true);
409         excludeFromFees(address(0xdead), true);
410 
411         operationsAddress = address(0xe84B075836D72F68Ef11C547A4D5680F0bac2c73); // change this address to wallet u want for operations   
412         TaxAddress = address(0xe84B075836D72F68Ef11C547A4D5680F0bac2c73);  // change this address to the one for tax 
413         
414         _createInitialSupply(newOwner, totalSupply);
415         transferOwnership(newOwner);
416     }
417 
418     receive() external payable {}
419 
420     // once enabled, can never be turned off
421     function enableTrading() external onlyOwner {
422         require(!tradingActive, "Cannot reenable trading");
423         tradingActive = true;
424         swapEnabled = true;
425         tradingActiveBlock = block.number;
426         emit EnabledTrading();
427     }
428     
429     // remove limits after token is stable
430     function removeLimits() external onlyOwner {
431         limitsInEffect = false;
432         transferDelayEnabled = false;
433         emit RemovedLimits();
434     }
435     
436    
437     // disable Transfer delay - cannot be reenabled
438     function disableTransferDelay() external onlyOwner {
439         transferDelayEnabled = false;
440     }
441     
442     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
443         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max buy amount lower than 0.1%");
444         maxBuyAmount = newNum * (10**18);
445         emit UpdatedMaxBuyAmount(maxBuyAmount);
446     }
447     
448     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
449         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max sell amount lower than 0.1%");
450         maxSellAmount = newNum * (10**18);
451         emit UpdatedMaxSellAmount(maxSellAmount);
452     }
453 
454     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
455         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
456         maxWalletAmount = newNum * (10**18);
457         emit UpdatedMaxWalletAmount(maxWalletAmount);
458     }
459 
460     // change the minimum amount of tokens to sell from fees
461     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
462         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
463         require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
464         swapTokensAtAmount = newAmount;
465     }
466     
467     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
468         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
469         emit MaxTransactionExclusion(updAds, isExcluded);
470     }
471 
472     
473     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
474         if(!isEx){
475             require(updAds != uniswapV2Pair, "Cannot remove uniswap pair from max txn");
476         }
477         _isExcludedMaxTransactionAmount[updAds] = isEx;
478     }
479 
480     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
481         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
482 
483         _setAutomatedMarketMakerPair(pair, value);
484     }
485 
486     function _setAutomatedMarketMakerPair(address pair, bool value) private {
487         automatedMarketMakerPairs[pair] = value;
488         
489         _excludeFromMaxTransaction(pair, value);
490 
491         emit SetAutomatedMarketMakerPair(pair, value);
492     }
493 
494     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _TaxFee) external onlyOwner {
495         buyOperationsFee = _operationsFee;
496         buyLiquidityFee = _liquidityFee;
497         buyTaxFee = _TaxFee;
498         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTaxFee;
499         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
500     }
501 
502     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _TaxFee) external onlyOwner {
503         sellOperationsFee = _operationsFee;
504         sellLiquidityFee = _liquidityFee;
505         sellTaxFee = _TaxFee;
506         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTaxFee;
507         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
508     }
509 
510     function excludeFromFees(address account, bool excluded) public onlyOwner {
511         _isExcludedFromFees[account] = excluded;
512         emit ExcludeFromFees(account, excluded);
513     }
514 
515     function _transfer(address from, address to, uint256 amount) internal override {
516 
517         require(from != address(0), "ERC20: transfer from the zero address");
518         require(to != address(0), "ERC20: transfer to the zero address");
519         require(amount > 0, "amount must be greater than 0");
520         
521         
522         if(limitsInEffect){
523             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead)){
524                 if(!tradingActive){
525                     require(_isExcludedMaxTransactionAmount[from] || _isExcludedMaxTransactionAmount[to], "Trading is not active.");
526                 }
527                 
528                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
529                 if (transferDelayEnabled){
530                     if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
531                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 4 && _holderLastTransferTimestamp[to] < block.number - 4, "_transfer:: Transfer Delay enabled.  Try again later.");
532                         _holderLastTransferTimestamp[tx.origin] = block.number;
533                         _holderLastTransferTimestamp[to] = block.number;
534                     }
535                 }
536                  
537                 //when buy
538                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
539                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
540                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
541                 } 
542                 //when sell
543                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
544                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
545                 } 
546                 else if (!_isExcludedMaxTransactionAmount[to] && !_isExcludedMaxTransactionAmount[from]){
547                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
548                 }
549             }
550         }
551 
552         uint256 contractTokenBalance = balanceOf(address(this));
553         
554         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
555 
556         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
557             swapping = true;
558 
559             swapBack();
560 
561             swapping = false;
562         }
563 
564         bool takeFee = true;
565         // if any account belongs to _isExcludedFromFee account then remove the fee
566         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
567             takeFee = false;
568         }
569         
570         uint256 fees = 0;
571         uint256 penaltyAmount = 0;
572         // only take fees on buys/sells, do not take on wallet transfers
573         if(takeFee){
574             // bot/sniper penalty.  Tokens get transferred to marketing wallet to allow potential refund.
575             if(tradingActiveBlock >= block.number + 1 && automatedMarketMakerPairs[from]){
576                 penaltyAmount = amount * 99 / 100;
577                 super._transfer(from, operationsAddress, penaltyAmount);
578             }
579             // on sell
580             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
581                 fees = amount * sellTotalFees /100;
582                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
583                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
584                 tokensForTax += fees * sellTaxFee / sellTotalFees;
585             }
586             // on buy
587             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
588                 fees = amount * buyTotalFees / 100;
589                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
590                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
591                 tokensForTax += fees * buyTaxFee / buyTotalFees;
592             }
593             
594             if(fees > 0){    
595                 super._transfer(from, address(this), fees);
596             }
597             
598             amount -= fees + penaltyAmount;
599         }
600 
601         super._transfer(from, to, amount);
602     }
603 
604     function swapTokensForEth(uint256 tokenAmount) private {
605 
606         // generate the uniswap pair path of token -> weth
607         address[] memory path = new address[](2);
608         path[0] = address(this);
609         path[1] = uniswapV2Router.WETH();
610 
611         _approve(address(this), address(uniswapV2Router), tokenAmount);
612 
613         // make the swap
614         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
615             tokenAmount,
616             0, // accept any amount of ETH
617             path,
618             address(this),
619             block.timestamp
620         );
621     }
622     
623     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
624         // approve token transfer to cover all possible scenarios
625         _approve(address(this), address(uniswapV2Router), tokenAmount);
626 
627         // add the liquidity
628         uniswapV2Router.addLiquidityETH{value: ethAmount}(
629             address(this),
630             tokenAmount,
631             0, // slippage is unavoidable
632             0, // slippage is unavoidable
633             address(0xdead),
634             block.timestamp
635         );
636     }
637 
638     function swapBack() private {
639         uint256 contractBalance = balanceOf(address(this));
640         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForTax;
641         
642         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
643 
644         if(contractBalance > swapTokensAtAmount * 10){
645             contractBalance = swapTokensAtAmount * 10;
646         }
647 
648         bool success;
649         
650         // Halve the amount of liquidity tokens
651         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
652         
653         swapTokensForEth(contractBalance - liquidityTokens); 
654         
655         uint256 ethBalance = address(this).balance;
656         uint256 ethForLiquidity = ethBalance;
657 
658         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
659         uint256 ethForTax = ethBalance * tokensForTax / (totalTokensToSwap - (tokensForLiquidity/2));
660 
661         ethForLiquidity -= ethForOperations + ethForTax;
662             
663         tokensForLiquidity = 0;
664         tokensForOperations = 0;
665         tokensForTax = 0;
666         
667         if(liquidityTokens > 0 && ethForLiquidity > 0){
668             addLiquidity(liquidityTokens, ethForLiquidity);
669         }
670 
671         (success,) = address(TaxAddress).call{value: ethForTax}("");
672 
673         (success,) = address(operationsAddress).call{value: address(this).balance}("");
674     }
675 
676     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
677         require(_token != address(0), "_token address cannot be 0");
678         require(_token != address(this), "Can't withdraw native tokens");
679         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
680         _sent = IERC20(_token).transfer(_to, _contractBalance);
681         emit TransferForeignToken(_token, _contractBalance);
682     }
683 
684     // withdraw ETH if stuck or someone sends to the address
685     function withdrawStuckETH() external onlyOwner {
686         bool success;
687         (success,) = address(msg.sender).call{value: address(this).balance}("");
688     }
689 
690     function setOperationsAddress(address _operationsAddress) external onlyOwner {
691         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
692         operationsAddress = payable(_operationsAddress);
693         emit UpdatedOperationsAddress(_operationsAddress);
694     }
695 
696     function setTaxAddress(address _TaxAddress) external onlyOwner {
697         require(_TaxAddress != address(0), "_TaxAddress address cannot be 0");
698         TaxAddress = payable(_TaxAddress);
699         emit UpdatedTaxAddress(_TaxAddress);
700     }
701 }