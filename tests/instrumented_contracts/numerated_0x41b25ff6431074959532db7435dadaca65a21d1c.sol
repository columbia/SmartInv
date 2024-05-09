1 //  SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.19;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 }
9 
10 abstract contract Ownable is Context {
11     address private _owner;
12 
13     event OwnershipTransferred(
14         address indexed previousOwner,
15         address indexed newOwner
16     );
17 
18     constructor() {
19         _transferOwnership(_msgSender());
20     }
21 
22     function owner() public view virtual returns (address) {
23         return _owner;
24     }
25 
26     modifier onlyOwner() {
27         require(owner() == _msgSender(), "Ownable: caller is not the owner");
28         _;
29     }
30 
31     function renounceOwnership() public virtual onlyOwner {
32         _transferOwnership(address(0));
33     }
34 
35     function transferOwnership(address newOwner) public virtual onlyOwner {
36         require(
37             newOwner != address(0),
38             "Ownable: new owner is the zero address"
39         );
40         _transferOwnership(newOwner);
41     }
42 
43     function _transferOwnership(address newOwner) internal virtual {
44         address oldOwner = _owner;
45         _owner = newOwner;
46         emit OwnershipTransferred(oldOwner, newOwner);
47     }
48 }
49 
50 interface IERC20 {
51     function totalSupply() external view returns (uint256);
52 
53     function balanceOf(address account) external view returns (uint256);
54 
55     function transfer(
56         address recipient,
57         uint256 amount
58     ) external returns (bool);
59 
60     function allowance(
61         address owner,
62         address spender
63     ) external view returns (uint256);
64 
65     function approve(address spender, uint256 amount) external returns (bool);
66 
67     function transferFrom(
68         address sender,
69         address recipient,
70         uint256 amount
71     ) external returns (bool);
72 
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     event Approval(
76         address indexed owner,
77         address indexed spender,
78         uint256 value
79     );
80 }
81 
82 interface IERC20Metadata is IERC20 {
83     function name() external view returns (string memory);
84 
85     function symbol() external view returns (string memory);
86 
87     function decimals() external view returns (uint8);
88 }
89 
90 contract ERC20 is Context, IERC20, IERC20Metadata {
91     mapping(address => uint256) private _balances;
92 
93     mapping(address => mapping(address => uint256)) private _allowances;
94 
95     uint256 private _totalSupply;
96 
97     string private _name;
98     string private _symbol;
99 
100     constructor(string memory name_, string memory symbol_) {
101         _name = name_;
102         _symbol = symbol_;
103     }
104 
105     function name() public view virtual override returns (string memory) {
106         return _name;
107     }
108 
109     function symbol() public view virtual override returns (string memory) {
110         return _symbol;
111     }
112 
113     function decimals() public view virtual override returns (uint8) {
114         return 18;
115     }
116 
117     function totalSupply() public view virtual override returns (uint256) {
118         return _totalSupply;
119     }
120 
121     function balanceOf(
122         address account
123     ) public view virtual override returns (uint256) {
124         return _balances[account];
125     }
126 
127     function transfer(
128         address recipient,
129         uint256 amount
130     ) public virtual override returns (bool) {
131         _transfer(_msgSender(), recipient, amount);
132         return true;
133     }
134 
135     function allowance(
136         address owner,
137         address spender
138     ) public view virtual override returns (uint256) {
139         return _allowances[owner][spender];
140     }
141 
142     function approve(
143         address spender,
144         uint256 amount
145     ) public virtual override returns (bool) {
146         _approve(_msgSender(), spender, amount);
147         return true;
148     }
149 
150     function transferFrom(
151         address sender,
152         address recipient,
153         uint256 amount
154     ) public virtual override returns (bool) {
155         _transfer(sender, recipient, amount);
156 
157         uint256 currentAllowance = _allowances[sender][_msgSender()];
158         require(
159             currentAllowance >= amount,
160             "ERC20: transfer amount exceeds allowance"
161         );
162         unchecked {
163             _approve(sender, _msgSender(), currentAllowance - amount);
164         }
165 
166         return true;
167     }
168 
169     function increaseAllowance(
170         address spender,
171         uint256 addedValue
172     ) public virtual returns (bool) {
173         _approve(
174             _msgSender(),
175             spender,
176             _allowances[_msgSender()][spender] + addedValue
177         );
178         return true;
179     }
180 
181     function decreaseAllowance(
182         address spender,
183         uint256 subtractedValue
184     ) public virtual returns (bool) {
185         uint256 currentAllowance = _allowances[_msgSender()][spender];
186         require(
187             currentAllowance >= subtractedValue,
188             "ERC20: decreased allowance below zero"
189         );
190         unchecked {
191             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
192         }
193 
194         return true;
195     }
196 
197     function _transfer(
198         address sender,
199         address recipient,
200         uint256 amount
201     ) internal virtual {
202         require(sender != address(0), "ERC20: transfer from the zero address");
203         require(recipient != address(0), "ERC20: transfer to the zero address");
204 
205         _beforeTokenTransfer(sender, recipient, amount);
206 
207         uint256 senderBalance = _balances[sender];
208         require(
209             senderBalance >= amount,
210             "ERC20: transfer amount exceeds balance"
211         );
212         unchecked {
213             _balances[sender] = senderBalance - amount;
214         }
215         _balances[recipient] += amount;
216 
217         emit Transfer(sender, recipient, amount);
218 
219         _afterTokenTransfer(sender, recipient, amount);
220     }
221 
222     function _mint(address account, uint256 amount) internal virtual {
223         require(account != address(0), "ERC20: mint to the zero address");
224 
225         _beforeTokenTransfer(address(0), account, amount);
226 
227         _totalSupply += amount;
228         _balances[account] += amount;
229         emit Transfer(address(0), account, amount);
230 
231         _afterTokenTransfer(address(0), account, amount);
232     }
233 
234     function _approve(
235         address owner,
236         address spender,
237         uint256 amount
238     ) internal virtual {
239         require(owner != address(0), "ERC20: approve from the zero address");
240         require(spender != address(0), "ERC20: approve to the zero address");
241 
242         _allowances[owner][spender] = amount;
243         emit Approval(owner, spender, amount);
244     }
245 
246     function _beforeTokenTransfer(
247         address from,
248         address to,
249         uint256 amount
250     ) internal virtual {}
251 
252     function _afterTokenTransfer(
253         address from,
254         address to,
255         uint256 amount
256     ) internal virtual {}
257 }
258 
259 library SafeMath {
260     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
261         return a - b;
262     }
263 
264     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
265         return a * b;
266     }
267 
268     function div(uint256 a, uint256 b) internal pure returns (uint256) {
269         return a / b;
270     }
271 }
272 
273 interface IUniswapV2Factory {
274     event PairCreated(
275         address indexed token0,
276         address indexed token1,
277         address pair,
278         uint256
279     );
280 
281     function feeTo() external view returns (address);
282 
283     function feeToSetter() external view returns (address);
284 
285     function getPair(
286         address tokenA,
287         address tokenB
288     ) external view returns (address pair);
289 
290     function allPairs(uint256) external view returns (address pair);
291 
292     function allPairsLength() external view returns (uint256);
293 
294     function createPair(
295         address tokenA,
296         address tokenB
297     ) external returns (address pair);
298 
299     function setFeeTo(address) external;
300 
301     function setFeeToSetter(address) external;
302 }
303 
304 interface IUniswapV2Pair {
305     event Approval(
306         address indexed owner,
307         address indexed spender,
308         uint256 value
309     );
310     event Transfer(address indexed from, address indexed to, uint256 value);
311 
312     function name() external pure returns (string memory);
313 
314     function symbol() external pure returns (string memory);
315 
316     function decimals() external pure returns (uint8);
317 
318     function totalSupply() external view returns (uint256);
319 
320     function balanceOf(address owner) external view returns (uint256);
321 
322     function allowance(
323         address owner,
324         address spender
325     ) external view returns (uint256);
326 
327     function approve(address spender, uint256 value) external returns (bool);
328 
329     function transfer(address to, uint256 value) external returns (bool);
330 
331     function transferFrom(
332         address from,
333         address to,
334         uint256 value
335     ) external returns (bool);
336 
337     function DOMAIN_SEPARATOR() external view returns (bytes32);
338 
339     function PERMIT_TYPEHASH() external pure returns (bytes32);
340 
341     function nonces(address owner) external view returns (uint256);
342 
343     function permit(
344         address owner,
345         address spender,
346         uint256 value,
347         uint256 deadline,
348         uint8 v,
349         bytes32 r,
350         bytes32 s
351     ) external;
352 
353     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
354     event Burn(
355         address indexed sender,
356         uint256 amount0,
357         uint256 amount1,
358         address indexed to
359     );
360     event Swap(
361         address indexed sender,
362         uint256 amount0In,
363         uint256 amount1In,
364         uint256 amount0Out,
365         uint256 amount1Out,
366         address indexed to
367     );
368     event Sync(uint112 reserve0, uint112 reserve1);
369 
370     function MINIMUM_LIQUIDITY() external pure returns (uint256);
371 
372     function factory() external view returns (address);
373 
374     function token0() external view returns (address);
375 
376     function token1() external view returns (address);
377 
378     function getReserves()
379         external
380         view
381         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
382 
383     function price0CumulativeLast() external view returns (uint256);
384 
385     function price1CumulativeLast() external view returns (uint256);
386 
387     function kLast() external view returns (uint256);
388 
389     function mint(address to) external returns (uint256 liquidity);
390 
391     function burn(
392         address to
393     ) external returns (uint256 amount0, uint256 amount1);
394 
395     function swap(
396         uint256 amount0Out,
397         uint256 amount1Out,
398         address to,
399         bytes calldata data
400     ) external;
401 
402     function skim(address to) external;
403 
404     function sync() external;
405 
406     function initialize(address, address) external;
407 }
408 
409 interface IUniswapV2Router02 {
410     function factory() external pure returns (address);
411 
412     function WETH() external pure returns (address);
413 
414     function addLiquidity(
415         address tokenA,
416         address tokenB,
417         uint256 amountADesired,
418         uint256 amountBDesired,
419         uint256 amountAMin,
420         uint256 amountBMin,
421         address to,
422         uint256 deadline
423     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
424 
425     function addLiquidityETH(
426         address token,
427         uint256 amountTokenDesired,
428         uint256 amountTokenMin,
429         uint256 amountETHMin,
430         address to,
431         uint256 deadline
432     )
433         external
434         payable
435         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
436 
437     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
438         uint256 amountIn,
439         uint256 amountOutMin,
440         address[] calldata path,
441         address to,
442         uint256 deadline
443     ) external;
444 
445     function swapExactETHForTokensSupportingFeeOnTransferTokens(
446         uint256 amountOutMin,
447         address[] calldata path,
448         address to,
449         uint256 deadline
450     ) external payable;
451 
452     function swapExactTokensForETHSupportingFeeOnTransferTokens(
453         uint256 amountIn,
454         uint256 amountOutMin,
455         address[] calldata path,
456         address to,
457         uint256 deadline
458     ) external;
459 }
460 
461 contract CLAW is ERC20, Ownable {
462     using SafeMath for uint256;
463 
464     IUniswapV2Router02 public immutable uniswapV2Router;
465     address public immutable uniswapV2Pair;
466     address public constant deadAddress = address(0xdead);
467 
468     bool private swapping;
469 
470     address public marketingWallet;
471     address public devWallet;
472     address public lpWallet;
473 
474     uint256 public maxTransactionAmount;
475     uint256 public swapTokensAtAmount;
476     uint256 public maxWallet;
477 
478     bool public limitsInEffect = true;
479     bool public tradingActive = false;
480     bool public swapEnabled = false;
481 
482     uint256 public buyTotalFees;
483     uint256 public buyMarketingFee;
484     uint256 public buyLiquidityFee;
485     uint256 public buyDevFee;
486 
487     uint256 public sellTotalFees;
488     uint256 public sellMarketingFee;
489     uint256 public sellLiquidityFee;
490     uint256 public sellDevFee;
491 
492     uint256 public tokensForMarketing;
493     uint256 public tokensForLiquidity;
494     uint256 public tokensForDev;
495 
496     /******************/
497 
498     // exlcude from fees and max transaction amount
499     mapping(address => bool) private _isExcludedFromFees;
500     mapping(address => bool) public _isExcludedMaxTransactionAmount;
501 
502     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
503     // could be subject to a maximum transfer amount
504     mapping(address => bool) public automatedMarketMakerPairs;
505 
506     event UpdateUniswapV2Router(
507         address indexed newAddress,
508         address indexed oldAddress
509     );
510 
511     event LimitsRemoved();
512 
513     event ExcludeFromFees(address indexed account, bool isExcluded);
514 
515     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
516 
517     event marketingWalletUpdated(
518         address indexed newWallet,
519         address indexed oldWallet
520     );
521 
522     event devWalletUpdated(
523         address indexed newWallet,
524         address indexed oldWallet
525     );
526 
527     event lpWalletUpdated(address indexed newWallet, address indexed oldWallet);
528 
529     event SwapAndLiquify(
530         uint256 tokensSwapped,
531         uint256 ethReceived,
532         uint256 tokensIntoLiquidity
533     );
534 
535     constructor() ERC20("Claw", "CLAW") {
536         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
537             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
538         );
539 
540         excludeFromMaxTransaction(address(_uniswapV2Router), true);
541         uniswapV2Router = _uniswapV2Router;
542 
543         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
544             .createPair(address(this), _uniswapV2Router.WETH());
545         excludeFromMaxTransaction(address(uniswapV2Pair), true);
546         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
547 
548         uint256 _buyMarketingFee = 24;
549         uint256 _buyLiquidityFee = 6;
550         uint256 _buyDevFee = 0;
551 
552         uint256 _sellMarketingFee = 40;
553         uint256 _sellLiquidityFee = 10;
554         uint256 _sellDevFee = 0;
555 
556         uint256 totalSupply = 100000000000 * 1e18;
557 
558         maxTransactionAmount = (totalSupply * 1) / 100;
559         maxWallet = (totalSupply * 1) / 100;
560         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
561 
562         buyMarketingFee = _buyMarketingFee;
563         buyLiquidityFee = _buyLiquidityFee;
564         buyDevFee = _buyDevFee;
565         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
566 
567         sellMarketingFee = _sellMarketingFee;
568         sellLiquidityFee = _sellLiquidityFee;
569         sellDevFee = _sellDevFee;
570         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
571 
572         marketingWallet = address(0xAfa0C142bc28bcC35A97559e632FcBe8569Ca327);
573         devWallet = address(0xf70d91885E1CbC0F3E9546Ec78Bf702306Aed424);
574         lpWallet = msg.sender;
575 
576         // exclude from paying fees or having max transaction amount
577         excludeFromFees(owner(), true);
578         excludeFromFees(address(this), true);
579         excludeFromFees(address(0xdead), true);
580         excludeFromFees(marketingWallet, true);
581 
582         excludeFromMaxTransaction(owner(), true);
583         excludeFromMaxTransaction(address(this), true);
584         excludeFromMaxTransaction(address(0xdead), true);
585         excludeFromMaxTransaction(marketingWallet, true);
586 
587         /*
588             _mint is an internal function in ERC20.sol that is only called here,
589             and CANNOT be called ever again
590         */
591         _mint(msg.sender, totalSupply);
592     }
593 
594     receive() external payable {}
595 
596     // once enabled, can never be turned off
597     function enableTrading() external onlyOwner {
598         tradingActive = true;
599         swapEnabled = true;
600     }
601 
602     // remove limits after token is stable
603     function removeLimits() external onlyOwner returns (bool) {
604         limitsInEffect = false;
605         emit LimitsRemoved();
606         return true;
607     }
608 
609     // change the minimum amount of tokens to sell from fees
610     function updateSwapTokensAtAmount(
611         uint256 newAmount
612     ) external onlyOwner returns (bool) {
613         require(
614             newAmount >= (totalSupply() * 1) / 100000,
615             "Swap amount cannot be lower than 0.001% total supply."
616         );
617         require(
618             newAmount <= (totalSupply() * 5) / 1000,
619             "Swap amount cannot be higher than 0.5% total supply."
620         );
621         swapTokensAtAmount = newAmount;
622         return true;
623     }
624 
625     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
626         require(
627             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
628             "Cannot set maxTransactionAmount lower than 0.1%"
629         );
630         maxTransactionAmount = newNum * (10 ** 18);
631     }
632 
633     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
634         require(
635             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
636             "Cannot set maxWallet lower than 0.5%"
637         );
638         maxWallet = newNum * (10 ** 18);
639     }
640 
641     function excludeFromMaxTransaction(
642         address updAds,
643         bool isEx
644     ) public onlyOwner {
645         _isExcludedMaxTransactionAmount[updAds] = isEx;
646     }
647 
648     // only use to disable contract sales if absolutely necessary (emergency use only)
649     function updateSwapEnabled(bool enabled) external onlyOwner {
650         swapEnabled = enabled;
651     }
652 
653     function updateBuyFees(
654         uint256 _marketingFee,
655         uint256 _liquidityFee,
656         uint256 _devFee
657     ) external onlyOwner {
658         buyMarketingFee = _marketingFee;
659         buyLiquidityFee = _liquidityFee;
660         buyDevFee = _devFee;
661         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
662         require(
663             buyTotalFees <= 5,
664             "Buy fees cannot be higher than 5% of transaction."
665         );
666     }
667 
668     function updateSellFees(
669         uint256 _marketingFee,
670         uint256 _liquidityFee,
671         uint256 _devFee
672     ) external onlyOwner {
673         sellMarketingFee = _marketingFee;
674         sellLiquidityFee = _liquidityFee;
675         sellDevFee = _devFee;
676         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
677         require(
678             sellTotalFees <= 10,
679             "Sell fees cannot be higher than 10% of transaction."
680         );
681     }
682 
683     function excludeFromFees(address account, bool excluded) public onlyOwner {
684         _isExcludedFromFees[account] = excluded;
685         emit ExcludeFromFees(account, excluded);
686     }
687 
688     function setAutomatedMarketMakerPair(
689         address pair,
690         bool value
691     ) public onlyOwner {
692         require(
693             pair != uniswapV2Pair,
694             "The pair cannot be removed from automatedMarketMakerPairs"
695         );
696 
697         _setAutomatedMarketMakerPair(pair, value);
698     }
699 
700     function _setAutomatedMarketMakerPair(address pair, bool value) private {
701         automatedMarketMakerPairs[pair] = value;
702 
703         emit SetAutomatedMarketMakerPair(pair, value);
704     }
705 
706     function updateMarketingWallet(
707         address newMarketingWallet
708     ) external onlyOwner {
709         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
710         marketingWallet = newMarketingWallet;
711     }
712 
713     function updateLPWallet(address newLPWallet) external onlyOwner {
714         emit lpWalletUpdated(newLPWallet, lpWallet);
715         lpWallet = newLPWallet;
716     }
717 
718     function updateDevWallet(address newWallet) external onlyOwner {
719         emit devWalletUpdated(newWallet, devWallet);
720         devWallet = newWallet;
721     }
722 
723     function isExcludedFromFees(address account) public view returns (bool) {
724         return _isExcludedFromFees[account];
725     }
726 
727     event BoughtEarly(address indexed sniper);
728 
729     function _transfer(
730         address from,
731         address to,
732         uint256 amount
733     ) internal override {
734         require(from != address(0), "ERC20: transfer from the zero address");
735         require(to != address(0), "ERC20: transfer to the zero address");
736 
737         if (amount == 0) {
738             super._transfer(from, to, 0);
739             return;
740         }
741 
742         if (limitsInEffect) {
743             if (
744                 from != owner() &&
745                 to != owner() &&
746                 to != address(0) &&
747                 to != address(0xdead) &&
748                 !swapping
749             ) {
750                 if (!tradingActive) {
751                     require(
752                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
753                         "Trading is not active."
754                     );
755                 }
756 
757                 //when buy
758                 if (
759                     automatedMarketMakerPairs[from] &&
760                     !_isExcludedMaxTransactionAmount[to]
761                 ) {
762                     require(
763                         amount <= maxTransactionAmount,
764                         "Buy transfer amount exceeds the maxTransactionAmount."
765                     );
766                     require(
767                         amount + balanceOf(to) <= maxWallet,
768                         "Max wallet exceeded"
769                     );
770                 }
771                 //when sell
772                 else if (
773                     automatedMarketMakerPairs[to] &&
774                     !_isExcludedMaxTransactionAmount[from]
775                 ) {
776                     require(
777                         amount <= maxTransactionAmount,
778                         "Sell transfer amount exceeds the maxTransactionAmount."
779                     );
780                 } else if (!_isExcludedMaxTransactionAmount[to]) {
781                     require(
782                         amount + balanceOf(to) <= maxWallet,
783                         "Max wallet exceeded"
784                     );
785                 }
786             }
787         }
788 
789         uint256 contractTokenBalance = balanceOf(address(this));
790 
791         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
792 
793         if (
794             canSwap &&
795             swapEnabled &&
796             !swapping &&
797             !automatedMarketMakerPairs[from] &&
798             !_isExcludedFromFees[from] &&
799             !_isExcludedFromFees[to]
800         ) {
801             swapping = true;
802 
803             swapBack();
804 
805             swapping = false;
806         }
807 
808         bool takeFee = !swapping;
809 
810         // if any account belongs to _isExcludedFromFee account then remove the fee
811         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
812             takeFee = false;
813         }
814 
815         uint256 fees = 0;
816         // only take fees on buys/sells, do not take on wallet transfers
817         if (takeFee) {
818             // on sell
819             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
820                 fees = amount.mul(sellTotalFees).div(100);
821                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
822                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
823                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
824             }
825             // on buy
826             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
827                 fees = amount.mul(buyTotalFees).div(100);
828                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
829                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
830                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
831             }
832 
833             if (fees > 0) {
834                 super._transfer(from, address(this), fees);
835             }
836 
837             amount -= fees;
838         }
839 
840         super._transfer(from, to, amount);
841     }
842 
843     function swapTokensForEth(uint256 tokenAmount) private {
844         // generate the uniswap pair path of token -> weth
845         address[] memory path = new address[](2);
846         path[0] = address(this);
847         path[1] = uniswapV2Router.WETH();
848 
849         _approve(address(this), address(uniswapV2Router), tokenAmount);
850 
851         // make the swap
852         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
853             tokenAmount,
854             0, // accept any amount of ETH
855             path,
856             address(this),
857             block.timestamp
858         );
859     }
860 
861     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
862         // approve token transfer to cover all possible scenarios
863         _approve(address(this), address(uniswapV2Router), tokenAmount);
864 
865         // add the liquidity
866         uniswapV2Router.addLiquidityETH{value: ethAmount}(
867             address(this),
868             tokenAmount,
869             0, // slippage is unavoidable
870             0, // slippage is unavoidable
871             lpWallet,
872             block.timestamp
873         );
874     }
875 
876     function swapBack() private {
877         uint256 contractBalance = balanceOf(address(this));
878         uint256 totalTokensToSwap = tokensForLiquidity +
879             tokensForMarketing +
880             tokensForDev;
881         bool success;
882 
883         if (contractBalance == 0 || totalTokensToSwap == 0) {
884             return;
885         }
886 
887         // Halve the amount of liquidity tokens
888         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
889             totalTokensToSwap /
890             2;
891         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
892 
893         uint256 initialETHBalance = address(this).balance;
894 
895         swapTokensForEth(amountToSwapForETH);
896 
897         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
898 
899         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
900             totalTokensToSwap
901         );
902         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
903 
904         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
905 
906         tokensForLiquidity = 0;
907         tokensForMarketing = 0;
908         tokensForDev = 0;
909 
910         (success, ) = address(devWallet).call{value: ethForDev}("");
911 
912         if (liquidityTokens > 0 && ethForLiquidity > 0) {
913             addLiquidity(liquidityTokens, ethForLiquidity);
914             emit SwapAndLiquify(
915                 amountToSwapForETH,
916                 ethForLiquidity,
917                 tokensForLiquidity
918             );
919         }
920 
921         (success, ) = address(marketingWallet).call{
922             value: address(this).balance
923         }("");
924     }
925 
926     function airdrop(
927         address[] memory recipients,
928         uint256[] memory amounts
929     ) external onlyOwner {
930         require(
931             recipients.length == amounts.length,
932             "recipients and amounts must be same length"
933         );
934         for (uint256 i = 0; i < recipients.length; i++) {
935             super._transfer(msg.sender, recipients[i], amounts[i]);
936         }
937     }
938 }