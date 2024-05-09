1 /* 
2 
3 Dinosaur Inu ($DNA)
4 
5 Twitter: https://twitter.com/DinosaurInu
6 
7 Website: https://dinosaurinu.com
8 
9 TG: https://t.me/DinosaurInuPortal
10 
11 2% Max Transation
12 
13 2% Operation Fee
14 1% Added to Liquidity
15 2% Marketing
16 
17 */
18 
19 // SPDX-License-Identifier: Unlicense                                                                           
20 pragma solidity 0.8.11;
21 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         this;
29         return msg.data;
30     }
31 }
32 
33 interface IERC20 {
34 
35     function totalSupply() external view returns (uint256);
36 
37     function balanceOf(address account) external view returns (uint256);
38 
39     function transfer(address recipient, uint256 amount) external returns (bool);
40 
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     function approve(address spender, uint256 amount) external returns (bool);
44 
45     function transferFrom(
46         address sender,
47         address recipient,
48         uint256 amount
49     ) external returns (bool);
50 
51     event Transfer(address indexed from, address indexed to, uint256 value);
52 
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 interface IERC20Metadata is IERC20 {
57   
58     function name() external view returns (string memory);
59 
60     function symbol() external view returns (string memory);
61 
62     function decimals() external view returns (uint8);
63 }
64 
65 contract ERC20 is Context, IERC20, IERC20Metadata {
66     mapping(address => uint256) private _balances;
67 
68     mapping(address => mapping(address => uint256)) private _allowances;
69 
70     uint256 private _totalSupply;
71 
72     string private _name;
73     string private _symbol;
74 
75     constructor(string memory name_, string memory symbol_) {
76         _name = name_;
77         _symbol = symbol_;
78     }
79 
80     function name() public view virtual override returns (string memory) {
81         return _name;
82     }
83 
84     function symbol() public view virtual override returns (string memory) {
85         return _symbol;
86     }
87 
88     function decimals() public view virtual override returns (uint8) {
89         return 18;
90     }
91 
92     function totalSupply() public view virtual override returns (uint256) {
93         return _totalSupply;
94     }
95 
96     function balanceOf(address account) public view virtual override returns (uint256) {
97         return _balances[account];
98     }
99 
100     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
101         _transfer(_msgSender(), recipient, amount);
102         return true;
103     }
104 
105     function allowance(address owner, address spender) public view virtual override returns (uint256) {
106         return _allowances[owner][spender];
107     }
108 
109     function approve(address spender, uint256 amount) public virtual override returns (bool) {
110         _approve(_msgSender(), spender, amount);
111         return true;
112     }
113 
114     function transferFrom(
115         address sender,
116         address recipient,
117         uint256 amount
118     ) public virtual override returns (bool) {
119         _transfer(sender, recipient, amount);
120 
121         uint256 currentAllowance = _allowances[sender][_msgSender()];
122         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
123         unchecked {
124             _approve(sender, _msgSender(), currentAllowance - amount);
125         }
126 
127         return true;
128     }
129 
130     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
131         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
132         return true;
133     }
134 
135     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
136         uint256 currentAllowance = _allowances[_msgSender()][spender];
137         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
138         unchecked {
139             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
140         }
141 
142         return true;
143     }
144 
145     function _transfer(
146         address sender,
147         address recipient,
148         uint256 amount
149     ) internal virtual {
150         require(sender != address(0), "ERC20: transfer from the zero address");
151         require(recipient != address(0), "ERC20: transfer to the zero address");
152 
153         uint256 senderBalance = _balances[sender];
154         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
155         unchecked {
156             _balances[sender] = senderBalance - amount;
157         }
158         _balances[recipient] += amount;
159 
160         emit Transfer(sender, recipient, amount);
161     }
162 
163     function _createInitialSupply(address account, uint256 amount) internal virtual {
164         require(account != address(0), "ERC20: mint to the zero address");
165 
166         _totalSupply += amount;
167         _balances[account] += amount;
168         emit Transfer(address(0), account, amount);
169     }
170 
171     function _approve(
172         address owner,
173         address spender,
174         uint256 amount
175     ) internal virtual {
176         require(owner != address(0), "ERC20: approve from the zero address");
177         require(spender != address(0), "ERC20: approve to the zero address");
178 
179         _allowances[owner][spender] = amount;
180         emit Approval(owner, spender, amount);
181     }
182 }
183 
184 contract Ownable is Context {
185     address private _owner;
186 
187     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
188     
189     constructor () {
190         address msgSender = _msgSender();
191         _owner = msgSender;
192         emit OwnershipTransferred(address(0), msgSender);
193     }
194 
195     function owner() public view returns (address) {
196         return _owner;
197     }
198 
199     modifier onlyOwner() {
200         require(_owner == _msgSender(), "Ownable: caller is not the owner");
201         _;
202     }
203 
204     function renounceOwnership() external virtual onlyOwner {
205         emit OwnershipTransferred(_owner, address(0));
206         _owner = address(0);
207     }
208 
209     function transferOwnership(address newOwner) public virtual onlyOwner {
210         require(newOwner != address(0), "Ownable: new owner is the zero address");
211         emit OwnershipTransferred(_owner, newOwner);
212         _owner = newOwner;
213     }
214 }
215 
216 interface IDexRouter {
217     function factory() external pure returns (address);
218     function WETH() external pure returns (address);
219     
220     function swapExactTokensForETHSupportingFeeOnTransferTokens(
221         uint amountIn,
222         uint amountOutMin,
223         address[] calldata path,
224         address to,
225         uint deadline
226     ) external;
227 
228     function addLiquidityETH(
229         address token,
230         uint256 amountTokenDesired,
231         uint256 amountTokenMin,
232         uint256 amountETHMin,
233         address to,
234         uint256 deadline
235     )
236         external
237         payable
238         returns (
239             uint256 amountToken,
240             uint256 amountETH,
241             uint256 liquidity
242         );
243 }
244 
245 interface IDexFactory {
246     function createPair(address tokenA, address tokenB)
247         external
248         returns (address pair);
249 }
250 
251 contract DinosaurInu is ERC20, Ownable {
252 
253     uint256 public maxBuyAmount;
254     uint256 public maxSellAmount;
255     uint256 public maxWalletAmount;
256 
257     IDexRouter public immutable uniswapV2Router;
258     address public immutable uniswapV2Pair;
259 
260     bool private swapping;
261     uint256 public swapTokensAtAmount;
262 
263     address public operationsAddress;
264     address public TaxAddress;
265 
266     uint256 public tradingActiveBlock = 0;
267 
268     bool public limitsInEffect = true;
269     bool public tradingActive = false;
270     bool public swapEnabled = false;
271     
272     mapping(address => uint256) private _holderLastTransferTimestamp; 
273     bool public transferDelayEnabled = true;
274 
275     uint256 public buyTotalFees;
276     uint256 public buyOperationsFee;
277     uint256 public buyLiquidityFee;
278     uint256 public buyTaxFee;
279 
280     uint256 public sellTotalFees;
281     uint256 public sellOperationsFee;
282     uint256 public sellLiquidityFee;
283     uint256 public sellTaxFee;
284 
285     uint256 public tokensForOperations;
286     uint256 public tokensForLiquidity;
287     uint256 public tokensForTax;
288     
289     mapping (address => bool) private _isExcludedFromFees;
290     mapping (address => bool) public _isExcludedMaxTransactionAmount;
291 
292     mapping (address => bool) public automatedMarketMakerPairs;
293 
294     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
295 
296     event EnabledTrading();
297     event RemovedLimits();
298 
299     event ExcludeFromFees(address indexed account, bool isExcluded);
300 
301     event UpdatedMaxBuyAmount(uint256 newAmount);
302 
303     event UpdatedMaxSellAmount(uint256 newAmount);
304 
305     event UpdatedMaxWalletAmount(uint256 newAmount);
306 
307     event UpdatedOperationsAddress(address indexed newWallet);
308 
309     event UpdatedTaxAddress(address indexed newWallet);
310 
311     event MaxTransactionExclusion(address _address, bool excluded);
312 
313     event SwapAndLiquify(
314         uint256 tokensSwapped,
315         uint256 ethReceived,
316         uint256 tokensIntoLiquidity
317     );
318 
319     event TransferForeignToken(address token, uint256 amount);
320 
321     constructor() ERC20( "Dinosaur Inu", "DNA") {
322         
323         address newOwner = msg.sender;
324         
325         IDexRouter _uniswapV2Router = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
326 
327         _excludeFromMaxTransaction(address(_uniswapV2Router), true);
328         uniswapV2Router = _uniswapV2Router;
329         
330         uniswapV2Pair = IDexFactory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
331         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
332  
333         uint256 totalSupply = 1 * 1e9 * 1e18;
334         
335         maxBuyAmount = totalSupply * 20 / 1000; 
336         maxSellAmount = totalSupply * 20 / 1000; 
337         maxWalletAmount = totalSupply * 20 / 1000;
338         swapTokensAtAmount = totalSupply * 25 / 100000; 
339 
340         buyOperationsFee = 2;
341         buyLiquidityFee = 1;
342         buyTaxFee = 2;
343         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTaxFee;
344 
345         sellOperationsFee = 2;
346         sellLiquidityFee = 1;
347         sellTaxFee = 2;
348         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTaxFee;
349 
350         _excludeFromMaxTransaction(newOwner, true);
351         _excludeFromMaxTransaction(address(this), true);
352         _excludeFromMaxTransaction(address(0xdead), true);
353 
354         excludeFromFees(newOwner, true);
355         excludeFromFees(address(this), true);
356         excludeFromFees(address(0xdead), true);
357 
358         operationsAddress = address(0x4d3614F5Bd67993A8ABed92B3716bF2B47157873);   
359         TaxAddress = address(0x2D0f30A61DF8aa62E72dAa622dd5b02460ceE86b); 
360         
361         _createInitialSupply(newOwner, totalSupply);
362         transferOwnership(newOwner);
363     }
364 
365     receive() external payable {}
366 
367     function enableTrading() external onlyOwner {
368         require(!tradingActive, "Cannot reenable trading");
369         tradingActive = true;
370         swapEnabled = true;
371         tradingActiveBlock = block.number;
372         emit EnabledTrading();
373     }
374     
375     function removeLimits() external onlyOwner {
376         limitsInEffect = false;
377         transferDelayEnabled = false;
378         emit RemovedLimits();
379     }
380     
381     function disableTransferDelay() external onlyOwner {
382         transferDelayEnabled = false;
383     }
384     
385     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
386         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max buy amount lower than 0.1%");
387         maxBuyAmount = newNum * (10**18);
388         emit UpdatedMaxBuyAmount(maxBuyAmount);
389     }
390     
391     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
392         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max sell amount lower than 0.1%");
393         maxSellAmount = newNum * (10**18);
394         emit UpdatedMaxSellAmount(maxSellAmount);
395     }
396 
397     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
398         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
399         maxWalletAmount = newNum * (10**18);
400         emit UpdatedMaxWalletAmount(maxWalletAmount);
401     }
402 
403     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
404         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
405         require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
406         swapTokensAtAmount = newAmount;
407     }
408     
409     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
410         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
411         emit MaxTransactionExclusion(updAds, isExcluded);
412     }
413 
414     
415     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
416         if(!isEx){
417             require(updAds != uniswapV2Pair, "Cannot remove uniswap pair from max txn");
418         }
419         _isExcludedMaxTransactionAmount[updAds] = isEx;
420     }
421 
422     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
423         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
424 
425         _setAutomatedMarketMakerPair(pair, value);
426     }
427 
428     function _setAutomatedMarketMakerPair(address pair, bool value) private {
429         automatedMarketMakerPairs[pair] = value;
430         
431         _excludeFromMaxTransaction(pair, value);
432 
433         emit SetAutomatedMarketMakerPair(pair, value);
434     }
435 
436     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _TaxFee) external onlyOwner {
437         buyOperationsFee = _operationsFee;
438         buyLiquidityFee = _liquidityFee;
439         buyTaxFee = _TaxFee;
440         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyTaxFee;
441         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
442     }
443 
444     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _TaxFee) external onlyOwner {
445         sellOperationsFee = _operationsFee;
446         sellLiquidityFee = _liquidityFee;
447         sellTaxFee = _TaxFee;
448         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellTaxFee;
449         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
450     }
451 
452     function excludeFromFees(address account, bool excluded) public onlyOwner {
453         _isExcludedFromFees[account] = excluded;
454         emit ExcludeFromFees(account, excluded);
455     }
456 
457     function _transfer(address from, address to, uint256 amount) internal override {
458 
459         require(from != address(0), "ERC20: transfer from the zero address");
460         require(to != address(0), "ERC20: transfer to the zero address");
461         require(amount > 0, "amount must be greater than 0");
462         
463         
464         if(limitsInEffect){
465             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead)){
466                 if(!tradingActive){
467                     require(_isExcludedMaxTransactionAmount[from] || _isExcludedMaxTransactionAmount[to], "Trading is not active.");
468                 }
469                 
470                  if (transferDelayEnabled){
471                     if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
472                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 4 && _holderLastTransferTimestamp[to] < block.number - 4, "_transfer:: Transfer Delay enabled.  Try again later.");
473                         _holderLastTransferTimestamp[tx.origin] = block.number;
474                         _holderLastTransferTimestamp[to] = block.number;
475                     }
476                 }
477                  
478                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
479                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
480                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
481                 } 
482 
483                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
484                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
485                 } 
486                 else if (!_isExcludedMaxTransactionAmount[to] && !_isExcludedMaxTransactionAmount[from]){
487                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
488                 }
489             }
490         }
491 
492         uint256 contractTokenBalance = balanceOf(address(this));
493         
494         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
495 
496         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
497             swapping = true;
498 
499             swapBack();
500 
501             swapping = false;
502         }
503 
504         bool takeFee = true;
505 
506         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
507             takeFee = false;
508         }
509         
510         uint256 fees = 0;
511         uint256 penaltyAmount = 0;
512     
513         if(takeFee){
514 
515             if(tradingActiveBlock >= block.number + 1 && automatedMarketMakerPairs[from]){
516                 penaltyAmount = amount * 99 / 100;
517                 super._transfer(from, operationsAddress, penaltyAmount);
518             }
519         
520             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
521                 fees = amount * sellTotalFees /100;
522                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
523                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
524                 tokensForTax += fees * sellTaxFee / sellTotalFees;
525             }
526           
527             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
528                 fees = amount * buyTotalFees / 100;
529                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
530                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
531                 tokensForTax += fees * buyTaxFee / buyTotalFees;
532             }
533             
534             if(fees > 0){    
535                 super._transfer(from, address(this), fees);
536             }
537             
538             amount -= fees + penaltyAmount;
539         }
540 
541         super._transfer(from, to, amount);
542     }
543 
544     function swapTokensForEth(uint256 tokenAmount) private {
545 
546         address[] memory path = new address[](2);
547         path[0] = address(this);
548         path[1] = uniswapV2Router.WETH();
549 
550         _approve(address(this), address(uniswapV2Router), tokenAmount);
551 
552         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
553             tokenAmount,
554             0, 
555             path,
556             address(this),
557             block.timestamp
558         );
559     }
560     
561     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
562         
563         _approve(address(this), address(uniswapV2Router), tokenAmount);
564 
565         uniswapV2Router.addLiquidityETH{value: ethAmount}(
566             address(this),
567             tokenAmount,
568             0, 
569             0, 
570             address(0xdead),
571             block.timestamp
572         );
573     }
574 
575     function swapBack() private {
576         uint256 contractBalance = balanceOf(address(this));
577         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForTax;
578         
579         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
580 
581         if(contractBalance > swapTokensAtAmount * 10){
582             contractBalance = swapTokensAtAmount * 10;
583         }
584 
585         bool success;
586         
587         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
588         
589         swapTokensForEth(contractBalance - liquidityTokens); 
590         
591         uint256 ethBalance = address(this).balance;
592         uint256 ethForLiquidity = ethBalance;
593 
594         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
595         uint256 ethForTax = ethBalance * tokensForTax / (totalTokensToSwap - (tokensForLiquidity/2));
596 
597         ethForLiquidity -= ethForOperations + ethForTax;
598             
599         tokensForLiquidity = 0;
600         tokensForOperations = 0;
601         tokensForTax = 0;
602         
603         if(liquidityTokens > 0 && ethForLiquidity > 0){
604             addLiquidity(liquidityTokens, ethForLiquidity);
605         }
606 
607         (success,) = address(TaxAddress).call{value: ethForTax}("");
608 
609         (success,) = address(operationsAddress).call{value: address(this).balance}("");
610     }
611 
612     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
613         require(_token != address(0), "_token address cannot be 0");
614         require(_token != address(this), "Can't withdraw native tokens");
615         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
616         _sent = IERC20(_token).transfer(_to, _contractBalance);
617         emit TransferForeignToken(_token, _contractBalance);
618     }
619 
620     function withdrawStuckETH() external onlyOwner {
621         bool success;
622         (success,) = address(msg.sender).call{value: address(this).balance}("");
623     }
624 
625     function setOperationsAddress(address _operationsAddress) external onlyOwner {
626         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
627         operationsAddress = payable(_operationsAddress);
628         emit UpdatedOperationsAddress(_operationsAddress);
629     }
630 
631     function setTaxAddress(address _TaxAddress) external onlyOwner {
632         require(_TaxAddress != address(0), "_TaxAddress address cannot be 0");
633         TaxAddress = payable(_TaxAddress);
634         emit UpdatedTaxAddress(_TaxAddress);
635     }
636 }