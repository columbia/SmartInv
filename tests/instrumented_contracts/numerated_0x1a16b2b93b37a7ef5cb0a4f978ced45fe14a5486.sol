1 /**
2  
3  Website : collar.finance
4 */
5 
6 //  SPDX-License-Identifier: MIT
7 pragma solidity >=0.8.19;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14 }
15 
16 abstract contract Ownable is Context {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     constructor() {
22         _transferOwnership(_msgSender());
23     }
24 
25     function owner() public view virtual returns (address) {
26         return _owner;
27     }
28 
29     modifier onlyOwner() {
30         require(owner() == _msgSender(), "Ownable: caller is not the owner");
31         _;
32     }
33 
34     function renounceOwnership() public virtual onlyOwner {
35         _transferOwnership(address(0));
36     }
37 
38     function transferOwnership(address newOwner) public virtual onlyOwner {
39         require(newOwner != address(0), "Ownable: new owner is the zero address");
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
51 
52     function totalSupply() external view returns (uint256);
53 
54     function balanceOf(address account) external view returns (uint256);
55 
56     function transfer(address recipient, uint256 amount) external returns (bool);
57 
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     function approve(address spender, uint256 amount) external returns (bool);
61 
62     function transferFrom(
63         address sender,
64         address recipient,
65         uint256 amount
66     ) external returns (bool);
67 
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 interface IERC20Metadata is IERC20 {
74 
75     function name() external view returns (string memory);
76 
77     function symbol() external view returns (string memory);
78 
79     function decimals() external view returns (uint8);
80 }
81 
82 contract ERC20 is Context, IERC20, IERC20Metadata {
83     mapping(address => uint256) private _balances;
84 
85     mapping(address => mapping(address => uint256)) private _allowances;
86 
87     uint256 private _totalSupply;
88 
89     string private _name;
90     string private _symbol;
91 
92     constructor(string memory name_, string memory symbol_) {
93         _name = name_;
94         _symbol = symbol_;
95     }
96 
97     function name() public view virtual override returns (string memory) {
98         return _name;
99     }
100 
101     function symbol() public view virtual override returns (string memory) {
102         return _symbol;
103     }
104 
105     function decimals() public view virtual override returns (uint8) {
106         return 18;
107     }
108 
109     function totalSupply() public view virtual override returns (uint256) {
110         return _totalSupply;
111     }
112 
113     function balanceOf(address account) public view virtual override returns (uint256) {
114         return _balances[account];
115     }
116 
117     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
118         _transfer(_msgSender(), recipient, amount);
119         return true;
120     }
121 
122     function allowance(address owner, address spender) public view virtual override returns (uint256) {
123         return _allowances[owner][spender];
124     }
125 
126     function approve(address spender, uint256 amount) public virtual override returns (bool) {
127         _approve(_msgSender(), spender, amount);
128         return true;
129     }
130 
131     function transferFrom(
132         address sender,
133         address recipient,
134         uint256 amount
135     ) public virtual override returns (bool) {
136         _transfer(sender, recipient, amount);
137 
138         uint256 currentAllowance = _allowances[sender][_msgSender()];
139         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
140         unchecked {
141             _approve(sender, _msgSender(), currentAllowance - amount);
142         }
143 
144         return true;
145     }
146 
147     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
148         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
149         return true;
150     }
151 
152     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
153         uint256 currentAllowance = _allowances[_msgSender()][spender];
154         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
155         unchecked {
156             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
157         }
158 
159         return true;
160     }
161 
162     function _transfer(
163         address sender,
164         address recipient,
165         uint256 amount
166     ) internal virtual {
167         require(sender != address(0), "ERC20: transfer from the zero address");
168         require(recipient != address(0), "ERC20: transfer to the zero address");
169 
170         _beforeTokenTransfer(sender, recipient, amount);
171 
172         uint256 senderBalance = _balances[sender];
173         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
174         unchecked {
175             _balances[sender] = senderBalance - amount;
176         }
177         _balances[recipient] += amount;
178 
179         emit Transfer(sender, recipient, amount);
180 
181         _afterTokenTransfer(sender, recipient, amount);
182     }
183 
184     function _mint(address account, uint256 amount) internal virtual {
185         require(account != address(0), "ERC20: mint to the zero address");
186 
187         _beforeTokenTransfer(address(0), account, amount);
188 
189         _totalSupply += amount;
190         _balances[account] += amount;
191         emit Transfer(address(0), account, amount);
192 
193         _afterTokenTransfer(address(0), account, amount);
194     }
195 
196     function _approve(
197         address owner,
198         address spender,
199         uint256 amount
200     ) internal virtual {
201         require(owner != address(0), "ERC20: approve from the zero address");
202         require(spender != address(0), "ERC20: approve to the zero address");
203 
204         _allowances[owner][spender] = amount;
205         emit Approval(owner, spender, amount);
206     }
207 
208     function _beforeTokenTransfer(
209         address from,
210         address to,
211         uint256 amount
212     ) internal virtual {}
213 
214     function _afterTokenTransfer(
215         address from,
216         address to,
217         uint256 amount
218     ) internal virtual {}
219 }
220 
221 library SafeMath {
222 
223     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
224         return a - b;
225     }
226 
227     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
228         return a * b;
229     }
230 
231     function div(uint256 a, uint256 b) internal pure returns (uint256) {
232         return a / b;
233     }
234 } 
235 
236 interface IUniswapV2Factory {
237     event PairCreated(
238         address indexed token0,
239         address indexed token1,
240         address pair,
241         uint256
242     );
243 
244     function feeTo() external view returns (address);
245 
246     function feeToSetter() external view returns (address);
247 
248     function getPair(address tokenA, address tokenB)
249         external
250         view
251         returns (address pair);
252 
253     function allPairs(uint256) external view returns (address pair);
254 
255     function allPairsLength() external view returns (uint256);
256 
257     function createPair(address tokenA, address tokenB)
258         external
259         returns (address pair);
260 
261     function setFeeTo(address) external;
262 
263     function setFeeToSetter(address) external;
264 }
265 
266 interface IUniswapV2Pair {
267     event Approval(
268         address indexed owner,
269         address indexed spender,
270         uint256 value
271     );
272     event Transfer(address indexed from, address indexed to, uint256 value);
273 
274     function name() external pure returns (string memory);
275 
276     function symbol() external pure returns (string memory);
277 
278     function decimals() external pure returns (uint8);
279 
280     function totalSupply() external view returns (uint256);
281 
282     function balanceOf(address owner) external view returns (uint256);
283 
284     function allowance(address owner, address spender)
285         external
286         view
287         returns (uint256);
288 
289     function approve(address spender, uint256 value) external returns (bool);
290 
291     function transfer(address to, uint256 value) external returns (bool);
292 
293     function transferFrom(
294         address from,
295         address to,
296         uint256 value
297     ) external returns (bool);
298 
299     function DOMAIN_SEPARATOR() external view returns (bytes32);
300 
301     function PERMIT_TYPEHASH() external pure returns (bytes32);
302 
303     function nonces(address owner) external view returns (uint256);
304 
305     function permit(
306         address owner,
307         address spender,
308         uint256 value,
309         uint256 deadline,
310         uint8 v,
311         bytes32 r,
312         bytes32 s
313     ) external;
314 
315     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
316     event Burn(
317         address indexed sender,
318         uint256 amount0,
319         uint256 amount1,
320         address indexed to
321     );
322     event Swap(
323         address indexed sender,
324         uint256 amount0In,
325         uint256 amount1In,
326         uint256 amount0Out,
327         uint256 amount1Out,
328         address indexed to
329     );
330     event Sync(uint112 reserve0, uint112 reserve1);
331 
332     function MINIMUM_LIQUIDITY() external pure returns (uint256);
333 
334     function factory() external view returns (address);
335 
336     function token0() external view returns (address);
337 
338     function token1() external view returns (address);
339 
340     function getReserves()
341         external
342         view
343         returns (
344             uint112 reserve0,
345             uint112 reserve1,
346             uint32 blockTimestampLast
347         );
348 
349     function price0CumulativeLast() external view returns (uint256);
350 
351     function price1CumulativeLast() external view returns (uint256);
352 
353     function kLast() external view returns (uint256);
354 
355     function mint(address to) external returns (uint256 liquidity);
356 
357     function burn(address to)
358         external
359         returns (uint256 amount0, uint256 amount1);
360 
361     function swap(
362         uint256 amount0Out,
363         uint256 amount1Out,
364         address to,
365         bytes calldata data
366     ) external;
367 
368     function skim(address to) external;
369 
370     function sync() external;
371 
372     function initialize(address, address) external;
373 }
374 
375 interface IUniswapV2Router02 {
376     function factory() external pure returns (address);
377 
378     function WETH() external pure returns (address);
379 
380     function addLiquidity(
381         address tokenA,
382         address tokenB,
383         uint256 amountADesired,
384         uint256 amountBDesired,
385         uint256 amountAMin,
386         uint256 amountBMin,
387         address to,
388         uint256 deadline
389     )
390         external
391         returns (
392             uint256 amountA,
393             uint256 amountB,
394             uint256 liquidity
395         );
396 
397     function addLiquidityETH(
398         address token,
399         uint256 amountTokenDesired,
400         uint256 amountTokenMin,
401         uint256 amountETHMin,
402         address to,
403         uint256 deadline
404     )
405         external
406         payable
407         returns (
408             uint256 amountToken,
409             uint256 amountETH,
410             uint256 liquidity
411         );
412 
413     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
414         uint256 amountIn,
415         uint256 amountOutMin,
416         address[] calldata path,
417         address to,
418         uint256 deadline
419     ) external;
420 
421     function swapExactETHForTokensSupportingFeeOnTransferTokens(
422         uint256 amountOutMin,
423         address[] calldata path,
424         address to,
425         uint256 deadline
426     ) external payable;
427 
428     function swapExactTokensForETHSupportingFeeOnTransferTokens(
429         uint256 amountIn,
430         uint256 amountOutMin,
431         address[] calldata path,
432         address to,
433         uint256 deadline
434     ) external;
435 }
436 
437 contract COLLAR is ERC20, Ownable {
438     using SafeMath for uint256;
439 
440     IUniswapV2Router02 public immutable uniswapV2Router;
441     address public immutable uniswapV2Pair;
442     address public constant deadAddress = address(0xdead);
443 
444     bool private swapping;
445 
446     address public marketingWallet;
447     address public devWallet;
448     address public lpWallet;
449 
450     uint256 public maxTransactionAmount;
451     uint256 public swapTokensAtAmount;
452     uint256 public maxWallet;
453 
454     bool public limitsInEffect = true;
455     bool public tradingActive = true;
456     bool public swapEnabled = true;
457 
458     uint256 public buyTotalFees;
459     uint256 public buyMarketingFee;
460     uint256 public buyLiquidityFee;
461     uint256 public buyDevFee;
462 
463     uint256 public sellTotalFees;
464     uint256 public sellMarketingFee;
465     uint256 public sellLiquidityFee;
466     uint256 public sellDevFee;
467 
468     uint256 public tokensForMarketing;
469     uint256 public tokensForLiquidity;
470     uint256 public tokensForDev;
471 
472     /******************/
473 
474     // exlcude from fees and max transaction amount
475     mapping(address => bool) private _isExcludedFromFees;
476     mapping(address => bool) public _isExcludedMaxTransactionAmount;
477 
478     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
479     // could be subject to a maximum transfer amount
480     mapping(address => bool) public automatedMarketMakerPairs;
481 
482     event UpdateUniswapV2Router(
483         address indexed newAddress,
484         address indexed oldAddress
485     );
486 
487     event LimitsRemoved();
488 
489     event ExcludeFromFees(address indexed account, bool isExcluded);
490 
491     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
492 
493     event marketingWalletUpdated(
494         address indexed newWallet,
495         address indexed oldWallet
496     );
497 
498     event devWalletUpdated(
499         address indexed newWallet,
500         address indexed oldWallet
501     );
502 
503     event lpWalletUpdated(
504         address indexed newWallet,
505         address indexed oldWallet
506     );
507 
508     event SwapAndLiquify(
509         uint256 tokensSwapped,
510         uint256 ethReceived,
511         uint256 tokensIntoLiquidity
512     );
513 
514     constructor() ERC20("Collar", "COLLAR") {
515         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
516             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
517         );
518 
519         excludeFromMaxTransaction(address(_uniswapV2Router), true);
520         uniswapV2Router = _uniswapV2Router;
521 
522         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
523             .createPair(address(this), _uniswapV2Router.WETH());
524         excludeFromMaxTransaction(address(uniswapV2Pair), true);
525         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
526 
527         uint256 _buyMarketingFee = 10;
528         uint256 _buyLiquidityFee = 0;
529         uint256 _buyDevFee = 0;
530 
531         uint256 _sellMarketingFee = 20;
532         uint256 _sellLiquidityFee = 0;
533         uint256 _sellDevFee = 0;
534 
535         uint256 totalSupply = 1000000000 * 1e18;
536 
537         maxTransactionAmount = (totalSupply * 2) / 100;
538         maxWallet = (totalSupply * 2) / 100;
539         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
540 
541         buyMarketingFee = _buyMarketingFee;
542         buyLiquidityFee = _buyLiquidityFee;
543         buyDevFee = _buyDevFee;
544         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
545 
546         sellMarketingFee = _sellMarketingFee;
547         sellLiquidityFee = _sellLiquidityFee;
548         sellDevFee = _sellDevFee;
549         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
550 
551         marketingWallet = address(0x4be7154A825c48b5F1EeB517911A72ab93518aF0); 
552         devWallet = address(0x7AEeD347B695961ad2ad5f6C5f2d20630be984c3);
553         lpWallet = msg.sender;
554 
555         // exclude from paying fees or having max transaction amount
556         excludeFromFees(owner(), true);
557         excludeFromFees(address(this), true);
558         excludeFromFees(address(0xdead), true);
559         excludeFromFees(marketingWallet, true);
560 
561         excludeFromMaxTransaction(owner(), true);
562         excludeFromMaxTransaction(address(this), true);
563         excludeFromMaxTransaction(address(0xdead), true);
564         excludeFromMaxTransaction(marketingWallet, true);
565 
566         /*
567             _mint is an internal function in ERC20.sol that is only called here,
568             and CANNOT be called ever again
569         */
570         _mint(msg.sender, totalSupply);
571     }
572 
573     receive() external payable {}
574 
575     // once enabled, can never be turned off
576     function enableTrading() external onlyOwner {
577         tradingActive = true;
578         swapEnabled = true;
579     }
580 
581     // remove limits after token is stable
582     function removeLimits() external onlyOwner returns (bool) {
583         limitsInEffect = false;
584         emit LimitsRemoved();
585         return true;
586     }
587 
588     // change the minimum amount of tokens to sell from fees
589     function updateSwapTokensAtAmount(uint256 newAmount)
590         external
591         onlyOwner
592         returns (bool)
593     {
594         require(
595             newAmount >= (totalSupply() * 1) / 100000,
596             "Swap amount cannot be lower than 0.001% total supply."
597         );
598         require(
599             newAmount <= (totalSupply() * 5) / 1000,
600             "Swap amount cannot be higher than 0.5% total supply."
601         );
602         swapTokensAtAmount = newAmount;
603         return true;
604     }
605 
606     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
607         require(
608             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
609             "Cannot set maxTransactionAmount lower than 0.1%"
610         );
611         maxTransactionAmount = newNum * (10**18);
612     }
613 
614     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
615         require(
616             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
617             "Cannot set maxWallet lower than 0.5%"
618         );
619         maxWallet = newNum * (10**18);
620     }
621 
622     function excludeFromMaxTransaction(address updAds, bool isEx)
623         public
624         onlyOwner
625     {
626         _isExcludedMaxTransactionAmount[updAds] = isEx;
627     }
628 
629     // only use to disable contract sales if absolutely necessary (emergency use only)
630     function updateSwapEnabled(bool enabled) external onlyOwner {
631         swapEnabled = enabled;
632     }
633 
634     function updateBuyFees(
635         uint256 _marketingFee,
636         uint256 _liquidityFee,
637         uint256 _devFee
638     ) external onlyOwner {
639         buyMarketingFee = _marketingFee;
640         buyLiquidityFee = _liquidityFee;
641         buyDevFee = _devFee;
642         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
643     }
644 
645     function updateSellFees(
646         uint256 _marketingFee,
647         uint256 _liquidityFee,
648         uint256 _devFee
649     ) external onlyOwner {
650         sellMarketingFee = _marketingFee;
651         sellLiquidityFee = _liquidityFee;
652         sellDevFee = _devFee;
653         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
654     }
655 
656     function excludeFromFees(address account, bool excluded) public onlyOwner {
657         _isExcludedFromFees[account] = excluded;
658         emit ExcludeFromFees(account, excluded);
659     }
660 
661     function setAutomatedMarketMakerPair(address pair, bool value)
662         public
663         onlyOwner
664     {
665         require(
666             pair != uniswapV2Pair,
667             "The pair cannot be removed from automatedMarketMakerPairs"
668         );
669 
670         _setAutomatedMarketMakerPair(pair, value);
671     }
672 
673     function _setAutomatedMarketMakerPair(address pair, bool value) private {
674         automatedMarketMakerPairs[pair] = value;
675 
676         emit SetAutomatedMarketMakerPair(pair, value);
677     }
678 
679     function updateMarketingWallet(address newMarketingWallet)
680         external
681         onlyOwner
682     {
683         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
684         marketingWallet = newMarketingWallet;
685     }
686 
687     function updateLPWallet(address newLPWallet)
688         external
689         onlyOwner
690     {
691         emit lpWalletUpdated(newLPWallet, lpWallet);
692         lpWallet = newLPWallet;
693     }
694 
695     function updateDevWallet(address newWallet) external onlyOwner {
696         emit devWalletUpdated(newWallet, devWallet);
697         devWallet = newWallet;
698     }
699 
700     function isExcludedFromFees(address account) public view returns (bool) {
701         return _isExcludedFromFees[account];
702     }
703 
704     event BoughtEarly(address indexed sniper);
705 
706     function _transfer(
707         address from,
708         address to,
709         uint256 amount
710     ) internal override {
711         require(from != address(0), "ERC20: transfer from the zero address");
712         require(to != address(0), "ERC20: transfer to the zero address");
713 
714         if (amount == 0) {
715             super._transfer(from, to, 0);
716             return;
717         }
718 
719         if (limitsInEffect) {
720             if (
721                 from != owner() &&
722                 to != owner() &&
723                 to != address(0) &&
724                 to != address(0xdead) &&
725                 !swapping
726             ) {
727                 if (!tradingActive) {
728                     require(
729                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
730                         "Trading is not active."
731                     );
732                 }
733 
734                 //when buy
735                 if (
736                     automatedMarketMakerPairs[from] &&
737                     !_isExcludedMaxTransactionAmount[to]
738                 ) {
739                     require(
740                         amount <= maxTransactionAmount,
741                         "Buy transfer amount exceeds the maxTransactionAmount."
742                     );
743                     require(
744                         amount + balanceOf(to) <= maxWallet,
745                         "Max wallet exceeded"
746                     );
747                 }
748                 //when sell
749                 else if (
750                     automatedMarketMakerPairs[to] &&
751                     !_isExcludedMaxTransactionAmount[from]
752                 ) {
753                     require(
754                         amount <= maxTransactionAmount,
755                         "Sell transfer amount exceeds the maxTransactionAmount."
756                     );
757                 } else if (!_isExcludedMaxTransactionAmount[to]) {
758                     require(
759                         amount + balanceOf(to) <= maxWallet,
760                         "Max wallet exceeded"
761                     );
762                 }
763             }
764         }
765 
766         uint256 contractTokenBalance = balanceOf(address(this));
767 
768         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
769 
770         if (
771             canSwap &&
772             swapEnabled &&
773             !swapping &&
774             !automatedMarketMakerPairs[from] &&
775             !_isExcludedFromFees[from] &&
776             !_isExcludedFromFees[to]
777         ) {
778             swapping = true;
779 
780             swapBack();
781 
782             swapping = false;
783         }
784 
785         bool takeFee = !swapping;
786 
787         // if any account belongs to _isExcludedFromFee account then remove the fee
788         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
789             takeFee = false;
790         }
791 
792         uint256 fees = 0;
793         // only take fees on buys/sells, do not take on wallet transfers
794         if (takeFee) {
795             // on sell
796             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
797                 fees = amount.mul(sellTotalFees).div(100);
798                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
799                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
800                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
801             }
802             // on buy
803             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
804                 fees = amount.mul(buyTotalFees).div(100);
805                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
806                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
807                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
808             }
809 
810             if (fees > 0) {
811                 super._transfer(from, address(this), fees);
812             }
813 
814             amount -= fees;
815         }
816 
817         super._transfer(from, to, amount);
818     }
819 
820     function swapTokensForEth(uint256 tokenAmount) private {
821         // generate the uniswap pair path of token -> weth
822         address[] memory path = new address[](2);
823         path[0] = address(this);
824         path[1] = uniswapV2Router.WETH();
825 
826         _approve(address(this), address(uniswapV2Router), tokenAmount);
827 
828         // make the swap
829         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
830             tokenAmount,
831             0, // accept any amount of ETH
832             path,
833             address(this),
834             block.timestamp
835         );
836     }
837 
838     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
839         // approve token transfer to cover all possible scenarios
840         _approve(address(this), address(uniswapV2Router), tokenAmount);
841 
842         // add the liquidity
843         uniswapV2Router.addLiquidityETH{value: ethAmount}(
844             address(this),
845             tokenAmount,
846             0, // slippage is unavoidable
847             0, // slippage is unavoidable
848             lpWallet,
849             block.timestamp
850         );
851     }
852 
853     function swapBack() private {
854         uint256 contractBalance = balanceOf(address(this));
855         uint256 totalTokensToSwap = tokensForLiquidity +
856             tokensForMarketing +
857             tokensForDev;
858         bool success;
859 
860         if (contractBalance == 0 || totalTokensToSwap == 0) {
861             return;
862         }
863 
864         // Halve the amount of liquidity tokens
865         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
866             totalTokensToSwap /
867             2;
868         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
869 
870         uint256 initialETHBalance = address(this).balance;
871 
872         swapTokensForEth(amountToSwapForETH);
873 
874         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
875 
876         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
877             totalTokensToSwap
878         );
879         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
880 
881         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
882 
883         tokensForLiquidity = 0;
884         tokensForMarketing = 0;
885         tokensForDev = 0;
886 
887         (success, ) = address(devWallet).call{value: ethForDev}("");
888 
889         if (liquidityTokens > 0 && ethForLiquidity > 0) {
890             addLiquidity(liquidityTokens, ethForLiquidity);
891             emit SwapAndLiquify(
892                 amountToSwapForETH,
893                 ethForLiquidity,
894                 tokensForLiquidity
895             );
896         }
897 
898         (success, ) = address(marketingWallet).call{
899             value: address(this).balance
900         }("");
901     }
902 }