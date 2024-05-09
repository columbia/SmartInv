1 //  SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.19;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9 }
10 
11 abstract contract Ownable is Context {
12     address private _owner;
13 
14     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16     constructor() {
17         _transferOwnership(_msgSender());
18     }
19 
20     function owner() public view virtual returns (address) {
21         return _owner;
22     }
23 
24     modifier onlyOwner() {
25         require(owner() == _msgSender(), "Ownable: caller is not the owner");
26         _;
27     }
28 
29     function renounceOwnership() public virtual onlyOwner {
30         _transferOwnership(address(0));
31     }
32 
33     function transferOwnership(address newOwner) public virtual onlyOwner {
34         require(newOwner != address(0), "Ownable: new owner is the zero address");
35         _transferOwnership(newOwner);
36     }
37 
38     function _transferOwnership(address newOwner) internal virtual {
39         address oldOwner = _owner;
40         _owner = newOwner;
41         emit OwnershipTransferred(oldOwner, newOwner);
42     }
43 }
44 
45 interface IERC20 {
46 
47     function totalSupply() external view returns (uint256);
48 
49     function balanceOf(address account) external view returns (uint256);
50 
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     function transferFrom(
58         address sender,
59         address recipient,
60         uint256 amount
61     ) external returns (bool);
62 
63     event Transfer(address indexed from, address indexed to, uint256 value);
64 
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 interface IERC20Metadata is IERC20 {
69 
70     function name() external view returns (string memory);
71 
72     function symbol() external view returns (string memory);
73 
74     function decimals() external view returns (uint8);
75 }
76 
77 contract ERC20 is Context, IERC20, IERC20Metadata {
78     mapping(address => uint256) private _balances;
79 
80     mapping(address => mapping(address => uint256)) private _allowances;
81 
82     uint256 private _totalSupply;
83 
84     string private _name;
85     string private _symbol;
86 
87     constructor(string memory name_, string memory symbol_) {
88         _name = name_;
89         _symbol = symbol_;
90     }
91 
92     function name() public view virtual override returns (string memory) {
93         return _name;
94     }
95 
96     function symbol() public view virtual override returns (string memory) {
97         return _symbol;
98     }
99 
100     function decimals() public view virtual override returns (uint8) {
101         return 18;
102     }
103 
104     function totalSupply() public view virtual override returns (uint256) {
105         return _totalSupply;
106     }
107 
108     function balanceOf(address account) public view virtual override returns (uint256) {
109         return _balances[account];
110     }
111 
112     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
113         _transfer(_msgSender(), recipient, amount);
114         return true;
115     }
116 
117     function allowance(address owner, address spender) public view virtual override returns (uint256) {
118         return _allowances[owner][spender];
119     }
120 
121     function approve(address spender, uint256 amount) public virtual override returns (bool) {
122         _approve(_msgSender(), spender, amount);
123         return true;
124     }
125 
126     function transferFrom(
127         address sender,
128         address recipient,
129         uint256 amount
130     ) public virtual override returns (bool) {
131         _transfer(sender, recipient, amount);
132 
133         uint256 currentAllowance = _allowances[sender][_msgSender()];
134         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
135         unchecked {
136             _approve(sender, _msgSender(), currentAllowance - amount);
137         }
138 
139         return true;
140     }
141 
142     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
143         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
144         return true;
145     }
146 
147     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
148         uint256 currentAllowance = _allowances[_msgSender()][spender];
149         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
150         unchecked {
151             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
152         }
153 
154         return true;
155     }
156 
157     function _transfer(
158         address sender,
159         address recipient,
160         uint256 amount
161     ) internal virtual {
162         require(sender != address(0), "ERC20: transfer from the zero address");
163         require(recipient != address(0), "ERC20: transfer to the zero address");
164 
165         _beforeTokenTransfer(sender, recipient, amount);
166 
167         uint256 senderBalance = _balances[sender];
168         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
169         unchecked {
170             _balances[sender] = senderBalance - amount;
171         }
172         _balances[recipient] += amount;
173 
174         emit Transfer(sender, recipient, amount);
175 
176         _afterTokenTransfer(sender, recipient, amount);
177     }
178 
179     function _mint(address account, uint256 amount) internal virtual {
180         require(account != address(0), "ERC20: mint to the zero address");
181 
182         _beforeTokenTransfer(address(0), account, amount);
183 
184         _totalSupply += amount;
185         _balances[account] += amount;
186         emit Transfer(address(0), account, amount);
187 
188         _afterTokenTransfer(address(0), account, amount);
189     }
190 
191     function _approve(
192         address owner,
193         address spender,
194         uint256 amount
195     ) internal virtual {
196         require(owner != address(0), "ERC20: approve from the zero address");
197         require(spender != address(0), "ERC20: approve to the zero address");
198 
199         _allowances[owner][spender] = amount;
200         emit Approval(owner, spender, amount);
201     }
202 
203     function _beforeTokenTransfer(
204         address from,
205         address to,
206         uint256 amount
207     ) internal virtual {}
208 
209     function _afterTokenTransfer(
210         address from,
211         address to,
212         uint256 amount
213     ) internal virtual {}
214 }
215 
216 library SafeMath {
217 
218     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
219         return a - b;
220     }
221 
222     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
223         return a * b;
224     }
225 
226     function div(uint256 a, uint256 b) internal pure returns (uint256) {
227         return a / b;
228     }
229 } 
230 
231 interface IUniswapV2Factory {
232     event PairCreated(
233         address indexed token0,
234         address indexed token1,
235         address pair,
236         uint256
237     );
238 
239     function feeTo() external view returns (address);
240 
241     function feeToSetter() external view returns (address);
242 
243     function getPair(address tokenA, address tokenB)
244         external
245         view
246         returns (address pair);
247 
248     function allPairs(uint256) external view returns (address pair);
249 
250     function allPairsLength() external view returns (uint256);
251 
252     function createPair(address tokenA, address tokenB)
253         external
254         returns (address pair);
255 
256     function setFeeTo(address) external;
257 
258     function setFeeToSetter(address) external;
259 }
260 
261 interface IUniswapV2Pair {
262     event Approval(
263         address indexed owner,
264         address indexed spender,
265         uint256 value
266     );
267     event Transfer(address indexed from, address indexed to, uint256 value);
268 
269     function name() external pure returns (string memory);
270 
271     function symbol() external pure returns (string memory);
272 
273     function decimals() external pure returns (uint8);
274 
275     function totalSupply() external view returns (uint256);
276 
277     function balanceOf(address owner) external view returns (uint256);
278 
279     function allowance(address owner, address spender)
280         external
281         view
282         returns (uint256);
283 
284     function approve(address spender, uint256 value) external returns (bool);
285 
286     function transfer(address to, uint256 value) external returns (bool);
287 
288     function transferFrom(
289         address from,
290         address to,
291         uint256 value
292     ) external returns (bool);
293 
294     function DOMAIN_SEPARATOR() external view returns (bytes32);
295 
296     function PERMIT_TYPEHASH() external pure returns (bytes32);
297 
298     function nonces(address owner) external view returns (uint256);
299 
300     function permit(
301         address owner,
302         address spender,
303         uint256 value,
304         uint256 deadline,
305         uint8 v,
306         bytes32 r,
307         bytes32 s
308     ) external;
309 
310     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
311     event Burn(
312         address indexed sender,
313         uint256 amount0,
314         uint256 amount1,
315         address indexed to
316     );
317     event Swap(
318         address indexed sender,
319         uint256 amount0In,
320         uint256 amount1In,
321         uint256 amount0Out,
322         uint256 amount1Out,
323         address indexed to
324     );
325     event Sync(uint112 reserve0, uint112 reserve1);
326 
327     function MINIMUM_LIQUIDITY() external pure returns (uint256);
328 
329     function factory() external view returns (address);
330 
331     function token0() external view returns (address);
332 
333     function token1() external view returns (address);
334 
335     function getReserves()
336         external
337         view
338         returns (
339             uint112 reserve0,
340             uint112 reserve1,
341             uint32 blockTimestampLast
342         );
343 
344     function price0CumulativeLast() external view returns (uint256);
345 
346     function price1CumulativeLast() external view returns (uint256);
347 
348     function kLast() external view returns (uint256);
349 
350     function mint(address to) external returns (uint256 liquidity);
351 
352     function burn(address to)
353         external
354         returns (uint256 amount0, uint256 amount1);
355 
356     function swap(
357         uint256 amount0Out,
358         uint256 amount1Out,
359         address to,
360         bytes calldata data
361     ) external;
362 
363     function skim(address to) external;
364 
365     function sync() external;
366 
367     function initialize(address, address) external;
368 }
369 
370 interface IUniswapV2Router02 {
371     function factory() external pure returns (address);
372 
373     function WETH() external pure returns (address);
374 
375     function addLiquidity(
376         address tokenA,
377         address tokenB,
378         uint256 amountADesired,
379         uint256 amountBDesired,
380         uint256 amountAMin,
381         uint256 amountBMin,
382         address to,
383         uint256 deadline
384     )
385         external
386         returns (
387             uint256 amountA,
388             uint256 amountB,
389             uint256 liquidity
390         );
391 
392     function addLiquidityETH(
393         address token,
394         uint256 amountTokenDesired,
395         uint256 amountTokenMin,
396         uint256 amountETHMin,
397         address to,
398         uint256 deadline
399     )
400         external
401         payable
402         returns (
403             uint256 amountToken,
404             uint256 amountETH,
405             uint256 liquidity
406         );
407 
408     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
409         uint256 amountIn,
410         uint256 amountOutMin,
411         address[] calldata path,
412         address to,
413         uint256 deadline
414     ) external;
415 
416     function swapExactETHForTokensSupportingFeeOnTransferTokens(
417         uint256 amountOutMin,
418         address[] calldata path,
419         address to,
420         uint256 deadline
421     ) external payable;
422 
423     function swapExactTokensForETHSupportingFeeOnTransferTokens(
424         uint256 amountIn,
425         uint256 amountOutMin,
426         address[] calldata path,
427         address to,
428         uint256 deadline
429     ) external;
430 }
431 
432 contract CLAW is ERC20, Ownable {
433     using SafeMath for uint256;
434 
435     IUniswapV2Router02 public immutable uniswapV2Router;
436     address public immutable uniswapV2Pair;
437     address public constant deadAddress = address(0xdead);
438 
439     bool private swapping;
440 
441     address public marketingWallet;
442     address public devWallet;
443     address public lpWallet;
444 
445     uint256 public maxTransactionAmount;
446     uint256 public swapTokensAtAmount;
447     uint256 public maxWallet;
448 
449     bool public limitsInEffect = true;
450     bool public tradingActive = false;
451     bool public swapEnabled = false;
452 
453     uint256 public buyTotalFees;
454     uint256 public buyMarketingFee;
455     uint256 public buyLiquidityFee;
456     uint256 public buyDevFee;
457 
458     uint256 public sellTotalFees;
459     uint256 public sellMarketingFee;
460     uint256 public sellLiquidityFee;
461     uint256 public sellDevFee;
462 
463     uint256 public tokensForMarketing;
464     uint256 public tokensForLiquidity;
465     uint256 public tokensForDev;
466 
467     /******************/
468 
469     // exlcude from fees and max transaction amount
470     mapping(address => bool) private _isExcludedFromFees;
471     mapping(address => bool) public _isExcludedMaxTransactionAmount;
472 
473     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
474     // could be subject to a maximum transfer amount
475     mapping(address => bool) public automatedMarketMakerPairs;
476 
477     event UpdateUniswapV2Router(
478         address indexed newAddress,
479         address indexed oldAddress
480     );
481 
482     event LimitsRemoved();
483 
484     event ExcludeFromFees(address indexed account, bool isExcluded);
485 
486     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
487 
488     event marketingWalletUpdated(
489         address indexed newWallet,
490         address indexed oldWallet
491     );
492 
493     event devWalletUpdated(
494         address indexed newWallet,
495         address indexed oldWallet
496     );
497 
498     event lpWalletUpdated(
499         address indexed newWallet,
500         address indexed oldWallet
501     );
502 
503     event SwapAndLiquify(
504         uint256 tokensSwapped,
505         uint256 ethReceived,
506         uint256 tokensIntoLiquidity
507     );
508 
509     constructor() ERC20("Claw", "CLAW") {
510         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
511             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
512         );
513 
514         excludeFromMaxTransaction(address(_uniswapV2Router), true);
515         uniswapV2Router = _uniswapV2Router;
516 
517         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
518             .createPair(address(this), _uniswapV2Router.WETH());
519         excludeFromMaxTransaction(address(uniswapV2Pair), true);
520         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
521 
522         uint256 _buyMarketingFee = 24;
523         uint256 _buyLiquidityFee = 6;
524         uint256 _buyDevFee = 0;
525 
526         uint256 _sellMarketingFee = 40;
527         uint256 _sellLiquidityFee = 10;
528         uint256 _sellDevFee = 0;
529 
530         uint256 totalSupply = 100000000000 * 1e18;
531 
532         maxTransactionAmount = (totalSupply * 1) / 100;
533         maxWallet = (totalSupply * 1) / 100;
534         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
535 
536         buyMarketingFee = _buyMarketingFee;
537         buyLiquidityFee = _buyLiquidityFee;
538         buyDevFee = _buyDevFee;
539         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
540 
541         sellMarketingFee = _sellMarketingFee;
542         sellLiquidityFee = _sellLiquidityFee;
543         sellDevFee = _sellDevFee;
544         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
545 
546         marketingWallet = address(0xAfa0C142bc28bcC35A97559e632FcBe8569Ca327); 
547         devWallet = address(0xf70d91885E1CbC0F3E9546Ec78Bf702306Aed424);
548         lpWallet = msg.sender;
549 
550         // exclude from paying fees or having max transaction amount
551         excludeFromFees(owner(), true);
552         excludeFromFees(address(this), true);
553         excludeFromFees(address(0xdead), true);
554         excludeFromFees(marketingWallet, true);
555 
556         excludeFromMaxTransaction(owner(), true);
557         excludeFromMaxTransaction(address(this), true);
558         excludeFromMaxTransaction(address(0xdead), true);
559         excludeFromMaxTransaction(marketingWallet, true);
560 
561         /*
562             _mint is an internal function in ERC20.sol that is only called here,
563             and CANNOT be called ever again
564         */
565         _mint(msg.sender, totalSupply);
566     }
567 
568     receive() external payable {}
569 
570     // once enabled, can never be turned off
571     function enableTrading() external onlyOwner {
572         tradingActive = true;
573         swapEnabled = true;
574     }
575 
576     // remove limits after token is stable
577     function removeLimits() external onlyOwner returns (bool) {
578         limitsInEffect = false;
579         emit LimitsRemoved();
580         return true;
581     }
582 
583     // change the minimum amount of tokens to sell from fees
584     function updateSwapTokensAtAmount(uint256 newAmount)
585         external
586         onlyOwner
587         returns (bool)
588     {
589         require(
590             newAmount >= (totalSupply() * 1) / 100000,
591             "Swap amount cannot be lower than 0.001% total supply."
592         );
593         require(
594             newAmount <= (totalSupply() * 5) / 1000,
595             "Swap amount cannot be higher than 0.5% total supply."
596         );
597         swapTokensAtAmount = newAmount;
598         return true;
599     }
600 
601     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
602         require(
603             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
604             "Cannot set maxTransactionAmount lower than 0.1%"
605         );
606         maxTransactionAmount = newNum * (10**18);
607     }
608 
609     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
610         require(
611             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
612             "Cannot set maxWallet lower than 0.5%"
613         );
614         maxWallet = newNum * (10**18);
615     }
616 
617     function excludeFromMaxTransaction(address updAds, bool isEx)
618         public
619         onlyOwner
620     {
621         _isExcludedMaxTransactionAmount[updAds] = isEx;
622     }
623 
624     // only use to disable contract sales if absolutely necessary (emergency use only)
625     function updateSwapEnabled(bool enabled) external onlyOwner {
626         swapEnabled = enabled;
627     }
628 
629     function updateBuyFees(
630         uint256 _marketingFee,
631         uint256 _liquidityFee,
632         uint256 _devFee
633     ) external onlyOwner {
634         buyMarketingFee = _marketingFee;
635         buyLiquidityFee = _liquidityFee;
636         buyDevFee = _devFee;
637         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
638     }
639 
640     function updateSellFees(
641         uint256 _marketingFee,
642         uint256 _liquidityFee,
643         uint256 _devFee
644     ) external onlyOwner {
645         sellMarketingFee = _marketingFee;
646         sellLiquidityFee = _liquidityFee;
647         sellDevFee = _devFee;
648         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
649     }
650 
651     function excludeFromFees(address account, bool excluded) public onlyOwner {
652         _isExcludedFromFees[account] = excluded;
653         emit ExcludeFromFees(account, excluded);
654     }
655 
656     function setAutomatedMarketMakerPair(address pair, bool value)
657         public
658         onlyOwner
659     {
660         require(
661             pair != uniswapV2Pair,
662             "The pair cannot be removed from automatedMarketMakerPairs"
663         );
664 
665         _setAutomatedMarketMakerPair(pair, value);
666     }
667 
668     function _setAutomatedMarketMakerPair(address pair, bool value) private {
669         automatedMarketMakerPairs[pair] = value;
670 
671         emit SetAutomatedMarketMakerPair(pair, value);
672     }
673 
674     function updateMarketingWallet(address newMarketingWallet)
675         external
676         onlyOwner
677     {
678         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
679         marketingWallet = newMarketingWallet;
680     }
681 
682     function updateLPWallet(address newLPWallet)
683         external
684         onlyOwner
685     {
686         emit lpWalletUpdated(newLPWallet, lpWallet);
687         lpWallet = newLPWallet;
688     }
689 
690     function updateDevWallet(address newWallet) external onlyOwner {
691         emit devWalletUpdated(newWallet, devWallet);
692         devWallet = newWallet;
693     }
694 
695     function isExcludedFromFees(address account) public view returns (bool) {
696         return _isExcludedFromFees[account];
697     }
698 
699     event BoughtEarly(address indexed sniper);
700 
701     function _transfer(
702         address from,
703         address to,
704         uint256 amount
705     ) internal override {
706         require(from != address(0), "ERC20: transfer from the zero address");
707         require(to != address(0), "ERC20: transfer to the zero address");
708 
709         if (amount == 0) {
710             super._transfer(from, to, 0);
711             return;
712         }
713 
714         if (limitsInEffect) {
715             if (
716                 from != owner() &&
717                 to != owner() &&
718                 to != address(0) &&
719                 to != address(0xdead) &&
720                 !swapping
721             ) {
722                 if (!tradingActive) {
723                     require(
724                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
725                         "Trading is not active."
726                     );
727                 }
728 
729                 //when buy
730                 if (
731                     automatedMarketMakerPairs[from] &&
732                     !_isExcludedMaxTransactionAmount[to]
733                 ) {
734                     require(
735                         amount <= maxTransactionAmount,
736                         "Buy transfer amount exceeds the maxTransactionAmount."
737                     );
738                     require(
739                         amount + balanceOf(to) <= maxWallet,
740                         "Max wallet exceeded"
741                     );
742                 }
743                 //when sell
744                 else if (
745                     automatedMarketMakerPairs[to] &&
746                     !_isExcludedMaxTransactionAmount[from]
747                 ) {
748                     require(
749                         amount <= maxTransactionAmount,
750                         "Sell transfer amount exceeds the maxTransactionAmount."
751                     );
752                 } else if (!_isExcludedMaxTransactionAmount[to]) {
753                     require(
754                         amount + balanceOf(to) <= maxWallet,
755                         "Max wallet exceeded"
756                     );
757                 }
758             }
759         }
760 
761         uint256 contractTokenBalance = balanceOf(address(this));
762 
763         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
764 
765         if (
766             canSwap &&
767             swapEnabled &&
768             !swapping &&
769             !automatedMarketMakerPairs[from] &&
770             !_isExcludedFromFees[from] &&
771             !_isExcludedFromFees[to]
772         ) {
773             swapping = true;
774 
775             swapBack();
776 
777             swapping = false;
778         }
779 
780         bool takeFee = !swapping;
781 
782         // if any account belongs to _isExcludedFromFee account then remove the fee
783         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
784             takeFee = false;
785         }
786 
787         uint256 fees = 0;
788         // only take fees on buys/sells, do not take on wallet transfers
789         if (takeFee) {
790             // on sell
791             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
792                 fees = amount.mul(sellTotalFees).div(100);
793                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
794                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
795                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
796             }
797             // on buy
798             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
799                 fees = amount.mul(buyTotalFees).div(100);
800                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
801                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
802                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
803             }
804 
805             if (fees > 0) {
806                 super._transfer(from, address(this), fees);
807             }
808 
809             amount -= fees;
810         }
811 
812         super._transfer(from, to, amount);
813     }
814 
815     function swapTokensForEth(uint256 tokenAmount) private {
816         // generate the uniswap pair path of token -> weth
817         address[] memory path = new address[](2);
818         path[0] = address(this);
819         path[1] = uniswapV2Router.WETH();
820 
821         _approve(address(this), address(uniswapV2Router), tokenAmount);
822 
823         // make the swap
824         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
825             tokenAmount,
826             0, // accept any amount of ETH
827             path,
828             address(this),
829             block.timestamp
830         );
831     }
832 
833     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
834         // approve token transfer to cover all possible scenarios
835         _approve(address(this), address(uniswapV2Router), tokenAmount);
836 
837         // add the liquidity
838         uniswapV2Router.addLiquidityETH{value: ethAmount}(
839             address(this),
840             tokenAmount,
841             0, // slippage is unavoidable
842             0, // slippage is unavoidable
843             lpWallet,
844             block.timestamp
845         );
846     }
847 
848     function swapBack() private {
849         uint256 contractBalance = balanceOf(address(this));
850         uint256 totalTokensToSwap = tokensForLiquidity +
851             tokensForMarketing +
852             tokensForDev;
853         bool success;
854 
855         if (contractBalance == 0 || totalTokensToSwap == 0) {
856             return;
857         }
858 
859         // Halve the amount of liquidity tokens
860         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
861             totalTokensToSwap /
862             2;
863         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
864 
865         uint256 initialETHBalance = address(this).balance;
866 
867         swapTokensForEth(amountToSwapForETH);
868 
869         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
870 
871         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
872             totalTokensToSwap
873         );
874         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
875 
876         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
877 
878         tokensForLiquidity = 0;
879         tokensForMarketing = 0;
880         tokensForDev = 0;
881 
882         (success, ) = address(devWallet).call{value: ethForDev}("");
883 
884         if (liquidityTokens > 0 && ethForLiquidity > 0) {
885             addLiquidity(liquidityTokens, ethForLiquidity);
886             emit SwapAndLiquify(
887                 amountToSwapForETH,
888                 ethForLiquidity,
889                 tokensForLiquidity
890             );
891         }
892 
893         (success, ) = address(marketingWallet).call{
894             value: address(this).balance
895         }("");
896     }
897 }