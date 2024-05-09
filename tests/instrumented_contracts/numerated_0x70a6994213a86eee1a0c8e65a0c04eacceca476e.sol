1 /*
2 
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity =0.8.16;
7 pragma experimental ABIEncoderV2;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes calldata) {
15         return msg.data;
16     }
17 }
18 
19 abstract contract Ownable is Context {
20     address private _owner;
21 
22     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23 
24     constructor() {
25         _transferOwnership(_msgSender());
26     }
27 
28     function owner() public view virtual returns (address) {
29         return _owner;
30     }
31 
32     modifier onlyOwner() {
33         require(owner() == _msgSender(), "Ownable: caller is not the owner");
34         _;
35     }
36 
37     function renounceOwnership() public virtual onlyOwner { //Change
38         _transferOwnership(address(0));
39     }
40 
41     function transferOwnership(address newOwner) public virtual onlyOwner {
42         require(newOwner != address(0), "Ownable: new owner is the zero address");
43         _transferOwnership(newOwner);
44     }
45 
46     function _transferOwnership(address newOwner) internal virtual {
47         address oldOwner = _owner;
48         _owner = newOwner;
49         emit OwnershipTransferred(oldOwner, newOwner);
50     }
51 }
52 
53 interface IERC20 {
54 
55     function totalSupply() external view returns (uint256);
56     function balanceOf(address account) external view returns (uint256);
57     function transfer(address recipient, uint256 amount) external returns (bool);
58     function allowance(address owner, address spender) external view returns (uint256);
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     function transferFrom(
62         address sender,
63         address recipient,
64         uint256 amount
65     ) external returns (bool);
66 
67     event Transfer(address indexed from, address indexed to, uint256 value);
68     event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 interface IERC20Metadata is IERC20 {
72 
73     function name() external view returns (string memory);
74     function symbol() external view returns (string memory);
75     function decimals() external view returns (uint8);
76 }
77 
78 
79 contract ERC20 is Context, IERC20, IERC20Metadata {
80     mapping(address => uint256) private _balances;
81 
82     mapping(address => mapping(address => uint256)) private _allowances;
83 
84     uint256 private _totalSupply;
85 
86     string private _name;
87     string private _symbol;
88 
89     constructor(string memory name_, string memory symbol_) {
90         _name = name_;
91         _symbol = symbol_;
92     }
93 
94     function name() public view virtual override returns (string memory) {
95         return _name;
96     }
97 
98     function symbol() public view virtual override returns (string memory) {
99         return _symbol;
100     }
101 
102     function decimals() public view virtual override returns (uint8) {
103         return 18;
104     }
105 
106     function totalSupply() public view virtual override returns (uint256) {
107         return _totalSupply;
108     }
109 
110     function balanceOf(address account) public view virtual override returns (uint256) {
111         return _balances[account];
112     }
113 
114     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
115         _transfer(_msgSender(), recipient, amount);
116         return true;
117     }
118 
119     function allowance(address owner, address spender) public view virtual override returns (uint256) {
120         return _allowances[owner][spender];
121     }
122 
123     function approve(address spender, uint256 amount) public virtual override returns (bool) {
124         _approve(_msgSender(), spender, amount);
125         return true;
126     }
127 
128     function transferFrom(
129         address sender,
130         address recipient,
131         uint256 amount
132     ) public virtual override returns (bool) {
133         _transfer(sender, recipient, amount);
134 
135         uint256 currentAllowance = _allowances[sender][_msgSender()];
136         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
137         unchecked {
138             _approve(sender, _msgSender(), currentAllowance - amount);
139         }
140 
141         return true;
142     }
143 
144     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
145         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
146         return true;
147     }
148 
149     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
150         uint256 currentAllowance = _allowances[_msgSender()][spender];
151         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
152         unchecked {
153             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
154         }
155 
156         return true;
157     }
158 
159     function _transfer(
160         address sender,
161         address recipient,
162         uint256 amount
163     ) internal virtual {
164         require(sender != address(0), "ERC20: transfer from the zero address");
165         require(recipient != address(0), "ERC20: transfer to the zero address");
166 
167         _beforeTokenTransfer(sender, recipient, amount);
168 
169         uint256 senderBalance = _balances[sender];
170         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
171         unchecked {
172             _balances[sender] = senderBalance - amount;
173         }
174         _balances[recipient] += amount;
175 
176         emit Transfer(sender, recipient, amount);
177 
178         _afterTokenTransfer(sender, recipient, amount);
179     }
180 
181     function _mint(address account, uint256 amount) internal virtual {
182         require(account != address(0), "ERC20: mint to the zero address");
183 
184         _beforeTokenTransfer(address(0), account, amount);
185 
186         _totalSupply += amount;
187         _balances[account] += amount;
188         emit Transfer(address(0), account, amount);
189 
190         _afterTokenTransfer(address(0), account, amount);
191     }
192 
193     function _approve(
194         address owner,
195         address spender,
196         uint256 amount
197     ) internal virtual {
198         require(owner != address(0), "ERC20: approve from the zero address");
199         require(spender != address(0), "ERC20: approve to the zero address");
200 
201         _allowances[owner][spender] = amount;
202         emit Approval(owner, spender, amount);
203     }
204 
205     function _beforeTokenTransfer(
206         address from,
207         address to,
208         uint256 amount
209     ) internal virtual {}
210 
211     function _afterTokenTransfer(
212         address from,
213         address to,
214         uint256 amount
215     ) internal virtual {}
216 }
217 
218 library SafeMath {
219 
220     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
221         unchecked {
222             uint256 c = a + b;
223             if (c < a) return (false, 0);
224             return (true, c);
225         }
226     }
227 
228     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
229         unchecked {
230             if (b > a) return (false, 0);
231             return (true, a - b);
232         }
233     }
234 
235     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
236         unchecked {
237             if (a == 0) return (true, 0);
238             uint256 c = a * b;
239             if (c / a != b) return (false, 0);
240             return (true, c);
241         }
242     }
243 
244     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
245         unchecked {
246             if (b == 0) return (false, 0);
247             return (true, a / b);
248         }
249     }
250 
251     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
252         unchecked {
253             if (b == 0) return (false, 0);
254             return (true, a % b);
255         }
256     }
257 
258     function add(uint256 a, uint256 b) internal pure returns (uint256) {
259         return a + b;
260     }
261 
262     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
263         return a - b;
264     }
265 
266     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
267         return a * b;
268     }
269 
270     function div(uint256 a, uint256 b) internal pure returns (uint256) {
271         return a / b;
272     }
273 
274     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
275         return a % b;
276     }
277 
278     function sub(
279         uint256 a,
280         uint256 b,
281         string memory errorMessage
282     ) internal pure returns (uint256) {
283         unchecked {
284             require(b <= a, errorMessage);
285             return a - b;
286         }
287     }
288 
289     function div(
290         uint256 a,
291         uint256 b,
292         string memory errorMessage
293     ) internal pure returns (uint256) {
294         unchecked {
295             require(b > 0, errorMessage);
296             return a / b;
297         }
298     }
299 
300     function mod(
301         uint256 a,
302         uint256 b,
303         string memory errorMessage
304     ) internal pure returns (uint256) {
305         unchecked {
306             require(b > 0, errorMessage);
307             return a % b;
308         }
309     }
310 }
311 
312 interface IUniswapV2Factory {
313     event PairCreated(
314         address indexed token0,
315         address indexed token1,
316         address pair,
317         uint256
318     );
319 
320     function feeTo() external view returns (address);
321 
322     function feeToSetter() external view returns (address);
323 
324     function getPair(address tokenA, address tokenB)
325         external
326         view
327         returns (address pair);
328 
329     function allPairs(uint256) external view returns (address pair);
330 
331     function allPairsLength() external view returns (uint256);
332 
333     function createPair(address tokenA, address tokenB)
334         external
335         returns (address pair);
336 
337     function setFeeTo(address) external;
338 
339     function setFeeToSetter(address) external;
340 }
341 
342 interface IUniswapV2Pair {
343     event Approval(
344         address indexed owner,
345         address indexed spender,
346         uint256 value
347     );
348     event Transfer(address indexed from, address indexed to, uint256 value);
349 
350     function name() external pure returns (string memory);
351 
352     function symbol() external pure returns (string memory);
353 
354     function decimals() external pure returns (uint8);
355 
356     function totalSupply() external view returns (uint256);
357 
358     function balanceOf(address owner) external view returns (uint256);
359 
360     function allowance(address owner, address spender)
361         external
362         view
363         returns (uint256);
364 
365     function approve(address spender, uint256 value) external returns (bool);
366 
367     function transfer(address to, uint256 value) external returns (bool);
368 
369     function transferFrom(
370         address from,
371         address to,
372         uint256 value
373     ) external returns (bool);
374 
375     function DOMAIN_SEPARATOR() external view returns (bytes32);
376 
377     function PERMIT_TYPEHASH() external pure returns (bytes32);
378 
379     function nonces(address owner) external view returns (uint256);
380 
381     function permit(
382         address owner,
383         address spender,
384         uint256 value,
385         uint256 deadline,
386         uint8 v,
387         bytes32 r,
388         bytes32 s
389     ) external;
390 
391     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
392 
393     event Swap(
394         address indexed sender,
395         uint256 amount0In,
396         uint256 amount1In,
397         uint256 amount0Out,
398         uint256 amount1Out,
399         address indexed to
400     );
401     event Sync(uint112 reserve0, uint112 reserve1);
402 
403     function MINIMUM_LIQUIDITY() external pure returns (uint256);
404 
405     function factory() external view returns (address);
406 
407     function token0() external view returns (address);
408 
409     function token1() external view returns (address);
410 
411     function getReserves()
412         external
413         view
414         returns (
415             uint112 reserve0,
416             uint112 reserve1,
417             uint32 blockTimestampLast
418         );
419 
420     function price0CumulativeLast() external view returns (uint256);
421 
422     function price1CumulativeLast() external view returns (uint256);
423 
424     function kLast() external view returns (uint256);
425 
426     function mint(address to) external returns (uint256 liquidity);
427 
428     function swap(
429         uint256 amount0Out,
430         uint256 amount1Out,
431         address to,
432         bytes calldata data
433     ) external;
434 
435     function skim(address to) external;
436 
437     function sync() external;
438 
439     function initialize(address, address) external;
440 }
441 
442 interface IUniswapV2Router02 {
443     function factory() external pure returns (address);
444 
445     function WETH() external pure returns (address);
446 
447     function addLiquidity(
448         address tokenA,
449         address tokenB,
450         uint256 amountADesired,
451         uint256 amountBDesired,
452         uint256 amountAMin,
453         uint256 amountBMin,
454         address to,
455         uint256 deadline
456     )
457         external
458         returns (
459             uint256 amountA,
460             uint256 amountB,
461             uint256 liquidity
462         );
463 
464     function addLiquidityETH(
465         address token,
466         uint256 amountTokenDesired,
467         uint256 amountTokenMin,
468         uint256 amountETHMin,
469         address to,
470         uint256 deadline
471     )
472         external
473         payable
474         returns (
475             uint256 amountToken,
476             uint256 amountETH,
477             uint256 liquidity
478         );
479 
480     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
481         uint256 amountIn,
482         uint256 amountOutMin,
483         address[] calldata path,
484         address to,
485         uint256 deadline
486     ) external;
487 
488     function swapExactETHForTokensSupportingFeeOnTransferTokens(
489         uint256 amountOutMin,
490         address[] calldata path,
491         address to,
492         uint256 deadline
493     ) external payable;
494 
495     function swapExactTokensForETHSupportingFeeOnTransferTokens(
496         uint256 amountIn,
497         uint256 amountOutMin,
498         address[] calldata path,
499         address to,
500         uint256 deadline
501     ) external;
502 }
503 
504 contract Coge is ERC20, Ownable {
505     using SafeMath for uint256;
506 
507     IUniswapV2Router02 public immutable uniswapV2Router;
508     address public immutable uniswapV2Pair;
509     address public constant deadAddress = address(0xdead);
510 
511     bool private swapping;
512 
513     address public marketingWallet;
514 
515     uint256 public maxTransactionAmount;
516     uint256 public swapTokensAtAmount;
517     uint256 public maxWallet;
518 
519     bool public tradingActive = false;
520     bool public swapEnabled = false;
521 
522     uint256 public buyTotalFees;
523     uint256 private buyMarketingFee;
524     uint256 private buyLiquidityFee;
525 
526     uint256 public sellTotalFees;
527     uint256 private sellMarketingFee;
528     uint256 private sellLiquidityFee;
529 
530     uint256 private tokensForMarketing;
531     uint256 private tokensForLiquidity;
532     uint256 private previousFee;
533 
534     mapping(address => bool) private _isExcludedFromFees;
535     mapping(address => bool) private _isExcludedMaxTransactionAmount;
536     mapping(address => bool) private automatedMarketMakerPairs;
537 
538     event UpdateUniswapV2Router(
539         address indexed newAddress,
540         address indexed oldAddress
541     );
542 
543     event ExcludeFromFees(address indexed account, bool isExcluded);
544 
545     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
546 
547     event marketingWalletUpdated(
548         address indexed newWallet,
549         address indexed oldWallet
550     );
551 
552     event SwapAndLiquify(
553         uint256 tokensSwapped,
554         uint256 ethReceived,
555         uint256 tokensIntoLiquidity
556     );
557 
558     constructor() ERC20("Coge Inu", "Coge") {
559         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
560             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
561         );
562 
563         excludeFromMaxTransaction(address(_uniswapV2Router), true);
564         uniswapV2Router = _uniswapV2Router;
565 
566         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
567             .createPair(address(this), _uniswapV2Router.WETH());
568         excludeFromMaxTransaction(address(uniswapV2Pair), true);
569         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
570 
571         uint256 _buyMarketingFee = 15;
572         uint256 _buyLiquidityFee = 0;
573 
574         uint256 _sellMarketingFee = 25;
575         uint256 _sellLiquidityFee = 0;
576 
577         uint256 totalSupply = 1000000000 * 1e18;
578 
579         maxTransactionAmount = 20000000 * 1e18;
580         maxWallet = 30000000 * 1e18;
581         swapTokensAtAmount = (totalSupply * 5) / 10000;
582 
583         buyMarketingFee = _buyMarketingFee;
584         buyLiquidityFee = _buyLiquidityFee;
585         buyTotalFees = buyMarketingFee + buyLiquidityFee;
586 
587         sellMarketingFee = _sellMarketingFee;
588         sellLiquidityFee = _sellLiquidityFee;
589         sellTotalFees = sellMarketingFee + sellLiquidityFee;
590         previousFee = sellTotalFees;
591 
592         marketingWallet = address(0x674D87f1D4902A19a6986D6E34D78bd1276afb42);
593 
594         excludeFromFees(owner(), true);
595         excludeFromFees(address(this), true);
596         excludeFromFees(address(0xdead), true);
597 
598         excludeFromMaxTransaction(owner(), true);
599         excludeFromMaxTransaction(address(this), true);
600         excludeFromMaxTransaction(address(0xdead), true);
601 
602         _mint(msg.sender, totalSupply);
603     }
604 
605     receive() external payable {}
606 
607     function enableTrading() external onlyOwner {
608         tradingActive = true;
609         swapEnabled = true;
610     }
611 
612     function updateSwapTokensAtAmount(uint256 newAmount)
613         external
614         onlyOwner
615         returns (bool)
616     {
617         require(
618             newAmount >= (totalSupply() * 1) / 100000,
619             "Swap amount cannot be lower than 0.001% total supply."
620         );
621         require(
622             newAmount <= (totalSupply() * 5) / 1000,
623             "Swap amount cannot be higher than 0.5% total supply."
624         );
625         swapTokensAtAmount = newAmount;
626         return true;
627     }
628 
629     function updateMaxWalletAndTxnAmount(uint256 newTxnNum, uint256 newMaxWalletNum) external onlyOwner {
630         require(
631             newTxnNum >= ((totalSupply() * 5) / 1000) / 1e18,
632             "Cannot set maxTxn lower than 0.5%"
633         );
634         require(
635             newMaxWalletNum >= ((totalSupply() * 5) / 1000) / 1e18,
636             "Cannot set maxWallet lower than 0.5%"
637         );
638         maxWallet = newMaxWalletNum * (10**18);
639         maxTransactionAmount = newTxnNum * (10**18);
640     }
641 
642     function excludeFromMaxTransaction(address updAds, bool isEx)
643         public
644         onlyOwner
645     {
646         _isExcludedMaxTransactionAmount[updAds] = isEx;
647     }
648 
649     function updateBuyFees(
650         uint256 _marketingFee,
651         uint256 _liquidityFee
652     ) external onlyOwner {
653         buyMarketingFee = _marketingFee;
654         buyLiquidityFee = _liquidityFee;
655         buyTotalFees = buyMarketingFee + buyLiquidityFee;
656         require(buyTotalFees <= 5, "Must keep fees at 5% or less");
657     }
658 
659     function updateSellFees(
660         uint256 _marketingFee,
661         uint256 _liquidityFee
662     ) external onlyOwner {
663         sellMarketingFee = _marketingFee;
664         sellLiquidityFee = _liquidityFee;
665         sellTotalFees = sellMarketingFee + sellLiquidityFee;
666         previousFee = sellTotalFees;
667         require(sellTotalFees <= 5, "Must keep fees at 5% or less");
668     }
669 
670     function excludeFromFees(address account, bool excluded) public onlyOwner {
671         _isExcludedFromFees[account] = excluded;
672         emit ExcludeFromFees(account, excluded);
673     }
674 
675     function setAutomatedMarketMakerPair(address pair, bool value)
676         public
677         onlyOwner
678     {
679         require(
680             pair != uniswapV2Pair,
681             "The pair cannot be removed from automatedMarketMakerPairs"
682         );
683 
684         _setAutomatedMarketMakerPair(pair, value);
685     }
686 
687     function _setAutomatedMarketMakerPair(address pair, bool value) private {
688         automatedMarketMakerPairs[pair] = value;
689 
690         emit SetAutomatedMarketMakerPair(pair, value);
691     }
692 
693     function isExcludedFromFees(address account) public view returns (bool) {
694         return _isExcludedFromFees[account];
695     }
696 
697     function _transfer(
698         address from,
699         address to,
700         uint256 amount
701     ) internal override {
702         require(from != address(0), "ERC20: transfer from the zero address");
703         require(to != address(0), "ERC20: transfer to the zero address");
704 
705         if (amount == 0) {
706             super._transfer(from, to, 0);
707             return;
708         }
709 
710                 if (
711                 from != owner() &&
712                 to != owner() &&
713                 to != address(0) &&
714                 to != address(0xdead) &&
715                 !swapping
716             ) {
717                 if (!tradingActive) {
718                     require(
719                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
720                         "Trading is not active."
721                     );
722                 }
723 
724                 //when buy
725                 if (
726                     automatedMarketMakerPairs[from] &&
727                     !_isExcludedMaxTransactionAmount[to]
728                 ) {
729                     require(
730                         amount <= maxTransactionAmount,
731                         "Buy transfer amount exceeds the maxTransactionAmount."
732                     );
733                     require(
734                         amount + balanceOf(to) <= maxWallet,
735                         "Max wallet exceeded"
736                     );
737                 }
738                 //when sell
739                 else if (
740                     automatedMarketMakerPairs[to] &&
741                     !_isExcludedMaxTransactionAmount[from]
742                 ) {
743                     require(
744                         amount <= maxTransactionAmount,
745                         "Sell transfer amount exceeds the maxTransactionAmount."
746                     );
747                 } 
748                 
749                 else if (!_isExcludedMaxTransactionAmount[to]) {
750                     require(
751                         amount + balanceOf(to) <= maxWallet,
752                         "Max wallet exceeded"
753                     );
754                 }
755             }
756 
757         uint256 contractTokenBalance = balanceOf(address(this));
758 
759         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
760 
761         if (
762             canSwap &&
763             swapEnabled &&
764             !swapping &&
765             !automatedMarketMakerPairs[from] &&
766             !_isExcludedFromFees[from] &&
767             !_isExcludedFromFees[to]
768         ) {
769             swapping = true;
770 
771             swapBack();
772 
773             swapping = false;
774         }
775 
776         bool takeFee = !swapping;
777 
778         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
779             takeFee = false;
780         }
781 
782         uint256 fees = 0;
783 
784         if (takeFee) {
785             // on sell
786             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
787                 fees = amount.mul(sellTotalFees).div(100);
788                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
789                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
790             }
791             // on buy
792             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
793                 fees = amount.mul(buyTotalFees).div(100);
794                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
795                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
796             }
797 
798             if (fees > 0) {
799                 super._transfer(from, address(this), fees);
800             }
801 
802             amount -= fees;
803         }
804 
805         super._transfer(from, to, amount);
806         sellTotalFees = previousFee;
807 
808     }
809 
810     function swapTokensForEth(uint256 tokenAmount) private {
811 
812         address[] memory path = new address[](2);
813         path[0] = address(this);
814         path[1] = uniswapV2Router.WETH();
815 
816         _approve(address(this), address(uniswapV2Router), tokenAmount);
817 
818         // make the swap
819         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
820             tokenAmount,
821             0,
822             path,
823             address(this),
824             block.timestamp
825         );
826     }
827 
828     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
829 
830         _approve(address(this), address(uniswapV2Router), tokenAmount);
831 
832         uniswapV2Router.addLiquidityETH{value: ethAmount}(
833             address(this),
834             tokenAmount,
835             0,
836             0,
837             deadAddress,
838             block.timestamp
839         );
840     }
841 
842     function swapBack() private {
843         uint256 contractBalance = balanceOf(address(this));
844         uint256 totalTokensToSwap = tokensForLiquidity +
845             tokensForMarketing;
846         bool success;
847 
848         if (contractBalance == 0 || totalTokensToSwap == 0) {
849             return;
850         }
851 
852         if (contractBalance > swapTokensAtAmount * 20) {
853             contractBalance = swapTokensAtAmount * 20;
854         }
855 
856         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
857             totalTokensToSwap /
858             2;
859         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
860 
861         uint256 initialETHBalance = address(this).balance;
862 
863         swapTokensForEth(amountToSwapForETH);
864 
865         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
866 
867         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
868             totalTokensToSwap
869         );
870 
871         uint256 ethForLiquidity = ethBalance - ethForMarketing;
872 
873         tokensForLiquidity = 0;
874         tokensForMarketing = 0;
875 
876         if (liquidityTokens > 0 && ethForLiquidity > 0) {
877             addLiquidity(liquidityTokens, ethForLiquidity);
878             emit SwapAndLiquify(
879                 amountToSwapForETH,
880                 ethForLiquidity,
881                 tokensForLiquidity
882             );
883         }
884 
885         (success, ) = address(marketingWallet).call{value: address(this).balance}("");
886     }
887 }