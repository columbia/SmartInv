1 // SPDX-License-Identifier: MIT                                                                               
2 
3 /*           _____                    _____                    _____            _____          
4          /\    \                  /\    \                  /\    \          /\    \         
5         /::\    \                /::\    \                /::\____\        /::\    \        
6        /::::\    \              /::::\    \              /:::/    /        \:::\    \       
7       /::::::\    \            /::::::\    \            /:::/    /          \:::\    \      
8      /:::/\:::\    \          /:::/\:::\    \          /:::/    /            \:::\    \     
9     /:::/  \:::\    \        /:::/__\:::\    \        /:::/    /              \:::\    \    
10    /:::/    \:::\    \      /::::\   \:::\    \      /:::/    /               /::::\    \   
11   /:::/    / \:::\    \    /::::::\   \:::\    \    /:::/    /       ____    /::::::\    \  
12  /:::/    /   \:::\ ___\  /:::/\:::\   \:::\    \  /:::/    /       /\   \  /:::/\:::\    \ 
13 /:::/____/  ___\:::|    |/:::/  \:::\   \:::\____\/:::/____/       /::\   \/:::/  \:::\____\
14 \:::\    \ /\  /:::|____|\::/    \:::\  /:::/    /\:::\    \       \:::\  /:::/    \::/    /
15  \:::\    /::\ \::/    /  \/____/ \:::\/:::/    /  \:::\    \       \:::\/:::/    / \/____/ 
16   \:::\   \:::\ \/____/            \::::::/    /    \:::\    \       \::::::/    /          
17    \:::\   \:::\____\               \::::/    /      \:::\    \       \::::/____/           
18     \:::\  /:::/    /               /:::/    /        \:::\    \       \:::\    \           
19      \:::\/:::/    /               /:::/    /          \:::\    \       \:::\    \          
20       \::::::/    /               /:::/    /            \:::\    \       \:::\    \         
21        \::::/    /               /:::/    /              \:::\____\       \:::\____\        
22         \::/____/                \::/    /                \::/    /        \::/    /        
23                                   \/____/                  \/____/          \/____/         
24                                                                                             */
25 
26 
27 
28 // 𝔸 ℂ𝕆𝕄𝕄𝕌ℕ𝕀𝕋𝕐 ℂ𝕆𝕀ℕ𝔼𝔻 𝔽ℝ𝕆𝕄 𝔸𝕊𝕋ℝ𝕆ℕ𝕆𝕄𝔼ℝ𝕊, 𝔼ℕ𝕋𝔼ℝ 𝕀𝔽 𝕐𝕆𝕌 ℍ𝔸𝕍𝔼 𝕋ℍ𝔼 𝕎𝕀𝕃𝕃 𝔸ℕ𝔻 ℙ𝔼ℝ𝕊𝔼𝕍𝔼ℝ𝔸ℕℂ𝔼 𝕋𝕆 𝕋ℝ𝔸𝕍𝔼ℝ𝕊𝔼 𝕋ℍ𝔼 𝕊𝕋𝔸ℝ𝕊                                                   
29 
30 pragma solidity 0.8.15;
31 
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address) {
34         return msg.sender;
35     }
36 
37     function _msgData() internal view virtual returns (bytes calldata) {
38         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
39         return msg.data;
40     }
41 }
42 
43 interface IERC20 {
44     /**
45      * @dev Returns the amount of tokens in existence.
46      */
47     function totalSupply() external view returns (uint256);
48 
49     /**
50      * @dev Returns the amount of tokens owned by `account`.
51      */
52     function balanceOf(address account) external view returns (uint256);
53 
54     /**
55      * @dev Moves `amount` tokens from the caller's account to `recipient`.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transfer(address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Returns the remaining number of tokens that `spender` will be
65      * allowed to spend on behalf of `owner` through {transferFrom}. This is
66      * zero by default.
67      *
68      * This value changes when {approve} or {transferFrom} are called.
69      */
70     function allowance(address owner, address spender) external view returns (uint256);
71 
72     /**
73      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * IMPORTANT: Beware that changing an allowance with this method brings the risk
78      * that someone may use both the old and the new allowance by unfortunate
79      * transaction ordering. One possible solution to mitigate this race
80      * condition is to first reduce the spender's allowance to 0 and set the
81      * desired value afterwards:
82      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
83      *
84      * Emits an {Approval} event.
85      */
86     function approve(address spender, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Moves `amount` tokens from `sender` to `recipient` using the
90      * allowance mechanism. `amount` is then deducted from the caller's
91      * allowance.
92      *
93      * Returns a boolean value indicating whether the operation succeeded.
94      *
95      * Emits a {Transfer} event.
96      */
97     function transferFrom(
98         address sender,
99         address recipient,
100         uint256 amount
101     ) external returns (bool);
102 
103     /**
104      * @dev Emitted when `value` tokens are moved from one account (`from`) to
105      * another (`to`).
106      *
107      * Note that `value` may be zero.
108      */
109     event Transfer(address indexed from, address indexed to, uint256 value);
110 
111     /**
112      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
113      * a call to {approve}. `value` is the new allowance.
114      */
115     event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 interface IERC20Metadata is IERC20 {
119     /**
120      * @dev Returns the name of the token.
121      */
122     function name() external view returns (string memory);
123 
124     /**
125      * @dev Returns the symbol of the token.
126      */
127     function symbol() external view returns (string memory);
128 
129     /**
130      * @dev Returns the decimals places of the token.
131      */
132     function decimals() external view returns (uint8);
133 }
134 
135 contract ERC20 is Context, IERC20, IERC20Metadata {
136     mapping(address => uint256) private _balances;
137 
138     mapping(address => mapping(address => uint256)) private _allowances;
139 
140     uint256 private _totalSupply;
141 
142     string private _name;
143     string private _symbol;
144 
145     constructor(string memory name_, string memory symbol_) {
146         _name = name_;
147         _symbol = symbol_;
148     }
149 
150     function name() public view virtual override returns (string memory) {
151         return _name;
152     }
153 
154     function symbol() public view virtual override returns (string memory) {
155         return _symbol;
156     }
157 
158     function decimals() public view virtual override returns (uint8) {
159         return 18;
160     }
161 
162     function totalSupply() public view virtual override returns (uint256) {
163         return _totalSupply;
164     }
165 
166     function balanceOf(address account) public view virtual override returns (uint256) {
167         return _balances[account];
168     }
169 
170     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
171         _transfer(_msgSender(), recipient, amount);
172         return true;
173     }
174 
175     function allowance(address owner, address spender) public view virtual override returns (uint256) {
176         return _allowances[owner][spender];
177     }
178 
179     function approve(address spender, uint256 amount) public virtual override returns (bool) {
180         _approve(_msgSender(), spender, amount);
181         return true;
182     }
183 
184     function transferFrom(
185         address sender,
186         address recipient,
187         uint256 amount
188     ) public virtual override returns (bool) {
189         _transfer(sender, recipient, amount);
190 
191         uint256 currentAllowance = _allowances[sender][_msgSender()];
192         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
193         unchecked {
194             _approve(sender, _msgSender(), currentAllowance - amount);
195         }
196 
197         return true;
198     }
199 
200     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
201         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
202         return true;
203     }
204 
205     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
206         uint256 currentAllowance = _allowances[_msgSender()][spender];
207         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
208         unchecked {
209             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
210         }
211 
212         return true;
213     }
214 
215     function _transfer(
216         address sender,
217         address recipient,
218         uint256 amount
219     ) internal virtual {
220         require(sender != address(0), "ERC20: transfer from the zero address");
221         require(recipient != address(0), "ERC20: transfer to the zero address");
222 
223         uint256 senderBalance = _balances[sender];
224         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
225         unchecked {
226             _balances[sender] = senderBalance - amount;
227         }
228         _balances[recipient] += amount;
229 
230         emit Transfer(sender, recipient, amount);
231     }
232 
233     function _createInitialSupply(address account, uint256 amount) internal virtual {
234         require(account != address(0), "ERC20: mint to the zero address");
235 
236         _totalSupply += amount;
237         _balances[account] += amount;
238         emit Transfer(address(0), account, amount);
239     }
240 
241     function _approve(
242         address owner,
243         address spender,
244         uint256 amount
245     ) internal virtual {
246         require(owner != address(0), "ERC20: approve from the zero address");
247         require(spender != address(0), "ERC20: approve to the zero address");
248 
249         _allowances[owner][spender] = amount;
250         emit Approval(owner, spender, amount);
251     }
252 }
253 
254 contract Ownable is Context {
255     address private _owner;
256 
257     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
258     
259     constructor () {
260         address msgSender = _msgSender();
261         _owner = msgSender;
262         emit OwnershipTransferred(address(0), msgSender);
263     }
264 
265     function owner() public view returns (address) {
266         return _owner;
267     }
268 
269     modifier onlyOwner() {
270         require(_owner == _msgSender(), "Ownable: caller is not the owner");
271         _;
272     }
273 
274     function renounceOwnership() external virtual onlyOwner {
275         emit OwnershipTransferred(_owner, address(0));
276         _owner = address(0);
277     }
278 
279     function transferOwnership(address newOwner) public virtual onlyOwner {
280         require(newOwner != address(0), "Ownable: new owner is the zero address");
281         emit OwnershipTransferred(_owner, newOwner);
282         _owner = newOwner;
283     }
284 }
285 
286 interface IDexRouter {
287     function factory() external pure returns (address);
288     function WETH() external pure returns (address);
289     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
290     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
291     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
292     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
293     function removeLiquidityETH(address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external returns (uint amountToken, uint amountETH);
294 }
295 
296 interface IDexFactory {
297     function createPair(address tokenA, address tokenB) external returns (address pair);
298 }
299 
300 contract ASTRONOMERS is ERC20, Ownable {
301 
302     uint256 public maxBuyAmount;
303     uint256 public maxSellAmount;
304     uint256 public maxWallet;
305 
306     IDexRouter public dexRouter;
307     address public lpPair;
308 
309     bool private swapping;
310     uint256 public swapTokensAtAmount;
311 
312     address public galiAddress;
313 
314     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
315     uint256 public blockForPenaltyEnd;
316     mapping (address => bool) public boughtEarly;
317     address[] public earlyBuyers;
318     uint256 public botsCaught;
319 
320     bool public limitsInEffect = true;
321     bool public tradingActive = false;
322     bool public swapEnabled = false;
323 
324     mapping (address => bool) public privateSaleWallets;
325     mapping (address => uint256) public nextPrivateWalletSellDate;
326     uint256 public maxPrivSaleSell = 1 ether;
327     
328      // Anti-bot and anti-whale mappings and variables
329     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
330     bool public transferDelayEnabled = true;
331 
332     uint256 public buyTotalFees;
333     uint256 public buyGaliFee;
334     uint256 public buyLiquidityFee;
335     uint256 public buyBurnFee;
336 
337     uint256 public sellTotalFees;
338     uint256 public sellGaliFee;
339     uint256 public sellLiquidityFee;
340     uint256 public sellBurnFee;
341 
342     uint256 public constant FEE_DIVISOR = 10000;
343 
344     uint256 public tokensForGali;
345     uint256 public tokensForLiquidity;
346 
347     uint256 public lpWithdrawRequestTimestamp;
348     uint256 public lpWithdrawRequestDuration = 1 days;
349     bool public lpWithdrawRequestPending;
350     uint256 public lpPercToWithDraw;
351 
352     uint256 public percentForLPBurn = 5; // 5 = .05%
353     bool public lpBurnEnabled = false;
354     uint256 public lpBurnFrequency = 1800 seconds;
355     uint256 public lastLpBurnTime;
356     
357     uint256 public manualBurnFrequency = 30 seconds;
358     uint256 public lastManualLpBurnTime;
359     
360     /******************/
361 
362     // exlcude from fees and max transaction amount
363     mapping (address => bool) private _isExcludedFromFees;
364     mapping (address => bool) public _isExcludedMaxTransactionAmount;
365 
366     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
367     // could be subject to a maximum transfer amount
368     mapping (address => bool) public automatedMarketMakerPairs;
369 
370     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
371 
372     event EnabledTrading();
373 
374     event RemovedLimits();
375 
376     event ExcludeFromFees(address indexed account, bool isExcluded);
377 
378     event UpdatedMaxBuyAmount(uint256 newAmount);
379 
380     event UpdatedMaxSellAmount(uint256 newAmount);
381 
382     event UpdatedMaxWalletAmount(uint256 newAmount);
383 
384     event UpdatedGaliAddress(address indexed newWallet);
385 
386     event UpdatedDevAddress(address indexed newWallet);
387 
388     event MaxTransactionExclusion(address _address, bool excluded);
389 
390     event OwnerForcedSwapBack(uint256 timestamp);
391 
392     event CaughtEarlyBuyer(address sniper);
393 
394     event SwapAndLiquify(
395         uint256 tokensSwapped,
396         uint256 ethReceived,
397         uint256 tokensIntoLiquidity
398     );
399 
400     event AutoBurnLP(uint256 indexed tokensBurned);
401 
402     event ManualBurnLP(uint256 indexed tokensBurned);
403 
404     event TransferForeignToken(address token, uint256 amount);
405 
406     event UpdatedPrivateMaxSell(uint256 amount);
407 
408     event RequestedLPWithdraw();
409     
410     event WithdrewLPForMigration();
411 
412     event CanceledLpWithdrawRequest();
413 
414     constructor() ERC20("GALILEO", "GALI") payable {
415         
416         address newOwner = msg.sender; // can leave alone if owner is deployer.
417         address _dexRouter;
418 
419         if(block.chainid == 1){
420             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
421         } else if(block.chainid == 4){
422             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
423         } else if(block.chainid == 56){
424             _dexRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BNB Chain: PCS V2
425         } else if(block.chainid == 97){
426             _dexRouter = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // BNB Chain: PCS V2
427         } else if(block.chainid == 42161){
428             _dexRouter = 0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506; // Arbitrum: SushiSwap
429         } else {
430             revert("Chain not configured");
431         }
432 
433         // initialize router
434         dexRouter = IDexRouter(_dexRouter);
435 
436         uint256 totalSupply = 1 * 1e8 * (10 ** decimals());
437         
438         maxBuyAmount = totalSupply * 1 / 100;
439         maxSellAmount = totalSupply * 1 / 100;
440         maxWallet = totalSupply * 1 / 100;
441         swapTokensAtAmount = totalSupply * 25 / 100000;
442 
443         buyGaliFee = 0;
444         buyLiquidityFee = 1500;
445         buyBurnFee = 500;
446         buyTotalFees = buyGaliFee + buyLiquidityFee + buyBurnFee;
447 
448         sellGaliFee = 0;
449         sellLiquidityFee = 1500;
450         sellBurnFee = 500;
451         sellTotalFees = sellGaliFee + sellLiquidityFee + sellBurnFee;
452 
453         galiAddress = address(msg.sender);
454 
455         _excludeFromMaxTransaction(newOwner, true);
456         _excludeFromMaxTransaction(address(this), true);
457         _excludeFromMaxTransaction(address(0xdead), true);
458         _excludeFromMaxTransaction(address(galiAddress), true);
459         _excludeFromMaxTransaction(address(dexRouter), true);
460 
461         excludeFromFees(newOwner, true);
462         excludeFromFees(address(this), true);
463         excludeFromFees(address(0xdead), true);
464         excludeFromFees(address(galiAddress), true);
465         excludeFromFees(address(dexRouter), true);
466 
467         
468         _createInitialSupply(address(this), totalSupply * 80 / 100);  // update with % for LP
469         _createInitialSupply(newOwner, totalSupply - balanceOf(address(this)));
470         transferOwnership(newOwner);
471     }
472 
473     receive() external payable {}
474     
475     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
476         require(!tradingActive, "Cannot reenable trading");
477         require(blocksForPenalty <= 50, "Cannot make penalty blocks more than 50");
478         tradingActive = true;
479         swapEnabled = true;
480         tradingActiveBlock = block.number;
481         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
482         emit EnabledTrading();
483     }
484     
485     // remove limits after token is stable
486     function removeLimits() external onlyOwner {
487         limitsInEffect = false;
488         transferDelayEnabled = false;
489         maxBuyAmount = totalSupply();
490         maxSellAmount = totalSupply();
491         emit RemovedLimits();
492     }
493 
494     function getEarlyBuyers() external view returns (address[] memory){
495         return earlyBuyers;
496     }
497 
498     function massRemoveBoughtEarly(address[] calldata accounts) external onlyOwner {
499         for(uint256 i = 0; i < accounts.length; i++){
500             boughtEarly[accounts[i]] = false;
501         }
502     }
503 
504     function removeBoughtEarly(address wallet) external onlyOwner {
505         require(boughtEarly[wallet], "Wallet is already not flagged.");
506         boughtEarly[wallet] = false;
507     }
508 
509     function emergencyUpdateRouter(address router) external onlyOwner {
510         require(!tradingActive, "Cannot update after trading is functional");
511         dexRouter = IDexRouter(router);
512     }
513     
514     // disable Transfer delay - cannot be reenabled
515     function disableTransferDelay() external onlyOwner {
516         transferDelayEnabled = false;
517     }
518     
519     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
520         require(newNum >= (totalSupply() * 1 / 1000) / (10 ** decimals()), "Cannot set max buy amount lower than 0.1%");
521         maxBuyAmount = newNum * (10 ** decimals());
522         emit UpdatedMaxBuyAmount(maxBuyAmount);
523     }
524     
525     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
526         require(newNum >= (totalSupply() * 1 / 1000) / (10 ** decimals()), "Cannot set max sell amount lower than 0.1%");
527         maxSellAmount = newNum * (10 ** decimals());
528         emit UpdatedMaxSellAmount(maxSellAmount);
529     }
530 
531     function updateMaxWallet(uint256 newNum) external onlyOwner {
532         require(newNum >= (totalSupply() * 1 / 100) / (10 ** decimals()), "Cannot set max wallet amount lower than %");
533         maxWallet = newNum * (10 ** decimals());
534         emit UpdatedMaxWalletAmount(maxWallet);
535     }
536 
537     // change the minimum amount of tokens to sell from fees
538     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
539   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
540   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
541   	    swapTokensAtAmount = newAmount;
542   	}
543     
544     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
545         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
546         emit MaxTransactionExclusion(updAds, isExcluded);
547     }
548      
549     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
550         if(!isEx){
551             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
552         }
553         _isExcludedMaxTransactionAmount[updAds] = isEx;
554     }
555 
556     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
557         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
558         _setAutomatedMarketMakerPair(pair, value);
559         emit SetAutomatedMarketMakerPair(pair, value);
560     }
561 
562     function _setAutomatedMarketMakerPair(address pair, bool value) private {
563         automatedMarketMakerPairs[pair] = value;
564         _excludeFromMaxTransaction(pair, value);
565         emit SetAutomatedMarketMakerPair(pair, value);
566     }
567 
568     function updateBuyFees(uint256 _galiFee, uint256 _liquidityFee, uint256 _burnFee) external onlyOwner {
569         buyGaliFee = _galiFee;
570         buyLiquidityFee = _liquidityFee;
571         buyBurnFee = _burnFee;
572         buyTotalFees = buyGaliFee + buyLiquidityFee + buyBurnFee;
573         require(buyTotalFees <= 10 * FEE_DIVISOR / 100, "Must keep fees at 10% or less");
574     }
575 
576     function updateSellFees(uint256 _galiFee, uint256 _liquidityFee,uint256 _burnFee) external onlyOwner {
577         sellGaliFee = _galiFee;
578         sellLiquidityFee = _liquidityFee;
579         sellBurnFee = _burnFee;
580         sellTotalFees = sellGaliFee + sellLiquidityFee + sellBurnFee;
581         require(sellTotalFees <= 20 * FEE_DIVISOR / 100, "Must keep fees at 20% or less");
582     }
583 
584     function massExcludeFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
585         for(uint256 i = 0; i < accounts.length; i++){
586             _isExcludedFromFees[accounts[i]] = excluded;
587             emit ExcludeFromFees(accounts[i], excluded);
588         }
589     }
590 
591     function excludeFromFees(address account, bool excluded) public onlyOwner {
592         _isExcludedFromFees[account] = excluded;
593         emit ExcludeFromFees(account, excluded);
594     }
595 
596     function _transfer(address from, address to, uint256 amount) internal override {
597 
598         require(from != address(0), "ERC20: transfer from the zero address");
599         require(to != address(0), "ERC20: transfer to the zero address");
600         require(amount > 0, "amount must be greater than 0");
601         
602         if(!tradingActive){
603             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
604         }
605 
606         if(!earlyBuyPenaltyInEffect() && tradingActive){
607             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
608         }
609 
610         if(privateSaleWallets[from]){
611             if(automatedMarketMakerPairs[to]){
612                 //enforce max sell restrictions.
613                 require(nextPrivateWalletSellDate[from] <= block.timestamp, "Cannot sell yet");
614                 require(amount <= getPrivateSaleMaxSell(), "Attempting to sell over max sell amount.  Check max.");
615                 nextPrivateWalletSellDate[from] = block.timestamp + 24 hours;
616             } else if(!_isExcludedFromFees[to]){
617                 revert("Private sale cannot transfer and must sell only or transfer to a whitelisted address.");
618             }
619         }
620         
621         if(limitsInEffect){
622             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
623                 
624                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
625                 if (transferDelayEnabled){
626                     if (to != address(dexRouter) && to != address(lpPair)){
627                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
628                         _holderLastTransferTimestamp[tx.origin] = block.number;
629                         _holderLastTransferTimestamp[to] = block.number;
630                     }
631                 }
632                  
633                 //when buy
634                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
635                     require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
636                     require(amount + balanceOf(to) <= maxWallet, "Cannot exceed max wallet");
637                 } 
638                 //when sell
639                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
640                     require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
641                 }
642                 else if (!_isExcludedMaxTransactionAmount[to]) {
643                     require(amount + balanceOf(to) <= maxWallet, "Cannot exceed max wallet");
644                 }
645             }
646         }
647 
648         uint256 contractTokenBalance = balanceOf(address(this));
649         
650         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
651 
652         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
653             swapping = true;
654             swapBack();
655             swapping = false;
656         }
657 
658         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
659             autoBurnLiquidityPairTokens();
660         }
661 
662         bool takeFee = true;
663         // if any account belongs to _isExcludedFromFee account then remove the fee
664         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
665             takeFee = false;
666         }
667         
668         uint256 fees = 0;
669         uint256 tokensToBurn = 0;
670 
671         // only take fees on buys/sells, do not take on wallet transfers
672         if(takeFee){
673             // bot/sniper penalty.
674             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && !_isExcludedFromFees[to] && buyTotalFees > 0){
675                 
676                 if(!earlyBuyPenaltyInEffect()){
677                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
678                     maxBuyAmount -= 1;
679                 }
680 
681                 if(!boughtEarly[to]){
682                     boughtEarly[to] = true;
683                     botsCaught += 1;
684                     earlyBuyers.push(to);
685                     emit CaughtEarlyBuyer(to);
686                 }
687 
688                 fees = amount * buyTotalFees / FEE_DIVISOR;
689         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
690                 tokensForGali += fees * buyGaliFee / buyTotalFees;
691                 tokensToBurn = fees * buyBurnFee / buyTotalFees;
692             }
693 
694             // on sell
695             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
696                 fees = amount * sellTotalFees / FEE_DIVISOR;
697                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
698                 tokensForGali += fees * sellGaliFee / sellTotalFees;
699                 tokensToBurn = fees * sellBurnFee / buyTotalFees;
700             }
701 
702             // on buy
703             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
704         	    fees = amount * buyTotalFees / FEE_DIVISOR;
705         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
706                 tokensForGali += fees * buyGaliFee / buyTotalFees;
707                 tokensToBurn = fees * buyBurnFee / buyTotalFees;
708             }
709             
710             if(fees > 0){    
711                 super._transfer(from, address(this), fees);
712                 if(tokensToBurn > 0){
713                     super._transfer(address(this), address(0xdead), tokensToBurn);
714                 }
715             }
716         	
717         	amount -= fees;
718         }
719 
720         super._transfer(from, to, amount);
721     }
722 
723     function earlyBuyPenaltyInEffect() public view returns (bool){
724         return block.number < blockForPenaltyEnd;
725     }
726 
727     function swapTokensForEth(uint256 tokenAmount) private {
728 
729         // generate the uniswap pair path of token -> weth
730         address[] memory path = new address[](2);
731         path[0] = address(this);
732         path[1] = dexRouter.WETH();
733 
734         _approve(address(this), address(dexRouter), tokenAmount);
735 
736         // make the swap
737         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
738             tokenAmount,
739             0, // accept any amount of ETH
740             path,
741             address(this),
742             block.timestamp
743         );
744     }
745     
746     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
747         // approve token transfer to cover all possible scenarios
748         _approve(address(this), address(dexRouter), tokenAmount);
749 
750         // add the liquidity
751         dexRouter.addLiquidityETH{value: ethAmount}(
752             address(this),
753             tokenAmount,
754             0, // slippage is unavoidable
755             0, // slippage is unavoidable
756             address(this),
757             block.timestamp
758         );
759     }
760 
761     function swapBack() private {
762 
763         uint256 contractBalance = balanceOf(address(this));
764         uint256 totalTokensToSwap = tokensForLiquidity + tokensForGali;
765         
766         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
767 
768         if(contractBalance > swapTokensAtAmount * 10){
769             contractBalance = swapTokensAtAmount * 10;
770         }
771 
772         bool success;
773         
774         // Halve the amount of liquidity tokens
775         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
776         
777         swapTokensForEth(contractBalance - liquidityTokens); 
778         
779         uint256 ethBalance = address(this).balance;
780         uint256 ethForLiquidity = ethBalance;
781 
782         uint256 ethForGali = ethBalance * tokensForGali / (totalTokensToSwap - (tokensForLiquidity/2));
783 
784         ethForLiquidity -= ethForGali;
785             
786         tokensForLiquidity = 0;
787         tokensForGali = 0;
788         
789         if(liquidityTokens > 0 && ethForLiquidity > 0){
790             addLiquidity(liquidityTokens, ethForLiquidity);
791         }
792 
793         (success,) = address(galiAddress).call{value: address(this).balance}("");
794     }
795 
796     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
797         require(_token != address(0), "_token address cannot be 0");
798         require(_token != address(this) || !tradingActive, "Can't withdraw native tokens while trading is active");
799         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
800         _sent = IERC20(_token).transfer(_to, _contractBalance);
801         emit TransferForeignToken(_token, _contractBalance);
802     }
803 
804     // withdraw ETH if stuck or someone sends to the address
805     function withdrawStuckETH() external onlyOwner {
806         bool success;
807         (success,) = address(msg.sender).call{value: address(this).balance}("");
808     }
809 
810     function setGaliAddress(address _galiAddress) external onlyOwner {
811         require(_galiAddress != address(0), "_galiAddress address cannot be 0");
812         galiAddress = payable(_galiAddress);
813         emit UpdatedGaliAddress(_galiAddress);
814     }
815 
816     // force Swap back if slippage issues.
817     function forceSwapBack() external onlyOwner {
818         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
819         swapping = true;
820         swapBack();
821         swapping = false;
822         emit OwnerForcedSwapBack(block.timestamp);
823     }
824 
825     function getPrivateSaleMaxSell() public view returns (uint256){
826         address[] memory path = new address[](2);
827         path[0] = dexRouter.WETH();
828         path[1] = address(this);
829         
830         uint256[] memory amounts = new uint256[](2);
831         amounts = dexRouter.getAmountsOut(maxPrivSaleSell, path);
832         return amounts[1] + (amounts[1] * (sellLiquidityFee + sellGaliFee))/100;
833     }
834 
835     function setPrivateSaleMaxSell(uint256 amount) external onlyOwner{
836         require(amount >= 10 && amount <= 50000, "Must set between 0.1 and 500 BNB");
837         maxPrivSaleSell = amount * 1e16;
838         emit UpdatedPrivateMaxSell(amount);
839     }
840 
841     function launch(address[] memory wallets, uint256[] memory amountsInTokens, uint256 blocksForPenalty) external onlyOwner {
842         require(!tradingActive, "Trading is already active, cannot relaunch.");
843         require(blocksForPenalty < 50, "Cannot make penalty blocks more than 50");
844 
845         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
846         require(wallets.length < 300, "Can only airdrop 300 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
847         for(uint256 i = 0; i < wallets.length; i++){
848             address wallet = wallets[i];
849             privateSaleWallets[wallet] = true;
850             nextPrivateWalletSellDate[wallet] = block.timestamp + 24 hours;
851             uint256 amount = amountsInTokens[i] * (10 ** decimals());
852             super._transfer(msg.sender, wallet, amount);
853         }
854 
855         //standard enable trading
856         tradingActive = true;
857         swapEnabled = true;
858         tradingActiveBlock = block.number;
859         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
860         emit EnabledTrading();
861 
862         // create pair
863         lpPair = IDexFactory(dexRouter.factory()).createPair(address(this), dexRouter.WETH());
864         _excludeFromMaxTransaction(address(lpPair), true);
865         _setAutomatedMarketMakerPair(address(lpPair), true);
866    
867         // add the liquidity
868 
869         require(address(this).balance > 0, "Must have ETH on contract to launch");
870 
871         require(balanceOf(address(this)) > 0, "Must have Tokens on contract to launch");
872 
873         _approve(address(this), address(dexRouter), balanceOf(address(this)));
874         dexRouter.addLiquidityETH{value: address(this).balance}(
875             address(this),
876             balanceOf(address(this)),
877             0, // slippage is unavoidable
878             0, // slippage is unavoidable
879             address(this),
880             block.timestamp
881         );
882     }
883 
884     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
885         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
886         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
887         lpBurnFrequency = _frequencyInSeconds;
888         percentForLPBurn = _percent;
889         lpBurnEnabled = _Enabled;
890     }
891     
892     function autoBurnLiquidityPairTokens() internal {
893         
894         lastLpBurnTime = block.timestamp;
895         
896         lastManualLpBurnTime = block.timestamp;
897         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
898         uint256 tokenBalance = balanceOf(address(this));
899         uint256 lpAmount = lpBalance * percentForLPBurn / 10000;
900         uint256 initialEthBalance = address(this).balance;
901 
902         // approve token transfer to cover all possible scenarios
903         IERC20(lpPair).approve(address(dexRouter), lpAmount);
904 
905         // remove the liquidity
906         dexRouter.removeLiquidityETH(
907             address(this),
908             lpAmount,
909             1, // slippage is unavoidable
910             1, // slippage is unavoidable
911             address(this),
912             block.timestamp
913         );
914 
915         uint256 deltaTokenBalance = balanceOf(address(this)) - tokenBalance;
916         if(deltaTokenBalance > 0){
917             super._transfer(address(this), address(0xdead), deltaTokenBalance);
918         }
919 
920         uint256 deltaEthBalance = address(this).balance - initialEthBalance;
921 
922         if(deltaEthBalance > 0){
923             buyBackTokens(deltaEthBalance);
924         }
925 
926         emit AutoBurnLP(lpAmount);
927     }
928 
929     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner {
930         require(percent <=2000, "May not burn more than 20% of contract's LP at a time");
931         require(lastManualLpBurnTime <= block.timestamp - manualBurnFrequency, "Burn too soon");
932         lastManualLpBurnTime = block.timestamp;
933         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
934         uint256 tokenBalance = balanceOf(address(this));
935         uint256 lpAmount = lpBalance * percent / 10000;
936         uint256 initialEthBalance = address(this).balance;
937 
938         // approve token transfer to cover all possible scenarios
939         IERC20(lpPair).approve(address(dexRouter), lpAmount);
940 
941         // remove the liquidity
942         dexRouter.removeLiquidityETH(
943             address(this),
944             lpAmount,
945             1, // slippage is unavoidable
946             1, // slippage is unavoidable
947             address(this),
948             block.timestamp
949         );
950 
951         uint256 deltaTokenBalance = balanceOf(address(this)) - tokenBalance;
952         if(deltaTokenBalance > 0){
953             super._transfer(address(this), address(0xdead), deltaTokenBalance);
954         }
955 
956         uint256 deltaEthBalance = address(this).balance - initialEthBalance;
957 
958         if(deltaEthBalance > 0){
959             buyBackTokens(deltaEthBalance);
960         }
961 
962         emit ManualBurnLP(lpAmount);
963     }
964 
965     function buyBackTokens(uint256 amountInWei) internal {
966         address[] memory path = new address[](2);
967         path[0] = dexRouter.WETH();
968         path[1] = address(this);
969 
970         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
971             0,
972             path,
973             address(0xdead),
974             block.timestamp
975         );
976     }
977 
978     function requestToWithdrawLP(uint256 percToWithdraw) external onlyOwner {
979         require(!lpWithdrawRequestPending, "Cannot request again until first request is over.");
980         require(percToWithdraw <= 100 && percToWithdraw > 0, "Need to set between 1-100%");
981         lpWithdrawRequestTimestamp = block.timestamp;
982         lpWithdrawRequestPending = true;
983         lpPercToWithDraw = percToWithdraw;
984         emit RequestedLPWithdraw();
985     }
986 
987     function nextAvailableLpWithdrawDate() public view returns (uint256){
988         if(lpWithdrawRequestPending){
989             return lpWithdrawRequestTimestamp + lpWithdrawRequestDuration;
990         }
991         else {
992             return 0;  // 0 means no open requests
993         }
994     }
995 
996     function withdrawRequestedLP() external onlyOwner {
997         require(block.timestamp >= nextAvailableLpWithdrawDate() && nextAvailableLpWithdrawDate() > 0, "Must request and wait.");
998         lpWithdrawRequestTimestamp = 0;
999         lpWithdrawRequestPending = false;
1000 
1001         uint256 amtToWithdraw = IERC20(address(lpPair)).balanceOf(address(this)) * lpPercToWithDraw / 100;
1002         
1003         lpPercToWithDraw = 0;
1004 
1005         IERC20(lpPair).transfer(msg.sender, amtToWithdraw);
1006     }
1007 
1008     function cancelLPWithdrawRequest() external onlyOwner {
1009         lpWithdrawRequestPending = false;
1010         lpPercToWithDraw = 0;
1011         lpWithdrawRequestTimestamp = 0;
1012         emit CanceledLpWithdrawRequest();
1013     }
1014 }