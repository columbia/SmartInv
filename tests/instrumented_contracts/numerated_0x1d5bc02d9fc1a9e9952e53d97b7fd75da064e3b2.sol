1 /**
2  Telegram: https://t.me/wrappedpepetwo
3 */
4 
5 //  SPDX-License-Identifier: MIT
6 pragma solidity >=0.8.19;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 
13 }
14 
15 abstract contract Ownable is Context {
16     address private _owner;
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20     constructor() {
21         _transferOwnership(_msgSender());
22     }
23 
24     function owner() public view virtual returns (address) {
25         return _owner;
26     }
27 
28     modifier onlyOwner() {
29         require(owner() == _msgSender(), "Ownable: caller is not the owner");
30         _;
31     }
32 
33     function renounceOwnership() public virtual onlyOwner {
34         _transferOwnership(address(0));
35     }
36 
37     function transferOwnership(address newOwner) public virtual onlyOwner {
38         require(newOwner != address(0), "Ownable: new owner is the zero address");
39         _transferOwnership(newOwner);
40     }
41 
42     function _transferOwnership(address newOwner) internal virtual {
43         address oldOwner = _owner;
44         _owner = newOwner;
45         emit OwnershipTransferred(oldOwner, newOwner);
46     }
47 }
48 
49 interface IERC20 {
50 
51     function totalSupply() external view returns (uint256);
52 
53     function balanceOf(address account) external view returns (uint256);
54 
55     function transfer(address recipient, uint256 amount) external returns (bool);
56 
57     function allowance(address owner, address spender) external view returns (uint256);
58 
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     function transferFrom(
62         address sender,
63         address recipient,
64         uint256 amount
65     ) external returns (bool);
66 
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 interface IERC20Metadata is IERC20 {
73 
74     function name() external view returns (string memory);
75 
76     function symbol() external view returns (string memory);
77 
78     function decimals() external view returns (uint8);
79 }
80 
81 contract ERC20 is Context, IERC20, IERC20Metadata {
82     mapping(address => uint256) private _balances;
83 
84     mapping(address => mapping(address => uint256)) private _allowances;
85 
86     uint256 private _totalSupply;
87 
88     string private _name;
89     string private _symbol;
90 
91     constructor(string memory name_, string memory symbol_) {
92         _name = name_;
93         _symbol = symbol_;
94     }
95 
96     function name() public view virtual override returns (string memory) {
97         return _name;
98     }
99 
100     function symbol() public view virtual override returns (string memory) {
101         return _symbol;
102     }
103 
104     function decimals() public view virtual override returns (uint8) {
105         return 18;
106     }
107 
108     function totalSupply() public view virtual override returns (uint256) {
109         return _totalSupply;
110     }
111 
112     function balanceOf(address account) public view virtual override returns (uint256) {
113         return _balances[account];
114     }
115 
116     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
117         _transfer(_msgSender(), recipient, amount);
118         return true;
119     }
120 
121     function allowance(address owner, address spender) public view virtual override returns (uint256) {
122         return _allowances[owner][spender];
123     }
124 
125     function approve(address spender, uint256 amount) public virtual override returns (bool) {
126         _approve(_msgSender(), spender, amount);
127         return true;
128     }
129 
130     function transferFrom(
131         address sender,
132         address recipient,
133         uint256 amount
134     ) public virtual override returns (bool) {
135         _transfer(sender, recipient, amount);
136 
137         uint256 currentAllowance = _allowances[sender][_msgSender()];
138         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
139         unchecked {
140             _approve(sender, _msgSender(), currentAllowance - amount);
141         }
142 
143         return true;
144     }
145 
146     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
147         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
148         return true;
149     }
150 
151     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
152         uint256 currentAllowance = _allowances[_msgSender()][spender];
153         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
154         unchecked {
155             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
156         }
157 
158         return true;
159     }
160 
161     function _transfer(
162         address sender,
163         address recipient,
164         uint256 amount
165     ) internal virtual {
166         require(sender != address(0), "ERC20: transfer from the zero address");
167         require(recipient != address(0), "ERC20: transfer to the zero address");
168 
169         _beforeTokenTransfer(sender, recipient, amount);
170 
171         uint256 senderBalance = _balances[sender];
172         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
173         unchecked {
174             _balances[sender] = senderBalance - amount;
175         }
176         _balances[recipient] += amount;
177 
178         emit Transfer(sender, recipient, amount);
179 
180         _afterTokenTransfer(sender, recipient, amount);
181     }
182 
183     function _mint(address account, uint256 amount) internal virtual {
184         require(account != address(0), "ERC20: mint to the zero address");
185 
186         _beforeTokenTransfer(address(0), account, amount);
187 
188         _totalSupply += amount;
189         _balances[account] += amount;
190         emit Transfer(address(0), account, amount);
191 
192         _afterTokenTransfer(address(0), account, amount);
193     }
194 
195     function _approve(
196         address owner,
197         address spender,
198         uint256 amount
199     ) internal virtual {
200         require(owner != address(0), "ERC20: approve from the zero address");
201         require(spender != address(0), "ERC20: approve to the zero address");
202 
203         _allowances[owner][spender] = amount;
204         emit Approval(owner, spender, amount);
205     }
206 
207     function _beforeTokenTransfer(
208         address from,
209         address to,
210         uint256 amount
211     ) internal virtual {}
212 
213     function _afterTokenTransfer(
214         address from,
215         address to,
216         uint256 amount
217     ) internal virtual {}
218 }
219 
220 library SafeMath {
221 
222     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
223         return a - b;
224     }
225 
226     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
227         return a * b;
228     }
229 
230     function div(uint256 a, uint256 b) internal pure returns (uint256) {
231         return a / b;
232     }
233 } 
234 
235 interface IUniswapV2Factory {
236     event PairCreated(
237         address indexed token0,
238         address indexed token1,
239         address pair,
240         uint256
241     );
242 
243     function feeTo() external view returns (address);
244 
245     function feeToSetter() external view returns (address);
246 
247     function getPair(address tokenA, address tokenB)
248         external
249         view
250         returns (address pair);
251 
252     function allPairs(uint256) external view returns (address pair);
253 
254     function allPairsLength() external view returns (uint256);
255 
256     function createPair(address tokenA, address tokenB)
257         external
258         returns (address pair);
259 
260     function setFeeTo(address) external;
261 
262     function setFeeToSetter(address) external;
263 }
264 
265 interface IUniswapV2Pair {
266     event Approval(
267         address indexed owner,
268         address indexed spender,
269         uint256 value
270     );
271     event Transfer(address indexed from, address indexed to, uint256 value);
272 
273     function name() external pure returns (string memory);
274 
275     function symbol() external pure returns (string memory);
276 
277     function decimals() external pure returns (uint8);
278 
279     function totalSupply() external view returns (uint256);
280 
281     function balanceOf(address owner) external view returns (uint256);
282 
283     function allowance(address owner, address spender)
284         external
285         view
286         returns (uint256);
287 
288     function approve(address spender, uint256 value) external returns (bool);
289 
290     function transfer(address to, uint256 value) external returns (bool);
291 
292     function transferFrom(
293         address from,
294         address to,
295         uint256 value
296     ) external returns (bool);
297 
298     function DOMAIN_SEPARATOR() external view returns (bytes32);
299 
300     function PERMIT_TYPEHASH() external pure returns (bytes32);
301 
302     function nonces(address owner) external view returns (uint256);
303 
304     function permit(
305         address owner,
306         address spender,
307         uint256 value,
308         uint256 deadline,
309         uint8 v,
310         bytes32 r,
311         bytes32 s
312     ) external;
313 
314     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
315     event Burn(
316         address indexed sender,
317         uint256 amount0,
318         uint256 amount1,
319         address indexed to
320     );
321     event Swap(
322         address indexed sender,
323         uint256 amount0In,
324         uint256 amount1In,
325         uint256 amount0Out,
326         uint256 amount1Out,
327         address indexed to
328     );
329     event Sync(uint112 reserve0, uint112 reserve1);
330 
331     function MINIMUM_LIQUIDITY() external pure returns (uint256);
332 
333     function factory() external view returns (address);
334 
335     function token0() external view returns (address);
336 
337     function token1() external view returns (address);
338 
339     function getReserves()
340         external
341         view
342         returns (
343             uint112 reserve0,
344             uint112 reserve1,
345             uint32 blockTimestampLast
346         );
347 
348     function price0CumulativeLast() external view returns (uint256);
349 
350     function price1CumulativeLast() external view returns (uint256);
351 
352     function kLast() external view returns (uint256);
353 
354     function mint(address to) external returns (uint256 liquidity);
355 
356     function burn(address to)
357         external
358         returns (uint256 amount0, uint256 amount1);
359 
360     function swap(
361         uint256 amount0Out,
362         uint256 amount1Out,
363         address to,
364         bytes calldata data
365     ) external;
366 
367     function skim(address to) external;
368 
369     function sync() external;
370 
371     function initialize(address, address) external;
372 }
373 
374 interface IUniswapV2Router02 {
375     function factory() external pure returns (address);
376 
377     function WETH() external pure returns (address);
378 
379     function addLiquidity(
380         address tokenA,
381         address tokenB,
382         uint256 amountADesired,
383         uint256 amountBDesired,
384         uint256 amountAMin,
385         uint256 amountBMin,
386         address to,
387         uint256 deadline
388     )
389         external
390         returns (
391             uint256 amountA,
392             uint256 amountB,
393             uint256 liquidity
394         );
395 
396     function addLiquidityETH(
397         address token,
398         uint256 amountTokenDesired,
399         uint256 amountTokenMin,
400         uint256 amountETHMin,
401         address to,
402         uint256 deadline
403     )
404         external
405         payable
406         returns (
407             uint256 amountToken,
408             uint256 amountETH,
409             uint256 liquidity
410         );
411 
412     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
413         uint256 amountIn,
414         uint256 amountOutMin,
415         address[] calldata path,
416         address to,
417         uint256 deadline
418     ) external;
419 
420     function swapExactETHForTokensSupportingFeeOnTransferTokens(
421         uint256 amountOutMin,
422         address[] calldata path,
423         address to,
424         uint256 deadline
425     ) external payable;
426 
427     function swapExactTokensForETHSupportingFeeOnTransferTokens(
428         uint256 amountIn,
429         uint256 amountOutMin,
430         address[] calldata path,
431         address to,
432         uint256 deadline
433     ) external;
434 }
435 
436 contract WRAPPEDPEPE2 is ERC20, Ownable {
437     using SafeMath for uint256;
438 
439     IUniswapV2Router02 public immutable uniswapV2Router;
440     address public immutable uniswapV2Pair;
441     address public constant deadAddress = address(0xdead);
442 
443     bool private swapping;
444 
445     address public marketingWallet;
446     address public devWallet;
447     address public lpWallet;
448 
449     uint256 public maxTransactionAmount;
450     uint256 public swapTokensAtAmount;
451     uint256 public maxWallet;
452 
453     bool public limitsInEffect = true;
454     bool public tradingActive = true;
455     bool public swapEnabled = true;
456 
457     uint256 public buyTotalFees;
458     uint256 public buyMarketingFee;
459     uint256 public buyLiquidityFee;
460     uint256 public buyDevFee;
461 
462     uint256 public sellTotalFees;
463     uint256 public sellMarketingFee;
464     uint256 public sellLiquidityFee;
465     uint256 public sellDevFee;
466 
467     uint256 public tokensForMarketing;
468     uint256 public tokensForLiquidity;
469     uint256 public tokensForDev;
470 
471     /******************/
472 
473     // exlcude from fees and max transaction amount
474     mapping(address => bool) private _isExcludedFromFees;
475     mapping(address => bool) public _isExcludedMaxTransactionAmount;
476 
477     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
478     // could be subject to a maximum transfer amount
479     mapping(address => bool) public automatedMarketMakerPairs;
480 
481     event UpdateUniswapV2Router(
482         address indexed newAddress,
483         address indexed oldAddress
484     );
485 
486     event LimitsRemoved();
487 
488     event ExcludeFromFees(address indexed account, bool isExcluded);
489 
490     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
491 
492     event marketingWalletUpdated(
493         address indexed newWallet,
494         address indexed oldWallet
495     );
496 
497     event devWalletUpdated(
498         address indexed newWallet,
499         address indexed oldWallet
500     );
501 
502     event lpWalletUpdated(
503         address indexed newWallet,
504         address indexed oldWallet
505     );
506 
507     event SwapAndLiquify(
508         uint256 tokensSwapped,
509         uint256 ethReceived,
510         uint256 tokensIntoLiquidity
511     );
512 
513     constructor() ERC20("WRAPPED PEPE 2.0", "WPEPE2.0") {
514         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
515             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
516         );
517 
518         excludeFromMaxTransaction(address(_uniswapV2Router), true);
519         uniswapV2Router = _uniswapV2Router;
520 
521         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
522             .createPair(address(this), _uniswapV2Router.WETH());
523         excludeFromMaxTransaction(address(uniswapV2Pair), true);
524         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
525 
526         uint256 _buyMarketingFee = 18;
527         uint256 _buyLiquidityFee = 0;
528         uint256 _buyDevFee = 18;
529 
530         uint256 _sellMarketingFee = 18;
531         uint256 _sellLiquidityFee = 0;
532         uint256 _sellDevFee = 18;
533 
534         uint256 totalSupply = 1000000000 * 1e18;
535 
536         maxTransactionAmount = (totalSupply * 2) / 100;
537         maxWallet = (totalSupply * 2) / 100;
538         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
539 
540         buyMarketingFee = _buyMarketingFee;
541         buyLiquidityFee = _buyLiquidityFee;
542         buyDevFee = _buyDevFee;
543         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
544 
545         sellMarketingFee = _sellMarketingFee;
546         sellLiquidityFee = _sellLiquidityFee;
547         sellDevFee = _sellDevFee;
548         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
549 
550         marketingWallet = address(0xd610e9097A5024335f2F9aBD3A1fd65B0C4B43c8); 
551         devWallet = address(0xF67BDBe70DA96336dED5bE0807316673955D25e2);
552         lpWallet = msg.sender;
553 
554         // exclude from paying fees or having max transaction amount
555         excludeFromFees(owner(), true);
556         excludeFromFees(address(this), true);
557         excludeFromFees(address(0xdead), true);
558         excludeFromFees(marketingWallet, true);
559 
560         excludeFromMaxTransaction(owner(), true);
561         excludeFromMaxTransaction(address(this), true);
562         excludeFromMaxTransaction(address(0xdead), true);
563         excludeFromMaxTransaction(marketingWallet, true);
564 
565         /*
566             _mint is an internal function in ERC20.sol that is only called here,
567             and CANNOT be called ever again
568         */
569         _mint(msg.sender, totalSupply);
570     }
571 
572     receive() external payable {}
573 
574     // once enabled, can never be turned off
575     function enableTrading() external onlyOwner {
576         tradingActive = true;
577         swapEnabled = true;
578     }
579 
580     // remove limits after token is stable
581     function removeLimits() external onlyOwner returns (bool) {
582         limitsInEffect = false;
583         emit LimitsRemoved();
584         return true;
585     }
586 
587     // change the minimum amount of tokens to sell from fees
588     function updateSwapTokensAtAmount(uint256 newAmount)
589         external
590         onlyOwner
591         returns (bool)
592     {
593         require(
594             newAmount >= (totalSupply() * 1) / 100000,
595             "Swap amount cannot be lower than 0.001% total supply."
596         );
597         require(
598             newAmount <= (totalSupply() * 5) / 1000,
599             "Swap amount cannot be higher than 0.5% total supply."
600         );
601         swapTokensAtAmount = newAmount;
602         return true;
603     }
604 
605     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
606         require(
607             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
608             "Cannot set maxTransactionAmount lower than 0.1%"
609         );
610         maxTransactionAmount = newNum * (10**18);
611     }
612 
613     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
614         require(
615             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
616             "Cannot set maxWallet lower than 0.5%"
617         );
618         maxWallet = newNum * (10**18);
619     }
620 
621     function excludeFromMaxTransaction(address updAds, bool isEx)
622         public
623         onlyOwner
624     {
625         _isExcludedMaxTransactionAmount[updAds] = isEx;
626     }
627 
628     // only use to disable contract sales if absolutely necessary (emergency use only)
629     function updateSwapEnabled(bool enabled) external onlyOwner {
630         swapEnabled = enabled;
631     }
632 
633     function updateBuyFees(
634         uint256 _marketingFee,
635         uint256 _liquidityFee,
636         uint256 _devFee
637     ) external onlyOwner {
638         buyMarketingFee = _marketingFee;
639         buyLiquidityFee = _liquidityFee;
640         buyDevFee = _devFee;
641         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
642     }
643 
644     function updateSellFees(
645         uint256 _marketingFee,
646         uint256 _liquidityFee,
647         uint256 _devFee
648     ) external onlyOwner {
649         sellMarketingFee = _marketingFee;
650         sellLiquidityFee = _liquidityFee;
651         sellDevFee = _devFee;
652         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
653     }
654 
655     function excludeFromFees(address account, bool excluded) public onlyOwner {
656         _isExcludedFromFees[account] = excluded;
657         emit ExcludeFromFees(account, excluded);
658     }
659 
660     function setAutomatedMarketMakerPair(address pair, bool value)
661         public
662         onlyOwner
663     {
664         require(
665             pair != uniswapV2Pair,
666             "The pair cannot be removed from automatedMarketMakerPairs"
667         );
668 
669         _setAutomatedMarketMakerPair(pair, value);
670     }
671 
672     function _setAutomatedMarketMakerPair(address pair, bool value) private {
673         automatedMarketMakerPairs[pair] = value;
674 
675         emit SetAutomatedMarketMakerPair(pair, value);
676     }
677 
678     function updateMarketingWallet(address newMarketingWallet)
679         external
680         onlyOwner
681     {
682         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
683         marketingWallet = newMarketingWallet;
684     }
685 
686     function updateLPWallet(address newLPWallet)
687         external
688         onlyOwner
689     {
690         emit lpWalletUpdated(newLPWallet, lpWallet);
691         lpWallet = newLPWallet;
692     }
693 
694     function updateDevWallet(address newWallet) external onlyOwner {
695         emit devWalletUpdated(newWallet, devWallet);
696         devWallet = newWallet;
697     }
698 
699     function isExcludedFromFees(address account) public view returns (bool) {
700         return _isExcludedFromFees[account];
701     }
702 
703     event BoughtEarly(address indexed sniper);
704 
705     function _transfer(
706         address from,
707         address to,
708         uint256 amount
709     ) internal override {
710         require(from != address(0), "ERC20: transfer from the zero address");
711         require(to != address(0), "ERC20: transfer to the zero address");
712 
713         if (amount == 0) {
714             super._transfer(from, to, 0);
715             return;
716         }
717 
718         if (limitsInEffect) {
719             if (
720                 from != owner() &&
721                 to != owner() &&
722                 to != address(0) &&
723                 to != address(0xdead) &&
724                 !swapping
725             ) {
726                 if (!tradingActive) {
727                     require(
728                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
729                         "Trading is not active."
730                     );
731                 }
732 
733                 //when buy
734                 if (
735                     automatedMarketMakerPairs[from] &&
736                     !_isExcludedMaxTransactionAmount[to]
737                 ) {
738                     require(
739                         amount <= maxTransactionAmount,
740                         "Buy transfer amount exceeds the maxTransactionAmount."
741                     );
742                     require(
743                         amount + balanceOf(to) <= maxWallet,
744                         "Max wallet exceeded"
745                     );
746                 }
747                 //when sell
748                 else if (
749                     automatedMarketMakerPairs[to] &&
750                     !_isExcludedMaxTransactionAmount[from]
751                 ) {
752                     require(
753                         amount <= maxTransactionAmount,
754                         "Sell transfer amount exceeds the maxTransactionAmount."
755                     );
756                 } else if (!_isExcludedMaxTransactionAmount[to]) {
757                     require(
758                         amount + balanceOf(to) <= maxWallet,
759                         "Max wallet exceeded"
760                     );
761                 }
762             }
763         }
764 
765         uint256 contractTokenBalance = balanceOf(address(this));
766 
767         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
768 
769         if (
770             canSwap &&
771             swapEnabled &&
772             !swapping &&
773             !automatedMarketMakerPairs[from] &&
774             !_isExcludedFromFees[from] &&
775             !_isExcludedFromFees[to]
776         ) {
777             swapping = true;
778 
779             swapBack();
780 
781             swapping = false;
782         }
783 
784         bool takeFee = !swapping;
785 
786         // if any account belongs to _isExcludedFromFee account then remove the fee
787         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
788             takeFee = false;
789         }
790 
791         uint256 fees = 0;
792         // only take fees on buys/sells, do not take on wallet transfers
793         if (takeFee) {
794             // on sell
795             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
796                 fees = amount.mul(sellTotalFees).div(100);
797                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
798                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
799                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
800             }
801             // on buy
802             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
803                 fees = amount.mul(buyTotalFees).div(100);
804                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
805                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
806                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
807             }
808 
809             if (fees > 0) {
810                 super._transfer(from, address(this), fees);
811             }
812 
813             amount -= fees;
814         }
815 
816         super._transfer(from, to, amount);
817     }
818 
819     function swapTokensForEth(uint256 tokenAmount) private {
820         // generate the uniswap pair path of token -> weth
821         address[] memory path = new address[](2);
822         path[0] = address(this);
823         path[1] = uniswapV2Router.WETH();
824 
825         _approve(address(this), address(uniswapV2Router), tokenAmount);
826 
827         // make the swap
828         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
829             tokenAmount,
830             0, // accept any amount of ETH
831             path,
832             address(this),
833             block.timestamp
834         );
835     }
836 
837     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
838         // approve token transfer to cover all possible scenarios
839         _approve(address(this), address(uniswapV2Router), tokenAmount);
840 
841         // add the liquidity
842         uniswapV2Router.addLiquidityETH{value: ethAmount}(
843             address(this),
844             tokenAmount,
845             0, // slippage is unavoidable
846             0, // slippage is unavoidable
847             lpWallet,
848             block.timestamp
849         );
850     }
851 
852     function swapBack() private {
853         uint256 contractBalance = balanceOf(address(this));
854         uint256 totalTokensToSwap = tokensForLiquidity +
855             tokensForMarketing +
856             tokensForDev;
857         bool success;
858 
859         if (contractBalance == 0 || totalTokensToSwap == 0) {
860             return;
861         }
862 
863         // Halve the amount of liquidity tokens
864         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
865             totalTokensToSwap /
866             2;
867         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
868 
869         uint256 initialETHBalance = address(this).balance;
870 
871         swapTokensForEth(amountToSwapForETH);
872 
873         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
874 
875         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
876             totalTokensToSwap
877         );
878         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
879 
880         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
881 
882         tokensForLiquidity = 0;
883         tokensForMarketing = 0;
884         tokensForDev = 0;
885 
886         (success, ) = address(devWallet).call{value: ethForDev}("");
887 
888         if (liquidityTokens > 0 && ethForLiquidity > 0) {
889             addLiquidity(liquidityTokens, ethForLiquidity);
890             emit SwapAndLiquify(
891                 amountToSwapForETH,
892                 ethForLiquidity,
893                 tokensForLiquidity
894             );
895         }
896 
897         (success, ) = address(marketingWallet).call{
898             value: address(this).balance
899         }("");
900     }
901 }