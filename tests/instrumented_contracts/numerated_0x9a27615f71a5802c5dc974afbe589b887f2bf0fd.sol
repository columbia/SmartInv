1 /*
2 
3 Telegram: https://t.me/pixelai_eth
4 
5 Website: https://pixel-ai.tech
6 
7 Medium: https://medium.com/@pixelaieth/pixel-ai-pixxy-845fb44d4684
8 */
9 // SPDX-License-Identifier: MIT
10 pragma solidity =0.8.16;
11 pragma experimental ABIEncoderV2;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         return msg.data;
20     }
21 }
22 
23 abstract contract Ownable is Context {
24     address private _owner;
25 
26     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28     constructor() {
29         _transferOwnership(_msgSender());
30     }
31 
32     function owner() public view virtual returns (address) {
33         return _owner;
34     }
35 
36     modifier onlyOwner() {
37         require(owner() == _msgSender(), "Ownable: caller is not the owner");
38         _;
39     }
40 
41     function renounceOwnership() public virtual onlyOwner { //Change
42         _transferOwnership(address(0));
43     }
44 
45     function transferOwnership(address newOwner) public virtual onlyOwner {
46         require(newOwner != address(0), "Ownable: new owner is the zero address");
47         _transferOwnership(newOwner);
48     }
49 
50     function _transferOwnership(address newOwner) internal virtual {
51         address oldOwner = _owner;
52         _owner = newOwner;
53         emit OwnershipTransferred(oldOwner, newOwner);
54     }
55 }
56 
57 interface IERC20 {
58 
59     function totalSupply() external view returns (uint256);
60     function balanceOf(address account) external view returns (uint256);
61     function transfer(address recipient, uint256 amount) external returns (bool);
62     function allowance(address owner, address spender) external view returns (uint256);
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65     function transferFrom(
66         address sender,
67         address recipient,
68         uint256 amount
69     ) external returns (bool);
70 
71     event Transfer(address indexed from, address indexed to, uint256 value);
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 interface IERC20Metadata is IERC20 {
76 
77     function name() external view returns (string memory);
78     function symbol() external view returns (string memory);
79     function decimals() external view returns (uint8);
80 }
81 
82 
83 contract ERC20 is Context, IERC20, IERC20Metadata {
84     mapping(address => uint256) private _balances;
85 
86     mapping(address => mapping(address => uint256)) private _allowances;
87 
88     uint256 private _totalSupply;
89 
90     string private _name;
91     string private _symbol;
92 
93     constructor(string memory name_, string memory symbol_) {
94         _name = name_;
95         _symbol = symbol_;
96     }
97 
98     function name() public view virtual override returns (string memory) {
99         return _name;
100     }
101 
102     function symbol() public view virtual override returns (string memory) {
103         return _symbol;
104     }
105 
106     function decimals() public view virtual override returns (uint8) {
107         return 18;
108     }
109 
110     function totalSupply() public view virtual override returns (uint256) {
111         return _totalSupply;
112     }
113 
114     function balanceOf(address account) public view virtual override returns (uint256) {
115         return _balances[account];
116     }
117 
118     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
119         _transfer(_msgSender(), recipient, amount);
120         return true;
121     }
122 
123     function allowance(address owner, address spender) public view virtual override returns (uint256) {
124         return _allowances[owner][spender];
125     }
126 
127     function approve(address spender, uint256 amount) public virtual override returns (bool) {
128         _approve(_msgSender(), spender, amount);
129         return true;
130     }
131 
132     function transferFrom(
133         address sender,
134         address recipient,
135         uint256 amount
136     ) public virtual override returns (bool) {
137         _transfer(sender, recipient, amount);
138 
139         uint256 currentAllowance = _allowances[sender][_msgSender()];
140         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
141         unchecked {
142             _approve(sender, _msgSender(), currentAllowance - amount);
143         }
144 
145         return true;
146     }
147 
148     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
149         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
150         return true;
151     }
152 
153     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
154         uint256 currentAllowance = _allowances[_msgSender()][spender];
155         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
156         unchecked {
157             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
158         }
159 
160         return true;
161     }
162 
163     function _transfer(
164         address sender,
165         address recipient,
166         uint256 amount
167     ) internal virtual {
168         require(sender != address(0), "ERC20: transfer from the zero address");
169         require(recipient != address(0), "ERC20: transfer to the zero address");
170 
171         _beforeTokenTransfer(sender, recipient, amount);
172 
173         uint256 senderBalance = _balances[sender];
174         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
175         unchecked {
176             _balances[sender] = senderBalance - amount;
177         }
178         _balances[recipient] += amount;
179 
180         emit Transfer(sender, recipient, amount);
181 
182         _afterTokenTransfer(sender, recipient, amount);
183     }
184 
185     function _mint(address account, uint256 amount) internal virtual {
186         require(account != address(0), "ERC20: mint to the zero address");
187 
188         _beforeTokenTransfer(address(0), account, amount);
189 
190         _totalSupply += amount;
191         _balances[account] += amount;
192         emit Transfer(address(0), account, amount);
193 
194         _afterTokenTransfer(address(0), account, amount);
195     }
196 
197     function _approve(
198         address owner,
199         address spender,
200         uint256 amount
201     ) internal virtual {
202         require(owner != address(0), "ERC20: approve from the zero address");
203         require(spender != address(0), "ERC20: approve to the zero address");
204 
205         _allowances[owner][spender] = amount;
206         emit Approval(owner, spender, amount);
207     }
208 
209     function _beforeTokenTransfer(
210         address from,
211         address to,
212         uint256 amount
213     ) internal virtual {}
214 
215     function _afterTokenTransfer(
216         address from,
217         address to,
218         uint256 amount
219     ) internal virtual {}
220 }
221 
222 library SafeMath {
223 
224     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
225         unchecked {
226             uint256 c = a + b;
227             if (c < a) return (false, 0);
228             return (true, c);
229         }
230     }
231 
232     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
233         unchecked {
234             if (b > a) return (false, 0);
235             return (true, a - b);
236         }
237     }
238 
239     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
240         unchecked {
241             if (a == 0) return (true, 0);
242             uint256 c = a * b;
243             if (c / a != b) return (false, 0);
244             return (true, c);
245         }
246     }
247 
248     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
249         unchecked {
250             if (b == 0) return (false, 0);
251             return (true, a / b);
252         }
253     }
254 
255     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
256         unchecked {
257             if (b == 0) return (false, 0);
258             return (true, a % b);
259         }
260     }
261 
262     function add(uint256 a, uint256 b) internal pure returns (uint256) {
263         return a + b;
264     }
265 
266     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
267         return a - b;
268     }
269 
270     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
271         return a * b;
272     }
273 
274     function div(uint256 a, uint256 b) internal pure returns (uint256) {
275         return a / b;
276     }
277 
278     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
279         return a % b;
280     }
281 
282     function sub(
283         uint256 a,
284         uint256 b,
285         string memory errorMessage
286     ) internal pure returns (uint256) {
287         unchecked {
288             require(b <= a, errorMessage);
289             return a - b;
290         }
291     }
292 
293     function div(
294         uint256 a,
295         uint256 b,
296         string memory errorMessage
297     ) internal pure returns (uint256) {
298         unchecked {
299             require(b > 0, errorMessage);
300             return a / b;
301         }
302     }
303 
304     function mod(
305         uint256 a,
306         uint256 b,
307         string memory errorMessage
308     ) internal pure returns (uint256) {
309         unchecked {
310             require(b > 0, errorMessage);
311             return a % b;
312         }
313     }
314 }
315 
316 interface IUniswapV2Factory {
317     event PairCreated(
318         address indexed token0,
319         address indexed token1,
320         address pair,
321         uint256
322     );
323 
324     function feeTo() external view returns (address);
325 
326     function feeToSetter() external view returns (address);
327 
328     function getPair(address tokenA, address tokenB)
329         external
330         view
331         returns (address pair);
332 
333     function allPairs(uint256) external view returns (address pair);
334 
335     function allPairsLength() external view returns (uint256);
336 
337     function createPair(address tokenA, address tokenB)
338         external
339         returns (address pair);
340 
341     function setFeeTo(address) external;
342 
343     function setFeeToSetter(address) external;
344 }
345 
346 interface IUniswapV2Pair {
347     event Approval(
348         address indexed owner,
349         address indexed spender,
350         uint256 value
351     );
352     event Transfer(address indexed from, address indexed to, uint256 value);
353 
354     function name() external pure returns (string memory);
355 
356     function symbol() external pure returns (string memory);
357 
358     function decimals() external pure returns (uint8);
359 
360     function totalSupply() external view returns (uint256);
361 
362     function balanceOf(address owner) external view returns (uint256);
363 
364     function allowance(address owner, address spender)
365         external
366         view
367         returns (uint256);
368 
369     function approve(address spender, uint256 value) external returns (bool);
370 
371     function transfer(address to, uint256 value) external returns (bool);
372 
373     function transferFrom(
374         address from,
375         address to,
376         uint256 value
377     ) external returns (bool);
378 
379     function DOMAIN_SEPARATOR() external view returns (bytes32);
380 
381     function PERMIT_TYPEHASH() external pure returns (bytes32);
382 
383     function nonces(address owner) external view returns (uint256);
384 
385     function permit(
386         address owner,
387         address spender,
388         uint256 value,
389         uint256 deadline,
390         uint8 v,
391         bytes32 r,
392         bytes32 s
393     ) external;
394 
395     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
396 
397     event Swap(
398         address indexed sender,
399         uint256 amount0In,
400         uint256 amount1In,
401         uint256 amount0Out,
402         uint256 amount1Out,
403         address indexed to
404     );
405     event Sync(uint112 reserve0, uint112 reserve1);
406 
407     function MINIMUM_LIQUIDITY() external pure returns (uint256);
408 
409     function factory() external view returns (address);
410 
411     function token0() external view returns (address);
412 
413     function token1() external view returns (address);
414 
415     function getReserves()
416         external
417         view
418         returns (
419             uint112 reserve0,
420             uint112 reserve1,
421             uint32 blockTimestampLast
422         );
423 
424     function price0CumulativeLast() external view returns (uint256);
425 
426     function price1CumulativeLast() external view returns (uint256);
427 
428     function kLast() external view returns (uint256);
429 
430     function mint(address to) external returns (uint256 liquidity);
431 
432     function swap(
433         uint256 amount0Out,
434         uint256 amount1Out,
435         address to,
436         bytes calldata data
437     ) external;
438 
439     function skim(address to) external;
440 
441     function sync() external;
442 
443     function initialize(address, address) external;
444 }
445 
446 interface IUniswapV2Router02 {
447     function factory() external pure returns (address);
448 
449     function WETH() external pure returns (address);
450 
451     function addLiquidity(
452         address tokenA,
453         address tokenB,
454         uint256 amountADesired,
455         uint256 amountBDesired,
456         uint256 amountAMin,
457         uint256 amountBMin,
458         address to,
459         uint256 deadline
460     )
461         external
462         returns (
463             uint256 amountA,
464             uint256 amountB,
465             uint256 liquidity
466         );
467 
468     function addLiquidityETH(
469         address token,
470         uint256 amountTokenDesired,
471         uint256 amountTokenMin,
472         uint256 amountETHMin,
473         address to,
474         uint256 deadline
475     )
476         external
477         payable
478         returns (
479             uint256 amountToken,
480             uint256 amountETH,
481             uint256 liquidity
482         );
483 
484     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
485         uint256 amountIn,
486         uint256 amountOutMin,
487         address[] calldata path,
488         address to,
489         uint256 deadline
490     ) external;
491 
492     function swapExactETHForTokensSupportingFeeOnTransferTokens(
493         uint256 amountOutMin,
494         address[] calldata path,
495         address to,
496         uint256 deadline
497     ) external payable;
498 
499     function swapExactTokensForETHSupportingFeeOnTransferTokens(
500         uint256 amountIn,
501         uint256 amountOutMin,
502         address[] calldata path,
503         address to,
504         uint256 deadline
505     ) external;
506 }
507 
508 contract PIXELAI is ERC20, Ownable {
509     using SafeMath for uint256;
510 
511     IUniswapV2Router02 public immutable uniswapV2Router;
512     address public immutable uniswapV2Pair;
513     address public constant deadAddress = address(0xdead);
514 
515     bool private swapping;
516 
517     address public marketingWallet;
518 
519     uint256 public maxTransactionAmount;
520     uint256 public swapTokensAtAmount;
521     uint256 public maxWallet;
522 
523     bool public tradingActive = false;
524     bool public swapEnabled = false;
525 
526     uint256 public buyTotalFees;
527     uint256 private buyMarketingFee;
528     uint256 private buyLiquidityFee;
529 
530     uint256 public sellTotalFees;
531     uint256 private sellMarketingFee;
532     uint256 private sellLiquidityFee;
533 
534     uint256 private tokensForMarketing;
535     uint256 private tokensForLiquidity;
536     uint256 private previousFee;
537 
538     mapping(address => bool) private _isExcludedFromFees;
539     mapping(address => bool) private _isExcludedMaxTransactionAmount;
540     mapping(address => bool) private automatedMarketMakerPairs;
541 
542     event UpdateUniswapV2Router(
543         address indexed newAddress,
544         address indexed oldAddress
545     );
546 
547     event ExcludeFromFees(address indexed account, bool isExcluded);
548 
549     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
550 
551     event marketingWalletUpdated(
552         address indexed newWallet,
553         address indexed oldWallet
554     );
555 
556     event SwapAndLiquify(
557         uint256 tokensSwapped,
558         uint256 ethReceived,
559         uint256 tokensIntoLiquidity
560     );
561 
562     constructor() ERC20("Pixel AI", "PIXEL AI") {
563         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
564             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
565         );
566 
567         excludeFromMaxTransaction(address(_uniswapV2Router), true);
568         uniswapV2Router = _uniswapV2Router;
569 
570         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
571             .createPair(address(this), _uniswapV2Router.WETH());
572         excludeFromMaxTransaction(address(uniswapV2Pair), true);
573         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
574 
575         uint256 _buyMarketingFee = 10;
576         uint256 _buyLiquidityFee = 0;
577 
578         uint256 _sellMarketingFee = 15;
579         uint256 _sellLiquidityFee = 0;
580 
581         uint256 totalSupply = 1000000000 * 1e18;
582 
583         maxTransactionAmount = 20000000 * 1e18;
584         maxWallet = 20000000 * 1e18;
585         swapTokensAtAmount = (totalSupply * 20) / 10000;
586 
587         buyMarketingFee = _buyMarketingFee;
588         buyLiquidityFee = _buyLiquidityFee;
589         buyTotalFees = buyMarketingFee + buyLiquidityFee;
590 
591         sellMarketingFee = _sellMarketingFee;
592         sellLiquidityFee = _sellLiquidityFee;
593         sellTotalFees = sellMarketingFee + sellLiquidityFee;
594         previousFee = sellTotalFees;
595 
596         marketingWallet = address(0xD0e4c7e4C969583030035b46B47417Eea4703536);
597 
598         excludeFromFees(owner(), true);
599         excludeFromFees(address(this), true);
600         excludeFromFees(address(0xdead), true);
601 
602         excludeFromMaxTransaction(owner(), true);
603         excludeFromMaxTransaction(address(this), true);
604         excludeFromMaxTransaction(address(0xdead), true);
605 
606         _mint(msg.sender, totalSupply);
607     }
608 
609     receive() external payable {}
610 
611     function enableTrading() external onlyOwner {
612         tradingActive = true;
613         swapEnabled = true;
614     }
615 
616     function updateSwapTokensAtAmount(uint256 newAmount)
617         external
618         onlyOwner
619         returns (bool)
620     {
621         require(
622             newAmount >= (totalSupply() * 1) / 100000,
623             "Swap amount cannot be lower than 0.001% total supply."
624         );
625         require(
626             newAmount <= (totalSupply() * 5) / 1000,
627             "Swap amount cannot be higher than 0.5% total supply."
628         );
629         swapTokensAtAmount = newAmount;
630         return true;
631     }
632 
633     function updateMaxWalletAndTxnAmount(uint256 newTxnNum, uint256 newMaxWalletNum) external onlyOwner {
634         require(
635             newTxnNum >= ((totalSupply() * 5) / 1000) / 1e18,
636             "Cannot set maxTxn lower than 0.5%"
637         );
638         require(
639             newMaxWalletNum >= ((totalSupply() * 5) / 1000) / 1e18,
640             "Cannot set maxWallet lower than 0.5%"
641         );
642         maxWallet = newMaxWalletNum * (10**18);
643         maxTransactionAmount = newTxnNum * (10**18);
644     }
645 
646     function excludeFromMaxTransaction(address updAds, bool isEx)
647         public
648         onlyOwner
649     {
650         _isExcludedMaxTransactionAmount[updAds] = isEx;
651     }
652 
653     function updateBuyFees(
654         uint256 _marketingFee,
655         uint256 _liquidityFee
656     ) external onlyOwner {
657         buyMarketingFee = _marketingFee;
658         buyLiquidityFee = _liquidityFee;
659         buyTotalFees = buyMarketingFee + buyLiquidityFee;
660         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
661     }
662 
663     function updateSellFees(
664         uint256 _marketingFee,
665         uint256 _liquidityFee
666     ) external onlyOwner {
667         sellMarketingFee = _marketingFee;
668         sellLiquidityFee = _liquidityFee;
669         sellTotalFees = sellMarketingFee + sellLiquidityFee;
670         previousFee = sellTotalFees;
671         require(sellTotalFees <= 99, "Must keep fees at 99% or less");
672     }
673 
674     function excludeFromFees(address account, bool excluded) public onlyOwner {
675         _isExcludedFromFees[account] = excluded;
676         emit ExcludeFromFees(account, excluded);
677     }
678 
679     function setAutomatedMarketMakerPair(address pair, bool value)
680         public
681         onlyOwner
682     {
683         require(
684             pair != uniswapV2Pair,
685             "The pair cannot be removed from automatedMarketMakerPairs"
686         );
687 
688         _setAutomatedMarketMakerPair(pair, value);
689     }
690 
691     function _setAutomatedMarketMakerPair(address pair, bool value) private {
692         automatedMarketMakerPairs[pair] = value;
693 
694         emit SetAutomatedMarketMakerPair(pair, value);
695     }
696 
697     function isExcludedFromFees(address account) public view returns (bool) {
698         return _isExcludedFromFees[account];
699     }
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
714                 if (
715                 from != owner() &&
716                 to != owner() &&
717                 to != address(0) &&
718                 to != address(0xdead) &&
719                 !swapping
720             ) {
721                 if (!tradingActive) {
722                     require(
723                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
724                         "Trading is not active."
725                     );
726                 }
727 
728                 //when buy
729                 if (
730                     automatedMarketMakerPairs[from] &&
731                     !_isExcludedMaxTransactionAmount[to]
732                 ) {
733                     require(
734                         amount <= maxTransactionAmount,
735                         "Buy transfer amount exceeds the maxTransactionAmount."
736                     );
737                     require(
738                         amount + balanceOf(to) <= maxWallet,
739                         "Max wallet exceeded"
740                     );
741                 }
742                 //when sell
743                 else if (
744                     automatedMarketMakerPairs[to] &&
745                     !_isExcludedMaxTransactionAmount[from]
746                 ) {
747                     require(
748                         amount <= maxTransactionAmount,
749                         "Sell transfer amount exceeds the maxTransactionAmount."
750                     );
751                 } 
752                 
753                 else if (!_isExcludedMaxTransactionAmount[to]) {
754                     require(
755                         amount + balanceOf(to) <= maxWallet,
756                         "Max wallet exceeded"
757                     );
758                 }
759             }
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
782         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
783             takeFee = false;
784         }
785 
786         uint256 fees = 0;
787 
788         if (takeFee) {
789             // on sell
790             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
791                 fees = amount.mul(sellTotalFees).div(100);
792                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
793                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
794             }
795             // on buy
796             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
797                 fees = amount.mul(buyTotalFees).div(100);
798                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
799                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
800             }
801 
802             if (fees > 0) {
803                 super._transfer(from, address(this), fees);
804             }
805 
806             amount -= fees;
807         }
808 
809         super._transfer(from, to, amount);
810         sellTotalFees = previousFee;
811 
812     }
813 
814     function swapTokensForEth(uint256 tokenAmount) private {
815 
816         address[] memory path = new address[](2);
817         path[0] = address(this);
818         path[1] = uniswapV2Router.WETH();
819 
820         _approve(address(this), address(uniswapV2Router), tokenAmount);
821 
822         // make the swap
823         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
824             tokenAmount,
825             0,
826             path,
827             address(this),
828             block.timestamp
829         );
830     }
831 
832     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
833 
834         _approve(address(this), address(uniswapV2Router), tokenAmount);
835 
836         uniswapV2Router.addLiquidityETH{value: ethAmount}(
837             address(this),
838             tokenAmount,
839             0,
840             0,
841             deadAddress,
842             block.timestamp
843         );
844     }
845 
846     function swapBack() private {
847         uint256 contractBalance = balanceOf(address(this));
848         uint256 totalTokensToSwap = tokensForLiquidity +
849             tokensForMarketing;
850         bool success;
851 
852         if (contractBalance == 0 || totalTokensToSwap == 0) {
853             return;
854         }
855 
856         if (contractBalance > swapTokensAtAmount * 20) {
857             contractBalance = swapTokensAtAmount * 20;
858         }
859 
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
874 
875         uint256 ethForLiquidity = ethBalance - ethForMarketing;
876 
877         tokensForLiquidity = 0;
878         tokensForMarketing = 0;
879 
880         if (liquidityTokens > 0 && ethForLiquidity > 0) {
881             addLiquidity(liquidityTokens, ethForLiquidity);
882             emit SwapAndLiquify(
883                 amountToSwapForETH,
884                 ethForLiquidity,
885                 tokensForLiquidity
886             );
887         }
888 
889         (success, ) = address(marketingWallet).call{value: address(this).balance}("");
890     }
891 }