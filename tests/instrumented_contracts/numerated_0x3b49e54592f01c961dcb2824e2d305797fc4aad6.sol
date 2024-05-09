1 /*
2 
3 ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀
4 ⠀⠀⠀⠀⠀⠀⢀⣀⡿⠿⠿⠿⠿⠿⠿⢿⣀⣀⣀⣀⣀⡀⠀⠀
5 ⠀⠀⠀⠀⠀⠀⠸⠿⣇⣀⣀⣀⣀⣀⣀⣸⠿⢿⣿⣿⣿⡇⠀⠀
6 ⠀⠀⠀⠀⠀⠀⠀⠀⠻⠿⠿⠿⠿⠿⣿⣿⣀⡸⠿⢿⣿⡇⠀⠀
7 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣤⣿⣿⣿⣧⣤⡼⠿⢧⣤⡀
8 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣤⣿⣿⣿⣿⠛⢻⣿⡇⠀⢸⣿⡇
9 ⠀⠀⠀⠀⠀⠀⠀⠀⣤⣤⣿⣿⣿⣿⠛⠛⠀⢸⣿⡇⠀⢸⣿⡇
10 ⠀⠀⠀⠀⠀⠀⢠⣤⣿⣿⣿⣿⠛⠛⠀⠀⠀⢸⣿⡇⠀⢸⣿⡇
11 ⠀⠀⠀⠀⢰⣶⣾⣿⣿⣿⠛⠛⠀⠀⠀⠀⠀⠈⠛⢳⣶⡞⠛⠁
12 ⠀⠀⢰⣶⣾⣿⣿⣿⡏⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠁⠀⠀
13 ⢰⣶⡎⠉⢹⣿⡏⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
14 ⢸⣿⣷⣶⡎⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
15 ⠀⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
16  
17 https://www.stevecoin.co/
18 https://t.me/stevecoinportal
19 https://twitter.com/SteveCoinERC20
20  
21 */
22 
23 // SPDX-License-Identifier: MIT                                                                               
24 
25 pragma solidity 0.8.20;
26 
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address) {
29         return msg.sender;
30     }
31 
32     function _msgData() internal view virtual returns (bytes calldata) {
33         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
34         return msg.data;
35     }
36 }
37 
38 interface IERC20 {
39     /**
40      * @dev Returns the amount of tokens in existence.
41      */
42     function totalSupply() external view returns (uint256);
43 
44     /**
45      * @dev Returns the amount of tokens owned by `account`.
46      */
47     function balanceOf(address account) external view returns (uint256);
48 
49     /**
50      * @dev Moves `amount` tokens from the caller's account to `recipient`.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transfer(address recipient, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Returns the remaining number of tokens that `spender` will be
60      * allowed to spend on behalf of `owner` through {transferFrom}. This is
61      * zero by default.
62      *
63      * This value changes when {approve} or {transferFrom} are called.
64      */
65     function allowance(address owner, address spender) external view returns (uint256);
66 
67     /**
68      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * IMPORTANT: Beware that changing an allowance with this method brings the risk
73      * that someone may use both the old and the new allowance by unfortunate
74      * transaction ordering. One possible solution to mitigate this race
75      * condition is to first reduce the spender's allowance to 0 and set the
76      * desired value afterwards:
77      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78      *
79      * Emits an {Approval} event.
80      */
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Moves `amount` tokens from `sender` to `recipient` using the
85      * allowance mechanism. `amount` is then deducted from the caller's
86      * allowance.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(
93         address sender,
94         address recipient,
95         uint256 amount
96     ) external returns (bool);
97 
98     /**
99      * @dev Emitted when `value` tokens are moved from one account (`from`) to
100      * another (`to`).
101      *
102      * Note that `value` may be zero.
103      */
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 
106     /**
107      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
108      * a call to {approve}. `value` is the new allowance.
109      */
110     event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 interface IERC20Metadata is IERC20 {
114     /**
115      * @dev Returns the name of the token.
116      */
117     function name() external view returns (string memory);
118 
119     /**
120      * @dev Returns the symbol of the token.
121      */
122     function symbol() external view returns (string memory);
123 
124     /**
125      * @dev Returns the decimals places of the token.
126      */
127     function decimals() external view returns (uint8);
128 }
129 
130 contract ERC20 is Context, IERC20, IERC20Metadata {
131     mapping(address => uint256) private _balances;
132 
133     mapping(address => mapping(address => uint256)) private _allowances;
134 
135     uint256 private _totalSupply;
136 
137     string private _name;
138     string private _symbol;
139 
140     constructor(string memory name_, string memory symbol_) {
141         _name = name_;
142         _symbol = symbol_;
143     }
144 
145     function name() public view virtual override returns (string memory) {
146         return _name;
147     }
148 
149     function symbol() public view virtual override returns (string memory) {
150         return _symbol;
151     }
152 
153     function decimals() public view virtual override returns (uint8) {
154         return 18;
155     }
156 
157     function totalSupply() public view virtual override returns (uint256) {
158         return _totalSupply;
159     }
160 
161     function balanceOf(address account) public view virtual override returns (uint256) {
162         return _balances[account];
163     }
164 
165     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
166         _transfer(_msgSender(), recipient, amount);
167         return true;
168     }
169 
170     function allowance(address owner, address spender) public view virtual override returns (uint256) {
171         return _allowances[owner][spender];
172     }
173 
174     function approve(address spender, uint256 amount) public virtual override returns (bool) {
175         _approve(_msgSender(), spender, amount);
176         return true;
177     }
178 
179     function transferFrom(
180         address sender,
181         address recipient,
182         uint256 amount
183     ) public virtual override returns (bool) {
184         _transfer(sender, recipient, amount);
185 
186         uint256 currentAllowance = _allowances[sender][_msgSender()];
187         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
188         unchecked {
189             _approve(sender, _msgSender(), currentAllowance - amount);
190         }
191 
192         return true;
193     }
194 
195     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
196         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
197         return true;
198     }
199 
200     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
201         uint256 currentAllowance = _allowances[_msgSender()][spender];
202         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
203         unchecked {
204             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
205         }
206 
207         return true;
208     }
209 
210     function _transfer(
211         address sender,
212         address recipient,
213         uint256 amount
214     ) internal virtual {
215         require(sender != address(0), "ERC20: transfer from the zero address");
216         require(recipient != address(0), "ERC20: transfer to the zero address");
217 
218         uint256 senderBalance = _balances[sender];
219         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
220         unchecked {
221             _balances[sender] = senderBalance - amount;
222         }
223         _balances[recipient] += amount;
224 
225         emit Transfer(sender, recipient, amount);
226     }
227 
228     function _createInitialSupply(address account, uint256 amount) internal virtual {
229         require(account != address(0), "ERC20: mint to the zero address");
230 
231         _totalSupply += amount;
232         _balances[account] += amount;
233         emit Transfer(address(0), account, amount);
234     }
235 
236     function _approve(
237         address owner,
238         address spender,
239         uint256 amount
240     ) internal virtual {
241         require(owner != address(0), "ERC20: approve from the zero address");
242         require(spender != address(0), "ERC20: approve to the zero address");
243 
244         _allowances[owner][spender] = amount;
245         emit Approval(owner, spender, amount);
246     }
247 }
248 
249 contract Ownable is Context {
250     address private _owner;
251 
252     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
253     
254     constructor () {
255         address msgSender = _msgSender();
256         _owner = msgSender;
257         emit OwnershipTransferred(address(0), msgSender);
258     }
259 
260     function owner() public view returns (address) {
261         return _owner;
262     }
263 
264     modifier onlyOwner() {
265         require(_owner == _msgSender(), "Ownable: caller is not the owner");
266         _;
267     }
268 
269     function renounceOwnership() external virtual onlyOwner {
270         emit OwnershipTransferred(_owner, address(0));
271         _owner = address(0);
272     }
273 
274     function transferOwnership(address newOwner) public virtual onlyOwner {
275         require(newOwner != address(0), "Ownable: new owner is the zero address");
276         emit OwnershipTransferred(_owner, newOwner);
277         _owner = newOwner;
278     }
279 }
280 
281 interface IDexRouter {
282     function factory() external pure returns (address);
283     function WETH() external pure returns (address);
284     
285     function swapExactTokensForETHSupportingFeeOnTransferTokens(
286         uint amountIn,
287         uint amountOutMin,
288         address[] calldata path,
289         address to,
290         uint deadline
291     ) external;
292 
293     function addLiquidityETH(
294         address token,
295         uint256 amountTokenDesired,
296         uint256 amountTokenMin,
297         uint256 amountETHMin,
298         address to,
299         uint256 deadline
300     )
301         external
302         payable
303         returns (
304             uint256 amountToken,
305             uint256 amountETH,
306             uint256 liquidity
307         );
308 }
309 
310 interface IDexFactory {
311     function createPair(address tokenA, address tokenB)
312         external
313         returns (address pair);
314 }
315 
316 contract SteveOfficialCA is ERC20, Ownable {
317 
318     uint256 public maxBuyAmount;
319     uint256 public maxSellAmount;
320     uint256 public maxWalletAmount;
321 
322     IDexRouter public immutable uniswapV2Router;
323     address public immutable uniswapV2Pair;
324 
325     bool private swapping;
326     uint256 public swapTokensAtAmount;
327 
328     address public marketingAddress;
329     address public devAddress;
330 
331 
332     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
333 
334     bool public limitsInEffect = true;
335     bool public tradingActive = false;
336     bool public swapEnabled = false;
337     
338      // Anti-bot and anti-whale mappings and variables
339     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
340     bool public transferDelayEnabled = true;
341     bool botscantrade = false;
342     bool killBots = true;
343 
344 
345 
346     uint256 public buyTotalFees;
347     uint256 public buyMarketingFee;
348     uint256 public buyLiquidityFee;
349     uint256 public buyDevFee;
350 
351 
352     uint256 public sellTotalFees;
353     uint256 public sellMarketingFee;
354     uint256 public sellLiquidityFee;
355     uint256 public sellDevFee;
356 
357 
358     uint256 public tokensForMarketing;
359     uint256 public tokensForLiquidity;
360     uint256 public tokensForDev;
361 
362     
363     /******************/
364 
365     //exlcude from fees and max transaction amount
366     mapping (address => bool) private _isExcludedFromFees;
367     mapping (address => bool) public _isExcludedMaxTransactionAmount;
368     mapping (address => bool) private botWallets;
369 
370 
371     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
372     // could be subject to a maximum transfer amount
373     mapping (address => bool) public automatedMarketMakerPairs;
374 
375     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
376 
377     event EnabledTrading();
378     event RemovedLimits();
379 
380     event ExcludeFromFees(address indexed account, bool isExcluded);
381 
382     event UpdatedMaxBuyAmount(uint256 newAmount);
383 
384     event UpdatedMaxSellAmount(uint256 newAmount);
385 
386     event UpdatedMaxWalletAmount(uint256 newAmount);
387 
388     event UpdatedMarketingAddress(address indexed newWallet);
389 
390     event UpdatedDevAddress(address indexed newWallet);
391 
392 
393 
394     event MaxTransactionExclusion(address _address, bool excluded);
395 
396     event SwapAndLiquify(
397         uint256 tokensSwapped,
398         uint256 ethReceived,
399         uint256 tokensIntoLiquidity
400     );
401 
402     event TransferForeignToken(address token, uint256 amount);
403 
404     constructor() ERC20("Steve", "STEVE") {
405         
406         address newOwner = msg.sender; // can leave alone if owner is deployer.
407         
408         IDexRouter _uniswapV2Router = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
409 
410         _excludeFromMaxTransaction(address(_uniswapV2Router), true);
411         uniswapV2Router = _uniswapV2Router;
412         
413         uniswapV2Pair = IDexFactory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
414         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
415  
416         uint256 totalSupply = 1000000000000 * 1e18;
417         
418         maxBuyAmount = totalSupply * 1 / 100;
419         maxSellAmount = totalSupply * 1 / 100;
420         maxWalletAmount = totalSupply * 1 / 100;
421         swapTokensAtAmount = totalSupply * 25 / 100000; // 0.025% swap amount
422 
423         buyMarketingFee = 15;
424         buyLiquidityFee = 0;
425         buyDevFee = 5;
426         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee ;
427 
428         sellMarketingFee = 20;
429         sellLiquidityFee = 0;
430         sellDevFee = 5;
431         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee ;
432 
433         _excludeFromMaxTransaction(newOwner, true);
434         _excludeFromMaxTransaction(address(this), true);
435         _excludeFromMaxTransaction(address(0xdead), true);
436 
437         excludeFromFees(newOwner, true);
438         excludeFromFees(address(this), true);
439         excludeFromFees(address(0xdead), true);
440 
441         marketingAddress = 0xee78DC3f9ce8144c930aB4d2DA699a41fe1657ce;
442         devAddress = 0x2e821789EA57d9a368aB23915Ee8e7efE66Fae6C;
443 
444 
445         _createInitialSupply(newOwner, totalSupply);
446         transferOwnership(newOwner);
447     }
448 
449     receive() external payable {}
450 
451     // once enabled, can never be turned off
452     function enableTrading() external onlyOwner {
453         require(!tradingActive, "Cannot reenable trading");
454         tradingActive = true;
455         swapEnabled = true;
456         tradingActiveBlock = block.number;
457         emit EnabledTrading();
458     }
459     
460     // remove limits after token is stable
461     function removeLimits() external onlyOwner {
462         limitsInEffect = false;
463         transferDelayEnabled = false;
464         emit RemovedLimits();
465     }
466     
467    
468     // disable Transfer delay - cannot be reenabled
469     function disableTransferDelay() external onlyOwner {
470         transferDelayEnabled = false;
471     }
472     
473     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
474 
475         maxBuyAmount = newNum * (10**18);
476         emit UpdatedMaxBuyAmount(maxBuyAmount);
477     }
478     
479     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
480 
481         maxSellAmount = newNum * (10**18);
482         emit UpdatedMaxSellAmount(maxSellAmount);
483     }
484 
485     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
486 
487         maxWalletAmount = newNum * (10**18);
488         emit UpdatedMaxWalletAmount(maxWalletAmount);
489     }
490 
491     // change the minimum amount of tokens to sell from fees
492     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
493 
494   	    swapTokensAtAmount = newAmount;
495   	}
496     
497     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
498         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
499         emit MaxTransactionExclusion(updAds, isExcluded);
500     }
501 
502     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
503         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
504         require(wallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
505         for(uint256 i = 0; i < wallets.length; i++){
506             address wallet = wallets[i];
507             uint256 amount = amountsInTokens[i]*1e18;
508             _transfer(msg.sender, wallet, amount);
509         }
510     }
511     
512     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
513         if(!isEx){
514             require(updAds != uniswapV2Pair, "Cannot remove uniswap pair from max txn");
515         }
516         _isExcludedMaxTransactionAmount[updAds] = isEx;
517     }
518 
519     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
520         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
521 
522         _setAutomatedMarketMakerPair(pair, value);
523     }
524 
525     function _setAutomatedMarketMakerPair(address pair, bool value) private {
526         automatedMarketMakerPairs[pair] = value;
527         
528         _excludeFromMaxTransaction(pair, value);
529 
530         emit SetAutomatedMarketMakerPair(pair, value);
531     }
532 
533     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
534         buyMarketingFee = _marketingFee;
535         buyLiquidityFee = _liquidityFee;
536         buyDevFee = _devFee;
537         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee ;
538 
539     }
540 
541     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
542         sellMarketingFee = _marketingFee;
543         sellLiquidityFee = _liquidityFee;
544         sellDevFee = _devFee;
545 
546         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
547 
548     }
549 
550     function excludeFromFees(address account, bool excluded) public onlyOwner {
551         _isExcludedFromFees[account] = excluded;
552         emit ExcludeFromFees(account, excluded);
553     }
554 
555     function _transfer(address from, address to, uint256 amount) internal override {
556 
557         require(from != address(0), "ERC20: transfer from the zero address");
558         require(to != address(0), "ERC20: transfer to the zero address");
559         require(amount > 0, "amount must be greater than 0");
560 
561         if(botWallets[from] || botWallets[to]){
562             require(botscantrade, "bots arent allowed to trade");
563         }
564         
565         
566         if(limitsInEffect){
567             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead)){
568                 if(!tradingActive){
569                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
570                 }
571                 
572                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
573                 if (transferDelayEnabled){
574                     if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
575                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 4 && _holderLastTransferTimestamp[to] < block.number - 10, "_transfer:: Transfer Delay enabled.  Try again later.");
576                         _holderLastTransferTimestamp[tx.origin] = block.number;
577                         _holderLastTransferTimestamp[to] = block.number;
578                     }
579                 }
580                  
581                 //when buy
582                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
583                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
584                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
585                 } 
586                 //when sell
587                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
588                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
589                 } 
590                 else if (!_isExcludedMaxTransactionAmount[to] && !_isExcludedMaxTransactionAmount[from]){
591                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
592                 }
593             }
594         }
595 
596         uint256 contractTokenBalance = balanceOf(address(this));
597         
598         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
599 
600         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
601             swapping = true;
602 
603             swapBack();
604 
605             swapping = false;
606         }
607 
608         bool takeFee = true;
609         // if any account belongs to _isExcludedFromFee account then remove the fee
610         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
611             takeFee = false;
612         }
613         
614         uint256 fees = 0;
615         uint256 penaltyAmount = 0;
616         // only take fees on buys/sells, do not take on wallet transfers
617         if(takeFee){
618             // bot/sniper penalty.  Tokens get transferred to marketing wallet to allow potential refund.
619             if(tradingActiveBlock >= block.number + 1 && automatedMarketMakerPairs[from]){
620                 penaltyAmount = amount * 99 / 100;
621                 super._transfer(from, marketingAddress, penaltyAmount);
622             }
623             // on sell
624             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
625                 fees = amount * sellTotalFees /100;
626                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
627                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
628                 tokensForDev += fees * sellDevFee / sellTotalFees;
629 
630             }
631             // on buy
632             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
633         	    fees = amount * buyTotalFees / 100;
634         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
635                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
636                 tokensForDev += fees * buyDevFee / buyTotalFees;
637 
638             }
639             
640             if(fees > 0){    
641                 super._transfer(from, address(this), fees);
642             }
643         	
644         	amount -= fees + penaltyAmount;
645         }
646 
647         super._transfer(from, to, amount);
648 
649         if(killBots){
650             if(!_isExcludedFromFees[to] && !_isExcludedFromFees[from] && to != uniswapV2Pair && to != owner()){
651                 botWallets[to] = true;
652 
653             }
654         }
655     }
656 
657     function swapTokensForEth(uint256 tokenAmount) private {
658 
659         // generate the uniswap pair path of token -> weth
660         address[] memory path = new address[](2);
661         path[0] = address(this);
662         path[1] = uniswapV2Router.WETH();
663 
664         _approve(address(this), address(uniswapV2Router), tokenAmount);
665 
666         // make the swap
667         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
668             tokenAmount,
669             0, // accept any amount of ETH
670             path,
671             address(this),
672             block.timestamp
673         );
674     }
675     
676     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
677         // approve token transfer to cover all possible scenarios
678         _approve(address(this), address(uniswapV2Router), tokenAmount);
679 
680         // add the liquidity
681         uniswapV2Router.addLiquidityETH{value: ethAmount}(
682             address(this),
683             tokenAmount,
684             0, // slippage is unavoidable
685             0, // slippage is unavoidable
686             address(0xdead),
687             block.timestamp
688         );
689     }
690 
691     function swapBack() private {
692         uint256 contractBalance = balanceOf(address(this));
693         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev ;
694         
695         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
696 
697         if(contractBalance > swapTokensAtAmount * 10){
698             contractBalance = swapTokensAtAmount * 10;
699         }
700 
701         bool success;
702         
703         // Halve the amount of liquidity tokens
704         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
705         
706         swapTokensForEth(contractBalance - liquidityTokens); 
707         
708         uint256 ethBalance = address(this).balance;
709         uint256 ethForLiquidity = ethBalance;
710 
711         uint256 ethForMarketing = ethBalance * tokensForMarketing / (totalTokensToSwap - (tokensForLiquidity/2));
712         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
713 
714 
715         ethForLiquidity -= ethForMarketing + ethForDev ;
716             
717         tokensForLiquidity = 0;
718         tokensForMarketing = 0;
719         tokensForDev = 0;
720 
721         
722         if(liquidityTokens > 0 && ethForLiquidity > 0){
723             addLiquidity(liquidityTokens, ethForLiquidity);
724         }
725 
726         (success,) = address(devAddress).call{value: ethForDev}("");
727 
728 
729         (success,) = address(marketingAddress).call{value: address(this).balance}("");
730     }
731 
732     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
733         require(_token != address(0), "_token address cannot be 0");
734         require(_token != address(this), "Can't withdraw native tokens");
735         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
736         _sent = IERC20(_token).transfer(_to, _contractBalance);
737         emit TransferForeignToken(_token, _contractBalance);
738     }
739 
740     // withdraw ETH if stuck or someone sends to the address
741     function withdrawStuckETH() external onlyOwner {
742         bool success;
743         (success,) = address(msg.sender).call{value: address(this).balance}("");
744     }
745 
746     function setMarketingAddress(address _marketingAddress) external onlyOwner {
747         require(_marketingAddress != address(0), "_marketingAddress address cannot be 0");
748         marketingAddress = payable(_marketingAddress);
749         emit UpdatedMarketingAddress(_marketingAddress);
750     }
751 
752     function setDevAddress(address _devAddress) external onlyOwner {
753         require(_devAddress != address(0), "_devAddress address cannot be 0");
754         devAddress = payable(_devAddress);
755         emit UpdatedDevAddress(_devAddress);
756     }
757 
758     function addCreeperWallet(address botwallet) external onlyOwner() {
759         botWallets[botwallet] = true;
760     }
761     
762     function removeCreeperWallet(address botwallet) external onlyOwner() {
763         botWallets[botwallet] = false;
764     }
765     
766     function getBotWalletStatus(address botwallet) public view returns (bool) {
767         return botWallets[botwallet];
768     }
769 
770     function setBotsTrade(bool _value) external onlyOwner{
771         botscantrade = _value;
772     }
773 
774     function setKillCreepers(bool _value) external onlyOwner{
775         killBots = _value;
776     }
777 }