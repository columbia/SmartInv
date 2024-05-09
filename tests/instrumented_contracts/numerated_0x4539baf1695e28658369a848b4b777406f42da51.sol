1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.9;
3 
4 /*
5     ███╗░░██╗  ░█████╗░  ░██████╗  ░█████╗░
6     ████╗░██║  ██╔══██╗  ██╔════╝  ██╔══██╗
7     ██╔██╗██║  ███████║  ╚█████╗░  ██║░░╚═╝
8     ██║╚████║  ██╔══██║  ░╚═══██╗  ██║░░██╗
9     ██║░╚███║  ██║░░██║  ██████╔╝  ╚█████╔╝
10     ╚═╝░░╚══╝  ╚═╝░░╚═╝  ╚═════╝░  ░╚════╝░
11 
12     ※ https://www.not-a-security.org
13     ※ https://t.me/NASCPORTAL
14     ※ https://twitter.com/NASC_Foundation
15 */
16 
17 interface IUniswapV2Factory {
18     function createPair(address tokenA, address tokenB) external returns(address pair);
19 }
20 
21 interface IERC20 {
22 
23     function totalSupply() external view returns(uint256);
24     function balanceOf(address account) external view returns(uint256);
25     function transfer(address recipient, uint256 amount) external returns(bool);
26     function allowance(address owner, address spender) external view returns(uint256);
27     function approve(address spender, uint256 amount) external returns(bool);
28 
29     function transferFrom(
30         address sender,
31         address recipient,
32         uint256 amount
33     ) external returns(bool);
34 
35         event Transfer(address indexed from, address indexed to, uint256 value);
36         event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 interface IERC20Metadata is IERC20 {
40 
41     function name() external view returns(string memory);
42     function symbol() external view returns(string memory);
43     function decimals() external view returns(uint8);
44 }
45 
46 abstract contract Context {
47     function _msgSender() internal view virtual returns(address) {
48         return msg.sender;
49     }
50 }
51 
52 contract ERC20 is Context, IERC20, IERC20Metadata {
53     using SafeMath for uint256;
54 
55         mapping(address => uint256) private _balances;
56 
57     mapping(address => mapping(address => uint256)) private _allowances;
58  
59     uint256 private _totalSupply;
60  
61     string private _name;
62     string private _symbol;
63 
64     constructor(string memory name_, string memory symbol_) {
65         _name = name_;
66         _symbol = symbol_;
67     }
68 
69     function name() public view virtual override returns(string memory) {
70         return _name;
71     }
72 
73     function symbol() public view virtual override returns(string memory) {
74         return _symbol;
75     }
76 
77     function decimals() public view virtual override returns(uint8) {
78         return 18;
79     }
80 
81     function totalSupply() public view virtual override returns(uint256) {
82         return _totalSupply;
83     }
84 
85     function balanceOf(address account) public view virtual override returns(uint256) {
86         return _balances[account];
87     }
88 
89     function transfer(address recipient, uint256 amount) public virtual override returns(bool) {
90         _transfer(_msgSender(), recipient, amount);
91         return true;
92     }
93 
94     function allowance(address owner, address spender) public view virtual override returns(uint256) {
95         return _allowances[owner][spender];
96     }
97 
98     function approve(address spender, uint256 amount) public virtual override returns(bool) {
99         _approve(_msgSender(), spender, amount);
100         return true;
101     }
102 
103     function transferFrom(
104         address sender,
105         address recipient,
106         uint256 amount
107     ) public virtual override returns(bool) {
108         _transfer(sender, recipient, amount);
109         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
110         return true;
111     }
112 
113     function increaseAllowance(address spender, uint256 addedValue) public virtual returns(bool) {
114         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
115         return true;
116     }
117 
118     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns(bool) {
119         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased cannot be below zero"));
120         return true;
121     }
122 
123     function _transfer(
124         address sender,
125         address recipient,
126         uint256 amount
127     ) internal virtual {
128         
129         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
130         _balances[recipient] = _balances[recipient].add(amount);
131         emit Transfer(sender, recipient, amount);
132     }
133 
134     function _mint(address account, uint256 amount) internal virtual {
135         require(account != address(0), "ERC20: mint to the zero address");
136 
137         _totalSupply = _totalSupply.add(amount);
138         _balances[account] = _balances[account].add(amount);
139         emit Transfer(address(0), account, amount);
140     }
141 
142     function _approve(
143         address owner,
144         address spender,
145         uint256 amount
146     ) internal virtual {
147         _allowances[owner][spender] = amount;
148         emit Approval(owner, spender, amount);
149     }
150 }
151  
152 library SafeMath {
153    
154     function add(uint256 a, uint256 b) internal pure returns(uint256) {
155         uint256 c = a + b;
156         require(c >= a, "SafeMath: addition overflow");
157 
158         return c;
159     }
160 
161     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
162         return sub(a, b, "SafeMath: subtraction overflow");
163     }
164 
165    
166     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
167         require(b <= a, errorMessage);
168         uint256 c = a - b;
169 
170         return c;
171     }
172 
173     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
174     
175         if (a == 0) {
176             return 0;
177         }
178  
179         uint256 c = a * b;
180         require(c / a == b, "SafeMath: multiplication overflow");
181 
182         return c;
183     }
184 
185     function div(uint256 a, uint256 b) internal pure returns(uint256) {
186         return div(a, b, "SafeMath: division by zero");
187     }
188   
189     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
190         require(b > 0, errorMessage);
191         uint256 c = a / b;
192 
193         return c;
194     }
195 }
196  
197 contract Ownable is Context {
198     address private _owner;
199  
200     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
201 
202     constructor() {
203         address msgSender = _msgSender();
204         _owner = msgSender;
205         emit OwnershipTransferred(address(0), msgSender);
206     }
207 
208     function owner() public view returns(address) {
209         return _owner;
210     }
211 
212     modifier onlyOwner() {
213         require(_owner == _msgSender(), "Ownable: caller is not the owner");
214         _;
215     }
216 
217     function renounceOwnership() public virtual onlyOwner {
218         emit OwnershipTransferred(_owner, address(0));
219         _owner = address(0);
220     }
221 
222     function transferOwnership(address newOwner) public virtual onlyOwner {
223         require(newOwner != address(0), "Ownable: new owner is the zero address");
224         emit OwnershipTransferred(_owner, newOwner);
225         _owner = newOwner;
226     }
227 }
228  
229 library SafeMathInt {
230     int256 private constant MIN_INT256 = int256(1) << 255;
231     int256 private constant MAX_INT256 = ~(int256(1) << 255);
232 
233     function mul(int256 a, int256 b) internal pure returns(int256) {
234         int256 c = a * b;
235 
236         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
237         require((b == 0) || (c / b == a));
238         return c;
239     }
240 
241     function div(int256 a, int256 b) internal pure returns(int256) {
242         require(b != -1 || a != MIN_INT256);
243 
244         return a / b;
245     }
246 
247     function sub(int256 a, int256 b) internal pure returns(int256) {
248         int256 c = a - b;
249         require((b >= 0 && c <= a) || (b < 0 && c > a));
250         return c;
251     }
252 
253     function add(int256 a, int256 b) internal pure returns(int256) {
254         int256 c = a + b;
255         require((b >= 0 && c >= a) || (b < 0 && c < a));
256         return c;
257     }
258 
259     function abs(int256 a) internal pure returns(int256) {
260         require(a != MIN_INT256);
261         return a < 0 ? -a : a;
262     }
263 
264     function toUint256Safe(int256 a) internal pure returns(uint256) {
265         require(a >= 0);
266         return uint256(a);
267     }
268 }
269  
270 library SafeMathUint {
271     function toInt256Safe(uint256 a) internal pure returns(int256) {
272     int256 b = int256(a);
273         require(b >= 0);
274         return b;
275     }
276 }
277 
278 interface IUniswapV2Router01 {
279     function factory() external pure returns(address);
280     function WETH() external pure returns(address);
281 
282     function addLiquidity(
283         address tokenA,
284         address tokenB,
285         uint amountADesired,
286         uint amountBDesired,
287         uint amountAMin,
288         uint amountBMin,
289         address to,
290         uint deadline
291     ) external returns(uint amountA, uint amountB, uint liquidity);
292     function addLiquidityETH(
293         address token,
294         uint amountTokenDesired,
295         uint amountTokenMin,
296         uint amountETHMin,
297         address to,
298         uint deadline
299     ) external payable returns(uint amountToken, uint amountETH, uint liquidity);
300     function removeLiquidity(
301         address tokenA,
302         address tokenB,
303         uint liquidity,
304         uint amountAMin,
305         uint amountBMin,
306         address to,
307         uint deadline
308     ) external returns(uint amountA, uint amountB);
309     function removeLiquidityETH(
310         address token,
311         uint liquidity,
312         uint amountTokenMin,
313         uint amountETHMin,
314         address to,
315         uint deadline
316     ) external returns(uint amountToken, uint amountETH);
317     function removeLiquidityWithPermit(
318         address tokenA,
319         address tokenB,
320         uint liquidity,
321         uint amountAMin,
322         uint amountBMin,
323         address to,
324         uint deadline,
325         bool approveMax, uint8 v, bytes32 r, bytes32 s
326     ) external returns(uint amountA, uint amountB);
327     function removeLiquidityETHWithPermit(
328         address token,
329         uint liquidity,
330         uint amountTokenMin,
331         uint amountETHMin,
332         address to,
333         uint deadline,
334         bool approveMax, uint8 v, bytes32 r, bytes32 s
335     ) external returns(uint amountToken, uint amountETH);
336     function swapExactTokensForTokens(
337         uint amountIn,
338         uint amountOutMin,
339         address[] calldata path,
340         address to,
341         uint deadline
342     ) external returns(uint[] memory amounts);
343     function swapTokensForExactTokens(
344         uint amountOut,
345         uint amountInMax,
346         address[] calldata path,
347         address to,
348         uint deadline
349     ) external returns(uint[] memory amounts);
350     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
351     external
352     payable
353     returns(uint[] memory amounts);
354     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
355     external
356     returns(uint[] memory amounts);
357     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
358     external
359     returns(uint[] memory amounts);
360     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
361     external
362     payable
363     returns(uint[] memory amounts);
364 
365     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns(uint amountB);
366     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns(uint amountOut);
367     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns(uint amountIn);
368     function getAmountsOut(uint amountIn, address[] calldata path) external view returns(uint[] memory amounts);
369     function getAmountsIn(uint amountOut, address[] calldata path) external view returns(uint[] memory amounts);
370 }
371 
372 interface IUniswapV2Router02 is IUniswapV2Router01 {
373     function removeLiquidityETHSupportingFeeOnTransferTokens(
374         address token,
375         uint liquidity,
376         uint amountTokenMin,
377         uint amountETHMin,
378         address to,
379         uint deadline
380     ) external returns(uint amountETH);
381     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
382         address token,
383         uint liquidity,
384         uint amountTokenMin,
385         uint amountETHMin,
386         address to,
387         uint deadline,
388         bool approveMax, uint8 v, bytes32 r, bytes32 s
389     ) external returns(uint amountETH);
390 
391     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
392         uint amountIn,
393         uint amountOutMin,
394         address[] calldata path,
395         address to,
396         uint deadline
397     ) external;
398     function swapExactETHForTokensSupportingFeeOnTransferTokens(
399         uint amountOutMin,
400         address[] calldata path,
401         address to,
402         uint deadline
403     ) external payable;
404     function swapExactTokensForETHSupportingFeeOnTransferTokens(
405         uint amountIn,
406         uint amountOutMin,
407         address[] calldata path,
408         address to,
409         uint deadline
410     ) external;
411 }
412  
413 contract NASC is ERC20, Ownable {
414     using SafeMath for uint256;
415 
416     IUniswapV2Router02 public immutable router;
417     address public immutable uniswapV2Pair;
418 
419     address private developmentWallet;
420     address private marketingWallet;
421 
422     uint256 private maxBuyAmount;
423     uint256 private maxSellAmount;   
424     uint256 private maxWalletAmount;
425  
426     uint256 private thresholdSwapAmount;
427 
428     bool private isTrading = false;
429     bool public swapEnabled = false;
430     bool public isSwapping;
431 
432     struct Fees {
433         uint256 buyTotalFees;
434         uint256 buyMarketingFee;
435         uint256 buyDevelopmentFee;
436         uint256 buyLiquidityFee;
437 
438         uint256 sellTotalFees;
439         uint256 sellMarketingFee;
440         uint256 sellDevelopmentFee;
441         uint256 sellLiquidityFee;
442     }  
443 
444     Fees public _fees = Fees({
445         buyTotalFees: 0,
446         buyMarketingFee: 0,
447         buyDevelopmentFee:0,
448         buyLiquidityFee: 0,
449 
450         sellTotalFees: 0,
451         sellMarketingFee: 0,
452         sellDevelopmentFee:0,
453         sellLiquidityFee: 0
454     });
455 
456     uint256 public tokensForMarketing;
457     uint256 public tokensForLiquidity;
458     uint256 public tokensForDevelopment;
459     uint256 private taxTill;
460 
461     mapping(address => bool) private _isExcludedFromFees;
462     mapping(address => bool) public _isExcludedMaxTransactionAmount;
463     mapping(address => bool) public _isExcludedMaxWalletAmount;
464     mapping(address => bool) public marketPair;
465  
466     event SwapAndLiquify(
467         uint256 tokensSwapped,
468         uint256 ethReceived
469     );
470 
471     constructor() ERC20("Not A Security Coin", "NASC") {
472  
473         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
474 
475         uniswapV2Pair = IUniswapV2Factory(router.factory()).createPair(address(this), router.WETH());
476 
477         _isExcludedMaxTransactionAmount[address(router)] = true;
478         _isExcludedMaxTransactionAmount[address(uniswapV2Pair)] = true;        
479         _isExcludedMaxTransactionAmount[owner()] = true;
480         _isExcludedMaxTransactionAmount[address(this)] = true;
481         _isExcludedMaxTransactionAmount[address(0xdead)] = true;
482 
483         _isExcludedFromFees[owner()] = true;
484         _isExcludedFromFees[address(this)] = true;
485 
486         _isExcludedMaxWalletAmount[owner()] = true;
487         _isExcludedMaxWalletAmount[address(0xdead)] = true;
488         _isExcludedMaxWalletAmount[address(this)] = true;
489         _isExcludedMaxWalletAmount[address(uniswapV2Pair)] = true;
490 
491         marketPair[address(uniswapV2Pair)] = true;
492 
493         approve(address(router), type(uint256).max);
494 
495         uint256 totalSupply = 5e8 * 1e18;
496         maxBuyAmount = totalSupply * 1 / 100; 
497         maxSellAmount = totalSupply * 1 / 100; 
498         maxWalletAmount = totalSupply * 1 / 100; 
499         thresholdSwapAmount = totalSupply * 1 / 1000; 
500 
501         _fees.buyMarketingFee = 40;
502         _fees.buyLiquidityFee = 0;
503         _fees.buyDevelopmentFee = 0;
504         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevelopmentFee;
505 
506         _fees.sellMarketingFee = 20;
507         _fees.sellLiquidityFee = 0;
508         _fees.sellDevelopmentFee = 0;
509         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevelopmentFee;
510 
511         marketingWallet = address(0x2918A5F775be40dc76CBB7FB60d2d61333596952);
512         developmentWallet = address(0x2918A5F775be40dc76CBB7FB60d2d61333596952);
513 
514         /*
515             _mint is an internal function in ERC20.sol that is only called here,
516             and CANNOT be called ever again
517         */
518         _mint(msg.sender, totalSupply);
519     }
520 
521     receive() external payable {
522 
523     }
524 
525     function enableTrading() external onlyOwner {
526         isTrading = true;
527         swapEnabled = true;
528         taxTill = block.number + 0;
529     }
530 
531     function updateThresholdSwapAmount(uint256 newAmount) external onlyOwner returns(bool){
532         thresholdSwapAmount = newAmount;
533         return true;
534     }
535 
536     function updateMaxTxnAmount(uint256 newMaxBuy, uint256 newMaxSell) public onlyOwner {
537         maxBuyAmount = (totalSupply() * newMaxBuy) / 1000;
538         maxSellAmount = (totalSupply() * newMaxSell) / 1000;
539     }
540 
541     function updateMaxWalletAmount(uint256 newPercentage) public onlyOwner {
542         maxWalletAmount = (totalSupply() * newPercentage) / 1000;
543     }
544 
545     function toggleSwapEnabled(bool enabled) external onlyOwner(){
546         swapEnabled = enabled;
547     }
548 
549     function updateFees(uint256 _marketingFeeBuy, uint256 _liquidityFeeBuy,uint256 _developmentFeeBuy,uint256 _marketingFeeSell, uint256 _liquidityFeeSell,uint256 _developmentFeeSell) external onlyOwner{
550         _fees.buyMarketingFee = _marketingFeeBuy;
551         _fees.buyLiquidityFee = _liquidityFeeBuy;
552         _fees.buyDevelopmentFee = _developmentFeeBuy;
553         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevelopmentFee;
554 
555         _fees.sellMarketingFee = _marketingFeeSell;
556         _fees.sellLiquidityFee = _liquidityFeeSell;
557         _fees.sellDevelopmentFee = _developmentFeeSell;
558         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevelopmentFee;
559         require(_fees.buyTotalFees <= 69, "Must keep fees at 69% or less");   
560         require(_fees.sellTotalFees <= 69, "Must keep fees at 69% or less");
561     }
562     
563     function excludeFromFees(address account, bool excluded) public onlyOwner {
564         _isExcludedFromFees[account] = excluded;
565     }
566     function excludeFromWalletLimit(address account, bool excluded) public onlyOwner {
567         _isExcludedMaxWalletAmount[account] = excluded;
568     }
569     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
570         _isExcludedMaxTransactionAmount[updAds] = isEx;
571     }
572 
573     function removeLimits() external onlyOwner {
574         updateMaxTxnAmount(1000,1000);
575         updateMaxWalletAmount(1000);
576     }
577 
578     function setMarketPair(address pair, bool value) public onlyOwner {
579         require(pair != uniswapV2Pair, "The pair cannot be removed from marketPair");
580         marketPair[pair] = value;
581     }
582 
583     function setWallets(address _marketingWallet,address _developmentWallet) external onlyOwner{
584         marketingWallet = _marketingWallet;
585         developmentWallet = _developmentWallet;
586     }
587 
588     function isExcludedFromFees(address account) public view returns(bool) {
589         return _isExcludedFromFees[account];
590     }
591 
592     function _transfer(
593         address sender,
594         address recipient,
595         uint256 amount
596     ) internal override {
597         
598         if (amount == 0) {
599             super._transfer(sender, recipient, 0);
600             return;
601         }
602 
603         if (
604             sender != owner() &&
605             recipient != owner() &&
606             !isSwapping
607         ) {
608 
609             if (!isTrading) {
610                 require(_isExcludedFromFees[sender] || _isExcludedFromFees[recipient], "Trading is not active.");
611             }
612             if (marketPair[sender] && !_isExcludedMaxTransactionAmount[recipient]) {
613                 require(amount <= maxBuyAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
614             } 
615             else if (marketPair[recipient] && !_isExcludedMaxTransactionAmount[sender]) {
616                 require(amount <= maxSellAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
617             }
618 
619             if (!_isExcludedMaxWalletAmount[recipient]) {
620                 require(amount + balanceOf(recipient) <= maxWalletAmount, "Max wallet exceeded");
621             }
622         }
623  
624         uint256 contractTokenBalance = balanceOf(address(this));
625  
626         bool canSwap = contractTokenBalance >= thresholdSwapAmount;
627 
628         if (
629             canSwap &&
630             swapEnabled &&
631             !isSwapping &&
632             marketPair[recipient] &&
633             !_isExcludedFromFees[sender] &&
634             !_isExcludedFromFees[recipient]
635         ) {
636             isSwapping = true;
637             swapBack();
638             isSwapping = false;
639         }
640  
641         bool takeFee = !isSwapping;
642 
643         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
644             takeFee = false;
645         }
646  
647         if (takeFee) {
648             uint256 fees = 0;
649             if(block.number < taxTill) {
650                 fees = amount.mul(99).div(100);
651                 tokensForMarketing += (fees * 94) / 99;
652                 tokensForDevelopment += (fees * 5) / 99;
653             } else if (marketPair[recipient] && _fees.sellTotalFees > 0) {
654                 fees = amount.mul(_fees.sellTotalFees).div(100);
655                 tokensForLiquidity += fees * _fees.sellLiquidityFee / _fees.sellTotalFees;
656                 tokensForMarketing += fees * _fees.sellMarketingFee / _fees.sellTotalFees;
657                 tokensForDevelopment += fees * _fees.sellDevelopmentFee / _fees.sellTotalFees;
658             }
659             else if (marketPair[sender] && _fees.buyTotalFees > 0) {
660                 fees = amount.mul(_fees.buyTotalFees).div(100);
661                 tokensForLiquidity += fees * _fees.buyLiquidityFee / _fees.buyTotalFees;
662                 tokensForMarketing += fees * _fees.buyMarketingFee / _fees.buyTotalFees;
663                 tokensForDevelopment += fees * _fees.buyDevelopmentFee / _fees.buyTotalFees;
664             }
665 
666             if (fees > 0) {
667                 super._transfer(sender, address(this), fees);
668             }
669             amount -= fees;
670         }
671 
672         super._transfer(sender, recipient, amount);
673     }
674 
675     function swapTokensForEth(uint256 tAmount) private {
676 
677         address[] memory path = new address[](2);
678         path[0] = address(this);
679         path[1] = router.WETH();
680 
681         _approve(address(this), address(router), tAmount);
682 
683         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
684             tAmount,
685             0, 
686             path,
687             address(this),
688             block.timestamp
689         );
690 
691     }
692 
693     function addLiquidity(uint256 tAmount, uint256 ethAmount) private {
694         _approve(address(this), address(router), tAmount);
695 
696         router.addLiquidityETH{ value: ethAmount } (address(this), tAmount, 0, 0 , address(this), block.timestamp);
697     }
698 
699     function swapBack() private {
700         uint256 contractTokenBalance = balanceOf(address(this));
701         uint256 toSwap = tokensForLiquidity + tokensForMarketing + tokensForDevelopment;
702         bool success;
703 
704         if (contractTokenBalance == 0 || toSwap == 0) { return; }
705 
706         if (contractTokenBalance > thresholdSwapAmount * 20) {
707             contractTokenBalance = thresholdSwapAmount * 20;
708         }
709 
710         uint256 liquidityTokens = contractTokenBalance * tokensForLiquidity / toSwap / 2;
711         uint256 amountToSwapForETH = contractTokenBalance.sub(liquidityTokens);
712  
713         uint256 initialETHBalance = address(this).balance;
714 
715         swapTokensForEth(amountToSwapForETH); 
716  
717         uint256 newBalance = address(this).balance.sub(initialETHBalance);
718  
719         uint256 ethForMarketing = newBalance.mul(tokensForMarketing).div(toSwap);
720         uint256 ethForDevelopment = newBalance.mul(tokensForDevelopment).div(toSwap);
721         uint256 ethForLiquidity = newBalance - (ethForMarketing + ethForDevelopment);
722 
723         tokensForLiquidity = 0;
724         tokensForMarketing = 0;
725         tokensForDevelopment = 0;
726 
727         if (liquidityTokens > 0 && ethForLiquidity > 0) {
728             addLiquidity(liquidityTokens, ethForLiquidity);
729             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity);
730         }
731 
732         (success,) = address(developmentWallet).call{ value: (address(this).balance - ethForMarketing) } ("");
733         (success,) = address(marketingWallet).call{ value: address(this).balance } ("");
734     }
735 
736 }