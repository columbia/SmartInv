1 // Telegram: https://t.me/thetafinance
2 
3 // Twitter: https://twitter.com/thetafinanceerc
4 
5 // Website: https://thetafinance.co/#app
6 
7 
8 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
9 pragma experimental ABIEncoderV2;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes calldata) {
17         return msg.data;
18     }
19 }
20 
21 abstract contract Ownable is Context {
22     address private _owner;
23 
24     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26     constructor() {
27         _transferOwnership(_msgSender());
28     }
29 
30     function owner() public view virtual returns (address) {
31         return _owner;
32     }
33 
34     modifier onlyOwner() {
35         require(owner() == _msgSender(), "Ownable: caller is not the owner");
36         _;
37     }
38 
39 
40     function renounceOwnership() public virtual onlyOwner {
41         _transferOwnership(address(0));
42     }
43 
44     function transferOwnership(address newOwner) public virtual onlyOwner {
45         require(newOwner != address(0), "Ownable: new owner is the zero address");
46         _transferOwnership(newOwner);
47     }
48 
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
60 
61     function balanceOf(address account) external view returns (uint256);
62 
63 
64     function transfer(address recipient, uint256 amount) external returns (bool);
65 
66 
67     function allowance(address owner, address spender) external view returns (uint256);
68 
69     function approve(address spender, uint256 amount) external returns (bool);
70 
71 
72     function transferFrom(
73         address sender,
74         address recipient,
75         uint256 amount
76     ) external returns (bool);
77 
78 
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 interface IERC20Metadata is IERC20 {
89 
90     function name() external view returns (string memory);
91 
92     function symbol() external view returns (string memory);
93 
94     function decimals() external view returns (uint8);
95 }
96 
97 
98 contract ERC20 is Context, IERC20, IERC20Metadata {
99     mapping(address => uint256) private _balances;
100 
101     mapping(address => mapping(address => uint256)) private _allowances;
102 
103     uint256 private _totalSupply;
104 
105     string private _name;
106     string private _symbol;
107 
108 
109     constructor(string memory name_, string memory symbol_) {
110         _name = name_;
111         _symbol = symbol_;
112     }
113 
114 
115     function name() public view virtual override returns (string memory) {
116         return _name;
117     }
118 
119 
120     function symbol() public view virtual override returns (string memory) {
121         return _symbol;
122     }
123 
124 
125     function decimals() public view virtual override returns (uint8) {
126         return 18;
127     }
128 
129 
130     function totalSupply() public view virtual override returns (uint256) {
131         return _totalSupply;
132     }
133 
134     function balanceOf(address account) public view virtual override returns (uint256) {
135         return _balances[account];
136     }
137 
138     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
139         _transfer(_msgSender(), recipient, amount);
140         return true;
141     }
142 
143 
144     function allowance(address owner, address spender) public view virtual override returns (uint256) {
145         return _allowances[owner][spender];
146     }
147 
148     function approve(address spender, uint256 amount) public virtual override returns (bool) {
149         _approve(_msgSender(), spender, amount);
150         return true;
151     }
152 
153     function transferFrom(
154         address sender,
155         address recipient,
156         uint256 amount
157     ) public virtual override returns (bool) {
158         _transfer(sender, recipient, amount);
159 
160         uint256 currentAllowance = _allowances[sender][_msgSender()];
161         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
162         unchecked {
163             _approve(sender, _msgSender(), currentAllowance - amount);
164         }
165 
166         return true;
167     }
168 
169     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
170         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
171         return true;
172     }
173 
174     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
175         uint256 currentAllowance = _allowances[_msgSender()][spender];
176         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
177         unchecked {
178             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
179         }
180 
181         return true;
182     }
183 
184     function _transfer(
185         address sender,
186         address recipient,
187         uint256 amount
188     ) internal virtual {
189         require(sender != address(0), "ERC20: transfer from the zero address");
190         require(recipient != address(0), "ERC20: transfer to the zero address");
191 
192         _beforeTokenTransfer(sender, recipient, amount);
193 
194         uint256 senderBalance = _balances[sender];
195         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
196         unchecked {
197             _balances[sender] = senderBalance - amount;
198         }
199         _balances[recipient] += amount;
200 
201         emit Transfer(sender, recipient, amount);
202 
203         _afterTokenTransfer(sender, recipient, amount);
204     }
205 
206     function _mint(address account, uint256 amount) internal virtual {
207         require(account != address(0), "ERC20: mint to the zero address");
208 
209         _beforeTokenTransfer(address(0), account, amount);
210 
211         _totalSupply += amount;
212         _balances[account] += amount;
213         emit Transfer(address(0), account, amount);
214 
215         _afterTokenTransfer(address(0), account, amount);
216     }
217 
218     function _burn(address account, uint256 amount) internal virtual {
219         require(account != address(0), "ERC20: burn from the zero address");
220 
221         _beforeTokenTransfer(account, address(0), amount);
222 
223         uint256 accountBalance = _balances[account];
224         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
225         unchecked {
226             _balances[account] = accountBalance - amount;
227         }
228         _totalSupply -= amount;
229 
230         emit Transfer(account, address(0), amount);
231 
232         _afterTokenTransfer(account, address(0), amount);
233     }
234 
235     function _approve(
236         address owner,
237         address spender,
238         uint256 amount
239     ) internal virtual {
240         require(owner != address(0), "ERC20: approve from the zero address");
241         require(spender != address(0), "ERC20: approve to the zero address");
242 
243         _allowances[owner][spender] = amount;
244         emit Approval(owner, spender, amount);
245     }
246 
247     function _beforeTokenTransfer(
248         address from,
249         address to,
250         uint256 amount
251     ) internal virtual {}
252 
253     function _afterTokenTransfer(
254         address from,
255         address to,
256         uint256 amount
257     ) internal virtual {}
258 }
259 
260 
261 library SafeMath {
262 
263     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
264         unchecked {
265             uint256 c = a + b;
266             if (c < a) return (false, 0);
267             return (true, c);
268         }
269     }
270 
271     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
272         unchecked {
273             if (b > a) return (false, 0);
274             return (true, a - b);
275         }
276     }
277 
278 
279     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
280         unchecked {
281             if (a == 0) return (true, 0);
282             uint256 c = a * b;
283             if (c / a != b) return (false, 0);
284             return (true, c);
285         }
286     }
287 
288     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
289         unchecked {
290             if (b == 0) return (false, 0);
291             return (true, a / b);
292         }
293     }
294 
295     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
296         unchecked {
297             if (b == 0) return (false, 0);
298             return (true, a % b);
299         }
300     }
301 
302 
303     function add(uint256 a, uint256 b) internal pure returns (uint256) {
304         return a + b;
305     }
306 
307     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
308         return a - b;
309     }
310 
311     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
312         return a * b;
313     }
314 
315     function div(uint256 a, uint256 b) internal pure returns (uint256) {
316         return a / b;
317     }
318 
319     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
320         return a % b;
321     }
322 
323     function sub(
324         uint256 a,
325         uint256 b,
326         string memory errorMessage
327     ) internal pure returns (uint256) {
328         unchecked {
329             require(b <= a, errorMessage);
330             return a - b;
331         }
332     }
333 
334     function div(
335         uint256 a,
336         uint256 b,
337         string memory errorMessage
338     ) internal pure returns (uint256) {
339         unchecked {
340             require(b > 0, errorMessage);
341             return a / b;
342         }
343     }
344 
345 
346     function mod(
347         uint256 a,
348         uint256 b,
349         string memory errorMessage
350     ) internal pure returns (uint256) {
351         unchecked {
352             require(b > 0, errorMessage);
353             return a % b;
354         }
355     }
356 }
357 
358 
359 interface IUniswapV2Factory {
360     event PairCreated(
361         address indexed token0,
362         address indexed token1,
363         address pair,
364         uint256
365     );
366 
367     function feeTo() external view returns (address);
368 
369     function feeToSetter() external view returns (address);
370 
371     function getPair(address tokenA, address tokenB)
372         external
373         view
374         returns (address pair);
375 
376     function allPairs(uint256) external view returns (address pair);
377 
378     function allPairsLength() external view returns (uint256);
379 
380     function createPair(address tokenA, address tokenB)
381         external
382         returns (address pair);
383 
384     function setFeeTo(address) external;
385 
386     function setFeeToSetter(address) external;
387 }
388 
389 
390 interface IUniswapV2Pair {
391     event Approval(
392         address indexed owner,
393         address indexed spender,
394         uint256 value
395     );
396     event Transfer(address indexed from, address indexed to, uint256 value);
397 
398     function name() external pure returns (string memory);
399 
400     function symbol() external pure returns (string memory);
401 
402     function decimals() external pure returns (uint8);
403 
404     function totalSupply() external view returns (uint256);
405 
406     function balanceOf(address owner) external view returns (uint256);
407 
408     function allowance(address owner, address spender)
409         external
410         view
411         returns (uint256);
412 
413     function approve(address spender, uint256 value) external returns (bool);
414 
415     function transfer(address to, uint256 value) external returns (bool);
416 
417     function transferFrom(
418         address from,
419         address to,
420         uint256 value
421     ) external returns (bool);
422 
423     function DOMAIN_SEPARATOR() external view returns (bytes32);
424 
425     function PERMIT_TYPEHASH() external pure returns (bytes32);
426 
427     function nonces(address owner) external view returns (uint256);
428 
429     function permit(
430         address owner,
431         address spender,
432         uint256 value,
433         uint256 deadline,
434         uint8 v,
435         bytes32 r,
436         bytes32 s
437     ) external;
438 
439     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
440     event Burn(
441         address indexed sender,
442         uint256 amount0,
443         uint256 amount1,
444         address indexed to
445     );
446     event Swap(
447         address indexed sender,
448         uint256 amount0In,
449         uint256 amount1In,
450         uint256 amount0Out,
451         uint256 amount1Out,
452         address indexed to
453     );
454     event Sync(uint112 reserve0, uint112 reserve1);
455 
456     function MINIMUM_LIQUIDITY() external pure returns (uint256);
457 
458     function factory() external view returns (address);
459 
460     function token0() external view returns (address);
461 
462     function token1() external view returns (address);
463 
464     function getReserves()
465         external
466         view
467         returns (
468             uint112 reserve0,
469             uint112 reserve1,
470             uint32 blockTimestampLast
471         );
472 
473     function price0CumulativeLast() external view returns (uint256);
474 
475     function price1CumulativeLast() external view returns (uint256);
476 
477     function kLast() external view returns (uint256);
478 
479     function mint(address to) external returns (uint256 liquidity);
480 
481     function burn(address to)
482         external
483         returns (uint256 amount0, uint256 amount1);
484 
485     function swap(
486         uint256 amount0Out,
487         uint256 amount1Out,
488         address to,
489         bytes calldata data
490     ) external;
491 
492     function skim(address to) external;
493 
494     function sync() external;
495 
496     function initialize(address, address) external;
497 }
498 
499 
500 interface IUniswapV2Router02 {
501     function factory() external pure returns (address);
502 
503     function WETH() external pure returns (address);
504 
505     function addLiquidity(
506         address tokenA,
507         address tokenB,
508         uint256 amountADesired,
509         uint256 amountBDesired,
510         uint256 amountAMin,
511         uint256 amountBMin,
512         address to,
513         uint256 deadline
514     )
515         external
516         returns (
517             uint256 amountA,
518             uint256 amountB,
519             uint256 liquidity
520         );
521 
522     function addLiquidityETH(
523         address token,
524         uint256 amountTokenDesired,
525         uint256 amountTokenMin,
526         uint256 amountETHMin,
527         address to,
528         uint256 deadline
529     )
530         external
531         payable
532         returns (
533             uint256 amountToken,
534             uint256 amountETH,
535             uint256 liquidity
536         );
537 
538     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
539         uint256 amountIn,
540         uint256 amountOutMin,
541         address[] calldata path,
542         address to,
543         uint256 deadline
544     ) external;
545 
546     function swapExactETHForTokensSupportingFeeOnTransferTokens(
547         uint256 amountOutMin,
548         address[] calldata path,
549         address to,
550         uint256 deadline
551     ) external payable;
552 
553     function swapExactTokensForETHSupportingFeeOnTransferTokens(
554         uint256 amountIn,
555         uint256 amountOutMin,
556         address[] calldata path,
557         address to,
558         uint256 deadline
559     ) external;
560 }
561 
562 
563 contract ThetaFinance is ERC20, Ownable {
564     using SafeMath for uint256;
565 
566     IUniswapV2Router02 public immutable uniswapV2Router;
567     address public immutable uniswapV2Pair;
568     address public constant deadAddress = address(0xdead);
569 
570     bool private swapping;
571 
572     address public marketingWallet;
573     address public devWallet;
574 
575     uint256 public maxTransactionAmount;
576     uint256 public swapTokensAtAmount;
577     uint256 public maxWallet;
578 
579     uint256 public percentForLPBurn = 0; 
580     bool public lpBurnEnabled = false;
581     uint256 public lpBurnFrequency = 3600 seconds;
582     uint256 public lastLpBurnTime;
583 
584     uint256 public manualBurnFrequency = 30 minutes;
585     uint256 public lastManualLpBurnTime;
586 
587     bool public limitsInEffect = true;
588     bool public tradingActive = false;
589     bool public swapEnabled = true;
590 
591     mapping(address => uint256) private _holderLastTransferTimestamp; 
592     bool public transferDelayEnabled = true;
593 
594     uint256 public buyTotalFees;
595     uint256 public buyMarketingFee;
596     uint256 public buyLiquidityFee;
597     uint256 public buyDevFee;
598 
599     uint256 public sellTotalFees;
600     uint256 public sellMarketingFee;
601     uint256 public sellLiquidityFee;
602     uint256 public sellDevFee;
603 
604     uint256 public tokensForMarketing;
605     uint256 public tokensForLiquidity;
606     uint256 public tokensForDev;
607 
608     mapping(address => bool) private _isExcludedFromFees;
609     mapping(address => bool) public _isExcludedMaxTransactionAmount;
610 
611     mapping(address => bool) public automatedMarketMakerPairs;
612 
613     event UpdateUniswapV2Router(
614         address indexed newAddress,
615         address indexed oldAddress
616     );
617 
618     event ExcludeFromFees(address indexed account, bool isExcluded);
619 
620     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
621 
622     event marketingWalletUpdated(
623         address indexed newWallet,
624         address indexed oldWallet
625     );
626 
627     event devWalletUpdated(
628         address indexed newWallet,
629         address indexed oldWallet
630     );
631 
632     event SwapAndLiquify(
633         uint256 tokensSwapped,
634         uint256 ethReceived,
635         uint256 tokensIntoLiquidity
636     );
637 
638     event AutoNukeLP();
639 
640     event ManualNukeLP();
641 
642     constructor() ERC20("Theta Finance", "TEF") {
643         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
644             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
645         );
646 
647         excludeFromMaxTransaction(address(_uniswapV2Router), true);
648         uniswapV2Router = _uniswapV2Router;
649 
650         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
651             .createPair(address(this), _uniswapV2Router.WETH());
652         excludeFromMaxTransaction(address(uniswapV2Pair), true);
653         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
654 
655         uint256 _buyMarketingFee = 45;
656         uint256 _buyLiquidityFee = 0;
657         uint256 _buyDevFee = 5;
658 
659         uint256 _sellMarketingFee = 45;
660         uint256 _sellLiquidityFee = 0;
661         uint256 _sellDevFee = 5;
662 
663         uint256 totalSupply = 1_000_000_000 * 1e18;
664 
665         maxTransactionAmount = 15_000_000 * 1e18; 
666         maxWallet = 20_000_000 * 1e18; 
667         swapTokensAtAmount = (totalSupply * 5) / 10000;
668 
669         buyMarketingFee = _buyMarketingFee;
670         buyLiquidityFee = _buyLiquidityFee;
671         buyDevFee = _buyDevFee;
672         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
673 
674         sellMarketingFee = _sellMarketingFee;
675         sellLiquidityFee = _sellLiquidityFee;
676         sellDevFee = _sellDevFee;
677         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
678 
679         marketingWallet = address(0x88D0ae07e4964E2197b1030f64BB5a5435CE4De1); 
680         devWallet = address(0x4DF075849972eBEEafFa7E3CA8952954ec1b7679); 
681 
682         // exclude from paying fees or having max transaction amount
683         excludeFromFees(owner(), true);
684         excludeFromFees(address(this), true);
685         excludeFromFees(address(0xdead), true);
686 
687         excludeFromMaxTransaction(owner(), true);
688         excludeFromMaxTransaction(address(this), true);
689         excludeFromMaxTransaction(address(0xdead), true);
690 
691         _mint(msg.sender, totalSupply);
692     }
693 
694     receive() external payable {}
695 
696     function enableTrading() external onlyOwner {
697         tradingActive = true;
698         swapEnabled = true;
699         lastLpBurnTime = block.timestamp;
700     }
701 
702     function removeLimits() external onlyOwner returns (bool) {
703         limitsInEffect = false;
704         return true;
705     }
706 
707     function disableTransferDelay() external onlyOwner returns (bool) {
708         transferDelayEnabled = false;
709         return true;
710     }
711 
712     function updateSwapTokensAtAmount(uint256 newAmount)
713         external
714         onlyOwner
715         returns (bool)
716     {
717         require(
718             newAmount >= (totalSupply() * 1) / 100000,
719             "Swap amount cannot be lower than 0.001% total supply."
720         );
721         require(
722             newAmount <= (totalSupply() * 5) / 1000,
723             "Swap amount cannot be higher than 0.5% total supply."
724         );
725         swapTokensAtAmount = newAmount;
726         return true;
727     }
728 
729     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
730         require(
731             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
732             "Cannot set maxTransactionAmount lower than 0.1%"
733         );
734         maxTransactionAmount = newNum * (10**18);
735     }
736 
737     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
738         require(
739             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
740             "Cannot set maxWallet lower than 0.5%"
741         );
742         maxWallet = newNum * (10**18);
743     }
744 
745     function excludeFromMaxTransaction(address updAds, bool isEx)
746         public
747         onlyOwner
748     {
749         _isExcludedMaxTransactionAmount[updAds] = isEx;
750     }
751 
752     function updateSwapEnabled(bool enabled) external onlyOwner {
753         swapEnabled = enabled;
754     }
755 
756     function updateBuyFees(
757         uint256 _marketingFee,
758         uint256 _liquidityFee,
759         uint256 _devFee
760     ) external onlyOwner {
761         buyMarketingFee = _marketingFee;
762         buyLiquidityFee = _liquidityFee;
763         buyDevFee = _devFee;
764         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
765         require(buyTotalFees <= 60, "Must keep fees at 60% or less");
766     }
767 
768     function updateSellFees(
769         uint256 _marketingFee,
770         uint256 _liquidityFee,
771         uint256 _devFee
772     ) external onlyOwner {
773         sellMarketingFee = _marketingFee;
774         sellLiquidityFee = _liquidityFee;
775         sellDevFee = _devFee;
776         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
777         require(sellTotalFees <= 60, "Must keep fees at 60% or less");
778     }
779 
780     function excludeFromFees(address account, bool excluded) public onlyOwner {
781         _isExcludedFromFees[account] = excluded;
782         emit ExcludeFromFees(account, excluded);
783     }
784 
785     function setAutomatedMarketMakerPair(address pair, bool value)
786         public
787         onlyOwner
788     {
789         require(
790             pair != uniswapV2Pair,
791             "The pair cannot be removed from automatedMarketMakerPairs"
792         );
793 
794         _setAutomatedMarketMakerPair(pair, value);
795     }
796 
797     function _setAutomatedMarketMakerPair(address pair, bool value) private {
798         automatedMarketMakerPairs[pair] = value;
799 
800         emit SetAutomatedMarketMakerPair(pair, value);
801     }
802 
803     function updateMarketingWallet(address newMarketingWallet)
804         external
805         onlyOwner
806     {
807         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
808         marketingWallet = newMarketingWallet;
809     }
810 
811     function updateDevWallet(address newWallet) external onlyOwner {
812         emit devWalletUpdated(newWallet, devWallet);
813         devWallet = newWallet;
814     }
815 
816     function isExcludedFromFees(address account) public view returns (bool) {
817         return _isExcludedFromFees[account];
818     }
819 
820     event BoughtEarly(address indexed sniper);
821 
822     function _transfer(
823         address from,
824         address to,
825         uint256 amount
826     ) internal override {
827         require(from != address(0), "ERC20: transfer from the zero address");
828         require(to != address(0), "ERC20: transfer to the zero address");
829 
830         if (amount == 0) {
831             super._transfer(from, to, 0);
832             return;
833         }
834 
835         if (limitsInEffect) {
836             if (
837                 from != owner() &&
838                 to != owner() &&
839                 to != address(0) &&
840                 to != address(0xdead) &&
841                 !swapping
842             ) {
843                 if (!tradingActive) {
844                     require(
845                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
846                         "Trading is not active."
847                     );
848                 }
849 
850                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
851                 if (transferDelayEnabled) {
852                     if (
853                         to != owner() &&
854                         to != address(uniswapV2Router) &&
855                         to != address(uniswapV2Pair)
856                     ) {
857                         require(
858                             _holderLastTransferTimestamp[tx.origin] <
859                                 block.number,
860                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
861                         );
862                         _holderLastTransferTimestamp[tx.origin] = block.number;
863                     }
864                 }
865 
866                 //when buy
867                 if (
868                     automatedMarketMakerPairs[from] &&
869                     !_isExcludedMaxTransactionAmount[to]
870                 ) {
871                     require(
872                         amount <= maxTransactionAmount,
873                         "Buy transfer amount exceeds the maxTransactionAmount."
874                     );
875                     require(
876                         amount + balanceOf(to) <= maxWallet,
877                         "Max wallet exceeded"
878                     );
879                 }
880                 //when sell
881                 else if (
882                     automatedMarketMakerPairs[to] &&
883                     !_isExcludedMaxTransactionAmount[from]
884                 ) {
885                     require(
886                         amount <= maxTransactionAmount,
887                         "Sell transfer amount exceeds the maxTransactionAmount."
888                     );
889                 } else if (!_isExcludedMaxTransactionAmount[to]) {
890                     require(
891                         amount + balanceOf(to) <= maxWallet,
892                         "Max wallet exceeded"
893                     );
894                 }
895             }
896         }
897 
898         uint256 contractTokenBalance = balanceOf(address(this));
899 
900         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
901 
902         if (
903             canSwap &&
904             swapEnabled &&
905             !swapping &&
906             !automatedMarketMakerPairs[from] &&
907             !_isExcludedFromFees[from] &&
908             !_isExcludedFromFees[to]
909         ) {
910             swapping = true;
911 
912             swapBack();
913 
914             swapping = false;
915         }
916 
917         if (
918             !swapping &&
919             automatedMarketMakerPairs[to] &&
920             lpBurnEnabled &&
921             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
922             !_isExcludedFromFees[from]
923         ) {
924             autoBurnLiquidityPairTokens();
925         }
926 
927         bool takeFee = !swapping;
928 
929         // if any account belongs to _isExcludedFromFee account then remove the fee
930         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
931             takeFee = false;
932         }
933 
934         uint256 fees = 0;
935         // only take fees on buys/sells, do not take on wallet transfers
936         if (takeFee) {
937             // on sell
938             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
939                 fees = amount.mul(sellTotalFees).div(100);
940                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
941                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
942                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
943             }
944             // on buy
945             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
946                 fees = amount.mul(buyTotalFees).div(100);
947                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
948                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
949                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
950             }
951 
952             if (fees > 0) {
953                 super._transfer(from, address(this), fees);
954             }
955 
956             amount -= fees;
957         }
958 
959         super._transfer(from, to, amount);
960     }
961 
962     function swapTokensForEth(uint256 tokenAmount) private {
963         // generate the uniswap pair path of token -> weth
964         address[] memory path = new address[](2);
965         path[0] = address(this);
966         path[1] = uniswapV2Router.WETH();
967 
968         _approve(address(this), address(uniswapV2Router), tokenAmount);
969 
970         // make the swap
971         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
972             tokenAmount,
973             0, // accept any amount of ETH
974             path,
975             address(this),
976             block.timestamp
977         );
978     }
979 
980     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
981         // approve token transfer to cover all possible scenarios
982         _approve(address(this), address(uniswapV2Router), tokenAmount);
983 
984         // add the liquidity
985         uniswapV2Router.addLiquidityETH{value: ethAmount}(
986             address(this),
987             tokenAmount,
988             0, // slippage is unavoidable
989             0, // slippage is unavoidable
990             deadAddress,
991             block.timestamp
992         );
993     }
994 
995     function swapBack() private {
996         uint256 contractBalance = balanceOf(address(this));
997         uint256 totalTokensToSwap = tokensForLiquidity +
998             tokensForMarketing +
999             tokensForDev;
1000         bool success;
1001 
1002         if (contractBalance == 0 || totalTokensToSwap == 0) {
1003             return;
1004         }
1005 
1006         if (contractBalance > swapTokensAtAmount * 20) {
1007             contractBalance = swapTokensAtAmount * 20;
1008         }
1009 
1010         // Halve the amount of liquidity tokens
1011         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1012             totalTokensToSwap /
1013             2;
1014         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1015 
1016         uint256 initialETHBalance = address(this).balance;
1017 
1018         swapTokensForEth(amountToSwapForETH);
1019 
1020         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1021 
1022         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1023             totalTokensToSwap
1024         );
1025         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1026 
1027         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1028 
1029         tokensForLiquidity = 0;
1030         tokensForMarketing = 0;
1031         tokensForDev = 0;
1032 
1033         (success, ) = address(devWallet).call{value: ethForDev}("");
1034 
1035         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1036             addLiquidity(liquidityTokens, ethForLiquidity);
1037             emit SwapAndLiquify(
1038                 amountToSwapForETH,
1039                 ethForLiquidity,
1040                 tokensForLiquidity
1041             );
1042         }
1043 
1044         (success, ) = address(marketingWallet).call{
1045             value: address(this).balance
1046         }("");
1047     }
1048 
1049     function setAutoLPBurnSettings(
1050         uint256 _frequencyInSeconds,
1051         uint256 _percent,
1052         bool _Enabled
1053     ) external onlyOwner {
1054         require(
1055             _frequencyInSeconds >= 600,
1056             "cannot set buyback more often than every 10 minutes"
1057         );
1058         require(
1059             _percent <= 1000 && _percent >= 0,
1060             "Must set auto LP burn percent between 0% and 10%"
1061         );
1062         lpBurnFrequency = _frequencyInSeconds;
1063         percentForLPBurn = _percent;
1064         lpBurnEnabled = _Enabled;
1065     }
1066 
1067     function autoBurnLiquidityPairTokens() internal returns (bool) {
1068         lastLpBurnTime = block.timestamp;
1069 
1070         // get balance of liquidity pair
1071         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1072 
1073         // calculate amount to burn
1074         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1075             10000
1076         );
1077 
1078         // pull tokens from pancakePair liquidity and move to dead address permanently
1079         if (amountToBurn > 0) {
1080             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1081         }
1082 
1083         //sync price since this is not in a swap transaction!
1084         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1085         pair.sync();
1086         emit AutoNukeLP();
1087         return true;
1088     }
1089 
1090     function manualBurnLiquidityPairTokens(uint256 percent)
1091         external
1092         onlyOwner
1093         returns (bool)
1094     {
1095         require(
1096             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1097             "Must wait for cooldown to finish"
1098         );
1099         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1100         lastManualLpBurnTime = block.timestamp;
1101 
1102         // get balance of liquidity pair
1103         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1104 
1105         // calculate amount to burn
1106         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1107 
1108         // pull tokens from pancakePair liquidity and move to dead address permanently
1109         if (amountToBurn > 0) {
1110             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1111         }
1112 
1113         //sync price since this is not in a swap transaction!
1114         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1115         pair.sync();
1116         emit ManualNukeLP();
1117         return true;
1118     }
1119 }