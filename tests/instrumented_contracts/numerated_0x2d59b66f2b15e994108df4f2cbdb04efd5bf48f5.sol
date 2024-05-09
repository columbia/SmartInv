1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
3 
4 //      ██████   ██████    █████   ██       ██    ██  ███████ 
5 //     ██    ██  ██   ██  ██   ██  ██       ██    ██  ██      
6 //     ██    ██  ██████   ███████  ██       ██    ██  ███████ 
7 //     ██    ██  ██       ██   ██  ██       ██    ██       ██ 
8 //      ██████   ██       ██   ██  ███████   ██████   ███████ 
9 //                                                  
10 //      ✺  https://www.opalus.world/
11 //      ✺  https://t.me/OPALUS_PORTAL
12 //      ✺  https://twitter.com/OPALUS_ERC
13 
14 interface IUniswapV2Factory {
15     function createPair(address tokenA, address tokenB) external returns(address pair);
16 }
17 
18 interface IERC20 {
19 
20     function totalSupply() external view returns(uint256);
21     function balanceOf(address account) external view returns(uint256);
22     function transfer(address recipient, uint256 amount) external returns(bool);
23     function allowance(address owner, address spender) external view returns(uint256);
24     function approve(address spender, uint256 amount) external returns(bool);
25 
26     function transferFrom(
27         address sender,
28         address recipient,
29         uint256 amount
30     ) external returns(bool);
31 
32         event Transfer(address indexed from, address indexed to, uint256 value);
33         event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 interface IERC20Metadata is IERC20 {
37 
38     function name() external view returns(string memory);
39     function symbol() external view returns(string memory);
40     function decimals() external view returns(uint8);
41 }
42 
43 abstract contract Context {
44     function _msgSender() internal view virtual returns(address) {
45         return msg.sender;
46     }
47 }
48 
49 contract ERC20 is Context, IERC20, IERC20Metadata {
50     using SafeMath for uint256;
51 
52         mapping(address => uint256) private _balances;
53 
54     mapping(address => mapping(address => uint256)) private _allowances;
55  
56     uint256 private _totalSupply;
57  
58     string private _name;
59     string private _symbol;
60 
61     constructor(string memory name_, string memory symbol_) {
62         _name = name_;
63         _symbol = symbol_;
64     }
65 
66     function name() public view virtual override returns(string memory) {
67         return _name;
68     }
69 
70     function symbol() public view virtual override returns(string memory) {
71         return _symbol;
72     }
73 
74     function decimals() public view virtual override returns(uint8) {
75         return 18;
76     }
77 
78     function totalSupply() public view virtual override returns(uint256) {
79         return _totalSupply;
80     }
81 
82     function balanceOf(address account) public view virtual override returns(uint256) {
83         return _balances[account];
84     }
85 
86     function transfer(address recipient, uint256 amount) public virtual override returns(bool) {
87         _transfer(_msgSender(), recipient, amount);
88         return true;
89     }
90 
91     function allowance(address owner, address spender) public view virtual override returns(uint256) {
92         return _allowances[owner][spender];
93     }
94 
95     function approve(address spender, uint256 amount) public virtual override returns(bool) {
96         _approve(_msgSender(), spender, amount);
97         return true;
98     }
99 
100     function transferFrom(
101         address sender,
102         address recipient,
103         uint256 amount
104     ) public virtual override returns(bool) {
105         _transfer(sender, recipient, amount);
106         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
107         return true;
108     }
109 
110     function increaseAllowance(address spender, uint256 addedValue) public virtual returns(bool) {
111         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
112         return true;
113     }
114 
115     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns(bool) {
116         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased cannot be below zero"));
117         return true;
118     }
119 
120     function _transfer(
121         address sender,
122         address recipient,
123         uint256 amount
124     ) internal virtual {
125         
126         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
127         _balances[recipient] = _balances[recipient].add(amount);
128         emit Transfer(sender, recipient, amount);
129     }
130 
131     function _mint(address account, uint256 amount) internal virtual {
132         require(account != address(0), "ERC20: mint to the zero address");
133 
134         _totalSupply = _totalSupply.add(amount);
135         _balances[account] = _balances[account].add(amount);
136         emit Transfer(address(0), account, amount);
137     }
138 
139     function _approve(
140         address owner,
141         address spender,
142         uint256 amount
143     ) internal virtual {
144         _allowances[owner][spender] = amount;
145         emit Approval(owner, spender, amount);
146     }
147 }
148  
149 library SafeMath {
150    
151     function add(uint256 a, uint256 b) internal pure returns(uint256) {
152         uint256 c = a + b;
153         require(c >= a, "SafeMath: addition overflow");
154 
155         return c;
156     }
157 
158     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
159         return sub(a, b, "SafeMath: subtraction overflow");
160     }
161 
162    
163     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
164         require(b <= a, errorMessage);
165         uint256 c = a - b;
166 
167         return c;
168     }
169 
170     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
171     
172         if (a == 0) {
173             return 0;
174         }
175  
176         uint256 c = a * b;
177         require(c / a == b, "SafeMath: multiplication overflow");
178 
179         return c;
180     }
181 
182     function div(uint256 a, uint256 b) internal pure returns(uint256) {
183         return div(a, b, "SafeMath: division by zero");
184     }
185   
186     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
187         require(b > 0, errorMessage);
188         uint256 c = a / b;
189 
190         return c;
191     }
192 }
193  
194 contract Ownable is Context {
195     address private _owner;
196  
197     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
198 
199     constructor() {
200         address msgSender = _msgSender();
201         _owner = msgSender;
202         emit OwnershipTransferred(address(0), msgSender);
203     }
204 
205     function owner() public view returns(address) {
206         return _owner;
207     }
208 
209     modifier onlyOwner() {
210         require(_owner == _msgSender(), "Ownable: caller is not the owner");
211         _;
212     }
213 
214     function renounceOwnership() public virtual onlyOwner {
215         emit OwnershipTransferred(_owner, address(0));
216         _owner = address(0);
217     }
218 
219     function transferOwnership(address newOwner) public virtual onlyOwner {
220         require(newOwner != address(0), "Ownable: new owner is the zero address");
221         emit OwnershipTransferred(_owner, newOwner);
222         _owner = newOwner;
223     }
224 }
225  
226 library SafeMathInt {
227     int256 private constant MIN_INT256 = int256(1) << 255;
228     int256 private constant MAX_INT256 = ~(int256(1) << 255);
229 
230     function mul(int256 a, int256 b) internal pure returns(int256) {
231         int256 c = a * b;
232 
233         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
234         require((b == 0) || (c / b == a));
235         return c;
236     }
237 
238     function div(int256 a, int256 b) internal pure returns(int256) {
239         require(b != -1 || a != MIN_INT256);
240 
241         return a / b;
242     }
243 
244     function sub(int256 a, int256 b) internal pure returns(int256) {
245         int256 c = a - b;
246         require((b >= 0 && c <= a) || (b < 0 && c > a));
247         return c;
248     }
249 
250     function add(int256 a, int256 b) internal pure returns(int256) {
251         int256 c = a + b;
252         require((b >= 0 && c >= a) || (b < 0 && c < a));
253         return c;
254     }
255 
256     function abs(int256 a) internal pure returns(int256) {
257         require(a != MIN_INT256);
258         return a < 0 ? -a : a;
259     }
260 
261     function toUint256Safe(int256 a) internal pure returns(uint256) {
262         require(a >= 0);
263         return uint256(a);
264     }
265 }
266  
267 library SafeMathUint {
268     function toInt256Safe(uint256 a) internal pure returns(int256) {
269     int256 b = int256(a);
270         require(b >= 0);
271         return b;
272     }
273 }
274 
275 interface IUniswapV2Router01 {
276     function factory() external pure returns(address);
277     function WETH() external pure returns(address);
278 
279     function addLiquidity(
280         address tokenA,
281         address tokenB,
282         uint amountADesired,
283         uint amountBDesired,
284         uint amountAMin,
285         uint amountBMin,
286         address to,
287         uint deadline
288     ) external returns(uint amountA, uint amountB, uint liquidity);
289     function addLiquidityETH(
290         address token,
291         uint amountTokenDesired,
292         uint amountTokenMin,
293         uint amountETHMin,
294         address to,
295         uint deadline
296     ) external payable returns(uint amountToken, uint amountETH, uint liquidity);
297     function removeLiquidity(
298         address tokenA,
299         address tokenB,
300         uint liquidity,
301         uint amountAMin,
302         uint amountBMin,
303         address to,
304         uint deadline
305     ) external returns(uint amountA, uint amountB);
306     function removeLiquidityETH(
307         address token,
308         uint liquidity,
309         uint amountTokenMin,
310         uint amountETHMin,
311         address to,
312         uint deadline
313     ) external returns(uint amountToken, uint amountETH);
314     function removeLiquidityWithPermit(
315         address tokenA,
316         address tokenB,
317         uint liquidity,
318         uint amountAMin,
319         uint amountBMin,
320         address to,
321         uint deadline,
322         bool approveMax, uint8 v, bytes32 r, bytes32 s
323     ) external returns(uint amountA, uint amountB);
324     function removeLiquidityETHWithPermit(
325         address token,
326         uint liquidity,
327         uint amountTokenMin,
328         uint amountETHMin,
329         address to,
330         uint deadline,
331         bool approveMax, uint8 v, bytes32 r, bytes32 s
332     ) external returns(uint amountToken, uint amountETH);
333     function swapExactTokensForTokens(
334         uint amountIn,
335         uint amountOutMin,
336         address[] calldata path,
337         address to,
338         uint deadline
339     ) external returns(uint[] memory amounts);
340     function swapTokensForExactTokens(
341         uint amountOut,
342         uint amountInMax,
343         address[] calldata path,
344         address to,
345         uint deadline
346     ) external returns(uint[] memory amounts);
347     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
348     external
349     payable
350     returns(uint[] memory amounts);
351     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
352     external
353     returns(uint[] memory amounts);
354     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
355     external
356     returns(uint[] memory amounts);
357     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
358     external
359     payable
360     returns(uint[] memory amounts);
361 
362     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns(uint amountB);
363     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns(uint amountOut);
364     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns(uint amountIn);
365     function getAmountsOut(uint amountIn, address[] calldata path) external view returns(uint[] memory amounts);
366     function getAmountsIn(uint amountOut, address[] calldata path) external view returns(uint[] memory amounts);
367 }
368 
369 interface IUniswapV2Router02 is IUniswapV2Router01 {
370     function removeLiquidityETHSupportingFeeOnTransferTokens(
371         address token,
372         uint liquidity,
373         uint amountTokenMin,
374         uint amountETHMin,
375         address to,
376         uint deadline
377     ) external returns(uint amountETH);
378     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
379         address token,
380         uint liquidity,
381         uint amountTokenMin,
382         uint amountETHMin,
383         address to,
384         uint deadline,
385         bool approveMax, uint8 v, bytes32 r, bytes32 s
386     ) external returns(uint amountETH);
387 
388     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
389         uint amountIn,
390         uint amountOutMin,
391         address[] calldata path,
392         address to,
393         uint deadline
394     ) external;
395     function swapExactETHForTokensSupportingFeeOnTransferTokens(
396         uint amountOutMin,
397         address[] calldata path,
398         address to,
399         uint deadline
400     ) external payable;
401     function swapExactTokensForETHSupportingFeeOnTransferTokens(
402         uint amountIn,
403         uint amountOutMin,
404         address[] calldata path,
405         address to,
406         uint deadline
407     ) external;
408 }
409  
410 contract OPALUS is ERC20, Ownable {
411     using SafeMath for uint256;
412 
413     IUniswapV2Router02 public immutable router;
414     address public immutable uniswapV2Pair;
415 
416     address private developmentWallet;
417     address private marketingWallet;
418 
419     uint256 private maxBuyAmount;
420     uint256 private maxSellAmount;   
421     uint256 private maxWalletAmount;
422  
423     uint256 private thresholdSwapAmount;
424 
425     bool private isTrading = false;
426     bool public swapEnabled = false;
427     bool public isSwapping;
428 
429     struct Fees {
430         uint256 buyTotalFees;
431         uint256 buyMarketingFee;
432         uint256 buyDevelopmentFee;
433         uint256 buyLiquidityFee;
434 
435         uint256 sellTotalFees;
436         uint256 sellMarketingFee;
437         uint256 sellDevelopmentFee;
438         uint256 sellLiquidityFee;
439     }  
440 
441     Fees public _fees = Fees({
442         buyTotalFees: 0,
443         buyMarketingFee: 0,
444         buyDevelopmentFee:0,
445         buyLiquidityFee: 0,
446 
447         sellTotalFees: 0,
448         sellMarketingFee: 0,
449         sellDevelopmentFee:0,
450         sellLiquidityFee: 0
451     });
452 
453     uint256 public tokensForMarketing;
454     uint256 public tokensForLiquidity;
455     uint256 public tokensForDevelopment;
456     uint256 private taxTill;
457 
458     mapping(address => bool) private _isExcludedFromFees;
459     mapping(address => bool) public _isExcludedMaxTransactionAmount;
460     mapping(address => bool) public _isExcludedMaxWalletAmount;
461     mapping(address => bool) public marketPair;
462  
463     event SwapAndLiquify(
464         uint256 tokensSwapped,
465         uint256 ethReceived
466     );
467 
468     constructor() ERC20("Light of the World", "OPALUS") {
469  
470         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
471 
472         uniswapV2Pair = IUniswapV2Factory(router.factory()).createPair(address(this), router.WETH());
473 
474         _isExcludedMaxTransactionAmount[address(router)] = true;
475         _isExcludedMaxTransactionAmount[address(uniswapV2Pair)] = true;        
476         _isExcludedMaxTransactionAmount[owner()] = true;
477         _isExcludedMaxTransactionAmount[address(this)] = true;
478         _isExcludedMaxTransactionAmount[address(0xdead)] = true;
479 
480         _isExcludedFromFees[owner()] = true;
481         _isExcludedFromFees[address(this)] = true;
482 
483         _isExcludedMaxWalletAmount[owner()] = true;
484         _isExcludedMaxWalletAmount[address(0xdead)] = true;
485         _isExcludedMaxWalletAmount[address(this)] = true;
486         _isExcludedMaxWalletAmount[address(uniswapV2Pair)] = true;
487 
488         marketPair[address(uniswapV2Pair)] = true;
489 
490         approve(address(router), type(uint256).max);
491 
492         uint256 totalSupply = 2e9 * 1e18;
493         maxBuyAmount = totalSupply * 1 / 100; 
494         maxSellAmount = totalSupply * 1 / 100; 
495         maxWalletAmount = totalSupply * 2 / 100; 
496         thresholdSwapAmount = totalSupply * 1 / 1000; 
497 
498         _fees.buyMarketingFee = 20;
499         _fees.buyLiquidityFee = 0;
500         _fees.buyDevelopmentFee = 0;
501         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevelopmentFee;
502 
503         _fees.sellMarketingFee = 40;
504         _fees.sellLiquidityFee = 0;
505         _fees.sellDevelopmentFee = 0;
506         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevelopmentFee;
507 
508         marketingWallet = address(0xF5982D4D33e50338d38389D1F63AcF87Fc3926B1);
509         developmentWallet = address(0xF5982D4D33e50338d38389D1F63AcF87Fc3926B1);
510 
511         /*
512             _mint is an internal function in ERC20.sol that is only called here,
513             and CANNOT be called ever again
514         */
515         _mint(msg.sender, totalSupply);
516     }
517 
518     receive() external payable {
519 
520     }
521 
522     function enableTrading() external onlyOwner {
523         isTrading = true;
524         swapEnabled = true;
525         taxTill = block.number + 0;
526     }
527 
528     function updateThresholdSwapAmount(uint256 newAmount) external onlyOwner returns(bool){
529         thresholdSwapAmount = newAmount;
530         return true;
531     }
532 
533     function updateMaxTxnAmount(uint256 newMaxBuy, uint256 newMaxSell) public onlyOwner {
534         maxBuyAmount = (totalSupply() * newMaxBuy) / 1000;
535         maxSellAmount = (totalSupply() * newMaxSell) / 1000;
536     }
537 
538     function updateMaxWalletAmount(uint256 newPercentage) public onlyOwner {
539         maxWalletAmount = (totalSupply() * newPercentage) / 1000;
540     }
541 
542     function toggleSwapEnabled(bool enabled) external onlyOwner(){
543         swapEnabled = enabled;
544     }
545 
546     function updateFees(uint256 _marketingFeeBuy, uint256 _liquidityFeeBuy,uint256 _developmentFeeBuy,uint256 _marketingFeeSell, uint256 _liquidityFeeSell,uint256 _developmentFeeSell) external onlyOwner{
547         _fees.buyMarketingFee = _marketingFeeBuy;
548         _fees.buyLiquidityFee = _liquidityFeeBuy;
549         _fees.buyDevelopmentFee = _developmentFeeBuy;
550         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevelopmentFee;
551 
552         _fees.sellMarketingFee = _marketingFeeSell;
553         _fees.sellLiquidityFee = _liquidityFeeSell;
554         _fees.sellDevelopmentFee = _developmentFeeSell;
555         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevelopmentFee;
556         require(_fees.buyTotalFees <= 40, "Must keep fees at 40% or less");   
557         require(_fees.sellTotalFees <= 40, "Must keep fees at 40% or less");
558     }
559     
560     function excludeFromFees(address account, bool excluded) public onlyOwner {
561         _isExcludedFromFees[account] = excluded;
562     }
563     function excludeFromWalletLimit(address account, bool excluded) public onlyOwner {
564         _isExcludedMaxWalletAmount[account] = excluded;
565     }
566     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
567         _isExcludedMaxTransactionAmount[updAds] = isEx;
568     }
569 
570     function removeLimits() external onlyOwner {
571         updateMaxTxnAmount(1000,1000);
572         updateMaxWalletAmount(1000);
573     }
574 
575     function setMarketPair(address pair, bool value) public onlyOwner {
576         require(pair != uniswapV2Pair, "The pair cannot be removed from marketPair");
577         marketPair[pair] = value;
578     }
579 
580     function setWallets(address _marketingWallet,address _developmentWallet) external onlyOwner{
581         marketingWallet = _marketingWallet;
582         developmentWallet = _developmentWallet;
583     }
584 
585     function isExcludedFromFees(address account) public view returns(bool) {
586         return _isExcludedFromFees[account];
587     }
588 
589     function _transfer(
590         address sender,
591         address recipient,
592         uint256 amount
593     ) internal override {
594         
595         if (amount == 0) {
596             super._transfer(sender, recipient, 0);
597             return;
598         }
599 
600         if (
601             sender != owner() &&
602             recipient != owner() &&
603             !isSwapping
604         ) {
605 
606             if (!isTrading) {
607                 require(_isExcludedFromFees[sender] || _isExcludedFromFees[recipient], "Trading is not active.");
608             }
609             if (marketPair[sender] && !_isExcludedMaxTransactionAmount[recipient]) {
610                 require(amount <= maxBuyAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
611             } 
612             else if (marketPair[recipient] && !_isExcludedMaxTransactionAmount[sender]) {
613                 require(amount <= maxSellAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
614             }
615 
616             if (!_isExcludedMaxWalletAmount[recipient]) {
617                 require(amount + balanceOf(recipient) <= maxWalletAmount, "Max wallet exceeded");
618             }
619         }
620  
621         uint256 contractTokenBalance = balanceOf(address(this));
622  
623         bool canSwap = contractTokenBalance >= thresholdSwapAmount;
624 
625         if (
626             canSwap &&
627             swapEnabled &&
628             !isSwapping &&
629             marketPair[recipient] &&
630             !_isExcludedFromFees[sender] &&
631             !_isExcludedFromFees[recipient]
632         ) {
633             isSwapping = true;
634             swapBack();
635             isSwapping = false;
636         }
637  
638         bool takeFee = !isSwapping;
639 
640         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
641             takeFee = false;
642         }
643  
644         if (takeFee) {
645             uint256 fees = 0;
646             if(block.number < taxTill) {
647                 fees = amount.mul(99).div(100);
648                 tokensForMarketing += (fees * 94) / 99;
649                 tokensForDevelopment += (fees * 5) / 99;
650             } else if (marketPair[recipient] && _fees.sellTotalFees > 0) {
651                 fees = amount.mul(_fees.sellTotalFees).div(100);
652                 tokensForLiquidity += fees * _fees.sellLiquidityFee / _fees.sellTotalFees;
653                 tokensForMarketing += fees * _fees.sellMarketingFee / _fees.sellTotalFees;
654                 tokensForDevelopment += fees * _fees.sellDevelopmentFee / _fees.sellTotalFees;
655             }
656             else if (marketPair[sender] && _fees.buyTotalFees > 0) {
657                 fees = amount.mul(_fees.buyTotalFees).div(100);
658                 tokensForLiquidity += fees * _fees.buyLiquidityFee / _fees.buyTotalFees;
659                 tokensForMarketing += fees * _fees.buyMarketingFee / _fees.buyTotalFees;
660                 tokensForDevelopment += fees * _fees.buyDevelopmentFee / _fees.buyTotalFees;
661             }
662 
663             if (fees > 0) {
664                 super._transfer(sender, address(this), fees);
665             }
666             amount -= fees;
667         }
668 
669         super._transfer(sender, recipient, amount);
670     }
671 
672     function swapTokensForEth(uint256 tAmount) private {
673 
674         address[] memory path = new address[](2);
675         path[0] = address(this);
676         path[1] = router.WETH();
677 
678         _approve(address(this), address(router), tAmount);
679 
680         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
681             tAmount,
682             0, 
683             path,
684             address(this),
685             block.timestamp
686         );
687 
688     }
689 
690     function addLiquidity(uint256 tAmount, uint256 ethAmount) private {
691         _approve(address(this), address(router), tAmount);
692 
693         router.addLiquidityETH{ value: ethAmount } (address(this), tAmount, 0, 0 , address(this), block.timestamp);
694     }
695 
696     function swapBack() private {
697         uint256 contractTokenBalance = balanceOf(address(this));
698         uint256 toSwap = tokensForLiquidity + tokensForMarketing + tokensForDevelopment;
699         bool success;
700 
701         if (contractTokenBalance == 0 || toSwap == 0) { return; }
702 
703         if (contractTokenBalance > thresholdSwapAmount * 20) {
704             contractTokenBalance = thresholdSwapAmount * 20;
705         }
706 
707         uint256 liquidityTokens = contractTokenBalance * tokensForLiquidity / toSwap / 2;
708         uint256 amountToSwapForETH = contractTokenBalance.sub(liquidityTokens);
709  
710         uint256 initialETHBalance = address(this).balance;
711 
712         swapTokensForEth(amountToSwapForETH); 
713  
714         uint256 newBalance = address(this).balance.sub(initialETHBalance);
715  
716         uint256 ethForMarketing = newBalance.mul(tokensForMarketing).div(toSwap);
717         uint256 ethForDevelopment = newBalance.mul(tokensForDevelopment).div(toSwap);
718         uint256 ethForLiquidity = newBalance - (ethForMarketing + ethForDevelopment);
719 
720         tokensForLiquidity = 0;
721         tokensForMarketing = 0;
722         tokensForDevelopment = 0;
723 
724         if (liquidityTokens > 0 && ethForLiquidity > 0) {
725             addLiquidity(liquidityTokens, ethForLiquidity);
726             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity);
727         }
728 
729         (success,) = address(developmentWallet).call{ value: (address(this).balance - ethForMarketing) } ("");
730         (success,) = address(marketingWallet).call{ value: address(this).balance } ("");
731     }
732 
733 }