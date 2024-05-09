1 /*
2  * 🔥🔥 Ōkami Inu 🔥🔥
3  * Utility driven meme token
4 
5  * Telegram :
6  * Website : 
7 
8  **** Tokenomics ****
9 
10  ** Buy Fee/Default Sell Fee : 12% (10% TX 2% Liquidity)
11  ** 1 Hour Sell Fee : 24% (12% TX 12% Liquidity)
12  ** 24 Hour Sell Fee : 18% (12% TX 6% Liquidity)
13  ** Holder Appreciation : After 30 days 0% sell fee
14  
15  **** Bot and Whale Protection ****
16 
17  ** .5% Max tx
18  ** 1.5% Max wallet
19  ** 30 Second cooldown between buys
20  ** 0-2 Block buys automatically blacklisted
21 */
22 
23 // SPDX-License-Identifier: MIT
24 
25 pragma solidity ^0.6.12;
26 
27 /**
28  * @dev Interface of the ERC20 standard as defined in the EIP.
29  */
30 interface IERC20 {
31     function totalSupply() external view returns (uint256);
32     function balanceOf(address account) external view returns (uint256);
33     function transfer(address recipient, uint256 amount) external returns (bool);
34     function allowance(address owner, address spender) external view returns (uint256);
35     function approve(address spender, uint256 amount) external returns (bool);
36     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 interface IERC20Metadata is IERC20 {
42     function name() external view returns (string memory);
43     function symbol() external view returns (string memory);
44     function decimals() external view returns (uint8);
45 }
46 
47 abstract contract Context {
48     function _msgSender() internal view virtual returns (address) {
49         return msg.sender;
50     }
51 
52     function _msgData() internal view virtual returns (bytes calldata) {
53         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
54         return msg.data;
55     }
56 }
57 
58 
59 contract Ownable is Context {
60     address private _owner;
61     address private _previousOwner;
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     constructor () public {
65         address msgSender = _msgSender();
66         _owner = msgSender;
67         emit OwnershipTransferred(address(0), msgSender);
68     }
69 
70     function owner() public view returns (address) {
71         return _owner;
72     }
73 
74     modifier onlyOwner() {
75         require(_owner == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     function renounceOwnership() public virtual onlyOwner {
80         emit OwnershipTransferred(_owner, address(0));
81         _owner = address(0);
82     }
83 
84 } 
85 
86 library SafeMath {
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a, "SafeMath: addition overflow");
90         return c;
91     }
92 
93     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
94         return sub(a, b, "SafeMath: subtraction overflow");
95     }
96 
97     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
98         require(b <= a, errorMessage);
99         uint256 c = a - b;
100         return c;
101     }
102 
103     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104         if (a == 0) {
105             return 0;
106         }
107         uint256 c = a * b;
108         require(c / a == b, "SafeMath: multiplication overflow");
109         return c;
110     }
111 
112     function div(uint256 a, uint256 b) internal pure returns (uint256) {
113         return div(a, b, "SafeMath: division by zero");
114     }
115 
116     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
117         require(b > 0, errorMessage);
118         uint256 c = a / b;
119         return c;
120     }
121 
122 }
123 
124 interface IUniswapV2Factory {
125     function createPair(address tokenA, address tokenB) external returns (address pair);
126 }
127 
128 
129 interface IUniswapV2Router02 {
130     function swapExactTokensForETHSupportingFeeOnTransferTokens(
131         uint amountIn,
132         uint amountOutMin,
133         address[] calldata path,
134         address to,
135         uint deadline
136     ) external;
137     function factory() external pure returns (address);
138     function WETH() external pure returns (address);
139     function addLiquidityETH(
140         address token,
141         uint amountTokenDesired,
142         uint amountTokenMin,
143         uint amountETHMin,
144         address to,
145         uint deadline
146     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
147 }
148 
149 contract ERC20 is Context, IERC20, IERC20Metadata {
150     using SafeMath for uint256;
151 
152     mapping(address => uint256) private _balances;
153 
154     mapping(address => mapping(address => uint256)) private _allowances;
155 
156     uint256 private _totalSupply;
157 
158     string private _name;
159     string private _symbol;
160 
161     constructor(string memory name_, string memory symbol_) public {
162         _name = name_;
163         _symbol = symbol_;
164     }
165 
166     function name() public view virtual override returns (string memory) {
167         return _name;
168     }
169     function symbol() public view virtual override returns (string memory) {
170         return _symbol;
171     }
172     function decimals() public view virtual override returns (uint8) {
173         return 9;
174     }
175     function totalSupply() public view virtual override returns (uint256) {
176         return _totalSupply;
177     }
178 
179     function balanceOf(address account) public view virtual override returns (uint256) {
180         return _balances[account];
181     }
182     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
183         _transfer(_msgSender(), recipient, amount);
184         return true;
185     }
186     function allowance(address owner, address spender) public view virtual override returns (uint256) {
187         return _allowances[owner][spender];
188     }
189     function approve(address spender, uint256 amount) public virtual override returns (bool) {
190         _approve(_msgSender(), spender, amount);
191         return true;
192     }
193 
194     function transferFrom(
195         address sender,
196         address recipient,
197         uint256 amount
198     ) public virtual override returns (bool) {
199         _transfer(sender, recipient, amount);
200         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
201         return true;
202     }
203 
204     function _transfer(
205         address sender,
206         address recipient,
207         uint256 amount
208     ) internal virtual {
209         require(sender != address(0), "ERC20: transfer from the zero address");
210         require(recipient != address(0), "ERC20: transfer to the zero address");
211 
212         _beforeTokenTransfer(sender, recipient, amount);
213 
214         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
215         _balances[recipient] = _balances[recipient].add(amount);
216         emit Transfer(sender, recipient, amount);
217     }
218     function _mint(address account, uint256 amount) internal virtual {
219         require(account != address(0), "ERC20: mint to the zero address");
220 
221         _beforeTokenTransfer(address(0), account, amount);
222 
223         _totalSupply = _totalSupply.add(amount);
224         _balances[account] = _balances[account].add(amount);
225         emit Transfer(address(0), account, amount);
226     }
227 
228     function _burn(address account, uint256 amount) internal virtual {
229         require(account != address(0), "ERC20: burn from the zero address");
230 
231         _beforeTokenTransfer(account, address(0), amount);
232 
233         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
234         _totalSupply = _totalSupply.sub(amount);
235         emit Transfer(account, address(0), amount);
236     }
237 
238     function _approve(
239         address owner,
240         address spender,
241         uint256 amount
242     ) internal virtual {
243         require(owner != address(0), "ERC20: approve from the zero address");
244         require(spender != address(0), "ERC20: approve to the zero address");
245 
246         _allowances[owner][spender] = amount;
247         emit Approval(owner, spender, amount);
248     }
249 
250     function _beforeTokenTransfer(
251         address from,
252         address to,
253         uint256 amount
254     ) internal virtual {}
255 }
256 
257 contract OKAMI is ERC20, Ownable {
258     using SafeMath for uint256;
259 
260     address public constant DEAD_ADDRESS = address(0xdead);
261     IUniswapV2Router02 public constant uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
262 
263     uint256 public buyLiquidityFee = 2;
264     uint256 public sellLiquidityFee = 2;
265     uint256 public buyTxFee = 10;
266     uint256 public sellTxFee = 10;
267 
268     uint256 public defaultSellLiquidityFee = 2;
269     uint256 public defaultSellTxFee = 10;
270 
271     uint256 public hourSellLiquidityFee = 12;
272     uint256 public hourSellTxFee = 12;
273 
274     uint256 public daySellLiquidityFee = 6;
275     uint256 public daySellTxFee = 12;
276 
277     uint256 public tokensForLiquidity;
278     uint256 public tokensForTax;
279 
280     uint256 public _tTotal = 10**9 * 10**9;                         // 1 billion
281     uint256 public swapAtAmount = _tTotal.mul(50).div(10000);       // 0.10% of total supply
282     uint256 public maxTxLimit = _tTotal;                            // 0.5% of total supply set in open trading
283     uint256 public maxWalletLimit = _tTotal;                        // 1% of total supply set in open trading
284 
285     address private dev;
286     address private liquidity;
287 
288     address public uniswapV2Pair;
289 
290     uint256 public launchBlock;
291 
292     bool private swapping;
293     bool public isLaunched;
294     bool private cooldownEnabled = false;
295     bool private useBuyMap = true;
296 
297     // exclude from fees
298     mapping (address => bool) public isExcludedFromFees;
299 
300     // exclude from max transaction amount
301     mapping (address => bool) public isExcludedFromTxLimit;
302 
303     // exclude from max wallet limit
304     mapping (address => bool) public isExcludedFromWalletLimit;
305 
306     // if the account is blacklisted from transacting
307     mapping (address => bool) public isBlacklisted;
308 
309     // buy map for timed sell tax
310     mapping (address => uint256) public _buyMap;
311 
312     // mapping for cooldown
313     mapping (address => uint) public cooldown;
314 
315     constructor() public ERC20("Ōkami Inu", "Ōkami") {
316 
317         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
318         _approve(address(this), address(uniswapV2Router), type(uint256).max);
319 
320 
321         // exclude from fees, wallet limit and transaction limit
322         excludeFromAllLimits(owner(), true);
323         excludeFromAllLimits(address(this), true);
324         excludeFromWalletLimit(uniswapV2Pair, true);
325 
326         dev = payable(0x1f30Eb1644Cb6528d0ab609815EE7930a0F5720c);
327         liquidity = payable(0x1f30Eb1644Cb6528d0ab609815EE7930a0F5720c);
328 
329         /*
330             _mint is an internal function in ERC20.sol that is only called here,
331             and CANNOT be called ever again
332         */
333         _mint(owner(), _tTotal);
334     }
335 
336     function excludeFromFees(address account, bool value) public onlyOwner() {
337         require(isExcludedFromFees[account] != value, "Fees: Already set to this value");
338         isExcludedFromFees[account] = value;
339     }
340 
341     function excludeFromTxLimit(address account, bool value) public onlyOwner() {
342         require(isExcludedFromTxLimit[account] != value, "TxLimit: Already set to this value");
343         isExcludedFromTxLimit[account] = value;
344     }
345 
346     function excludeFromWalletLimit(address account, bool value) public onlyOwner() {
347         require(isExcludedFromWalletLimit[account] != value, "WalletLimit: Already set to this value");
348         isExcludedFromWalletLimit[account] = value;
349     }
350 
351     function excludeFromAllLimits(address account, bool value) public onlyOwner() {
352         excludeFromFees(account, value);
353         excludeFromTxLimit(account, value);
354         excludeFromWalletLimit(account, value);
355     }
356 
357     function setBuyFee(uint256 liquidityFee, uint256 txFee) external onlyOwner() {
358 	require(liquidityFee.add(txFee) <= 12, "Total buy fee can not be more than 12");
359         buyLiquidityFee = liquidityFee;
360         buyTxFee = txFee;
361     }
362 
363     function setSellFee(uint256 liquidityFee, uint256 txFee) external onlyOwner() {
364         require(liquidityFee.add(txFee) <= 12, "Total default fee can not be more than 12");
365         sellLiquidityFee = liquidityFee;
366         sellTxFee = txFee;
367 
368         defaultSellLiquidityFee = liquidityFee;
369         defaultSellTxFee = txFee;
370     }
371 
372     function setHourSellFee(uint256 liquidityFee, uint256 txFee) external onlyOwner() {
373         require(liquidityFee.add(txFee) <= 24, "Total default fee can not be more than 25");
374         hourSellLiquidityFee = liquidityFee;
375         hourSellTxFee = txFee;
376     }
377 
378     function setDaySellFee(uint256 liquidityFee, uint256 txFee) external onlyOwner() {
379         require(liquidityFee.add(txFee) <= 18, "Total default fee can not be more than 18");
380         daySellLiquidityFee = liquidityFee;
381         daySellTxFee = txFee;
382     }
383 
384     function setCooldownEnabled(bool _enabled) external onlyOwner() {
385         cooldownEnabled = _enabled;
386     }
387 
388    function setUseBuyMap(bool _enabled) external onlyOwner() {
389         useBuyMap = _enabled;
390     }
391 
392     function setMaxTxLimit(uint256 newLimit) external onlyOwner() {
393         require(newLimit > 0, "max tx can not be 0");
394         maxTxLimit = newLimit * (10**9);
395     }
396 
397     function setMaxWalletLimit(uint256 newLimit) external onlyOwner() {
398         require(newLimit > 0, "max wallet can not be 0");
399         maxWalletLimit = newLimit * (10**9);
400     }
401 
402     function setSwapAtAmount(uint256 amountToSwap) external onlyOwner() {
403         swapAtAmount = amountToSwap * (10**9);
404     }
405 
406     function updateDevWallet(address newWallet) external onlyOwner() {
407         dev = newWallet;
408     }
409 
410     function updateLiqWallet(address newWallet) external onlyOwner() {
411         liquidity = newWallet;
412     }
413 
414     function addBlacklist(address account) external onlyOwner() {
415         require(!isBlacklisted[account], "Blacklist: Already blacklisted");
416         require(account != uniswapV2Pair, "Cannot blacklist pair");
417         _setBlacklist(account, true);
418     }
419 
420     function removeBlacklist(address account) external onlyOwner() {
421         require(isBlacklisted[account], "Blacklist: Not blacklisted");
422         _setBlacklist(account, false);
423     }
424 
425     function manualswap() external onlyOwner() {
426         uint256 totalTokensForFee = tokensForLiquidity + tokensForTax;
427         swapBack(totalTokensForFee);
428     }
429     
430     function manualsend() external onlyOwner(){
431         uint256 contractETHBalance = address(this).balance;
432         payable(address(dev)).transfer(contractETHBalance);
433     }
434     
435 
436     function openTrading() external onlyOwner() {
437         require(!isLaunched, "Contract is already launched");
438         isLaunched = true;
439         launchBlock = block.number;
440         cooldownEnabled = true;
441         maxTxLimit = _tTotal.mul(50).div(10000);        
442         maxWalletLimit = _tTotal.mul(100).div(10000);
443     }
444 
445     function _transfer(address from, address to, uint256 amount) internal override {
446         require(from != address(0), "transfer from the zero address");
447         require(to != address(0), "transfer to the zero address");
448         require(amount <= maxTxLimit || isExcludedFromTxLimit[from] || isExcludedFromTxLimit[to], "Tx Amount too large");
449         require(balanceOf(to).add(amount) <= maxWalletLimit || isExcludedFromWalletLimit[to], "Transfer will exceed wallet limit");
450         require(isLaunched || isExcludedFromFees[from] || isExcludedFromFees[to], "Waiting to go live");
451         require(!isBlacklisted[from], "Sender is blacklisted");
452 
453         if(amount == 0) {
454             super._transfer(from, to, 0);
455             return;
456         }
457 
458         uint256 totalTokensForFee = tokensForLiquidity + tokensForTax;
459         bool canSwap = totalTokensForFee >= swapAtAmount;
460 
461         if(
462             from != uniswapV2Pair &&
463             canSwap &&
464             !swapping
465         ) {
466             swapping = true;
467             swapBack(totalTokensForFee);
468             swapping = false;
469         } else if(
470             from == uniswapV2Pair &&
471             to != uniswapV2Pair &&
472             block.number < launchBlock + 1 &&
473             !isExcludedFromFees[to]
474         ) {
475             _setBlacklist(to, true);
476         }
477 
478         bool takeFee = !swapping;
479 
480         if(isExcludedFromFees[from] || isExcludedFromFees[to]) {
481             takeFee = false;
482         }
483 
484         if(takeFee) {
485             uint256 fees;
486             // on sell
487             if (to == uniswapV2Pair) {
488                 if(useBuyMap){
489                     if (_buyMap[from] != 0 &&
490                         (_buyMap[from] + (1 hours) >= block.timestamp))  {
491                         sellLiquidityFee = hourSellLiquidityFee;
492                         sellTxFee = hourSellTxFee;
493                         _buyMap[from] = block.timestamp;
494                     } else if (_buyMap[from] != 0 &&
495                         (_buyMap[from] + (24 hours) >= block.timestamp)) {
496                         sellLiquidityFee = daySellLiquidityFee;
497                         sellTxFee = daySellTxFee;
498                         _buyMap[from] = block.timestamp;
499                     } else if (_buyMap[from] != 0 &&
500                         (_buyMap[from] + (30 days) >= block.timestamp)) {
501                         sellLiquidityFee = 0;
502                         sellTxFee = 0;
503                     } else {
504                         sellLiquidityFee = defaultSellLiquidityFee;
505                         sellTxFee = defaultSellTxFee;
506                     }
507                 } else {
508                     sellLiquidityFee = defaultSellLiquidityFee;
509                     sellTxFee = defaultSellTxFee;
510                 }
511               
512                 uint256 sellTotalFees = sellLiquidityFee.add(sellTxFee);
513                 fees = amount.mul(sellTotalFees).div(100);
514                 tokensForLiquidity = tokensForLiquidity.add(fees.mul(sellLiquidityFee).div(sellTotalFees));
515                 tokensForTax = tokensForTax.add(fees.mul(sellTxFee).div(sellTotalFees));
516             }
517             // on buy & wallet transfers
518             else {
519                 if(cooldownEnabled){
520                     require(cooldown[to] < block.timestamp);
521                     cooldown[to] = block.timestamp + (30 seconds);
522                 }
523                 if (useBuyMap && _buyMap[to] == 0) {
524                     _buyMap[to] = block.timestamp;
525                 }
526                 uint256 buyTotalFees = buyLiquidityFee.add(buyTxFee);
527                 fees = amount.mul(buyTotalFees).div(100);
528                 tokensForLiquidity = tokensForLiquidity.add(fees.mul(buyLiquidityFee).div(buyTotalFees));
529                 tokensForTax = tokensForTax.add(fees.mul(buyTxFee).div(buyTotalFees));
530             }
531 
532             if(fees > 0){
533                 super._transfer(from, address(this), fees);
534                 amount = amount.sub(fees);
535             }
536         }
537 
538         super._transfer(from, to, amount);
539     }
540 
541     function swapBack(uint256 totalTokensForFee) private {
542         uint256 toSwap = swapAtAmount;
543 
544         // Halve the amount of liquidity tokens
545         uint256 liquidityTokens = toSwap.mul(tokensForLiquidity).div(totalTokensForFee).div(2);
546         uint256 taxTokens = toSwap.sub(liquidityTokens).sub(liquidityTokens);
547         uint256 amountToSwapForETH = toSwap.sub(liquidityTokens);
548 
549         _swapTokensForETH(amountToSwapForETH);
550 
551         uint256 ethBalance = address(this).balance;
552         uint256 ethForTax = ethBalance.mul(taxTokens).div(amountToSwapForETH);
553         uint256 ethForLiquidity = ethBalance.sub(ethForTax);
554 
555         tokensForLiquidity = tokensForLiquidity.sub(liquidityTokens.mul(2));
556         tokensForTax = tokensForTax.sub(toSwap.sub(liquidityTokens.mul(2)));
557 
558         payable(address(dev)).transfer(ethForTax);
559         _addLiquidity(liquidityTokens, ethForLiquidity);
560     }
561 
562     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
563 
564         uniswapV2Router.addLiquidityETH{value: ethAmount}(
565             address(this),
566             tokenAmount,
567             0,
568             0,
569             liquidity,
570             block.timestamp
571         );
572     }
573 
574     function _swapTokensForETH(uint256 tokenAmount) private {
575 
576         address[] memory path = new address[](2);
577         path[0] = address(this);
578         path[1] = uniswapV2Router.WETH();
579 
580         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
581             tokenAmount,
582             0,
583             path,
584             address(this),
585             block.timestamp
586         );
587     }
588 
589     function _setBlacklist(address account, bool value) internal {
590         isBlacklisted[account] = value;
591     }
592 
593     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent){
594         require(_token != address(this), "Can't withdraw native tokens");
595         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
596         _sent = IERC20(_token).transfer(_to, _contractBalance);
597     }
598     
599 
600     receive() external payable {}
601 }