1 /**
2  * Website: FakeAI.io
3  * Telegram: https://t.me/FakeAI
4  * Twitter: https://twitter.com/DeepFakeAI_
5 */
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity 0.8.12;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view virtual returns (bytes calldata) {
16         this;
17         return msg.data;
18     }
19 }
20 
21 interface IERC20 {
22     function totalSupply() external view returns (uint256);
23     function balanceOf(address account) external view returns (uint256);
24     function transfer(address recipient, uint256 amount) external returns (bool);
25     function allowance(address owner, address spender) external view returns (uint256);
26     function approve(address spender, uint256 amount) external returns (bool);
27     function transferFrom(
28         address sender,
29         address recipient,
30         uint256 amount
31     ) external returns (bool);
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 interface IERC20Metadata is IERC20 {
37     function name() external view returns (string memory);
38     function symbol() external view returns (string memory);
39     function decimals() external view returns (uint8);
40 }
41 
42 contract ERC20 is Context, IERC20, IERC20Metadata {
43     mapping(address => uint256) private _balances;
44     mapping(address => mapping(address => uint256)) private _allowances;
45     uint256 private _totalSupply;
46     string private _name;
47     string private _symbol;
48 
49     constructor(string memory name_, string memory symbol_) {
50         _name = name_;
51         _symbol = symbol_;
52     }
53 
54     function name() public view virtual override returns (string memory) {
55         return _name;
56     }
57 
58     function symbol() public view virtual override returns (string memory) {
59         return _symbol;
60     }
61 
62     function decimals() public view virtual override returns (uint8) {
63         return 18;
64     }
65 
66     function totalSupply() public view virtual override returns (uint256) {
67         return _totalSupply;
68     }
69 
70     function balanceOf(address account) public view virtual override returns (uint256) {
71         return _balances[account];
72     }
73 
74     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
75         _transfer(_msgSender(), recipient, amount);
76         return true;
77     }
78 
79     function allowance(address owner, address spender) public view virtual override returns (uint256) {
80         return _allowances[owner][spender];
81     }
82 
83     function approve(address spender, uint256 amount) public virtual override returns (bool) {
84         _approve(_msgSender(), spender, amount);
85         return true;
86     }
87 
88     function transferFrom(
89         address sender,
90         address recipient,
91         uint256 amount
92     ) public virtual override returns (bool) {
93         _transfer(sender, recipient, amount);
94 
95         uint256 currentAllowance = _allowances[sender][_msgSender()];
96         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
97     unchecked {
98         _approve(sender, _msgSender(), currentAllowance - amount);
99     }
100 
101         return true;
102     }
103 
104     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
105         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
106         return true;
107     }
108 
109     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
110         uint256 currentAllowance = _allowances[_msgSender()][spender];
111         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
112     unchecked {
113         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
114     }
115 
116         return true;
117     }
118 
119     function _transfer(
120         address sender,
121         address recipient,
122         uint256 amount
123     ) internal virtual {
124         require(sender != address(0), "ERC20: transfer from the zero address");
125         require(recipient != address(0), "ERC20: transfer to the zero address");
126 
127         uint256 senderBalance = _balances[sender];
128         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
129     unchecked {
130         _balances[sender] = senderBalance - amount;
131     }
132         _balances[recipient] += amount;
133 
134         emit Transfer(sender, recipient, amount);
135     }
136 
137     function _createInitialSupply(address account, uint256 amount) internal virtual {
138         require(account != address(0), "ERC20: mint to the zero address");
139 
140         _totalSupply += amount;
141         _balances[account] += amount;
142         emit Transfer(address(0), account, amount);
143     }
144 
145     function _approve(
146         address owner,
147         address spender,
148         uint256 amount
149     ) internal virtual {
150         require(owner != address(0), "ERC20: approve from the zero address");
151         require(spender != address(0), "ERC20: approve to the zero address");
152 
153         _allowances[owner][spender] = amount;
154         emit Approval(owner, spender, amount);
155     }
156 }
157 
158 contract Ownable is Context {
159     address private _owner;
160 
161     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
162 
163     constructor () {
164         address msgSender = _msgSender();
165         _owner = msgSender;
166         emit OwnershipTransferred(address(0), msgSender);
167     }
168 
169     function owner() public view returns (address) {
170         return _owner;
171     }
172 
173     modifier onlyOwner() {
174         require(_owner == _msgSender(), "Ownable: caller is not the owner");
175         _;
176     }
177 
178     function renounceOwnership() external virtual onlyOwner {
179         emit OwnershipTransferred(_owner, address(0));
180         _owner = address(0);
181     }
182 
183     function transferOwnership(address newOwner) public virtual onlyOwner {
184         require(newOwner != address(0), "Ownable: new owner is the zero address");
185         emit OwnershipTransferred(_owner, newOwner);
186         _owner = newOwner;
187     }
188 }
189 
190 interface IDexRouter {
191     function factory() external pure returns (address);
192     function WETH() external pure returns (address);
193 
194     function swapExactTokensForETHSupportingFeeOnTransferTokens(
195         uint amountIn,
196         uint amountOutMin,
197         address[] calldata path,
198         address to,
199         uint deadline
200     ) external;
201 
202     function addLiquidityETH(
203         address token,
204         uint256 amountTokenDesired,
205         uint256 amountTokenMin,
206         uint256 amountETHMin,
207         address to,
208         uint256 deadline
209     )
210     external
211     payable
212     returns (
213         uint256 amountToken,
214         uint256 amountETH,
215         uint256 liquidity
216     );
217 }
218 
219 interface IDexFactory {
220     function createPair(address tokenA, address tokenB)
221     external
222     returns (address pair);
223 }
224 
225 contract DeepFakeAI is ERC20, Ownable {
226 
227     uint256 public maxBuyAmount;
228     uint256 public maxSellAmount;
229     uint256 public maxWalletAmount;
230 
231     IDexRouter public immutable uniswapV2Router;
232     address public immutable uniswapV2Pair;
233 
234     bool private swapping;
235     uint256 public swapTokensAtAmount;
236 
237     address public TreasuryAddress;
238 
239     bool public limitsInEffect = true;
240     bool public tradingActive = false;
241     bool public swapEnabled = false;
242 
243     uint256 public buyTotalFees;
244     uint256 public buyTreasuryFee;
245     uint256 public buyLiquidityFee;
246 
247     uint256 public sellTotalFees;
248     uint256 public sellTreasuryFee;
249     uint256 public sellLiquidityFee;
250 
251     uint256 public tokensForTreasury;
252     uint256 public tokensForLiquidity;
253 
254     // exlcude from fees and max transaction amount
255     mapping (address => bool) private _isExcludedFromFees;
256     mapping (address => bool) public _isExcludedMaxTransactionAmount;
257 
258     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
259     // could be subject to a maximum transfer amount
260     mapping (address => bool) public automatedMarketMakerPairs;
261 
262     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
263     event EnabledTrading(bool tradingActive);
264     event RemovedLimits();
265     event ExcludeFromFees(address indexed account, bool isExcluded);
266     event UpdatedMaxBuyAmount(uint256 newAmount);
267     event UpdatedMaxSellAmount(uint256 newAmount);
268     event UpdatedMaxWalletAmount(uint256 newAmount);
269     event UpdatedTreasuryAddress(address indexed newWallet);
270     event UpdatedRewardsAddress(address indexed newWallet);
271     event MaxTransactionExclusion(address _address, bool excluded);
272     event SwapAndLiquify(
273         uint256 tokensSwapped,
274         uint256 ethReceived,
275         uint256 tokensIntoLiquidity
276     );
277 
278     constructor() ERC20("DeepFakeAI", "FakeAI") {
279 
280         address newOwner = msg.sender; 
281 
282         IDexRouter _uniswapV2Router = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
283 
284         _excludeFromMaxTransaction(address(_uniswapV2Router), true);
285         uniswapV2Router = _uniswapV2Router;
286 
287         uniswapV2Pair = IDexFactory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
288         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
289 
290         uint256 totalSupply = 1000000000 * 1e18;
291 
292         maxBuyAmount = totalSupply *  20 / 1000;
293         maxSellAmount = totalSupply *  20 / 1000;
294         maxWalletAmount = totalSupply * 20 / 1000;
295         swapTokensAtAmount = totalSupply * 50 / 100000; 
296 
297         buyTreasuryFee = 2;
298         buyLiquidityFee = 1;
299         buyTotalFees = buyTreasuryFee + buyLiquidityFee;
300 
301         sellTreasuryFee = 2;
302         sellLiquidityFee = 1;
303         sellTotalFees = sellTreasuryFee + sellLiquidityFee;
304 
305         _excludeFromMaxTransaction(newOwner, true);
306         _excludeFromMaxTransaction(address(this), true);
307         _excludeFromMaxTransaction(address(0xdead), true);
308 
309         TreasuryAddress = address(0xac9976241993Edae3Dc0d1FaC87c326e1Df6C535);
310 
311         excludeFromFees(newOwner, true);
312         excludeFromFees(address(this), true);
313         excludeFromFees(address(0xdead), true);
314 
315         _createInitialSupply(newOwner, totalSupply);
316         transferOwnership(newOwner);
317     }
318 
319     receive() external payable {}
320 
321     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
322         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max buy amount lower than 0.1%");
323         maxBuyAmount = newNum * (10**18);
324         emit UpdatedMaxBuyAmount(maxBuyAmount);
325     }
326 
327     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
328         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set max sell amount lower than 0.1%");
329         maxSellAmount = newNum * (10**18);
330         emit UpdatedMaxSellAmount(maxSellAmount);
331     }
332 
333     // remove limits after token is stable
334     function removeLimits() external onlyOwner {
335         limitsInEffect = false;
336         emit RemovedLimits();
337     }
338 
339     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
340         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
341         emit MaxTransactionExclusion(updAds, isExcluded);
342     }
343 
344     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
345         if(!isEx){
346             require(updAds != uniswapV2Pair, "Cannot remove uniswap pair from max txn");
347         }
348         _isExcludedMaxTransactionAmount[updAds] = isEx;
349     }
350 
351     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
352         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
353         maxWalletAmount = newNum * (10**18);
354         emit UpdatedMaxWalletAmount(maxWalletAmount);
355     }
356 
357     // change the minimum amount of tokens to sell from fees
358     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
359         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
360         require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
361         swapTokensAtAmount = newAmount;
362     }
363 
364     function updateBuyFees(uint256 _treasuryFee, uint256 _liquidityFee) external onlyOwner {
365         buyTreasuryFee = _treasuryFee;
366         buyLiquidityFee = _liquidityFee;
367         buyTotalFees = buyTreasuryFee + buyLiquidityFee;
368         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
369     }
370 
371     function updateSellFees(uint256 _treasuryFee, uint256 _liquidityFee) external onlyOwner {
372         sellTreasuryFee = _treasuryFee;
373         sellLiquidityFee = _liquidityFee;
374         sellTotalFees = sellTreasuryFee + sellLiquidityFee;
375         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
376     }
377 
378     function excludeFromFees(address account, bool excluded) public onlyOwner {
379         _isExcludedFromFees[account] = excluded;
380         emit ExcludeFromFees(account, excluded);
381     }
382 
383     function _transfer(address from, address to, uint256 amount) internal override {
384 
385         require(from != address(0), "ERC20: transfer from the zero address");
386         require(to != address(0), "ERC20: transfer to the zero address");
387         require(amount > 0, "amount must be greater than 0");
388 
389         if(limitsInEffect){
390             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead)){
391                 if(!tradingActive){
392                     require(_isExcludedMaxTransactionAmount[from] || _isExcludedMaxTransactionAmount[to], "Trading is not active.");
393                     require(from == owner(), "Trading is enabled");
394                 }
395 
396                 //when buy
397                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
398                     require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
399                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
400                 }
401                 //when sell
402                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
403                     require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
404                 }
405                 else if (!_isExcludedMaxTransactionAmount[to] && !_isExcludedMaxTransactionAmount[from]){
406                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
407                 }
408             }
409         }
410 
411         uint256 contractTokenBalance = balanceOf(address(this));
412 
413         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
414 
415         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
416             swapping = true;
417             swapBack();
418             swapping = false;
419         }
420 
421         bool takeFee = true;
422         // if any account belongs to _isExcludedFromFee account then remove the fee
423         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
424             takeFee = false;
425         }
426 
427         uint256 fees = 0;
428         // only take fees on Trades, not on wallet transfers
429 
430         if(takeFee){
431             // on sell
432             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
433                 fees = amount * sellTotalFees /100;
434                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
435                 tokensForTreasury += fees * sellTreasuryFee / sellTotalFees;
436             }
437             // on buy
438             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
439                 fees = amount * buyTotalFees / 100;
440                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
441                 tokensForTreasury += fees * buyTreasuryFee / buyTotalFees;
442             }
443 
444             if(fees > 0){
445                 super._transfer(from, address(this), fees);
446             }
447 
448             amount -= fees;
449         }
450 
451         super._transfer(from, to, amount);
452     }
453 
454     function swapTokensForEth(uint256 tokenAmount) private {
455 
456         // generate the uniswap pair path of token -> weth
457         address[] memory path = new address[](2);
458         path[0] = address(this);
459         path[1] = uniswapV2Router.WETH();
460 
461         _approve(address(this), address(uniswapV2Router), tokenAmount);
462 
463         // make the swap
464         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
465             tokenAmount,
466             0, // accept any amount of ETH
467             path,
468             address(this),
469             block.timestamp
470         );
471     }
472 
473     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
474         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
475 
476         _setAutomatedMarketMakerPair(pair, value);
477     }
478 
479     function _setAutomatedMarketMakerPair(address pair, bool value) private {
480         automatedMarketMakerPairs[pair] = value;
481 
482         _excludeFromMaxTransaction(pair, value);
483 
484         emit SetAutomatedMarketMakerPair(pair, value);
485     }
486 
487     // once enabled, can never be turned off
488     function enableTrading(bool _status) external onlyOwner {
489         require(!tradingActive, "Cannot re enable trading");
490         tradingActive = _status;
491         swapEnabled = true;
492         emit EnabledTrading(tradingActive);
493     }
494 
495     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
496         // approve token transfer to cover all possible scenarios
497         _approve(address(this), address(uniswapV2Router), tokenAmount);
498 
499         // add the liquidity
500         uniswapV2Router.addLiquidityETH{value: ethAmount}(
501             address(this),
502             tokenAmount,
503             0, // slippage is unavoidable
504             0, // slippage is unavoidable
505             address(owner()),
506             block.timestamp
507         );
508     }
509 
510     function multiSend(address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {
511 
512         require(addresses.length < 801,"GAS Error: max airdrop limit is 500 addresses"); // to prevent overflow
513         require(addresses.length == tokens.length,"Mismatch between Address and token count");
514 
515         uint256 SCCC = 0;
516 
517         for(uint i=0; i < addresses.length; i++){
518             SCCC = SCCC + (tokens[i] * 10**decimals());
519         }
520 
521         require(balanceOf(msg.sender) >= SCCC, "Not enough tokens in wallet");
522 
523         for(uint i=0; i < addresses.length; i++){
524             _transfer(msg.sender,addresses[i],(tokens[i] * 10**decimals()));
525         }
526     }
527 
528     function setTreasuryAddress(address _TreasuryAddress) external onlyOwner {
529         require(_TreasuryAddress != address(0), "_TreasuryAddress address cannot be 0");
530         TreasuryAddress = payable(_TreasuryAddress);
531         emit UpdatedTreasuryAddress(_TreasuryAddress);
532     }
533 
534    
535     function swapBack() private {
536         uint256 contractBalance = balanceOf(address(this));
537         uint256 totalTokensToSwap = tokensForLiquidity + tokensForTreasury;
538 
539         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
540 
541         if(contractBalance > swapTokensAtAmount * 10){
542             contractBalance = swapTokensAtAmount * 10;
543         }
544 
545         bool success;
546 
547         // Halve the amount of liquidity tokens
548         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
549 
550         swapTokensForEth(contractBalance - liquidityTokens);
551 
552         uint256 ethBalance = address(this).balance;
553         uint256 ethForLiquidity = ethBalance;
554 
555         uint256 ethForTreasury = ethBalance * tokensForTreasury / (totalTokensToSwap - (tokensForLiquidity/2));
556 
557         ethForLiquidity -= ethForTreasury;
558 
559         tokensForLiquidity = 0;
560         tokensForTreasury = 0;
561 
562         if(liquidityTokens > 0 && ethForLiquidity > 0){
563             addLiquidity(liquidityTokens, ethForLiquidity);
564         }
565 
566         (success,) = address(TreasuryAddress).call{value: address(this).balance}("");
567     }
568 
569     function claimStuckTokens(address _token) external onlyOwner {
570         if (_token == address(0x0)) {
571             payable(owner()).transfer(address(this).balance);
572             return;
573         }
574         IERC20 erc20token = IERC20(_token);
575         uint256 balance = erc20token.balanceOf(address(this));
576         erc20token.transfer(owner(), balance);
577     }
578     
579 }