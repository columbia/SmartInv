1 // Website: https://liquidlock.xyz/
2 // Telegram: https://t.me/liquidlock
3 // Twitter: https://twitter.com/liquidlock_erc
4 // Medium: https://medium.com/@liquidlock_ERC
5 
6 // SPDX-License-Identifier: MIT
7 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
8 pragma experimental ABIEncoderV2;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view virtual returns (bytes calldata) {
16         return msg.data;
17     }
18 }
19 
20 abstract contract Ownable is Context {
21     address private _owner;
22 
23     event OwnershipTransferred(
24         address indexed previousOwner,
25         address indexed newOwner
26     );
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
41     function renounceOwnership() public virtual onlyOwner {
42         _transferOwnership(address(0));
43     }
44 
45     function transferOwnership(address newOwner) public virtual onlyOwner {
46         require(
47             newOwner != address(0),
48             "Ownable: new owner is the zero address"
49         );
50         _transferOwnership(newOwner);
51     }
52 
53     function _transferOwnership(address newOwner) internal virtual {
54         address oldOwner = _owner;
55         _owner = newOwner;
56         emit OwnershipTransferred(oldOwner, newOwner);
57     }
58 }
59 
60 interface IERC20 {
61     function totalSupply() external view returns (uint256);
62 
63     function balanceOf(address account) external view returns (uint256);
64 
65     function transfer(address recipient, uint256 amount)
66         external
67         returns (bool);
68 
69     function allowance(address owner, address spender)
70         external
71         view
72         returns (uint256);
73 
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     function transferFrom(
77         address sender,
78         address recipient,
79         uint256 amount
80     ) external returns (bool);
81 
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     event Approval(
85         address indexed owner,
86         address indexed spender,
87         uint256 value
88     );
89 }
90 
91 interface IERC20Metadata is IERC20 {
92     function name() external view returns (string memory);
93 
94     function symbol() external view returns (string memory);
95 
96     function decimals() external view returns (uint8);
97 }
98 
99 contract ERC20 is Context, IERC20, IERC20Metadata {
100     mapping(address => uint256) private _balances;
101 
102     mapping(address => mapping(address => uint256)) private _allowances;
103 
104     uint256 private _totalSupply;
105 
106     string private _name;
107     string private _symbol;
108 
109     constructor(string memory name_, string memory symbol_) {
110         _name = name_;
111         _symbol = symbol_;
112     }
113 
114     function name() public view virtual override returns (string memory) {
115         return _name;
116     }
117 
118     function symbol() public view virtual override returns (string memory) {
119         return _symbol;
120     }
121 
122     function decimals() public view virtual override returns (uint8) {
123         return 18;
124     }
125 
126     function totalSupply() public view virtual override returns (uint256) {
127         return _totalSupply;
128     }
129 
130     function balanceOf(address account)
131         public
132         view
133         virtual
134         override
135         returns (uint256)
136     {
137         return _balances[account];
138     }
139 
140     function transfer(address recipient, uint256 amount)
141         public
142         virtual
143         override
144         returns (bool)
145     {
146         _transfer(_msgSender(), recipient, amount);
147         return true;
148     }
149 
150     function allowance(address owner, address spender)
151         public
152         view
153         virtual
154         override
155         returns (uint256)
156     {
157         return _allowances[owner][spender];
158     }
159 
160     function approve(address spender, uint256 amount)
161         public
162         virtual
163         override
164         returns (bool)
165     {
166         _approve(_msgSender(), spender, amount);
167         return true;
168     }
169 
170     function transferFrom(
171         address sender,
172         address recipient,
173         uint256 amount
174     ) public virtual override returns (bool) {
175         _transfer(sender, recipient, amount);
176 
177         uint256 currentAllowance = _allowances[sender][_msgSender()];
178         require(
179             currentAllowance >= amount,
180             "ERC20: transfer amount exceeds allowance"
181         );
182         unchecked {
183             _approve(sender, _msgSender(), currentAllowance - amount);
184         }
185 
186         return true;
187     }
188 
189     function increaseAllowance(address spender, uint256 addedValue)
190         public
191         virtual
192         returns (bool)
193     {
194         _approve(
195             _msgSender(),
196             spender,
197             _allowances[_msgSender()][spender] + addedValue
198         );
199         return true;
200     }
201 
202     function decreaseAllowance(address spender, uint256 subtractedValue)
203         public
204         virtual
205         returns (bool)
206     {
207         uint256 currentAllowance = _allowances[_msgSender()][spender];
208         require(
209             currentAllowance >= subtractedValue,
210             "ERC20: decreased allowance below zero"
211         );
212         unchecked {
213             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
214         }
215 
216         return true;
217     }
218 
219     function _transfer(
220         address sender,
221         address recipient,
222         uint256 amount
223     ) internal virtual {
224         require(sender != address(0), "ERC20: transfer from the zero address");
225         require(recipient != address(0), "ERC20: transfer to the zero address");
226 
227         _beforeTokenTransfer(sender, recipient, amount);
228 
229         uint256 senderBalance = _balances[sender];
230         require(
231             senderBalance >= amount,
232             "ERC20: transfer amount exceeds balance"
233         );
234         unchecked {
235             _balances[sender] = senderBalance - amount;
236         }
237         _balances[recipient] += amount;
238 
239         emit Transfer(sender, recipient, amount);
240 
241         _afterTokenTransfer(sender, recipient, amount);
242     }
243 
244     function _mint(address account, uint256 amount) internal virtual {
245         require(account != address(0), "ERC20: mint to the zero address");
246 
247         _beforeTokenTransfer(address(0), account, amount);
248 
249         _totalSupply += amount;
250         _balances[account] += amount;
251         emit Transfer(address(0), account, amount);
252 
253         _afterTokenTransfer(address(0), account, amount);
254     }
255 
256     function _burn(address account, uint256 amount) internal virtual {
257         require(account != address(0), "ERC20: burn from the zero address");
258 
259         _beforeTokenTransfer(account, address(0), amount);
260 
261         uint256 accountBalance = _balances[account];
262         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
263         unchecked {
264             _balances[account] = accountBalance - amount;
265         }
266         _totalSupply -= amount;
267 
268         emit Transfer(account, address(0), amount);
269 
270         _afterTokenTransfer(account, address(0), amount);
271     }
272 
273     function _approve(
274         address owner,
275         address spender,
276         uint256 amount
277     ) internal virtual {
278         require(owner != address(0), "ERC20: approve from the zero address");
279         require(spender != address(0), "ERC20: approve to the zero address");
280 
281         _allowances[owner][spender] = amount;
282         emit Approval(owner, spender, amount);
283     }
284 
285     function _beforeTokenTransfer(
286         address from,
287         address to,
288         uint256 amount
289     ) internal virtual {}
290 
291     function _afterTokenTransfer(
292         address from,
293         address to,
294         uint256 amount
295     ) internal virtual {}
296 }
297 
298 library SafeMath {
299     function tryAdd(uint256 a, uint256 b)
300         internal
301         pure
302         returns (bool, uint256)
303     {
304         unchecked {
305             uint256 c = a + b;
306             if (c < a) return (false, 0);
307             return (true, c);
308         }
309     }
310 
311     function trySub(uint256 a, uint256 b)
312         internal
313         pure
314         returns (bool, uint256)
315     {
316         unchecked {
317             if (b > a) return (false, 0);
318             return (true, a - b);
319         }
320     }
321 
322     function tryMul(uint256 a, uint256 b)
323         internal
324         pure
325         returns (bool, uint256)
326     {
327         unchecked {
328             if (a == 0) return (true, 0);
329             uint256 c = a * b;
330             if (c / a != b) return (false, 0);
331             return (true, c);
332         }
333     }
334 
335     function tryDiv(uint256 a, uint256 b)
336         internal
337         pure
338         returns (bool, uint256)
339     {
340         unchecked {
341             if (b == 0) return (false, 0);
342             return (true, a / b);
343         }
344     }
345 
346     function tryMod(uint256 a, uint256 b)
347         internal
348         pure
349         returns (bool, uint256)
350     {
351         unchecked {
352             if (b == 0) return (false, 0);
353             return (true, a % b);
354         }
355     }
356 
357     function add(uint256 a, uint256 b) internal pure returns (uint256) {
358         return a + b;
359     }
360 
361     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
362         return a - b;
363     }
364 
365     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
366         return a * b;
367     }
368 
369     function div(uint256 a, uint256 b) internal pure returns (uint256) {
370         return a / b;
371     }
372 
373     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
374         return a % b;
375     }
376 
377     function sub(
378         uint256 a,
379         uint256 b,
380         string memory errorMessage
381     ) internal pure returns (uint256) {
382         unchecked {
383             require(b <= a, errorMessage);
384             return a - b;
385         }
386     }
387 
388     function div(
389         uint256 a,
390         uint256 b,
391         string memory errorMessage
392     ) internal pure returns (uint256) {
393         unchecked {
394             require(b > 0, errorMessage);
395             return a / b;
396         }
397     }
398 
399     function mod(
400         uint256 a,
401         uint256 b,
402         string memory errorMessage
403     ) internal pure returns (uint256) {
404         unchecked {
405             require(b > 0, errorMessage);
406             return a % b;
407         }
408     }
409 }
410 
411 interface IUniswapV2Factory {
412     event PairCreated(
413         address indexed token0,
414         address indexed token1,
415         address pair,
416         uint256
417     );
418 
419     function feeTo() external view returns (address);
420 
421     function feeToSetter() external view returns (address);
422 
423     function getPair(address tokenA, address tokenB)
424         external
425         view
426         returns (address pair);
427 
428     function allPairs(uint256) external view returns (address pair);
429 
430     function allPairsLength() external view returns (uint256);
431 
432     function createPair(address tokenA, address tokenB)
433         external
434         returns (address pair);
435 
436     function setFeeTo(address) external;
437 
438     function setFeeToSetter(address) external;
439 }
440 
441 interface IUniswapV2Pair {
442     event Approval(
443         address indexed owner,
444         address indexed spender,
445         uint256 value
446     );
447     event Transfer(address indexed from, address indexed to, uint256 value);
448 
449     function name() external pure returns (string memory);
450 
451     function symbol() external pure returns (string memory);
452 
453     function decimals() external pure returns (uint8);
454 
455     function totalSupply() external view returns (uint256);
456 
457     function balanceOf(address owner) external view returns (uint256);
458 
459     function allowance(address owner, address spender)
460         external
461         view
462         returns (uint256);
463 
464     function approve(address spender, uint256 value) external returns (bool);
465 
466     function transfer(address to, uint256 value) external returns (bool);
467 
468     function transferFrom(
469         address from,
470         address to,
471         uint256 value
472     ) external returns (bool);
473 
474     function DOMAIN_SEPARATOR() external view returns (bytes32);
475 
476     function PERMIT_TYPEHASH() external pure returns (bytes32);
477 
478     function nonces(address owner) external view returns (uint256);
479 
480     function permit(
481         address owner,
482         address spender,
483         uint256 value,
484         uint256 deadline,
485         uint8 v,
486         bytes32 r,
487         bytes32 s
488     ) external;
489 
490     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
491     event Burn(
492         address indexed sender,
493         uint256 amount0,
494         uint256 amount1,
495         address indexed to
496     );
497     event Swap(
498         address indexed sender,
499         uint256 amount0In,
500         uint256 amount1In,
501         uint256 amount0Out,
502         uint256 amount1Out,
503         address indexed to
504     );
505     event Sync(uint112 reserve0, uint112 reserve1);
506 
507     function MINIMUM_LIQUIDITY() external pure returns (uint256);
508 
509     function factory() external view returns (address);
510 
511     function token0() external view returns (address);
512 
513     function token1() external view returns (address);
514 
515     function getReserves()
516         external
517         view
518         returns (
519             uint112 reserve0,
520             uint112 reserve1,
521             uint32 blockTimestampLast
522         );
523 
524     function price0CumulativeLast() external view returns (uint256);
525 
526     function price1CumulativeLast() external view returns (uint256);
527 
528     function kLast() external view returns (uint256);
529 
530     function mint(address to) external returns (uint256 liquidity);
531 
532     function burn(address to)
533         external
534         returns (uint256 amount0, uint256 amount1);
535 
536     function swap(
537         uint256 amount0Out,
538         uint256 amount1Out,
539         address to,
540         bytes calldata data
541     ) external;
542 
543     function skim(address to) external;
544 
545     function sync() external;
546 
547     function initialize(address, address) external;
548 }
549 
550 interface IUniswapV2Router02 {
551     function factory() external pure returns (address);
552 
553     function WETH() external pure returns (address);
554 
555     function addLiquidity(
556         address tokenA,
557         address tokenB,
558         uint256 amountADesired,
559         uint256 amountBDesired,
560         uint256 amountAMin,
561         uint256 amountBMin,
562         address to,
563         uint256 deadline
564     )
565         external
566         returns (
567             uint256 amountA,
568             uint256 amountB,
569             uint256 liquidity
570         );
571 
572     function addLiquidityETH(
573         address token,
574         uint256 amountTokenDesired,
575         uint256 amountTokenMin,
576         uint256 amountETHMin,
577         address to,
578         uint256 deadline
579     )
580         external
581         payable
582         returns (
583             uint256 amountToken,
584             uint256 amountETH,
585             uint256 liquidity
586         );
587 
588     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
589         uint256 amountIn,
590         uint256 amountOutMin,
591         address[] calldata path,
592         address to,
593         uint256 deadline
594     ) external;
595 
596     function swapExactETHForTokensSupportingFeeOnTransferTokens(
597         uint256 amountOutMin,
598         address[] calldata path,
599         address to,
600         uint256 deadline
601     ) external payable;
602 
603     function swapExactTokensForETHSupportingFeeOnTransferTokens(
604         uint256 amountIn,
605         uint256 amountOutMin,
606         address[] calldata path,
607         address to,
608         uint256 deadline
609     ) external;
610 }
611 
612 contract LiquidLock is ERC20, Ownable {
613     using SafeMath for uint256;
614 
615     IUniswapV2Router02 public immutable uniswapV2Router;
616     address public immutable uniswapV2Pair;
617     address public constant deadAddress = address(0xdead);
618 
619     bool private swapping;
620 
621     address private marketingWallet;
622     address private developmentWallet;
623 
624     uint256 public maxTransactionAmount;
625     uint256 public swapTokensAtAmount;
626     uint256 public maxWallet;
627 
628     uint256 public percentForLPBurn = 0;
629     bool public lpBurnEnabled = false;
630     uint256 public lpBurnFrequency = 3600 seconds;
631     uint256 public lastLpBurnTime;
632 
633     uint256 public manualBurnFrequency = 30 minutes;
634     uint256 public lastManualLpBurnTime;
635 
636     bool public limitsInEffect = true;
637     bool public tradingActive = false;
638     bool public swapEnabled = true;
639 
640     mapping(address => uint256) private _holderLastTransferTimestamp;
641     bool public transferDelayEnabled = true;
642 
643     uint256 public buyTotalFees;
644     uint256 public buyMarketingFee;
645     uint256 public buyLiquidityFee;
646     uint256 public buyDevelopmentFee;
647 
648     uint256 public sellTotalFees;
649     uint256 public sellMarketingFee;
650     uint256 public sellLiquidityFee;
651     uint256 public sellDevelopmentFee;
652 
653     uint256 public tokensForMarketing;
654     uint256 public tokensForLiquidity;
655     uint256 public tokensForDev;
656 
657     mapping(address => bool) private _isExcludedFromFees;
658     mapping(address => bool) public _isExcludedMaxTransactionAmount;
659 
660     mapping(address => bool) public automatedMarketMakerPairs;
661 
662     event UpdateUniswapV2Router(
663         address indexed newAddress,
664         address indexed oldAddress
665     );
666 
667     event ExcludeFromFees(address indexed account, bool isExcluded);
668 
669     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
670 
671     event marketingWalletUpdated(
672         address indexed newWallet,
673         address indexed oldWallet
674     );
675 
676     event developmentWalletUpdated(
677         address indexed newWallet,
678         address indexed oldWallet
679     );
680 
681     event SwapAndLiquify(
682         uint256 tokensSwapped,
683         uint256 ethReceived,
684         uint256 tokensIntoLiquidity
685     );
686 
687     event AutoNukeLP();
688 
689     event ManualNukeLP();
690 
691     constructor() ERC20("LiquidLock", "LOCK") {
692         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
693             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
694         );
695 
696         excludeFromMaxTransaction(address(_uniswapV2Router), true);
697         uniswapV2Router = _uniswapV2Router;
698 
699         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
700             .createPair(address(this), _uniswapV2Router.WETH());
701         excludeFromMaxTransaction(address(uniswapV2Pair), true);
702         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
703 
704         uint256 _buyMarketingFee = 20;
705         uint256 _buyLiquidityFee = 0;
706         uint256 _buyDevelopmentFee = 5;
707 
708         uint256 _sellMarketingFee = 28;
709         uint256 _sellLiquidityFee = 0;
710         uint256 _sellDevelopmentFee = 7;
711 
712         uint256 totalSupply = 100_000_000 * 1e18;
713 
714         maxTransactionAmount = 500_000 * 1e18;
715         maxWallet = 1_000_000 * 1e18;
716         swapTokensAtAmount = (totalSupply * 10) / 10000;
717 
718         buyMarketingFee = _buyMarketingFee;
719         buyLiquidityFee = _buyLiquidityFee;
720         buyDevelopmentFee = _buyDevelopmentFee;
721         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
722 
723         sellMarketingFee = _sellMarketingFee;
724         sellLiquidityFee = _sellLiquidityFee;
725         sellDevelopmentFee = _sellDevelopmentFee;
726         sellTotalFees =
727             sellMarketingFee +
728             sellLiquidityFee +
729             sellDevelopmentFee;
730 
731         marketingWallet = address(0xAF86D1e88fb05174591a511F9e7E15515C760682);
732         developmentWallet = address(0x122Fa954F48f8AD7Cfe1cd67b71D235055460c16);
733 
734         excludeFromFees(owner(), true);
735         excludeFromFees(address(this), true);
736         excludeFromFees(address(0xdead), true);
737 
738         excludeFromMaxTransaction(owner(), true);
739         excludeFromMaxTransaction(address(this), true);
740         excludeFromMaxTransaction(address(0xdead), true);
741 
742         _mint(msg.sender, totalSupply);
743     }
744 
745     receive() external payable {}
746 
747     function enableTrading() external onlyOwner {
748         tradingActive = true;
749         swapEnabled = true;
750         lastLpBurnTime = block.timestamp;
751     }
752 
753     function removeLimits() external onlyOwner returns (bool) {
754         limitsInEffect = false;
755         return true;
756     }
757 
758     function disableTransferDelay() external onlyOwner returns (bool) {
759         transferDelayEnabled = false;
760         return true;
761     }
762 
763     function updateSwapTokensAtAmount(uint256 newAmount)
764         external
765         onlyOwner
766         returns (bool)
767     {
768         require(
769             newAmount >= (totalSupply() * 1) / 100000,
770             "Swap amount cannot be lower than 0.001% total supply."
771         );
772         require(
773             newAmount <= (totalSupply() * 5) / 1000,
774             "Swap amount cannot be higher than 0.5% total supply."
775         );
776         swapTokensAtAmount = newAmount;
777         return true;
778     }
779 
780     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
781         require(
782             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
783             "Cannot set maxTransactionAmount lower than 0.1%"
784         );
785         maxTransactionAmount = newNum * (10**18);
786     }
787 
788     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
789         require(
790             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
791             "Cannot set maxWallet lower than 0.5%"
792         );
793         maxWallet = newNum * (10**18);
794     }
795 
796     function excludeFromMaxTransaction(address updAds, bool isEx)
797         public
798         onlyOwner
799     {
800         _isExcludedMaxTransactionAmount[updAds] = isEx;
801     }
802 
803     function updateSwapEnabled(bool enabled) external onlyOwner {
804         swapEnabled = enabled;
805     }
806 
807     function updateBuyFees(
808         uint256 _marketingFee,
809         uint256 _liquidityFee,
810         uint256 _developmentFee
811     ) external onlyOwner {
812         buyMarketingFee = _marketingFee;
813         buyLiquidityFee = _liquidityFee;
814         buyDevelopmentFee = _developmentFee;
815         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
816         require(buyTotalFees <= 35, "Must keep fees at 35% or less");
817     }
818 
819     function updateSellFees(
820         uint256 _marketingFee,
821         uint256 _liquidityFee,
822         uint256 _developmentFee
823     ) external onlyOwner {
824         sellMarketingFee = _marketingFee;
825         sellLiquidityFee = _liquidityFee;
826         sellDevelopmentFee = _developmentFee;
827         sellTotalFees =
828             sellMarketingFee +
829             sellLiquidityFee +
830             sellDevelopmentFee;
831         require(sellTotalFees <= 40, "Must keep fees at 40% or less");
832     }
833 
834     function excludeFromFees(address account, bool excluded) public onlyOwner {
835         _isExcludedFromFees[account] = excluded;
836         emit ExcludeFromFees(account, excluded);
837     }
838 
839     function setAutomatedMarketMakerPair(address pair, bool value)
840         public
841         onlyOwner
842     {
843         require(
844             pair != uniswapV2Pair,
845             "The pair cannot be removed from automatedMarketMakerPairs"
846         );
847 
848         _setAutomatedMarketMakerPair(pair, value);
849     }
850 
851     function _setAutomatedMarketMakerPair(address pair, bool value) private {
852         automatedMarketMakerPairs[pair] = value;
853 
854         emit SetAutomatedMarketMakerPair(pair, value);
855     }
856 
857     function updateMarketingWalletInfo(address newMarketingWallet)
858         external
859         onlyOwner
860     {
861         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
862         marketingWallet = newMarketingWallet;
863     }
864 
865     function updateDevelopmentWalletInfo(address newWallet) external onlyOwner {
866         emit developmentWalletUpdated(newWallet, developmentWallet);
867         developmentWallet = newWallet;
868     }
869 
870     function isExcludedFromFees(address account) public view returns (bool) {
871         return _isExcludedFromFees[account];
872     }
873 
874     event BoughtEarly(address indexed sniper);
875 
876     function _transfer(
877         address from,
878         address to,
879         uint256 amount
880     ) internal override {
881         require(from != address(0), "ERC20: transfer from the zero address");
882         require(to != address(0), "ERC20: transfer to the zero address");
883 
884         if (amount == 0) {
885             super._transfer(from, to, 0);
886             return;
887         }
888 
889         if (limitsInEffect) {
890             if (
891                 from != owner() &&
892                 to != owner() &&
893                 to != address(0) &&
894                 to != address(0xdead) &&
895                 !swapping
896             ) {
897                 if (!tradingActive) {
898                     require(
899                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
900                         "Trading is not active."
901                     );
902                 }
903 
904                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
905                 if (transferDelayEnabled) {
906                     if (
907                         to != owner() &&
908                         to != address(uniswapV2Router) &&
909                         to != address(uniswapV2Pair)
910                     ) {
911                         require(
912                             _holderLastTransferTimestamp[tx.origin] <
913                                 block.number,
914                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
915                         );
916                         _holderLastTransferTimestamp[tx.origin] = block.number;
917                     }
918                 }
919 
920                 //when buy
921                 if (
922                     automatedMarketMakerPairs[from] &&
923                     !_isExcludedMaxTransactionAmount[to]
924                 ) {
925                     require(
926                         amount <= maxTransactionAmount,
927                         "Buy transfer amount exceeds the maxTransactionAmount."
928                     );
929                     require(
930                         amount + balanceOf(to) <= maxWallet,
931                         "Max wallet exceeded"
932                     );
933                 }
934                 //when sell
935                 else if (
936                     automatedMarketMakerPairs[to] &&
937                     !_isExcludedMaxTransactionAmount[from]
938                 ) {
939                     require(
940                         amount <= maxTransactionAmount,
941                         "Sell transfer amount exceeds the maxTransactionAmount."
942                     );
943                 } else if (!_isExcludedMaxTransactionAmount[to]) {
944                     require(
945                         amount + balanceOf(to) <= maxWallet,
946                         "Max wallet exceeded"
947                     );
948                 }
949             }
950         }
951 
952         uint256 contractTokenBalance = balanceOf(address(this));
953 
954         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
955 
956         if (
957             canSwap &&
958             swapEnabled &&
959             !swapping &&
960             !automatedMarketMakerPairs[from] &&
961             !_isExcludedFromFees[from] &&
962             !_isExcludedFromFees[to]
963         ) {
964             swapping = true;
965 
966             swapBack();
967 
968             swapping = false;
969         }
970 
971         if (
972             !swapping &&
973             automatedMarketMakerPairs[to] &&
974             lpBurnEnabled &&
975             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
976             !_isExcludedFromFees[from]
977         ) {
978             autoBurnLiquidityPairTokens();
979         }
980 
981         bool takeFee = !swapping;
982 
983         // if any account belongs to _isExcludedFromFee account then remove the fee
984         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
985             takeFee = false;
986         }
987 
988         uint256 fees = 0;
989         // only take fees on buys/sells, do not take on wallet transfers
990         if (takeFee) {
991             // on sell
992             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
993                 fees = amount.mul(sellTotalFees).div(100);
994                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
995                 tokensForDev += (fees * sellDevelopmentFee) / sellTotalFees;
996                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
997             }
998             // on buy
999             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1000                 fees = amount.mul(buyTotalFees).div(100);
1001                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1002                 tokensForDev += (fees * buyDevelopmentFee) / buyTotalFees;
1003                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1004             }
1005 
1006             if (fees > 0) {
1007                 super._transfer(from, address(this), fees);
1008             }
1009 
1010             amount -= fees;
1011         }
1012 
1013         super._transfer(from, to, amount);
1014     }
1015 
1016     function swapTokensForEth(uint256 tokenAmount) private {
1017         // generate the uniswap pair path of token -> weth
1018         address[] memory path = new address[](2);
1019         path[0] = address(this);
1020         path[1] = uniswapV2Router.WETH();
1021 
1022         _approve(address(this), address(uniswapV2Router), tokenAmount);
1023 
1024         // make the swap
1025         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1026             tokenAmount,
1027             0, // accept any amount of ETH
1028             path,
1029             address(this),
1030             block.timestamp
1031         );
1032     }
1033 
1034     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1035         // approve token transfer to cover all possible scenarios
1036         _approve(address(this), address(uniswapV2Router), tokenAmount);
1037 
1038         // add the liquidity
1039         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1040             address(this),
1041             tokenAmount,
1042             0, // slippage is unavoidable
1043             0, // slippage is unavoidable
1044             deadAddress,
1045             block.timestamp
1046         );
1047     }
1048 
1049     function swapBack() private {
1050         uint256 contractBalance = balanceOf(address(this));
1051         uint256 totalTokensToSwap = tokensForLiquidity +
1052             tokensForMarketing +
1053             tokensForDev;
1054         bool success;
1055 
1056         if (contractBalance == 0 || totalTokensToSwap == 0) {
1057             return;
1058         }
1059 
1060         if (contractBalance > swapTokensAtAmount * 20) {
1061             contractBalance = swapTokensAtAmount * 20;
1062         }
1063 
1064         // Halve the amount of liquidity tokens
1065         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1066             totalTokensToSwap /
1067             2;
1068         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1069 
1070         uint256 initialETHBalance = address(this).balance;
1071 
1072         swapTokensForEth(amountToSwapForETH);
1073 
1074         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1075 
1076         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1077             totalTokensToSwap
1078         );
1079         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1080 
1081         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1082 
1083         tokensForLiquidity = 0;
1084         tokensForMarketing = 0;
1085         tokensForDev = 0;
1086 
1087         (success, ) = address(developmentWallet).call{value: ethForDev}("");
1088 
1089         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1090             addLiquidity(liquidityTokens, ethForLiquidity);
1091             emit SwapAndLiquify(
1092                 amountToSwapForETH,
1093                 ethForLiquidity,
1094                 tokensForLiquidity
1095             );
1096         }
1097 
1098         (success, ) = address(marketingWallet).call{
1099             value: address(this).balance
1100         }("");
1101     }
1102 
1103     function setAutoLPBurnSettings(
1104         uint256 _frequencyInSeconds,
1105         uint256 _percent,
1106         bool _Enabled
1107     ) external onlyOwner {
1108         require(
1109             _frequencyInSeconds >= 600,
1110             "cannot set buyback more often than every 10 minutes"
1111         );
1112         require(
1113             _percent <= 1000 && _percent >= 0,
1114             "Must set auto LP burn percent between 0% and 10%"
1115         );
1116         lpBurnFrequency = _frequencyInSeconds;
1117         percentForLPBurn = _percent;
1118         lpBurnEnabled = _Enabled;
1119     }
1120 
1121     function autoBurnLiquidityPairTokens() internal returns (bool) {
1122         lastLpBurnTime = block.timestamp;
1123 
1124         // get balance of liquidity pair
1125         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1126 
1127         // calculate amount to burn
1128         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1129             10000
1130         );
1131 
1132         // pull tokens from pancakePair liquidity and move to dead address permanently
1133         if (amountToBurn > 0) {
1134             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1135         }
1136 
1137         //sync price since this is not in a swap transaction!
1138         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1139         pair.sync();
1140         emit AutoNukeLP();
1141         return true;
1142     }
1143 
1144     function manualBurnLiquidityPairTokens(uint256 percent)
1145         external
1146         onlyOwner
1147         returns (bool)
1148     {
1149         require(
1150             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1151             "Must wait for cooldown to finish"
1152         );
1153         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1154         lastManualLpBurnTime = block.timestamp;
1155 
1156         // get balance of liquidity pair
1157         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1158 
1159         // calculate amount to burn
1160         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1161 
1162         // pull tokens from pancakePair liquidity and move to dead address permanently
1163         if (amountToBurn > 0) {
1164             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1165         }
1166 
1167         //sync price since this is not in a swap transaction!
1168         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1169         pair.sync();
1170         emit ManualNukeLP();
1171         return true;
1172     }
1173 }