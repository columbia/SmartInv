1 // SPDX-License-Identifier: MIT
2 
3 /*
4 
5 Presenting StudyBuddyAI, a LRNERC subsidiary
6 
7 A consortium of study tools powered by machine learning, designed with students in mind.
8 
9 Visit lrnerc.com for more info
10 
11 https://t.me/studybuddyai
12 
13 https://twitter.com/lrnerc
14 
15 
16 
17 */
18 
19 pragma solidity ^0.8.17;
20 
21 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 
33 interface IERC20 {
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 
38     function totalSupply() external view returns (uint256);
39 
40     function balanceOf(address account) external view returns (uint256);
41 
42     function transfer(address to, uint256 amount) external returns (bool);
43 
44     function allowance(address owner, address spender) external view returns (uint256);
45 
46     function approve(address spender, uint256 amount) external returns (bool);
47 
48     function transferFrom(address from, address to, uint256 amount) external returns (bool);
49 }
50 
51 
52 interface IERC20Metadata is IERC20 {
53     function name() external view returns (string memory);
54 
55     function symbol() external view returns (string memory);
56 
57     function decimals() external view returns (uint8);
58 }
59 
60 
61 contract ERC20 is Context, IERC20, IERC20Metadata {
62     mapping(address => uint256) private _balances;
63 
64     mapping(address => mapping(address => uint256)) private _allowances;
65 
66     uint256 private _totalSupply;
67 
68     string private _name;
69     string private _symbol;
70 
71     constructor(string memory name_, string memory symbol_) {
72         _name = name_;
73         _symbol = symbol_;
74     }
75 
76     function name() public view virtual override returns (string memory) {
77         return _name;
78     }
79 
80     function symbol() public view virtual override returns (string memory) {
81         return _symbol;
82     }
83 
84     function decimals() public view virtual override returns (uint8) {
85         return 18;
86     }
87 
88     function totalSupply() public view virtual override returns (uint256) {
89         return _totalSupply;
90     }
91 
92     function balanceOf(address account) public view virtual override returns (uint256) {
93         return _balances[account];
94     }
95 
96     function transfer(address to, uint256 amount) public virtual override returns (bool) {
97         address owner = _msgSender();
98         _transfer(owner, to, amount);
99         return true;
100     }
101 
102     function allowance(address owner, address spender) public view virtual override returns (uint256) {
103         return _allowances[owner][spender];
104     }
105 
106     function approve(address spender, uint256 amount) public virtual override returns (bool) {
107         address owner = _msgSender();
108         _approve(owner, spender, amount);
109         return true;
110     }
111 
112     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
113         address spender = _msgSender();
114         _spendAllowance(from, spender, amount);
115         _transfer(from, to, amount);
116         return true;
117     }
118 
119     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
120         address owner = _msgSender();
121         _approve(owner, spender, allowance(owner, spender) + addedValue);
122         return true;
123     }
124 
125     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
126         address owner = _msgSender();
127         uint256 currentAllowance = allowance(owner, spender);
128         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
129         unchecked {
130             _approve(owner, spender, currentAllowance - subtractedValue);
131         }
132 
133         return true;
134     }
135 
136     function _transfer(address from, address to, uint256 amount) internal virtual {
137         require(from != address(0), "ERC20: transfer from the zero address");
138         require(to != address(0), "ERC20: transfer to the zero address");
139 
140         _beforeTokenTransfer(from, to, amount);
141 
142         uint256 fromBalance = _balances[from];
143         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
144         unchecked {
145             _balances[from] = fromBalance - amount;
146             _balances[to] += amount;
147         }
148 
149         emit Transfer(from, to, amount);
150 
151         _afterTokenTransfer(from, to, amount);
152     }
153 
154     function _mint(address account, uint256 amount) internal virtual {
155         require(account != address(0), "ERC20: mint to the zero address");
156 
157         _beforeTokenTransfer(address(0), account, amount);
158 
159         _totalSupply += amount;
160         unchecked {
161             _balances[account] += amount;
162         }
163         emit Transfer(address(0), account, amount);
164 
165         _afterTokenTransfer(address(0), account, amount);
166     }
167 
168     function _burn(address account, uint256 amount) internal virtual {
169         require(account != address(0), "ERC20: burn from the zero address");
170 
171         _beforeTokenTransfer(account, address(0), amount);
172 
173         uint256 accountBalance = _balances[account];
174         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
175         unchecked {
176             _balances[account] = accountBalance - amount;
177             _totalSupply -= amount;
178         }
179 
180         emit Transfer(account, address(0), amount);
181 
182         _afterTokenTransfer(account, address(0), amount);
183     }
184 
185     function _approve(address owner, address spender, uint256 amount) internal virtual {
186         require(owner != address(0), "ERC20: approve from the zero address");
187         require(spender != address(0), "ERC20: approve to the zero address");
188 
189         _allowances[owner][spender] = amount;
190         emit Approval(owner, spender, amount);
191     }
192 
193     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
194         uint256 currentAllowance = allowance(owner, spender);
195         if (currentAllowance != type(uint256).max) {
196             require(currentAllowance >= amount, "ERC20: insufficient allowance");
197             unchecked {
198                 _approve(owner, spender, currentAllowance - amount);
199             }
200         }
201     }
202 
203     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
204 
205     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
206 }
207 
208 /**
209  * OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
210  */
211 abstract contract Ownable is Context {
212     address private _owner;
213 
214     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
215 
216     constructor() {
217         _transferOwnership(_msgSender());
218     }
219 
220     modifier onlyOwner() {
221         _checkOwner();
222         _;
223     }
224 
225     function owner() public view virtual returns (address) {
226         return _owner;
227     }
228 
229     function _checkOwner() internal view virtual {
230         require(owner() == _msgSender(), "Ownable: caller is not the owner");
231     }
232 
233     function renounceOwnership() public virtual onlyOwner {
234         _transferOwnership(address(0));
235     }
236 
237     function transferOwnership(address newOwner) public virtual onlyOwner {
238         require(newOwner != address(0), "Ownable: new owner is the zero address");
239         _transferOwnership(newOwner);
240     }
241 
242     function _transferOwnership(address newOwner) internal virtual {
243         address oldOwner = _owner;
244         _owner = newOwner;
245         emit OwnershipTransferred(oldOwner, newOwner);
246     }
247 }
248 
249 interface IDexRouter {
250     function factory() external pure returns (address);
251     function WETH() external pure returns (address);
252 
253     function swapExactTokensForETHSupportingFeeOnTransferTokens(
254         uint amountIn,
255         uint amountOutMin,
256         address[] calldata path,
257         address to,
258         uint deadline
259     ) external;
260 
261     function swapExactETHForTokensSupportingFeeOnTransferTokens(
262         uint amountOutMin,
263         address[] calldata path,
264         address to,
265         uint deadline
266     ) external payable;
267 
268     function addLiquidityETH(
269         address token,
270         uint256 amountTokenDesired,
271         uint256 amountTokenMin,
272         uint256 amountETHMin,
273         address to,
274         uint256 deadline
275     )
276         external
277         payable
278         returns (
279             uint256 amountToken,
280             uint256 amountETH,
281             uint256 liquidity
282         );
283 }
284 
285 interface IDexFactory {
286     function createPair(address tokenA, address tokenB)
287         external
288         returns (address pair);
289 }
290 
291 contract StudyBuddyAI is ERC20, Ownable {
292 
293     uint256 public maxBuyAmount;
294     uint256 public maxSellAmount;
295     uint256 public maxWalletAmount;
296 
297     IDexRouter public dexRouter;
298     address public lpPair;
299 
300     bool private swapping;
301     uint256 public swapTokensAtAmount;
302 
303     address taxAddress;
304 
305     uint256 public tradingActiveBlock = 0;
306     uint256 public blockForPenaltyEnd;
307     mapping (address => bool) public boughtEarly;
308     uint256 public botsCaught;
309 
310     bool public limitsInEffect = true;
311     bool public tradingActive = false;
312     bool public swapEnabled = false;
313     bool public swapToEth = false;
314 
315     mapping(address => uint256) private _holderLastTransferTimestamp;
316     bool public transferDelayEnabled = true;
317 
318     uint256 public buyTotalFees;
319     uint256 public buyTaxFee;
320 
321     uint256 public sellTotalFees;
322     uint256 public sellTaxFee;
323 
324     uint256 public tokensForTax;
325 
326     mapping (address => bool) private _isExcludedFromFees;
327     mapping (address => bool) public _isExcludedMaxTransactionAmount;
328     mapping (address => bool) public automatedMarketMakerPairs;
329 
330     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
331 
332     event EnabledTrading();
333     
334     event RemovedLimits();
335     
336     event ExcludeFromFees(address indexed account, bool isExcluded);
337     
338     event UpdatedMaxBuyAmount(uint256 newAmount);
339     
340     event UpdatedMaxSellAmount(uint256 newAmount);
341     
342     event UpdatedMaxWalletAmount(uint256 newAmount);
343     
344     event MaxTransactionExclusion(address _address, bool excluded);
345     
346     event OwnerForcedSwapBack(uint256 timestamp);
347     
348     event CaughtEarlyBuyer(address sniper);
349 
350     event SwapAndLiquify(
351         uint256 tokensSwapped,
352         uint256 ethReceived,
353         uint256 tokensIntoLiquidity
354     );
355 
356     constructor() ERC20("StudyBuddyAI", "LRN") {
357         address contractOwner = msg.sender; 
358 
359         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
360         dexRouter = _dexRouter;
361 
362         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
363         _excludeFromMaxTransaction(address(lpPair), true);
364         _setAutomatedMarketMakerPair(address(lpPair), true);
365 
366         uint256 totalSupply = 100_000_000 * 1e18;
367 
368         maxBuyAmount = totalSupply * 20 / 1000;
369         maxSellAmount = totalSupply * 20 / 1000;
370         maxWalletAmount = totalSupply * 15 / 1000;
371         swapTokensAtAmount = totalSupply * 1 / 1000;
372 
373         buyTaxFee = 25;
374         buyTotalFees = buyTaxFee;
375 
376         sellTaxFee = 45;
377         sellTotalFees = sellTaxFee;
378 
379         taxAddress = payable(0x42C039d74284654902fa3fbb14Ec92Be5AC117BD);
380 
381         _excludeFromMaxTransaction(contractOwner, true);
382         _excludeFromMaxTransaction(address(this), true);
383         _excludeFromMaxTransaction(address(0xdead), true);
384         _excludeFromMaxTransaction(taxAddress, true);
385 
386         excludeFromFees(contractOwner, true);
387         excludeFromFees(address(this), true);
388         excludeFromFees(address(0xdead), true);
389         excludeFromFees(taxAddress, true);
390 
391         _mint(contractOwner, totalSupply);
392         transferOwnership(contractOwner);
393     }
394 
395     receive() external payable {}
396 
397     function enableTrading(uint256 deadBlocks) external onlyOwner {
398         require(!tradingActive, "Cannot reenable trading");
399         tradingActive = true;
400         swapEnabled = true;
401         tradingActiveBlock = block.number;
402         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
403         emit EnabledTrading();
404     }
405 
406     function removeLimits() external onlyOwner {
407         limitsInEffect = false;
408         transferDelayEnabled = false;
409         emit RemovedLimits();
410     }
411 
412     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
413         boughtEarly[wallet] = flag;
414     }
415 
416     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
417         for(uint256 i = 0; i < wallets.length; i++){
418             boughtEarly[wallets[i]] = flag;
419         }
420     }
421 
422     function disableTransferDelay() external onlyOwner {
423         transferDelayEnabled = false;
424     }
425 
426     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
427         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
428         maxBuyAmount = newNum * (10**18);
429         emit UpdatedMaxBuyAmount(maxBuyAmount);
430     }
431 
432     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
433         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
434         maxSellAmount = newNum * (10**18);
435         emit UpdatedMaxSellAmount(maxSellAmount);
436     }
437 
438     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
439         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
440         maxWalletAmount = newNum * (10**18);
441         emit UpdatedMaxWalletAmount(maxWalletAmount);
442     }
443 
444     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
445   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
446   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
447   	    swapTokensAtAmount = newAmount;
448   	}
449 
450     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
451         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
452         emit MaxTransactionExclusion(updAds, isExcluded);
453     }
454 
455     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
456         if(!isEx){
457             require(updAds != lpPair, "Cannot remove Uniswap pair from max txn");
458         }
459         _isExcludedMaxTransactionAmount[updAds] = isEx;
460     }
461 
462     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
463         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
464 
465         _setAutomatedMarketMakerPair(pair, value);
466         emit SetAutomatedMarketMakerPair(pair, value);
467     }
468 
469     function _setAutomatedMarketMakerPair(address pair, bool value) private {
470         automatedMarketMakerPairs[pair] = value;
471 
472         _excludeFromMaxTransaction(pair, value);
473         emit SetAutomatedMarketMakerPair(pair, value);
474     }
475 
476     function setSwapToEth(bool _swapToEth) public onlyOwner {
477         swapToEth = _swapToEth;
478     }
479 
480     function updateBuyFees(uint256 _taxFee) external onlyOwner {
481         buyTaxFee = _taxFee;
482         buyTotalFees = buyTaxFee;
483         require(buyTotalFees <= 25, "Must keep fees at 25% or less.");
484     }
485 
486     function updateSellFees(uint256 _taxFee) external onlyOwner {
487         sellTaxFee = _taxFee;
488         sellTotalFees = sellTaxFee;
489         require(sellTotalFees <= 45, "Must keep fees at 45% or less.");
490     }
491 
492     function excludeFromFees(address account, bool excluded) public onlyOwner {
493         _isExcludedFromFees[account] = excluded;
494         emit ExcludeFromFees(account, excluded);
495     }
496 
497     function _transfer(address from, address to, uint256 amount) internal override {
498 
499         require(from != address(0), "ERC20: transfer from the zero address");
500         require(to != address(0), "ERC20: transfer to the zero address");
501         require(amount > 0, "amount must be greater than 0");
502 
503         if(!tradingActive){
504             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
505         }
506 
507         if(blockForPenaltyEnd > 0){
508             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
509         }
510 
511         if(limitsInEffect){
512             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
513 
514                 if (transferDelayEnabled){
515                     if (to != address(dexRouter) && to != address(lpPair)){
516                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
517                         _holderLastTransferTimestamp[tx.origin] = block.number;
518                         _holderLastTransferTimestamp[to] = block.number;
519                     }
520                 }
521 
522                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
523                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
524                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot exceed max wallet.");
525                 }
526                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
527                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
528                 }
529                 else if (!_isExcludedMaxTransactionAmount[to]){
530                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot exceed max wallet.");
531                 }
532             }
533         }
534 
535         uint256 contractTokenBalance = balanceOf(address(this));
536 
537         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
538 
539         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
540             swapping = true;
541 
542             swapBack();
543 
544             swapping = false;
545         }
546 
547         bool takeFee = true;
548         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
549             takeFee = false;
550         }
551 
552         uint256 fees = 0;
553         if(takeFee){
554             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
555 
556                 if(!boughtEarly[to]){
557                     boughtEarly[to] = true;
558                     botsCaught += 1;
559                     emit CaughtEarlyBuyer(to);
560                 }
561 
562                 fees = amount * 99 / 100;
563                 tokensForTax += fees * buyTaxFee / buyTotalFees;
564             }
565 
566             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
567                 fees = amount * sellTotalFees / 100;
568                 tokensForTax += fees * sellTaxFee / sellTotalFees;
569             }
570 
571             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
572         	    fees = amount * buyTotalFees / 100;
573                 tokensForTax += fees * buyTaxFee / buyTotalFees;
574             }
575 
576             if(fees > 0){
577                 super._transfer(from, address(this), fees);
578             }
579 
580         	amount -= fees;
581         }
582 
583         super._transfer(from, to, amount);
584     }
585 
586     function earlyBuyPenaltyInEffect() public view returns (bool){
587         return block.number < blockForPenaltyEnd;
588     }
589 
590     function swapTokensForEth(uint256 tokenAmount) private {
591         address[] memory path = new address[](2);
592         path[0] = address(this);
593         path[1] = dexRouter.WETH();
594 
595         _approve(address(this), address(dexRouter), tokenAmount);
596 
597         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
598             tokenAmount,
599             0,
600             path,
601             address(this),
602             block.timestamp
603         );
604     }
605 
606     function swapBack() private {
607         uint256 contractBalance = balanceOf(address(this));
608         uint256 totalTokensToSwap =  tokensForTax;
609 
610         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
611 
612         if(contractBalance > swapTokensAtAmount * 20){
613             contractBalance = swapTokensAtAmount * 20;
614         }
615 
616         bool success;
617 
618         if (swapToEth) {
619             swapTokensForEth(contractBalance);
620             tokensForTax = 0;
621             (success,) = address(taxAddress).call{value: address(this).balance}("");
622         }
623 
624         if (!swapToEth) {
625             _transfer(address(this), taxAddress, contractBalance);
626             tokensForTax = 0;
627             success = true;
628         }
629     }
630 
631     // Withdraw ETH from contract address
632     function withdrawStuckETH() external onlyOwner {
633         bool success;
634         (success,) = address(msg.sender).call{value: address(this).balance}("");
635     }
636 
637     function updateTaxAddress(address _taxAddress) external onlyOwner {
638         require(_taxAddress != address(0), "_taxAddress address cannot be 0");
639         taxAddress = payable(_taxAddress);
640     }
641 
642     function forceSwapBack() external onlyOwner {
643         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
644         swapping = true;
645         swapBack();
646         swapping = false;
647         emit OwnerForcedSwapBack(block.timestamp);
648     }
649 }