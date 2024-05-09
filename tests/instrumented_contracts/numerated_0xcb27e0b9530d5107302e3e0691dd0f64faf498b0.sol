1 // SPDX-License-Identifier: MIT
2 
3 // twitter(X) : Twitter.com/powcommunityeth
4 // telegram : https://t.me/pepeofwallstreetportal
5 // website : https://pepeofwallstreet.live/
6 
7 pragma solidity 0.8.9;
8  
9 
10 
11 interface IUniswapV2Factory {
12     function createPair(address tokenA, address tokenB) external returns(address pair);
13 }
14 
15 interface IERC20 {
16     
17     function totalSupply() external view returns(uint256);
18 
19     
20     function balanceOf(address account) external view returns(uint256);
21 
22     
23     function transfer(address recipient, uint256 amount) external returns(bool);
24 
25    
26     function allowance(address owner, address spender) external view returns(uint256);
27 
28     
29     function approve(address spender, uint256 amount) external returns(bool);
30 
31    
32     function transferFrom(
33         address sender,
34         address recipient,
35         uint256 amount
36     ) external returns(bool);
37 
38         
39         event Transfer(address indexed from, address indexed to, uint256 value);
40 
41        
42         event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 interface IERC20Metadata is IERC20 {
46     
47     function name() external view returns(string memory);
48 
49    
50     function symbol() external view returns(string memory);
51 
52     
53     function decimals() external view returns(uint8);
54 }
55 
56 abstract contract Context {
57     function _msgSender() internal view virtual returns(address) {
58         return msg.sender;
59     }
60 
61 }
62 
63  
64 contract ERC20 is Context, IERC20, IERC20Metadata {
65     using SafeMath for uint256;
66 
67         mapping(address => uint256) private _balances;
68 
69     mapping(address => mapping(address => uint256)) private _allowances;
70  
71     uint256 private _totalSupply;
72  
73     string private _name;
74     string private _symbol;
75 
76     
77     constructor(string memory name_, string memory symbol_) {
78         _name = name_;
79         _symbol = symbol_;
80     }
81 
82     
83     function name() public view virtual override returns(string memory) {
84         return _name;
85     }
86 
87    
88     function symbol() public view virtual override returns(string memory) {
89         return _symbol;
90     }
91 
92     
93     function decimals() public view virtual override returns(uint8) {
94         return 18;
95     }
96 
97    
98     function totalSupply() public view virtual override returns(uint256) {
99         return _totalSupply;
100     }
101 
102     
103     function balanceOf(address account) public view virtual override returns(uint256) {
104         return _balances[account];
105     }
106 
107     
108     function transfer(address recipient, uint256 amount) public virtual override returns(bool) {
109         _transfer(_msgSender(), recipient, amount);
110         return true;
111     }
112 
113     
114     function allowance(address owner, address spender) public view virtual override returns(uint256) {
115         return _allowances[owner][spender];
116     }
117 
118     
119     function approve(address spender, uint256 amount) public virtual override returns(bool) {
120         _approve(_msgSender(), spender, amount);
121         return true;
122     }
123 
124     
125     function transferFrom(
126         address sender,
127         address recipient,
128         uint256 amount
129     ) public virtual override returns(bool) {
130         _transfer(sender, recipient, amount);
131         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
132         return true;
133     }
134 
135     
136     function increaseAllowance(address spender, uint256 addedValue) public virtual returns(bool) {
137         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
138         return true;
139     }
140 
141     
142     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns(bool) {
143         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased cannot be below zero"));
144         return true;
145     }
146 
147     
148     function _transfer(
149         address sender,
150         address recipient,
151         uint256 amount
152     ) internal virtual {
153         
154         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
155         _balances[recipient] = _balances[recipient].add(amount);
156         emit Transfer(sender, recipient, amount);
157     }
158 
159     
160     function _mint(address account, uint256 amount) internal virtual {
161         require(account != address(0), "ERC20: mint to the zero address");
162 
163         _totalSupply = _totalSupply.add(amount);
164         _balances[account] = _balances[account].add(amount);
165         emit Transfer(address(0), account, amount);
166     }
167 
168     
169    
170     function _approve(
171         address owner,
172         address spender,
173         uint256 amount
174     ) internal virtual {
175         _allowances[owner][spender] = amount;
176         emit Approval(owner, spender, amount);
177     }
178 
179     
180 }
181  
182 library SafeMath {
183    
184     function add(uint256 a, uint256 b) internal pure returns(uint256) {
185         uint256 c = a + b;
186         require(c >= a, "SafeMath: addition overflow");
187 
188         return c;
189     }
190 
191    
192     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
193         return sub(a, b, "SafeMath: subtraction overflow");
194     }
195 
196    
197     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
198         require(b <= a, errorMessage);
199         uint256 c = a - b;
200 
201         return c;
202     }
203 
204     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
205     
206         if (a == 0) {
207             return 0;
208         }
209  
210         uint256 c = a * b;
211         require(c / a == b, "SafeMath: multiplication overflow");
212 
213         return c;
214     }
215 
216  
217     function div(uint256 a, uint256 b) internal pure returns(uint256) {
218         return div(a, b, "SafeMath: division by zero");
219     }
220 
221   
222     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns(uint256) {
223         require(b > 0, errorMessage);
224         uint256 c = a / b;
225         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
226 
227         return c;
228     }
229 
230     
231 }
232  
233 contract Ownable is Context {
234     address private _owner;
235  
236     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
237 
238     /**
239      * @dev Initializes the contract setting the deployer as the initial owner.
240      */
241     constructor() {
242         address msgSender = _msgSender();
243         _owner = msgSender;
244         emit OwnershipTransferred(address(0), msgSender);
245     }
246 
247     /**
248      * @dev Returns the address of the current owner.
249      */
250     function owner() public view returns(address) {
251         return _owner;
252     }
253 
254     /**
255      * @dev Throws if called by any account other than the owner.
256      */
257     modifier onlyOwner() {
258         require(_owner == _msgSender(), "Ownable: caller is not the owner");
259         _;
260     }
261 
262     
263     function renounceOwnership() public virtual onlyOwner {
264         emit OwnershipTransferred(_owner, address(0));
265         _owner = address(0);
266     }
267 
268     
269     function transferOwnership(address newOwner) public virtual onlyOwner {
270         require(newOwner != address(0), "Ownable: new owner is the zero address");
271         emit OwnershipTransferred(_owner, newOwner);
272         _owner = newOwner;
273     }
274 }
275  
276  
277  
278 library SafeMathInt {
279     int256 private constant MIN_INT256 = int256(1) << 255;
280     int256 private constant MAX_INT256 = ~(int256(1) << 255);
281 
282     
283     function mul(int256 a, int256 b) internal pure returns(int256) {
284         int256 c = a * b;
285 
286         // Detect overflow when multiplying MIN_INT256 with -1
287         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
288         require((b == 0) || (c / b == a));
289         return c;
290     }
291 
292    
293     function div(int256 a, int256 b) internal pure returns(int256) {
294         // Prevent overflow when dividing MIN_INT256 by -1
295         require(b != -1 || a != MIN_INT256);
296 
297         // Solidity already throws when dividing by 0.
298         return a / b;
299     }
300 
301     /**
302      * @dev Subtracts two int256 variables and fails on overflow.
303      */
304     function sub(int256 a, int256 b) internal pure returns(int256) {
305         int256 c = a - b;
306         require((b >= 0 && c <= a) || (b < 0 && c > a));
307         return c;
308     }
309 
310     /**
311      * @dev Adds two int256 variables and fails on overflow.
312      */
313     function add(int256 a, int256 b) internal pure returns(int256) {
314         int256 c = a + b;
315         require((b >= 0 && c >= a) || (b < 0 && c < a));
316         return c;
317     }
318 
319     /**
320      * @dev Converts to absolute value, and fails on overflow.
321      */
322     function abs(int256 a) internal pure returns(int256) {
323         require(a != MIN_INT256);
324         return a < 0 ? -a : a;
325     }
326 
327 
328     function toUint256Safe(int256 a) internal pure returns(uint256) {
329         require(a >= 0);
330         return uint256(a);
331     }
332 }
333  
334 library SafeMathUint {
335     function toInt256Safe(uint256 a) internal pure returns(int256) {
336     int256 b = int256(a);
337         require(b >= 0);
338         return b;
339     }
340 }
341 
342 
343 interface IUniswapV2Router01 {
344     function factory() external pure returns(address);
345     function WETH() external pure returns(address);
346 
347     function addLiquidity(
348         address tokenA,
349         address tokenB,
350         uint amountADesired,
351         uint amountBDesired,
352         uint amountAMin,
353         uint amountBMin,
354         address to,
355         uint deadline
356     ) external returns(uint amountA, uint amountB, uint liquidity);
357     function addLiquidityETH(
358         address token,
359         uint amountTokenDesired,
360         uint amountTokenMin,
361         uint amountETHMin,
362         address to,
363         uint deadline
364     ) external payable returns(uint amountToken, uint amountETH, uint liquidity);
365     function removeLiquidity(
366         address tokenA,
367         address tokenB,
368         uint liquidity,
369         uint amountAMin,
370         uint amountBMin,
371         address to,
372         uint deadline
373     ) external returns(uint amountA, uint amountB);
374     function removeLiquidityETH(
375         address token,
376         uint liquidity,
377         uint amountTokenMin,
378         uint amountETHMin,
379         address to,
380         uint deadline
381     ) external returns(uint amountToken, uint amountETH);
382     function removeLiquidityWithPermit(
383         address tokenA,
384         address tokenB,
385         uint liquidity,
386         uint amountAMin,
387         uint amountBMin,
388         address to,
389         uint deadline,
390         bool approveMax, uint8 v, bytes32 r, bytes32 s
391     ) external returns(uint amountA, uint amountB);
392     function removeLiquidityETHWithPermit(
393         address token,
394         uint liquidity,
395         uint amountTokenMin,
396         uint amountETHMin,
397         address to,
398         uint deadline,
399         bool approveMax, uint8 v, bytes32 r, bytes32 s
400     ) external returns(uint amountToken, uint amountETH);
401     function swapExactTokensForTokens(
402         uint amountIn,
403         uint amountOutMin,
404         address[] calldata path,
405         address to,
406         uint deadline
407     ) external returns(uint[] memory amounts);
408     function swapTokensForExactTokens(
409         uint amountOut,
410         uint amountInMax,
411         address[] calldata path,
412         address to,
413         uint deadline
414     ) external returns(uint[] memory amounts);
415     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
416     external
417     payable
418     returns(uint[] memory amounts);
419     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
420     external
421     returns(uint[] memory amounts);
422     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
423     external
424     returns(uint[] memory amounts);
425     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
426     external
427     payable
428     returns(uint[] memory amounts);
429 
430     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns(uint amountB);
431     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns(uint amountOut);
432     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns(uint amountIn);
433     function getAmountsOut(uint amountIn, address[] calldata path) external view returns(uint[] memory amounts);
434     function getAmountsIn(uint amountOut, address[] calldata path) external view returns(uint[] memory amounts);
435 }
436 
437 interface IUniswapV2Router02 is IUniswapV2Router01 {
438     function removeLiquidityETHSupportingFeeOnTransferTokens(
439         address token,
440         uint liquidity,
441         uint amountTokenMin,
442         uint amountETHMin,
443         address to,
444         uint deadline
445     ) external returns(uint amountETH);
446     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
447         address token,
448         uint liquidity,
449         uint amountTokenMin,
450         uint amountETHMin,
451         address to,
452         uint deadline,
453         bool approveMax, uint8 v, bytes32 r, bytes32 s
454     ) external returns(uint amountETH);
455 
456     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
457         uint amountIn,
458         uint amountOutMin,
459         address[] calldata path,
460         address to,
461         uint deadline
462     ) external;
463     function swapExactETHForTokensSupportingFeeOnTransferTokens(
464         uint amountOutMin,
465         address[] calldata path,
466         address to,
467         uint deadline
468     ) external payable;
469     function swapExactTokensForETHSupportingFeeOnTransferTokens(
470         uint amountIn,
471         uint amountOutMin,
472         address[] calldata path,
473         address to,
474         uint deadline
475     ) external;
476 }
477  
478 contract PepeOfWallstreet is ERC20, Ownable {
479     using SafeMath for uint256;
480 
481     IUniswapV2Router02 public immutable router;
482     address public immutable uniswapV2Pair;
483 
484 
485     // addresses
486     address public  devWallet;
487     address private marketingWallet;
488 
489     // limits 
490     uint256 private maxBuyAmount;
491     uint256 private maxSellAmount;   
492     uint256 private maxWalletAmount;
493  
494     uint256 private thresholdSwapAmount;
495 
496     // status flags
497     bool private isTrading = false;
498     bool public swapEnabled = false;
499     bool public isSwapping;
500 
501 
502     struct Fees {
503         uint8 buyTotalFees;
504         uint8 buyMarketingFee;
505         uint8 buyDevFee;
506         uint8 buyLiquidityFee;
507 
508         uint8 sellTotalFees;
509         uint8 sellMarketingFee;
510         uint8 sellDevFee;
511         uint8 sellLiquidityFee;
512     }  
513 
514     Fees public _fees = Fees({
515         buyTotalFees: 0,
516         buyMarketingFee: 0,
517         buyDevFee:0,
518         buyLiquidityFee: 0,
519 
520         sellTotalFees: 0,
521         sellMarketingFee: 0,
522         sellDevFee:0,
523         sellLiquidityFee: 0
524     });
525     
526     
527 
528     uint256 public tokensForMarketing;
529     uint256 public tokensForLiquidity;
530     uint256 public tokensForDev;
531     uint256 private taxTill;
532     // exclude from fees and max transaction amount
533     mapping(address => bool) private _isExcludedFromFees;
534     mapping(address => bool) public _isExcludedMaxTransactionAmount;
535     mapping(address => bool) public _isExcludedMaxWalletAmount;
536 
537     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
538     // could be subject to a maximum transfer amount
539     mapping(address => bool) public marketPair;
540     
541     event SwapAndLiquify(
542         uint256 tokensSwapped,
543         uint256 ethReceived
544     );
545 
546 
547     constructor() ERC20("Pepe Of Wallstreet", "POW") {
548  
549         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
550 
551 
552         uniswapV2Pair = IUniswapV2Factory(router.factory()).createPair(address(this), router.WETH());
553 
554         _isExcludedMaxTransactionAmount[address(router)] = true;
555         _isExcludedMaxTransactionAmount[address(uniswapV2Pair)] = true;        
556         _isExcludedMaxTransactionAmount[owner()] = true;
557         _isExcludedMaxTransactionAmount[address(this)] = true;
558 
559         _isExcludedFromFees[owner()] = true;
560         _isExcludedFromFees[address(this)] = true;
561 
562         _isExcludedMaxWalletAmount[owner()] = true;
563         _isExcludedMaxWalletAmount[address(this)] = true;
564         _isExcludedMaxWalletAmount[address(uniswapV2Pair)] = true;
565 
566 
567         marketPair[address(uniswapV2Pair)] = true;
568 
569         approve(address(router), type(uint256).max);
570         uint256 totalSupply = 1e12 * 1e18;
571 
572         maxBuyAmount = totalSupply * 100 / 100; // 1% maxTransactionAmountTxn
573         maxSellAmount = totalSupply * 100 / 100; // 1% maxTransactionAmountTxn
574         maxWalletAmount = totalSupply * 100 / 100; // 1% maxWallet
575         thresholdSwapAmount = totalSupply * 1 / 10000; // 0.01% swap wallet
576 
577         _fees.buyMarketingFee = 5;
578         _fees.buyLiquidityFee = 1;
579         _fees.buyDevFee = 0;
580         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevFee;
581 
582         _fees.sellMarketingFee = 5;
583         _fees.sellLiquidityFee = 1;
584         _fees.sellDevFee = 0;
585         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevFee;
586 
587 
588         marketingWallet = address(0x185Fd6aDae886cfbCC1492beB0a386B685Fa90ac);
589         devWallet = address(0x185Fd6aDae886cfbCC1492beB0a386B685Fa90ac);
590 
591         // exclude from paying fees or having max transaction amount
592 
593         /*
594             _mint is an internal function in ERC20.sol that is only called here,
595             and CANNOT be called ever again
596         */
597         _mint(msg.sender, totalSupply);
598     }
599 
600     receive() external payable {
601 
602     }
603 
604     // once enabled, can never be turned off
605     function swapTrading() external onlyOwner {
606         isTrading = true;
607         swapEnabled = true;
608         taxTill = block.number + 2;
609     }
610 
611 
612 
613     // change the minimum amount of tokens to sell from fees
614     function updateThresholdSwapAmount(uint256 newAmount) external onlyOwner returns(bool){
615         thresholdSwapAmount = newAmount;
616         return true;
617     }
618 
619 
620     function updateMaxTxnAmount(uint256 newMaxBuy, uint256 newMaxSell) external onlyOwner {
621         require(((totalSupply() * newMaxBuy) / 1000) >= (totalSupply() / 100), "maxBuyAmount must be higher than 1%");
622         require(((totalSupply() * newMaxSell) / 1000) >= (totalSupply() / 100), "maxSellAmount must be higher than 1%");
623         maxBuyAmount = (totalSupply() * newMaxBuy) / 1000;
624         maxSellAmount = (totalSupply() * newMaxSell) / 1000;
625     }
626 
627 
628     function updateMaxWalletAmount(uint256 newPercentage) external onlyOwner {
629         require(((totalSupply() * newPercentage) / 1000) >= (totalSupply() / 100), "Cannot set maxWallet lower than 1%");
630         maxWalletAmount = (totalSupply() * newPercentage) / 1000;
631     }
632 
633     function updateFees(uint8 _marketingFeeBuy, uint8 _liquidityFeeBuy,uint8 _devFeeBuy,uint8 _marketingFeeSell, uint8 _liquidityFeeSell,uint8 _devFeeSell) external onlyOwner{
634         _fees.buyMarketingFee = _marketingFeeBuy;
635         _fees.buyLiquidityFee = _liquidityFeeBuy;
636         _fees.buyDevFee = _devFeeBuy;
637         _fees.buyTotalFees = _fees.buyMarketingFee + _fees.buyLiquidityFee + _fees.buyDevFee;
638 
639         _fees.sellMarketingFee = _marketingFeeSell;
640         _fees.sellLiquidityFee = _liquidityFeeSell;
641         _fees.sellDevFee = _devFeeSell;
642         _fees.sellTotalFees = _fees.sellMarketingFee + _fees.sellLiquidityFee + _fees.sellDevFee;
643         require(_fees.buyTotalFees <= 30, "Must keep fees at 30% or less");   
644         require(_fees.sellTotalFees <= 30, "Must keep fees at 30% or less");
645      
646     }
647     
648     function excludeFromFees(address account, bool excluded) public onlyOwner {
649         _isExcludedFromFees[account] = excluded;
650     }
651     function excludeFromWalletLimit(address account, bool excluded) public onlyOwner {
652         _isExcludedMaxWalletAmount[account] = excluded;
653     }
654     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
655         _isExcludedMaxTransactionAmount[updAds] = isEx;
656     }
657 
658 
659     function setMarketPair(address pair, bool value) public onlyOwner {
660         require(pair != uniswapV2Pair, "Must keep uniswapV2Pair");
661         marketPair[pair] = value;
662     }
663     function rescueETH(uint256 weiAmount) external onlyOwner {
664         payable(owner()).transfer(weiAmount);
665     }
666 
667     function rescueERC20(address tokenAdd, uint256 amount) external onlyOwner {
668         IERC20(tokenAdd).transfer(owner(), amount);
669     }
670 
671     function setWallets(address _marketingWallet,address _devWallet) external onlyOwner{
672         marketingWallet = _marketingWallet;
673         devWallet = _devWallet;
674     }
675 
676     function isExcludedFromFees(address account) public view returns(bool) {
677         return _isExcludedFromFees[account];
678     }
679 
680     function _transfer(
681         address sender,
682         address recipient,
683         uint256 amount
684         
685     ) internal override {
686         
687         if (amount == 0) {
688             super._transfer(sender, recipient, 0);
689             return;
690         }
691 
692         if (
693             sender != owner() &&
694             recipient != owner() &&
695             !isSwapping
696         ) {
697 
698             if (!isTrading) {
699                 require(_isExcludedFromFees[sender] || _isExcludedFromFees[recipient], "Trading is not active.");
700             }
701             if (marketPair[sender] && !_isExcludedMaxTransactionAmount[recipient]) {
702                 require(amount <= maxBuyAmount, "buy transfer over max amount");
703             } 
704             else if (marketPair[recipient] && !_isExcludedMaxTransactionAmount[sender]) {
705                 require(amount <= maxSellAmount, "Sell transfer over max amount");
706             }
707 
708             if (!_isExcludedMaxWalletAmount[recipient]) {
709                 require(amount + balanceOf(recipient) <= maxWalletAmount, "Max wallet exceeded");
710             }
711            
712         }
713  
714         
715  
716         uint256 contractTokenBalance = balanceOf(address(this));
717  
718         bool canSwap = contractTokenBalance >= thresholdSwapAmount;
719 
720         if (
721             canSwap &&
722             swapEnabled &&
723             !isSwapping &&
724             marketPair[recipient] &&
725             !_isExcludedFromFees[sender] &&
726             !_isExcludedFromFees[recipient]
727         ) {
728             isSwapping = true;
729             swapBack();
730             isSwapping = false;
731         }
732  
733         bool takeFee = !isSwapping;
734 
735         // if any account belongs to _isExcludedFromFee account then remove the fee
736         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
737             takeFee = false;
738         }
739  
740         
741         // only take fees on buys/sells, do not take on wallet transfers
742         if (takeFee) {
743             uint256 fees = 0;
744             if(block.number < taxTill) {
745                 fees = amount.mul(99).div(100);
746                 tokensForMarketing += (fees * 94) / 99;
747                 tokensForDev += (fees * 5) / 99;
748             } else if (marketPair[recipient] && _fees.sellTotalFees > 0) {
749                 fees = amount.mul(_fees.sellTotalFees).div(100);
750                 tokensForLiquidity += fees * _fees.sellLiquidityFee / _fees.sellTotalFees;
751                 tokensForMarketing += fees * _fees.sellMarketingFee / _fees.sellTotalFees;
752                 tokensForDev += fees * _fees.sellDevFee / _fees.sellTotalFees;
753             }
754             // on buy
755             else if (marketPair[sender] && _fees.buyTotalFees > 0) {
756                 fees = amount.mul(_fees.buyTotalFees).div(100);
757                 tokensForLiquidity += fees * _fees.buyLiquidityFee / _fees.buyTotalFees;
758                 tokensForMarketing += fees * _fees.buyMarketingFee / _fees.buyTotalFees;
759                 tokensForDev += fees * _fees.buyDevFee / _fees.buyTotalFees;
760             }
761 
762             if (fees > 0) {
763                 super._transfer(sender, address(this), fees);
764             }
765 
766             amount -= fees;
767 
768         }
769 
770         super._transfer(sender, recipient, amount);
771     }
772 
773     function swapTokensForEth(uint256 tAmount) private {
774 
775         // generate the uniswap pair path of token -> weth
776         address[] memory path = new address[](2);
777         path[0] = address(this);
778         path[1] = router.WETH();
779 
780         _approve(address(this), address(router), tAmount);
781 
782         // make the swap
783         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
784             tAmount,
785             0, // accept any amount of ETH
786             path,
787             address(this),
788             block.timestamp
789         );
790 
791     }
792 
793     function addLiquidity(uint256 tAmount, uint256 ethAmount) private {
794         // approve token transfer to cover all possible scenarios
795         _approve(address(this), address(router), tAmount);
796 
797         // add the liquidity
798         router.addLiquidityETH{ value: ethAmount } (address(this), tAmount, 0, 0 , address(this), block.timestamp);
799     }
800 
801     function swapBack() private {
802         uint256 contractTokenBalance = balanceOf(address(this));
803         uint256 toSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
804         bool success;
805 
806         if (contractTokenBalance == 0 || toSwap == 0) { return; }
807 
808         if (contractTokenBalance > thresholdSwapAmount * 20) {
809             contractTokenBalance = thresholdSwapAmount * 20;
810         }
811 
812         // Halve the amount of liquidity tokens
813         uint256 liquidityTokens = contractTokenBalance * tokensForLiquidity / toSwap / 2;
814         uint256 amountToSwapForETH = contractTokenBalance.sub(liquidityTokens);
815  
816         uint256 initialETHBalance = address(this).balance;
817 
818         swapTokensForEth(amountToSwapForETH); 
819  
820         uint256 newBalance = address(this).balance.sub(initialETHBalance);
821  
822         uint256 ethForMarketing = newBalance.mul(tokensForMarketing).div(toSwap);
823         uint256 ethForDev = newBalance.mul(tokensForDev).div(toSwap);
824         uint256 ethForLiquidity = newBalance - (ethForMarketing + ethForDev);
825 
826 
827         tokensForLiquidity = 0;
828         tokensForMarketing = 0;
829         tokensForDev = 0;
830 
831 
832         if (liquidityTokens > 0 && ethForLiquidity > 0) {
833             addLiquidity(liquidityTokens, ethForLiquidity);
834             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity);
835         }
836 
837         (success,) = address(devWallet).call{ value: (address(this).balance - ethForMarketing) } ("");
838         (success,) = address(marketingWallet).call{ value: address(this).balance } ("");
839     }
840 
841 }