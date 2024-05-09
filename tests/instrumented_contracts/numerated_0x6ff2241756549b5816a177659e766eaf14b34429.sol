1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 /**
5  * OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6  */
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes calldata) {
13         return msg.data;
14     }
15 }
16 
17 /**
18  * OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
19  */
20 interface IERC20 {
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 
25     function totalSupply() external view returns (uint256);
26 
27     function balanceOf(address account) external view returns (uint256);
28 
29     function transfer(address to, uint256 amount) external returns (bool);
30 
31     function allowance(address owner, address spender) external view returns (uint256);
32 
33     function approve(address spender, uint256 amount) external returns (bool);
34 
35     function transferFrom(address from, address to, uint256 amount) external returns (bool);
36 }
37 
38 /**
39  * OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
40  * _Available since v4.1._
41  */
42 interface IERC20Metadata is IERC20 {
43     function name() external view returns (string memory);
44 
45     function symbol() external view returns (string memory);
46 
47     function decimals() external view returns (uint8);
48 }
49 
50 /**
51  * OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
52  */
53 contract ERC20 is Context, IERC20, IERC20Metadata {
54     mapping(address => uint256) private _balances;
55 
56     mapping(address => mapping(address => uint256)) private _allowances;
57 
58     uint256 private _totalSupply;
59 
60     string private _name;
61     string private _symbol;
62 
63     constructor(string memory name_, string memory symbol_) {
64         _name = name_;
65         _symbol = symbol_;
66     }
67 
68     function name() public view virtual override returns (string memory) {
69         return _name;
70     }
71 
72     function symbol() public view virtual override returns (string memory) {
73         return _symbol;
74     }
75 
76     function decimals() public view virtual override returns (uint8) {
77         return 18;
78     }
79 
80     function totalSupply() public view virtual override returns (uint256) {
81         return _totalSupply;
82     }
83 
84     function balanceOf(address account) public view virtual override returns (uint256) {
85         return _balances[account];
86     }
87 
88     function transfer(address to, uint256 amount) public virtual override returns (bool) {
89         address owner = _msgSender();
90         _transfer(owner, to, amount);
91         return true;
92     }
93 
94     function allowance(address owner, address spender) public view virtual override returns (uint256) {
95         return _allowances[owner][spender];
96     }
97 
98     function approve(address spender, uint256 amount) public virtual override returns (bool) {
99         address owner = _msgSender();
100         _approve(owner, spender, amount);
101         return true;
102     }
103 
104     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
105         address spender = _msgSender();
106         _spendAllowance(from, spender, amount);
107         _transfer(from, to, amount);
108         return true;
109     }
110 
111     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
112         address owner = _msgSender();
113         _approve(owner, spender, allowance(owner, spender) + addedValue);
114         return true;
115     }
116 
117     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
118         address owner = _msgSender();
119         uint256 currentAllowance = allowance(owner, spender);
120         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
121         unchecked {
122             _approve(owner, spender, currentAllowance - subtractedValue);
123         }
124 
125         return true;
126     }
127 
128     function _transfer(address from, address to, uint256 amount) internal virtual {
129         require(from != address(0), "ERC20: transfer from the zero address");
130         require(to != address(0), "ERC20: transfer to the zero address");
131 
132         _beforeTokenTransfer(from, to, amount);
133 
134         uint256 fromBalance = _balances[from];
135         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
136         unchecked {
137             _balances[from] = fromBalance - amount;
138             _balances[to] += amount;
139         }
140 
141         emit Transfer(from, to, amount);
142 
143         _afterTokenTransfer(from, to, amount);
144     }
145 
146     function _mint(address account, uint256 amount) internal virtual {
147         require(account != address(0), "ERC20: mint to the zero address");
148 
149         _beforeTokenTransfer(address(0), account, amount);
150 
151         _totalSupply += amount;
152         unchecked {
153             _balances[account] += amount;
154         }
155         emit Transfer(address(0), account, amount);
156 
157         _afterTokenTransfer(address(0), account, amount);
158     }
159 
160     function _burn(address account, uint256 amount) internal virtual {
161         require(account != address(0), "ERC20: burn from the zero address");
162 
163         _beforeTokenTransfer(account, address(0), amount);
164 
165         uint256 accountBalance = _balances[account];
166         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
167         unchecked {
168             _balances[account] = accountBalance - amount;
169             _totalSupply -= amount;
170         }
171 
172         emit Transfer(account, address(0), amount);
173 
174         _afterTokenTransfer(account, address(0), amount);
175     }
176 
177     function _approve(address owner, address spender, uint256 amount) internal virtual {
178         require(owner != address(0), "ERC20: approve from the zero address");
179         require(spender != address(0), "ERC20: approve to the zero address");
180 
181         _allowances[owner][spender] = amount;
182         emit Approval(owner, spender, amount);
183     }
184 
185     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
186         uint256 currentAllowance = allowance(owner, spender);
187         if (currentAllowance != type(uint256).max) {
188             require(currentAllowance >= amount, "ERC20: insufficient allowance");
189             unchecked {
190                 _approve(owner, spender, currentAllowance - amount);
191             }
192         }
193     }
194 
195     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
196 
197     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
198 }
199 
200 /**
201  * OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
202  */
203 abstract contract Ownable is Context {
204     address private _owner;
205 
206     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
207 
208     constructor() {
209         _transferOwnership(_msgSender());
210     }
211 
212     modifier onlyOwner() {
213         _checkOwner();
214         _;
215     }
216 
217     function owner() public view virtual returns (address) {
218         return _owner;
219     }
220 
221     function _checkOwner() internal view virtual {
222         require(owner() == _msgSender(), "Ownable: caller is not the owner");
223     }
224 
225     function renounceOwnership() public virtual onlyOwner {
226         _transferOwnership(address(0));
227     }
228 
229     function transferOwnership(address newOwner) public virtual onlyOwner {
230         require(newOwner != address(0), "Ownable: new owner is the zero address");
231         _transferOwnership(newOwner);
232     }
233 
234     function _transferOwnership(address newOwner) internal virtual {
235         address oldOwner = _owner;
236         _owner = newOwner;
237         emit OwnershipTransferred(oldOwner, newOwner);
238     }
239 }
240 
241 interface IDexRouter {
242     function factory() external pure returns (address);
243     function WETH() external pure returns (address);
244 
245     function swapExactTokensForETHSupportingFeeOnTransferTokens(
246         uint amountIn,
247         uint amountOutMin,
248         address[] calldata path,
249         address to,
250         uint deadline
251     ) external;
252 
253     function swapExactETHForTokensSupportingFeeOnTransferTokens(
254         uint amountOutMin,
255         address[] calldata path,
256         address to,
257         uint deadline
258     ) external payable;
259 
260     function addLiquidityETH(
261         address token,
262         uint256 amountTokenDesired,
263         uint256 amountTokenMin,
264         uint256 amountETHMin,
265         address to,
266         uint256 deadline
267     )
268         external
269         payable
270         returns (
271             uint256 amountToken,
272             uint256 amountETH,
273             uint256 liquidity
274         );
275 }
276 
277 interface IDexFactory {
278     function createPair(address tokenA, address tokenB)
279         external
280         returns (address pair);
281 }
282 
283 contract AqtisToken is ERC20, Ownable {
284 
285     uint256 public maxBuyAmount;
286     uint256 public maxSellAmount;
287     uint256 public maxWalletAmount;
288 
289     IDexRouter public dexRouter;
290     address public lpPair;
291 
292     bool private swapping;
293     uint256 public swapTokensAtAmount;
294 
295     address taxAddress;
296 
297     uint256 public tradingActiveBlock = 0;
298     uint256 public blockForPenaltyEnd;
299     mapping (address => bool) public boughtEarly;
300     uint256 public botsCaught;
301 
302     bool public limitsInEffect = true;
303     bool public tradingActive = false;
304     bool public swapEnabled = false;
305     bool public swapToEth = false;
306 
307     mapping(address => uint256) private _holderLastTransferTimestamp;
308     bool public transferDelayEnabled = true;
309 
310     uint256 public buyTotalFees;
311     uint256 public buyTaxFee;
312 
313     uint256 public sellTotalFees;
314     uint256 public sellTaxFee;
315 
316     uint256 public tokensForTax;
317 
318     mapping (address => bool) private _isExcludedFromFees;
319     mapping (address => bool) public _isExcludedMaxTransactionAmount;
320     mapping (address => bool) public automatedMarketMakerPairs;
321 
322     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
323 
324     event EnabledTrading();
325     
326     event RemovedLimits();
327     
328     event ExcludeFromFees(address indexed account, bool isExcluded);
329     
330     event UpdatedMaxBuyAmount(uint256 newAmount);
331     
332     event UpdatedMaxSellAmount(uint256 newAmount);
333     
334     event UpdatedMaxWalletAmount(uint256 newAmount);
335     
336     event MaxTransactionExclusion(address _address, bool excluded);
337     
338     event OwnerForcedSwapBack(uint256 timestamp);
339     
340     event CaughtEarlyBuyer(address sniper);
341 
342     event SwapAndLiquify(
343         uint256 tokensSwapped,
344         uint256 ethReceived,
345         uint256 tokensIntoLiquidity
346     );
347 
348     constructor() ERC20("AQTIS Token", "AQTIS") {
349         address contractOwner = msg.sender; 
350 
351         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
352         dexRouter = _dexRouter;
353 
354         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
355         _excludeFromMaxTransaction(address(lpPair), true);
356         _setAutomatedMarketMakerPair(address(lpPair), true);
357 
358         uint256 totalSupply = 3_000_000_000 * 1e18;
359 
360         maxBuyAmount = totalSupply * 15 / 1000;
361         maxSellAmount = totalSupply * 15 / 1000;
362         maxWalletAmount = totalSupply * 15 / 1000;
363         swapTokensAtAmount = totalSupply * 1 / 1000;
364 
365         buyTaxFee = 5;
366         buyTotalFees = buyTaxFee;
367 
368         sellTaxFee = 5;
369         sellTotalFees = sellTaxFee;
370 
371         taxAddress = payable(0x1eD086f9bdc70788EcdA67899AB8C922Ff7F305d);
372 
373         _excludeFromMaxTransaction(contractOwner, true);
374         _excludeFromMaxTransaction(address(this), true);
375         _excludeFromMaxTransaction(address(0xdead), true);
376         _excludeFromMaxTransaction(taxAddress, true);
377 
378         excludeFromFees(contractOwner, true);
379         excludeFromFees(address(this), true);
380         excludeFromFees(address(0xdead), true);
381         excludeFromFees(taxAddress, true);
382 
383         _mint(contractOwner, totalSupply);
384         transferOwnership(contractOwner);
385     }
386 
387     receive() external payable {}
388 
389     function enableTrading(uint256 deadBlocks) external onlyOwner {
390         require(!tradingActive, "Cannot reenable trading");
391         tradingActive = true;
392         swapEnabled = true;
393         tradingActiveBlock = block.number;
394         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
395         emit EnabledTrading();
396     }
397 
398     function removeLimits() external onlyOwner {
399         limitsInEffect = false;
400         transferDelayEnabled = false;
401         emit RemovedLimits();
402     }
403 
404     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
405         boughtEarly[wallet] = flag;
406     }
407 
408     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
409         for(uint256 i = 0; i < wallets.length; i++){
410             boughtEarly[wallets[i]] = flag;
411         }
412     }
413 
414     function disableTransferDelay() external onlyOwner {
415         transferDelayEnabled = false;
416     }
417 
418     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
419         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
420         maxBuyAmount = newNum * (10**18);
421         emit UpdatedMaxBuyAmount(maxBuyAmount);
422     }
423 
424     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
425         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
426         maxSellAmount = newNum * (10**18);
427         emit UpdatedMaxSellAmount(maxSellAmount);
428     }
429 
430     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
431         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
432         maxWalletAmount = newNum * (10**18);
433         emit UpdatedMaxWalletAmount(maxWalletAmount);
434     }
435 
436     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
437   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
438   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
439   	    swapTokensAtAmount = newAmount;
440   	}
441 
442     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
443         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
444         emit MaxTransactionExclusion(updAds, isExcluded);
445     }
446 
447     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
448         if(!isEx){
449             require(updAds != lpPair, "Cannot remove Uniswap pair from max txn");
450         }
451         _isExcludedMaxTransactionAmount[updAds] = isEx;
452     }
453 
454     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
455         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
456 
457         _setAutomatedMarketMakerPair(pair, value);
458         emit SetAutomatedMarketMakerPair(pair, value);
459     }
460 
461     function _setAutomatedMarketMakerPair(address pair, bool value) private {
462         automatedMarketMakerPairs[pair] = value;
463 
464         _excludeFromMaxTransaction(pair, value);
465         emit SetAutomatedMarketMakerPair(pair, value);
466     }
467 
468     function setSwapToEth(bool _swapToEth) public onlyOwner {
469         swapToEth = _swapToEth;
470     }
471 
472     function updateBuyFees(uint256 _taxFee) external onlyOwner {
473         buyTaxFee = _taxFee;
474         buyTotalFees = buyTaxFee;
475         require(buyTotalFees <= 10, "Must keep fees at 10% or less.");
476     }
477 
478     function updateSellFees(uint256 _taxFee) external onlyOwner {
479         sellTaxFee = _taxFee;
480         sellTotalFees = sellTaxFee;
481         require(sellTotalFees <= 10, "Must keep fees at 10% or less.");
482     }
483 
484     function excludeFromFees(address account, bool excluded) public onlyOwner {
485         _isExcludedFromFees[account] = excluded;
486         emit ExcludeFromFees(account, excluded);
487     }
488 
489     function _transfer(address from, address to, uint256 amount) internal override {
490 
491         require(from != address(0), "ERC20: transfer from the zero address");
492         require(to != address(0), "ERC20: transfer to the zero address");
493         require(amount > 0, "amount must be greater than 0");
494 
495         if(!tradingActive){
496             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
497         }
498 
499         if(blockForPenaltyEnd > 0){
500             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
501         }
502 
503         if(limitsInEffect){
504             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
505 
506                 if (transferDelayEnabled){
507                     if (to != address(dexRouter) && to != address(lpPair)){
508                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
509                         _holderLastTransferTimestamp[tx.origin] = block.number;
510                         _holderLastTransferTimestamp[to] = block.number;
511                     }
512                 }
513 
514                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
515                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
516                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot exceed max wallet.");
517                 }
518                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
519                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
520                 }
521                 else if (!_isExcludedMaxTransactionAmount[to]){
522                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot exceed max wallet.");
523                 }
524             }
525         }
526 
527         uint256 contractTokenBalance = balanceOf(address(this));
528 
529         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
530 
531         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
532             swapping = true;
533 
534             swapBack();
535 
536             swapping = false;
537         }
538 
539         bool takeFee = true;
540         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
541             takeFee = false;
542         }
543 
544         uint256 fees = 0;
545         if(takeFee){
546             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
547 
548                 if(!boughtEarly[to]){
549                     boughtEarly[to] = true;
550                     botsCaught += 1;
551                     emit CaughtEarlyBuyer(to);
552                 }
553 
554                 fees = amount * 99 / 100;
555                 tokensForTax += fees * buyTaxFee / buyTotalFees;
556             }
557 
558             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
559                 fees = amount * sellTotalFees / 100;
560                 tokensForTax += fees * sellTaxFee / sellTotalFees;
561             }
562 
563             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
564         	    fees = amount * buyTotalFees / 100;
565                 tokensForTax += fees * buyTaxFee / buyTotalFees;
566             }
567 
568             if(fees > 0){
569                 super._transfer(from, address(this), fees);
570             }
571 
572         	amount -= fees;
573         }
574 
575         super._transfer(from, to, amount);
576     }
577 
578     function earlyBuyPenaltyInEffect() public view returns (bool){
579         return block.number < blockForPenaltyEnd;
580     }
581 
582     function swapTokensForEth(uint256 tokenAmount) private {
583         address[] memory path = new address[](2);
584         path[0] = address(this);
585         path[1] = dexRouter.WETH();
586 
587         _approve(address(this), address(dexRouter), tokenAmount);
588 
589         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
590             tokenAmount,
591             0,
592             path,
593             address(this),
594             block.timestamp
595         );
596     }
597 
598     function swapBack() private {
599         uint256 contractBalance = balanceOf(address(this));
600         uint256 totalTokensToSwap =  tokensForTax;
601 
602         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
603 
604         if(contractBalance > swapTokensAtAmount * 20){
605             contractBalance = swapTokensAtAmount * 20;
606         }
607 
608         bool success;
609 
610         if (swapToEth) {
611             swapTokensForEth(contractBalance);
612             tokensForTax = 0;
613             (success,) = address(taxAddress).call{value: address(this).balance}("");
614         }
615 
616         if (!swapToEth) {
617             _transfer(address(this), taxAddress, contractBalance);
618             tokensForTax = 0;
619             success = true;
620         }
621     }
622 
623     // Withdraw ETH from contract address
624     function withdrawStuckETH() external onlyOwner {
625         bool success;
626         (success,) = address(msg.sender).call{value: address(this).balance}("");
627     }
628 
629     function updateTaxAddress(address _taxAddress) external onlyOwner {
630         require(_taxAddress != address(0), "_taxAddress address cannot be 0");
631         taxAddress = payable(_taxAddress);
632     }
633 
634     function forceSwapBack() external onlyOwner {
635         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
636         swapping = true;
637         swapBack();
638         swapping = false;
639         emit OwnerForcedSwapBack(block.timestamp);
640     }
641 }