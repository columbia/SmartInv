1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.16;
3 pragma experimental ABIEncoderV2;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
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
33     function renounceOwnership() public virtual onlyOwner { //Change
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
52     function balanceOf(address account) external view returns (uint256);
53     function transfer(address recipient, uint256 amount) external returns (bool);
54     function allowance(address owner, address spender) external view returns (uint256);
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     function transferFrom(
58         address sender,
59         address recipient,
60         uint256 amount
61     ) external returns (bool);
62 
63     event Transfer(address indexed from, address indexed to, uint256 value);
64     event Approval(address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 interface IERC20Metadata is IERC20 {
68 
69     function name() external view returns (string memory);
70     function symbol() external view returns (string memory);
71     function decimals() external view returns (uint8);
72 }
73 
74 
75 contract ERC20 is Context, IERC20, IERC20Metadata {
76     mapping(address => uint256) private _balances;
77 
78     mapping(address => mapping(address => uint256)) private _allowances;
79 
80     uint256 private _totalSupply;
81 
82     string private _name;
83     string private _symbol;
84 
85     constructor(string memory name_, string memory symbol_) {
86         _name = name_;
87         _symbol = symbol_;
88     }
89 
90     function name() public view virtual override returns (string memory) {
91         return _name;
92     }
93 
94     function symbol() public view virtual override returns (string memory) {
95         return _symbol;
96     }
97 
98     function decimals() public view virtual override returns (uint8) {
99         return 18;
100     }
101 
102     function totalSupply() public view virtual override returns (uint256) {
103         return _totalSupply;
104     }
105 
106     function balanceOf(address account) public view virtual override returns (uint256) {
107         return _balances[account];
108     }
109 
110     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
111         _transfer(_msgSender(), recipient, amount);
112         return true;
113     }
114 
115     function allowance(address owner, address spender) public view virtual override returns (uint256) {
116         return _allowances[owner][spender];
117     }
118 
119     function approve(address spender, uint256 amount) public virtual override returns (bool) {
120         _approve(_msgSender(), spender, amount);
121         return true;
122     }
123 
124     function transferFrom(
125         address sender,
126         address recipient,
127         uint256 amount
128     ) public virtual override returns (bool) {
129         _transfer(sender, recipient, amount);
130 
131         uint256 currentAllowance = _allowances[sender][_msgSender()];
132         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
133         unchecked {
134             _approve(sender, _msgSender(), currentAllowance - amount);
135         }
136 
137         return true;
138     }
139 
140     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
141         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
142         return true;
143     }
144 
145     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
146         uint256 currentAllowance = _allowances[_msgSender()][spender];
147         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
148         unchecked {
149             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
150         }
151 
152         return true;
153     }
154 
155     function _transfer(
156         address sender,
157         address recipient,
158         uint256 amount
159     ) internal virtual {
160         require(sender != address(0), "ERC20: transfer from the zero address");
161         require(recipient != address(0), "ERC20: transfer to the zero address");
162 
163         _beforeTokenTransfer(sender, recipient, amount);
164 
165         uint256 senderBalance = _balances[sender];
166         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
167         unchecked {
168             _balances[sender] = senderBalance - amount;
169         }
170         _balances[recipient] += amount;
171 
172         emit Transfer(sender, recipient, amount);
173 
174         _afterTokenTransfer(sender, recipient, amount);
175     }
176 
177     function _mint(address account, uint256 amount) internal virtual {
178         require(account != address(0), "ERC20: mint to the zero address");
179 
180         _beforeTokenTransfer(address(0), account, amount);
181 
182         _totalSupply += amount;
183         _balances[account] += amount;
184         emit Transfer(address(0), account, amount);
185 
186         _afterTokenTransfer(address(0), account, amount);
187     }
188 
189     function _approve(
190         address owner,
191         address spender,
192         uint256 amount
193     ) internal virtual {
194         require(owner != address(0), "ERC20: approve from the zero address");
195         require(spender != address(0), "ERC20: approve to the zero address");
196 
197         _allowances[owner][spender] = amount;
198         emit Approval(owner, spender, amount);
199     }
200 
201     function _beforeTokenTransfer(
202         address from,
203         address to,
204         uint256 amount
205     ) internal virtual {}
206 
207     function _afterTokenTransfer(
208         address from,
209         address to,
210         uint256 amount
211     ) internal virtual {}
212 }
213 
214 library SafeMath {
215 
216     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
217         unchecked {
218             uint256 c = a + b;
219             if (c < a) return (false, 0);
220             return (true, c);
221         }
222     }
223 
224     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
225         unchecked {
226             if (b > a) return (false, 0);
227             return (true, a - b);
228         }
229     }
230 
231     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
232         unchecked {
233             if (a == 0) return (true, 0);
234             uint256 c = a * b;
235             if (c / a != b) return (false, 0);
236             return (true, c);
237         }
238     }
239 
240     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
241         unchecked {
242             if (b == 0) return (false, 0);
243             return (true, a / b);
244         }
245     }
246 
247     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
248         unchecked {
249             if (b == 0) return (false, 0);
250             return (true, a % b);
251         }
252     }
253 
254     function add(uint256 a, uint256 b) internal pure returns (uint256) {
255         return a + b;
256     }
257 
258     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
259         return a - b;
260     }
261 
262     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
263         return a * b;
264     }
265 
266     function div(uint256 a, uint256 b) internal pure returns (uint256) {
267         return a / b;
268     }
269 
270     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
271         return a % b;
272     }
273 
274     function sub(
275         uint256 a,
276         uint256 b,
277         string memory errorMessage
278     ) internal pure returns (uint256) {
279         unchecked {
280             require(b <= a, errorMessage);
281             return a - b;
282         }
283     }
284 
285     function div(
286         uint256 a,
287         uint256 b,
288         string memory errorMessage
289     ) internal pure returns (uint256) {
290         unchecked {
291             require(b > 0, errorMessage);
292             return a / b;
293         }
294     }
295 
296     function mod(
297         uint256 a,
298         uint256 b,
299         string memory errorMessage
300     ) internal pure returns (uint256) {
301         unchecked {
302             require(b > 0, errorMessage);
303             return a % b;
304         }
305     }
306 }
307 
308 interface IUniswapV2Factory {
309     event PairCreated(
310         address indexed token0,
311         address indexed token1,
312         address pair,
313         uint256
314     );
315 
316     function feeTo() external view returns (address);
317 
318     function feeToSetter() external view returns (address);
319 
320     function getPair(address tokenA, address tokenB)
321         external
322         view
323         returns (address pair);
324 
325     function allPairs(uint256) external view returns (address pair);
326 
327     function allPairsLength() external view returns (uint256);
328 
329     function createPair(address tokenA, address tokenB)
330         external
331         returns (address pair);
332 
333     function setFeeTo(address) external;
334 
335     function setFeeToSetter(address) external;
336 }
337 
338 interface IUniswapV2Pair {
339     event Approval(
340         address indexed owner,
341         address indexed spender,
342         uint256 value
343     );
344     event Transfer(address indexed from, address indexed to, uint256 value);
345 
346     function name() external pure returns (string memory);
347 
348     function symbol() external pure returns (string memory);
349 
350     function decimals() external pure returns (uint8);
351 
352     function totalSupply() external view returns (uint256);
353 
354     function balanceOf(address owner) external view returns (uint256);
355 
356     function allowance(address owner, address spender)
357         external
358         view
359         returns (uint256);
360 
361     function approve(address spender, uint256 value) external returns (bool);
362 
363     function transfer(address to, uint256 value) external returns (bool);
364 
365     function transferFrom(
366         address from,
367         address to,
368         uint256 value
369     ) external returns (bool);
370 
371     function DOMAIN_SEPARATOR() external view returns (bytes32);
372 
373     function PERMIT_TYPEHASH() external pure returns (bytes32);
374 
375     function nonces(address owner) external view returns (uint256);
376 
377     function permit(
378         address owner,
379         address spender,
380         uint256 value,
381         uint256 deadline,
382         uint8 v,
383         bytes32 r,
384         bytes32 s
385     ) external;
386 
387     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
388 
389     event Swap(
390         address indexed sender,
391         uint256 amount0In,
392         uint256 amount1In,
393         uint256 amount0Out,
394         uint256 amount1Out,
395         address indexed to
396     );
397     event Sync(uint112 reserve0, uint112 reserve1);
398 
399     function MINIMUM_LIQUIDITY() external pure returns (uint256);
400 
401     function factory() external view returns (address);
402 
403     function token0() external view returns (address);
404 
405     function token1() external view returns (address);
406 
407     function getReserves()
408         external
409         view
410         returns (
411             uint112 reserve0,
412             uint112 reserve1,
413             uint32 blockTimestampLast
414         );
415 
416     function price0CumulativeLast() external view returns (uint256);
417 
418     function price1CumulativeLast() external view returns (uint256);
419 
420     function kLast() external view returns (uint256);
421 
422     function mint(address to) external returns (uint256 liquidity);
423 
424     function swap(
425         uint256 amount0Out,
426         uint256 amount1Out,
427         address to,
428         bytes calldata data
429     ) external;
430 
431     function skim(address to) external;
432 
433     function sync() external;
434 
435     function initialize(address, address) external;
436 }
437 
438 interface IUniswapV2Router02 {
439     function factory() external pure returns (address);
440 
441     function WETH() external pure returns (address);
442 
443     function addLiquidity(
444         address tokenA,
445         address tokenB,
446         uint256 amountADesired,
447         uint256 amountBDesired,
448         uint256 amountAMin,
449         uint256 amountBMin,
450         address to,
451         uint256 deadline
452     )
453         external
454         returns (
455             uint256 amountA,
456             uint256 amountB,
457             uint256 liquidity
458         );
459 
460     function addLiquidityETH(
461         address token,
462         uint256 amountTokenDesired,
463         uint256 amountTokenMin,
464         uint256 amountETHMin,
465         address to,
466         uint256 deadline
467     )
468         external
469         payable
470         returns (
471             uint256 amountToken,
472             uint256 amountETH,
473             uint256 liquidity
474         );
475 
476     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
477         uint256 amountIn,
478         uint256 amountOutMin,
479         address[] calldata path,
480         address to,
481         uint256 deadline
482     ) external;
483 
484     function swapExactETHForTokensSupportingFeeOnTransferTokens(
485         uint256 amountOutMin,
486         address[] calldata path,
487         address to,
488         uint256 deadline
489     ) external payable;
490 
491     function swapExactTokensForETHSupportingFeeOnTransferTokens(
492         uint256 amountIn,
493         uint256 amountOutMin,
494         address[] calldata path,
495         address to,
496         uint256 deadline
497     ) external;
498 }
499 
500 contract BABYSHARKTANK is ERC20, Ownable {
501     using SafeMath for uint256;
502 
503     IUniswapV2Router02 public immutable uniswapV2Router;
504     address public immutable uniswapV2Pair;
505     address public constant deadAddress = address(0xdead);
506 
507     bool private swapping;
508 
509     address public marketingWallet;
510 
511     uint256 public maxTransactionAmount;
512     uint256 public swapTokensAtAmount;
513     uint256 public maxWallet;
514 
515     bool public tradingActive = false;
516     bool public swapEnabled = false;
517 
518     uint256 public buyTotalFees;
519     uint256 private buyMarketingFee;
520     uint256 private buyLiquidityFee;
521 
522     uint256 public sellTotalFees;
523     uint256 private sellMarketingFee;
524     uint256 private sellLiquidityFee;
525 
526     uint256 private tokensForMarketing;
527     uint256 private tokensForLiquidity;
528     uint256 private previousFee;
529 
530     mapping(address => bool) private _isExcludedFromFees;
531     mapping(address => bool) private _isExcludedMaxTransactionAmount;
532     mapping(address => bool) private automatedMarketMakerPairs;
533 
534     event UpdateUniswapV2Router(
535         address indexed newAddress,
536         address indexed oldAddress
537     );
538 
539     event ExcludeFromFees(address indexed account, bool isExcluded);
540 
541     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
542 
543     event marketingWalletUpdated(
544         address indexed newWallet,
545         address indexed oldWallet
546     );
547 
548     event SwapAndLiquify(
549         uint256 tokensSwapped,
550         uint256 ethReceived,
551         uint256 tokensIntoLiquidity
552     );
553 
554     constructor() ERC20("BABYSHARKTANK", "BASHTANK") {
555         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
556             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
557         );
558 
559         excludeFromMaxTransaction(address(_uniswapV2Router), true);
560         uniswapV2Router = _uniswapV2Router;
561 
562         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
563             .createPair(address(this), _uniswapV2Router.WETH());
564         excludeFromMaxTransaction(address(uniswapV2Pair), true);
565         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
566 
567         uint256 _buyMarketingFee = 4;
568         uint256 _buyLiquidityFee = 0;
569 
570         uint256 _sellMarketingFee = 15;
571         uint256 _sellLiquidityFee = 0;
572 
573         uint256 totalSupply = 1000000000000 * 1e18;
574 
575         maxTransactionAmount = 10000000000 * 1e18;
576         maxWallet = 10000000000 * 1e18;
577         swapTokensAtAmount = (totalSupply * 5) / 10000;
578 
579         buyMarketingFee = _buyMarketingFee;
580         buyLiquidityFee = _buyLiquidityFee;
581         buyTotalFees = buyMarketingFee + buyLiquidityFee;
582 
583         sellMarketingFee = _sellMarketingFee;
584         sellLiquidityFee = _sellLiquidityFee;
585         sellTotalFees = sellMarketingFee + sellLiquidityFee;
586         previousFee = sellTotalFees;
587 
588         marketingWallet = address(0x5A9B851b63Aff70e5FeFa9C3762c791f490b8180);
589 
590         excludeFromFees(owner(), true);
591         excludeFromFees(address(this), true);
592         excludeFromFees(address(0xdead), true);
593 
594         excludeFromMaxTransaction(owner(), true);
595         excludeFromMaxTransaction(address(this), true);
596         excludeFromMaxTransaction(address(0xdead), true);
597 
598         _mint(msg.sender, totalSupply);
599     }
600 
601     receive() external payable {}
602 
603     function enableTrading() external onlyOwner {
604         tradingActive = true;
605         swapEnabled = true;
606     }
607 
608     function updateSwapTokensAtAmount(uint256 newAmount)
609         external
610         onlyOwner
611         returns (bool)
612     {
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
625     function updateMaxWalletAndTxnAmount(uint256 newTxnNum, uint256 newMaxWalletNum) external onlyOwner {
626         require(
627             newTxnNum >= ((totalSupply() * 5) / 1000) / 1e18,
628             "Cannot set maxTxn lower than 0.5%"
629         );
630         require(
631             newMaxWalletNum >= ((totalSupply() * 5) / 1000) / 1e18,
632             "Cannot set maxWallet lower than 0.5%"
633         );
634         maxWallet = newMaxWalletNum * (10**18);
635         maxTransactionAmount = newTxnNum * (10**18);
636     }
637 
638     function excludeFromMaxTransaction(address updAds, bool isEx)
639         public
640         onlyOwner
641     {
642         _isExcludedMaxTransactionAmount[updAds] = isEx;
643     }
644 
645     function updateBuyFees(
646         uint256 _marketingFee,
647         uint256 _liquidityFee
648     ) external onlyOwner {
649         buyMarketingFee = _marketingFee;
650         buyLiquidityFee = _liquidityFee;
651         buyTotalFees = buyMarketingFee + buyLiquidityFee;
652         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
653     }
654 
655     function updateSellFees(
656         uint256 _marketingFee,
657         uint256 _liquidityFee
658     ) external onlyOwner {
659         sellMarketingFee = _marketingFee;
660         sellLiquidityFee = _liquidityFee;
661         sellTotalFees = sellMarketingFee + sellLiquidityFee;
662         previousFee = sellTotalFees;
663         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
664     }
665 
666     function excludeFromFees(address account, bool excluded) public onlyOwner {
667         _isExcludedFromFees[account] = excluded;
668         emit ExcludeFromFees(account, excluded);
669     }
670 
671     function setAutomatedMarketMakerPair(address pair, bool value)
672         public
673         onlyOwner
674     {
675         require(
676             pair != uniswapV2Pair,
677             "The pair cannot be removed from automatedMarketMakerPairs"
678         );
679 
680         _setAutomatedMarketMakerPair(pair, value);
681     }
682 
683     function _setAutomatedMarketMakerPair(address pair, bool value) private {
684         automatedMarketMakerPairs[pair] = value;
685 
686         emit SetAutomatedMarketMakerPair(pair, value);
687     }
688 
689     function isExcludedFromFees(address account) public view returns (bool) {
690         return _isExcludedFromFees[account];
691     }
692 
693     function _transfer(
694         address from,
695         address to,
696         uint256 amount
697     ) internal override {
698         require(from != address(0), "ERC20: transfer from the zero address");
699         require(to != address(0), "ERC20: transfer to the zero address");
700 
701         if (amount == 0) {
702             super._transfer(from, to, 0);
703             return;
704         }
705 
706                 if (
707                 from != owner() &&
708                 to != owner() &&
709                 to != address(0) &&
710                 to != address(0xdead) &&
711                 !swapping
712             ) {
713                 if (!tradingActive) {
714                     require(
715                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
716                         "Trading is not active."
717                     );
718                 }
719 
720                 //when buy
721                 if (
722                     automatedMarketMakerPairs[from] &&
723                     !_isExcludedMaxTransactionAmount[to]
724                 ) {
725                     require(
726                         amount <= maxTransactionAmount,
727                         "Buy transfer amount exceeds the maxTransactionAmount."
728                     );
729                     require(
730                         amount + balanceOf(to) <= maxWallet,
731                         "Max wallet exceeded"
732                     );
733                 }
734                 //when sell
735                 else if (
736                     automatedMarketMakerPairs[to] &&
737                     !_isExcludedMaxTransactionAmount[from]
738                 ) {
739                     require(
740                         amount <= maxTransactionAmount,
741                         "Sell transfer amount exceeds the maxTransactionAmount."
742                     );
743                 } 
744                 
745                 else if (!_isExcludedMaxTransactionAmount[to]) {
746                     require(
747                         amount + balanceOf(to) <= maxWallet,
748                         "Max wallet exceeded"
749                     );
750                 }
751             }
752 
753         uint256 contractTokenBalance = balanceOf(address(this));
754 
755         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
756 
757         if (
758             canSwap &&
759             swapEnabled &&
760             !swapping &&
761             !automatedMarketMakerPairs[from] &&
762             !_isExcludedFromFees[from] &&
763             !_isExcludedFromFees[to]
764         ) {
765             swapping = true;
766 
767             swapBack();
768 
769             swapping = false;
770         }
771 
772         bool takeFee = !swapping;
773 
774         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
775             takeFee = false;
776         }
777 
778         uint256 fees = 0;
779 
780         if (takeFee) {
781             // on sell
782             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
783                 fees = amount.mul(sellTotalFees).div(100);
784                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
785                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
786             }
787             // on buy
788             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
789                 fees = amount.mul(buyTotalFees).div(100);
790                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
791                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
792             }
793 
794             if (fees > 0) {
795                 super._transfer(from, address(this), fees);
796             }
797 
798             amount -= fees;
799         }
800 
801         super._transfer(from, to, amount);
802         sellTotalFees = previousFee;
803 
804     }
805 
806     function swapTokensForEth(uint256 tokenAmount) private {
807 
808         address[] memory path = new address[](2);
809         path[0] = address(this);
810         path[1] = uniswapV2Router.WETH();
811 
812         _approve(address(this), address(uniswapV2Router), tokenAmount);
813 
814         // make the swap
815         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
816             tokenAmount,
817             0,
818             path,
819             address(this),
820             block.timestamp
821         );
822     }
823 
824     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
825 
826         _approve(address(this), address(uniswapV2Router), tokenAmount);
827 
828         uniswapV2Router.addLiquidityETH{value: ethAmount}(
829             address(this),
830             tokenAmount,
831             0,
832             0,
833             deadAddress,
834             block.timestamp
835         );
836     }
837 
838     function swapBack() private {
839         uint256 contractBalance = balanceOf(address(this));
840         uint256 totalTokensToSwap = tokensForLiquidity +
841             tokensForMarketing;
842         bool success;
843 
844         if (contractBalance == 0 || totalTokensToSwap == 0) {
845             return;
846         }
847 
848         if (contractBalance > swapTokensAtAmount * 20) {
849             contractBalance = swapTokensAtAmount * 20;
850         }
851 
852         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
853             totalTokensToSwap /
854             2;
855         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
856 
857         uint256 initialETHBalance = address(this).balance;
858 
859         swapTokensForEth(amountToSwapForETH);
860 
861         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
862 
863         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
864             totalTokensToSwap
865         );
866 
867         uint256 ethForLiquidity = ethBalance - ethForMarketing;
868 
869         tokensForLiquidity = 0;
870         tokensForMarketing = 0;
871 
872         if (liquidityTokens > 0 && ethForLiquidity > 0) {
873             addLiquidity(liquidityTokens, ethForLiquidity);
874             emit SwapAndLiquify(
875                 amountToSwapForETH,
876                 ethForLiquidity,
877                 tokensForLiquidity
878             );
879         }
880 
881         (success, ) = address(marketingWallet).call{value: address(this).balance}("");
882     }
883 }