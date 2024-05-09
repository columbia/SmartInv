1 /**       
2      
3            ,╓╦╦╗DßßRBNR╦╦,
4         ╔╫H  ╓ñ╜▀   "²w     ╙R╗,
5      ╒╓Ñ  ╥╝▀   ,∩≈╦,Dork      ▀w╓
6  .  ╒╓╜  ▒     ⌐  Kenobi ````"**"N ╫
7    óá` ╖á    ¡▄╗╢  ` "", ▐▄╦▌╜*º▄╚ ╫
8  /¿░` ║▀     ║░ ╣╩╙"IJ^═4 ▓,,ww=∞╝B W
9 ▐╒░  ╥▀  ,  ▌▀≈═`▐█`█▀█L *▐═▄▀███ `^▄
10 ⌡║ .▒   ╓▀  ▀W▄▄;▀███▄▀  .  ██▌,█ .4▐
11  ┐╓▀   ╓▌ j╝*, '"Ö%*═▄▄▄═` ╦▄▄▄▄▄═$▌ ▄
12 ].█   ─▀  ░ ╔▄,`  `,.═^^'   ╬╦╦M╢'▐▌ Γ
13 ║]▌   ░   ≡  ▒▀,╢`Hçj╗^FÇ ╗⌐══¬¬╤ ▐ ▐
14 ║]█  ▒▌Let `  ╗▄M▒,▀╜╙∞═╩Æ¬▌╬N▀╧╣L ;▐
15 ╢║▌  ░▒W j The `╗╚ *╝║▄╛▐▄▄ ▌╜▄╚▐  ▌Γ
16 ╙▓█'─┐╫` ▐▓╦▄ Memes ═é   ▄▐ ╙N╩═  ▄ Γ
17 ╣██ ]╒  ╔▒░^═▄▄g▄, Flow ╛ ▓     ▄▓█ ╛
18 H└╨▓▄▌ É` ░▒▒▒▒Ñ╩▀`,▄,,▄▄▄,▒▒0╬▓▒▓ á
19 ╙▀╢░▀▀▄ "▀▀▀,,╥▄*▀` ,Through╙╙═▄`╓▓
20 ╚┐  ▐▌▀` `   ,,─"`You▀▀▀▀*═,   É W
21 ╙,,  ▒⌐ ▌╖ ,,=╩▀  ╓╖H∞≡=H#╥╖╖,  *▄ ▌╫
22 ---
23 website:https://dorkkenobi.vip                                                            
24 twitter:https://twitter.com/DorkKenobiToken
25 tg:https://t.me/Dork_Kenobi                                                           
26                                                  
27 */
28 
29 // SPDX-License-Identifier: MIT
30 
31 pragma solidity 0.8.17;
32 
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes calldata) {
39         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
40         return msg.data;
41     }
42 }
43 
44 interface IERC20 {
45     /**
46      * @dev Returns the amount of tokens in existence.
47      */
48     function totalSupply() external view returns (uint256);
49 
50     /**
51      * @dev Returns the amount of tokens owned by `account`.
52      */
53     function balanceOf(address account) external view returns (uint256);
54 
55     /**
56      * @dev Moves `amount` tokens from the caller's account to `recipient`.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transfer(address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Returns the remaining number of tokens that `spender` will be
66      * allowed to spend on behalf of `owner` through {transferFrom}. This is
67      * zero by default.
68      *
69      * This value changes when {approve} or {transferFrom} are called.
70      */
71     function allowance(address owner, address spender) external view returns (uint256);
72 
73     /**
74      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * IMPORTANT: Beware that changing an allowance with this method brings the risk
79      * that someone may use both the old and the new allowance by unfortunate
80      * transaction ordering. One possible solution to mitigate this race
81      * condition is to first reduce the spender's allowance to 0 and set the
82      * desired value afterwards:
83      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
84      *
85      * Emits an {Approval} event.
86      */
87     function approve(address spender, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Moves `amount` tokens from `sender` to `recipient` using the
91      * allowance mechanism. `amount` is then deducted from the caller's
92      * allowance.
93      *
94      * Returns a boolean value indicating whether the operation succeeded.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transferFrom(
99         address sender,
100         address recipient,
101         uint256 amount
102     ) external returns (bool);
103 
104     /**
105      * @dev Emitted when `value` tokens are moved from one account (`from`) to
106      * another (`to`).
107      *
108      * Note that `value` may be zero.
109      */
110     event Transfer(address indexed from, address indexed to, uint256 value);
111 
112     /**
113      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
114      * a call to {approve}. `value` is the new allowance.
115      */
116     event Approval(address indexed owner, address indexed spender, uint256 value);
117 }
118 
119 interface IERC20Metadata is IERC20 {
120     /**
121      * @dev Returns the name of the token.
122      */
123     function name() external view returns (string memory);
124 
125     /**
126      * @dev Returns the symbol of the token.
127      */
128     function symbol() external view returns (string memory);
129 
130     /**
131      * @dev Returns the decimals places of the token.
132      */
133     function decimals() external view returns (uint8);
134 }
135 
136 contract ERC20 is Context, IERC20, IERC20Metadata {
137     mapping(address => uint256) private _balances;
138 
139     mapping(address => mapping(address => uint256)) private _allowances;
140 
141     uint256 private _totalSupply;
142 
143     string private _name;
144     string private _symbol;
145 
146     constructor(string memory name_, string memory symbol_) {
147         _name = name_;
148         _symbol = symbol_;
149     }
150 
151     function name() public view virtual override returns (string memory) {
152         return _name;
153     }
154 
155     function symbol() public view virtual override returns (string memory) {
156         return _symbol;
157     }
158 
159     function decimals() public view virtual override returns (uint8) {
160         return 18;
161     }
162 
163     function totalSupply() public view virtual override returns (uint256) {
164         return _totalSupply;
165     }
166 
167     function balanceOf(address account) public view virtual override returns (uint256) {
168         return _balances[account];
169     }
170 
171     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
172         _transfer(_msgSender(), recipient, amount);
173         return true;
174     }
175 
176     function allowance(address owner, address spender) public view virtual override returns (uint256) {
177         return _allowances[owner][spender];
178     }
179 
180     function approve(address spender, uint256 amount) public virtual override returns (bool) {
181         _approve(_msgSender(), spender, amount);
182         return true;
183     }
184 
185     function transferFrom(
186         address sender,
187         address recipient,
188         uint256 amount
189     ) public virtual override returns (bool) {
190         _transfer(sender, recipient, amount);
191 
192         uint256 currentAllowance = _allowances[sender][_msgSender()];
193         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
194         unchecked {
195             _approve(sender, _msgSender(), currentAllowance - amount);
196         }
197 
198         return true;
199     }
200 
201     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
202         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
203         return true;
204     }
205 
206     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
207         uint256 currentAllowance = _allowances[_msgSender()][spender];
208         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
209         unchecked {
210             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
211         }
212 
213         return true;
214     }
215 
216     function _transfer(
217         address sender,
218         address recipient,
219         uint256 amount
220     ) internal virtual {
221         require(sender != address(0), "ERC20: transfer from the zero address");
222         require(recipient != address(0), "ERC20: transfer to the zero address");
223 
224         uint256 senderBalance = _balances[sender];
225         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
226         unchecked {
227             _balances[sender] = senderBalance - amount;
228         }
229         _balances[recipient] += amount;
230 
231         emit Transfer(sender, recipient, amount);
232     }
233 
234     function _createInitialSupply(address account, uint256 amount) internal virtual {
235         require(account != address(0), "ERC20: mint to the zero address");
236 
237         _totalSupply += amount;
238         _balances[account] += amount;
239         emit Transfer(address(0), account, amount);
240     }
241 
242     function _approve(
243         address owner,
244         address spender,
245         uint256 amount
246     ) internal virtual {
247         require(owner != address(0), "ERC20: approve from the zero address");
248         require(spender != address(0), "ERC20: approve to the zero address");
249 
250         _allowances[owner][spender] = amount;
251         emit Approval(owner, spender, amount);
252     }
253 }
254 
255 contract Ownable is Context {
256     address private _owner;
257 
258     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
259 
260     constructor () {
261         address msgSender = _msgSender();
262         _owner = msgSender;
263         emit OwnershipTransferred(address(0), msgSender);
264     }
265 
266     function owner() public view returns (address) {
267         return _owner;
268     }
269 
270     modifier onlyOwner() {
271         require(_owner == _msgSender(), "Ownable: caller is not the owner");
272         _;
273     }
274 
275     function renounceOwnership() external virtual onlyOwner {
276         emit OwnershipTransferred(_owner, address(0));
277         _owner = address(0);
278     }
279 
280     function transferOwnership(address newOwner) public virtual onlyOwner {
281         require(newOwner != address(0), "Ownable: new owner is the zero address");
282         emit OwnershipTransferred(_owner, newOwner);
283         _owner = newOwner;
284     }
285 }
286 
287 interface IDexRouter {
288     function factory() external pure returns (address);
289     function WETH() external pure returns (address);
290 
291     function swapExactTokensForETHSupportingFeeOnTransferTokens(
292         uint amountIn,
293         uint amountOutMin,
294         address[] calldata path,
295         address to,
296         uint deadline
297     ) external;
298 
299     function swapExactETHForTokensSupportingFeeOnTransferTokens(
300         uint amountOutMin,
301         address[] calldata path,
302         address to,
303         uint deadline
304     ) external payable;
305 
306     function addLiquidityETH(
307         address token,
308         uint256 amountTokenDesired,
309         uint256 amountTokenMin,
310         uint256 amountETHMin,
311         address to,
312         uint256 deadline
313     )
314         external
315         payable
316         returns (
317             uint256 amountToken,
318             uint256 amountETH,
319             uint256 liquidity
320         );
321 }
322 
323 interface IDexFactory {
324     function createPair(address tokenA, address tokenB)
325         external
326         returns (address pair);
327 }
328 
329 contract dorkkenobi is ERC20, Ownable {
330 
331     uint256 public maxBuyAmount;
332     uint256 public maxSellAmount;
333     uint256 public maxWalletAmount;
334 
335     IDexRouter public dexRouter;
336     address public lpPair;
337 
338     bool private swapping;
339     uint256 public swapTokensAtAmount;
340 
341     address operationsAddress;
342 
343     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
344     mapping (address => bool) public bot;
345     uint256 public botsCaught;
346 
347     bool public limitsInEffect = true;
348     bool public tradingActive = false;
349     bool public swapEnabled = false;
350 
351      // Anti-bot and anti-whale mappings and variables
352     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
353     bool public transferDelayEnabled = true;
354 
355     uint256 public buyTotalFees;
356     uint256 public buyOperationsFee;
357     uint256 public buyLiquidityFee;
358 
359     uint256 public sellTotalFees;
360     uint256 public sellOperationsFee;
361     uint256 public sellLiquidityFee;
362 
363     uint256 public tokensForOperations;
364     uint256 public tokensForLiquidity;
365 
366     /******************/
367 
368     // exlcude from fees and max transaction amount
369     mapping (address => bool) private _isExcludedFromFees;
370     mapping (address => bool) public _isExcludedMaxTransactionAmount;
371 
372     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
373     // could be subject to a maximum transfer amount
374     mapping (address => bool) public automatedMarketMakerPairs;
375 
376     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
377 
378     event EnabledTrading();
379 
380     event RemovedLimits();
381 
382     event ExcludeFromFees(address indexed account, bool isExcluded);
383 
384     event UpdatedMaxBuyAmount(uint256 newAmount);
385 
386     event UpdatedMaxSellAmount(uint256 newAmount);
387 
388     event UpdatedMaxWalletAmount(uint256 newAmount);
389 
390     event UpdatedOperationsAddress(address indexed newWallet);
391 
392     event MaxTransactionExclusion(address _address, bool excluded);
393 
394     event BuyBackTriggered(uint256 amount);
395 
396     event OwnerForcedSwapBack(uint256 timestamp);
397  
398     event CaughtEarlyBuyer(address sniper);
399 
400     event SwapAndLiquify(
401         uint256 tokensSwapped,
402         uint256 ethReceived,
403         uint256 tokensIntoLiquidity
404     );
405 
406     event TransferForeignToken(address token, uint256 amount);
407 
408     constructor() ERC20(unicode"ᗪOᖇK KEᑎOᗷI ", unicode"DORKK") {
409 
410         address newOwner = msg.sender; // can leave alone if owner is deployer.
411 
412         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
413         dexRouter = _dexRouter;
414 
415         // create pair
416         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
417         _excludeFromMaxTransaction(address(lpPair), true);
418         _setAutomatedMarketMakerPair(address(lpPair), true);
419 
420         uint256 totalSupply = 1 * 1e9 * 1e18;
421 
422         maxBuyAmount = totalSupply * 2 / 100;
423         maxSellAmount = totalSupply * 2 / 100;
424         maxWalletAmount = totalSupply * 2 / 100;
425         swapTokensAtAmount = totalSupply * 1 / 1000;
426 
427         buyOperationsFee = 20;
428         buyLiquidityFee = 0;
429         buyTotalFees = buyOperationsFee + buyLiquidityFee;
430 
431         sellOperationsFee = 20;
432         sellLiquidityFee = 0;
433         sellTotalFees = sellOperationsFee + sellLiquidityFee;
434 
435         _excludeFromMaxTransaction(newOwner, true);
436         _excludeFromMaxTransaction(address(this), true);
437         _excludeFromMaxTransaction(address(0xdead), true);
438 
439         excludeFromFees(newOwner, true);
440         excludeFromFees(address(this), true);
441         excludeFromFees(address(0xdead), true);
442 
443         operationsAddress = address(newOwner);
444 
445         _createInitialSupply(newOwner, totalSupply);
446         transferOwnership(newOwner);
447     }
448 
449     receive() external payable {}
450 
451     // only enable if no plan to airdrop
452 
453     function enableTrading() external onlyOwner {
454         require(!tradingActive, "Cannot reenable trading");
455         tradingActive = true;
456         swapEnabled = true;
457         tradingActiveBlock = block.number;
458         emit EnabledTrading();
459     }
460 
461     // remove limits after token is stable
462     function removeLimits() external onlyOwner {
463         limitsInEffect = false;
464         transferDelayEnabled = false;
465         emit RemovedLimits();
466     }
467 
468     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
469         bot[wallet] = flag;
470     }
471 
472     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
473         for(uint256 i = 0; i < wallets.length; i++){
474             bot[wallets[i]] = flag;
475         }
476     }
477 
478     // disable Transfer delay - cannot be reenabled
479     function disableTransferDelay() external onlyOwner {
480         transferDelayEnabled = false;
481     }
482 
483     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
484         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
485         maxBuyAmount = newNum * (10**18);
486         emit UpdatedMaxBuyAmount(maxBuyAmount);
487     }
488 
489     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
490         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
491         maxSellAmount = newNum * (10**18);
492         emit UpdatedMaxSellAmount(maxSellAmount);
493     }
494 
495     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
496         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
497         maxWalletAmount = newNum * (10**18);
498         emit UpdatedMaxWalletAmount(maxWalletAmount);
499     }
500 
501     // change the minimum amount of tokens to sell from fees
502     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
503   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
504   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
505   	    swapTokensAtAmount = newAmount;
506   	}
507 
508     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
509         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
510         emit MaxTransactionExclusion(updAds, isExcluded);
511     }
512 
513     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
514         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
515         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
516         for(uint256 i = 0; i < wallets.length; i++){
517             address wallet = wallets[i];
518             uint256 amount = amountsInTokens[i];
519             super._transfer(msg.sender, wallet, amount);
520         }
521     }
522 
523     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
524         if(!isEx){
525             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
526         }
527         _isExcludedMaxTransactionAmount[updAds] = isEx;
528     }
529 
530     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
531         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
532 
533         _setAutomatedMarketMakerPair(pair, value);
534         emit SetAutomatedMarketMakerPair(pair, value);
535     }
536 
537     function _setAutomatedMarketMakerPair(address pair, bool value) private {
538         automatedMarketMakerPairs[pair] = value;
539 
540         _excludeFromMaxTransaction(pair, value);
541 
542         emit SetAutomatedMarketMakerPair(pair, value);
543     }
544 
545     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
546         buyOperationsFee = _operationsFee;
547         buyLiquidityFee = _liquidityFee;
548         buyTotalFees = buyOperationsFee + buyLiquidityFee;
549         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
550     }
551 
552     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
553         sellOperationsFee = _operationsFee;
554         sellLiquidityFee = _liquidityFee;
555         sellTotalFees = sellOperationsFee + sellLiquidityFee;
556         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
557     }
558 
559     function excludeFromFees(address account, bool excluded) public onlyOwner {
560         _isExcludedFromFees[account] = excluded;
561         emit ExcludeFromFees(account, excluded);
562     }
563 
564     function _transfer(address from, address to, uint256 amount) internal override {
565 
566         require(from != address(0), "ERC20: transfer from the zero address");
567         require(to != address(0), "ERC20: transfer to the zero address");
568         require(amount > 0, "amount must be greater than 0");
569 
570         if(!tradingActive){
571             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
572         }
573 
574         require(!bot[from] && !bot[to], "Bots cannot transfer tokens in or out except to owner or dead address.");
575 
576         if(limitsInEffect){
577             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
578 
579                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
580                 if (transferDelayEnabled){
581                     if (to != address(dexRouter) && to != address(lpPair)){
582                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
583                         _holderLastTransferTimestamp[tx.origin] = block.number;
584                         _holderLastTransferTimestamp[to] = block.number;
585                     }
586                 }
587     
588                 //when buy
589                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
590                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
591                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
592                 }
593                 //when sell
594                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
595                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
596                 }
597                 else if (!_isExcludedMaxTransactionAmount[to]){
598                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
599                 }
600             }
601         }
602 
603         uint256 contractTokenBalance = balanceOf(address(this));
604 
605         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
606 
607         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
608             swapping = true;
609 
610             swapBack();
611 
612             swapping = false;
613         }
614 
615         bool takeFee = true;
616         // if any account belongs to _isExcludedFromFee account then remove the fee
617         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
618             takeFee = false;
619         }
620 
621         uint256 fees = 0;
622         // only take fees on buys/sells, do not take on wallet transfers
623         if(takeFee){
624             // on sell
625             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
626                 fees = amount * sellTotalFees / 100;
627                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
628                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
629             }
630 
631             // on buy
632             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
633         	    fees = amount * buyTotalFees / 100;
634         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
635                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
636             }
637 
638             if(fees > 0){
639                 super._transfer(from, address(this), fees);
640             }
641 
642         	amount -= fees;
643         }
644 
645         super._transfer(from, to, amount);
646     }
647     function swapTokensForEth(uint256 tokenAmount) private {
648 
649         // generate the uniswap pair path of token -> weth
650         address[] memory path = new address[](2);
651         path[0] = address(this);
652         path[1] = dexRouter.WETH();
653 
654         _approve(address(this), address(dexRouter), tokenAmount);
655 
656         // make the swap
657         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
658             tokenAmount,
659             0, // accept any amount of ETH
660             path,
661             address(this),
662             block.timestamp
663         );
664     }
665 
666     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
667         // approve token transfer to cover all possible scenarios
668         _approve(address(this), address(dexRouter), tokenAmount);
669 
670         // add the liquidity
671         dexRouter.addLiquidityETH{value: ethAmount}(
672             address(this),
673             tokenAmount,
674             0, // slippage is unavoidable
675             0, // slippage is unavoidable
676             address(0xdead),
677             block.timestamp
678         );
679     }
680 
681     function swapBack() private {
682         uint256 contractBalance = balanceOf(address(this));
683         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations;
684 
685         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
686 
687         if(contractBalance > swapTokensAtAmount * 60){
688             contractBalance = swapTokensAtAmount * 60;
689         }
690 
691         bool success;
692 
693         // Halve the amount of liquidity tokens
694         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
695 
696         swapTokensForEth(contractBalance - liquidityTokens);
697 
698         uint256 ethBalance = address(this).balance;
699         uint256 ethForLiquidity = ethBalance;
700 
701         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
702 
703         ethForLiquidity -= ethForOperations;
704 
705         tokensForLiquidity = 0;
706         tokensForOperations = 0;
707 
708         if(liquidityTokens > 0 && ethForLiquidity > 0){
709             addLiquidity(liquidityTokens, ethForLiquidity);
710         }
711 
712         if(address(this).balance > 0){
713             (success,) = address(operationsAddress).call{value: address(this).balance}("");
714         }
715     }
716 
717     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
718         require(_token != address(0), "_token address cannot be 0");
719         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
720         _sent = IERC20(_token).transfer(_to, _contractBalance);
721         emit TransferForeignToken(_token, _contractBalance);
722     }
723 
724     // withdraw ETH if stuck or someone sends to the address
725     function withdrawStuckETH() external onlyOwner {
726         bool success;
727         (success,) = address(msg.sender).call{value: address(this).balance}("");
728     }
729 
730     function setOperationsAddress(address _operationsAddress) external onlyOwner {
731         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
732         operationsAddress = payable(_operationsAddress);
733     }
734 
735     // force Swap back if slippage issues.
736     function forceSwapBack() external onlyOwner {
737         require(balanceOf(address(this)) >= 0, "No tokens to swap");
738         swapping = true;
739         swapBack();
740         swapping = false;
741         emit OwnerForcedSwapBack(block.timestamp);
742     }
743 
744 }