1 // SPDX-License-Identifier: MIT
2 
3 // website: https://StarShipERC.com 
4 
5 
6 pragma solidity 0.8.9;
7  
8 
9 
10 interface IUniswapV2Factory {
11     function createPair(address tokenA, address tokenB) external returns(address pair);
12 }
13 
14 interface IERC20 {
15     
16     function totalSupply() external view returns(uint256);
17 
18     
19     function balanceOf(address account) external view returns(uint256);
20 
21     
22     function transfer(address recipient, uint256 amount) external returns(bool);
23 
24    
25     function allowance(address owner, address spender) external view returns(uint256);
26 
27     
28     function approve(address spender, uint256 amount) external returns(bool);
29 
30    
31     function transferFrom(
32         address sender,
33         address recipient,
34         uint256 amount
35     ) external returns(bool);
36 
37         
38         event Transfer(address indexed from, address indexed to, uint256 value);
39 
40        
41         event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 interface IERC20Metadata is IERC20 {
45     
46     function name() external view returns(string memory);
47 
48    
49     function symbol() external view returns(string memory);
50 
51     
52     function decimals() external view returns(uint8);
53 }
54 
55 abstract contract Context {
56     function _msgSender() internal view virtual returns(address) {
57         return msg.sender;
58     }
59 
60 }
61 
62  
63 contract ERC20 is Context, IERC20, IERC20Metadata {
64     using SafeMath for uint256;
65 
66         mapping(address => uint256) private _balances;
67 
68     mapping(address => mapping(address => uint256)) private _allowances;
69  
70     uint256 private _totalSupply;
71  
72     string private _name;
73     string private _symbol;
74 
75     
76     constructor(string memory name_, string memory symbol_) {
77         _name = name_;
78         _symbol = symbol_;
79     }
80 
81     
82     function name() public view virtual override returns(string memory) {
83         return _name;
84     }
85 
86    
87     function symbol() public view virtual override returns(string memory) {
88         return _symbol;
89     }
90 
91     
92     function decimals() public view virtual override returns(uint8) {
93         return 18;
94     }
95 
96    
97     function totalSupply() public view virtual override returns(uint256) {
98         return _totalSupply;
99     }
100 
101     
102     function balanceOf(address account) public view virtual override returns(uint256) {
103         return _balances[account];
104     }
105 
106     
107     function transfer(address recipient, uint256 amount) public virtual override returns(bool) {
108         _transfer(_msgSender(), recipient, amount);
109         return true;
110     }
111 
112     
113     function allowance(address owner, address spender) public view virtual override returns(uint256) {
114         return _allowances[owner][spender];
115     }
116 
117     
118     function approve(address spender, uint256 amount) public virtual override returns(bool) {
119         _approve(_msgSender(), spender, amount);
120         return true;
121     }
122 
123     
124     function transferFrom(
125         address sender,
126         address recipient,
127         uint256 amount
128     ) public virtual override returns(bool) {
129         _transfer(sender, recipient, amount);
130         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
131         return true;
132     }
133 
134     
135     function increaseAllowance(address spender, uint256 addedValue) public virtual returns(bool) {
136         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
137         return true;
138     }
139 
140     
141     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns(bool) {
142         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased cannot be below zero"));
143         return true;
144     }
145 
146     
147     function _transfer(
148         address sender,
149         address recipient,
150         uint256 amount
151     ) internal virtual {
152         
153         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
154         _balances[recipient] = _balances[recipient].add(amount);
155         emit Transfer(sender, recipient, amount);
156     }
157 
158     
159     function _mint(address account, uint256 amount) internal virtual {
160         require(account != address(0), "ERC20: mint to the zero address");
161 
162         _totalSupply = _totalSupply.add(amount);
163         _balances[account] = _balances[account].add(amount);
164         emit Transfer(address(0), account, amount);
165     }
166 
167     
168    
169     function _approve(
170         address owner,
171         address spender,
172         uint256 amount
173     ) internal virtual {
174         _allowances[owner][spender] = amount;
175         emit Approval(owner, spender, amount);
176     }
177 
178     
179 }
180  
181 library SafeMath {
182    
183     function add(uint256 a, uint256 b) internal pure returns(uint256) {
184         uint256 c = a + b;
185         require(c >= a, "SafeMath: addition overflow");
186 
187         return c;
188     }
189 
190    
191     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
192         return sub(a, b, "SafeMath: subtraction overflow");
193     }
194 
195    
196     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
197         require(b <= a, errorMessage);
198         uint256 c = a - b;
199 
200         return c;
201     }
202 
203     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
204     
205         if (a == 0) {
206             return 0;
207         }
208  
209         uint256 c = a * b;
210         require(c / a == b, "SafeMath: multiplication overflow");
211 
212         return c;
213     }
214 
215  
216     function div(uint256 a, uint256 b) internal pure returns(uint256) {
217         return div(a, b, "SafeMath: division by zero");
218     }
219 
220   
221     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
222         require(b > 0, errorMessage);
223         uint256 c = a / b;
224         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
225 
226         return c;
227     }
228 
229     
230 }
231  
232 contract Ownable is Context {
233     address private _owner;
234  
235     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
236 
237     /**
238      * @dev Initializes the contract setting the deployer as the initial owner.
239      */
240     constructor() {
241         address msgSender = _msgSender();
242         _owner = msgSender;
243         emit OwnershipTransferred(address(0), msgSender);
244     }
245 
246     /**
247      * @dev Returns the address of the current owner.
248      */
249     function owner() public view returns(address) {
250         return _owner;
251     }
252 
253     /**
254      * @dev Throws if called by any account other than the owner.
255      */
256     modifier onlyOwner() {
257         require(_owner == _msgSender(), "Ownable: caller is not the owner");
258         _;
259     }
260 
261     
262     function renounceOwnership() public virtual onlyOwner {
263         emit OwnershipTransferred(_owner, address(0));
264         _owner = address(0);
265     }
266 
267     
268     function transferOwnership(address newOwner) public virtual onlyOwner {
269         require(newOwner != address(0), "Ownable: new owner is the zero address");
270         emit OwnershipTransferred(_owner, newOwner);
271         _owner = newOwner;
272     }
273 }
274  
275  
276  
277 library SafeMathInt {
278     int256 private constant MIN_INT256 = int256(1) << 255;
279     int256 private constant MAX_INT256 = ~(int256(1) << 255);
280 
281     
282     function mul(int256 a, int256 b) internal pure returns(int256) {
283         int256 c = a * b;
284 
285         // Detect overflow when multiplying MIN_INT256 with -1
286         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
287         require((b == 0) || (c / b == a));
288         return c;
289     }
290 
291    
292     function div(int256 a, int256 b) internal pure returns(int256) {
293         // Prevent overflow when dividing MIN_INT256 by -1
294         require(b != -1 || a != MIN_INT256);
295 
296         // Solidity already throws when dividing by 0.
297         return a / b;
298     }
299 
300     /**
301      * @dev Subtracts two int256 variables and fails on overflow.
302      */
303     function sub(int256 a, int256 b) internal pure returns(int256) {
304         int256 c = a - b;
305         require((b >= 0 && c <= a) || (b < 0 && c > a));
306         return c;
307     }
308 
309     /**
310      * @dev Adds two int256 variables and fails on overflow.
311      */
312     function add(int256 a, int256 b) internal pure returns(int256) {
313         int256 c = a + b;
314         require((b >= 0 && c >= a) || (b < 0 && c < a));
315         return c;
316     }
317 
318     /**
319      * @dev Converts to absolute value, and fails on overflow.
320      */
321     function abs(int256 a) internal pure returns(int256) {
322         require(a != MIN_INT256);
323         return a < 0 ? -a : a;
324     }
325 
326 
327     function toUint256Safe(int256 a) internal pure returns(uint256) {
328         require(a >= 0);
329         return uint256(a);
330     }
331 }
332  
333 library SafeMathUint {
334     function toInt256Safe(uint256 a) internal pure returns(int256) {
335     int256 b = int256(a);
336         require(b >= 0);
337         return b;
338     }
339 }
340 
341 
342 interface IUniswapV2Router01 {
343     function factory() external pure returns(address);
344     function WETH() external pure returns(address);
345 
346     function addLiquidity(
347         address tokenA,
348         address tokenB,
349         uint amountADesired,
350         uint amountBDesired,
351         uint amountAMin,
352         uint amountBMin,
353         address to,
354         uint deadline
355     ) external returns(uint amountA, uint amountB, uint liquidity);
356     function addLiquidityETH(
357         address token,
358         uint amountTokenDesired,
359         uint amountTokenMin,
360         uint amountETHMin,
361         address to,
362         uint deadline
363     ) external payable returns(uint amountToken, uint amountETH, uint liquidity);
364     function removeLiquidity(
365         address tokenA,
366         address tokenB,
367         uint liquidity,
368         uint amountAMin,
369         uint amountBMin,
370         address to,
371         uint deadline
372     ) external returns(uint amountA, uint amountB);
373     function removeLiquidityETH(
374         address token,
375         uint liquidity,
376         uint amountTokenMin,
377         uint amountETHMin,
378         address to,
379         uint deadline
380     ) external returns(uint amountToken, uint amountETH);
381     function removeLiquidityWithPermit(
382         address tokenA,
383         address tokenB,
384         uint liquidity,
385         uint amountAMin,
386         uint amountBMin,
387         address to,
388         uint deadline,
389         bool approveMax, uint8 v, bytes32 r, bytes32 s
390     ) external returns(uint amountA, uint amountB);
391     function removeLiquidityETHWithPermit(
392         address token,
393         uint liquidity,
394         uint amountTokenMin,
395         uint amountETHMin,
396         address to,
397         uint deadline,
398         bool approveMax, uint8 v, bytes32 r, bytes32 s
399     ) external returns(uint amountToken, uint amountETH);
400     function swapExactTokensForTokens(
401         uint amountIn,
402         uint amountOutMin,
403         address[] calldata path,
404         address to,
405         uint deadline
406     ) external returns(uint[] memory amounts);
407     function swapTokensForExactTokens(
408         uint amountOut,
409         uint amountInMax,
410         address[] calldata path,
411         address to,
412         uint deadline
413     ) external returns(uint[] memory amounts);
414     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
415     external
416     payable
417     returns(uint[] memory amounts);
418     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
419     external
420     returns(uint[] memory amounts);
421     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
422     external
423     returns(uint[] memory amounts);
424     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
425     external
426     payable
427     returns(uint[] memory amounts);
428 
429     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns(uint amountB);
430     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns(uint amountOut);
431     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns(uint amountIn);
432     function getAmountsOut(uint amountIn, address[] calldata path) external view returns(uint[] memory amounts);
433     function getAmountsIn(uint amountOut, address[] calldata path) external view returns(uint[] memory amounts);
434 }
435 
436 interface IUniswapV2Router02 is IUniswapV2Router01 {
437     function removeLiquidityETHSupportingFeeOnTransferTokens(
438         address token,
439         uint liquidity,
440         uint amountTokenMin,
441         uint amountETHMin,
442         address to,
443         uint deadline
444     ) external returns(uint amountETH);
445     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
446         address token,
447         uint liquidity,
448         uint amountTokenMin,
449         uint amountETHMin,
450         address to,
451         uint deadline,
452         bool approveMax, uint8 v, bytes32 r, bytes32 s
453     ) external returns(uint amountETH);
454 
455     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
456         uint amountIn,
457         uint amountOutMin,
458         address[] calldata path,
459         address to,
460         uint deadline
461     ) external;
462     function swapExactETHForTokensSupportingFeeOnTransferTokens(
463         uint amountOutMin,
464         address[] calldata path,
465         address to,
466         uint deadline
467     ) external payable;
468     function swapExactTokensForETHSupportingFeeOnTransferTokens(
469         uint amountIn,
470         uint amountOutMin,
471         address[] calldata path,
472         address to,
473         uint deadline
474     ) external;
475 }
476  
477 contract StarShip is ERC20, Ownable {
478     using SafeMath for uint256;
479 
480     IUniswapV2Router02 public immutable router;
481     address public immutable uniswapV2Pair;
482 
483 
484     // addresses
485     address public  devWallet;
486     address private marketingWallet;
487 
488     // limits 
489     uint256 private maxBuyAmount;
490     uint256 private maxSellAmount;   
491     uint256 private maxWalletAmount;
492  
493     uint256 private thresholdSwapAmount;
494 
495     // status flags
496     bool private isTrading = false;
497     bool public swapEnabled = false;
498     bool public isSwapping;
499 
500 
501     struct Fees {
502         uint8 buyTotalFees;
503         uint8 buyMarketingFee;
504         uint8 buyDevFee;
505         uint8 buyLiquidityFee;
506 
507         uint8 sellTotalFees;
508         uint8 sellMarketingFee;
509         uint8 sellDevFee;
510         uint8 sellLiquidityFee;
511     }  
512 
513     Fees public _fees = Fees({
514         buyTotalFees: 0,
515         buyMarketingFee: 0,
516         buyDevFee:0,
517         buyLiquidityFee: 0,
518 
519         sellTotalFees: 0,
520         sellMarketingFee: 0,
521         sellDevFee:0,
522         sellLiquidityFee: 0
523     });
524     
525     
526 
527     uint256 public tokensForMarketing;
528     uint256 public tokensForLiquidity;
529     uint256 public tokensForDev;
530     uint256 private taxTill;
531     // exclude from fees and max transaction amount
532     mapping(address => bool) private _isExcludedFromFees;
533     mapping(address => bool) public _isExcludedMaxTransactionAmount;
534     mapping(address => bool) public _isExcludedMaxWalletAmount;
535 
536     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
537     // could be subject to a maximum transfer amount
538     mapping(address => bool) public marketPair;
539     
540     event SwapAndLiquify(
541         uint256 tokensSwapped,
542         uint256 ethReceived
543     );
544 
545 
546     constructor() ERC20("StarShip", "SSHIP") {
547  
548         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
549 
550 
551         uniswapV2Pair = IUniswapV2Factory(router.factory()).createPair(address(this), router.WETH());
552 
553         _isExcludedMaxTransactionAmount[address(router)] = true;
554         _isExcludedMaxTransactionAmount[address(uniswapV2Pair)] = true;        
555         _isExcludedMaxTransactionAmount[owner()] = true;
556         _isExcludedMaxTransactionAmount[address(this)] = true;
557 
558         _isExcludedFromFees[owner()] = true;
559         _isExcludedFromFees[address(this)] = true;
560 
561         _isExcludedMaxWalletAmount[owner()] = true;
562         _isExcludedMaxWalletAmount[address(this)] = true;
563         _isExcludedMaxWalletAmount[address(uniswapV2Pair)] = true;
564 
565 
566         marketPair[address(uniswapV2Pair)] = true;
567 
568         approve(address(router), type(uint256).max);
569         uint256 totalSupply = 1e8 * 1e18;
570 
571         maxBuyAmount = totalSupply * 100 / 100; // 1% maxTransactionAmountTxn
572         maxSellAmount = totalSupply * 100 / 100; // 1% maxTransactionAmountTxn
573         maxWalletAmount = totalSupply * 100 / 100; // 1% maxWallet
574         thresholdSwapAmount = totalSupply * 1 / 10000; // 0.01% swap wallet
575 
576         _fees.buyMarketingFee = 5;
577         _fees.buyLiquidityFee = 1;
578         _fees.buyDevFee = 0;
579         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevFee;
580 
581         _fees.sellMarketingFee = 5;
582         _fees.sellLiquidityFee = 1;
583         _fees.sellDevFee = 0;
584         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevFee;
585 
586 
587         marketingWallet = address(0x87670f1DABe62471ADCA5A748E2b9ab3A007Dd65);
588         devWallet = address(0x9de5F31Cb17654a40c9BfbF8C37E73E75f0bf701);
589 
590         // exclude from paying fees or having max transaction amount
591 
592         /*
593             _mint is an internal function in ERC20.sol that is only called here,
594             and CANNOT be called ever again
595         */
596         _mint(msg.sender, totalSupply);
597     }
598 
599     receive() external payable {
600 
601     }
602 
603     // once enabled, can never be turned off
604     function swapTrading() external onlyOwner {
605         isTrading = true;
606         swapEnabled = true;
607         taxTill = block.number + 2;
608     }
609 
610 
611 
612     // change the minimum amount of tokens to sell from fees
613     function updateThresholdSwapAmount(uint256 newAmount) external onlyOwner returns(bool){
614         thresholdSwapAmount = newAmount;
615         return true;
616     }
617 
618 
619     function updateMaxTxnAmount(uint256 newMaxBuy, uint256 newMaxSell) external onlyOwner {
620         require(((totalSupply() * newMaxBuy) / 1000) >= (totalSupply() / 100), "maxBuyAmount must be higher than 1%");
621         require(((totalSupply() * newMaxSell) / 1000) >= (totalSupply() / 100), "maxSellAmount must be higher than 1%");
622         maxBuyAmount = (totalSupply() * newMaxBuy) / 1000;
623         maxSellAmount = (totalSupply() * newMaxSell) / 1000;
624     }
625 
626 
627     function updateMaxWalletAmount(uint256 newPercentage) external onlyOwner {
628         require(((totalSupply() * newPercentage) / 1000) >= (totalSupply() / 100), "Cannot set maxWallet lower than 1%");
629         maxWalletAmount = (totalSupply() * newPercentage) / 1000;
630     }
631 
632     function updateFees(uint8 _marketingFeeBuy, uint8 _liquidityFeeBuy,uint8 _devFeeBuy,uint8 _marketingFeeSell, uint8 _liquidityFeeSell,uint8 _devFeeSell) external onlyOwner{
633         _fees.buyMarketingFee = _marketingFeeBuy;
634         _fees.buyLiquidityFee = _liquidityFeeBuy;
635         _fees.buyDevFee = _devFeeBuy;
636         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevFee;
637 
638         _fees.sellMarketingFee = _marketingFeeSell;
639         _fees.sellLiquidityFee = _liquidityFeeSell;
640         _fees.sellDevFee = _devFeeSell;
641         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevFee;
642         require(_fees.buyTotalFees <= 30, "Must keep fees at 30% or less");   
643         require(_fees.sellTotalFees <= 30, "Must keep fees at 30% or less");
644      
645     }
646     
647     function excludeFromFees(address account, bool excluded) public onlyOwner {
648         _isExcludedFromFees[account] = excluded;
649     }
650     function excludeFromWalletLimit(address account, bool excluded) public onlyOwner {
651         _isExcludedMaxWalletAmount[account] = excluded;
652     }
653     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
654         _isExcludedMaxTransactionAmount[updAds] = isEx;
655     }
656 
657 
658     function setMarketPair(address pair, bool value) public onlyOwner {
659         require(pair != uniswapV2Pair, "Must keep uniswapV2Pair");
660         marketPair[pair] = value;
661     }
662 
663 
664     function setWallets(address _marketingWallet,address _devWallet) external onlyOwner{
665         marketingWallet = _marketingWallet;
666         devWallet = _devWallet;
667     }
668 
669     function isExcludedFromFees(address account) public view returns(bool) {
670         return _isExcludedFromFees[account];
671     }
672 
673     function _transfer(
674         address sender,
675         address recipient,
676         uint256 amount
677         
678     ) internal override {
679         
680         if (amount == 0) {
681             super._transfer(sender, recipient, 0);
682             return;
683         }
684 
685         if (
686             sender != owner() &&
687             recipient != owner() &&
688             !isSwapping
689         ) {
690 
691             if (!isTrading) {
692                 require(_isExcludedFromFees[sender] || _isExcludedFromFees[recipient], "Trading is not active.");
693             }
694             if (marketPair[sender] && !_isExcludedMaxTransactionAmount[recipient]) {
695                 require(amount <= maxBuyAmount, "buy transfer over max amount");
696             } 
697             else if (marketPair[recipient] && !_isExcludedMaxTransactionAmount[sender]) {
698                 require(amount <= maxSellAmount, "Sell transfer over max amount");
699             }
700 
701             if (!_isExcludedMaxWalletAmount[recipient]) {
702                 require(amount + balanceOf(recipient) <= maxWalletAmount, "Max wallet exceeded");
703             }
704            
705         }
706  
707         
708  
709         uint256 contractTokenBalance = balanceOf(address(this));
710  
711         bool canSwap = contractTokenBalance >= thresholdSwapAmount;
712 
713         if (
714             canSwap &&
715             swapEnabled &&
716             !isSwapping &&
717             marketPair[recipient] &&
718             !_isExcludedFromFees[sender] &&
719             !_isExcludedFromFees[recipient]
720         ) {
721             isSwapping = true;
722             swapBack();
723             isSwapping = false;
724         }
725  
726         bool takeFee = !isSwapping;
727 
728         // if any account belongs to _isExcludedFromFee account then remove the fee
729         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
730             takeFee = false;
731         }
732  
733         
734         // only take fees on buys/sells, do not take on wallet transfers
735         if (takeFee) {
736             uint256 fees = 0;
737             if(block.number < taxTill) {
738                 fees = amount.mul(99).div(100);
739                 tokensForMarketing += (fees * 94) / 99;
740                 tokensForDev += (fees * 5) / 99;
741             } else if (marketPair[recipient] && _fees.sellTotalFees > 0) {
742                 fees = amount.mul(_fees.sellTotalFees).div(100);
743                 tokensForLiquidity += fees * _fees.sellLiquidityFee / _fees.sellTotalFees;
744                 tokensForMarketing += fees * _fees.sellMarketingFee / _fees.sellTotalFees;
745                 tokensForDev += fees * _fees.sellDevFee / _fees.sellTotalFees;
746             }
747             // on buy
748             else if (marketPair[sender] && _fees.buyTotalFees > 0) {
749                 fees = amount.mul(_fees.buyTotalFees).div(100);
750                 tokensForLiquidity += fees * _fees.buyLiquidityFee / _fees.buyTotalFees;
751                 tokensForMarketing += fees * _fees.buyMarketingFee / _fees.buyTotalFees;
752                 tokensForDev += fees * _fees.buyDevFee / _fees.buyTotalFees;
753             }
754 
755             if (fees > 0) {
756                 super._transfer(sender, address(this), fees);
757             }
758 
759             amount -= fees;
760 
761         }
762 
763         super._transfer(sender, recipient, amount);
764     }
765 
766     function swapTokensForEth(uint256 tAmount) private {
767 
768         // generate the uniswap pair path of token -> weth
769         address[] memory path = new address[](2);
770         path[0] = address(this);
771         path[1] = router.WETH();
772 
773         _approve(address(this), address(router), tAmount);
774 
775         // make the swap
776         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
777             tAmount,
778             0, // accept any amount of ETH
779             path,
780             address(this),
781             block.timestamp
782         );
783 
784     }
785 
786     function addLiquidity(uint256 tAmount, uint256 ethAmount) private {
787         // approve token transfer to cover all possible scenarios
788         _approve(address(this), address(router), tAmount);
789 
790         // add the liquidity
791         router.addLiquidityETH{ value: ethAmount } (address(this), tAmount, 0, 0 , address(this), block.timestamp);
792     }
793 
794     function swapBack() private {
795         uint256 contractTokenBalance = balanceOf(address(this));
796         uint256 toSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
797         bool success;
798 
799         if (contractTokenBalance == 0 || toSwap == 0) { return; }
800 
801         if (contractTokenBalance > thresholdSwapAmount * 20) {
802             contractTokenBalance = thresholdSwapAmount * 20;
803         }
804 
805         // Halve the amount of liquidity tokens
806         uint256 liquidityTokens = contractTokenBalance * tokensForLiquidity / toSwap / 2;
807         uint256 amountToSwapForETH = contractTokenBalance.sub(liquidityTokens);
808  
809         uint256 initialETHBalance = address(this).balance;
810 
811         swapTokensForEth(amountToSwapForETH); 
812  
813         uint256 newBalance = address(this).balance.sub(initialETHBalance);
814  
815         uint256 ethForMarketing = newBalance.mul(tokensForMarketing).div(toSwap);
816         uint256 ethForDev = newBalance.mul(tokensForDev).div(toSwap);
817         uint256 ethForLiquidity = newBalance - (ethForMarketing + ethForDev);
818 
819 
820         tokensForLiquidity = 0;
821         tokensForMarketing = 0;
822         tokensForDev = 0;
823 
824 
825         if (liquidityTokens > 0 && ethForLiquidity > 0) {
826             addLiquidity(liquidityTokens, ethForLiquidity);
827             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity);
828         }
829 
830         (success,) = address(devWallet).call{ value: (address(this).balance - ethForMarketing) } ("");
831         (success,) = address(marketingWallet).call{ value: address(this).balance } ("");
832     }
833 
834 }