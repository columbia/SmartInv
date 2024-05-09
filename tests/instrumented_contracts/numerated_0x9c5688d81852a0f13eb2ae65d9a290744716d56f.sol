1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.9;
3 
4 /*
5 ─────────────────────
6 ───────────████████──       ██████╗░███████╗██████╗░████████╗░█████╗░██████╗░
7 ──────────███▄███████       ██╔══██╗██╔════╝██╔══██╗╚══██╔══╝██╔══██╗██╔══██╗
8 ──────────███████████       ██████╔╝█████╗░░██████╔╝░░░██║░░░███████║██████╔╝
9 ──────────███████████       ██╔══██╗██╔══╝░░██╔═══╝░░░░██║░░░██╔══██║██╔══██╗
10 ──────────██████─────       ██║░░██║███████╗██║░░░░░░░░██║░░░██║░░██║██║░░██║
11 ──────────█████████──       ╚═╝░░╚═╝╚══════╝╚═╝░░░░░░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░╚═╝
12 █───────███████──────
13 ██────████████████───       🦖 https://www.reptar-token.com/
14 ███──██████████──█───
15 ███████████████──────       🦖 https://twitter.com/ReptarToken
16 ███████████████──────
17 ─█████████████───────       🦖 https://t.me/REPTARPORTAL
18 ──███████████────────
19 ────████████─────────       
20 ─────███──██─────────       
21 ─────██────█─────────
22 ─────█─────█─────────          
23 ─────██────██────────
24 ───────────────────── 
25 */
26 
27 interface IUniswapV2Factory {
28     function createPair(address tokenA, address tokenB) external returns(address pair);
29 }
30 
31 interface IERC20 {
32 
33     function totalSupply() external view returns(uint256);
34     function balanceOf(address account) external view returns(uint256);
35     function transfer(address recipient, uint256 amount) external returns(bool);
36     function allowance(address owner, address spender) external view returns(uint256);
37     function approve(address spender, uint256 amount) external returns(bool);
38 
39     function transferFrom(
40         address sender,
41         address recipient,
42         uint256 amount
43     ) external returns(bool);
44 
45         event Transfer(address indexed from, address indexed to, uint256 value);
46         event Approval(address indexed owner, address indexed spender, uint256 value);
47 }
48 
49 interface IERC20Metadata is IERC20 {
50 
51     function name() external view returns(string memory);
52     function symbol() external view returns(string memory);
53     function decimals() external view returns(uint8);
54 }
55 
56 abstract contract Context {
57     function _msgSender() internal view virtual returns(address) {
58         return msg.sender;
59     }
60 }
61 
62 contract ERC20 is Context, IERC20, IERC20Metadata {
63     using SafeMath for uint256;
64 
65         mapping(address => uint256) private _balances;
66 
67     mapping(address => mapping(address => uint256)) private _allowances;
68  
69     uint256 private _totalSupply;
70  
71     string private _name;
72     string private _symbol;
73 
74     constructor(string memory name_, string memory symbol_) {
75         _name = name_;
76         _symbol = symbol_;
77     }
78 
79     function name() public view virtual override returns(string memory) {
80         return _name;
81     }
82 
83     function symbol() public view virtual override returns(string memory) {
84         return _symbol;
85     }
86 
87     function decimals() public view virtual override returns(uint8) {
88         return 18;
89     }
90 
91     function totalSupply() public view virtual override returns(uint256) {
92         return _totalSupply;
93     }
94 
95     function balanceOf(address account) public view virtual override returns(uint256) {
96         return _balances[account];
97     }
98 
99     function transfer(address recipient, uint256 amount) public virtual override returns(bool) {
100         _transfer(_msgSender(), recipient, amount);
101         return true;
102     }
103 
104     function allowance(address owner, address spender) public view virtual override returns(uint256) {
105         return _allowances[owner][spender];
106     }
107 
108     function approve(address spender, uint256 amount) public virtual override returns(bool) {
109         _approve(_msgSender(), spender, amount);
110         return true;
111     }
112 
113     function transferFrom(
114         address sender,
115         address recipient,
116         uint256 amount
117     ) public virtual override returns(bool) {
118         _transfer(sender, recipient, amount);
119         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
120         return true;
121     }
122 
123     function increaseAllowance(address spender, uint256 addedValue) public virtual returns(bool) {
124         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
125         return true;
126     }
127 
128     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns(bool) {
129         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased cannot be below zero"));
130         return true;
131     }
132 
133     function _transfer(
134         address sender,
135         address recipient,
136         uint256 amount
137     ) internal virtual {
138         
139         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
140         _balances[recipient] = _balances[recipient].add(amount);
141         emit Transfer(sender, recipient, amount);
142     }
143 
144     function _mint(address account, uint256 amount) internal virtual {
145         require(account != address(0), "ERC20: mint to the zero address");
146 
147         _totalSupply = _totalSupply.add(amount);
148         _balances[account] = _balances[account].add(amount);
149         emit Transfer(address(0), account, amount);
150     }
151 
152     function _approve(
153         address owner,
154         address spender,
155         uint256 amount
156     ) internal virtual {
157         _allowances[owner][spender] = amount;
158         emit Approval(owner, spender, amount);
159     }
160 }
161  
162 library SafeMath {
163    
164     function add(uint256 a, uint256 b) internal pure returns(uint256) {
165         uint256 c = a + b;
166         require(c >= a, "SafeMath: addition overflow");
167 
168         return c;
169     }
170 
171     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
172         return sub(a, b, "SafeMath: subtraction overflow");
173     }
174 
175    
176     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
177         require(b <= a, errorMessage);
178         uint256 c = a - b;
179 
180         return c;
181     }
182 
183     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
184     
185         if (a == 0) {
186             return 0;
187         }
188  
189         uint256 c = a * b;
190         require(c / a == b, "SafeMath: multiplication overflow");
191 
192         return c;
193     }
194 
195     function div(uint256 a, uint256 b) internal pure returns(uint256) {
196         return div(a, b, "SafeMath: division by zero");
197     }
198   
199     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
200         require(b > 0, errorMessage);
201         uint256 c = a / b;
202 
203         return c;
204     }
205 }
206  
207 contract Ownable is Context {
208     address private _owner;
209  
210     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
211 
212     constructor() {
213         address msgSender = _msgSender();
214         _owner = msgSender;
215         emit OwnershipTransferred(address(0), msgSender);
216     }
217 
218     function owner() public view returns(address) {
219         return _owner;
220     }
221 
222     modifier onlyOwner() {
223         require(_owner == _msgSender(), "Ownable: caller is not the owner");
224         _;
225     }
226 
227     function renounceOwnership() public virtual onlyOwner {
228         emit OwnershipTransferred(_owner, address(0));
229         _owner = address(0);
230     }
231 
232     function transferOwnership(address newOwner) public virtual onlyOwner {
233         require(newOwner != address(0), "Ownable: new owner is the zero address");
234         emit OwnershipTransferred(_owner, newOwner);
235         _owner = newOwner;
236     }
237 }
238  
239 library SafeMathInt {
240     int256 private constant MIN_INT256 = int256(1) << 255;
241     int256 private constant MAX_INT256 = ~(int256(1) << 255);
242 
243     function mul(int256 a, int256 b) internal pure returns(int256) {
244         int256 c = a * b;
245 
246         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
247         require((b == 0) || (c / b == a));
248         return c;
249     }
250 
251     function div(int256 a, int256 b) internal pure returns(int256) {
252         require(b != -1 || a != MIN_INT256);
253 
254         return a / b;
255     }
256 
257     function sub(int256 a, int256 b) internal pure returns(int256) {
258         int256 c = a - b;
259         require((b >= 0 && c <= a) || (b < 0 && c > a));
260         return c;
261     }
262 
263     function add(int256 a, int256 b) internal pure returns(int256) {
264         int256 c = a + b;
265         require((b >= 0 && c >= a) || (b < 0 && c < a));
266         return c;
267     }
268 
269     function abs(int256 a) internal pure returns(int256) {
270         require(a != MIN_INT256);
271         return a < 0 ? -a : a;
272     }
273 
274     function toUint256Safe(int256 a) internal pure returns(uint256) {
275         require(a >= 0);
276         return uint256(a);
277     }
278 }
279  
280 library SafeMathUint {
281     function toInt256Safe(uint256 a) internal pure returns(int256) {
282     int256 b = int256(a);
283         require(b >= 0);
284         return b;
285     }
286 }
287 
288 interface IUniswapV2Router01 {
289     function factory() external pure returns(address);
290     function WETH() external pure returns(address);
291 
292     function addLiquidity(
293         address tokenA,
294         address tokenB,
295         uint amountADesired,
296         uint amountBDesired,
297         uint amountAMin,
298         uint amountBMin,
299         address to,
300         uint deadline
301     ) external returns(uint amountA, uint amountB, uint liquidity);
302     function addLiquidityETH(
303         address token,
304         uint amountTokenDesired,
305         uint amountTokenMin,
306         uint amountETHMin,
307         address to,
308         uint deadline
309     ) external payable returns(uint amountToken, uint amountETH, uint liquidity);
310     function removeLiquidity(
311         address tokenA,
312         address tokenB,
313         uint liquidity,
314         uint amountAMin,
315         uint amountBMin,
316         address to,
317         uint deadline
318     ) external returns(uint amountA, uint amountB);
319     function removeLiquidityETH(
320         address token,
321         uint liquidity,
322         uint amountTokenMin,
323         uint amountETHMin,
324         address to,
325         uint deadline
326     ) external returns(uint amountToken, uint amountETH);
327     function removeLiquidityWithPermit(
328         address tokenA,
329         address tokenB,
330         uint liquidity,
331         uint amountAMin,
332         uint amountBMin,
333         address to,
334         uint deadline,
335         bool approveMax, uint8 v, bytes32 r, bytes32 s
336     ) external returns(uint amountA, uint amountB);
337     function removeLiquidityETHWithPermit(
338         address token,
339         uint liquidity,
340         uint amountTokenMin,
341         uint amountETHMin,
342         address to,
343         uint deadline,
344         bool approveMax, uint8 v, bytes32 r, bytes32 s
345     ) external returns(uint amountToken, uint amountETH);
346     function swapExactTokensForTokens(
347         uint amountIn,
348         uint amountOutMin,
349         address[] calldata path,
350         address to,
351         uint deadline
352     ) external returns(uint[] memory amounts);
353     function swapTokensForExactTokens(
354         uint amountOut,
355         uint amountInMax,
356         address[] calldata path,
357         address to,
358         uint deadline
359     ) external returns(uint[] memory amounts);
360     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
361     external
362     payable
363     returns(uint[] memory amounts);
364     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
365     external
366     returns(uint[] memory amounts);
367     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
368     external
369     returns(uint[] memory amounts);
370     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
371     external
372     payable
373     returns(uint[] memory amounts);
374 
375     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns(uint amountB);
376     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns(uint amountOut);
377     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns(uint amountIn);
378     function getAmountsOut(uint amountIn, address[] calldata path) external view returns(uint[] memory amounts);
379     function getAmountsIn(uint amountOut, address[] calldata path) external view returns(uint[] memory amounts);
380 }
381 
382 interface IUniswapV2Router02 is IUniswapV2Router01 {
383     function removeLiquidityETHSupportingFeeOnTransferTokens(
384         address token,
385         uint liquidity,
386         uint amountTokenMin,
387         uint amountETHMin,
388         address to,
389         uint deadline
390     ) external returns(uint amountETH);
391     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
392         address token,
393         uint liquidity,
394         uint amountTokenMin,
395         uint amountETHMin,
396         address to,
397         uint deadline,
398         bool approveMax, uint8 v, bytes32 r, bytes32 s
399     ) external returns(uint amountETH);
400 
401     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
402         uint amountIn,
403         uint amountOutMin,
404         address[] calldata path,
405         address to,
406         uint deadline
407     ) external;
408     function swapExactETHForTokensSupportingFeeOnTransferTokens(
409         uint amountOutMin,
410         address[] calldata path,
411         address to,
412         uint deadline
413     ) external payable;
414     function swapExactTokensForETHSupportingFeeOnTransferTokens(
415         uint amountIn,
416         uint amountOutMin,
417         address[] calldata path,
418         address to,
419         uint deadline
420     ) external;
421 }
422  
423 contract REPTAR is ERC20, Ownable {
424     using SafeMath for uint256;
425 
426     IUniswapV2Router02 public immutable router;
427     address public immutable uniswapV2Pair;
428 
429     address private developmentWallet;
430     address private marketingWallet;
431 
432     uint256 private maxBuyAmount;
433     uint256 private maxSellAmount;   
434     uint256 private maxWalletAmount;
435  
436     uint256 private thresholdSwapAmount;
437 
438     bool private isTrading = false;
439     bool public swapEnabled = false;
440     bool public isSwapping;
441 
442     struct Fees {
443         uint256 buyTotalFees;
444         uint256 buyMarketingFee;
445         uint256 buyDevelopmentFee;
446         uint256 buyLiquidityFee;
447 
448         uint256 sellTotalFees;
449         uint256 sellMarketingFee;
450         uint256 sellDevelopmentFee;
451         uint256 sellLiquidityFee;
452     }  
453 
454     Fees public _fees = Fees({
455         buyTotalFees: 0,
456         buyMarketingFee: 0,
457         buyDevelopmentFee:0,
458         buyLiquidityFee: 0,
459 
460         sellTotalFees: 0,
461         sellMarketingFee: 0,
462         sellDevelopmentFee:0,
463         sellLiquidityFee: 0
464     });
465 
466     uint256 public tokensForMarketing;
467     uint256 public tokensForLiquidity;
468     uint256 public tokensForDevelopment;
469     uint256 private taxTill;
470 
471     mapping(address => bool) private _isExcludedFromFees;
472     mapping(address => bool) public _isExcludedMaxTransactionAmount;
473     mapping(address => bool) public _isExcludedMaxWalletAmount;
474     mapping(address => bool) public marketPair;
475  
476     event SwapAndLiquify(
477         uint256 tokensSwapped,
478         uint256 ethReceived
479     );
480 
481     constructor() ERC20("REPTAR", "REPTAR") {
482  
483         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
484 
485         uniswapV2Pair = IUniswapV2Factory(router.factory()).createPair(address(this), router.WETH());
486 
487         _isExcludedMaxTransactionAmount[address(router)] = true;
488         _isExcludedMaxTransactionAmount[address(uniswapV2Pair)] = true;        
489         _isExcludedMaxTransactionAmount[owner()] = true;
490         _isExcludedMaxTransactionAmount[address(this)] = true;
491         _isExcludedMaxTransactionAmount[address(0xdead)] = true;
492 
493         _isExcludedFromFees[owner()] = true;
494         _isExcludedFromFees[address(this)] = true;
495 
496         _isExcludedMaxWalletAmount[owner()] = true;
497         _isExcludedMaxWalletAmount[address(0xdead)] = true;
498         _isExcludedMaxWalletAmount[address(this)] = true;
499         _isExcludedMaxWalletAmount[address(uniswapV2Pair)] = true;
500 
501         marketPair[address(uniswapV2Pair)] = true;
502 
503         approve(address(router), type(uint256).max);
504 
505         uint256 totalSupply = 2e9 * 1e18;
506         maxBuyAmount = totalSupply * 2 / 100; 
507         maxSellAmount = totalSupply * 2 / 100; 
508         maxWalletAmount = totalSupply * 2 / 100; 
509         thresholdSwapAmount = totalSupply * 1 / 1000; 
510 
511         _fees.buyMarketingFee = 20;
512         _fees.buyLiquidityFee = 0;
513         _fees.buyDevelopmentFee = 0;
514         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevelopmentFee;
515 
516         _fees.sellMarketingFee = 35;
517         _fees.sellLiquidityFee = 0;
518         _fees.sellDevelopmentFee = 0;
519         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevelopmentFee;
520 
521         marketingWallet = address(0x0d036b360c999756e353Ed274aED0b52d1Ca809c);
522         developmentWallet = address(0x0d036b360c999756e353Ed274aED0b52d1Ca809c);
523 
524         /*
525             _mint is an internal function in ERC20.sol that is only called here,
526             and CANNOT be called ever again
527         */
528         _mint(msg.sender, totalSupply);
529     }
530 
531     receive() external payable {
532 
533     }
534 
535     function enableTrading() external onlyOwner {
536         isTrading = true;
537         swapEnabled = true;
538         taxTill = block.number + 0;
539     }
540 
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
555     function toggleSwapEnabled(bool enabled) external onlyOwner(){
556         swapEnabled = enabled;
557     }
558 
559     function updateFees(uint256 _marketingFeeBuy, uint256 _liquidityFeeBuy,uint256 _developmentFeeBuy,uint256 _marketingFeeSell, uint256 _liquidityFeeSell,uint256 _developmentFeeSell) external onlyOwner{
560         _fees.buyMarketingFee = _marketingFeeBuy;
561         _fees.buyLiquidityFee = _liquidityFeeBuy;
562         _fees.buyDevelopmentFee = _developmentFeeBuy;
563         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevelopmentFee;
564 
565         _fees.sellMarketingFee = _marketingFeeSell;
566         _fees.sellLiquidityFee = _liquidityFeeSell;
567         _fees.sellDevelopmentFee = _developmentFeeSell;
568         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevelopmentFee;
569         require(_fees.buyTotalFees <= 49, "Must keep fees at 49% or less");   
570         require(_fees.sellTotalFees <= 49, "Must keep fees at 49% or less");
571     }
572     
573     function excludeFromFees(address account, bool excluded) public onlyOwner {
574         _isExcludedFromFees[account] = excluded;
575     }
576     function excludeFromWalletLimit(address account, bool excluded) public onlyOwner {
577         _isExcludedMaxWalletAmount[account] = excluded;
578     }
579     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
580         _isExcludedMaxTransactionAmount[updAds] = isEx;
581     }
582 
583     function removeLimits() external onlyOwner {
584         updateMaxTxnAmount(1000,1000);
585         updateMaxWalletAmount(1000);
586     }
587 
588     function setMarketPair(address pair, bool value) public onlyOwner {
589         require(pair != uniswapV2Pair, "The pair cannot be removed from marketPair");
590         marketPair[pair] = value;
591     }
592 
593     function setWallets(address _marketingWallet,address _developmentWallet) external onlyOwner{
594         marketingWallet = _marketingWallet;
595         developmentWallet = _developmentWallet;
596     }
597 
598     function isExcludedFromFees(address account) public view returns(bool) {
599         return _isExcludedFromFees[account];
600     }
601 
602     function _transfer(
603         address sender,
604         address recipient,
605         uint256 amount
606     ) internal override {
607         
608         if (amount == 0) {
609             super._transfer(sender, recipient, 0);
610             return;
611         }
612 
613         if (
614             sender != owner() &&
615             recipient != owner() &&
616             !isSwapping
617         ) {
618 
619             if (!isTrading) {
620                 require(_isExcludedFromFees[sender] || _isExcludedFromFees[recipient], "Trading is not active.");
621             }
622             if (marketPair[sender] && !_isExcludedMaxTransactionAmount[recipient]) {
623                 require(amount <= maxBuyAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
624             } 
625             else if (marketPair[recipient] && !_isExcludedMaxTransactionAmount[sender]) {
626                 require(amount <= maxSellAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
627             }
628 
629             if (!_isExcludedMaxWalletAmount[recipient]) {
630                 require(amount + balanceOf(recipient) <= maxWalletAmount, "Max wallet exceeded");
631             }
632         }
633  
634         uint256 contractTokenBalance = balanceOf(address(this));
635  
636         bool canSwap = contractTokenBalance >= thresholdSwapAmount;
637 
638         if (
639             canSwap &&
640             swapEnabled &&
641             !isSwapping &&
642             marketPair[recipient] &&
643             !_isExcludedFromFees[sender] &&
644             !_isExcludedFromFees[recipient]
645         ) {
646             isSwapping = true;
647             swapBack();
648             isSwapping = false;
649         }
650  
651         bool takeFee = !isSwapping;
652 
653         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
654             takeFee = false;
655         }
656  
657         if (takeFee) {
658             uint256 fees = 0;
659             if(block.number < taxTill) {
660                 fees = amount.mul(99).div(100);
661                 tokensForMarketing += (fees * 94) / 99;
662                 tokensForDevelopment += (fees * 5) / 99;
663             } else if (marketPair[recipient] && _fees.sellTotalFees > 0) {
664                 fees = amount.mul(_fees.sellTotalFees).div(100);
665                 tokensForLiquidity += fees * _fees.sellLiquidityFee / _fees.sellTotalFees;
666                 tokensForMarketing += fees * _fees.sellMarketingFee / _fees.sellTotalFees;
667                 tokensForDevelopment += fees * _fees.sellDevelopmentFee / _fees.sellTotalFees;
668             }
669             else if (marketPair[sender] && _fees.buyTotalFees > 0) {
670                 fees = amount.mul(_fees.buyTotalFees).div(100);
671                 tokensForLiquidity += fees * _fees.buyLiquidityFee / _fees.buyTotalFees;
672                 tokensForMarketing += fees * _fees.buyMarketingFee / _fees.buyTotalFees;
673                 tokensForDevelopment += fees * _fees.buyDevelopmentFee / _fees.buyTotalFees;
674             }
675 
676             if (fees > 0) {
677                 super._transfer(sender, address(this), fees);
678             }
679             amount -= fees;
680         }
681 
682         super._transfer(sender, recipient, amount);
683     }
684 
685     function swapTokensForEth(uint256 tAmount) private {
686 
687         address[] memory path = new address[](2);
688         path[0] = address(this);
689         path[1] = router.WETH();
690 
691         _approve(address(this), address(router), tAmount);
692 
693         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
694             tAmount,
695             0, 
696             path,
697             address(this),
698             block.timestamp
699         );
700 
701     }
702 
703     function addLiquidity(uint256 tAmount, uint256 ethAmount) private {
704         _approve(address(this), address(router), tAmount);
705 
706         router.addLiquidityETH{ value: ethAmount } (address(this), tAmount, 0, 0 , address(this), block.timestamp);
707     }
708 
709     function swapBack() private {
710         uint256 contractTokenBalance = balanceOf(address(this));
711         uint256 toSwap = tokensForLiquidity + tokensForMarketing + tokensForDevelopment;
712         bool success;
713 
714         if (contractTokenBalance == 0 || toSwap == 0) { return; }
715 
716         if (contractTokenBalance > thresholdSwapAmount * 20) {
717             contractTokenBalance = thresholdSwapAmount * 20;
718         }
719 
720         uint256 liquidityTokens = contractTokenBalance * tokensForLiquidity / toSwap / 2;
721         uint256 amountToSwapForETH = contractTokenBalance.sub(liquidityTokens);
722  
723         uint256 initialETHBalance = address(this).balance;
724 
725         swapTokensForEth(amountToSwapForETH); 
726  
727         uint256 newBalance = address(this).balance.sub(initialETHBalance);
728  
729         uint256 ethForMarketing = newBalance.mul(tokensForMarketing).div(toSwap);
730         uint256 ethForDevelopment = newBalance.mul(tokensForDevelopment).div(toSwap);
731         uint256 ethForLiquidity = newBalance - (ethForMarketing + ethForDevelopment);
732 
733         tokensForLiquidity = 0;
734         tokensForMarketing = 0;
735         tokensForDevelopment = 0;
736 
737         if (liquidityTokens > 0 && ethForLiquidity > 0) {
738             addLiquidity(liquidityTokens, ethForLiquidity);
739             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity);
740         }
741 
742         (success,) = address(developmentWallet).call{ value: (address(this).balance - ethForMarketing) } ("");
743         (success,) = address(marketingWallet).call{ value: address(this).balance } ("");
744     }
745 
746 }