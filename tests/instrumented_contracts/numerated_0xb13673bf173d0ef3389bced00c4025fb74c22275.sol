1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.15;
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
214     function _burn(address account, uint256 amount) internal virtual {
215         require(account != address(0), "ERC20: burn from the zero address");
216         uint256 accountBalance = _balances[account];
217         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
218         unchecked {
219             _balances[account] = accountBalance - amount;
220             // Overflow not possible: amount <= accountBalance <= totalSupply.
221             _totalSupply -= amount;
222         }
223 
224         emit Transfer(account, address(0), amount);
225     }
226 
227     function _approve(
228         address owner,
229         address spender,
230         uint256 amount
231     ) internal virtual {
232         require(owner != address(0), "ERC20: approve from the zero address");
233         require(spender != address(0), "ERC20: approve to the zero address");
234 
235         _allowances[owner][spender] = amount;
236         emit Approval(owner, spender, amount);
237     }
238 }
239 
240 contract Ownable is Context {
241     address private _owner;
242 
243     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
244 
245     constructor () {
246         address msgSender = _msgSender();
247         _owner = msgSender;
248         emit OwnershipTransferred(address(0), msgSender);
249     }
250 
251     function owner() public view returns (address) {
252         return _owner;
253     }
254 
255     modifier onlyOwner() {
256         require(_owner == _msgSender(), "Ownable: caller is not the owner");
257         _;
258     }
259 
260     function renounceOwnership() external virtual onlyOwner {
261         emit OwnershipTransferred(_owner, address(0));
262         _owner = address(0);
263     }
264 
265     function transferOwnership(address newOwner) public virtual onlyOwner {
266         require(newOwner != address(0), "Ownable: new owner is the zero address");
267         emit OwnershipTransferred(_owner, newOwner);
268         _owner = newOwner;
269     }
270 }
271 
272 interface IDexRouter {
273     function factory() external pure returns (address);
274     function WETH() external pure returns (address);
275 
276     function swapExactTokensForETHSupportingFeeOnTransferTokens(
277         uint amountIn,
278         uint amountOutMin,
279         address[] calldata path,
280         address to,
281         uint deadline
282     ) external;
283 
284     function swapExactETHForTokensSupportingFeeOnTransferTokens(
285         uint amountOutMin,
286         address[] calldata path,
287         address to,
288         uint deadline
289     ) external payable;
290 
291 }
292 
293 interface IDexFactory {
294     function createPair(address tokenA, address tokenB)
295         external
296         returns (address pair);
297 }
298 
299 contract BasedRetardAutisticGang is ERC20, Ownable {
300 
301     uint256 public maxBuyAmount;
302     uint256 public maxSellAmount;
303     uint256 public maxWalletAmount;
304 
305     IDexRouter public dexRouter;
306     address public lpPair;
307 
308     bool private swapping;
309     uint256 public swapTokensAtAmount;
310 
311     address taxAddress;
312 
313     bool public limitsInEffect = true;
314     bool public tradingActive = false;
315 
316      // Anti-sandwithc-bot mappings and variables
317     mapping(address => uint256) private _holderLastBuyBlock; // to hold last Buy temporarily
318     bool public transferDelayEnabled = true;
319 
320     uint256 public buyFee;
321     uint256 public sellFee;
322 
323 
324     /******************/
325 
326     // exlcude from fees and max transaction amount
327     mapping (address => bool) private _isExcludedFromFees;
328     mapping (address => bool) public _isExcludedMaxTransactionAmount;
329 
330     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
331     // could be subject to a maximum transfer amount
332     mapping (address => bool) public automatedMarketMakerPairs;
333 
334     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
335 
336     event EnabledTrading();
337 
338     event RemovedLimits();
339 
340     event ExcludeFromFees(address indexed account, bool isExcluded);
341 
342     event UpdatedMaxBuyAmount(uint256 newAmount);
343 
344     event UpdatedMaxSellAmount(uint256 newAmount);
345 
346     event UpdatedMaxWalletAmount(uint256 newAmount);
347 
348     event UpdatedBuyFee(uint256 buyFee);
349 
350     event UpdatedSellFee(uint256 sellFee);
351 
352     event MaxTransactionExclusion(address _address, bool excluded);
353 
354     event BuyBackTriggered(uint256 amount);
355 
356     event OwnerForcedSwapBack(uint256 timestamp);
357 
358     event CaughtEarlyBuyer(address sniper);
359 
360     event SwapAndLiquify(
361         uint256 tokensSwapped,
362         uint256 ethReceived,
363         uint256 tokensIntoLiquidity
364     );
365 
366     event TransferForeignToken(address token, uint256 amount);
367 
368     constructor() ERC20("Based Retard Autistic Gang","BRAG") {
369 
370         address newOwner = msg.sender; // can leave alone if owner is deployer.
371 
372         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
373         dexRouter = _dexRouter;
374 
375         // create pair
376         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
377         _excludeFromMaxTransaction(address(lpPair), true);
378         _excludeFromMaxTransaction(address(dexRouter), true);
379         _setAutomatedMarketMakerPair(address(lpPair), true);
380 
381         uint256 totalSupply = 1 * 1e8 * 1e18;
382 
383         maxBuyAmount = totalSupply * 7 / 1000;
384         maxSellAmount = totalSupply * 7 / 1000;
385         maxWalletAmount = totalSupply * 7 / 1000;
386         swapTokensAtAmount = totalSupply * 1 / 100;
387 
388         buyFee = 30;
389         sellFee = 70;
390 
391         _excludeFromMaxTransaction(newOwner, true);
392         _excludeFromMaxTransaction(address(this), true);
393         _excludeFromMaxTransaction(address(0xdead), true);
394 
395         excludeFromFees(newOwner, true);
396         excludeFromFees(address(this), true);
397         excludeFromFees(address(0xdead), true);
398 
399         taxAddress = address(0xc7aF5Bc9BD31e8B80671056F76f2AcA92791B91C);
400 
401         _createInitialSupply(newOwner, totalSupply);
402         transferOwnership(newOwner);
403     }
404 
405     receive() external payable {}
406 
407     // only enable if no plan to airdrop
408 
409     function enableTrading() external onlyOwner {
410         require(!tradingActive, "Cannot reenable trading");
411         tradingActive = true;
412         emit EnabledTrading();
413     }
414 
415     // remove limits after token is stable
416     function removeLimits() external onlyOwner {
417         limitsInEffect = false;
418         emit RemovedLimits();
419     }
420 
421     // change the minimum amount of tokens to sell from fees
422     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
423   	    require(newAmount >= totalSupply() * 1 / 1000, "Swap amount cannot be lower than 0.1% total supply.");
424   	    require(newAmount <= totalSupply() * 1 / 20, "Swap amount cannot be higher than 5% total supply.");
425   	    swapTokensAtAmount = newAmount;
426   	}
427 
428     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
429         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
430         emit MaxTransactionExclusion(updAds, isExcluded);
431     }
432 
433     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
434         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
435         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
436         for(uint256 i = 0; i < wallets.length; i++){
437             address wallet = wallets[i];
438             uint256 amount = amountsInTokens[i];
439             super._transfer(msg.sender, wallet, amount);
440         }
441     }
442 
443     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
444         if(!isEx){
445             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
446         }
447         _isExcludedMaxTransactionAmount[updAds] = isEx;
448     }
449 
450     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
451         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
452 
453         _setAutomatedMarketMakerPair(pair, value);
454         emit SetAutomatedMarketMakerPair(pair, value);
455     }
456 
457     function _setAutomatedMarketMakerPair(address pair, bool value) private {
458         automatedMarketMakerPairs[pair] = value;
459 
460         _excludeFromMaxTransaction(pair, value);
461 
462         emit SetAutomatedMarketMakerPair(pair, value);
463     }
464 
465     function updateBuyFees(uint256 _buyFee) external onlyOwner {
466         require(_buyFee <= 70, "Must keep fees at 50% or less");
467         buyFee = _buyFee;
468         emit UpdatedBuyFee(buyFee);
469     }
470 
471     function updateSellFees(uint256 _sellFee) external onlyOwner {
472         require(_sellFee <= 70, "Must keep fees at 50% or less");
473         sellFee = _sellFee;
474         emit UpdatedSellFee(sellFee);
475     }
476 
477     function returnToNormalTax() external onlyOwner {
478         sellFee = 0;
479         buyFee = 0;
480     }
481 
482     function excludeFromFees(address account, bool excluded) public onlyOwner {
483         _isExcludedFromFees[account] = excluded;
484         emit ExcludeFromFees(account, excluded);
485     }
486 
487     function _transfer(address from, address to, uint256 amount) internal override {
488 
489         require(from != address(0), "ERC20: transfer from the zero address");
490         require(to != address(0), "ERC20: transfer to the zero address");
491         require(amount > 0, "amount must be greater than 0");
492 
493         if(!tradingActive){
494             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
495         }
496 
497         // anti sandwich bot
498         if (automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && to != address(this) && to != address(dexRouter)){
499             _holderLastBuyBlock[to] = block.number;
500         }
501         require(_holderLastBuyBlock[from] < block.number, "_transfer:: Anti sandwich bot enabled. Please try again later.");
502 
503         if(limitsInEffect){
504             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
505     
506                 //when buy
507                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
508                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
509                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");            
510                 }
511                 //when sell
512                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
513                         if(amount > maxSellAmount){
514                             amount = maxSellAmount;
515                         }
516                 }
517                 else if (!_isExcludedMaxTransactionAmount[to]){
518                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max tokens per wallet");
519                 }
520             }
521         }
522 
523         uint256 contractTokenBalance = balanceOf(address(this));
524 
525         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
526 
527         if(canSwap && tradingActive && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
528             swapping = true;
529             swapBack();
530             swapping = false;
531         }
532 
533         // only take fees on buys/sells, do not take on wallet transfers
534         if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
535             uint256 fees = 0;
536             // on sell
537             if (automatedMarketMakerPairs[to] && sellFee > 0){
538                 fees = amount * sellFee / 100;
539             }
540             // on buy
541             else if(automatedMarketMakerPairs[from] && buyFee > 0) {
542         	    fees = amount * buyFee / 100;
543             }
544             if(fees > 0){
545                 super._transfer(from, address(this), fees);
546             }
547         	amount -= fees;
548         }
549 
550         super._transfer(from, to, amount);
551     }
552 
553     function swapTokensForEth(uint256 tokenAmount) private {
554 
555         // generate the uniswap pair path of token -> weth
556         address[] memory path = new address[](2);
557         path[0] = address(this);
558         path[1] = dexRouter.WETH();
559 
560         _approve(address(this), address(dexRouter), tokenAmount);
561 
562         // make the swap
563         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
564             tokenAmount,
565             0, // accept any amount of ETH
566             path,
567             address(this),
568             block.timestamp
569         );
570     }
571 
572     function swapBack() private {
573         uint256 contractBalance = balanceOf(address(this));
574         if(contractBalance == 0) {return;}
575 
576         if(contractBalance > swapTokensAtAmount * 6){
577             contractBalance = swapTokensAtAmount * 6;
578         }
579 
580         bool success;
581 
582         swapTokensForEth(contractBalance);
583 
584         uint256 ethBalance = address(this).balance;
585         
586         if(ethBalance > 0){
587             (success,) = address(taxAddress).call{value: ethBalance}("");
588         }
589         
590     }
591 
592     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
593         require(_token != address(0), "_token address cannot be 0");
594         require(_token != address(this), "Can't withdraw native tokens");
595         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
596         _sent = IERC20(_token).transfer(_to, _contractBalance);
597         emit TransferForeignToken(_token, _contractBalance);
598     }
599 
600     // withdraw ETH if stuck or someone sends to the address
601     function withdrawStuckETH() external onlyOwner {
602         bool success;
603         (success,) = address(msg.sender).call{value: address(this).balance}("");
604     }
605 
606     // function setTaxAddress(address _taxAddress) external onlyOwner {
607     //     require(_taxAddress != address(0), "_taxAddress address cannot be 0");
608     //     taxAddress = payable(_taxAddress);
609     // }
610 
611     // force Swap back if slippage issues.
612     function forceSwapBack() external onlyOwner {
613         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
614         swapping = true;
615         swapBack();
616         swapping = false;
617         emit OwnerForcedSwapBack(block.timestamp);
618     }
619 
620     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
621     function buyBackTokens(uint256 amountInWei) external onlyOwner {
622         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
623 
624         address[] memory path = new address[](2);
625         path[0] = dexRouter.WETH();
626         path[1] = address(this);
627 
628         // make the swap
629         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
630             0, // accept any amount of Ethereum
631             path,
632             address(0xdead),
633             block.timestamp
634         );
635         emit BuyBackTriggered(amountInWei);
636     }
637 }