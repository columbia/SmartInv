1 // SPDX-License-Identifier: MIT
2 
3 /*
4  _____                              _    _     
5 /  ___|                            | |  | |    
6 \ `--. __      __  ___   ___   ___ | |_ | |__  
7  `--. \\ \ /\ / / / _ \ / _ \ / _ \| __|| '_ \ 
8 /\__/ / \ V  V / |  __/|  __/|  __/| |_ | | | |
9 \____/   \_/\_/   \___| \___| \___| \__||_| |_|
10 
11 * Socials :
12 * https://sweeth.is
13 * https://twitter.com/SWEETHtoken
14 
15 */
16 pragma solidity 0.8.11;
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 interface IERC20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      *
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(
84         address sender,
85         address recipient,
86         uint256 amount
87     ) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 interface IERC20Metadata is IERC20 {
105     /**
106      * @dev Returns the name of the token.
107      */
108     function name() external view returns (string memory);
109 
110     /**
111      * @dev Returns the symbol of the token.
112      */
113     function symbol() external view returns (string memory);
114 
115     /**
116      * @dev Returns the decimals places of the token.
117      */
118     function decimals() external view returns (uint8);
119 }
120 
121 contract ERC20 is Context, IERC20, IERC20Metadata {
122     mapping(address => uint256) private _balances;
123 
124     mapping(address => mapping(address => uint256)) private _allowances;
125 
126     uint256 private _totalSupply;
127 
128     string private _name;
129     string private _symbol;
130 
131     constructor(string memory name_, string memory symbol_) {
132         _name = name_;
133         _symbol = symbol_;
134     }
135 
136     function name() public view virtual override returns (string memory) {
137         return _name;
138     }
139 
140     function symbol() public view virtual override returns (string memory) {
141         return _symbol;
142     }
143 
144     function decimals() public view virtual override returns (uint8) {
145         return 18;
146     }
147 
148     function totalSupply() public view virtual override returns (uint256) {
149         return _totalSupply;
150     }
151 
152     function balanceOf(address account) public view virtual override returns (uint256) {
153         return _balances[account];
154     }
155 
156     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
157         _transfer(_msgSender(), recipient, amount);
158         return true;
159     }
160 
161     function allowance(address owner, address spender) public view virtual override returns (uint256) {
162         return _allowances[owner][spender];
163     }
164 
165     function approve(address spender, uint256 amount) public virtual override returns (bool) {
166         _approve(_msgSender(), spender, amount);
167         return true;
168     }
169 
170     function transferFrom(
171         address sender,
172         address recipient,
173         uint256 amount
174     ) public virtual override returns (bool) {
175         _transfer(sender, recipient, amount);
176 
177         uint256 currentAllowance = _allowances[sender][_msgSender()];
178         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
179     unchecked {
180         _approve(sender, _msgSender(), currentAllowance - amount);
181     }
182 
183         return true;
184     }
185 
186     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
187         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
188         return true;
189     }
190 
191     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
192         uint256 currentAllowance = _allowances[_msgSender()][spender];
193         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
194     unchecked {
195         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
196     }
197 
198         return true;
199     }
200 
201     function _transfer(
202         address sender,
203         address recipient,
204         uint256 amount
205     ) internal virtual {
206         require(sender != address(0), "ERC20: transfer from the zero address");
207         require(recipient != address(0), "ERC20: transfer to the zero address");
208 
209         uint256 senderBalance = _balances[sender];
210         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
211     unchecked {
212         _balances[sender] = senderBalance - amount;
213     }
214         _balances[recipient] += amount;
215 
216         emit Transfer(sender, recipient, amount);
217     }
218 
219     function _createInitialSupply(address account, uint256 amount) internal virtual {
220         require(account != address(0), "ERC20: mint to the zero address");
221 
222         _totalSupply += amount;
223         _balances[account] += amount;
224         emit Transfer(address(0), account, amount);
225     }
226 
227     function _approve(
228         address owner,
229         address spender,
230         uint256 amount
231     ) internal virtual {
232         require(owner != address(0), "ERC20: approve from the zero address");
233         require(spender != address(0), "ERC20: approve to the zero address");
234 
235         _allowances[owner][spender] = amount;
236         emit Approval(owner, spender, amount);
237     }
238 }
239 
240 contract Ownable is Context {
241     address private _owner;
242 
243     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
244 
245     constructor () {
246         address msgSender = _msgSender();
247         _owner = msgSender;
248         emit OwnershipTransferred(address(0), msgSender);
249     }
250 
251     function owner() public view returns (address) {
252         return _owner;
253     }
254 
255     modifier onlyOwner() {
256         require(_owner == _msgSender(), "Ownable: caller is not the owner");
257         _;
258     }
259 
260     function renounceOwnership() external virtual onlyOwner {
261         emit OwnershipTransferred(_owner, address(0));
262         _owner = address(0);
263     }
264 
265     function transferOwnership(address newOwner) public virtual onlyOwner {
266         require(newOwner != address(0), "Ownable: new owner is the zero address");
267         emit OwnershipTransferred(_owner, newOwner);
268         _owner = newOwner;
269     }
270 }
271 
272 interface IDexRouter {
273     function factory() external pure returns (address);
274     function WETH() external pure returns (address);
275 
276     function swapExactTokensForETHSupportingFeeOnTransferTokens(
277         uint amountIn,
278         uint amountOutMin,
279         address[] calldata path,
280         address to,
281         uint deadline
282     ) external;
283 
284     function addLiquidityETH(
285         address token,
286         uint256 amountTokenDesired,
287         uint256 amountTokenMin,
288         uint256 amountETHMin,
289         address to,
290         uint256 deadline
291     )
292     external
293     payable
294     returns (
295         uint256 amountToken,
296         uint256 amountETH,
297         uint256 liquidity
298     );
299 }
300 
301 interface IDexFactory {
302     function createPair(address tokenA, address tokenB)
303     external
304     returns (address pair);
305 }
306 
307 contract Sweeth is ERC20, Ownable {
308 
309     uint256 public maxBuyAmount;
310     uint256 public maxSellAmount;
311     uint256 public maxWalletAmount;
312 
313     IDexRouter public immutable uniswapV2Router;
314     address public immutable uniswapV2Pair;
315 
316     bool private swapping;
317     uint256 public swapTokensAtAmount;
318 
319     address public marketingAddress;
320     address public rewardsAddress;
321 
322     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
323 
324     bool public limitsInEffect = true;
325     bool public tradingActive = false;
326     bool public swapEnabled = false;
327 
328     // Anti-bot and anti-whale mappings and variables
329     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
330     bool public transferDelayEnabled = true;
331 
332     uint256 public buyTotalFees;
333     uint256 public buyMarketingFee;
334     uint256 public buyLiquidityFee;
335     uint256 public buyRewardsFee;
336 
337     uint256 public sellTotalFees;
338     uint256 public sellMarketingFee;
339     uint256 public sellLiquidityFee;
340     uint256 public sellrewardsFee;
341 
342     uint256 public tokensForMarketing;
343     uint256 public tokensForLiquidity;
344     uint256 public tokensForRewards;
345 
346     /******************/
347 
348     // exlcude from fees and max transaction amount
349     mapping (address => bool) private _isExcludedFromFees;
350     mapping (address => bool) public _isExcludedMaxTransactionAmount;
351 
352     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
353     // could be subject to a maximum transfer amount
354     mapping (address => bool) public automatedMarketMakerPairs;
355 
356     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
357 
358     event EnabledTrading();
359     event RemovedLimits();
360 
361     event ExcludeFromFees(address indexed account, bool isExcluded);
362 
363     event UpdatedMaxBuyAmount(uint256 newAmount);
364 
365     event UpdatedMaxSellAmount(uint256 newAmount);
366 
367     event UpdatedMaxWalletAmount(uint256 newAmount);
368 
369     event UpdatedMarketingAddress(address indexed newWallet);
370 
371     event UpdatedRewardsAddress(address indexed newWallet);
372 
373     event MaxTransactionExclusion(address _address, bool excluded);
374 
375     event SwapAndLiquify(
376         uint256 tokensSwapped,
377         uint256 ethReceived,
378         uint256 tokensIntoLiquidity
379     );
380 
381     event TransferForeignToken(address token, uint256 amount);
382 
383     constructor() ERC20("Sweeth", "SWEETH") {
384 
385         address newOwner = msg.sender; // can leave alone if owner is deployer.
386 
387         IDexRouter _uniswapV2Router = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
388 
389         _excludeFromMaxTransaction(address(_uniswapV2Router), true);
390         uniswapV2Router = _uniswapV2Router;
391 
392         uniswapV2Pair = IDexFactory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
393         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
394 
395         uint256 totalSupply = 100 * 1e9 * 1e18;
396 
397         maxBuyAmount = totalSupply * 2 / 1000;
398         maxSellAmount = totalSupply * 5 / 1000;
399         maxWalletAmount = totalSupply * 10 / 1000;
400         swapTokensAtAmount = totalSupply * 25 / 100000; // 0.025% swap amount
401 
402         buyMarketingFee = 6;
403         buyLiquidityFee = 2;
404         buyRewardsFee = 2;
405         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyRewardsFee;
406 
407         sellMarketingFee = 16;
408         sellLiquidityFee = 4;
409         sellrewardsFee = 10;
410         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellrewardsFee;
411 
412         marketingAddress = address(0xaD242F79780B5c225f59DE8Db350a0C8CB80898A);
413         rewardsAddress = address(0x7fdF0B507e3fdc1dD3F64f0db7c97972daac4D48);
414 
415         _excludeFromMaxTransaction(newOwner, true);
416         _excludeFromMaxTransaction(address(this), true);
417         _excludeFromMaxTransaction(address(0xdead), true);
418 
419         excludeFromFees(newOwner, true);
420         excludeFromFees(address(this), true);
421         excludeFromFees(address(0xdead), true);
422 
423 
424         _createInitialSupply(newOwner, totalSupply);
425         transferOwnership(newOwner);
426     }
427 
428     receive() external payable {}
429 
430     // once enabled, can never be turned off
431     function enableTrading() external onlyOwner {
432         require(!tradingActive, "Cannot re enable trading");
433         tradingActive = true;
434         swapEnabled = true;
435         tradingActiveBlock = block.number;
436         emit EnabledTrading();
437     }
438 
439     // remove limits after token is stable
440     function removeLimits() external onlyOwner {
441         limitsInEffect = false;
442         transferDelayEnabled = false;
443         emit RemovedLimits();
444     }
445 
446 
447     // disable Transfer delay - cannot be re enabled
448     function disableTransferDelay() external onlyOwner {
449         transferDelayEnabled = false;
450     }
451 
452     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
453         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max buy amount lower than 0.1%");
454         maxBuyAmount = newNum * (10**18);
455         emit UpdatedMaxBuyAmount(maxBuyAmount);
456     }
457 
458     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
459         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max sell amount lower than 0.1%");
460         maxSellAmount = newNum * (10**18);
461         emit UpdatedMaxSellAmount(maxSellAmount);
462     }
463 
464     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
465         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
466         maxWalletAmount = newNum * (10**18);
467         emit UpdatedMaxWalletAmount(maxWalletAmount);
468     }
469 
470     // change the minimum amount of tokens to sell from fees
471     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
472         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
473         require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
474         swapTokensAtAmount = newAmount;
475     }
476 
477     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
478         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
479         emit MaxTransactionExclusion(updAds, isExcluded);
480     }
481 
482 
483     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
484         if(!isEx){
485             require(updAds != uniswapV2Pair, "Cannot remove uniswap pair from max txn");
486         }
487         _isExcludedMaxTransactionAmount[updAds] = isEx;
488     }
489 
490     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
491         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
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
504     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _rewardsFee) external onlyOwner {
505         buyMarketingFee = _marketingFee;
506         buyLiquidityFee = _liquidityFee;
507         buyRewardsFee = _rewardsFee;
508         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyRewardsFee;
509         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
510     }
511 
512     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _rewardsFee) external onlyOwner {
513         sellMarketingFee = _marketingFee;
514         sellLiquidityFee = _liquidityFee;
515         sellrewardsFee = _rewardsFee;
516         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellrewardsFee;
517         require(sellTotalFees <= 30, "Must keep fees at 20% or less");
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
540                     if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
541                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 4 && _holderLastTransferTimestamp[to] < block.number - 4, "_transfer:: Transfer Delay enabled.  Try again later.");
542                         _holderLastTransferTimestamp[tx.origin] = block.number;
543                         _holderLastTransferTimestamp[to] = block.number;
544                     }
545                 }
546 
547                 //when buy
548                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
549                     require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
550                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
551                 }
552                 //when sell
553                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
554                     require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
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
582         // only take fees on Trades, not on wallet transfers
583 
584         if(takeFee){
585             // bot/sniper penalty.  Tokens get transferred to marketing wallet and ETH to liquidity.
586             if(tradingActiveBlock>0 && (tradingActiveBlock + 3) > block.number){
587                 penaltyAmount = amount * 99 / 100;
588                 super._transfer(from, marketingAddress, penaltyAmount);
589             }
590             // on sell
591             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
592                 fees = amount * sellTotalFees /100;
593                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
594                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
595                 tokensForRewards += fees * sellrewardsFee / sellTotalFees;
596             }
597             // on buy
598             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
599                 fees = amount * buyTotalFees / 100;
600                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
601                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
602                 tokensForRewards += fees * buyRewardsFee / buyTotalFees;
603             }
604 
605             if(fees > 0){
606                 super._transfer(from, address(this), fees);
607             }
608 
609             amount -= fees + penaltyAmount;
610         }
611 
612         super._transfer(from, to, amount);
613     }
614 
615     function swapTokensForEth(uint256 tokenAmount) private {
616 
617         // generate the uniswap pair path of token -> weth
618         address[] memory path = new address[](2);
619         path[0] = address(this);
620         path[1] = uniswapV2Router.WETH();
621 
622         _approve(address(this), address(uniswapV2Router), tokenAmount);
623 
624         // make the swap
625         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
626             tokenAmount,
627             0, // accept any amount of ETH
628             path,
629             address(this),
630             block.timestamp
631         );
632     }
633 
634     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
635         // approve token transfer to cover all possible scenarios
636         _approve(address(this), address(uniswapV2Router), tokenAmount);
637 
638         // add the liquidity
639         uniswapV2Router.addLiquidityETH{value: ethAmount}(
640             address(this),
641             tokenAmount,
642             0, // slippage is unavoidable
643             0, // slippage is unavoidable
644             address(owner()),
645             block.timestamp
646         );
647     }
648 
649     function swapBack() private {
650         uint256 contractBalance = balanceOf(address(this));
651         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForRewards;
652 
653         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
654 
655         if(contractBalance > swapTokensAtAmount * 10){
656             contractBalance = swapTokensAtAmount * 10;
657         }
658 
659         bool success;
660 
661         // Halve the amount of liquidity tokens
662         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
663 
664         swapTokensForEth(contractBalance - liquidityTokens);
665 
666         uint256 ethBalance = address(this).balance;
667         uint256 ethForLiquidity = ethBalance;
668 
669         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
670         uint256 ethForRewards = ethBalance * tokensForRewards / (totalTokensToSwap - (tokensForLiquidity/2));
671 
672         ethForLiquidity -= ethForMarketing + ethForRewards;
673 
674         tokensForLiquidity = 0;
675         tokensForMarketing = 0;
676         tokensForRewards = 0;
677 
678         if(liquidityTokens > 0 && ethForLiquidity > 0){
679             addLiquidity(liquidityTokens, ethForLiquidity);
680         }
681 
682         (success,) = address(rewardsAddress).call{value: ethForRewards}("");
683 
684         (success,) = address(marketingAddress).call{value: address(this).balance}("");
685     }
686 
687     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
688         require(_token != address(0), "_token address cannot be 0");
689         require(_token != address(this), "Can't withdraw native tokens");
690         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
691         _sent = IERC20(_token).transfer(_to, _contractBalance);
692         emit TransferForeignToken(_token, _contractBalance);
693     }
694 
695     // withdraw ETH if stuck or someone sends to the address
696     function withdrawStuckETH() external onlyOwner {
697         bool success;
698         (success,) = address(msg.sender).call{value: address(this).balance}("");
699     }
700 
701     function setMarketingAddress(address _marketingAddress) external onlyOwner {
702         require(_marketingAddress != address(0), "_marketingAddress address cannot be 0");
703         marketingAddress = payable(_marketingAddress);
704         emit UpdatedMarketingAddress(_marketingAddress);
705     }
706 
707     function setRewardsAddress(address _rewardsAddress) external onlyOwner {
708         require(_rewardsAddress != address(0), "_rewardsAddress address cannot be 0");
709         rewardsAddress = payable(_rewardsAddress);
710         emit UpdatedRewardsAddress(_rewardsAddress);
711     }
712 }