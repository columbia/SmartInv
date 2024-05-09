1 // SPDX-License-Identifier: MIT
2 //
3 //
4 //  __       __   ______   _______   _______   __        ________  __    __ 
5 // |  \     /  \ /      \ |       \ |       \ |  \      |        \|  \  |  \
6 // | $$\   /  $$|  $$$$$$\| $$$$$$$\| $$$$$$$\| $$      | $$$$$$$$| $$  | $$
7 // | $$$\ /  $$$| $$__| $$| $$__| $$| $$__/ $$| $$      | $$__     \$$\/  $$
8 // | $$$$\  $$$$| $$    $$| $$    $$| $$    $$| $$      | $$  \     >$$  $$ 
9 // | $$\$$ $$ $$| $$$$$$$$| $$$$$$$\| $$$$$$$\| $$      | $$$$$    /  $$$$\ 
10 // | $$ \$$$| $$| $$  | $$| $$  | $$| $$__/ $$| $$_____ | $$_____ |  $$ \$$\
11 // | $$  \$ | $$| $$  | $$| $$  | $$| $$    $$| $$     \| $$     \| $$  | $$
12 //  \$$      \$$ \$$   \$$ \$$   \$$ \$$$$$$$  \$$$$$$$$ \$$$$$$$$ \$$   \$$
13 //                                                                                                                                                                                                           
14 // Socials : https://www.Marblex.live
15 // 
16 
17 pragma solidity 0.8.11;
18 
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 interface IERC20 {
31     /**
32      * @dev Returns the amount of tokens in existence.
33      */
34     function totalSupply() external view returns (uint256);
35 
36     /**
37      * @dev Returns the amount of tokens owned by `account`.
38      */
39     function balanceOf(address account) external view returns (uint256);
40 
41     /**
42      * @dev Moves `amount` tokens from the caller's account to `recipient`.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * Emits a {Transfer} event.
47      */
48     function transfer(address recipient, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Returns the remaining number of tokens that `spender` will be
52      * allowed to spend on behalf of `owner` through {transferFrom}. This is
53      * zero by default.
54      *
55      * This value changes when {approve} or {transferFrom} are called.
56      */
57     function allowance(address owner, address spender) external view returns (uint256);
58 
59     /**
60      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * IMPORTANT: Beware that changing an allowance with this method brings the risk
65      * that someone may use both the old and the new allowance by unfortunate
66      * transaction ordering. One possible solution to mitigate this race
67      * condition is to first reduce the spender's allowance to 0 and set the
68      * desired value afterwards:
69      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
70      *
71      * Emits an {Approval} event.
72      */
73     function approve(address spender, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Moves `amount` tokens from `sender` to `recipient` using the
77      * allowance mechanism. `amount` is then deducted from the caller's
78      * allowance.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * Emits a {Transfer} event.
83      */
84     function transferFrom(
85         address sender,
86         address recipient,
87         uint256 amount
88     ) external returns (bool);
89 
90     /**
91      * @dev Emitted when `value` tokens are moved from one account (`from`) to
92      * another (`to`).
93      *
94      * Note that `value` may be zero.
95      */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100      * a call to {approve}. `value` is the new allowance.
101      */
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 interface IERC20Metadata is IERC20 {
106     /**
107      * @dev Returns the name of the token.
108      */
109     function name() external view returns (string memory);
110 
111     /**
112      * @dev Returns the symbol of the token.
113      */
114     function symbol() external view returns (string memory);
115 
116     /**
117      * @dev Returns the decimals places of the token.
118      */
119     function decimals() external view returns (uint8);
120 }
121 
122 contract ERC20 is Context, IERC20, IERC20Metadata {
123     mapping(address => uint256) private _balances;
124 
125     mapping(address => mapping(address => uint256)) private _allowances;
126 
127     uint256 private _totalSupply;
128 
129     string private _name;
130     string private _symbol;
131 
132     constructor(string memory name_, string memory symbol_) {
133         _name = name_;
134         _symbol = symbol_;
135     }
136 
137     function name() public view virtual override returns (string memory) {
138         return _name;
139     }
140 
141     function symbol() public view virtual override returns (string memory) {
142         return _symbol;
143     }
144 
145     function decimals() public view virtual override returns (uint8) {
146         return 18;
147     }
148 
149     function totalSupply() public view virtual override returns (uint256) {
150         return _totalSupply;
151     }
152 
153     function balanceOf(address account) public view virtual override returns (uint256) {
154         return _balances[account];
155     }
156 
157     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
158         _transfer(_msgSender(), recipient, amount);
159         return true;
160     }
161 
162     function allowance(address owner, address spender) public view virtual override returns (uint256) {
163         return _allowances[owner][spender];
164     }
165 
166     function approve(address spender, uint256 amount) public virtual override returns (bool) {
167         _approve(_msgSender(), spender, amount);
168         return true;
169     }
170 
171     function transferFrom(
172         address sender,
173         address recipient,
174         uint256 amount
175     ) public virtual override returns (bool) {
176         _transfer(sender, recipient, amount);
177 
178         uint256 currentAllowance = _allowances[sender][_msgSender()];
179         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
180     unchecked {
181         _approve(sender, _msgSender(), currentAllowance - amount);
182     }
183 
184         return true;
185     }
186 
187     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
188         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
189         return true;
190     }
191 
192     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
193         uint256 currentAllowance = _allowances[_msgSender()][spender];
194         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
195     unchecked {
196         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
197     }
198 
199         return true;
200     }
201 
202     function _transfer(
203         address sender,
204         address recipient,
205         uint256 amount
206     ) internal virtual {
207         require(sender != address(0), "ERC20: transfer from the zero address");
208         require(recipient != address(0), "ERC20: transfer to the zero address");
209 
210         uint256 senderBalance = _balances[sender];
211         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
212     unchecked {
213         _balances[sender] = senderBalance - amount;
214     }
215         _balances[recipient] += amount;
216 
217         emit Transfer(sender, recipient, amount);
218     }
219 
220     function _createInitialSupply(address account, uint256 amount) internal virtual {
221         require(account != address(0), "ERC20: mint to the zero address");
222 
223         _totalSupply += amount;
224         _balances[account] += amount;
225         emit Transfer(address(0), account, amount);
226     }
227 
228     function _approve(
229         address owner,
230         address spender,
231         uint256 amount
232     ) internal virtual {
233         require(owner != address(0), "ERC20: approve from the zero address");
234         require(spender != address(0), "ERC20: approve to the zero address");
235 
236         _allowances[owner][spender] = amount;
237         emit Approval(owner, spender, amount);
238     }
239 }
240 
241 contract Ownable is Context {
242     address private _owner;
243 
244     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
245 
246     constructor () {
247         address msgSender = _msgSender();
248         _owner = msgSender;
249         emit OwnershipTransferred(address(0), msgSender);
250     }
251 
252     function owner() public view returns (address) {
253         return _owner;
254     }
255 
256     modifier onlyOwner() {
257         require(_owner == _msgSender(), "Ownable: caller is not the owner");
258         _;
259     }
260 
261     function renounceOwnership() external virtual onlyOwner {
262         emit OwnershipTransferred(_owner, address(0));
263         _owner = address(0);
264     }
265 
266     function transferOwnership(address newOwner) public virtual onlyOwner {
267         require(newOwner != address(0), "Ownable: new owner is the zero address");
268         emit OwnershipTransferred(_owner, newOwner);
269         _owner = newOwner;
270     }
271 }
272 
273 interface IDexRouter {
274     function factory() external pure returns (address);
275     function WETH() external pure returns (address);
276 
277     function swapExactTokensForETHSupportingFeeOnTransferTokens(
278         uint amountIn,
279         uint amountOutMin,
280         address[] calldata path,
281         address to,
282         uint deadline
283     ) external;
284 
285     function addLiquidityETH(
286         address token,
287         uint256 amountTokenDesired,
288         uint256 amountTokenMin,
289         uint256 amountETHMin,
290         address to,
291         uint256 deadline
292     )
293     external
294     payable
295     returns (
296         uint256 amountToken,
297         uint256 amountETH,
298         uint256 liquidity
299     );
300 }
301 
302 interface IDexFactory {
303     function createPair(address tokenA, address tokenB)
304     external
305     returns (address pair);
306 }
307 
308 contract MarbleX is ERC20, Ownable {
309 
310     uint256 public maxBuyAmount;
311     uint256 public maxSellAmount;
312     uint256 public maxWalletAmount;
313 
314     IDexRouter public immutable uniswapV2Router;
315     address public immutable uniswapV2Pair;
316 
317     bool private swapping;
318     uint256 public swapTokensAtAmount;
319 
320     address public marketingAddress;
321     address public RaceAddress;
322 
323     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
324 
325     bool public limitsInEffect = true;
326     bool public tradingActive = false;
327     bool public swapEnabled = false;
328     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last    Transfers temporarily during launch
329     bool public transferDelayEnabled = true;
330 
331     uint256 public buyTotalFees;
332     uint256 public buyMarketingFee;
333     uint256 public buyLiquidityFee;
334     uint256 public buyRaceFee;
335 
336     uint256 public sellTotalFees;
337     uint256 public sellMarketingFee;
338     uint256 public sellLiquidityFee;
339     uint256 public sellRaceFee;
340 
341     uint256 public tokensForMarketing;
342     uint256 public tokensForLiquidity;
343     uint256 public tokensForRace;
344 
345     /******************/
346 
347     // exlcude from fees and max transaction amount
348     mapping (address => bool) private _isExcludedFromFees;
349     mapping (address => bool) public _isExcludedMaxTransactionAmount;
350 
351     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
352     // could be subject to a maximum transfer amount
353     mapping (address => bool) public automatedMarketMakerPairs;
354 
355     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
356 
357     event EnabledTrading();
358     event RemovedLimits();
359 
360     event ExcludeFromFees(address indexed account, bool isExcluded);
361 
362     event UpdatedMaxBuyAmount(uint256 newAmount);
363 
364     event UpdatedMaxSellAmount(uint256 newAmount);
365 
366     event UpdatedMaxWalletAmount(uint256 newAmount);
367 
368     event UpdatedMarketingAddress(address indexed newWallet);
369 
370     event UpdatedRaceAddress(address indexed newWallet);
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
382     constructor() ERC20("MarbleX", "MarbleX") {
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
394         uint256 totalSupply = 100_000_000_000 * 1e18;
395 
396         maxBuyAmount = totalSupply * 2 / 1000;
397         maxSellAmount = totalSupply * 5 / 1000;
398         maxWalletAmount = totalSupply * 10 / 1000;
399         swapTokensAtAmount = totalSupply * 25 / 100000; // 0.025% swap amount
400 
401         buyMarketingFee = 10;
402         buyLiquidityFee = 5;
403         buyRaceFee = 10;
404         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyRaceFee;
405 
406         sellMarketingFee = 10;
407         sellLiquidityFee = 5;
408         sellRaceFee = 10;
409         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellRaceFee;
410 
411         marketingAddress = address(0x6bFC097B384f254474793E164289531B0CB57728);
412         RaceAddress = address(0xdC6741CAfC3bd0Bb7eaC0C4E0d281F63f6c00f7F);
413 
414         _excludeFromMaxTransaction(newOwner, true);
415         _excludeFromMaxTransaction(address(this), true);
416         _excludeFromMaxTransaction(address(0xdead), true);
417 
418         excludeFromFees(newOwner, true);
419         excludeFromFees(address(this), true);
420         excludeFromFees(address(0xdead), true);
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
446     // disable Transfer delay - cannot be re enabled
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
464         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
465         maxWalletAmount = newNum * (10**18);
466         emit UpdatedMaxWalletAmount(maxWalletAmount);
467     }
468 
469     // change the minimum amount of tokens to sell from fees
470     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
471         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
472         require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
473         swapTokensAtAmount = newAmount;
474     }
475 
476     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
477         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
478         emit MaxTransactionExclusion(updAds, isExcluded);
479     }
480 
481 
482     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
483         if(!isEx){
484             require(updAds != uniswapV2Pair, "Cannot remove uniswap pair from max txn");
485         }
486         _isExcludedMaxTransactionAmount[updAds] = isEx;
487     }
488 
489     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
490         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
491 
492         _setAutomatedMarketMakerPair(pair, value);
493     }
494 
495     function _setAutomatedMarketMakerPair(address pair, bool value) private {
496         automatedMarketMakerPairs[pair] = value;
497 
498         _excludeFromMaxTransaction(pair, value);
499 
500         emit SetAutomatedMarketMakerPair(pair, value);
501     }
502 
503     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _RaceFee) external onlyOwner {
504         buyMarketingFee = _marketingFee;
505         buyLiquidityFee = _liquidityFee;
506         buyRaceFee = _RaceFee;
507         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyRaceFee;
508         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
509     }
510 
511     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _RaceFee) external onlyOwner {
512         sellMarketingFee = _marketingFee;
513         sellLiquidityFee = _liquidityFee;
514         sellRaceFee = _RaceFee;
515         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellRaceFee;
516         require(sellTotalFees <= 30, "Must keep fees at 20% or less");
517     }
518 
519     function excludeFromFees(address account, bool excluded) public onlyOwner {
520         _isExcludedFromFees[account] = excluded;
521         emit ExcludeFromFees(account, excluded);
522     }
523 
524     function _transfer(address from, address to, uint256 amount) internal override {
525 
526         require(from != address(0), "ERC20: transfer from the zero address");
527         require(to != address(0), "ERC20: transfer to the zero address");
528         require(amount > 0, "amount must be greater than 0");
529 
530 
531         if(limitsInEffect){
532             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead)){
533                 if(!tradingActive){
534                     require(_isExcludedMaxTransactionAmount[from] || _isExcludedMaxTransactionAmount[to], "Trading is not active.");
535                 }
536 
537                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
538                 if (transferDelayEnabled){
539                     if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
540                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 4 && _holderLastTransferTimestamp[to] < block.number - 4, "_transfer:: Transfer Delay enabled.  Try again later.");
541                         _holderLastTransferTimestamp[tx.origin] = block.number;
542                         _holderLastTransferTimestamp[to] = block.number;
543                     }
544                 }
545 
546                 //when buy
547                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
548                     require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
549                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
550                 }
551                 //when sell
552                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
553                     require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
554                 }
555                 else if (!_isExcludedMaxTransactionAmount[to] && !_isExcludedMaxTransactionAmount[from]){
556                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
557                 }
558             }
559         }
560 
561         uint256 contractTokenBalance = balanceOf(address(this));
562 
563         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
564 
565         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
566             swapping = true;
567 
568             swapBack();
569 
570             swapping = false;
571         }
572 
573         bool takeFee = true;
574         // if any account belongs to _isExcludedFromFee account then remove the fee
575         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
576             takeFee = false;
577         }
578 
579         uint256 fees = 0;
580         uint256 penaltyAmount = 0;
581         // only take fees on Trades, not on wallet transfers
582 
583         if(takeFee){
584 
585             if(tradingActiveBlock>0 && (tradingActiveBlock + 3) > block.number){
586                 penaltyAmount = amount * 99 / 100;
587                 super._transfer(from, marketingAddress, penaltyAmount);
588             }
589             // on sell
590             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
591                 fees = amount * sellTotalFees /100;
592                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
593                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
594                 tokensForRace += fees * sellRaceFee / sellTotalFees;
595             }
596             // on buy
597             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
598                 fees = amount * buyTotalFees / 100;
599                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
600                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
601                 tokensForRace += fees * buyRaceFee / buyTotalFees;
602             }
603 
604             if(fees > 0){
605                 super._transfer(from, address(this), fees);
606             }
607 
608             amount -= fees + penaltyAmount;
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
619         path[1] = uniswapV2Router.WETH();
620 
621         _approve(address(this), address(uniswapV2Router), tokenAmount);
622 
623         // make the swap
624         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
625             tokenAmount,
626             0, // accept any amount of ETH
627             path,
628             address(this),
629             block.timestamp
630         );
631     }
632 
633     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
634         // approve token transfer to cover all possible scenarios
635         _approve(address(this), address(uniswapV2Router), tokenAmount);
636 
637         // add the liquidity
638         uniswapV2Router.addLiquidityETH{value: ethAmount}(
639             address(this),
640             tokenAmount,
641             0, // slippage is unavoidable
642             0, // slippage is unavoidable
643             address(owner()),
644             block.timestamp
645         );
646     }
647 
648     function swapBack() private {
649         uint256 contractBalance = balanceOf(address(this));
650         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForRace;
651 
652         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
653 
654         if(contractBalance > swapTokensAtAmount * 10){
655             contractBalance = swapTokensAtAmount * 10;
656         }
657 
658         bool success;
659 
660         // Halve the amount of liquidity tokens
661         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
662 
663         swapTokensForEth(contractBalance - liquidityTokens);
664 
665         uint256 ethBalance = address(this).balance;
666         uint256 ethForLiquidity = ethBalance;
667 
668         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
669         uint256 ethForRace = ethBalance * tokensForRace / (totalTokensToSwap - (tokensForLiquidity/2));
670 
671         ethForLiquidity -= ethForMarketing + ethForRace;
672 
673         tokensForLiquidity = 0;
674         tokensForMarketing = 0;
675         tokensForRace = 0;
676 
677         if(liquidityTokens > 0 && ethForLiquidity > 0){
678             addLiquidity(liquidityTokens, ethForLiquidity);
679         }
680 
681         (success,) = address(RaceAddress).call{value: ethForRace}("");
682 
683         (success,) = address(marketingAddress).call{value: address(this).balance}("");
684     }
685 
686     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
687         require(_token != address(0), "_token address cannot be 0");
688         require(_token != address(this), "Can't withdraw native tokens");
689         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
690         _sent = IERC20(_token).transfer(_to, _contractBalance);
691         emit TransferForeignToken(_token, _contractBalance);
692     }
693 
694     // withdraw ETH if stuck or someone sends to the address
695     function withdrawStuckETH() external onlyOwner {
696         bool success;
697         (success,) = address(msg.sender).call{value: address(this).balance}("");
698     }
699 
700     function setMarketingAddress(address _marketingAddress) external onlyOwner {
701         require(_marketingAddress != address(0), "_marketingAddress address cannot be 0");
702         marketingAddress = payable(_marketingAddress);
703         emit UpdatedMarketingAddress(_marketingAddress);
704     }
705 
706     function setRaceAddress(address _RaceAddress) external onlyOwner {
707         require(_RaceAddress != address(0), "_RaceAddress address cannot be 0");
708         RaceAddress = payable(_RaceAddress);
709         emit UpdatedRaceAddress(_RaceAddress);
710     }
711 }