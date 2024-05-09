1 /**
2  Telegram: https://t.me/Sentient0xgame
3  Twitter:  https://twitter.com/SentientZone
4  Website: https://sentientofficial.io
5  Whitepaper: https://sentientwhitepaper.tiiny.site
6  Medium: https://medium.com/@sentientofficial
7 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
8 */
9 
10 //  SPDX-License-Identifier: MIT
11 pragma solidity >=0.8.19;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18 }
19 
20 abstract contract Ownable is Context {
21     address private _owner;
22 
23     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24 
25     constructor() {
26         _transferOwnership(_msgSender());
27     }
28 
29     function owner() public view virtual returns (address) {
30         return _owner;
31     }
32 
33     modifier onlyOwner() {
34         require(owner() == _msgSender(), "Ownable: caller is not the owner");
35         _;
36     }
37 
38     function renounceOwnership() public virtual onlyOwner {
39         _transferOwnership(address(0));
40     }
41 
42     function transferOwnership(address newOwner) public virtual onlyOwner {
43         require(newOwner != address(0), "Ownable: new owner is the zero address");
44         _transferOwnership(newOwner);
45     }
46 
47     function _transferOwnership(address newOwner) internal virtual {
48         address oldOwner = _owner;
49         _owner = newOwner;
50         emit OwnershipTransferred(oldOwner, newOwner);
51     }
52 }
53 
54 interface IERC20 {
55 
56     function totalSupply() external view returns (uint256);
57 
58     function balanceOf(address account) external view returns (uint256);
59 
60     function transfer(address recipient, uint256 amount) external returns (bool);
61 
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     function transferFrom(
67         address sender,
68         address recipient,
69         uint256 amount
70     ) external returns (bool);
71 
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 interface IERC20Metadata is IERC20 {
78 
79     function name() external view returns (string memory);
80 
81     function symbol() external view returns (string memory);
82 
83     function decimals() external view returns (uint8);
84 }
85 
86 contract ERC20 is Context, IERC20, IERC20Metadata {
87     mapping(address => uint256) private _balances;
88 
89     mapping(address => mapping(address => uint256)) private _allowances;
90 
91     uint256 private _totalSupply;
92 
93     string private _name;
94     string private _symbol;
95 
96     constructor(string memory name_, string memory symbol_) {
97         _name = name_;
98         _symbol = symbol_;
99     }
100 
101     function name() public view virtual override returns (string memory) {
102         return _name;
103     }
104 
105     function symbol() public view virtual override returns (string memory) {
106         return _symbol;
107     }
108 
109     function decimals() public view virtual override returns (uint8) {
110         return 18;
111     }
112 
113     function totalSupply() public view virtual override returns (uint256) {
114         return _totalSupply;
115     }
116 
117     function balanceOf(address account) public view virtual override returns (uint256) {
118         return _balances[account];
119     }
120 
121     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
122         _transfer(_msgSender(), recipient, amount);
123         return true;
124     }
125 
126     function allowance(address owner, address spender) public view virtual override returns (uint256) {
127         return _allowances[owner][spender];
128     }
129 
130     function approve(address spender, uint256 amount) public virtual override returns (bool) {
131         _approve(_msgSender(), spender, amount);
132         return true;
133     }
134 
135     function transferFrom(
136         address sender,
137         address recipient,
138         uint256 amount
139     ) public virtual override returns (bool) {
140         _transfer(sender, recipient, amount);
141 
142         uint256 currentAllowance = _allowances[sender][_msgSender()];
143         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
144         unchecked {
145             _approve(sender, _msgSender(), currentAllowance - amount);
146         }
147 
148         return true;
149     }
150 
151     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
152         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
153         return true;
154     }
155 
156     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
157         uint256 currentAllowance = _allowances[_msgSender()][spender];
158         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
159         unchecked {
160             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
161         }
162 
163         return true;
164     }
165 
166     function _transfer(
167         address sender,
168         address recipient,
169         uint256 amount
170     ) internal virtual {
171         require(sender != address(0), "ERC20: transfer from the zero address");
172         require(recipient != address(0), "ERC20: transfer to the zero address");
173 
174         _beforeTokenTransfer(sender, recipient, amount);
175 
176         uint256 senderBalance = _balances[sender];
177         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
178         unchecked {
179             _balances[sender] = senderBalance - amount;
180         }
181         _balances[recipient] += amount;
182 
183         emit Transfer(sender, recipient, amount);
184 
185         _afterTokenTransfer(sender, recipient, amount);
186     }
187 
188     function _mint(address account, uint256 amount) internal virtual {
189         require(account != address(0), "ERC20: mint to the zero address");
190 
191         _beforeTokenTransfer(address(0), account, amount);
192 
193         _totalSupply += amount;
194         _balances[account] += amount;
195         emit Transfer(address(0), account, amount);
196 
197         _afterTokenTransfer(address(0), account, amount);
198     }
199 
200     function _approve(
201         address owner,
202         address spender,
203         uint256 amount
204     ) internal virtual {
205         require(owner != address(0), "ERC20: approve from the zero address");
206         require(spender != address(0), "ERC20: approve to the zero address");
207 
208         _allowances[owner][spender] = amount;
209         emit Approval(owner, spender, amount);
210     }
211 
212     function _beforeTokenTransfer(
213         address from,
214         address to,
215         uint256 amount
216     ) internal virtual {}
217 
218     function _afterTokenTransfer(
219         address from,
220         address to,
221         uint256 amount
222     ) internal virtual {}
223 }
224 
225 library SafeMath {
226 
227     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
228         return a - b;
229     }
230 
231     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
232         return a * b;
233     }
234 
235     function div(uint256 a, uint256 b) internal pure returns (uint256) {
236         return a / b;
237     }
238 } 
239 
240 interface IUniswapV2Factory {
241     event PairCreated(
242         address indexed token0,
243         address indexed token1,
244         address pair,
245         uint256
246     );
247 
248     function feeTo() external view returns (address);
249 
250     function feeToSetter() external view returns (address);
251 
252     function getPair(address tokenA, address tokenB)
253         external
254         view
255         returns (address pair);
256 
257     function allPairs(uint256) external view returns (address pair);
258 
259     function allPairsLength() external view returns (uint256);
260 
261     function createPair(address tokenA, address tokenB)
262         external
263         returns (address pair);
264 
265     function setFeeTo(address) external;
266 
267     function setFeeToSetter(address) external;
268 }
269 
270 interface IUniswapV2Pair {
271     event Approval(
272         address indexed owner,
273         address indexed spender,
274         uint256 value
275     );
276     event Transfer(address indexed from, address indexed to, uint256 value);
277 
278     function name() external pure returns (string memory);
279 
280     function symbol() external pure returns (string memory);
281 
282     function decimals() external pure returns (uint8);
283 
284     function totalSupply() external view returns (uint256);
285 
286     function balanceOf(address owner) external view returns (uint256);
287 
288     function allowance(address owner, address spender)
289         external
290         view
291         returns (uint256);
292 
293     function approve(address spender, uint256 value) external returns (bool);
294 
295     function transfer(address to, uint256 value) external returns (bool);
296 
297     function transferFrom(
298         address from,
299         address to,
300         uint256 value
301     ) external returns (bool);
302 
303     function DOMAIN_SEPARATOR() external view returns (bytes32);
304 
305     function PERMIT_TYPEHASH() external pure returns (bytes32);
306 
307     function nonces(address owner) external view returns (uint256);
308 
309     function permit(
310         address owner,
311         address spender,
312         uint256 value,
313         uint256 deadline,
314         uint8 v,
315         bytes32 r,
316         bytes32 s
317     ) external;
318 
319     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
320     event Burn(
321         address indexed sender,
322         uint256 amount0,
323         uint256 amount1,
324         address indexed to
325     );
326     event Swap(
327         address indexed sender,
328         uint256 amount0In,
329         uint256 amount1In,
330         uint256 amount0Out,
331         uint256 amount1Out,
332         address indexed to
333     );
334     event Sync(uint112 reserve0, uint112 reserve1);
335 
336     function MINIMUM_LIQUIDITY() external pure returns (uint256);
337 
338     function factory() external view returns (address);
339 
340     function token0() external view returns (address);
341 
342     function token1() external view returns (address);
343 
344     function getReserves()
345         external
346         view
347         returns (
348             uint112 reserve0,
349             uint112 reserve1,
350             uint32 blockTimestampLast
351         );
352 
353     function price0CumulativeLast() external view returns (uint256);
354 
355     function price1CumulativeLast() external view returns (uint256);
356 
357     function kLast() external view returns (uint256);
358 
359     function mint(address to) external returns (uint256 liquidity);
360 
361     function burn(address to)
362         external
363         returns (uint256 amount0, uint256 amount1);
364 
365     function swap(
366         uint256 amount0Out,
367         uint256 amount1Out,
368         address to,
369         bytes calldata data
370     ) external;
371 
372     function skim(address to) external;
373 
374     function sync() external;
375 
376     function initialize(address, address) external;
377 }
378 
379 interface IUniswapV2Router02 {
380     function factory() external pure returns (address);
381 
382     function WETH() external pure returns (address);
383 
384     function addLiquidity(
385         address tokenA,
386         address tokenB,
387         uint256 amountADesired,
388         uint256 amountBDesired,
389         uint256 amountAMin,
390         uint256 amountBMin,
391         address to,
392         uint256 deadline
393     )
394         external
395         returns (
396             uint256 amountA,
397             uint256 amountB,
398             uint256 liquidity
399         );
400 
401     function addLiquidityETH(
402         address token,
403         uint256 amountTokenDesired,
404         uint256 amountTokenMin,
405         uint256 amountETHMin,
406         address to,
407         uint256 deadline
408     )
409         external
410         payable
411         returns (
412             uint256 amountToken,
413             uint256 amountETH,
414             uint256 liquidity
415         );
416 
417     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
418         uint256 amountIn,
419         uint256 amountOutMin,
420         address[] calldata path,
421         address to,
422         uint256 deadline
423     ) external;
424 
425     function swapExactETHForTokensSupportingFeeOnTransferTokens(
426         uint256 amountOutMin,
427         address[] calldata path,
428         address to,
429         uint256 deadline
430     ) external payable;
431 
432     function swapExactTokensForETHSupportingFeeOnTransferTokens(
433         uint256 amountIn,
434         uint256 amountOutMin,
435         address[] calldata path,
436         address to,
437         uint256 deadline
438     ) external;
439 }
440 
441 contract Sentient is ERC20, Ownable {
442     using SafeMath for uint256;
443 
444     IUniswapV2Router02 public immutable uniswapV2Router;
445     address public immutable uniswapV2Pair;
446     address public constant deadAddress = address(0xdead);
447 
448     bool private swapping;
449 
450     address public marketingWallet;
451     address public devWallet;
452     address public lpWallet;
453 
454     uint256 public maxTransactionAmount;
455     uint256 public swapTokensAtAmount;
456     uint256 public maxWallet;
457 
458     bool public limitsInEffect = true;
459     bool public tradingActive = true;
460     bool public swapEnabled = true;
461 
462     uint256 public buyTotalFees;
463     uint256 public buyMarketingFee;
464     uint256 public buyLiquidityFee;
465     uint256 public buyDevFee;
466 
467     uint256 public sellTotalFees;
468     uint256 public sellMarketingFee;
469     uint256 public sellLiquidityFee;
470     uint256 public sellDevFee;
471 
472     uint256 public tokensForMarketing;
473     uint256 public tokensForLiquidity;
474     uint256 public tokensForDev;
475 
476     /******************/
477 
478     // exlcude from fees and max transaction amount
479     mapping(address => bool) private _isExcludedFromFees;
480     mapping(address => bool) public _isExcludedMaxTransactionAmount;
481 
482     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
483     // could be subject to a maximum transfer amount
484     mapping(address => bool) public automatedMarketMakerPairs;
485 
486     event UpdateUniswapV2Router(
487         address indexed newAddress,
488         address indexed oldAddress
489     );
490 
491     event LimitsRemoved();
492 
493     event ExcludeFromFees(address indexed account, bool isExcluded);
494 
495     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
496 
497     event marketingWalletUpdated(
498         address indexed newWallet,
499         address indexed oldWallet
500     );
501 
502     event devWalletUpdated(
503         address indexed newWallet,
504         address indexed oldWallet
505     );
506 
507     event lpWalletUpdated(
508         address indexed newWallet,
509         address indexed oldWallet
510     );
511 
512     event SwapAndLiquify(
513         uint256 tokensSwapped,
514         uint256 ethReceived,
515         uint256 tokensIntoLiquidity
516     );
517 
518     constructor() ERC20("0xGame (Sentient)", "$0xG") {
519         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
520             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
521         );
522 
523         excludeFromMaxTransaction(address(_uniswapV2Router), true);
524         uniswapV2Router = _uniswapV2Router;
525 
526         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
527             .createPair(address(this), _uniswapV2Router.WETH());
528         excludeFromMaxTransaction(address(uniswapV2Pair), true);
529         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
530 
531         uint256 _buyMarketingFee = 19;
532         uint256 _buyLiquidityFee = 0;
533         uint256 _buyDevFee = 18;
534 
535         uint256 _sellMarketingFee = 19;
536         uint256 _sellLiquidityFee = 0;
537         uint256 _sellDevFee = 19;
538 
539         uint256 totalSupply = 1000000000 * 1e18;
540 
541         maxTransactionAmount = (totalSupply * 2) / 100;
542         maxWallet = (totalSupply * 2) / 100;
543         swapTokensAtAmount = (totalSupply * 9) / 10000; // 0.05% swap wallet
544 
545         buyMarketingFee = _buyMarketingFee;
546         buyLiquidityFee = _buyLiquidityFee;
547         buyDevFee = _buyDevFee;
548         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
549 
550         sellMarketingFee = _sellMarketingFee;
551         sellLiquidityFee = _sellLiquidityFee;
552         sellDevFee = _sellDevFee;
553         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
554 
555         marketingWallet = address(0x4578E89697280a5db8C0999Fe0a93b8bac6d86EC); 
556         devWallet = address(0xCA66265EAEfa61Bb9A373d1F9ab0A31cB6fd243c);
557         lpWallet = msg.sender;
558 
559         // exclude from paying fees or having max transaction amount
560         excludeFromFees(owner(), true);
561         excludeFromFees(address(this), true);
562         excludeFromFees(address(0xdead), true);
563         excludeFromFees(marketingWallet, true);
564 
565         excludeFromMaxTransaction(owner(), true);
566         excludeFromMaxTransaction(address(this), true);
567         excludeFromMaxTransaction(address(0xdead), true);
568         excludeFromMaxTransaction(marketingWallet, true);
569 
570         /*
571             _mint is an internal function in ERC20.sol that is only called here,
572             and CANNOT be called ever again
573         */
574         _mint(msg.sender, totalSupply);
575     }
576 
577     receive() external payable {}
578 
579     // once enabled, can never be turned off
580     function enableTrading() external onlyOwner {
581         tradingActive = true;
582         swapEnabled = true;
583     }
584 
585     // remove limits after token is stable
586     function removeLimits() external onlyOwner returns (bool) {
587         limitsInEffect = false;
588         emit LimitsRemoved();
589         return true;
590     }
591 
592     // change the minimum amount of tokens to sell from fees
593     function updateSwapTokensAtAmount(uint256 newAmount)
594         external
595         onlyOwner
596         returns (bool)
597     {
598         require(
599             newAmount >= (totalSupply() * 1) / 100000,
600             "Swap amount cannot be lower than 0.001% total supply."
601         );
602         require(
603             newAmount <= (totalSupply() * 5) / 1000,
604             "Swap amount cannot be higher than 0.5% total supply."
605         );
606         swapTokensAtAmount = newAmount;
607         return true;
608     }
609 
610     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
611         require(
612             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
613             "Cannot set maxTransactionAmount lower than 0.1%"
614         );
615         maxTransactionAmount = newNum * (10**18);
616     }
617 
618     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
619         require(
620             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
621             "Cannot set maxWallet lower than 0.5%"
622         );
623         maxWallet = newNum * (10**18);
624     }
625 
626     function excludeFromMaxTransaction(address updAds, bool isEx)
627         public
628         onlyOwner
629     {
630         _isExcludedMaxTransactionAmount[updAds] = isEx;
631     }
632 
633     // only use to disable contract sales if absolutely necessary (emergency use only)
634     function updateSwapEnabled(bool enabled) external onlyOwner {
635         swapEnabled = enabled;
636     }
637 
638     function updateBuyFees(
639         uint256 _marketingFee,
640         uint256 _liquidityFee,
641         uint256 _devFee
642     ) external onlyOwner {
643         buyMarketingFee = _marketingFee;
644         buyLiquidityFee = _liquidityFee;
645         buyDevFee = _devFee;
646         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
647     }
648 
649     function updateSellFees(
650         uint256 _marketingFee,
651         uint256 _liquidityFee,
652         uint256 _devFee
653     ) external onlyOwner {
654         sellMarketingFee = _marketingFee;
655         sellLiquidityFee = _liquidityFee;
656         sellDevFee = _devFee;
657         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
658     }
659 
660     function excludeFromFees(address account, bool excluded) public onlyOwner {
661         _isExcludedFromFees[account] = excluded;
662         emit ExcludeFromFees(account, excluded);
663     }
664 
665     function setAutomatedMarketMakerPair(address pair, bool value)
666         public
667         onlyOwner
668     {
669         require(
670             pair != uniswapV2Pair,
671             "The pair cannot be removed from automatedMarketMakerPairs"
672         );
673 
674         _setAutomatedMarketMakerPair(pair, value);
675     }
676 
677     function _setAutomatedMarketMakerPair(address pair, bool value) private {
678         automatedMarketMakerPairs[pair] = value;
679 
680         emit SetAutomatedMarketMakerPair(pair, value);
681     }
682 
683     function updateMarketingWallet(address newMarketingWallet)
684         external
685         onlyOwner
686     {
687         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
688         marketingWallet = newMarketingWallet;
689     }
690 
691     function updateLPWallet(address newLPWallet)
692         external
693         onlyOwner
694     {
695         emit lpWalletUpdated(newLPWallet, lpWallet);
696         lpWallet = newLPWallet;
697     }
698 
699     function updateDevWallet(address newWallet) external onlyOwner {
700         emit devWalletUpdated(newWallet, devWallet);
701         devWallet = newWallet;
702     }
703 
704     function isExcludedFromFees(address account) public view returns (bool) {
705         return _isExcludedFromFees[account];
706     }
707 
708     event BoughtEarly(address indexed sniper);
709 
710     function _transfer(
711         address from,
712         address to,
713         uint256 amount
714     ) internal override {
715         require(from != address(0), "ERC20: transfer from the zero address");
716         require(to != address(0), "ERC20: transfer to the zero address");
717 
718         if (amount == 0) {
719             super._transfer(from, to, 0);
720             return;
721         }
722 
723         if (limitsInEffect) {
724             if (
725                 from != owner() &&
726                 to != owner() &&
727                 to != address(0) &&
728                 to != address(0xdead) &&
729                 !swapping
730             ) {
731                 if (!tradingActive) {
732                     require(
733                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
734                         "Trading is not active."
735                     );
736                 }
737 
738                 //when buy
739                 if (
740                     automatedMarketMakerPairs[from] &&
741                     !_isExcludedMaxTransactionAmount[to]
742                 ) {
743                     require(
744                         amount <= maxTransactionAmount,
745                         "Buy transfer amount exceeds the maxTransactionAmount."
746                     );
747                     require(
748                         amount + balanceOf(to) <= maxWallet,
749                         "Max wallet exceeded"
750                     );
751                 }
752                 //when sell
753                 else if (
754                     automatedMarketMakerPairs[to] &&
755                     !_isExcludedMaxTransactionAmount[from]
756                 ) {
757                     require(
758                         amount <= maxTransactionAmount,
759                         "Sell transfer amount exceeds the maxTransactionAmount."
760                     );
761                 } else if (!_isExcludedMaxTransactionAmount[to]) {
762                     require(
763                         amount + balanceOf(to) <= maxWallet,
764                         "Max wallet exceeded"
765                     );
766                 }
767             }
768         }
769 
770         uint256 contractTokenBalance = balanceOf(address(this));
771 
772         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
773 
774         if (
775             canSwap &&
776             swapEnabled &&
777             !swapping &&
778             !automatedMarketMakerPairs[from] &&
779             !_isExcludedFromFees[from] &&
780             !_isExcludedFromFees[to]
781         ) {
782             swapping = true;
783 
784             swapBack();
785 
786             swapping = false;
787         }
788 
789         bool takeFee = !swapping;
790 
791         // if any account belongs to _isExcludedFromFee account then remove the fee
792         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
793             takeFee = false;
794         }
795 
796         uint256 fees = 0;
797         // only take fees on buys/sells, do not take on wallet transfers
798         if (takeFee) {
799             // on sell
800             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
801                 fees = amount.mul(sellTotalFees).div(100);
802                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
803                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
804                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
805             }
806             // on buy
807             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
808                 fees = amount.mul(buyTotalFees).div(100);
809                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
810                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
811                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
812             }
813 
814             if (fees > 0) {
815                 super._transfer(from, address(this), fees);
816             }
817 
818             amount -= fees;
819         }
820 
821         super._transfer(from, to, amount);
822     }
823 
824     function swapTokensForEth(uint256 tokenAmount) private {
825         // generate the uniswap pair path of token -> weth
826         address[] memory path = new address[](2);
827         path[0] = address(this);
828         path[1] = uniswapV2Router.WETH();
829 
830         _approve(address(this), address(uniswapV2Router), tokenAmount);
831 
832         // make the swap
833         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
834             tokenAmount,
835             0, // accept any amount of ETH
836             path,
837             address(this),
838             block.timestamp
839         );
840     }
841 
842     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
843         // approve token transfer to cover all possible scenarios
844         _approve(address(this), address(uniswapV2Router), tokenAmount);
845 
846         // add the liquidity
847         uniswapV2Router.addLiquidityETH{value: ethAmount}(
848             address(this),
849             tokenAmount,
850             0, // slippage is unavoidable
851             0, // slippage is unavoidable
852             lpWallet,
853             block.timestamp
854         );
855     }
856 
857     function swapBack() private {
858         uint256 contractBalance = balanceOf(address(this));
859         uint256 totalTokensToSwap = tokensForLiquidity +
860             tokensForMarketing +
861             tokensForDev;
862         bool success;
863 
864         if (contractBalance == 0 || totalTokensToSwap == 0) {
865             return;
866         }
867 
868         // Halve the amount of liquidity tokens
869         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
870             totalTokensToSwap /
871             2;
872         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
873 
874         uint256 initialETHBalance = address(this).balance;
875 
876         swapTokensForEth(amountToSwapForETH);
877 
878         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
879 
880         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
881             totalTokensToSwap
882         );
883         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
884 
885         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
886 
887         tokensForLiquidity = 0;
888         tokensForMarketing = 0;
889         tokensForDev = 0;
890 
891         (success, ) = address(devWallet).call{value: ethForDev}("");
892 
893         if (liquidityTokens > 0 && ethForLiquidity > 0) {
894             addLiquidity(liquidityTokens, ethForLiquidity);
895             emit SwapAndLiquify(
896                 amountToSwapForETH,
897                 ethForLiquidity,
898                 tokensForLiquidity
899             );
900         }
901 
902         (success, ) = address(marketingWallet).call{
903             value: address(this).balance
904         }("");
905     }
906 }