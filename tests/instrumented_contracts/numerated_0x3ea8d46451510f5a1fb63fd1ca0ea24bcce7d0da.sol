1 /**
2 Eggs of Tsuka is a scam
3 You're a discrase to the 19
4 Now, feel the Wrath Of Tsuka
5 https://t.me/EggOfTsuka
6 */
7 // SPDX-License-Identifier: MIT
8 pragma solidity 0.8.9;
9  
10 
11 
12 interface IUniswapV2Factory {
13     function createPair(address tokenA, address tokenB) external returns(address pair);
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns(uint256);
18     function balanceOf(address account) external view returns(uint256);
19     function transfer(address recipient, uint256 amount) external returns(bool);
20     function allowance(address owner, address spender) external view returns(uint256);
21     function approve(address spender, uint256 amount) external returns(bool);
22     function transferFrom(
23         address sender,
24         address recipient,
25         uint256 amount
26     ) external returns(bool);
27         event Transfer(address indexed from, address indexed to, uint256 value);
28         event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 interface IERC20Metadata is IERC20 {
31     function name() external view returns(string memory);
32     function symbol() external view returns(string memory);
33     function decimals() external view returns(uint8);
34 }
35 abstract contract Context {
36     function _msgSender() internal view virtual returns(address) {
37         return msg.sender;
38     }
39 }
40 contract ERC20 is Context, IERC20, IERC20Metadata {
41     using SafeMath for uint256;
42         mapping(address => uint256) private _balances;
43     mapping(address => mapping(address => uint256)) private _allowances;
44     uint256 private _totalSupply;
45     string private _name;
46     string private _symbol;
47     constructor(string memory name_, string memory symbol_) {
48         _name = name_;
49         _symbol = symbol_;
50     }
51     function name() public view virtual override returns(string memory) {
52         return _name;
53     }
54     function symbol() public view virtual override returns(string memory) {
55         return _symbol;
56     }
57     function decimals() public view virtual override returns(uint8) {
58         return 18;
59     }
60     function totalSupply() public view virtual override returns(uint256) {
61         return _totalSupply;
62     }
63     function balanceOf(address account) public view virtual override returns(uint256) {
64         return _balances[account];
65     }
66     function transfer(address recipient, uint256 amount) public virtual override returns(bool) {
67         _transfer(_msgSender(), recipient, amount);
68         return true;
69     }
70     function allowance(address owner, address spender) public view virtual override returns(uint256) {
71         return _allowances[owner][spender];
72     }
73     function approve(address spender, uint256 amount) public virtual override returns(bool) {
74         _approve(_msgSender(), spender, amount);
75         return true;
76     }
77     function transferFrom(
78         address sender,
79         address recipient,
80         uint256 amount
81     ) public virtual override returns(bool) {
82         _transfer(sender, recipient, amount);
83         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
84         return true;
85     }
86     function increaseAllowance(address spender, uint256 addedValue) public virtual returns(bool) {
87         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
88         return true;
89     }
90     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns(bool) {
91         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased cannot be below zero"));
92         return true;
93     }
94     function _transfer(
95         address sender,
96         address recipient,
97         uint256 amount
98     ) internal virtual {
99         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
100         _balances[recipient] = _balances[recipient].add(amount);
101         emit Transfer(sender, recipient, amount);
102     }
103     function _mint(address account, uint256 amount) internal virtual {
104         require(account != address(0), "ERC20: mint to the zero address");
105         _totalSupply = _totalSupply.add(amount);
106         _balances[account] = _balances[account].add(amount);
107         emit Transfer(address(0), account, amount);
108     }
109     function _approve(
110         address owner,
111         address spender,
112         uint256 amount
113     ) internal virtual {
114         _allowances[owner][spender] = amount;
115         emit Approval(owner, spender, amount);
116     }
117 }
118 library SafeMath {
119     function add(uint256 a, uint256 b) internal pure returns(uint256) {
120         uint256 c = a + b;
121         require(c >= a, "SafeMath: addition overflow");
122         return c;
123     }
124     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
125         return sub(a, b, "SafeMath: subtraction overflow");
126     }
127     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
128         require(b <= a, errorMessage);
129         uint256 c = a - b;
130         return c;
131     }
132     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
133         if (a == 0) {
134             return 0;
135         }
136         uint256 c = a * b;
137         require(c / a == b, "SafeMath: multiplication overflow");
138         return c;
139     }
140     function div(uint256 a, uint256 b) internal pure returns(uint256) {
141         return div(a, b, "SafeMath: division by zero");
142     }
143     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
144         require(b > 0, errorMessage);
145         uint256 c = a / b;
146         return c;
147     }
148 }
149 contract Ownable is Context {
150     address private _owner;
151     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
152     constructor() {
153         address msgSender = _msgSender();
154         _owner = msgSender;
155         emit OwnershipTransferred(address(0), msgSender);
156     }
157     function owner() public view returns(address) {
158         return _owner;
159     }
160     modifier onlyOwner() {
161         require(_owner == _msgSender(), "Ownable: caller is not the owner");
162         _;
163     }
164     function renounceOwnership() public virtual onlyOwner {
165         emit OwnershipTransferred(_owner, address(0));
166         _owner = address(0);
167     }
168     function transferOwnership(address newOwner) public virtual onlyOwner {
169         require(newOwner != address(0), "Ownable: new owner is the zero address");
170         emit OwnershipTransferred(_owner, newOwner);
171         _owner = newOwner;
172     }
173 }
174 library SafeMathInt {
175     int256 private constant MIN_INT256 = int256(1) << 255;
176     int256 private constant MAX_INT256 = ~(int256(1) << 255);
177     function mul(int256 a, int256 b) internal pure returns(int256) {
178         int256 c = a * b;
179         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
180         require((b == 0) || (c / b == a));
181         return c;
182     }
183     function div(int256 a, int256 b) internal pure returns(int256) {
184         require(b != -1 || a != MIN_INT256);
185         return a / b;
186     }
187     function sub(int256 a, int256 b) internal pure returns(int256) {
188         int256 c = a - b;
189         require((b >= 0 && c <= a) || (b < 0 && c > a));
190         return c;
191     }
192     function add(int256 a, int256 b) internal pure returns(int256) {
193         int256 c = a + b;
194         require((b >= 0 && c >= a) || (b < 0 && c < a));
195         return c;
196     }
197     function abs(int256 a) internal pure returns(int256) {
198         require(a != MIN_INT256);
199         return a < 0 ? -a : a;
200     }
201     function toUint256Safe(int256 a) internal pure returns(uint256) {
202         require(a >= 0);
203         return uint256(a);
204     }
205 }
206 library SafeMathUint {
207     function toInt256Safe(uint256 a) internal pure returns(int256) {
208     int256 b = int256(a);
209         require(b >= 0);
210         return b;
211     }
212 }
213 interface IUniswapV2Router01 {
214     function factory() external pure returns(address);
215     function WETH() external pure returns(address);
216     function addLiquidity(
217         address tokenA,
218         address tokenB,
219         uint amountADesired,
220         uint amountBDesired,
221         uint amountAMin,
222         uint amountBMin,
223         address to,
224         uint deadline
225     ) external returns(uint amountA, uint amountB, uint liquidity);
226     function addLiquidityETH(
227         address token,
228         uint amountTokenDesired,
229         uint amountTokenMin,
230         uint amountETHMin,
231         address to,
232         uint deadline
233     ) external payable returns(uint amountToken, uint amountETH, uint liquidity);
234     function removeLiquidity(
235         address tokenA,
236         address tokenB,
237         uint liquidity,
238         uint amountAMin,
239         uint amountBMin,
240         address to,
241         uint deadline
242     ) external returns(uint amountA, uint amountB);
243     function removeLiquidityETH(
244         address token,
245         uint liquidity,
246         uint amountTokenMin,
247         uint amountETHMin,
248         address to,
249         uint deadline
250     ) external returns(uint amountToken, uint amountETH);
251     function removeLiquidityWithPermit(
252         address tokenA,
253         address tokenB,
254         uint liquidity,
255         uint amountAMin,
256         uint amountBMin,
257         address to,
258         uint deadline,
259         bool approveMax, uint8 v, bytes32 r, bytes32 s
260     ) external returns(uint amountA, uint amountB);
261     function removeLiquidityETHWithPermit(
262         address token,
263         uint liquidity,
264         uint amountTokenMin,
265         uint amountETHMin,
266         address to,
267         uint deadline,
268         bool approveMax, uint8 v, bytes32 r, bytes32 s
269     ) external returns(uint amountToken, uint amountETH);
270     function swapExactTokensForTokens(
271         uint amountIn,
272         uint amountOutMin,
273         address[] calldata path,
274         address to,
275         uint deadline
276     ) external returns(uint[] memory amounts);
277     function swapTokensForExactTokens(
278         uint amountOut,
279         uint amountInMax,
280         address[] calldata path,
281         address to,
282         uint deadline
283     ) external returns(uint[] memory amounts);
284     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
285     external
286     payable
287     returns(uint[] memory amounts);
288     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
289     external
290     returns(uint[] memory amounts);
291     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
292     external
293     returns(uint[] memory amounts);
294     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
295     external
296     payable
297     returns(uint[] memory amounts);
298     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns(uint amountB);
299     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns(uint amountOut);
300     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns(uint amountIn);
301     function getAmountsOut(uint amountIn, address[] calldata path) external view returns(uint[] memory amounts);
302     function getAmountsIn(uint amountOut, address[] calldata path) external view returns(uint[] memory amounts);
303 }
304 interface IUniswapV2Router02 is IUniswapV2Router01 {
305     function removeLiquidityETHSupportingFeeOnTransferTokens(
306         address token,
307         uint liquidity,
308         uint amountTokenMin,
309         uint amountETHMin,
310         address to,
311         uint deadline
312     ) external returns(uint amountETH);
313     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
314         address token,
315         uint liquidity,
316         uint amountTokenMin,
317         uint amountETHMin,
318         address to,
319         uint deadline,
320         bool approveMax, uint8 v, bytes32 r, bytes32 s
321     ) external returns(uint amountETH);
322     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
323         uint amountIn,
324         uint amountOutMin,
325         address[] calldata path,
326         address to,
327         uint deadline
328     ) external;
329     function swapExactETHForTokensSupportingFeeOnTransferTokens(
330         uint amountOutMin,
331         address[] calldata path,
332         address to,
333         uint deadline
334     ) external payable;
335     function swapExactTokensForETHSupportingFeeOnTransferTokens(
336         uint amountIn,
337         uint amountOutMin,
338         address[] calldata path,
339         address to,
340         uint deadline
341     ) external;
342 }
343 contract WOT is ERC20, Ownable {
344     using SafeMath for uint256;
345     IUniswapV2Router02 public immutable router;
346     address public immutable uniswapV2Pair;
347     address private contestAIWallet;
348     address private marketingWallet;
349     uint256 private maxBuyAmount;
350     uint256 private maxSellAmount;   
351     uint256 private maxWalletAmount;
352     uint256 private thresholdSwapAmount;
353     bool private isTrading = false;
354     bool public swapEnabled = false;
355     bool public isSwapping;
356     struct Fees {
357         uint256 buyTotalFees;
358         uint256 buyMarketingFee;
359         uint256 buyContestAIFee;
360         uint256 buyLiquidityFee;
361         uint256 sellTotalFees;
362         uint256 sellMarketingFee;
363         uint256 sellContestAIFee;
364         uint256 sellLiquidityFee;
365     }  
366     Fees public _fees = Fees({
367         buyTotalFees: 0,
368         buyMarketingFee: 0,
369         buyContestAIFee:0,
370         buyLiquidityFee: 0,
371         sellTotalFees: 0,
372         sellMarketingFee: 0,
373         sellContestAIFee:0,
374         sellLiquidityFee: 0
375     });
376     uint256 public tokensForMarketing;
377     uint256 public tokensForLiquidity;
378     uint256 public tokensForContestAI;
379     uint256 private taxTill;
380     mapping(address => bool) private _isExcludedFromFees;
381     mapping(address => bool) public _isExcludedMaxTransactionAmount;
382     mapping(address => bool) public _isExcludedMaxWalletAmount;
383     mapping(address => bool) public marketPair;
384     event SwapAndLiquify(
385         uint256 tokensSwapped,
386         uint256 ethReceived
387     );
388     constructor() ERC20("Wrath Of Tsuka", "WOT") {
389         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
390         uniswapV2Pair = IUniswapV2Factory(router.factory()).createPair(address(this), router.WETH());
391         _isExcludedMaxTransactionAmount[address(router)] = true;
392         _isExcludedMaxTransactionAmount[address(uniswapV2Pair)] = true;        
393         _isExcludedMaxTransactionAmount[owner()] = true;
394         _isExcludedMaxTransactionAmount[address(this)] = true;
395         _isExcludedFromFees[owner()] = true;
396         _isExcludedFromFees[address(this)] = true;
397         _isExcludedMaxWalletAmount[owner()] = true;
398         _isExcludedMaxWalletAmount[address(this)] = true;
399         _isExcludedMaxWalletAmount[address(uniswapV2Pair)] = true;
400         marketPair[address(uniswapV2Pair)] = true;
401         approve(address(router), type(uint256).max);
402         uint256 totalSupply = 1e7 * 1e18;
403         maxBuyAmount = totalSupply / 50; 
404         maxSellAmount = totalSupply / 50; 
405         maxWalletAmount = totalSupply * 2 / 100; 
406         thresholdSwapAmount = totalSupply * 1 / 10000; 
407         _fees.buyMarketingFee = 10;
408         _fees.buyLiquidityFee = 1;
409         _fees.buyContestAIFee = 1;
410         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyContestAIFee;
411         _fees.sellMarketingFee = 10;
412         _fees.sellLiquidityFee = 1;
413         _fees.sellContestAIFee = 1;
414         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellContestAIFee;
415         marketingWallet = address(0xB0Ee3B86dc93450A7f5BBa77Fd99318dD4D59060);
416         contestAIWallet = address(0x5f74bdE95Ec0aaa88E9Abb27076792B28fcDD677);
417         _mint(msg.sender, totalSupply);
418     }
419     receive() external payable {
420     }
421     function swapTrading() external onlyOwner {
422         isTrading = true;
423         swapEnabled = true;
424         taxTill = block.number + 20;
425     }
426     function updateThresholdSwapAmount(uint256 newAmount) external onlyOwner returns(bool){
427         thresholdSwapAmount = newAmount;
428         return true;
429     }
430     function updateMaxTxnAmount(uint256 newMaxBuy, uint256 newMaxSell) external onlyOwner {
431         require(((totalSupply() * newMaxBuy) / 1000) >= (totalSupply() / 50), "Cannot set maxTransactionAmounts lower than 2%");
432         require(((totalSupply() * newMaxSell) / 1000) >= (totalSupply() / 50), "Cannot set maxTransactionAmounts lower than 2%");
433         maxBuyAmount = (totalSupply() * newMaxBuy) / 1000;
434         maxSellAmount = (totalSupply() * newMaxSell) / 1000;
435     }
436     function updateMaxWalletAmount(uint256 newPercentage) external onlyOwner {
437         require(((totalSupply() * newPercentage) / 1000) >= (totalSupply() / 50), "Cannot set maxWallet lower than 2%");
438         maxWalletAmount = (totalSupply() * newPercentage) / 1000;
439     }
440     function toggleSwapEnabled(bool enabled) external onlyOwner(){
441         swapEnabled = enabled;
442     }
443     function updateFees(uint256 _marketingFeeBuy, uint256 _liquidityFeeBuy,uint256 _contestAIFeeBuy,uint256 _marketingFeeSell, uint256 _liquidityFeeSell,uint256 _contestAIFeeSell) external onlyOwner{
444         _fees.buyMarketingFee = _marketingFeeBuy;
445         _fees.buyLiquidityFee = _liquidityFeeBuy;
446         _fees.buyContestAIFee = _contestAIFeeBuy;
447         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyContestAIFee;
448         _fees.sellMarketingFee = _marketingFeeSell;
449         _fees.sellLiquidityFee = _liquidityFeeSell;
450         _fees.sellContestAIFee = _contestAIFeeSell;
451         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellContestAIFee;
452         require(_fees.buyTotalFees <= 15, "Must keep fees at 15% or less");   
453         require(_fees.sellTotalFees <= 15, "Must keep fees at 15% or less");
454     }
455     function excludeFromFees(address account, bool excluded) public onlyOwner {
456         _isExcludedFromFees[account] = excluded;
457     }
458     function excludeFromWalletLimit(address account, bool excluded) public onlyOwner {
459         _isExcludedMaxWalletAmount[account] = excluded;
460     }
461     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
462         _isExcludedMaxTransactionAmount[updAds] = isEx;
463     }
464     function setMarketPair(address pair, bool value) public onlyOwner {
465         require(pair != uniswapV2Pair, "The pair cannot be removed from marketPair");
466         marketPair[pair] = value;
467     }
468     function setWallets(address _marketingWallet,address _contestAIWallet) external onlyOwner{
469         marketingWallet = _marketingWallet;
470         contestAIWallet = _contestAIWallet;
471     }
472     function isExcludedFromFees(address account) public view returns(bool) {
473         return _isExcludedFromFees[account];
474     }
475     function _transfer(
476         address sender,
477         address recipient,
478         uint256 amount
479     ) internal override {
480         if (amount == 0) {
481             super._transfer(sender, recipient, 0);
482             return;
483         }
484         if (
485             sender != owner() &&
486             recipient != owner() &&
487             !isSwapping
488         ) {
489             if (!isTrading) {
490                 require(_isExcludedFromFees[sender] || _isExcludedFromFees[recipient], "Trading is not active.");
491             }
492             if (marketPair[sender] && !_isExcludedMaxTransactionAmount[recipient]) {
493                 require(amount <= maxBuyAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
494             } 
495             else if (marketPair[recipient] && !_isExcludedMaxTransactionAmount[sender]) {
496                 require(amount <= maxSellAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
497             }
498             if (!_isExcludedMaxWalletAmount[recipient]) {
499                 require(amount + balanceOf(recipient) <= maxWalletAmount, "Max wallet exceeded");
500             }
501         }
502         uint256 contractTokenBalance = balanceOf(address(this));
503         bool canSwap = contractTokenBalance >= thresholdSwapAmount;
504         if (
505             canSwap &&
506             swapEnabled &&
507             !isSwapping &&
508             marketPair[recipient] &&
509             !_isExcludedFromFees[sender] &&
510             !_isExcludedFromFees[recipient]
511         ) {
512             isSwapping = true;
513             swapBack();
514             isSwapping = false;
515         }
516         bool takeFee = !isSwapping;
517         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
518             takeFee = false;
519         }
520         if (takeFee) {
521             uint256 fees = 0;
522             if(block.number < taxTill) {
523                 fees = amount.mul(99).div(100);
524                 tokensForMarketing += (fees * 50) / 99;
525                 tokensForContestAI += (fees * 49) / 99;
526             } else if (marketPair[recipient] && _fees.sellTotalFees > 0) {
527                 fees = amount.mul(_fees.sellTotalFees).div(100);
528                 tokensForLiquidity += fees * _fees.sellLiquidityFee / _fees.sellTotalFees;
529                 tokensForMarketing += fees * _fees.sellMarketingFee / _fees.sellTotalFees;
530                 tokensForContestAI += fees * _fees.sellContestAIFee / _fees.sellTotalFees;
531             }
532             else if (marketPair[sender] && _fees.buyTotalFees > 0) {
533                 fees = amount.mul(_fees.buyTotalFees).div(100);
534                 tokensForLiquidity += fees * _fees.buyLiquidityFee / _fees.buyTotalFees;
535                 tokensForMarketing += fees * _fees.buyMarketingFee / _fees.buyTotalFees;
536                 tokensForContestAI += fees * _fees.buyContestAIFee / _fees.buyTotalFees;
537             }
538             if (fees > 0) {
539                 super._transfer(sender, address(this), fees);
540             }
541             amount -= fees;
542         }
543         super._transfer(sender, recipient, amount);
544    }
545     function swapTokensForEth(uint256 tAmount) private {
546         address[] memory path = new address[](2);
547         path[0] = address(this);
548         path[1] = router.WETH();
549         _approve(address(this), address(router), tAmount);
550         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
551             tAmount,
552             0, 
553             path,
554             address(this),
555             block.timestamp
556         );
557     }
558     function addLiquidity(uint256 tAmount, uint256 ethAmount) private {
559         _approve(address(this), address(router), tAmount);
560         router.addLiquidityETH{ value: ethAmount } (address(this), tAmount, 0, 0 , address(this), block.timestamp);
561     }
562     function swapBack() private {
563         uint256 contractTokenBalance = balanceOf(address(this));
564         uint256 toSwap = tokensForLiquidity + tokensForMarketing + tokensForContestAI;
565         bool success;
566         if (contractTokenBalance == 0 || toSwap == 0) { return; }
567         if (contractTokenBalance > thresholdSwapAmount * 20) {
568             contractTokenBalance = thresholdSwapAmount * 20;
569         }
570         uint256 liquidityTokens = contractTokenBalance * tokensForLiquidity / toSwap / 2;
571         uint256 amountToSwapForETH = contractTokenBalance.sub(liquidityTokens);
572         uint256 initialETHBalance = address(this).balance;
573         swapTokensForEth(amountToSwapForETH); 
574         uint256 newBalance = address(this).balance.sub(initialETHBalance);
575         uint256 ethForMarketing = newBalance.mul(tokensForMarketing).div(toSwap);
576         uint256 ethForContestAI = newBalance.mul(tokensForContestAI).div(toSwap);
577         uint256 ethForLiquidity = newBalance - (ethForMarketing + ethForContestAI);
578         tokensForLiquidity = 0;
579         tokensForMarketing = 0;
580         tokensForContestAI = 0;
581         if (liquidityTokens > 0 && ethForLiquidity > 0) {
582             addLiquidity(liquidityTokens, ethForLiquidity);
583             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity);
584         }
585         (success,) = address(contestAIWallet).call{ value: (address(this).balance - ethForMarketing) } ("");
586         (success,) = address(marketingWallet).call{ value: address(this).balance } ("");
587     }
588 }