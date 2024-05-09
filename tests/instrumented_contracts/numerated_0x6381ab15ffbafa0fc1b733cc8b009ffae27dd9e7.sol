1 /**
2         https://t.me/billyercofficial
3 
4         https://twitter.com/ERCBILLY
5 
6         */
7 
8         // SPDX-License-Identifier: MIT
9 
10         pragma solidity 0.8.15;
11 
12         abstract contract Context {
13             function _msgSender() internal view virtual returns (address) {
14                 return msg.sender;
15             }
16 
17             function _msgData() internal view virtual returns (bytes calldata) {
18                 this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19                 return msg.data;
20             }
21         }
22 
23         interface IERC20 {
24 
25             function totalSupply() external view returns (uint256);
26             function balanceOf(address account) external view returns (uint256);
27             function transfer(address recipient, uint256 amount) external returns (bool);
28             function allowance(address owner, address spender) external view returns (uint256);
29             function approve(address spender, uint256 amount) external returns (bool);
30             function transferFrom(
31                 address sender,
32                 address recipient,
33                 uint256 amount
34             ) external returns (bool);
35 
36             event Transfer(address indexed from, address indexed to, uint256 value);
37         
38             event Approval(address indexed owner, address indexed spender, uint256 value);
39         }
40 
41         interface IERC20Metadata is IERC20 {
42             
43             function name() external view returns (string memory);
44             function symbol() external view returns (string memory);
45             function decimals() external view returns (uint8);
46         }
47 
48         contract ERC20 is Context, IERC20, IERC20Metadata {
49             mapping(address => uint256) private _balances;
50             mapping(address => mapping(address => uint256)) private _allowances;
51 
52             uint256 private _totalSupply;
53             string private _name;
54             string private _symbol;
55 
56             constructor(string memory name_, string memory symbol_) {
57                 _name = name_;
58                 _symbol = symbol_;
59             }
60 
61             function name() public view virtual override returns (string memory) {
62                 return _name;
63             }
64 
65             function symbol() public view virtual override returns (string memory) {
66                 return _symbol;
67             }
68 
69             function decimals() public view virtual override returns (uint8) {
70                 return 18;
71             }
72 
73             function totalSupply() public view virtual override returns (uint256) {
74                 return _totalSupply;
75             }
76 
77             function balanceOf(address account) public view virtual override returns (uint256) {
78                 return _balances[account];
79             }
80 
81             function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
82                 _transfer(_msgSender(), recipient, amount);
83                 return true;
84             }
85 
86             function allowance(address owner, address spender) public view virtual override returns (uint256) {
87                 return _allowances[owner][spender];
88             }
89 
90             function approve(address spender, uint256 amount) public virtual override returns (bool) {
91                 _approve(_msgSender(), spender, amount);
92                 return true;
93             }
94 
95             function transferFrom(
96                 address sender,
97                 address recipient,
98                 uint256 amount
99             ) public virtual override returns (bool) {
100                 _transfer(sender, recipient, amount);
101 
102                 uint256 currentAllowance = _allowances[sender][_msgSender()];
103                 require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
104                 unchecked {
105                     _approve(sender, _msgSender(), currentAllowance - amount);
106                 }
107 
108                 return true;
109             }
110 
111             function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
112                 _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
113                 return true;
114             }
115 
116             function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
117                 uint256 currentAllowance = _allowances[_msgSender()][spender];
118                 require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
119                 unchecked {
120                     _approve(_msgSender(), spender, currentAllowance - subtractedValue);
121                 }
122 
123                 return true;
124             }
125 
126             function _transfer(
127                 address sender,
128                 address recipient,
129                 uint256 amount
130             ) internal virtual {
131                 require(sender != address(0), "ERC20: transfer from the zero address");
132                 require(recipient != address(0), "ERC20: transfer to the zero address");
133 
134                 uint256 senderBalance = _balances[sender];
135                 require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
136                 unchecked {
137                     _balances[sender] = senderBalance - amount;
138                 }
139                 _balances[recipient] += amount;
140 
141                 emit Transfer(sender, recipient, amount);
142             }
143 
144             function _createInitialSupply(address account, uint256 amount) internal virtual {
145                 require(account != address(0), "ERC20: mint to the zero address");
146 
147                 _totalSupply += amount;
148                 _balances[account] += amount;
149                 emit Transfer(address(0), account, amount);
150             }
151 
152             function _burn(address account, uint256 amount) internal virtual {
153                 require(account != address(0), "ERC20: burn from the zero address");
154                 uint256 accountBalance = _balances[account];
155                 require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
156                 unchecked {
157                     _balances[account] = accountBalance - amount;
158                     // Overflow not possible: amount <= accountBalance <= totalSupply.
159                     _totalSupply -= amount;
160                 }
161 
162                 emit Transfer(account, address(0), amount);
163             }
164 
165             function _approve(
166                 address owner,
167                 address spender,
168                 uint256 amount
169             ) internal virtual {
170                 require(owner != address(0), "ERC20: approve from the zero address");
171                 require(spender != address(0), "ERC20: approve to the zero address");
172 
173                 _allowances[owner][spender] = amount;
174                 emit Approval(owner, spender, amount);
175             }
176         }
177 
178         contract Ownable is Context {
179             address private _owner;
180 
181             event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
182 
183             constructor () {
184                 address msgSender = _msgSender();
185                 _owner = msgSender;
186                 emit OwnershipTransferred(address(0), msgSender);
187             }
188 
189             function owner() public view returns (address) {
190                 return _owner;
191             }
192 
193             modifier onlyOwner() {
194                 require(_owner == _msgSender(), "Ownable: caller is not the owner");
195                 _;
196             }
197 
198             function renounceOwnership() external virtual onlyOwner {
199                 emit OwnershipTransferred(_owner, address(0));
200                 _owner = address(0);
201             }
202 
203             function transferOwnership(address newOwner) public virtual onlyOwner {
204                 require(newOwner != address(0), "Ownable: new owner is the zero address");
205                 emit OwnershipTransferred(_owner, newOwner);
206                 _owner = newOwner;
207             }
208         }
209 
210         interface IDexRouter {
211             function factory() external pure returns (address);
212             function WETH() external pure returns (address);
213 
214             function swapExactTokensForETHSupportingFeeOnTransferTokens(
215                 uint amountIn,
216                 uint amountOutMin,
217                 address[] calldata path,
218                 address to,
219                 uint deadline
220             ) external;
221 
222             function swapExactETHForTokensSupportingFeeOnTransferTokens(
223                 uint amountOutMin,
224                 address[] calldata path,
225                 address to,
226                 uint deadline
227             ) external payable;
228 
229             function addLiquidityETH(
230                 address token,
231                 uint256 amountTokenDesired,
232                 uint256 amountTokenMin,
233                 uint256 amountETHMin,
234                 address to,
235                 uint256 deadline
236             )
237                 external
238                 payable
239                 returns (
240                     uint256 amountToken,
241                     uint256 amountETH,
242                     uint256 liquidity
243                 );
244         }
245 
246         interface IDexFactory {
247             function createPair(address tokenA, address tokenB)
248                 external
249                 returns (address pair);
250         }
251 
252         contract Billy is ERC20, Ownable {
253 
254             uint256 public maxBuyAmount;
255             uint256 public maxSellAmount;
256             uint256 public maxWalletAmount;
257 
258             IDexRouter public dexRouter;
259             address public lpPair;
260 
261             bool private swapping;
262             uint256 public swapTokensAtAmount;
263 
264             address operationsAddress;
265             address devAddress;
266 
267             uint256 public tradingActiveBlock = 0; // 0 means trading is not active
268             uint256 public blockForPenaltyEnd;
269             mapping (address => bool) public boughtEarly;
270             uint256 public botsCaught;
271 
272             bool public limitsInEffect = true;
273             bool public tradingActive = false;
274             bool public swapEnabled = false;
275 
276             // Anti-bot and anti-whale mappings and variables
277             mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
278             bool public transferDelayEnabled = true;
279 
280             uint256 public buyTotalFees;
281             uint256 public buyOperationsFee;
282             uint256 public buyLiquidityFee;
283             uint256 public buyDevFee;
284             uint256 public buyBurnFee;
285 
286             uint256 public sellTotalFees;
287             uint256 public sellOperationsFee;
288             uint256 public sellLiquidityFee;
289             uint256 public sellDevFee;
290             uint256 public sellBurnFee;
291 
292             uint256 public tokensForOperations;
293             uint256 public tokensForLiquidity;
294             uint256 public tokensForDev;
295             uint256 public tokensForBurn;
296 
297             /******************/
298 
299             // exlcude from fees and max transaction amount
300             mapping (address => bool) private _isExcludedFromFees;
301             mapping (address => bool) public _isExcludedMaxTransactionAmount;
302 
303             // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
304             // could be subject to a maximum transfer amount
305             mapping (address => bool) public automatedMarketMakerPairs;
306 
307             event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
308 
309             event EnabledTrading();
310 
311             event RemovedLimits();
312 
313             event ExcludeFromFees(address indexed account, bool isExcluded);
314 
315             event UpdatedMaxBuyAmount(uint256 newAmount);
316 
317             event UpdatedMaxSellAmount(uint256 newAmount);
318 
319             event UpdatedMaxWalletAmount(uint256 newAmount);
320 
321             event UpdatedOperationsAddress(address indexed newWallet);
322 
323             event MaxTransactionExclusion(address _address, bool excluded);
324 
325             event BuyBackTriggered(uint256 amount);
326 
327             event OwnerForcedSwapBack(uint256 timestamp);
328 
329             event CaughtEarlyBuyer(address sniper);
330 
331             event SwapAndLiquify(
332                 uint256 tokensSwapped,
333                 uint256 ethReceived,
334                 uint256 tokensIntoLiquidity
335             );
336 
337             event TransferForeignToken(address token, uint256 amount);
338 
339             constructor() ERC20("Billy", "Billy") {
340 
341                 address newOwner = msg.sender; // can leave alone if owner is deployer.
342 
343                 IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
344                 dexRouter = _dexRouter;
345 
346                 // create pair
347                 lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
348                 _excludeFromMaxTransaction(address(lpPair), true);
349                 _setAutomatedMarketMakerPair(address(lpPair), true);
350 
351                 uint256 totalSupply = 1 * 1e12 * 1e18;
352 
353                 maxBuyAmount = totalSupply * 1 / 100;
354                 maxSellAmount = totalSupply * 1 / 100;
355                 maxWalletAmount = totalSupply * 2 / 100;
356                 swapTokensAtAmount = totalSupply * 5 / 10000;
357 
358                 buyOperationsFee = 50;
359                 buyLiquidityFee = 0;
360                 buyDevFee = 20;
361                 buyBurnFee = 0;
362                 buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
363 
364                 sellOperationsFee = 30;
365                 sellLiquidityFee = 0;
366                 sellDevFee = 10;
367                 sellBurnFee = 0;
368                 sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
369 
370                 _excludeFromMaxTransaction(newOwner, true);
371                 _excludeFromMaxTransaction(address(this), true);
372                 _excludeFromMaxTransaction(address(0xdead), true);
373 
374                 excludeFromFees(newOwner, true);
375                 excludeFromFees(address(this), true);
376                 excludeFromFees(address(0xdead), true);
377 
378                 operationsAddress = address(newOwner);
379                 devAddress = address(newOwner);
380 
381                 _createInitialSupply(newOwner, totalSupply);
382                 transferOwnership(newOwner);
383             }
384 
385             receive() external payable {}
386 
387             // only enable if no plan to airdrop
388 
389             function enableTrading(uint256 deadBlocks) external onlyOwner {
390                 require(!tradingActive, "Cannot reenable trading");
391                 tradingActive = true;
392                 swapEnabled = true;
393                 tradingActiveBlock = block.number;
394                 blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
395                 emit EnabledTrading();
396             }
397 
398             // remove limits after token is stable
399             function removeLimits() external onlyOwner {
400                 limitsInEffect = false;
401                 transferDelayEnabled = false;
402                 emit RemovedLimits();
403             }
404 
405             function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
406                 boughtEarly[wallet] = flag;
407             }
408 
409             function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
410                 for(uint256 i = 0; i < wallets.length; i++){
411                     boughtEarly[wallets[i]] = flag;
412                 }
413             }
414 
415             // disable Transfer delay - cannot be reenabled
416             function disableTransferDelay() external onlyOwner {
417                 transferDelayEnabled = false;
418             }
419 
420             function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
421                 require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
422                 maxBuyAmount = newNum * (10**18);
423                 emit UpdatedMaxBuyAmount(maxBuyAmount);
424             }
425 
426             function updateMaxSellAmount(uint256 newNum) external onlyOwner {
427                 require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
428                 maxSellAmount = newNum * (10**18);
429                 emit UpdatedMaxSellAmount(maxSellAmount);
430             }
431 
432             function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
433                 require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
434                 maxWalletAmount = newNum * (10**18);
435                 emit UpdatedMaxWalletAmount(maxWalletAmount);
436             }
437 
438             // change the minimum amount of tokens to sell from fees
439             function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
440                 require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
441                 require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
442                 swapTokensAtAmount = newAmount;
443             }
444 
445             function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
446                 _isExcludedMaxTransactionAmount[updAds] = isExcluded;
447                 emit MaxTransactionExclusion(updAds, isExcluded);
448             }
449 
450             function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
451                 require(wallets.length == amountsInTokens.length, "arrays must be the same length");
452                 require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
453                 for(uint256 i = 0; i < wallets.length; i++){
454                     address wallet = wallets[i];
455                     uint256 amount = amountsInTokens[i];
456                     super._transfer(msg.sender, wallet, amount);
457                 }
458             }
459 
460             function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
461                 if(!isEx){
462                     require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
463                 }
464                 _isExcludedMaxTransactionAmount[updAds] = isEx;
465             }
466 
467             function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
468                 require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
469 
470                 _setAutomatedMarketMakerPair(pair, value);
471                 emit SetAutomatedMarketMakerPair(pair, value);
472             }
473 
474             function _setAutomatedMarketMakerPair(address pair, bool value) private {
475                 automatedMarketMakerPairs[pair] = value;
476 
477                 _excludeFromMaxTransaction(pair, value);
478 
479                 emit SetAutomatedMarketMakerPair(pair, value);
480             }
481 
482             function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
483                 buyOperationsFee = _operationsFee;
484                 buyLiquidityFee = _liquidityFee;
485                 buyDevFee = _DevFee;
486                 buyBurnFee = _burnFee;
487                 buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
488                 require(buyTotalFees <= 40, "Must keep fees at 40% or less");
489             }
490 
491             function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _DevFee, uint256 _burnFee) external onlyOwner {
492                 sellOperationsFee = _operationsFee;
493                 sellLiquidityFee = _liquidityFee;
494                 sellDevFee = _DevFee;
495                 sellBurnFee = _burnFee;
496                 sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
497                 require(sellTotalFees <= 40, "Must keep fees at 40% or less");
498             }
499 
500             function returnToNormalTax() external onlyOwner {
501                 sellOperationsFee = 20;
502                 sellLiquidityFee = 0;
503                 sellDevFee = 0;
504                 sellBurnFee = 0;
505                 sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
506                 require(sellTotalFees <= 30, "Must keep fees at 30% or less");
507 
508                 buyOperationsFee = 20;
509                 buyLiquidityFee = 0;
510                 buyDevFee = 0;
511                 buyBurnFee = 0;
512                 buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
513                 require(buyTotalFees <= 15, "Must keep fees at 15% or less");
514             }
515 
516             function excludeFromFees(address account, bool excluded) public onlyOwner {
517                 _isExcludedFromFees[account] = excluded;
518                 emit ExcludeFromFees(account, excluded);
519             }
520 
521             function _transfer(address from, address to, uint256 amount) internal override {
522 
523                 require(from != address(0), "ERC20: transfer from the zero address");
524                 require(to != address(0), "ERC20: transfer to the zero address");
525                 require(amount > 0, "amount must be greater than 0");
526 
527                 if(!tradingActive){
528                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
529                 }
530 
531                 if(blockForPenaltyEnd > 0){
532                     require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
533                 }
534 
535                 if(limitsInEffect){
536                     if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
537 
538                         // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
539                         if (transferDelayEnabled){
540                             if (to != address(dexRouter) && to != address(lpPair)){
541                                 require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
542                                 _holderLastTransferTimestamp[tx.origin] = block.number;
543                                 _holderLastTransferTimestamp[to] = block.number;
544                             }
545                         }
546 
547                         //when buy
548                         if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
549                                 require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
550                                 require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
551                         }
552                         //when sell
553                         else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
554                                 require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
555                         }
556                         else if (!_isExcludedMaxTransactionAmount[to]){
557                             require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
558                         }
559                     }
560                 }
561 
562                 uint256 contractTokenBalance = balanceOf(address(this));
563 
564                 bool canSwap = contractTokenBalance >= swapTokensAtAmount;
565 
566                 if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
567                     swapping = true;
568 
569                     swapBack();
570 
571                     swapping = false;
572                 }
573 
574                 bool takeFee = true;
575                 // if any account belongs to _isExcludedFromFee account then remove the fee
576                 if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
577                     takeFee = false;
578                 }
579 
580                 uint256 fees = 0;
581                 // only take fees on buys/sells, do not take on wallet transfers
582                 if(takeFee){
583                     // bot/sniper penalty.
584                     if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
585 
586                         if(!boughtEarly[to]){
587                             boughtEarly[to] = true;
588                             botsCaught += 1;
589                             emit CaughtEarlyBuyer(to);
590                         }
591 
592                         fees = amount * 99 / 100;
593                         tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
594                         tokensForOperations += fees * buyOperationsFee / buyTotalFees;
595                         tokensForDev += fees * buyDevFee / buyTotalFees;
596                         tokensForBurn += fees * buyBurnFee / buyTotalFees;
597                     }
598 
599                     // on sell
600                     else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
601                         fees = amount * sellTotalFees / 100;
602                         tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
603                         tokensForOperations += fees * sellOperationsFee / sellTotalFees;
604                         tokensForDev += fees * sellDevFee / sellTotalFees;
605                         tokensForBurn += fees * sellBurnFee / sellTotalFees;
606                     }
607 
608                     // on buy
609                     else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
610                         fees = amount * buyTotalFees / 100;
611                         tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
612                         tokensForOperations += fees * buyOperationsFee / buyTotalFees;
613                         tokensForDev += fees * buyDevFee / buyTotalFees;
614                         tokensForBurn += fees * buyBurnFee / buyTotalFees;
615                     }
616 
617                     if(fees > 0){
618                         super._transfer(from, address(this), fees);
619                     }
620 
621                     amount -= fees;
622                 }
623 
624                 super._transfer(from, to, amount);
625             }
626 
627             function earlyBuyPenaltyInEffect() public view returns (bool){
628                 return block.number < blockForPenaltyEnd;
629             }
630 
631             function swapTokensForEth(uint256 tokenAmount) private {
632 
633                 // generate the uniswap pair path of token -> weth
634                 address[] memory path = new address[](2);
635                 path[0] = address(this);
636                 path[1] = dexRouter.WETH();
637 
638                 _approve(address(this), address(dexRouter), tokenAmount);
639 
640                 // make the swap
641                 dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
642                     tokenAmount,
643                     0, // accept any amount of ETH
644                     path,
645                     address(this),
646                     block.timestamp
647                 );
648             }
649 
650             function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
651                 // approve token transfer to cover all possible scenarios
652                 _approve(address(this), address(dexRouter), tokenAmount);
653 
654                 // add the liquidity
655                 dexRouter.addLiquidityETH{value: ethAmount}(
656                     address(this),
657                     tokenAmount,
658                     0, // slippage is unavoidable
659                     0, // slippage is unavoidable
660                     address(0xdead),
661                     block.timestamp
662                 );
663             }
664 
665             function swapBack() private {
666 
667                 if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
668                     _burn(address(this), tokensForBurn);
669                 }
670                 tokensForBurn = 0;
671 
672                 uint256 contractBalance = balanceOf(address(this));
673                 uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
674 
675                 if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
676 
677                 if(contractBalance > swapTokensAtAmount * 20){
678                     contractBalance = swapTokensAtAmount * 20;
679                 }
680 
681                 bool success;
682 
683                 // Halve the amount of liquidity tokens
684                 uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
685 
686                 swapTokensForEth(contractBalance - liquidityTokens);
687 
688                 uint256 ethBalance = address(this).balance;
689                 uint256 ethForLiquidity = ethBalance;
690 
691                 uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
692                 uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
693 
694                 ethForLiquidity -= ethForOperations + ethForDev;
695 
696                 tokensForLiquidity = 0;
697                 tokensForOperations = 0;
698                 tokensForDev = 0;
699                 tokensForBurn = 0;
700 
701                 if(liquidityTokens > 0 && ethForLiquidity > 0){
702                     addLiquidity(liquidityTokens, ethForLiquidity);
703                 }
704 
705                 (success,) = address(devAddress).call{value: ethForDev}("");
706 
707                 (success,) = address(operationsAddress).call{value: address(this).balance}("");
708             }
709 
710             function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
711                 require(_token != address(0), "_token address cannot be 0");
712                 require(_token != address(this), "Can't withdraw native tokens");
713                 uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
714                 _sent = IERC20(_token).transfer(_to, _contractBalance);
715                 emit TransferForeignToken(_token, _contractBalance);
716             }
717 
718             // withdraw ETH if stuck or someone sends to the address
719             function withdrawStuckETH() external onlyOwner {
720                 bool success;
721                 (success,) = address(msg.sender).call{value: address(this).balance}("");
722             }
723 
724             function setOperationsAddress(address _operationsAddress) external onlyOwner {
725                 require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
726                 operationsAddress = payable(_operationsAddress);
727             }
728 
729             function setDevAddress(address _devAddress) external onlyOwner {
730                 require(_devAddress != address(0), "_devAddress address cannot be 0");
731                 devAddress = payable(_devAddress);
732             }
733 
734             // force Swap back if slippage issues.
735             function forceSwapBack() external onlyOwner {
736                 require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
737                 swapping = true;
738                 swapBack();
739                 swapping = false;
740                 emit OwnerForcedSwapBack(block.timestamp);
741             }
742 
743             // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
744             function buyBackTokens(uint256 amountInWei) external onlyOwner {
745                 require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
746 
747                 address[] memory path = new address[](2);
748                 path[0] = dexRouter.WETH();
749                 path[1] = address(this);
750 
751                 // make the swap
752                 dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
753                     0, // accept any amount of Ethereum
754                     path,
755                     address(0xdead),
756                     block.timestamp
757                 );
758                 emit BuyBackTriggered(amountInWei);
759             }
760         }