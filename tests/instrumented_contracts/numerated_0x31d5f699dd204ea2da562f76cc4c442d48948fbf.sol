1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-07
3 */
4 
5 /** 
6  * Palpatinu - $SETH 
7  * Website: https://palpatinu.com
8  * Twitter: https://twitter.com/palpatinu_seth
9  * Telegram: https://t.me/palpatinu_seth
10 */
11 
12 // SPDX-License-Identifier: Unlicensed
13 pragma solidity ^0.8.9;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 abstract contract Ownable is Context {
25     address private _owner;
26 
27     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29     constructor() {
30         _transferOwnership(_msgSender());
31     }
32 
33     function owner() public view virtual returns (address) {
34         return _owner;
35     }
36 
37     modifier onlyOwner() {
38         require(owner() == _msgSender(), "Ownable: caller is not the owner");
39         _;
40     }
41 
42     function renounceOwnership() public virtual onlyOwner {
43         _transferOwnership(address(0));
44     }
45 
46     function transferOwnership(address newOwner) public virtual onlyOwner {
47         require(newOwner != address(0), "Ownable: new owner is the zero address");
48         _transferOwnership(newOwner);
49     }
50 
51     function _transferOwnership(address newOwner) internal virtual {
52         address oldOwner = _owner;
53         _owner = newOwner;
54         emit OwnershipTransferred(oldOwner, newOwner);
55     }
56 }
57 
58 interface IERC20 {
59     function totalSupply() external view returns (uint256);
60 
61     function balanceOf(address account) external view returns (uint256);
62 
63     function transfer(address recipient, uint256 amount) external returns (bool);
64 
65     function allowance(address owner, address spender) external view returns (uint256);
66 
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69     function transferFrom(
70         address sender,
71         address recipient,
72         uint256 amount
73     ) external returns (bool);
74 
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 interface IERC20Metadata is IERC20 {
81     function name() external view returns (string memory);
82 
83     function symbol() external view returns (string memory);
84 
85     function decimals() external view returns (uint8);
86 }
87 
88 contract ERC20 is Context, IERC20, IERC20Metadata {
89     mapping(address => uint256) private _balances;
90 
91     mapping(address => mapping(address => uint256)) private _allowances;
92 
93     uint256 private _totalSupply;
94 
95     string private _name;
96     string private _symbol;
97 
98     constructor(string memory name_, string memory symbol_) {
99         _name = name_;
100         _symbol = symbol_;
101     }
102 
103     function name() public view virtual override returns (string memory) {
104         return _name;
105     }
106 
107     function symbol() public view virtual override returns (string memory) {
108         return _symbol;
109     }
110 
111     function decimals() public view virtual override returns (uint8) {
112         return 18;
113     }
114 
115     function totalSupply() public view virtual override returns (uint256) {
116         return _totalSupply;
117     }
118 
119     function balanceOf(address account) public view virtual override returns (uint256) {
120         return _balances[account];
121     }
122 
123     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
124         _transfer(_msgSender(), recipient, amount);
125         return true;
126     }
127 
128     function allowance(address owner, address spender) public view virtual override returns (uint256) {
129         return _allowances[owner][spender];
130     }
131 
132     function approve(address spender, uint256 amount) public virtual override returns (bool) {
133         _approve(_msgSender(), spender, amount);
134         return true;
135     }
136 
137     function transferFrom(
138         address sender,
139         address recipient,
140         uint256 amount
141     ) public virtual override returns (bool) {
142         _transfer(sender, recipient, amount);
143 
144         uint256 currentAllowance = _allowances[sender][_msgSender()];
145         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
146         unchecked {
147             _approve(sender, _msgSender(), currentAllowance - amount);
148         }
149 
150         return true;
151     }
152 
153     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
154         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
155         return true;
156     }
157 
158     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
159         uint256 currentAllowance = _allowances[_msgSender()][spender];
160         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
161         unchecked {
162             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
163         }
164 
165         return true;
166     }
167 
168     function _transfer(
169         address sender,
170         address recipient,
171         uint256 amount
172     ) internal virtual {
173         require(sender != address(0), "ERC20: transfer from the zero address");
174         require(recipient != address(0), "ERC20: transfer to the zero address");
175 
176         _beforeTokenTransfer(sender, recipient, amount);
177 
178         uint256 senderBalance = _balances[sender];
179         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
180         unchecked {
181             _balances[sender] = senderBalance - amount;
182         }
183         _balances[recipient] += amount;
184 
185         emit Transfer(sender, recipient, amount);
186 
187         _afterTokenTransfer(sender, recipient, amount);
188     }
189 
190     function _mint(address account, uint256 amount) internal virtual {
191         require(account != address(0), "ERC20: mint to the zero address");
192 
193         _beforeTokenTransfer(address(0), account, amount);
194 
195         _totalSupply += amount;
196         _balances[account] += amount;
197         emit Transfer(address(0), account, amount);
198 
199         _afterTokenTransfer(address(0), account, amount);
200     }
201 
202     function _burn(address account, uint256 amount) internal virtual {
203         require(account != address(0), "ERC20: burn from the zero address");
204 
205         _beforeTokenTransfer(account, address(0), amount);
206 
207         uint256 accountBalance = _balances[account];
208         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
209         unchecked {
210             _balances[account] = accountBalance - amount;
211         }
212         _totalSupply -= amount;
213 
214         emit Transfer(account, address(0), amount);
215 
216         _afterTokenTransfer(account, address(0), amount);
217     }
218 
219     function _approve(
220         address owner,
221         address spender,
222         uint256 amount
223     ) internal virtual {
224         require(owner != address(0), "ERC20: approve from the zero address");
225         require(spender != address(0), "ERC20: approve to the zero address");
226 
227         _allowances[owner][spender] = amount;
228         emit Approval(owner, spender, amount);
229     }
230 
231     function _beforeTokenTransfer(
232         address from,
233         address to,
234         uint256 amount
235     ) internal virtual {}
236 
237     function _afterTokenTransfer(
238         address from,
239         address to,
240         uint256 amount
241     ) internal virtual {}
242 }
243 
244 library SafeMath {
245     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
246         unchecked {
247             uint256 c = a + b;
248             if (c < a) return (false, 0);
249             return (true, c);
250         }
251     }
252 
253     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
254         unchecked {
255             if (b > a) return (false, 0);
256             return (true, a - b);
257         }
258     }
259 
260     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
261         unchecked {
262             if (a == 0) return (true, 0);
263             uint256 c = a * b;
264             if (c / a != b) return (false, 0);
265             return (true, c);
266         }
267     }
268 
269     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
270         unchecked {
271             if (b == 0) return (false, 0);
272             return (true, a / b);
273         }
274     }
275 
276     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
277         unchecked {
278             if (b == 0) return (false, 0);
279             return (true, a % b);
280         }
281     }
282 
283     function add(uint256 a, uint256 b) internal pure returns (uint256) {
284         return a + b;
285     }
286 
287     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
288         return a - b;
289     }
290 
291     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
292         return a * b;
293     }
294 
295     function div(uint256 a, uint256 b) internal pure returns (uint256) {
296         return a / b;
297     }
298 
299     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
300         return a % b;
301     }
302 
303     function sub(
304         uint256 a,
305         uint256 b,
306         string memory errorMessage
307     ) internal pure returns (uint256) {
308         unchecked {
309             require(b <= a, errorMessage);
310             return a - b;
311         }
312     }
313 
314     function div(
315         uint256 a,
316         uint256 b,
317         string memory errorMessage
318     ) internal pure returns (uint256) {
319         unchecked {
320             require(b > 0, errorMessage);
321             return a / b;
322         }
323     }
324 
325     function mod(
326         uint256 a,
327         uint256 b,
328         string memory errorMessage
329     ) internal pure returns (uint256) {
330         unchecked {
331             require(b > 0, errorMessage);
332             return a % b;
333         }
334     }
335 }
336 
337 interface IUniswapV2Factory {
338     event PairCreated(
339         address indexed token0,
340         address indexed token1,
341         address pair,
342         uint256
343     );
344 
345     function feeTo() external view returns (address);
346 
347     function feeToSetter() external view returns (address);
348 
349     function getPair(address tokenA, address tokenB)
350         external
351         view
352         returns (address pair);
353 
354     function allPairs(uint256) external view returns (address pair);
355 
356     function allPairsLength() external view returns (uint256);
357 
358     function createPair(address tokenA, address tokenB)
359         external
360         returns (address pair);
361 
362     function setFeeTo(address) external;
363 
364     function setFeeToSetter(address) external;
365 }
366 
367 interface IUniswapV2Pair {
368     event Approval(
369         address indexed owner,
370         address indexed spender,
371         uint256 value
372     );
373     event Transfer(address indexed from, address indexed to, uint256 value);
374 
375     function name() external pure returns (string memory);
376 
377     function symbol() external pure returns (string memory);
378 
379     function decimals() external pure returns (uint8);
380 
381     function totalSupply() external view returns (uint256);
382 
383     function balanceOf(address owner) external view returns (uint256);
384 
385     function allowance(address owner, address spender)
386         external
387         view
388         returns (uint256);
389 
390     function approve(address spender, uint256 value) external returns (bool);
391 
392     function transfer(address to, uint256 value) external returns (bool);
393 
394     function transferFrom(
395         address from,
396         address to,
397         uint256 value
398     ) external returns (bool);
399 
400     function DOMAIN_SEPARATOR() external view returns (bytes32);
401 
402     function PERMIT_TYPEHASH() external pure returns (bytes32);
403 
404     function nonces(address owner) external view returns (uint256);
405 
406     function permit(
407         address owner,
408         address spender,
409         uint256 value,
410         uint256 deadline,
411         uint8 v,
412         bytes32 r,
413         bytes32 s
414     ) external;
415 
416     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
417     event Burn(
418         address indexed sender,
419         uint256 amount0,
420         uint256 amount1,
421         address indexed to
422     );
423     event Swap(
424         address indexed sender,
425         uint256 amount0In,
426         uint256 amount1In,
427         uint256 amount0Out,
428         uint256 amount1Out,
429         address indexed to
430     );
431     event Sync(uint112 reserve0, uint112 reserve1);
432 
433     function MINIMUM_LIQUIDITY() external pure returns (uint256);
434 
435     function factory() external view returns (address);
436 
437     function token0() external view returns (address);
438 
439     function token1() external view returns (address);
440 
441     function getReserves()
442         external
443         view
444         returns (
445             uint112 reserve0,
446             uint112 reserve1,
447             uint32 blockTimestampLast
448         );
449 
450     function price0CumulativeLast() external view returns (uint256);
451 
452     function price1CumulativeLast() external view returns (uint256);
453 
454     function kLast() external view returns (uint256);
455 
456     function mint(address to) external returns (uint256 liquidity);
457 
458     function burn(address to)
459         external
460         returns (uint256 amount0, uint256 amount1);
461 
462     function swap(
463         uint256 amount0Out,
464         uint256 amount1Out,
465         address to,
466         bytes calldata data
467     ) external;
468 
469     function skim(address to) external;
470 
471     function sync() external;
472 
473     function initialize(address, address) external;
474 }
475 
476 interface IUniswapV2Router02 {
477     function factory() external pure returns (address);
478 
479     function WETH() external pure returns (address);
480 
481     function addLiquidity(
482         address tokenA,
483         address tokenB,
484         uint256 amountADesired,
485         uint256 amountBDesired,
486         uint256 amountAMin,
487         uint256 amountBMin,
488         address to,
489         uint256 deadline
490     )
491         external
492         returns (
493             uint256 amountA,
494             uint256 amountB,
495             uint256 liquidity
496         );
497 
498     function addLiquidityETH(
499         address token,
500         uint256 amountTokenDesired,
501         uint256 amountTokenMin,
502         uint256 amountETHMin,
503         address to,
504         uint256 deadline
505     )
506         external
507         payable
508         returns (
509             uint256 amountToken,
510             uint256 amountETH,
511             uint256 liquidity
512         );
513 
514     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
515         uint256 amountIn,
516         uint256 amountOutMin,
517         address[] calldata path,
518         address to,
519         uint256 deadline
520     ) external;
521 
522     function swapExactETHForTokensSupportingFeeOnTransferTokens(
523         uint256 amountOutMin,
524         address[] calldata path,
525         address to,
526         uint256 deadline
527     ) external payable;
528 
529     function swapExactTokensForETHSupportingFeeOnTransferTokens(
530         uint256 amountIn,
531         uint256 amountOutMin,
532         address[] calldata path,
533         address to,
534         uint256 deadline
535     ) external;
536 }
537 
538 contract Palpatinu is ERC20, Ownable {
539     using SafeMath for uint256;
540 
541     IUniswapV2Router02 public immutable uniswapV2Router;
542     address public immutable uniswapV2Pair;
543     address public constant deadAddress = address(0xdead);
544 
545     bool private swapping;
546 
547     address public marketingWallet;
548     address public developmentWallet;
549 
550     uint256 public maxTransactionAmount;
551     uint256 public maxWallet;
552     uint256 public swapTokensAtAmount;
553 
554     uint256 public percentForLPBurn = 25;
555     bool public lpBurnEnabled = false;
556     uint256 public lpBurnFrequency = 3600 seconds;
557     uint256 public lastLpBurnTime;
558 
559     uint256 public manualBurnFrequency = 30 minutes;
560     uint256 public lastManualLpBurnTime;
561 
562     bool public limitsInEffect = true;
563     bool public tradingActive = false;
564     bool public swapEnabled = false;
565 
566     mapping(address => uint256) private _buyerLastTransferTimestamp;
567     bool public transferDelayEnabled = true;
568 
569     uint256 public buyMarketingFee;
570     uint256 public buyLiquidityFee;
571     uint256 public buyDevFee;
572     uint256 public buyTotalFees;
573 
574     uint256 public sellMarketingFee;
575     uint256 public sellLiquidityFee;
576     uint256 public sellDevFee;
577     uint256 public sellTotalFees;
578 
579     uint256 public tokensForMarketing;
580     uint256 public tokensForLiquidity;
581     uint256 public tokensForDev;
582 
583     mapping(address => bool) private _isExcludedFromFees;
584     mapping(address => bool) public _isExcludedMaxTransactionAmount;
585 
586     mapping(address => bool) public automatedMarketMakerPairs;
587 
588     event UpdateUniswapV2Router(
589         address indexed newAddress,
590         address indexed oldAddress
591     );
592 
593     event ExcludeFromFees(address indexed account, bool isExcluded);
594 
595     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
596 
597     event marketingWalletUpdated(
598         address indexed newWallet,
599         address indexed oldWallet
600     );
601 
602     event developmentWalletUpdated(
603         address indexed newWallet,
604         address indexed oldWallet
605     );
606 
607     event SwapAndLiquify(
608         uint256 tokensSwapped,
609         uint256 ethReceived,
610         uint256 tokensIntoLiquidity
611     );
612 
613     event AutoNukeLP();
614 
615     event ManualNukeLP();
616 
617     constructor() ERC20("Palpatinu", "SETH") {
618         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
619             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
620         );
621 
622         excludeFromMaxTransaction(address(_uniswapV2Router), true);
623         uniswapV2Router = _uniswapV2Router;
624 
625         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
626             .createPair(address(this), _uniswapV2Router.WETH());
627         excludeFromMaxTransaction(address(uniswapV2Pair), true);
628         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
629 
630         uint256 _buyLiquidityFee = 0;
631         uint256 _buyMarketingFee = 8;
632         uint256 _buyDevFee = 2;
633 
634         uint256 _sellLiquidityFee = 0;
635         uint256 _sellMarketingFee = 16;
636         uint256 _sellDevFee = 4;
637 
638         uint256 totalSupply = 1_000_000_000 * 1e18;
639 
640         maxTransactionAmount = 10_000_000 * 1e18; // 1% from total supply maxTransactionAmountTxn
641         maxWallet = 20_000_000 * 1e18; // 2% from total supply maxWallet
642         swapTokensAtAmount = (totalSupply * 2) / 10000; // 0.02% swap wallet
643 
644         buyMarketingFee = _buyMarketingFee;
645         buyLiquidityFee = _buyLiquidityFee;
646         buyDevFee = _buyDevFee;
647         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
648 
649         sellMarketingFee = _sellMarketingFee;
650         sellLiquidityFee = _sellLiquidityFee;
651         sellDevFee = _sellDevFee;
652         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
653 
654         marketingWallet = address(0xF23eC005AB9f9927802F13599B34E2b63C1b455A);
655         developmentWallet = address(0xA9E9E494317C00e2809dbe7f9e6ac0aAf2aD1E55);
656 
657         excludeFromFees(owner(), true);
658         excludeFromFees(address(this), true);
659         excludeFromFees(address(0xdead), true);
660 
661         excludeFromMaxTransaction(owner(), true);
662         excludeFromMaxTransaction(address(this), true);
663         excludeFromMaxTransaction(address(0xdead), true);
664 
665         _mint(msg.sender, totalSupply);
666     }
667 
668     receive() external payable {}
669 
670     function enableTrading() external onlyOwner {
671         tradingActive = true;
672         swapEnabled = true;
673         lastLpBurnTime = block.timestamp;
674     }
675 
676     function removeLimits() external onlyOwner returns (bool) {
677         limitsInEffect = false;
678         return true;
679     }
680 
681     function disableTransferDelay() external onlyOwner returns (bool) {
682         transferDelayEnabled = false;
683         return true;
684     }
685 
686     function updateSwapTokensAtAmount(uint256 newAmount)
687         external
688         onlyOwner
689         returns (bool)
690     {
691         require(
692             newAmount >= (totalSupply() * 1) / 100000,
693             "Swap amount cannot be lower than 0.001% total supply."
694         );
695         require(
696             newAmount <= (totalSupply() * 5) / 1000,
697             "Swap amount cannot be higher than 0.5% total supply."
698         );
699         swapTokensAtAmount = newAmount;
700         return true;
701     }
702 
703     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
704         require(
705             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
706             "Cannot set maxTransactionAmount lower than 0.1%"
707         );
708         maxTransactionAmount = newNum * (10**18);
709     }
710 
711     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
712         require(
713             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
714             "Cannot set maxWallet lower than 0.5%"
715         );
716         maxWallet = newNum * (10**18);
717     }
718 
719     function excludeFromMaxTransaction(address updAds, bool isEx)
720         public
721         onlyOwner
722     {
723         _isExcludedMaxTransactionAmount[updAds] = isEx;
724     }
725 
726     function updateSwapEnabled(bool enabled) external onlyOwner {
727         swapEnabled = enabled;
728     }
729 
730     function updateBuyFees(
731         uint256 _marketingFee,
732         uint256 _liquidityFee,
733         uint256 _devFee
734     ) external onlyOwner {
735         buyMarketingFee = _marketingFee;
736         buyLiquidityFee = _liquidityFee;
737         buyDevFee = _devFee;
738         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
739         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
740     }
741 
742     function updateSellFees(
743         uint256 _marketingFee,
744         uint256 _liquidityFee,
745         uint256 _devFee
746     ) external onlyOwner {
747         sellMarketingFee = _marketingFee;
748         sellLiquidityFee = _liquidityFee;
749         sellDevFee = _devFee;
750         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
751         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
752     }
753 
754     function excludeFromFees(address account, bool excluded) public onlyOwner {
755         _isExcludedFromFees[account] = excluded;
756         emit ExcludeFromFees(account, excluded);
757     }
758 
759     function setAutomatedMarketMakerPair(address pair, bool value)
760         public
761         onlyOwner
762     {
763         require(
764             pair != uniswapV2Pair,
765             "The pair cannot be removed from the automatedMarketMakerPairs"
766         );
767 
768         _setAutomatedMarketMakerPair(pair, value);
769     }
770 
771     function _setAutomatedMarketMakerPair(address pair, bool value) private {
772         automatedMarketMakerPairs[pair] = value;
773 
774         emit SetAutomatedMarketMakerPair(pair, value);
775     }
776 
777     function updateMarketingWallet(address newMarketingWallet)
778         external
779         onlyOwner
780     {
781         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
782         marketingWallet = newMarketingWallet;
783     }
784 
785     function updateDevelopmentWallet(address newWallet) external onlyOwner {
786         emit developmentWalletUpdated(newWallet, developmentWallet);
787         developmentWallet = newWallet;
788     }
789 
790     function isExcludedFromFees(address account) public view returns (bool) {
791         return _isExcludedFromFees[account];
792     }
793 
794     event BoughtEarly(address indexed sniper);
795 
796     function _transfer(
797         address from,
798         address to,
799         uint256 amount
800     ) internal override {
801         require(from != address(0), "ERC20: transfer from the zero address");
802         require(to != address(0), "ERC20: transfer to the zero address");
803 
804         if (amount == 0) {
805             super._transfer(from, to, 0);
806             return;
807         }
808 
809         if (limitsInEffect) {
810             if (
811                 from != owner() &&
812                 to != owner() &&
813                 to != address(0) &&
814                 to != address(0xdead) &&
815                 !swapping
816             ) {
817                 if (!tradingActive) {
818                     require(
819                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
820                         "Trading is not active."
821                     );
822                 }
823 
824                 if (transferDelayEnabled) {
825                     if (
826                         to != owner() &&
827                         to != address(uniswapV2Router) &&
828                         to != address(uniswapV2Pair)
829                     ) {
830                         require(
831                             _buyerLastTransferTimestamp[tx.origin] <
832                                 block.number,
833                             "_transfer:: Transfer Delay enabled."
834                         );
835                         _buyerLastTransferTimestamp[tx.origin] = block.number;
836                     }
837                 }
838 
839                 // Buy
840                 if (
841                     automatedMarketMakerPairs[from] &&
842                     !_isExcludedMaxTransactionAmount[to]
843                 ) {
844                     require(
845                         amount <= maxTransactionAmount,
846                         "Buy transfer amount exceeds the maxTransactionAmount."
847                     );
848                     require(
849                         amount + balanceOf(to) <= maxWallet,
850                         "Max wallet exceeded"
851                     );
852                 }
853                 // Sell
854                 else if (
855                     automatedMarketMakerPairs[to] &&
856                     !_isExcludedMaxTransactionAmount[from]
857                 ) {
858                     require(
859                         amount <= maxTransactionAmount,
860                         "Sell transfer amount exceeds the maxTransactionAmount."
861                     );
862                 } else if (!_isExcludedMaxTransactionAmount[to]) {
863                     require(
864                         amount + balanceOf(to) <= maxWallet,
865                         "Max wallet exceeded"
866                     );
867                 }
868             }
869         }
870 
871         uint256 contractTokenBalance = balanceOf(address(this));
872 
873         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
874 
875         if (
876             canSwap &&
877             swapEnabled &&
878             !swapping &&
879             !automatedMarketMakerPairs[from] &&
880             !_isExcludedFromFees[from] &&
881             !_isExcludedFromFees[to]
882         ) {
883             swapping = true;
884 
885             swapBack();
886 
887             swapping = false;
888         }
889 
890         if (
891             !swapping &&
892             automatedMarketMakerPairs[to] &&
893             lpBurnEnabled &&
894             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
895             !_isExcludedFromFees[from]
896         ) {
897             autoBurnLiquidityPairTokens();
898         }
899 
900         bool takeFee = !swapping;
901 
902         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
903             takeFee = false;
904         }
905 
906         uint256 fees = 0;
907         if (takeFee) {
908             // Sell
909             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
910                 fees = amount.mul(sellTotalFees).div(100);
911                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
912                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
913                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
914             }
915             // Buy
916             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
917                 fees = amount.mul(buyTotalFees).div(100);
918                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
919                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
920                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
921             }
922 
923             if (fees > 0) {
924                 super._transfer(from, address(this), fees);
925             }
926 
927             amount -= fees;
928         }
929 
930         super._transfer(from, to, amount);
931     }
932 
933     function swapTokensForEth(uint256 tokenAmount) private {
934         address[] memory path = new address[](2);
935         path[0] = address(this);
936         path[1] = uniswapV2Router.WETH();
937 
938         _approve(address(this), address(uniswapV2Router), tokenAmount);
939 
940         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
941             tokenAmount,
942             0,
943             path,
944             address(this),
945             block.timestamp
946         );
947     }
948 
949     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
950         _approve(address(this), address(uniswapV2Router), tokenAmount);
951 
952         uniswapV2Router.addLiquidityETH{value: ethAmount}(
953             address(this),
954             tokenAmount,
955             0,
956             0,
957             deadAddress,
958             block.timestamp
959         );
960     }
961 
962     function swapBack() private {
963         uint256 contractBalance = balanceOf(address(this));
964         uint256 totalTokensToSwap = tokensForLiquidity +
965             tokensForMarketing +
966             tokensForDev;
967         bool success;
968 
969         if (contractBalance == 0 || totalTokensToSwap == 0) {
970             return;
971         }
972 
973         if (contractBalance > swapTokensAtAmount * 20) {
974             contractBalance = swapTokensAtAmount * 20;
975         }
976 
977         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
978             totalTokensToSwap /
979             2;
980         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
981 
982         uint256 initialETHBalance = address(this).balance;
983 
984         swapTokensForEth(amountToSwapForETH);
985 
986         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
987 
988         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
989             totalTokensToSwap
990         );
991         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
992 
993         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
994 
995         tokensForLiquidity = 0;
996         tokensForMarketing = 0;
997         tokensForDev = 0;
998 
999         (success, ) = address(developmentWallet).call{value: ethForDev}("");
1000 
1001         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1002             addLiquidity(liquidityTokens, ethForLiquidity);
1003             emit SwapAndLiquify(
1004                 amountToSwapForETH,
1005                 ethForLiquidity,
1006                 tokensForLiquidity
1007             );
1008         }
1009 
1010         (success, ) = address(marketingWallet).call{
1011             value: address(this).balance
1012         }("");
1013     }
1014 
1015     function setAutoLPBurnSettings(
1016         uint256 _frequencyInSeconds,
1017         uint256 _percent,
1018         bool _Enabled
1019     ) external onlyOwner {
1020         require(
1021             _frequencyInSeconds >= 600,
1022             "Cannot set buyback more often than every 10 minutes."
1023         );
1024         require(
1025             _percent <= 1000 && _percent >= 0,
1026             "Must set auto LP burn percent between 0% and 10%."
1027         );
1028         lpBurnFrequency = _frequencyInSeconds;
1029         percentForLPBurn = _percent;
1030         lpBurnEnabled = _Enabled;
1031     }
1032 
1033     function autoBurnLiquidityPairTokens() internal returns (bool) {
1034         lastLpBurnTime = block.timestamp;
1035 
1036         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1037 
1038         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1039             10000
1040         );
1041 
1042         if (amountToBurn > 0) {
1043             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1044         }
1045 
1046         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1047         pair.sync();
1048         emit AutoNukeLP();
1049         return true;
1050     }
1051 
1052     function manualBurnLiquidityPairTokens(uint256 percent)
1053         external
1054         onlyOwner
1055         returns (bool)
1056     {
1057         require(
1058             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1059             "Must wait for cooldown to finish."
1060         );
1061         require(percent <= 1000, "May not nuke more than 10% of tokens in LP.");
1062         lastManualLpBurnTime = block.timestamp;
1063 
1064         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1065 
1066         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1067 
1068         if (amountToBurn > 0) {
1069             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1070         }
1071 
1072         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1073         pair.sync();
1074         emit ManualNukeLP();
1075         return true;
1076     }
1077 }