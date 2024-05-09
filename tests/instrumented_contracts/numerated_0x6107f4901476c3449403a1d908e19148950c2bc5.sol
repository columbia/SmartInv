1 // SPDX-License-Identifier: MIT                                                                               
2                                                     
3 pragma solidity 0.8.11;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a {Transfer} event.
33      */
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     /**
37      * @dev Returns the remaining number of tokens that `spender` will be
38      * allowed to spend on behalf of `owner` through {transferFrom}. This is
39      * zero by default.
40      *
41      * This value changes when {approve} or {transferFrom} are called.
42      */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * IMPORTANT: Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an {Approval} event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transferFrom(
71         address sender,
72         address recipient,
73         uint256 amount
74     ) external returns (bool);
75 
76     /**
77      * @dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to {approve}. `value` is the new allowance.
87      */
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 interface IERC20Metadata is IERC20 {
92     /**
93      * @dev Returns the name of the token.
94      */
95     function name() external view returns (string memory);
96 
97     /**
98      * @dev Returns the symbol of the token.
99      */
100     function symbol() external view returns (string memory);
101 
102     /**
103      * @dev Returns the decimals places of the token.
104      */
105     function decimals() external view returns (uint8);
106 }
107 
108 contract ERC20 is Context, IERC20, IERC20Metadata {
109     mapping(address => uint256) private _balances;
110 
111     mapping(address => mapping(address => uint256)) private _allowances;
112 
113     uint256 private _totalSupply;
114 
115     string private _name;
116     string private _symbol;
117 
118     constructor(string memory name_, string memory symbol_) {
119         _name = name_;
120         _symbol = symbol_;
121     }
122 
123     function name() public view virtual override returns (string memory) {
124         return _name;
125     }
126 
127     function symbol() public view virtual override returns (string memory) {
128         return _symbol;
129     }
130 
131     function decimals() public view virtual override returns (uint8) {
132         return 18;
133     }
134 
135     function totalSupply() public view virtual override returns (uint256) {
136         return _totalSupply;
137     }
138 
139     function balanceOf(address account) public view virtual override returns (uint256) {
140         return _balances[account];
141     }
142 
143     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
144         _transfer(_msgSender(), recipient, amount);
145         return true;
146     }
147 
148     function allowance(address owner, address spender) public view virtual override returns (uint256) {
149         return _allowances[owner][spender];
150     }
151 
152     function approve(address spender, uint256 amount) public virtual override returns (bool) {
153         _approve(_msgSender(), spender, amount);
154         return true;
155     }
156 
157     function transferFrom(
158         address sender,
159         address recipient,
160         uint256 amount
161     ) public virtual override returns (bool) {
162         _transfer(sender, recipient, amount);
163 
164         uint256 currentAllowance = _allowances[sender][_msgSender()];
165         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
166         unchecked {
167             _approve(sender, _msgSender(), currentAllowance - amount);
168         }
169 
170         return true;
171     }
172 
173     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
174         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
175         return true;
176     }
177 
178     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
179         uint256 currentAllowance = _allowances[_msgSender()][spender];
180         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
181         unchecked {
182             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
183         }
184 
185         return true;
186     }
187 
188     function _transfer(
189         address sender,
190         address recipient,
191         uint256 amount
192     ) internal virtual {
193         require(sender != address(0), "ERC20: transfer from the zero address");
194         require(recipient != address(0), "ERC20: transfer to the zero address");
195 
196         uint256 senderBalance = _balances[sender];
197         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
198         unchecked {
199             _balances[sender] = senderBalance - amount;
200         }
201         _balances[recipient] += amount;
202 
203         emit Transfer(sender, recipient, amount);
204     }
205 
206     function _createInitialSupply(address account, uint256 amount) internal virtual {
207         require(account != address(0), "ERC20: mint to the zero address");
208 
209         _totalSupply += amount;
210         _balances[account] += amount;
211         emit Transfer(address(0), account, amount);
212     }
213 
214     function _approve(
215         address owner,
216         address spender,
217         uint256 amount
218     ) internal virtual {
219         require(owner != address(0), "ERC20: approve from the zero address");
220         require(spender != address(0), "ERC20: approve to the zero address");
221 
222         _allowances[owner][spender] = amount;
223         emit Approval(owner, spender, amount);
224     }
225 }
226 
227 contract Ownable is Context {
228     address private _owner;
229 
230     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
231     
232     constructor () {
233         address msgSender = _msgSender();
234         _owner = msgSender;
235         emit OwnershipTransferred(address(0), msgSender);
236     }
237 
238     function owner() public view returns (address) {
239         return _owner;
240     }
241 
242     modifier onlyOwner() {
243         require(_owner == _msgSender(), "Ownable: caller is not the owner");
244         _;
245     }
246 
247     function renounceOwnership() external virtual onlyOwner {
248         emit OwnershipTransferred(_owner, address(0));
249         _owner = address(0);
250     }
251 
252     function transferOwnership(address newOwner) public virtual onlyOwner {
253         require(newOwner != address(0), "Ownable: new owner is the zero address");
254         emit OwnershipTransferred(_owner, newOwner);
255         _owner = newOwner;
256     }
257 }
258 
259 interface IDexRouter {
260     function factory() external pure returns (address);
261     function WETH() external pure returns (address);
262     
263     function swapExactTokensForETHSupportingFeeOnTransferTokens(
264         uint amountIn,
265         uint amountOutMin,
266         address[] calldata path,
267         address to,
268         uint deadline
269     ) external;
270 
271     function addLiquidityETH(
272         address token,
273         uint256 amountTokenDesired,
274         uint256 amountTokenMin,
275         uint256 amountETHMin,
276         address to,
277         uint256 deadline
278     )
279         external
280         payable
281         returns (
282             uint256 amountToken,
283             uint256 amountETH,
284             uint256 liquidity
285         );
286 }
287 
288 interface IDexFactory {
289     function createPair(address tokenA, address tokenB)
290         external
291         returns (address pair);
292 }
293 
294 contract YASHA is ERC20, Ownable {
295 
296     IDexRouter public immutable uniswapV2Router;
297     address public immutable uniswapV2Pair;
298 
299     bool private swapping;
300     uint256 public swapTokensAtAmount;
301 
302     address public operationsAddress;
303 
304     bool public tradingActive = false;
305     bool public swapEnabled = false;
306 
307     uint256 public buyTotalFees;
308     uint256 public buyOperationsFee;
309     uint256 public buyLiquidityFee;
310 
311     uint256 public sellTotalFees;
312     uint256 public sellOperationsFee;
313     uint256 public sellLiquidityFee;
314 
315     uint256 public tokensForOperations;
316     uint256 public tokensForLiquidity;
317 
318     uint256 public lpWithdrawRequestTimestamp;
319     uint256 public lpWithdrawRequestDuration = 3 days;
320     bool public lpWithdrawRequestPending;
321     uint256 public lpPercToWithDraw;
322     
323     /******************/
324 
325     // exlcude from fees and max transaction amount
326     mapping (address => bool) private _isExcludedFromFees;
327 
328     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
329     // could be subject to a maximum transfer amount
330     mapping (address => bool) public automatedMarketMakerPairs;
331 
332     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
333 
334     event ExcludeFromFees(address indexed account, bool isExcluded);
335 
336     event UpdatedOperationsAddress(address indexed newWallet);
337 
338     event MaxTransactionExclusion(address _address, bool excluded);
339 
340     event RequestedLPWithdraw();
341     
342     event WithdrewLPForMigration();
343 
344     event EnabledTrading();
345 
346     event SwapAndLiquify(
347         uint256 tokensSwapped,
348         uint256 ethReceived,
349         uint256 tokensIntoLiquidity
350     );
351 
352     event TransferForeignToken(address token, uint256 amount);
353 
354     constructor() ERC20("YASHADAO", "YASHA") {
355         
356         address newOwner = msg.sender; // can leave alone if owner is deployer.
357         
358         IDexRouter _uniswapV2Router = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
359 
360         uniswapV2Router = _uniswapV2Router;
361         
362         uniswapV2Pair = IDexFactory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
363         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
364  
365         uint256 totalSupply = 100 * 1e9 * 1e18;
366         
367         swapTokensAtAmount = totalSupply * 25 / 100000; // 0.025% swap amount
368 
369         buyOperationsFee = 7;
370         buyLiquidityFee = 3;
371         buyTotalFees = buyOperationsFee + buyLiquidityFee;
372 
373         sellOperationsFee = 7;
374         sellLiquidityFee = 3;
375         sellTotalFees = sellOperationsFee + sellLiquidityFee;
376 
377         excludeFromFees(newOwner, true);
378         excludeFromFees(address(this), true);
379         excludeFromFees(address(0xdead), true);
380 
381         operationsAddress = address(newOwner);
382         
383         _createInitialSupply(newOwner, totalSupply);
384         transferOwnership(newOwner);
385     }
386 
387     receive() external payable {}
388 
389     // once enabled, can never be turned off
390     function enableTrading() external onlyOwner {
391         require(!tradingActive, "Cannot reenable trading");
392         tradingActive = true;
393         swapEnabled = true;
394         emit EnabledTrading();
395     }
396        
397     // change the minimum amount of tokens to sell from fees
398     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
399   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
400   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
401   	    swapTokensAtAmount = newAmount;
402   	}
403     
404     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
405         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
406         require(wallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
407         for(uint256 i = 0; i < wallets.length; i++){
408             address wallet = wallets[i];
409             uint256 amount = amountsInTokens[i]*1e18;
410             super._transfer(msg.sender, wallet, amount);
411         }
412     }
413     
414 
415 
416     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
417         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
418 
419         _setAutomatedMarketMakerPair(pair, value);
420     }
421 
422     function _setAutomatedMarketMakerPair(address pair, bool value) private {
423         automatedMarketMakerPairs[pair] = value;
424 
425         emit SetAutomatedMarketMakerPair(pair, value);
426     }
427 
428     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
429         buyOperationsFee = _operationsFee;
430         buyLiquidityFee = _liquidityFee;
431         buyTotalFees = buyOperationsFee + buyLiquidityFee;
432         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
433     }
434 
435     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee) external onlyOwner {
436         sellOperationsFee = _operationsFee;
437         sellLiquidityFee = _liquidityFee;
438         sellTotalFees = sellOperationsFee + sellLiquidityFee;
439         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
440     }
441 
442     function excludeFromFees(address account, bool excluded) public onlyOwner {
443         _isExcludedFromFees[account] = excluded;
444         emit ExcludeFromFees(account, excluded);
445     }
446 
447     function _transfer(address from, address to, uint256 amount) internal override {
448 
449         require(from != address(0), "ERC20: transfer from the zero address");
450         require(to != address(0), "ERC20: transfer to the zero address");
451         require(amount > 0, "amount must be greater than 0");
452         
453         if(!tradingActive){
454             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
455         }
456         
457         uint256 contractTokenBalance = balanceOf(address(this));
458         
459         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
460 
461         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
462             swapping = true;
463 
464             swapBack();
465 
466             swapping = false;
467         }
468 
469         bool takeFee = true;
470 
471         // if any account belongs to _isExcludedFromFee account then remove the fee
472         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
473             takeFee = false;
474         }
475         
476         uint256 fees = 0;
477         // only take fees on buys/sells, do not take on wallet transfers
478         if(takeFee){
479             // on sell
480             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
481                 fees = amount * sellTotalFees /100;
482                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
483                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
484             }
485             // on buy
486             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
487         	    fees = amount * buyTotalFees / 100;
488         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
489                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
490             }
491             
492             if(fees > 0){    
493                 super._transfer(from, address(this), fees);
494             }
495         	
496         	amount -= fees;
497         }
498 
499         super._transfer(from, to, amount);
500     }
501 
502     function swapTokensForEth(uint256 tokenAmount) private {
503 
504         // generate the uniswap pair path of token -> weth
505         address[] memory path = new address[](2);
506         path[0] = address(this);
507         path[1] = uniswapV2Router.WETH();
508 
509         _approve(address(this), address(uniswapV2Router), tokenAmount);
510 
511         // make the swap
512         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
513             tokenAmount,
514             0, // accept any amount of ETH
515             path,
516             address(this),
517             block.timestamp
518         );
519     }
520     
521     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
522         // approve token transfer to cover all possible scenarios
523         _approve(address(this), address(uniswapV2Router), tokenAmount);
524 
525         // add the liquidity
526         uniswapV2Router.addLiquidityETH{value: ethAmount}(
527             address(this),
528             tokenAmount,
529             0, // slippage is unavoidable
530             0, // slippage is unavoidable
531             address(0xdead),
532             block.timestamp
533         );
534     }
535 
536     function swapBack() private {
537         uint256 contractBalance = balanceOf(address(this));
538         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations;
539         
540         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
541 
542         if(contractBalance > swapTokensAtAmount * 10){
543             contractBalance = swapTokensAtAmount * 10;
544         }
545 
546         bool success;
547         
548         // Halve the amount of liquidity tokens
549         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
550         
551         swapTokensForEth(contractBalance - liquidityTokens); 
552         
553         uint256 ethBalance = address(this).balance;
554         uint256 ethForLiquidity = ethBalance;
555 
556         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
557 
558         ethForLiquidity -= ethForOperations;
559             
560         tokensForLiquidity = 0;
561         tokensForOperations = 0;
562         
563         if(liquidityTokens > 0 && ethForLiquidity > 0){
564             addLiquidity(liquidityTokens, ethForLiquidity);
565         }
566 
567         (success,) = address(operationsAddress).call{value: address(this).balance}("");
568     }
569 
570     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
571         require(_token != address(0), "_token address cannot be 0");
572         require(_token != address(this), "Can't withdraw native tokens");
573         require(_token != uniswapV2Pair, "Cannot withdraw LP tokens this way.  Use LP Withdraw.");
574         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
575         _sent = IERC20(_token).transfer(_to, _contractBalance);
576         emit TransferForeignToken(_token, _contractBalance);
577     }
578 
579     // withdraw ETH if stuck or someone sends to the address
580     function withdrawStuckETH() external onlyOwner {
581         bool success;
582         (success,) = address(msg.sender).call{value: address(this).balance}("");
583     }
584 
585     function setOperationsAddress(address _operationsAddress) external onlyOwner {
586         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
587         operationsAddress = payable(_operationsAddress);
588         emit UpdatedOperationsAddress(_operationsAddress);
589     }
590 
591     function requestToWithdrawLP(uint256 percToWithdraw) external onlyOwner {
592         require(!lpWithdrawRequestPending, "Cannot request again until first request is over.");
593         require(percToWithdraw <= 100 && percToWithdraw > 0, "Need to set between 1-100%");
594         lpWithdrawRequestTimestamp = block.timestamp;
595         lpWithdrawRequestPending = true;
596         lpPercToWithDraw = percToWithdraw;
597         emit RequestedLPWithdraw();
598     }
599 
600     function nextAvailableLpWithdrawDate() public view returns (uint256){
601         if(lpWithdrawRequestPending){
602             return lpWithdrawRequestTimestamp + lpWithdrawRequestDuration;
603         }
604         else {
605             return 0;  // 0 means no open requests
606         }
607     }
608 
609     function withdrawRequestedLP() external onlyOwner {
610         require(block.timestamp >= nextAvailableLpWithdrawDate() && nextAvailableLpWithdrawDate() > 0, "Must request and wait.");
611         lpWithdrawRequestTimestamp = 0;
612         lpWithdrawRequestPending = false;
613 
614         uint256 amtToWithdraw = IERC20(address(uniswapV2Pair)).balanceOf(address(this)) * lpPercToWithDraw / 100;
615         
616         lpPercToWithDraw = 0;
617 
618         IERC20(uniswapV2Pair).transfer(msg.sender, amtToWithdraw);
619     }
620 }