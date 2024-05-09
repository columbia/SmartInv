1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.9;
3 
4 /*
5 Socials: https://t.me/ChoyCommunity
6 
7 Twitter: https://twitter.com/BokChoyToken
8 
9 Web:     https://bok-choy.club/
10 */
11 
12 interface IUniswapV2Factory {
13     function createPair(address tokenA, address tokenB) external returns(address pair);
14 }
15 
16 interface IERC20 {
17 
18     function totalSupply() external view returns(uint256);
19 
20     function balanceOf(address account) external view returns(uint256);
21 
22     function transfer(address recipient, uint256 amount) external returns(bool);
23 
24     function allowance(address owner, address spender) external view returns(uint256);
25 
26     function approve(address spender, uint256 amount) external returns(bool);
27 
28     function transferFrom(
29         address sender,
30         address recipient,
31         uint256 amount
32     ) external returns(bool);
33 
34         event Transfer(address indexed from, address indexed to, uint256 value);
35 
36         event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 interface IERC20Metadata is IERC20 {
40 
41     function name() external view returns(string memory);
42 
43     function symbol() external view returns(string memory);
44 
45     function decimals() external view returns(uint8);
46 }
47 
48 abstract contract Context {
49     function _msgSender() internal view virtual returns(address) {
50         return msg.sender;
51     }
52 
53 }
54 
55 contract ERC20 is Context, IERC20, IERC20Metadata {
56     using SafeMath for uint256;
57 
58         mapping(address => uint256) private _balances;
59 
60     mapping(address => mapping(address => uint256)) private _allowances;
61  
62     uint256 private _totalSupply;
63  
64     string private _name;
65     string private _symbol;
66 
67     constructor(string memory name_, string memory symbol_) {
68         _name = name_;
69         _symbol = symbol_;
70     }
71 
72     function name() public view virtual override returns(string memory) {
73         return _name;
74     }
75 
76     function symbol() public view virtual override returns(string memory) {
77         return _symbol;
78     }
79 
80     function decimals() public view virtual override returns(uint8) {
81         return 18;
82     }
83 
84     function totalSupply() public view virtual override returns(uint256) {
85         return _totalSupply;
86     }
87 
88     function balanceOf(address account) public view virtual override returns(uint256) {
89         return _balances[account];
90     }
91 
92     function transfer(address recipient, uint256 amount) public virtual override returns(bool) {
93         _transfer(_msgSender(), recipient, amount);
94         return true;
95     }
96 
97     function allowance(address owner, address spender) public view virtual override returns(uint256) {
98         return _allowances[owner][spender];
99     }
100 
101     function approve(address spender, uint256 amount) public virtual override returns(bool) {
102         _approve(_msgSender(), spender, amount);
103         return true;
104     }
105 
106     function transferFrom(
107         address sender,
108         address recipient,
109         uint256 amount
110     ) public virtual override returns(bool) {
111         _transfer(sender, recipient, amount);
112         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
113         return true;
114     }
115 
116     function increaseAllowance(address spender, uint256 addedValue) public virtual returns(bool) {
117         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
118         return true;
119     }
120 
121     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns(bool) {
122         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased cannot be below zero"));
123         return true;
124     }
125 
126     function _transfer(
127         address sender,
128         address recipient,
129         uint256 amount
130     ) internal virtual {
131         
132         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
133         _balances[recipient] = _balances[recipient].add(amount);
134         emit Transfer(sender, recipient, amount);
135     }
136 
137     function _mint(address account, uint256 amount) internal virtual {
138         require(account != address(0), "ERC20: mint to the zero address");
139 
140         _totalSupply = _totalSupply.add(amount);
141         _balances[account] = _balances[account].add(amount);
142         emit Transfer(address(0), account, amount);
143     }
144 
145     function _approve(
146         address owner,
147         address spender,
148         uint256 amount
149     ) internal virtual {
150         _allowances[owner][spender] = amount;
151         emit Approval(owner, spender, amount);
152     }
153     
154 }
155  
156 library SafeMath {
157    
158     function add(uint256 a, uint256 b) internal pure returns(uint256) {
159         uint256 c = a + b;
160         require(c >= a, "SafeMath: addition overflow");
161 
162         return c;
163     }
164    
165     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
166         return sub(a, b, "SafeMath: subtraction overflow");
167     }
168 
169     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
170         require(b <= a, errorMessage);
171         uint256 c = a - b;
172 
173         return c;
174     }
175 
176     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
177     
178         if (a == 0) {
179             return 0;
180         }
181  
182         uint256 c = a * b;
183         require(c / a == b, "SafeMath: multiplication overflow");
184 
185         return c;
186     }
187  
188     function div(uint256 a, uint256 b) internal pure returns(uint256) {
189         return div(a, b, "SafeMath: division by zero");
190     }
191   
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
193         require(b > 0, errorMessage);
194         uint256 c = a / b;
195 
196         return c;
197     }   
198 }
199  
200 contract Ownable is Context {
201     address private _owner;
202  
203     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
204 
205     constructor() {
206         address msgSender = _msgSender();
207         _owner = msgSender;
208         emit OwnershipTransferred(address(0), msgSender);
209     }
210 
211     function owner() public view returns(address) {
212         return _owner;
213     }
214 
215     modifier onlyOwner() {
216         require(_owner == _msgSender(), "Ownable: caller is not the owner");
217         _;
218     }
219 
220     function renounceOwnership() public virtual onlyOwner {
221         emit OwnershipTransferred(_owner, address(0));
222         _owner = address(0);
223     }
224 
225     function transferOwnership(address newOwner) public virtual onlyOwner {
226         require(newOwner != address(0), "Ownable: new owner is the zero address");
227         emit OwnershipTransferred(_owner, newOwner);
228         _owner = newOwner;
229     }
230 }
231  
232 library SafeMathInt {
233     int256 private constant MIN_INT256 = int256(1) << 255;
234     int256 private constant MAX_INT256 = ~(int256(1) << 255);
235 
236     function mul(int256 a, int256 b) internal pure returns(int256) {
237         int256 c = a * b;
238 
239         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
240         require((b == 0) || (c / b == a));
241         return c;
242     }
243 
244     function div(int256 a, int256 b) internal pure returns(int256) {
245         require(b != -1 || a != MIN_INT256);
246 
247         return a / b;
248     }
249 
250     function sub(int256 a, int256 b) internal pure returns(int256) {
251         int256 c = a - b;
252         require((b >= 0 && c <= a) || (b < 0 && c > a));
253         return c;
254     }
255 
256     function add(int256 a, int256 b) internal pure returns(int256) {
257         int256 c = a + b;
258         require((b >= 0 && c >= a) || (b < 0 && c < a));
259         return c;
260     }
261 
262     function abs(int256 a) internal pure returns(int256) {
263         require(a != MIN_INT256);
264         return a < 0 ? -a : a;
265     }
266 
267     function toUint256Safe(int256 a) internal pure returns(uint256) {
268         require(a >= 0);
269         return uint256(a);
270     }
271 }
272  
273 library SafeMathUint {
274     function toInt256Safe(uint256 a) internal pure returns(int256) {
275     int256 b = int256(a);
276         require(b >= 0);
277         return b;
278     }
279 }
280 
281 interface IUniswapV2Router01 {
282     function factory() external pure returns(address);
283     function WETH() external pure returns(address);
284 
285     function addLiquidity(
286         address tokenA,
287         address tokenB,
288         uint amountADesired,
289         uint amountBDesired,
290         uint amountAMin,
291         uint amountBMin,
292         address to,
293         uint deadline
294     ) external returns(uint amountA, uint amountB, uint liquidity);
295     function addLiquidityETH(
296         address token,
297         uint amountTokenDesired,
298         uint amountTokenMin,
299         uint amountETHMin,
300         address to,
301         uint deadline
302     ) external payable returns(uint amountToken, uint amountETH, uint liquidity);
303     function removeLiquidity(
304         address tokenA,
305         address tokenB,
306         uint liquidity,
307         uint amountAMin,
308         uint amountBMin,
309         address to,
310         uint deadline
311     ) external returns(uint amountA, uint amountB);
312     function removeLiquidityETH(
313         address token,
314         uint liquidity,
315         uint amountTokenMin,
316         uint amountETHMin,
317         address to,
318         uint deadline
319     ) external returns(uint amountToken, uint amountETH);
320     function removeLiquidityWithPermit(
321         address tokenA,
322         address tokenB,
323         uint liquidity,
324         uint amountAMin,
325         uint amountBMin,
326         address to,
327         uint deadline,
328         bool approveMax, uint8 v, bytes32 r, bytes32 s
329     ) external returns(uint amountA, uint amountB);
330     function removeLiquidityETHWithPermit(
331         address token,
332         uint liquidity,
333         uint amountTokenMin,
334         uint amountETHMin,
335         address to,
336         uint deadline,
337         bool approveMax, uint8 v, bytes32 r, bytes32 s
338     ) external returns(uint amountToken, uint amountETH);
339     function swapExactTokensForTokens(
340         uint amountIn,
341         uint amountOutMin,
342         address[] calldata path,
343         address to,
344         uint deadline
345     ) external returns(uint[] memory amounts);
346     function swapTokensForExactTokens(
347         uint amountOut,
348         uint amountInMax,
349         address[] calldata path,
350         address to,
351         uint deadline
352     ) external returns(uint[] memory amounts);
353     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
354     external
355     payable
356     returns(uint[] memory amounts);
357     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
358     external
359     returns(uint[] memory amounts);
360     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
361     external
362     returns(uint[] memory amounts);
363     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
364     external
365     payable
366     returns(uint[] memory amounts);
367 
368     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns(uint amountB);
369     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns(uint amountOut);
370     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns(uint amountIn);
371     function getAmountsOut(uint amountIn, address[] calldata path) external view returns(uint[] memory amounts);
372     function getAmountsIn(uint amountOut, address[] calldata path) external view returns(uint[] memory amounts);
373 }
374 
375 interface IUniswapV2Router02 is IUniswapV2Router01 {
376     function removeLiquidityETHSupportingFeeOnTransferTokens(
377         address token,
378         uint liquidity,
379         uint amountTokenMin,
380         uint amountETHMin,
381         address to,
382         uint deadline
383     ) external returns(uint amountETH);
384     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
385         address token,
386         uint liquidity,
387         uint amountTokenMin,
388         uint amountETHMin,
389         address to,
390         uint deadline,
391         bool approveMax, uint8 v, bytes32 r, bytes32 s
392     ) external returns(uint amountETH);
393 
394     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
395         uint amountIn,
396         uint amountOutMin,
397         address[] calldata path,
398         address to,
399         uint deadline
400     ) external;
401     function swapExactETHForTokensSupportingFeeOnTransferTokens(
402         uint amountOutMin,
403         address[] calldata path,
404         address to,
405         uint deadline
406     ) external payable;
407     function swapExactTokensForETHSupportingFeeOnTransferTokens(
408         uint amountIn,
409         uint amountOutMin,
410         address[] calldata path,
411         address to,
412         uint deadline
413     ) external;
414 }
415  
416 contract BOKCHOY is ERC20, Ownable {
417     using SafeMath for uint256;
418 
419     IUniswapV2Router02 public immutable router;
420     address public immutable uniswapV2Pair;
421 
422     // addresses
423     address private developmentWallet;
424     address private marketingWallet;
425 
426     // limits 
427     uint256 private maxBuyAmount;
428     uint256 private maxSellAmount;   
429     uint256 private maxWalletAmount;
430  
431     uint256 private thresholdSwapAmount;
432 
433     // status flags
434     bool private isTrading = false;
435     bool public swapEnabled = false;
436     bool public isSwapping;
437 
438     struct Fees {
439         uint256 buyTotalFees;
440         uint256 buyMarketingFee;
441         uint256 buyDevelopmentFee;
442         uint256 buyLiquidityFee;
443 
444         uint256 sellTotalFees;
445         uint256 sellMarketingFee;
446         uint256 sellDevelopmentFee;
447         uint256 sellLiquidityFee;
448     }  
449 
450     Fees public _fees = Fees({
451         buyTotalFees: 0,
452         buyMarketingFee: 0,
453         buyDevelopmentFee:0,
454         buyLiquidityFee: 0,
455 
456         sellTotalFees: 0,
457         sellMarketingFee: 0,
458         sellDevelopmentFee:0,
459         sellLiquidityFee: 0
460     });
461 
462     uint256 public tokensForMarketing;
463     uint256 public tokensForLiquidity;
464     uint256 public tokensForDevelopment;
465     uint256 private taxTill;
466 
467     mapping(address => bool) private _isExcludedFromFees;
468     mapping(address => bool) public _isExcludedMaxTransactionAmount;
469     mapping(address => bool) public _isExcludedMaxWalletAmount;
470 
471     mapping(address => bool) public marketPair;
472  
473   
474     event SwapAndLiquify(
475         uint256 tokensSwapped,
476         uint256 ethReceived
477     );
478 
479     constructor() ERC20("BOK CHOY", "CHOY") {
480  
481         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
482 
483         uniswapV2Pair = IUniswapV2Factory(router.factory()).createPair(address(this), router.WETH());
484 
485         _isExcludedMaxTransactionAmount[address(router)] = true;
486         _isExcludedMaxTransactionAmount[address(uniswapV2Pair)] = true;        
487         _isExcludedMaxTransactionAmount[owner()] = true;
488         _isExcludedMaxTransactionAmount[address(this)] = true;
489         _isExcludedMaxTransactionAmount[address(0xdead)] = true;
490 
491         _isExcludedFromFees[owner()] = true;
492         _isExcludedFromFees[address(this)] = true;
493 
494         _isExcludedMaxWalletAmount[owner()] = true;
495         _isExcludedMaxWalletAmount[address(0xdead)] = true;
496         _isExcludedMaxWalletAmount[address(this)] = true;
497         _isExcludedMaxWalletAmount[address(uniswapV2Pair)] = true;
498 
499         marketPair[address(uniswapV2Pair)] = true;
500 
501         approve(address(router), type(uint256).max);
502 
503         uint256 totalSupply = 5e9 * 1e18;
504         maxBuyAmount = totalSupply * 1 / 100; // 1% maxBuyAmount
505         maxSellAmount = totalSupply * 1 / 100; // 1% maxSellAmount
506         maxWalletAmount = totalSupply * 1 / 100; // 1% maxWallet
507         thresholdSwapAmount = totalSupply * 1 / 1000; 
508 
509         _fees.buyMarketingFee = 20;
510         _fees.buyLiquidityFee = 0;
511         _fees.buyDevelopmentFee = 0;
512         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevelopmentFee;
513 
514         _fees.sellMarketingFee = 30;
515         _fees.sellLiquidityFee = 0;
516         _fees.sellDevelopmentFee = 0;
517         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevelopmentFee;
518 
519         marketingWallet = address(0x332CEB38A8514eEc47f95fB91854C297Cb106158);
520         developmentWallet = address(0x332CEB38A8514eEc47f95fB91854C297Cb106158);
521 
522         /*
523             _mint is an internal function in ERC20.sol that is only called here,
524             and CANNOT be called ever again
525         */
526         _mint(msg.sender, totalSupply);
527     }
528 
529     receive() external payable {
530 
531     }
532 
533     // once enabled, can never be turned off
534     function enableTrading() external onlyOwner {
535         isTrading = true;
536         swapEnabled = true;
537         taxTill = block.number + 0;
538     }
539 
540     // change the minimum amount of tokens to sell from fees
541     function updateThresholdSwapAmount(uint256 newAmount) external onlyOwner returns(bool){
542         thresholdSwapAmount = newAmount;
543         return true;
544     }
545 
546     function updateMaxTxnAmount(uint256 newMaxBuy, uint256 newMaxSell) public onlyOwner {
547         maxBuyAmount = (totalSupply() * newMaxBuy) / 1000;
548         maxSellAmount = (totalSupply() * newMaxSell) / 1000;
549     }
550 
551     function updateMaxWalletAmount(uint256 newPercentage) public onlyOwner {
552         maxWalletAmount = (totalSupply() * newPercentage) / 1000;
553     }
554 
555     // only use to disable contract sales if absolutely necessary (emergency use only)
556     function toggleSwapEnabled(bool enabled) external onlyOwner(){
557         swapEnabled = enabled;
558     }
559 
560     function updateFees(uint256 _marketingFeeBuy, uint256 _liquidityFeeBuy,uint256 _developmentFeeBuy,uint256 _marketingFeeSell, uint256 _liquidityFeeSell,uint256 _developmentFeeSell) external onlyOwner{
561         _fees.buyMarketingFee = _marketingFeeBuy;
562         _fees.buyLiquidityFee = _liquidityFeeBuy;
563         _fees.buyDevelopmentFee = _developmentFeeBuy;
564         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevelopmentFee;
565 
566         _fees.sellMarketingFee = _marketingFeeSell;
567         _fees.sellLiquidityFee = _liquidityFeeSell;
568         _fees.sellDevelopmentFee = _developmentFeeSell;
569         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevelopmentFee;
570         require(_fees.buyTotalFees <= 70, "Must keep fees at 70% or less");   
571         require(_fees.sellTotalFees <= 70, "Must keep fees at 70% or less");
572     }
573     
574     function excludeFromFees(address account, bool excluded) public onlyOwner {
575         _isExcludedFromFees[account] = excluded;
576     }
577     function excludeFromWalletLimit(address account, bool excluded) public onlyOwner {
578         _isExcludedMaxWalletAmount[account] = excluded;
579     }
580     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
581         _isExcludedMaxTransactionAmount[updAds] = isEx;
582     }
583 
584     function removeLimits() external onlyOwner {
585         updateMaxTxnAmount(1000,1000);
586         updateMaxWalletAmount(1000);
587     }
588 
589     function setMarketPair(address pair, bool value) public onlyOwner {
590         require(pair != uniswapV2Pair, "The pair cannot be removed from marketPair");
591         marketPair[pair] = value;
592     }
593 
594     function setWallets(address _marketingWallet,address _developmentWallet) external onlyOwner{
595         marketingWallet = _marketingWallet;
596         developmentWallet = _developmentWallet;
597     }
598 
599     function isExcludedFromFees(address account) public view returns(bool) {
600         return _isExcludedFromFees[account];
601     }
602 
603     function _transfer(
604         address sender,
605         address recipient,
606         uint256 amount
607     ) internal override {
608         
609         if (amount == 0) {
610             super._transfer(sender, recipient, 0);
611             return;
612         }
613 
614         if (
615             sender != owner() &&
616             recipient != owner() &&
617             !isSwapping
618         ) {
619 
620             if (!isTrading) {
621                 require(_isExcludedFromFees[sender] || _isExcludedFromFees[recipient], "Trading is not active.");
622             }
623             if (marketPair[sender] && !_isExcludedMaxTransactionAmount[recipient]) {
624                 require(amount <= maxBuyAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
625             } 
626             else if (marketPair[recipient] && !_isExcludedMaxTransactionAmount[sender]) {
627                 require(amount <= maxSellAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
628             }
629 
630             if (!_isExcludedMaxWalletAmount[recipient]) {
631                 require(amount + balanceOf(recipient) <= maxWalletAmount, "Max wallet exceeded");
632             }
633 
634         }
635  
636         uint256 contractTokenBalance = balanceOf(address(this));
637  
638         bool canSwap = contractTokenBalance >= thresholdSwapAmount;
639 
640         if (
641             canSwap &&
642             swapEnabled &&
643             !isSwapping &&
644             marketPair[recipient] &&
645             !_isExcludedFromFees[sender] &&
646             !_isExcludedFromFees[recipient]
647         ) {
648             isSwapping = true;
649             swapBack();
650             isSwapping = false;
651         }
652  
653         bool takeFee = !isSwapping;
654 
655         // if any account belongs to _isExcludedFromFee account then remove the fee
656         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
657             takeFee = false;
658         }
659  
660         
661         // only take fees on buys/sells, do not take on wallet transfers
662         if (takeFee) {
663             uint256 fees = 0;
664             if(block.number < taxTill) {
665                 fees = amount.mul(99).div(100);
666                 tokensForMarketing += (fees * 94) / 99;
667                 tokensForDevelopment += (fees * 5) / 99;
668             } else if (marketPair[recipient] && _fees.sellTotalFees > 0) {
669                 fees = amount.mul(_fees.sellTotalFees).div(100);
670                 tokensForLiquidity += fees * _fees.sellLiquidityFee / _fees.sellTotalFees;
671                 tokensForMarketing += fees * _fees.sellMarketingFee / _fees.sellTotalFees;
672                 tokensForDevelopment += fees * _fees.sellDevelopmentFee / _fees.sellTotalFees;
673             }
674             // on buy
675             else if (marketPair[sender] && _fees.buyTotalFees > 0) {
676                 fees = amount.mul(_fees.buyTotalFees).div(100);
677                 tokensForLiquidity += fees * _fees.buyLiquidityFee / _fees.buyTotalFees;
678                 tokensForMarketing += fees * _fees.buyMarketingFee / _fees.buyTotalFees;
679                 tokensForDevelopment += fees * _fees.buyDevelopmentFee / _fees.buyTotalFees;
680             }
681 
682             if (fees > 0) {
683                 super._transfer(sender, address(this), fees);
684             }
685 
686             amount -= fees;
687 
688         }
689 
690         super._transfer(sender, recipient, amount);
691     }
692 
693     function swapTokensForEth(uint256 tAmount) private {
694 
695         // generate the uniswap pair path of token -> weth
696         address[] memory path = new address[](2);
697         path[0] = address(this);
698         path[1] = router.WETH();
699 
700         _approve(address(this), address(router), tAmount);
701 
702         // make the swap
703         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
704             tAmount,
705             0, // accept any amount of ETH
706             path,
707             address(this),
708             block.timestamp
709         );
710 
711     }
712 
713     function addLiquidity(uint256 tAmount, uint256 ethAmount) private {
714         // approve token transfer to cover all possible scenarios
715         _approve(address(this), address(router), tAmount);
716 
717         // add the liquidity
718         router.addLiquidityETH{ value: ethAmount } (address(this), tAmount, 0, 0 , address(this), block.timestamp);
719     }
720 
721     function swapBack() private {
722         uint256 contractTokenBalance = balanceOf(address(this));
723         uint256 toSwap = tokensForLiquidity + tokensForMarketing + tokensForDevelopment;
724         bool success;
725 
726         if (contractTokenBalance == 0 || toSwap == 0) { return; }
727 
728         if (contractTokenBalance > thresholdSwapAmount * 20) {
729             contractTokenBalance = thresholdSwapAmount * 20;
730         }
731 
732         // Halve the amount of liquidity tokens
733         uint256 liquidityTokens = contractTokenBalance * tokensForLiquidity / toSwap / 2;
734         uint256 amountToSwapForETH = contractTokenBalance.sub(liquidityTokens);
735  
736         uint256 initialETHBalance = address(this).balance;
737 
738         swapTokensForEth(amountToSwapForETH); 
739  
740         uint256 newBalance = address(this).balance.sub(initialETHBalance);
741  
742         uint256 ethForMarketing = newBalance.mul(tokensForMarketing).div(toSwap);
743         uint256 ethForDevelopment = newBalance.mul(tokensForDevelopment).div(toSwap);
744         uint256 ethForLiquidity = newBalance - (ethForMarketing + ethForDevelopment);
745 
746 
747         tokensForLiquidity = 0;
748         tokensForMarketing = 0;
749         tokensForDevelopment = 0;
750 
751 
752         if (liquidityTokens > 0 && ethForLiquidity > 0) {
753             addLiquidity(liquidityTokens, ethForLiquidity);
754             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity);
755         }
756 
757         (success,) = address(developmentWallet).call{ value: (address(this).balance - ethForMarketing) } ("");
758         (success,) = address(marketingWallet).call{ value: address(this).balance } ("");
759     }
760 
761 }