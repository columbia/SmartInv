1 /*
2 	https://medium.com/@theyoungdevil
3 */
4 // SPDX-License-Identifier: MIT
5 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
6 pragma experimental ABIEncoderV2;
7 
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
37     function renounceOwnership() public virtual onlyOwner {
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
52 interface IERC20 {
53     function totalSupply() external view returns (uint256);
54     function balanceOf(address account) external view returns (uint256);
55     function transfer(address recipient, uint256 amount) external returns (bool);
56     function allowance(address owner, address spender) external view returns (uint256);
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     function transferFrom(
60         address sender,
61         address recipient,
62         uint256 amount
63     ) external returns (bool);
64 
65     event Transfer(address indexed from, address indexed to, uint256 value);
66     event Approval(address indexed owner, address indexed spender, uint256 value);
67 }
68 
69 interface IERC20Metadata is IERC20 {
70     function name() external view returns (string memory);
71     function symbol() external view returns (string memory);
72     function decimals() external view returns (uint8);
73 }
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
101     function totalSupply() public view virtual override returns (uint256) {
102         return _totalSupply;
103     }
104     function balanceOf(address account) public view virtual override returns (uint256) {
105         return _balances[account];
106     }
107 
108     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
109         _transfer(_msgSender(), recipient, amount);
110         return true;
111     }
112 
113     function allowance(address owner, address spender) public view virtual override returns (uint256) {
114         return _allowances[owner][spender];
115     }
116 
117     function approve(address spender, uint256 amount) public virtual override returns (bool) {
118         _approve(_msgSender(), spender, amount);
119         return true;
120     }
121 
122     function transferFrom(
123         address sender,
124         address recipient,
125         uint256 amount
126     ) public virtual override returns (bool) {
127         _transfer(sender, recipient, amount);
128 
129         uint256 currentAllowance = _allowances[sender][_msgSender()];
130         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
131         unchecked {
132             _approve(sender, _msgSender(), currentAllowance - amount);
133         }
134 
135         return true;
136     }
137 
138     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
139         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
140         return true;
141     }
142 
143     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
144         uint256 currentAllowance = _allowances[_msgSender()][spender];
145         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
146         unchecked {
147             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
148         }
149 
150         return true;
151     }
152 
153    
154     function _transfer(
155         address sender,
156         address recipient,
157         uint256 amount
158     ) internal virtual {
159         require(sender != address(0), "ERC20: transfer from the zero address");
160         require(recipient != address(0), "ERC20: transfer to the zero address");
161 
162         _beforeTokenTransfer(sender, recipient, amount);
163 
164         uint256 senderBalance = _balances[sender];
165         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
166         unchecked {
167             _balances[sender] = senderBalance - amount;
168         }
169         _balances[recipient] += amount;
170 
171         emit Transfer(sender, recipient, amount);
172 
173         _afterTokenTransfer(sender, recipient, amount);
174     }
175 
176     function _mint(address account, uint256 amount) internal virtual {
177         require(account != address(0), "ERC20: mint to the zero address");
178 
179         _beforeTokenTransfer(address(0), account, amount);
180 
181         _totalSupply += amount;
182         _balances[account] += amount;
183         emit Transfer(address(0), account, amount);
184 
185         _afterTokenTransfer(address(0), account, amount);
186     }
187 
188     function _burn(address account, uint256 amount) internal virtual {
189         require(account != address(0), "ERC20: burn from the zero address");
190 
191         _beforeTokenTransfer(account, address(0), amount);
192 
193         uint256 accountBalance = _balances[account];
194         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
195         unchecked {
196             _balances[account] = accountBalance - amount;
197         }
198         _totalSupply -= amount;
199 
200         emit Transfer(account, address(0), amount);
201 
202         _afterTokenTransfer(account, address(0), amount);
203     }
204 
205     function _approve(
206         address owner,
207         address spender,
208         uint256 amount
209     ) internal virtual {
210         require(owner != address(0), "ERC20: approve from the zero address");
211         require(spender != address(0), "ERC20: approve to the zero address");
212 
213         _allowances[owner][spender] = amount;
214         emit Approval(owner, spender, amount);
215     }
216 
217     function _beforeTokenTransfer(
218         address from,
219         address to,
220         uint256 amount
221     ) internal virtual {}
222 
223     function _afterTokenTransfer(
224         address from,
225         address to,
226         uint256 amount
227     ) internal virtual {}
228 }
229 
230 library SafeMath {
231     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
232         unchecked {
233             uint256 c = a + b;
234             if (c < a) return (false, 0);
235             return (true, c);
236         }
237     }
238 
239     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
240         unchecked {
241             if (b > a) return (false, 0);
242             return (true, a - b);
243         }
244     }
245 
246     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
247         unchecked {
248             if (a == 0) return (true, 0);
249             uint256 c = a * b;
250             if (c / a != b) return (false, 0);
251             return (true, c);
252         }
253     }
254 
255     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
256         unchecked {
257             if (b == 0) return (false, 0);
258             return (true, a / b);
259         }
260     }
261 
262     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
263         unchecked {
264             if (b == 0) return (false, 0);
265             return (true, a % b);
266         }
267     }
268 
269     function add(uint256 a, uint256 b) internal pure returns (uint256) {
270         return a + b;
271     }
272 
273     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
274         return a - b;
275     }
276 
277     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
278         return a * b;
279     }
280 
281     function div(uint256 a, uint256 b) internal pure returns (uint256) {
282         return a / b;
283     }
284 
285     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
286         return a % b;
287     }
288 
289     function sub(
290         uint256 a,
291         uint256 b,
292         string memory errorMessage
293     ) internal pure returns (uint256) {
294         unchecked {
295             require(b <= a, errorMessage);
296             return a - b;
297         }
298     }
299 
300     function div(
301         uint256 a,
302         uint256 b,
303         string memory errorMessage
304     ) internal pure returns (uint256) {
305         unchecked {
306             require(b > 0, errorMessage);
307             return a / b;
308         }
309     }
310 
311     function mod(
312         uint256 a,
313         uint256 b,
314         string memory errorMessage
315     ) internal pure returns (uint256) {
316         unchecked {
317             require(b > 0, errorMessage);
318             return a % b;
319         }
320     }
321 }
322 
323 interface IUniswapV2Factory {
324     event PairCreated(
325         address indexed token0,
326         address indexed token1,
327         address pair,
328         uint256
329     );
330 
331     function feeTo() external view returns (address);
332 
333     function feeToSetter() external view returns (address);
334 
335     function getPair(address tokenA, address tokenB)
336         external
337         view
338         returns (address pair);
339 
340     function allPairs(uint256) external view returns (address pair);
341 
342     function allPairsLength() external view returns (uint256);
343 
344     function createPair(address tokenA, address tokenB)
345         external
346         returns (address pair);
347 
348     function setFeeTo(address) external;
349 
350     function setFeeToSetter(address) external;
351 }
352 
353 interface IUniswapV2Pair {
354     event Approval(
355         address indexed owner,
356         address indexed spender,
357         uint256 value
358     );
359     event Transfer(address indexed from, address indexed to, uint256 value);
360 
361     function name() external pure returns (string memory);
362 
363     function symbol() external pure returns (string memory);
364 
365     function decimals() external pure returns (uint8);
366 
367     function totalSupply() external view returns (uint256);
368 
369     function balanceOf(address owner) external view returns (uint256);
370 
371     function allowance(address owner, address spender)
372         external
373         view
374         returns (uint256);
375 
376     function approve(address spender, uint256 value) external returns (bool);
377 
378     function transfer(address to, uint256 value) external returns (bool);
379 
380     function transferFrom(
381         address from,
382         address to,
383         uint256 value
384     ) external returns (bool);
385 
386     function DOMAIN_SEPARATOR() external view returns (bytes32);
387 
388     function PERMIT_TYPEHASH() external pure returns (bytes32);
389 
390     function nonces(address owner) external view returns (uint256);
391 
392     function permit(
393         address owner,
394         address spender,
395         uint256 value,
396         uint256 deadline,
397         uint8 v,
398         bytes32 r,
399         bytes32 s
400     ) external;
401 
402     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
403     event Burn(
404         address indexed sender,
405         uint256 amount0,
406         uint256 amount1,
407         address indexed to
408     );
409     event Swap(
410         address indexed sender,
411         uint256 amount0In,
412         uint256 amount1In,
413         uint256 amount0Out,
414         uint256 amount1Out,
415         address indexed to
416     );
417     event Sync(uint112 reserve0, uint112 reserve1);
418 
419     function MINIMUM_LIQUIDITY() external pure returns (uint256);
420 
421     function factory() external view returns (address);
422 
423     function token0() external view returns (address);
424 
425     function token1() external view returns (address);
426 
427     function getReserves()
428         external
429         view
430         returns (
431             uint112 reserve0,
432             uint112 reserve1,
433             uint32 blockTimestampLast
434         );
435 
436     function price0CumulativeLast() external view returns (uint256);
437 
438     function price1CumulativeLast() external view returns (uint256);
439 
440     function kLast() external view returns (uint256);
441 
442     function mint(address to) external returns (uint256 liquidity);
443 
444     function burn(address to)
445         external
446         returns (uint256 amount0, uint256 amount1);
447 
448     function swap(
449         uint256 amount0Out,
450         uint256 amount1Out,
451         address to,
452         bytes calldata data
453     ) external;
454 
455     function skim(address to) external;
456 
457     function sync() external;
458 
459     function initialize(address, address) external;
460 }
461 
462 
463 interface IUniswapV2Router02 {
464     function factory() external pure returns (address);
465 
466     function WETH() external pure returns (address);
467 
468     function addLiquidity(
469         address tokenA,
470         address tokenB,
471         uint256 amountADesired,
472         uint256 amountBDesired,
473         uint256 amountAMin,
474         uint256 amountBMin,
475         address to,
476         uint256 deadline
477     )
478         external
479         returns (
480             uint256 amountA,
481             uint256 amountB,
482             uint256 liquidity
483         );
484 
485     function addLiquidityETH(
486         address token,
487         uint256 amountTokenDesired,
488         uint256 amountTokenMin,
489         uint256 amountETHMin,
490         address to,
491         uint256 deadline
492     )
493         external
494         payable
495         returns (
496             uint256 amountToken,
497             uint256 amountETH,
498             uint256 liquidity
499         );
500 
501     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
502         uint256 amountIn,
503         uint256 amountOutMin,
504         address[] calldata path,
505         address to,
506         uint256 deadline
507     ) external;
508 
509     function swapExactETHForTokensSupportingFeeOnTransferTokens(
510         uint256 amountOutMin,
511         address[] calldata path,
512         address to,
513         uint256 deadline
514     ) external payable;
515 
516     function swapExactTokensForETHSupportingFeeOnTransferTokens(
517         uint256 amountIn,
518         uint256 amountOutMin,
519         address[] calldata path,
520         address to,
521         uint256 deadline
522     ) external;
523 }
524 
525 contract Lucifer is ERC20, Ownable {
526     using SafeMath for uint256;
527 
528     IUniswapV2Router02 public immutable uniswapV2Router;
529     address public immutable uniswapV2Pair;
530     address public constant deadAddress = address(0xdead);
531 
532     bool private swapping;
533 
534     address public marketingWallet;
535     address public devWallet;
536 
537     uint256 public maxTransactionAmount;
538     uint256 public swapTokensAtAmount;
539     uint256 public maxWallet;
540 
541     uint256 public percentForLPBurn = 25; // 25 = .25%
542     bool public lpBurnEnabled = true;
543     uint256 public lpBurnFrequency = 3600 seconds;
544     uint256 public lastLpBurnTime;
545 
546     uint256 public manualBurnFrequency = 30 minutes;
547     uint256 public lastManualLpBurnTime;
548 
549     bool public limitsInEffect = true;
550     bool public tradingActive = false;
551     bool public swapEnabled = false;
552 
553     mapping(address => uint256) private _holderLastTransferTimestamp; 
554     bool public transferDelayEnabled = true;
555 
556     uint256 public buyTotalFees;
557     uint256 public buyMarketingFee;
558     uint256 public buyLiquidityFee;
559     uint256 public buyDevFee;
560 
561     uint256 public sellTotalFees;
562     uint256 public sellMarketingFee;
563     uint256 public sellLiquidityFee;
564     uint256 public sellDevFee;
565 
566     uint256 public tokensForMarketing;
567     uint256 public tokensForLiquidity;
568     uint256 public tokensForDev;
569     mapping(address => bool) private _isExcludedFromFees;
570     mapping(address => bool) public _isExcludedMaxTransactionAmount;
571     mapping(address => bool) public automatedMarketMakerPairs;
572 
573     event UpdateUniswapV2Router(
574         address indexed newAddress,
575         address indexed oldAddress
576     );
577 
578     event ExcludeFromFees(address indexed account, bool isExcluded);
579 
580     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
581 
582     event marketingWalletUpdated(
583         address indexed newWallet,
584         address indexed oldWallet
585     );
586 
587     event devWalletUpdated(
588         address indexed newWallet,
589         address indexed oldWallet
590     );
591 
592     event SwapAndLiquify(
593         uint256 tokensSwapped,
594         uint256 ethReceived,
595         uint256 tokensIntoLiquidity
596     );
597 
598     event AutoNukeLP();
599 
600     event ManualNukeLP();
601 
602     constructor() ERC20("The Young Devil", "LUCIFER") {
603         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
604             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
605         );
606 
607         excludeFromMaxTransaction(address(_uniswapV2Router), true);
608         uniswapV2Router = _uniswapV2Router;
609 
610         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
611             .createPair(address(this), _uniswapV2Router.WETH());
612         excludeFromMaxTransaction(address(uniswapV2Pair), true);
613         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
614 
615         uint256 _buyMarketingFee = 0;
616         uint256 _buyLiquidityFee = 0;
617         uint256 _buyDevFee = 0;
618 
619         uint256 _sellMarketingFee = 0;
620         uint256 _sellLiquidityFee = 0;
621         uint256 _sellDevFee = 0;
622 
623         uint256 totalSupply = 1_000_000_000 * 1e18;
624 
625         maxTransactionAmount = 30_000_000 * 1e18;
626         maxWallet = 30_000_000 * 1e18;
627         swapTokensAtAmount = (totalSupply * 5) / 10000;
628 
629         buyMarketingFee = _buyMarketingFee;
630         buyLiquidityFee = _buyLiquidityFee;
631         buyDevFee = _buyDevFee;
632         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
633 
634         sellMarketingFee = _sellMarketingFee;
635         sellLiquidityFee = _sellLiquidityFee;
636         sellDevFee = _sellDevFee;
637         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
638 
639         marketingWallet = address(0x61A8f96B9AD0e0C9E10506266e66E8f92ab3eD75);
640         devWallet = address(0x61A8f96B9AD0e0C9E10506266e66E8f92ab3eD75);
641 
642         excludeFromFees(owner(), true);
643         excludeFromFees(address(this), true);
644         excludeFromFees(address(0xdead), true);
645 
646         excludeFromMaxTransaction(owner(), true);
647         excludeFromMaxTransaction(address(this), true);
648         excludeFromMaxTransaction(address(0xdead), true);
649         _mint(msg.sender, totalSupply);
650     }
651 
652     receive() external payable {}
653 
654     function enableTrading() external onlyOwner {
655         tradingActive = true;
656         swapEnabled = true;
657         lastLpBurnTime = block.timestamp;
658     }
659 
660     function removeLimits() external onlyOwner returns (bool) {
661         limitsInEffect = false;
662         return true;
663     }
664 
665     function disableTransferDelay() external onlyOwner returns (bool) {
666         transferDelayEnabled = false;
667         return true;
668     }
669 
670     function updateSwapTokensAtAmount(uint256 newAmount)
671         external
672         onlyOwner
673         returns (bool)
674     {
675         require(
676             newAmount >= (totalSupply() * 1) / 100000,
677             "Swap amount cannot be lower than 0.001% total supply."
678         );
679         require(
680             newAmount <= (totalSupply() * 5) / 1000,
681             "Swap amount cannot be higher than 0.5% total supply."
682         );
683         swapTokensAtAmount = newAmount;
684         return true;
685     }
686 
687     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
688         require(
689             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
690             "Cannot set maxTransactionAmount lower than 0.1%"
691         );
692         maxTransactionAmount = newNum * (10**18);
693     }
694 
695     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
696         require(
697             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
698             "Cannot set maxWallet lower than 0.5%"
699         );
700         maxWallet = newNum * (10**18);
701     }
702 
703     function excludeFromMaxTransaction(address updAds, bool isEx)
704         public
705         onlyOwner
706     {
707         _isExcludedMaxTransactionAmount[updAds] = isEx;
708     }
709 
710     function updateSwapEnabled(bool enabled) external onlyOwner {
711         swapEnabled = enabled;
712     }
713 
714     function updateBuyFees(
715         uint256 _marketingFee,
716         uint256 _liquidityFee,
717         uint256 _devFee
718     ) external onlyOwner {
719         buyMarketingFee = _marketingFee;
720         buyLiquidityFee = _liquidityFee;
721         buyDevFee = _devFee;
722         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
723         require(buyTotalFees <= 9, "Must keep fees at 11% or less");
724     }
725 
726     function updateSellFees(
727         uint256 _marketingFee,
728         uint256 _liquidityFee,
729         uint256 _devFee
730     ) external onlyOwner {
731         sellMarketingFee = _marketingFee;
732         sellLiquidityFee = _liquidityFee;
733         sellDevFee = _devFee;
734         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
735         require(sellTotalFees <= 13, "Must keep fees at 11% or less");
736     }
737 
738     function excludeFromFees(address account, bool excluded) public onlyOwner {
739         _isExcludedFromFees[account] = excluded;
740         emit ExcludeFromFees(account, excluded);
741     }
742 
743     function setAutomatedMarketMakerPair(address pair, bool value)
744         public
745         onlyOwner
746     {
747         require(
748             pair != uniswapV2Pair,
749             "The pair cannot be removed from automatedMarketMakerPairs"
750         );
751 
752         _setAutomatedMarketMakerPair(pair, value);
753     }
754 
755     function _setAutomatedMarketMakerPair(address pair, bool value) private {
756         automatedMarketMakerPairs[pair] = value;
757 
758         emit SetAutomatedMarketMakerPair(pair, value);
759     }
760 
761     function updateMarketingWallet(address newMarketingWallet)
762         external
763         onlyOwner
764     {
765         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
766         marketingWallet = newMarketingWallet;
767     }
768 
769     function updateDevWallet(address newWallet) external onlyOwner {
770         emit devWalletUpdated(newWallet, devWallet);
771         devWallet = newWallet;
772     }
773 
774     function isExcludedFromFees(address account) public view returns (bool) {
775         return _isExcludedFromFees[account];
776     }
777 
778     event BoughtEarly(address indexed sniper);
779 
780     function _transfer(
781         address from,
782         address to,
783         uint256 amount
784     ) internal override {
785         require(from != address(0), "ERC20: transfer from the zero address");
786         require(to != address(0), "ERC20: transfer to the zero address");
787 
788         if (amount == 0) {
789             super._transfer(from, to, 0);
790             return;
791         }
792 
793         if (limitsInEffect) {
794             if (
795                 from != owner() &&
796                 to != owner() &&
797                 to != address(0) &&
798                 to != address(0xdead) &&
799                 !swapping
800             ) {
801                 if (!tradingActive) {
802                     require(
803                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
804                         "Trading is not active."
805                     );
806                 }
807 
808                 if (transferDelayEnabled) {
809                     if (
810                         to != owner() &&
811                         to != address(uniswapV2Router) &&
812                         to != address(uniswapV2Pair)
813                     ) {
814                         require(
815                             _holderLastTransferTimestamp[tx.origin] <
816                                 block.number,
817                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
818                         );
819                         _holderLastTransferTimestamp[tx.origin] = block.number;
820                     }
821                 }
822 
823                 if (
824                     automatedMarketMakerPairs[from] &&
825                     !_isExcludedMaxTransactionAmount[to]
826                 ) {
827                     require(
828                         amount <= maxTransactionAmount,
829                         "Buy transfer amount exceeds the maxTransactionAmount."
830                     );
831                     require(
832                         amount + balanceOf(to) <= maxWallet,
833                         "Max wallet exceeded"
834                     );
835                 }
836                 else if (
837                     automatedMarketMakerPairs[to] &&
838                     !_isExcludedMaxTransactionAmount[from]
839                 ) {
840                     require(
841                         amount <= maxTransactionAmount,
842                         "Sell transfer amount exceeds the maxTransactionAmount."
843                     );
844                 } else if (!_isExcludedMaxTransactionAmount[to]) {
845                     require(
846                         amount + balanceOf(to) <= maxWallet,
847                         "Max wallet exceeded"
848                     );
849                 }
850             }
851         }
852 
853         uint256 contractTokenBalance = balanceOf(address(this));
854 
855         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
856 
857         if (
858             canSwap &&
859             swapEnabled &&
860             !swapping &&
861             !automatedMarketMakerPairs[from] &&
862             !_isExcludedFromFees[from] &&
863             !_isExcludedFromFees[to]
864         ) {
865             swapping = true;
866 
867             swapBack();
868 
869             swapping = false;
870         }
871 
872         if (
873             !swapping &&
874             automatedMarketMakerPairs[to] &&
875             lpBurnEnabled &&
876             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
877             !_isExcludedFromFees[from]
878         ) {
879             autoBurnLiquidityPairTokens();
880         }
881 
882         bool takeFee = !swapping;
883 
884         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
885             takeFee = false;
886         }
887 
888         uint256 fees = 0;
889         if (takeFee) {
890             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
891                 fees = amount.mul(sellTotalFees).div(100);
892                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
893                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
894                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
895             }
896             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
897                 fees = amount.mul(buyTotalFees).div(100);
898                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
899                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
900                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
901             }
902 
903             if (fees > 0) {
904                 super._transfer(from, address(this), fees);
905             }
906 
907             amount -= fees;
908         }
909 
910         super._transfer(from, to, amount);
911     }
912 
913     function swapTokensForEth(uint256 tokenAmount) private {
914         address[] memory path = new address[](2);
915         path[0] = address(this);
916         path[1] = uniswapV2Router.WETH();
917 
918         _approve(address(this), address(uniswapV2Router), tokenAmount);
919 
920         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
921             tokenAmount,
922             0,
923             path,
924             address(this),
925             block.timestamp
926         );
927     }
928 
929     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
930         _approve(address(this), address(uniswapV2Router), tokenAmount);
931 
932         uniswapV2Router.addLiquidityETH{value: ethAmount}(
933             address(this),
934             tokenAmount,
935             0,
936             0,
937             deadAddress,
938             block.timestamp
939         );
940     }
941 
942     function swapBack() private {
943         uint256 contractBalance = balanceOf(address(this));
944         uint256 totalTokensToSwap = tokensForLiquidity +
945             tokensForMarketing +
946             tokensForDev;
947         bool success;
948 
949         if (contractBalance == 0 || totalTokensToSwap == 0) {
950             return;
951         }
952 
953         if (contractBalance > swapTokensAtAmount * 20) {
954             contractBalance = swapTokensAtAmount * 20;
955         }
956 
957         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
958             totalTokensToSwap /
959             2;
960         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
961 
962         uint256 initialETHBalance = address(this).balance;
963 
964         swapTokensForEth(amountToSwapForETH);
965 
966         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
967 
968         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
969             totalTokensToSwap
970         );
971         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
972 
973         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
974 
975         tokensForLiquidity = 0;
976         tokensForMarketing = 0;
977         tokensForDev = 0;
978 
979         (success, ) = address(devWallet).call{value: ethForDev}("");
980 
981         if (liquidityTokens > 0 && ethForLiquidity > 0) {
982             addLiquidity(liquidityTokens, ethForLiquidity);
983             emit SwapAndLiquify(
984                 amountToSwapForETH,
985                 ethForLiquidity,
986                 tokensForLiquidity
987             );
988         }
989 
990         (success, ) = address(marketingWallet).call{
991             value: address(this).balance
992         }("");
993     }
994 
995     function setAutoLPBurnSettings(
996         uint256 _frequencyInSeconds,
997         uint256 _percent,
998         bool _Enabled
999     ) external onlyOwner {
1000         require(
1001             _frequencyInSeconds >= 600,
1002             "cannot set buyback more often than every 10 minutes"
1003         );
1004         require(
1005             _percent <= 1000 && _percent >= 0,
1006             "Must set auto LP burn percent between 0% and 10%"
1007         );
1008         lpBurnFrequency = _frequencyInSeconds;
1009         percentForLPBurn = _percent;
1010         lpBurnEnabled = _Enabled;
1011     }
1012 
1013     function autoBurnLiquidityPairTokens() internal returns (bool) {
1014         lastLpBurnTime = block.timestamp;
1015 
1016         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1017         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1018             10000
1019         );
1020 
1021         if (amountToBurn > 0) {
1022             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1023         }
1024 
1025         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1026         pair.sync();
1027         emit AutoNukeLP();
1028         return true;
1029     }
1030 
1031     function manualBurnLiquidityPairTokens(uint256 percent)
1032         external
1033         onlyOwner
1034         returns (bool)
1035     {
1036         require(
1037             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1038             "Must wait for cooldown to finish"
1039         );
1040         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1041         lastManualLpBurnTime = block.timestamp;
1042 
1043         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1044 
1045         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1046 
1047         if (amountToBurn > 0) {
1048             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1049         }
1050 
1051         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1052         pair.sync();
1053         emit ManualNukeLP();
1054         return true;
1055     }
1056 }