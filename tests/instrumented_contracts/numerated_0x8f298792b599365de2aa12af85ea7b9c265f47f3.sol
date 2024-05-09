1 /*
2 ░██╗░░░░░░░██╗░█████╗░██████╗░██╗░░░░░██████╗░  ██████╗░███████╗░█████╗░░█████╗░███████╗
3 ░██║░░██╗░░██║██╔══██╗██╔══██╗██║░░░░░██╔══██╗  ██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝
4 ░╚██╗████╗██╔╝██║░░██║██████╔╝██║░░░░░██║░░██║  ██████╔╝█████╗░░███████║██║░░╚═╝█████╗░░
5 ░░████╔═████║░██║░░██║██╔══██╗██║░░░░░██║░░██║  ██╔═══╝░██╔══╝░░██╔══██║██║░░██╗██╔══╝░░
6 ░░╚██╔╝░╚██╔╝░╚█████╔╝██║░░██║███████╗██████╔╝  ██║░░░░░███████╗██║░░██║╚█████╔╝███████╗
7 ░░░╚═╝░░░╚═╝░░░╚════╝░╚═╝░░╚═╝╚══════╝╚═════╝░  ╚═╝░░░░░╚══════╝╚═╝░░╚═╝░╚════╝░╚══════╝
8 
9 ░░██╗██████╗░░█████╗░███████╗██╗░░
10 ░██╔╝██╔══██╗██╔══██╗╚════██║╚██╗░
11 ██╔╝░██████╔╝███████║░░███╔═╝░╚██╗
12 ╚██╗░██╔═══╝░██╔══██║██╔══╝░░░██╔╝
13 ░╚██╗██║░░░░░██║░░██║███████╗██╔╝░
14 ░░╚═╝╚═╝░░░░░╚═╝░░╚═╝╚══════╝╚═╝░░
15 
16 Stop Fighting M*therf*ckers
17 */
18 
19 // SPDX-License-Identifier: MIT                                                                               
20                                                     
21 pragma solidity 0.8.11;
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 interface IERC20 {
35     /**
36      * @dev Returns the amount of tokens in existence.
37      */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41      * @dev Returns the amount of tokens owned by `account`.
42      */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46      * @dev Moves `amount` tokens from the caller's account to `recipient`.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * Emits a {Transfer} event.
51      */
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     /**
64      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Moves `amount` tokens from `sender` to `recipient` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(
89         address sender,
90         address recipient,
91         uint256 amount
92     ) external returns (bool);
93 
94     /**
95      * @dev Emitted when `value` tokens are moved from one account (`from`) to
96      * another (`to`).
97      *
98      * Note that `value` may be zero.
99      */
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 
102     /**
103      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
104      * a call to {approve}. `value` is the new allowance.
105      */
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 interface IERC20Metadata is IERC20 {
110     /**
111      * @dev Returns the name of the token.
112      */
113     function name() external view returns (string memory);
114 
115     /**
116      * @dev Returns the symbol of the token.
117      */
118     function symbol() external view returns (string memory);
119 
120     /**
121      * @dev Returns the decimals places of the token.
122      */
123     function decimals() external view returns (uint8);
124 }
125 
126 contract ERC20 is Context, IERC20, IERC20Metadata {
127     mapping(address => uint256) private _balances;
128 
129     mapping(address => mapping(address => uint256)) private _allowances;
130 
131     uint256 private _totalSupply;
132 
133     string private _name;
134     string private _symbol;
135 
136     constructor(string memory name_, string memory symbol_) {
137         _name = name_;
138         _symbol = symbol_;
139     }
140 
141     function name() public view virtual override returns (string memory) {
142         return _name;
143     }
144 
145     function symbol() public view virtual override returns (string memory) {
146         return _symbol;
147     }
148 
149     function decimals() public view virtual override returns (uint8) {
150         return 18;
151     }
152 
153     function totalSupply() public view virtual override returns (uint256) {
154         return _totalSupply;
155     }
156 
157     function balanceOf(address account) public view virtual override returns (uint256) {
158         return _balances[account];
159     }
160 
161     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
162         _transfer(_msgSender(), recipient, amount);
163         return true;
164     }
165 
166     function allowance(address owner, address spender) public view virtual override returns (uint256) {
167         return _allowances[owner][spender];
168     }
169 
170     function approve(address spender, uint256 amount) public virtual override returns (bool) {
171         _approve(_msgSender(), spender, amount);
172         return true;
173     }
174 
175     function transferFrom(
176         address sender,
177         address recipient,
178         uint256 amount
179     ) public virtual override returns (bool) {
180         _transfer(sender, recipient, amount);
181 
182         uint256 currentAllowance = _allowances[sender][_msgSender()];
183         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
184         unchecked {
185             _approve(sender, _msgSender(), currentAllowance - amount);
186         }
187 
188         return true;
189     }
190 
191     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
192         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
193         return true;
194     }
195 
196     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
197         uint256 currentAllowance = _allowances[_msgSender()][spender];
198         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
199         unchecked {
200             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
201         }
202 
203         return true;
204     }
205 
206     function _transfer(
207         address sender,
208         address recipient,
209         uint256 amount
210     ) internal virtual {
211         require(sender != address(0), "ERC20: transfer from the zero address");
212         require(recipient != address(0), "ERC20: transfer to the zero address");
213 
214         uint256 senderBalance = _balances[sender];
215         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
216         unchecked {
217             _balances[sender] = senderBalance - amount;
218         }
219         _balances[recipient] += amount;
220 
221         emit Transfer(sender, recipient, amount);
222     }
223 
224     function _createInitialSupply(address account, uint256 amount) internal virtual {
225         require(account != address(0), "ERC20: mint to the zero address");
226 
227         _totalSupply += amount;
228         _balances[account] += amount;
229         emit Transfer(address(0), account, amount);
230     }
231 
232     function _approve(
233         address owner,
234         address spender,
235         uint256 amount
236     ) internal virtual {
237         require(owner != address(0), "ERC20: approve from the zero address");
238         require(spender != address(0), "ERC20: approve to the zero address");
239 
240         _allowances[owner][spender] = amount;
241         emit Approval(owner, spender, amount);
242     }
243 }
244 
245 contract Ownable is Context {
246     address private _owner;
247 
248     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
249     
250     constructor () {
251         address msgSender = _msgSender();
252         _owner = msgSender;
253         emit OwnershipTransferred(address(0), msgSender);
254     }
255 
256     function owner() public view returns (address) {
257         return _owner;
258     }
259 
260     modifier onlyOwner() {
261         require(_owner == _msgSender(), "Ownable: caller is not the owner");
262         _;
263     }
264 
265     function renounceOwnership() external virtual onlyOwner {
266         emit OwnershipTransferred(_owner, address(0));
267         _owner = address(0);
268     }
269 
270     function transferOwnership(address newOwner) public virtual onlyOwner {
271         require(newOwner != address(0), "Ownable: new owner is the zero address");
272         emit OwnershipTransferred(_owner, newOwner);
273         _owner = newOwner;
274     }
275 }
276 
277 interface IDexRouter {
278     function factory() external pure returns (address);
279     function WETH() external pure returns (address);
280     
281     function swapExactTokensForETHSupportingFeeOnTransferTokens(
282         uint amountIn,
283         uint amountOutMin,
284         address[] calldata path,
285         address to,
286         uint deadline
287     ) external;
288 
289     function addLiquidityETH(
290         address token,
291         uint256 amountTokenDesired,
292         uint256 amountTokenMin,
293         uint256 amountETHMin,
294         address to,
295         uint256 deadline
296     )
297         external
298         payable
299         returns (
300             uint256 amountToken,
301             uint256 amountETH,
302             uint256 liquidity
303         );
304 }
305 
306 interface IDexFactory {
307     function createPair(address tokenA, address tokenB)
308         external
309         returns (address pair);
310 }
311 
312 contract WorldPeace is ERC20, Ownable {
313 
314     uint256 public maxBuyAmount;
315     uint256 public maxSellAmount;
316     uint256 public maxWalletAmount;
317 
318     IDexRouter public immutable uniswapV2Router;
319     address public immutable uniswapV2Pair;
320 
321     bool private swapping;
322     uint256 public swapTokensAtAmount;
323 
324     address public charityAddress;
325     address public yashaAddress;
326     address public cliffAddress;
327 
328     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
329 
330     bool public limitsInEffect = true;
331     bool public tradingActive = false;
332     bool public swapEnabled = false;
333     
334      // Anti-bot and anti-whale mappings and variables
335     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
336     bool public transferDelayEnabled = true;
337 
338     uint256 public buyTotalFees;
339     uint256 public buyCharityFee;
340     uint256 public buyLiquidityFee;
341     uint256 public buyYashaFee;
342     uint256 public buyCliffFee;
343 
344     uint256 public sellTotalFees;
345     uint256 public sellCharityFee;
346     uint256 public sellLiquidityFee;
347     uint256 public sellYashaFee;
348     uint256 public sellCliffFee;
349 
350     uint256 public tokensForCharity;
351     uint256 public tokensForLiquidity;
352     uint256 public tokensForYasha;
353     uint256 public tokensForCliff;
354     
355     /******************/
356 
357     //exlcude from fees and max transaction amount
358     mapping (address => bool) private _isExcludedFromFees;
359     mapping (address => bool) public _isExcludedMaxTransactionAmount;
360 
361     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
362     // could be subject to a maximum transfer amount
363     mapping (address => bool) public automatedMarketMakerPairs;
364 
365     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
366 
367     event EnabledTrading();
368     event RemovedLimits();
369 
370     event ExcludeFromFees(address indexed account, bool isExcluded);
371 
372     event UpdatedMaxBuyAmount(uint256 newAmount);
373 
374     event UpdatedMaxSellAmount(uint256 newAmount);
375 
376     event UpdatedMaxWalletAmount(uint256 newAmount);
377 
378     event UpdatedCharityAddress(address indexed newWallet);
379 
380     event UpdatedYashaAddress(address indexed newWallet);
381 
382     event UpdatedCliffAddress(address indexed newWallet);
383 
384     event MaxTransactionExclusion(address _address, bool excluded);
385 
386     event SwapAndLiquify(
387         uint256 tokensSwapped,
388         uint256 ethReceived,
389         uint256 tokensIntoLiquidity
390     );
391 
392     event TransferForeignToken(address token, uint256 amount);
393 
394     constructor() ERC20("PAZ", "PAZ") {
395         
396         address newOwner = msg.sender; // can leave alone if owner is deployer.
397         
398         IDexRouter _uniswapV2Router = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
399 
400         _excludeFromMaxTransaction(address(_uniswapV2Router), true);
401         uniswapV2Router = _uniswapV2Router;
402         
403         uniswapV2Pair = IDexFactory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
404         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
405  
406         uint256 totalSupply = 77 * 1e9 * 1e18;
407         
408         maxBuyAmount = totalSupply * 1 / 1000;
409         maxSellAmount = totalSupply * 1 / 1000;
410         maxWalletAmount = totalSupply * 3 / 1000;
411         swapTokensAtAmount = totalSupply * 25 / 100000; // 0.025% swap amount
412 
413         buyCharityFee = 3;
414         buyLiquidityFee = 1;
415         buyYashaFee = 1;
416         buyCliffFee = 1;
417         buyTotalFees = buyCharityFee + buyLiquidityFee + buyYashaFee + buyCliffFee;
418 
419         sellCharityFee = 3;
420         sellLiquidityFee = 1;
421         sellYashaFee = 1;
422         sellCliffFee = 1;
423         sellTotalFees = sellCharityFee + sellLiquidityFee + sellYashaFee + sellCliffFee;
424 
425         _excludeFromMaxTransaction(newOwner, true);
426         _excludeFromMaxTransaction(address(this), true);
427         _excludeFromMaxTransaction(address(0xdead), true);
428 
429         excludeFromFees(newOwner, true);
430         excludeFromFees(address(this), true);
431         excludeFromFees(address(0xdead), true);
432 
433         charityAddress = 0x4d19D32838DFAb0f7ca869319fDFA08588881ECd;
434         yashaAddress = 0x3a0aB80324B676d0573a41Da6374af827Dc49abE;
435         cliffAddress = 0x20c606FBb6984AAAB0CaD48F1f2644693aDC1680;
436 
437         _createInitialSupply(newOwner, totalSupply);
438         transferOwnership(newOwner);
439     }
440 
441     receive() external payable {}
442 
443     // once enabled, can never be turned off
444     function enableTrading() external onlyOwner {
445         require(!tradingActive, "Cannot reenable trading");
446         tradingActive = true;
447         swapEnabled = true;
448         tradingActiveBlock = block.number;
449         emit EnabledTrading();
450     }
451     
452     // remove limits after token is stable
453     function removeLimits() external onlyOwner {
454         limitsInEffect = false;
455         transferDelayEnabled = false;
456         emit RemovedLimits();
457     }
458     
459    
460     // disable Transfer delay - cannot be reenabled
461     function disableTransferDelay() external onlyOwner {
462         transferDelayEnabled = false;
463     }
464     
465     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
466         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max buy amount lower than 0.1%");
467         maxBuyAmount = newNum * (10**18);
468         emit UpdatedMaxBuyAmount(maxBuyAmount);
469     }
470     
471     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
472         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max sell amount lower than 0.1%");
473         maxSellAmount = newNum * (10**18);
474         emit UpdatedMaxSellAmount(maxSellAmount);
475     }
476 
477     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
478         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
479         maxWalletAmount = newNum * (10**18);
480         emit UpdatedMaxWalletAmount(maxWalletAmount);
481     }
482 
483     // change the minimum amount of tokens to sell from fees
484     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
485   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
486   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
487   	    swapTokensAtAmount = newAmount;
488   	}
489     
490     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
491         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
492         emit MaxTransactionExclusion(updAds, isExcluded);
493     }
494 
495     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
496         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
497         require(wallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
498         for(uint256 i = 0; i < wallets.length; i++){
499             address wallet = wallets[i];
500             uint256 amount = amountsInTokens[i]*1e18;
501             _transfer(msg.sender, wallet, amount);
502         }
503     }
504     
505     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
506         if(!isEx){
507             require(updAds != uniswapV2Pair, "Cannot remove uniswap pair from max txn");
508         }
509         _isExcludedMaxTransactionAmount[updAds] = isEx;
510     }
511 
512     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
513         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
514 
515         _setAutomatedMarketMakerPair(pair, value);
516     }
517 
518     function _setAutomatedMarketMakerPair(address pair, bool value) private {
519         automatedMarketMakerPairs[pair] = value;
520         
521         _excludeFromMaxTransaction(pair, value);
522 
523         emit SetAutomatedMarketMakerPair(pair, value);
524     }
525 
526     function updateBuyFees(uint256 _charityFee, uint256 _liquidityFee, uint256 _yashaFee, uint256 _cliffFee) external onlyOwner {
527         buyCharityFee = _charityFee;
528         buyLiquidityFee = _liquidityFee;
529         buyYashaFee = _yashaFee;
530         buyCliffFee = _cliffFee;
531         buyTotalFees = buyCharityFee + buyLiquidityFee + buyYashaFee + buyCliffFee;
532         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
533     }
534 
535     function updateSellFees(uint256 _charityFee, uint256 _liquidityFee, uint256 _yashaFee, uint256 _cliffFee) external onlyOwner {
536         sellCharityFee = _charityFee;
537         sellLiquidityFee = _liquidityFee;
538         sellYashaFee = _yashaFee;
539         sellCliffFee = _cliffFee;
540         sellTotalFees = sellCharityFee + sellLiquidityFee + sellYashaFee + sellCliffFee;
541         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
542     }
543 
544     function excludeFromFees(address account, bool excluded) public onlyOwner {
545         _isExcludedFromFees[account] = excluded;
546         emit ExcludeFromFees(account, excluded);
547     }
548 
549     function _transfer(address from, address to, uint256 amount) internal override {
550 
551         require(from != address(0), "ERC20: transfer from the zero address");
552         require(to != address(0), "ERC20: transfer to the zero address");
553         require(amount > 0, "amount must be greater than 0");
554         
555         
556         if(limitsInEffect){
557             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead)){
558                 if(!tradingActive){
559                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
560                 }
561                 
562                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
563                 if (transferDelayEnabled){
564                     if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
565                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 4 && _holderLastTransferTimestamp[to] < block.number - 10, "_transfer:: Transfer Delay enabled.  Try again later.");
566                         _holderLastTransferTimestamp[tx.origin] = block.number;
567                         _holderLastTransferTimestamp[to] = block.number;
568                     }
569                 }
570                  
571                 //when buy
572                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
573                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
574                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
575                 } 
576                 //when sell
577                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
578                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
579                 } 
580                 else if (!_isExcludedMaxTransactionAmount[to] && !_isExcludedMaxTransactionAmount[from]){
581                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
582                 }
583             }
584         }
585 
586         uint256 contractTokenBalance = balanceOf(address(this));
587         
588         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
589 
590         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
591             swapping = true;
592 
593             swapBack();
594 
595             swapping = false;
596         }
597 
598         bool takeFee = true;
599         // if any account belongs to _isExcludedFromFee account then remove the fee
600         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
601             takeFee = false;
602         }
603         
604         uint256 fees = 0;
605         uint256 penaltyAmount = 0;
606         // only take fees on buys/sells, do not take on wallet transfers
607         if(takeFee){
608             // bot/sniper penalty.  Tokens get transferred to marketing wallet to allow potential refund.
609             if(tradingActiveBlock >= block.number + 1 && automatedMarketMakerPairs[from]){
610                 penaltyAmount = amount * 99 / 100;
611                 super._transfer(from, charityAddress, penaltyAmount);
612             }
613             // on sell
614             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
615                 fees = amount * sellTotalFees /100;
616                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
617                 tokensForCharity += fees * sellCharityFee / sellTotalFees;
618                 tokensForYasha += fees * sellYashaFee / sellTotalFees;
619                 tokensForCliff += fees * sellCliffFee / buyTotalFees;
620             }
621             // on buy
622             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
623         	    fees = amount * buyTotalFees / 100;
624         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
625                 tokensForCharity += fees * buyCharityFee / buyTotalFees;
626                 tokensForYasha += fees * buyYashaFee / buyTotalFees;
627                 tokensForCliff += fees * buyCliffFee / buyTotalFees;
628             }
629             
630             if(fees > 0){    
631                 super._transfer(from, address(this), fees);
632             }
633         	
634         	amount -= fees + penaltyAmount;
635         }
636 
637         super._transfer(from, to, amount);
638     }
639 
640     function swapTokensForEth(uint256 tokenAmount) private {
641 
642         // generate the uniswap pair path of token -> weth
643         address[] memory path = new address[](2);
644         path[0] = address(this);
645         path[1] = uniswapV2Router.WETH();
646 
647         _approve(address(this), address(uniswapV2Router), tokenAmount);
648 
649         // make the swap
650         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
651             tokenAmount,
652             0, // accept any amount of ETH
653             path,
654             address(this),
655             block.timestamp
656         );
657     }
658     
659     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
660         // approve token transfer to cover all possible scenarios
661         _approve(address(this), address(uniswapV2Router), tokenAmount);
662 
663         // add the liquidity
664         uniswapV2Router.addLiquidityETH{value: ethAmount}(
665             address(this),
666             tokenAmount,
667             0, // slippage is unavoidable
668             0, // slippage is unavoidable
669             address(0xdead),
670             block.timestamp
671         );
672     }
673 
674     function swapBack() private {
675         uint256 contractBalance = balanceOf(address(this));
676         uint256 totalTokensToSwap = tokensForLiquidity + tokensForCharity + tokensForYasha + tokensForCliff;
677         
678         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
679 
680         if(contractBalance > swapTokensAtAmount * 10){
681             contractBalance = swapTokensAtAmount * 10;
682         }
683 
684         bool success;
685         
686         // Halve the amount of liquidity tokens
687         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
688         
689         swapTokensForEth(contractBalance - liquidityTokens); 
690         
691         uint256 ethBalance = address(this).balance;
692         uint256 ethForLiquidity = ethBalance;
693 
694         uint256 ethForCharity = ethBalance * tokensForCharity / (totalTokensToSwap - (tokensForLiquidity/2));
695         uint256 ethForYasha = ethBalance * tokensForYasha / (totalTokensToSwap - (tokensForLiquidity/2));
696         uint256 ethForCliff = ethBalance * tokensForCliff / (totalTokensToSwap - (tokensForLiquidity/2));
697 
698         ethForLiquidity -= ethForCharity + ethForYasha + ethForCliff;
699             
700         tokensForLiquidity = 0;
701         tokensForCharity = 0;
702         tokensForYasha = 0;
703         tokensForCliff = 0;
704         
705         if(liquidityTokens > 0 && ethForLiquidity > 0){
706             addLiquidity(liquidityTokens, ethForLiquidity);
707         }
708 
709         (success,) = address(yashaAddress).call{value: ethForYasha}("");
710 
711         (success,) = address(cliffAddress).call{value: ethForCliff}("");
712 
713         (success,) = address(charityAddress).call{value: address(this).balance}("");
714     }
715 
716     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
717         require(_token != address(0), "_token address cannot be 0");
718         require(_token != address(this), "Can't withdraw native tokens");
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
730     function setCharityAddress(address _charityAddress) external onlyOwner {
731         require(_charityAddress != address(0), "_charityAddress address cannot be 0");
732         charityAddress = payable(_charityAddress);
733         emit UpdatedCharityAddress(_charityAddress);
734     }
735 
736     function setYashaAddress(address _yashaAddress) external onlyOwner {
737         require(_yashaAddress != address(0), "_yashaAddress address cannot be 0");
738         yashaAddress = payable(_yashaAddress);
739         emit UpdatedYashaAddress(_yashaAddress);
740     }
741 
742      function setCliffAddress(address _cliffAddress) external onlyOwner {
743         require(_cliffAddress != address(0), "_cliffAddress address cannot be 0");
744         cliffAddress = payable(_cliffAddress);
745         emit UpdatedCliffAddress(_cliffAddress);
746     }
747 }