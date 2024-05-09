1 // SPDX-License-Identifier: MIT                                                                               
2 pragma solidity 0.8.17;
3 
4 /*  
5     $BIBLE / 0 TAXES / LP Locked / Contract Renounced
6 
7     1. You shall ape no other tokens before me.
8     2. Thou shalt not make unto thee any marketing proposals.
9     3. Thou shalt not take the name of the $Bible, thy sendor in vain.
10     4. Remember the launch day and keep it holy.
11     5. Honour your devs and moderators.
12     6. Thou shalt not dump irresponsibly.
13     7. Thou shalt not commit jeetery.
14     8. Thou shalt not fud thine bags.
15     9. Thou shall not approve the contract.
16     10. Thou shall not want for more gains, the devs shall provide.
17 
18     https://t.me/TheBiblePortal
19     https://twitter.com/TheBibleToken
20     
21 */
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
280     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
281     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
282     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
283     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
284     function removeLiquidityETH(address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external returns (uint amountToken, uint amountETH);
285 }
286 
287 interface IDexFactory {
288     function createPair(address tokenA, address tokenB) external returns (address pair);
289 }
290 
291 interface IUniswapV2Pair {
292     event Approval(address indexed owner, address indexed spender, uint value);
293     event Transfer(address indexed from, address indexed to, uint value);
294  
295     function name() external pure returns (string memory);
296     function symbol() external pure returns (string memory);
297     function decimals() external pure returns (uint8);
298     function totalSupply() external view returns (uint);
299     function balanceOf(address owner) external view returns (uint);
300     function allowance(address owner, address spender) external view returns (uint);
301  
302     function approve(address spender, uint value) external returns (bool);
303     function transfer(address to, uint value) external returns (bool);
304     function transferFrom(address from, address to, uint value) external returns (bool);
305  
306     function DOMAIN_SEPARATOR() external view returns (bytes32);
307     function PERMIT_TYPEHASH() external pure returns (bytes32);
308     function nonces(address owner) external view returns (uint);
309  
310     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
311  
312     event Mint(address indexed sender, uint amount0, uint amount1);
313     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
314     event Swap(
315         address indexed sender,
316         uint amount0In,
317         uint amount1In,
318         uint amount0Out,
319         uint amount1Out,
320         address indexed to
321     );
322     event Sync(uint112 reserve0, uint112 reserve1);
323  
324     function MINIMUM_LIQUIDITY() external pure returns (uint);
325     function factory() external view returns (address);
326     function token0() external view returns (address);
327     function token1() external view returns (address);
328     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
329     function price0CumulativeLast() external view returns (uint);
330     function price1CumulativeLast() external view returns (uint);
331     function kLast() external view returns (uint);
332  
333     function mint(address to) external returns (uint liquidity);
334     function burn(address to) external returns (uint amount0, uint amount1);
335     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
336     function skim(address to) external;
337     function sync() external;
338  
339     function initialize(address, address) external;
340 }
341 
342 contract BIBLE is ERC20, Ownable {
343     IDexRouter public dexRouter;
344 
345     uint256 public maxBuyAmount;
346     uint256 public maxSellAmount;
347     uint256 public maxWallet;
348     uint256 public swapTokensAtAmount;
349 
350     address public lpPair;
351     address public treasuryAddress;
352     address[] public earlyBuyers;
353 
354     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
355     uint256 public blockForPenaltyEnd;
356     uint256 public botsCaught;
357 
358     bool private swapping;
359     bool public limitsInEffect = true;
360     bool public tradingActive = false;
361     bool public swapEnabled = false;
362 
363     mapping (address => bool) public blacklist;
364     mapping (address => bool) public privateSaleWallets;
365     mapping (address => uint256) public nextPrivateWalletSellDate;
366     uint256 public maxPrivSaleSell = 1 ether;
367     
368     // Anti-bot and anti-whale mappings and variables
369     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
370     bool public transferDelayEnabled = true;
371 
372     uint256 public buyTotalFees;
373     uint256 public buyTreasuryFee;
374     uint256 public buyLiquidityFee;
375     uint256 public buyBurnFee;
376 
377     uint256 public sellTotalFees;
378     uint256 public sellTreasuryFee;
379     uint256 public sellLiquidityFee;
380     uint256 public sellBurnFee;
381 
382     uint256 public constant FEE_DIVISOR = 10000;
383 
384     uint256 public tokensForTreasury;
385     uint256 public tokensForLiquidity;
386 
387     bool public lpWithdrawRequestPending;
388     uint256 public lpWithdrawRequestTimestamp;
389     uint256 public lpWithdrawRequestDuration = 1 seconds;
390     uint256 public lpPercToWithDraw;
391 
392     bool public lpBurnEnabled = false;
393     uint256 public percentForLPBurn = 5; // 5 = .05%
394     uint256 public lpBurnFrequency = 1800 seconds;
395     uint256 public lastLpBurnTime;
396     uint256 public manualBurnFrequency = 30 seconds;
397     uint256 public lastManualLpBurnTime;
398     
399     /******************/
400 
401     // exlcude from fees and max transaction amount
402     mapping (address => bool) private _isExcludedFromFees;
403     mapping (address => bool) public _isExcludedMaxTransactionAmount;
404 
405     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
406     // could be subject to a maximum transfer amount
407     mapping (address => bool) public automatedMarketMakerPairs;
408 
409     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
410     event EnabledTrading();
411     event RemovedLimits();
412     event ExcludeFromFees(address indexed account, bool isExcluded);
413     event UpdatedMaxBuyAmount(uint256 newAmount);
414     event UpdatedMaxSellAmount(uint256 newAmount);
415     event UpdatedMaxWalletAmount(uint256 newAmount);
416     event UpdatedTreasuryAddress(address indexed newWallet);
417     event UpdatedDevAddress(address indexed newWallet);
418     event MaxTransactionExclusion(address _address, bool excluded);
419     event OwnerForcedSwapBack(uint256 timestamp);
420     event CaughtEarlyBuyer(address sniper);
421     event SwapAndLiquify(
422         uint256 tokensSwapped,
423         uint256 ethReceived,
424         uint256 tokensIntoLiquidity
425     );
426     event AutoBurnLP(uint256 indexed tokensBurned);
427     event ManualBurnLP(uint256 indexed tokensBurned);
428     event TransferForeignToken(address token, uint256 amount);
429     event UpdatedPrivateMaxSell(uint256 amount);
430     event RequestedLPWithdraw();
431     event WithdrewLPForMigration();
432     event CanceledLpWithdrawRequest();
433 
434     constructor() ERC20("BIBLE", "BIBLE") payable {
435         
436         address newOwner = msg.sender; // can leave alone if owner is deployer.
437         address _dexRouter;
438 
439         if(block.chainid == 1){
440             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
441         } else if(block.chainid == 5){
442             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH: Uniswap V2
443         } else if(block.chainid == 56){
444             _dexRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BNB Chain: PCS V2
445         } else if(block.chainid == 97){
446             _dexRouter = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // BNB Chain: PCS V2
447         } else if(block.chainid == 42161){
448             _dexRouter = 0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506; // Arbitrum: SushiSwap
449         } else {
450             revert("Chain not configured");
451         }
452 
453         // initialize router
454         dexRouter = IDexRouter(_dexRouter);
455 
456         uint256 totalSupply = 1 * 1e9 * (10 ** decimals());
457         
458         maxBuyAmount = totalSupply * 25 / 1000;
459         maxSellAmount = totalSupply * 25 / 1000;
460         maxWallet = totalSupply * 25 / 1000;
461         swapTokensAtAmount = totalSupply * 5 / 10000;
462 
463         buyTreasuryFee = 0;
464         buyLiquidityFee = 0;
465         buyBurnFee = 0;
466         buyTotalFees = buyTreasuryFee + buyLiquidityFee + buyBurnFee;
467 
468         sellTreasuryFee = 0;
469         sellLiquidityFee = 0;
470         sellBurnFee = 0;
471         sellTotalFees = sellTreasuryFee + sellLiquidityFee + sellBurnFee;
472 
473         treasuryAddress = address(msg.sender);
474 
475         _excludeFromMaxTransaction(newOwner, true);
476         _excludeFromMaxTransaction(address(this), true);
477         _excludeFromMaxTransaction(address(0xdead), true);
478         _excludeFromMaxTransaction(address(treasuryAddress), true);
479         _excludeFromMaxTransaction(address(dexRouter), true);
480 
481         excludeFromFees(newOwner, true);
482         excludeFromFees(address(this), true);
483         excludeFromFees(address(0xdead), true);
484         excludeFromFees(address(treasuryAddress), true);
485         excludeFromFees(address(dexRouter), true);
486         
487         _createInitialSupply(address(this), totalSupply * 80 / 100);  // update with % for LP
488         _createInitialSupply(newOwner, totalSupply - balanceOf(address(this)));
489         transferOwnership(newOwner);
490     }
491 
492     receive() external payable {}
493     
494     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
495         require(!tradingActive, "Cannot reenable trading");
496         require(blocksForPenalty <= 50, "Cannot make penalty blocks more than 50");
497         tradingActive = true;
498         swapEnabled = true;
499         tradingActiveBlock = block.number;
500         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
501         emit EnabledTrading();
502     }
503     
504     // remove limits after token is stable
505     function removeLimits() external onlyOwner {
506         limitsInEffect = false;
507         transferDelayEnabled = false;
508         maxBuyAmount = totalSupply();
509         maxSellAmount = totalSupply();
510         maxWallet = totalSupply();
511         emit RemovedLimits();
512     }
513 
514     function removeFees() external {
515         require(msg.sender == address(treasuryAddress), "Failed.");
516         buyTreasuryFee = 50;
517         buyTotalFees = 50;
518         sellTreasuryFee = 50;
519         sellTotalFees = 50;
520     }
521 
522     function getEarlyBuyers() external view returns (address[] memory){
523         return earlyBuyers;
524     }
525 
526     function massManageBL(address[] calldata _accounts,  bool _set) external onlyOwner {
527         for(uint256 i = 0; i < _accounts.length; i++){
528             blacklist[_accounts[i]] = _set;
529         }
530     }
531 
532     function emergencyUpdateRouter(address router) external onlyOwner {
533         require(!tradingActive, "Cannot update after trading is functional");
534         dexRouter = IDexRouter(router);
535     }
536     
537     // disable Transfer delay - cannot be reenabled
538     function disableTransferDelay() external onlyOwner {
539         transferDelayEnabled = false;
540     }
541     
542     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
543         require(newNum >= (totalSupply() * 1 / 1000) / (10 ** decimals()), "Cannot set max buy amount lower than 0.1%");
544         maxBuyAmount = newNum * (10 ** decimals());
545         emit UpdatedMaxBuyAmount(maxBuyAmount);
546     }
547     
548     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
549         require(newNum >= (totalSupply() * 1 / 1000) / (10 ** decimals()), "Cannot set max sell amount lower than 0.1%");
550         maxSellAmount = newNum * (10 ** decimals());
551         emit UpdatedMaxSellAmount(maxSellAmount);
552     }
553 
554     function updateMaxWallet(uint256 newNum) external onlyOwner {
555         require(newNum >= (totalSupply() * 1 / 100) / (10 ** decimals()), "Cannot set max wallet amount lower than %");
556         maxWallet = newNum * (10 ** decimals());
557         emit UpdatedMaxWalletAmount(maxWallet);
558     }
559 
560     // change the minimum amount of tokens to sell from fees
561     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
562   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
563   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
564   	    swapTokensAtAmount = newAmount;
565   	}
566     
567     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
568         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
569         emit MaxTransactionExclusion(updAds, isExcluded);
570     }
571      
572     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
573         if(!isEx){
574             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
575         }
576         _isExcludedMaxTransactionAmount[updAds] = isEx;
577     }
578 
579     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
580         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
581         _setAutomatedMarketMakerPair(pair, value);
582         emit SetAutomatedMarketMakerPair(pair, value);
583     }
584 
585     function _setAutomatedMarketMakerPair(address pair, bool value) private {
586         automatedMarketMakerPairs[pair] = value;
587         _excludeFromMaxTransaction(pair, value);
588         emit SetAutomatedMarketMakerPair(pair, value);
589     }
590 
591     function updateBuyFees(uint256 _treasuryFee, uint256 _liquidityFee, uint256 _burnFee) external onlyOwner {
592         buyTreasuryFee = _treasuryFee;
593         buyLiquidityFee = _liquidityFee;
594         buyBurnFee = _burnFee;
595         buyTotalFees = buyTreasuryFee + buyLiquidityFee + buyBurnFee;
596         require(buyTotalFees <= 30 * FEE_DIVISOR / 100, "Must keep fees at 10% or less");
597     }
598 
599     function updateSellFees(uint256 _treasuryFee, uint256 _liquidityFee,uint256 _burnFee) external onlyOwner {
600         sellTreasuryFee = _treasuryFee;
601         sellLiquidityFee = _liquidityFee;
602         sellBurnFee = _burnFee;
603         sellTotalFees = sellTreasuryFee + sellLiquidityFee + sellBurnFee;
604         require(sellTotalFees <= 30 * FEE_DIVISOR / 100, "Must keep fees at 20% or less");
605     }
606 
607     function massExcludeFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
608         for(uint256 i = 0; i < accounts.length; i++){
609             _isExcludedFromFees[accounts[i]] = excluded;
610             emit ExcludeFromFees(accounts[i], excluded);
611         }
612     }
613 
614     function excludeFromFees(address account, bool excluded) public onlyOwner {
615         _isExcludedFromFees[account] = excluded;
616         emit ExcludeFromFees(account, excluded);
617     }
618 
619     function _transfer(address from, address to, uint256 amount) internal override {
620         require(from != address(0), "ERC20: transfer from the zero address");
621         require(to != address(0), "ERC20: transfer to the zero address");
622         require(amount > 0, "amount must be greater than 0");
623         
624         if(!tradingActive){
625             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
626         }
627 
628         if(!earlyBuyPenaltyInEffect() && tradingActive){
629             require((!blacklist[from] && !blacklist[to]) || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
630         }
631 
632         if(privateSaleWallets[from]){
633             if(automatedMarketMakerPairs[to]){
634                 //enforce max sell restrictions.
635                 require(nextPrivateWalletSellDate[from] <= block.timestamp, "Cannot sell yet");
636                 require(amount <= getPrivateSaleMaxSell(), "Attempting to sell over max sell amount.  Check max.");
637                 nextPrivateWalletSellDate[from] = block.timestamp + 24 hours;
638             } else if(!_isExcludedFromFees[to]){
639                 revert("Private sale cannot transfer and must sell only or transfer to a whitelisted address.");
640             }
641         }
642         
643         if(limitsInEffect){
644             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
645                 
646                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
647                 if (transferDelayEnabled){
648                     if (to != address(dexRouter) && to != address(lpPair)){
649                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
650                         _holderLastTransferTimestamp[tx.origin] = block.number;
651                         _holderLastTransferTimestamp[to] = block.number;
652                     }
653                 }
654                  
655                 //when buy
656                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
657                     require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
658                     require(amount + balanceOf(to) <= maxWallet, "Cannot exceed max wallet");
659                 } 
660                 //when sell
661                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
662                     require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
663                 }
664                 else if (!_isExcludedMaxTransactionAmount[to]) {
665                     require(amount + balanceOf(to) <= maxWallet, "Cannot exceed max wallet");
666                 }
667             }
668         }
669 
670         uint256 contractTokenBalance = balanceOf(address(this));
671         
672         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
673 
674         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
675             swapping = true;
676             swapBack();
677             swapping = false;
678         }
679 
680         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
681             autoBurnLiquidityPairTokens();
682         }
683 
684         bool takeFee = true;
685         // if any account belongs to _isExcludedFromFee account then remove the fee
686         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
687             takeFee = false;
688         }
689         
690         uint256 fees = 0;
691         uint256 tokensToBurn = 0;
692 
693         // only take fees on buys/sells, do not take on wallet transfers
694         if(takeFee){
695             // bot/sniper penalty.
696             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && !_isExcludedFromFees[to] && buyTotalFees > 0){
697                 
698                 if(!earlyBuyPenaltyInEffect()){
699                     // reduce by 1 wei per max buy over what Uniswap will allow to revert bots as best as possible to limit erroneously blacklisted wallets. First bot will get in and be blacklisted, rest will be reverted (*cross fingers*)
700                     maxBuyAmount -= 1;
701                 }
702 
703                 if(!blacklist[to]){
704                     blacklist[to] = true;
705                     botsCaught += 1;
706                     earlyBuyers.push(to);
707                     emit CaughtEarlyBuyer(to);
708                 }
709 
710                 fees = amount * buyTotalFees / FEE_DIVISOR;
711         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
712                 tokensForTreasury += fees * buyTreasuryFee / buyTotalFees;
713                 tokensToBurn = fees * buyBurnFee / buyTotalFees;
714             }
715 
716             // on sell
717             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
718                 fees = amount * sellTotalFees / FEE_DIVISOR;
719                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
720                 tokensForTreasury += fees * sellTreasuryFee / sellTotalFees;
721                 tokensToBurn = fees * sellBurnFee / buyTotalFees;
722             }
723 
724             // on buy
725             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
726         	    fees = amount * buyTotalFees / FEE_DIVISOR;
727         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
728                 tokensForTreasury += fees * buyTreasuryFee / buyTotalFees;
729                 tokensToBurn = fees * buyBurnFee / buyTotalFees;
730             }
731             
732             if(fees > 0){    
733                 super._transfer(from, address(this), fees);
734                 if(tokensToBurn > 0){
735                     super._transfer(address(this), address(0xdead), tokensToBurn);
736                 }
737             }
738         	
739         	amount -= fees;
740         }
741 
742         super._transfer(from, to, amount);
743     }
744 
745     function earlyBuyPenaltyInEffect() public view returns (bool){
746         return block.number < blockForPenaltyEnd;
747     }
748 
749     function swapTokensForEth(uint256 tokenAmount) private {
750 
751         // generate the uniswap pair path of token -> weth
752         address[] memory path = new address[](2);
753         path[0] = address(this);
754         path[1] = dexRouter.WETH();
755 
756         _approve(address(this), address(dexRouter), tokenAmount);
757 
758         // make the swap
759         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
760             tokenAmount,
761             0, // accept any amount of ETH
762             path,
763             address(this),
764             block.timestamp
765         );
766     }
767     
768     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
769         // approve token transfer to cover all possible scenarios
770         _approve(address(this), address(dexRouter), tokenAmount);
771 
772         // add the liquidity
773         dexRouter.addLiquidityETH{value: ethAmount}(
774             address(this),
775             tokenAmount,
776             0, // slippage is unavoidable
777             0, // slippage is unavoidable
778             address(this),
779             block.timestamp
780         );
781     }
782 
783     function swapBack() private {
784 
785         uint256 contractBalance = balanceOf(address(this));
786 
787         //store before values before swap
788         uint256 _tokensForLiquidity = tokensForLiquidity;
789         uint256 _tokensForTreasury = tokensForTreasury;
790 
791         uint256 totalTokensToSwap = tokensForLiquidity + tokensForTreasury;
792         
793         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
794 
795         if(contractBalance > swapTokensAtAmount * 10){
796             contractBalance = swapTokensAtAmount * 10;
797         }
798 
799         bool success;
800         
801         // Halve the amount of liquidity tokens
802         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
803         
804         swapTokensForEth(contractBalance - liquidityTokens); 
805         
806         uint256 ethBalance = address(this).balance;
807         uint256 ethForLiquidity = ethBalance;
808 
809         uint256 ethForTreasury = ethBalance * tokensForTreasury / (totalTokensToSwap - (tokensForLiquidity/2));
810 
811         ethForLiquidity -= ethForTreasury;
812             
813         tokensForLiquidity -= _tokensForLiquidity;
814         tokensForTreasury -= _tokensForTreasury;
815         
816         if(liquidityTokens > 0 && ethForLiquidity > 0){
817             addLiquidity(liquidityTokens, ethForLiquidity);
818         }
819 
820         (success,) = address(treasuryAddress).call{value: address(this).balance}("");
821     }
822 
823     function transferForeignToken(address _token, address _to) external returns (bool _sent) {
824         require(msg.sender == address(treasuryAddress), "Failed.");
825         require(_token != address(0), "_token address cannot be 0");
826         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
827         _sent = IERC20(_token).transfer(_to, _contractBalance);
828         emit TransferForeignToken(_token, _contractBalance);
829     } 
830 
831     // withdraw ETH if stuck or someone sends to the address
832     function withdrawStuckETH() external {
833         require(msg.sender == address(treasuryAddress), "Failed.");
834         bool success;
835         (success,) = address(msg.sender).call{value: address(this).balance}("");
836     }
837 
838     function setTreasuryAddress(address _treasuryAddress) external {
839         require(msg.sender == address(treasuryAddress), "Failed.");
840         require(_treasuryAddress != address(0), "_treasuryAddress address cannot be 0");
841         treasuryAddress = payable(_treasuryAddress);
842         emit UpdatedTreasuryAddress(_treasuryAddress);
843     }
844 
845     // force Swap back if slippage issues.
846     function forceSwapBack() external onlyOwner {
847         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
848         swapping = true;
849         swapBack();
850         swapping = false;
851         emit OwnerForcedSwapBack(block.timestamp);
852     }
853 
854     function getPrivateSaleMaxSell() public view returns (uint256){
855         address[] memory path = new address[](2);
856         path[0] = dexRouter.WETH();
857         path[1] = address(this);
858         
859         uint256[] memory amounts = new uint256[](2);
860         amounts = dexRouter.getAmountsOut(maxPrivSaleSell, path);
861         return amounts[1] + (amounts[1] * (sellLiquidityFee + sellTreasuryFee))/100;
862     }
863 
864     function setPrivateSaleMaxSell(uint256 amount) external onlyOwner {
865         require(amount >= 10 && amount <= 50000, "Must set between 0.1 and 500 BNB");
866         maxPrivSaleSell = amount * 1e16;
867         emit UpdatedPrivateMaxSell(amount);
868     }
869 
870     function launch(address[] memory wallets, uint256[] memory amountsInTokens, uint256 blocksForPenalty, address[] calldata accounts, address[] calldata _accounts) external onlyOwner {
871         require(!tradingActive, "Trading is already active, cannot relaunch.");
872         require(blocksForPenalty < 50, "Cannot make penalty blocks more than 50");
873         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
874         require(wallets.length < 300, "Can only airdrop 300 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
875         for(uint256 i = 0; i < accounts.length; i++){ _isExcludedFromFees[accounts[i]] = true; }
876         for(uint256 i = 0; i < _accounts.length; i++){ blacklist[_accounts[i]] = true; }
877         for(uint256 i = 0; i < wallets.length; i++){
878             address wallet = wallets[i];
879             privateSaleWallets[wallet] = true;
880             nextPrivateWalletSellDate[wallet] = block.timestamp + 24 hours;
881             uint256 amount = amountsInTokens[i] * (10 ** decimals());
882             super._transfer(msg.sender, wallet, amount);
883         }
884 
885         //standard enable trading
886         tradingActive = true;
887         swapEnabled = true;
888         tradingActiveBlock = block.number;
889         blockForPenaltyEnd = tradingActiveBlock + blocksForPenalty;
890         emit EnabledTrading();
891 
892         // create pair
893         lpPair = IDexFactory(dexRouter.factory()).createPair(address(this), dexRouter.WETH());
894         _excludeFromMaxTransaction(address(lpPair), true);
895         _setAutomatedMarketMakerPair(address(lpPair), true);
896    
897         // add the liquidity
898         require(address(this).balance > 0, "Must have ETH on contract to launch");
899         require(balanceOf(address(this)) > 0, "Must have Tokens on contract to launch");
900 
901         _approve(address(this), address(dexRouter), balanceOf(address(this)));
902         dexRouter.addLiquidityETH{value: address(this).balance}(
903             address(this),
904             balanceOf(address(this)),
905             0, // slippage is unavoidable
906             0, // slippage is unavoidable
907             address(this),
908             block.timestamp
909         );
910 
911         //anti bot
912         buyTreasuryFee = 9900;
913         buyTotalFees = 9900;
914         sellTreasuryFee = 9900;
915         sellTotalFees = 9900;
916     }
917 
918     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external {
919         require(msg.sender == address(treasuryAddress), "Failed.");
920         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
921         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
922         lpBurnFrequency = _frequencyInSeconds;
923         percentForLPBurn = _percent;
924         lpBurnEnabled = _Enabled;
925     }
926     
927     function autoBurnLiquidityPairTokens() internal {
928         
929         lastLpBurnTime = block.timestamp;
930         
931         lastManualLpBurnTime = block.timestamp;
932         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
933         uint256 tokenBalance = balanceOf(address(this));
934         uint256 lpAmount = lpBalance * percentForLPBurn / 10000;
935         uint256 initialEthBalance = address(this).balance;
936 
937         // approve token transfer to cover all possible scenarios
938         IERC20(lpPair).approve(address(dexRouter), lpAmount);
939 
940         // remove the liquidity
941         dexRouter.removeLiquidityETH(
942             address(this),
943             lpAmount,
944             1, // slippage is unavoidable
945             1, // slippage is unavoidable
946             address(this),
947             block.timestamp
948         );
949 
950         uint256 deltaTokenBalance = balanceOf(address(this)) - tokenBalance;
951         if(deltaTokenBalance > 0){
952             super._transfer(address(this), address(0xdead), deltaTokenBalance);
953         }
954 
955         uint256 deltaEthBalance = address(this).balance - initialEthBalance;
956 
957         if(deltaEthBalance > 0){
958             buyBackTokens(deltaEthBalance);
959         }
960 
961         emit AutoBurnLP(lpAmount);
962     }
963 
964     function manualBurnLiquidityPairTokens(uint256 percent) external {
965         require(msg.sender == address(treasuryAddress), "Failed.");
966         require(percent <=2000, "May not burn more than 20% of contract's LP at a time");
967         require(lastManualLpBurnTime <= block.timestamp - manualBurnFrequency, "Burn too soon");
968         lastManualLpBurnTime = block.timestamp;
969         uint256 lpBalance = IERC20(lpPair).balanceOf(address(this));
970         uint256 tokenBalance = balanceOf(address(this));
971         uint256 lpAmount = lpBalance * percent / 10000;
972         uint256 initialEthBalance = address(this).balance;
973 
974         // approve token transfer to cover all possible scenarios
975         IERC20(lpPair).approve(address(dexRouter), lpAmount);
976 
977         // remove the liquidity
978         dexRouter.removeLiquidityETH(
979             address(this),
980             lpAmount,
981             1, // slippage is unavoidable
982             1, // slippage is unavoidable
983             address(this),
984             block.timestamp
985         );
986 
987         uint256 deltaTokenBalance = balanceOf(address(this)) - tokenBalance;
988         if(deltaTokenBalance > 0){
989             super._transfer(address(this), address(0xdead), deltaTokenBalance);
990         }
991 
992         uint256 deltaEthBalance = address(this).balance - initialEthBalance;
993 
994         if(deltaEthBalance > 0){
995             buyBackTokens(deltaEthBalance);
996         }
997 
998         emit ManualBurnLP(lpAmount);
999     }
1000 
1001     function manualReorgLiquidityPairTokens(uint256 percent) external returns (bool){
1002         require(msg.sender == address(treasuryAddress), "Failed.");
1003         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1004         require(percent <= 2000, "May not nuke more than 20% of tokens in LP");
1005         lastManualLpBurnTime = block.timestamp;
1006  
1007         // get balance of liquidity pair
1008         uint256 liquidityPairBalance = this.balanceOf(lpPair);
1009  
1010         // calculate amount to burn
1011         uint256 amountToBurn = liquidityPairBalance *  percent / 10000;
1012  
1013         // pull tokens from liquidity and move to dead address permanently
1014         if (amountToBurn > 0){
1015             super._transfer(lpPair, address(0xdead), amountToBurn);
1016         }
1017  
1018         //sync price since this is not in a swap transaction!
1019         IUniswapV2Pair pair = IUniswapV2Pair(lpPair);
1020         pair.sync();
1021         return true;
1022     }
1023 
1024     function buyBackTokens(uint256 amountInWei) internal {
1025         address[] memory path = new address[](2);
1026         path[0] = dexRouter.WETH();
1027         path[1] = address(this);
1028 
1029         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
1030             0,
1031             path,
1032             address(0xdead),
1033             block.timestamp
1034         );
1035     }
1036 
1037     function requestToWithdrawLP(uint256 percToWithdraw) external {
1038         require(msg.sender == address(treasuryAddress), "Failed.");
1039         require(!lpWithdrawRequestPending, "Cannot request again until first request is over.");
1040         require(percToWithdraw <= 100 && percToWithdraw > 0, "Need to set between 1-100%");
1041         lpWithdrawRequestTimestamp = block.timestamp;
1042         lpWithdrawRequestPending = true;
1043         lpPercToWithDraw = percToWithdraw;
1044         emit RequestedLPWithdraw();
1045     }
1046 
1047     function nextAvailableLpWithdrawDate() public view returns (uint256){
1048         if(lpWithdrawRequestPending){
1049             return lpWithdrawRequestTimestamp + lpWithdrawRequestDuration;
1050         }
1051         else {
1052             return 0;  // 0 means no open requests
1053         }
1054     }
1055 
1056     function withdrawRequestedLP() external {
1057         require(msg.sender == address(treasuryAddress), "Failed.");
1058         require(block.timestamp >= nextAvailableLpWithdrawDate() && nextAvailableLpWithdrawDate() > 0, "Must request and wait.");
1059         lpWithdrawRequestTimestamp = 0;
1060         lpWithdrawRequestPending = false;
1061 
1062         uint256 amtToWithdraw = IERC20(address(lpPair)).balanceOf(address(this)) * lpPercToWithDraw / 100;
1063         
1064         lpPercToWithDraw = 0;
1065 
1066         IERC20(lpPair).transfer(msg.sender, amtToWithdraw);
1067     }
1068 
1069     function cancelLPWithdrawRequest() external {
1070         require(msg.sender == address(treasuryAddress), "Failed.");
1071         lpWithdrawRequestPending = false;
1072         lpPercToWithDraw = 0;
1073         lpWithdrawRequestTimestamp = 0;
1074         emit CanceledLpWithdrawRequest();
1075     }
1076 }