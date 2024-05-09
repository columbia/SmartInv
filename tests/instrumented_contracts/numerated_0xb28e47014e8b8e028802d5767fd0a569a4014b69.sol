1 /**
2 Pareidolia
3 Low tax community token made by a fellow degen.
4 9% Jeet tax on launch, reduced to 3% all to liquidity.
5 Liquidity will be burnt shortly after launch and ownership renounced once limits lifted. 
6 Please feel free to make a community telegram for Bobby.
7 */
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
11 pragma experimental ABIEncoderV2;
12 
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
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
57 interface IERC20 {
58     function totalSupply() external view returns (uint256);
59     function balanceOf(address account) external view returns (uint256);
60     function transfer(address recipient, uint256 amount) external returns (bool);
61     function allowance(address owner, address spender) external view returns (uint256);
62     function approve(address spender, uint256 amount) external returns (bool);
63 
64     function transferFrom(
65         address sender,
66         address recipient,
67         uint256 amount
68     ) external returns (bool);
69 
70     event Transfer(address indexed from, address indexed to, uint256 value);
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 interface IERC20Metadata is IERC20 {
75     function name() external view returns (string memory);
76     function symbol() external view returns (string memory);
77     function decimals() external view returns (uint8);
78 }
79 
80 contract ERC20 is Context, IERC20, IERC20Metadata {
81     mapping(address => uint256) private _balances;
82 
83     mapping(address => mapping(address => uint256)) private _allowances;
84 
85     uint256 private _totalSupply;
86 
87     string private _name;
88     string private _symbol;
89 
90     constructor(string memory name_, string memory symbol_) {
91         _name = name_;
92         _symbol = symbol_;
93     }
94 
95     function name() public view virtual override returns (string memory) {
96         return _name;
97     }
98 
99     function symbol() public view virtual override returns (string memory) {
100         return _symbol;
101     }
102 
103     function decimals() public view virtual override returns (uint8) {
104         return 18;
105     }
106     function totalSupply() public view virtual override returns (uint256) {
107         return _totalSupply;
108     }
109     function balanceOf(address account) public view virtual override returns (uint256) {
110         return _balances[account];
111     }
112 
113     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
114         _transfer(_msgSender(), recipient, amount);
115         return true;
116     }
117 
118     function allowance(address owner, address spender) public view virtual override returns (uint256) {
119         return _allowances[owner][spender];
120     }
121 
122     function approve(address spender, uint256 amount) public virtual override returns (bool) {
123         _approve(_msgSender(), spender, amount);
124         return true;
125     }
126 
127     function transferFrom(
128         address sender,
129         address recipient,
130         uint256 amount
131     ) public virtual override returns (bool) {
132         _transfer(sender, recipient, amount);
133 
134         uint256 currentAllowance = _allowances[sender][_msgSender()];
135         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
136         unchecked {
137             _approve(sender, _msgSender(), currentAllowance - amount);
138         }
139 
140         return true;
141     }
142 
143     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
144         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
145         return true;
146     }
147 
148     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
149         uint256 currentAllowance = _allowances[_msgSender()][spender];
150         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
151         unchecked {
152             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
153         }
154 
155         return true;
156     }
157 
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
193     function _burn(address account, uint256 amount) internal virtual {
194         require(account != address(0), "ERC20: burn from the zero address");
195 
196         _beforeTokenTransfer(account, address(0), amount);
197 
198         uint256 accountBalance = _balances[account];
199         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
200         unchecked {
201             _balances[account] = accountBalance - amount;
202         }
203         _totalSupply -= amount;
204 
205         emit Transfer(account, address(0), amount);
206 
207         _afterTokenTransfer(account, address(0), amount);
208     }
209 
210     function _approve(
211         address owner,
212         address spender,
213         uint256 amount
214     ) internal virtual {
215         require(owner != address(0), "ERC20: approve from the zero address");
216         require(spender != address(0), "ERC20: approve to the zero address");
217 
218         _allowances[owner][spender] = amount;
219         emit Approval(owner, spender, amount);
220     }
221 
222     function _beforeTokenTransfer(
223         address from,
224         address to,
225         uint256 amount
226     ) internal virtual {}
227 
228     function _afterTokenTransfer(
229         address from,
230         address to,
231         uint256 amount
232     ) internal virtual {}
233 }
234 
235 library SafeMath {
236     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
237         unchecked {
238             uint256 c = a + b;
239             if (c < a) return (false, 0);
240             return (true, c);
241         }
242     }
243 
244     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
245         unchecked {
246             if (b > a) return (false, 0);
247             return (true, a - b);
248         }
249     }
250 
251     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
252         unchecked {
253             if (a == 0) return (true, 0);
254             uint256 c = a * b;
255             if (c / a != b) return (false, 0);
256             return (true, c);
257         }
258     }
259 
260     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
261         unchecked {
262             if (b == 0) return (false, 0);
263             return (true, a / b);
264         }
265     }
266 
267     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
268         unchecked {
269             if (b == 0) return (false, 0);
270             return (true, a % b);
271         }
272     }
273 
274     function add(uint256 a, uint256 b) internal pure returns (uint256) {
275         return a + b;
276     }
277 
278     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
279         return a - b;
280     }
281 
282     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
283         return a * b;
284     }
285 
286     function div(uint256 a, uint256 b) internal pure returns (uint256) {
287         return a / b;
288     }
289 
290     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
291         return a % b;
292     }
293 
294     function sub(
295         uint256 a,
296         uint256 b,
297         string memory errorMessage
298     ) internal pure returns (uint256) {
299         unchecked {
300             require(b <= a, errorMessage);
301             return a - b;
302         }
303     }
304 
305     function div(
306         uint256 a,
307         uint256 b,
308         string memory errorMessage
309     ) internal pure returns (uint256) {
310         unchecked {
311             require(b > 0, errorMessage);
312             return a / b;
313         }
314     }
315 
316     function mod(
317         uint256 a,
318         uint256 b,
319         string memory errorMessage
320     ) internal pure returns (uint256) {
321         unchecked {
322             require(b > 0, errorMessage);
323             return a % b;
324         }
325     }
326 }
327 
328 interface IUniswapV2Factory {
329     event PairCreated(
330         address indexed token0,
331         address indexed token1,
332         address pair,
333         uint256
334     );
335 
336     function feeTo() external view returns (address);
337 
338     function feeToSetter() external view returns (address);
339 
340     function getPair(address tokenA, address tokenB)
341         external
342         view
343         returns (address pair);
344 
345     function allPairs(uint256) external view returns (address pair);
346 
347     function allPairsLength() external view returns (uint256);
348 
349     function createPair(address tokenA, address tokenB)
350         external
351         returns (address pair);
352 
353     function setFeeTo(address) external;
354 
355     function setFeeToSetter(address) external;
356 }
357 
358 interface IUniswapV2Pair {
359     event Approval(
360         address indexed owner,
361         address indexed spender,
362         uint256 value
363     );
364     event Transfer(address indexed from, address indexed to, uint256 value);
365 
366     function name() external pure returns (string memory);
367 
368     function symbol() external pure returns (string memory);
369 
370     function decimals() external pure returns (uint8);
371 
372     function totalSupply() external view returns (uint256);
373 
374     function balanceOf(address owner) external view returns (uint256);
375 
376     function allowance(address owner, address spender)
377         external
378         view
379         returns (uint256);
380 
381     function approve(address spender, uint256 value) external returns (bool);
382 
383     function transfer(address to, uint256 value) external returns (bool);
384 
385     function transferFrom(
386         address from,
387         address to,
388         uint256 value
389     ) external returns (bool);
390 
391     function DOMAIN_SEPARATOR() external view returns (bytes32);
392 
393     function PERMIT_TYPEHASH() external pure returns (bytes32);
394 
395     function nonces(address owner) external view returns (uint256);
396 
397     function permit(
398         address owner,
399         address spender,
400         uint256 value,
401         uint256 deadline,
402         uint8 v,
403         bytes32 r,
404         bytes32 s
405     ) external;
406 
407     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
408     event Burn(
409         address indexed sender,
410         uint256 amount0,
411         uint256 amount1,
412         address indexed to
413     );
414     event Swap(
415         address indexed sender,
416         uint256 amount0In,
417         uint256 amount1In,
418         uint256 amount0Out,
419         uint256 amount1Out,
420         address indexed to
421     );
422     event Sync(uint112 reserve0, uint112 reserve1);
423 
424     function MINIMUM_LIQUIDITY() external pure returns (uint256);
425 
426     function factory() external view returns (address);
427 
428     function token0() external view returns (address);
429 
430     function token1() external view returns (address);
431 
432     function getReserves()
433         external
434         view
435         returns (
436             uint112 reserve0,
437             uint112 reserve1,
438             uint32 blockTimestampLast
439         );
440 
441     function price0CumulativeLast() external view returns (uint256);
442 
443     function price1CumulativeLast() external view returns (uint256);
444 
445     function kLast() external view returns (uint256);
446 
447     function mint(address to) external returns (uint256 liquidity);
448 
449     function burn(address to)
450         external
451         returns (uint256 amount0, uint256 amount1);
452 
453     function swap(
454         uint256 amount0Out,
455         uint256 amount1Out,
456         address to,
457         bytes calldata data
458     ) external;
459 
460     function skim(address to) external;
461 
462     function sync() external;
463 
464     function initialize(address, address) external;
465 }
466 
467 
468 interface IUniswapV2Router02 {
469     function factory() external pure returns (address);
470 
471     function WETH() external pure returns (address);
472 
473     function addLiquidity(
474         address tokenA,
475         address tokenB,
476         uint256 amountADesired,
477         uint256 amountBDesired,
478         uint256 amountAMin,
479         uint256 amountBMin,
480         address to,
481         uint256 deadline
482     )
483         external
484         returns (
485             uint256 amountA,
486             uint256 amountB,
487             uint256 liquidity
488         );
489 
490     function addLiquidityETH(
491         address token,
492         uint256 amountTokenDesired,
493         uint256 amountTokenMin,
494         uint256 amountETHMin,
495         address to,
496         uint256 deadline
497     )
498         external
499         payable
500         returns (
501             uint256 amountToken,
502             uint256 amountETH,
503             uint256 liquidity
504         );
505 
506     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
507         uint256 amountIn,
508         uint256 amountOutMin,
509         address[] calldata path,
510         address to,
511         uint256 deadline
512     ) external;
513 
514     function swapExactETHForTokensSupportingFeeOnTransferTokens(
515         uint256 amountOutMin,
516         address[] calldata path,
517         address to,
518         uint256 deadline
519     ) external payable;
520 
521     function swapExactTokensForETHSupportingFeeOnTransferTokens(
522         uint256 amountIn,
523         uint256 amountOutMin,
524         address[] calldata path,
525         address to,
526         uint256 deadline
527     ) external;
528 }
529 
530 contract PAREIDOLIA is ERC20, Ownable {
531     using SafeMath for uint256;
532 
533     IUniswapV2Router02 public immutable uniswapV2Router;
534     address public immutable uniswapV2Pair;
535     address public constant deadAddress = address(0xdead);
536 
537     bool private swapping;
538 
539     address public marketingWallet;
540     address public devWallet;
541 
542     uint256 public maxTransactionAmount;
543     uint256 public swapTokensAtAmount;
544     uint256 public maxWallet;
545 
546     uint256 public percentForLPBurn = 25; // 25 = .25%
547     bool public lpBurnEnabled = true;
548     uint256 public lpBurnFrequency = 3600 seconds;
549     uint256 public lastLpBurnTime;
550 
551     uint256 public manualBurnFrequency = 30 minutes;
552     uint256 public lastManualLpBurnTime;
553 
554     bool public limitsInEffect = true;
555     bool public tradingActive = false;
556     bool public swapEnabled = false;
557 
558     mapping(address => uint256) private _holderLastTransferTimestamp; 
559     bool public transferDelayEnabled = true;
560 
561     uint256 public buyTotalFees;
562     uint256 public buyMarketingFee;
563     uint256 public buyLiquidityFee;
564     uint256 public buyDevFee;
565 
566     uint256 public sellTotalFees;
567     uint256 public sellMarketingFee;
568     uint256 public sellLiquidityFee;
569     uint256 public sellDevFee;
570 
571     uint256 public tokensForMarketing;
572     uint256 public tokensForLiquidity;
573     uint256 public tokensForDev;
574     mapping(address => bool) private _isExcludedFromFees;
575     mapping(address => bool) public _isExcludedMaxTransactionAmount;
576     mapping(address => bool) public automatedMarketMakerPairs;
577 
578     event UpdateUniswapV2Router(
579         address indexed newAddress,
580         address indexed oldAddress
581     );
582 
583     event ExcludeFromFees(address indexed account, bool isExcluded);
584 
585     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
586 
587     event marketingWalletUpdated(
588         address indexed newWallet,
589         address indexed oldWallet
590     );
591 
592     event devWalletUpdated(
593         address indexed newWallet,
594         address indexed oldWallet
595     );
596 
597     event SwapAndLiquify(
598         uint256 tokensSwapped,
599         uint256 ethReceived,
600         uint256 tokensIntoLiquidity
601     );
602 
603     event AutoNukeLP();
604 
605     event ManualNukeLP();
606 
607     constructor() ERC20("PAREIDOLIA", "PAREIDOLIA") {
608         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
609             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
610         );
611 
612         excludeFromMaxTransaction(address(_uniswapV2Router), true);
613         uniswapV2Router = _uniswapV2Router;
614 
615         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
616             .createPair(address(this), _uniswapV2Router.WETH());
617         excludeFromMaxTransaction(address(uniswapV2Pair), true);
618         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
619 
620         uint256 _buyMarketingFee = 4;
621         uint256 _buyLiquidityFee = 5;
622         uint256 _buyDevFee = 0;
623 
624         uint256 _sellMarketingFee = 4;
625         uint256 _sellLiquidityFee = 5;
626         uint256 _sellDevFee = 0;
627 
628         uint256 totalSupply = 1_000_000_000 * 1e18;
629 
630         maxTransactionAmount = 10_000_000 * 1e18;
631         maxWallet = 20_000_000 * 1e18;
632         swapTokensAtAmount = (totalSupply * 5) / 10000;
633 
634         buyMarketingFee = _buyMarketingFee;
635         buyLiquidityFee = _buyLiquidityFee;
636         buyDevFee = _buyDevFee;
637         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
638 
639         sellMarketingFee = _sellMarketingFee;
640         sellLiquidityFee = _sellLiquidityFee;
641         sellDevFee = _sellDevFee;
642         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
643 
644         marketingWallet = address(0xE20AEDc26B01Af39065d54ea692DF4Ce55E40182);
645         devWallet = address(0xE20AEDc26B01Af39065d54ea692DF4Ce55E40182);
646 
647         excludeFromFees(owner(), true);
648         excludeFromFees(address(this), true);
649         excludeFromFees(address(0xdead), true);
650 
651         excludeFromMaxTransaction(owner(), true);
652         excludeFromMaxTransaction(address(this), true);
653         excludeFromMaxTransaction(address(0xdead), true);
654         _mint(msg.sender, totalSupply);
655     }
656 
657     receive() external payable {}
658 
659     function enableTrading() external onlyOwner {
660         tradingActive = true;
661         swapEnabled = true;
662         lastLpBurnTime = block.timestamp;
663     }
664 
665     function removeLimits() external onlyOwner returns (bool) {
666         limitsInEffect = false;
667         return true;
668     }
669 
670     function disableTransferDelay() external onlyOwner returns (bool) {
671         transferDelayEnabled = false;
672         return true;
673     }
674 
675     function updateSwapTokensAtAmount(uint256 newAmount)
676         external
677         onlyOwner
678         returns (bool)
679     {
680         require(
681             newAmount >= (totalSupply() * 1) / 100000,
682             "Swap amount cannot be lower than 0.001% total supply."
683         );
684         require(
685             newAmount <= (totalSupply() * 5) / 1000,
686             "Swap amount cannot be higher than 0.5% total supply."
687         );
688         swapTokensAtAmount = newAmount;
689         return true;
690     }
691 
692     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
693         require(
694             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
695             "Cannot set maxTransactionAmount lower than 0.1%"
696         );
697         maxTransactionAmount = newNum * (10**18);
698     }
699 
700     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
701         require(
702             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
703             "Cannot set maxWallet lower than 0.5%"
704         );
705         maxWallet = newNum * (10**18);
706     }
707 
708     function excludeFromMaxTransaction(address updAds, bool isEx)
709         public
710         onlyOwner
711     {
712         _isExcludedMaxTransactionAmount[updAds] = isEx;
713     }
714 
715     function updateSwapEnabled(bool enabled) external onlyOwner {
716         swapEnabled = enabled;
717     }
718 
719     function updateBuyFees(
720         uint256 _marketingFee,
721         uint256 _liquidityFee,
722         uint256 _devFee
723     ) external onlyOwner {
724         buyMarketingFee = _marketingFee;
725         buyLiquidityFee = _liquidityFee;
726         buyDevFee = _devFee;
727         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
728         require(buyTotalFees <= 9, "Must keep fees at 11% or less");
729     }
730 
731     function updateSellFees(
732         uint256 _marketingFee,
733         uint256 _liquidityFee,
734         uint256 _devFee
735     ) external onlyOwner {
736         sellMarketingFee = _marketingFee;
737         sellLiquidityFee = _liquidityFee;
738         sellDevFee = _devFee;
739         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
740         require(sellTotalFees <= 13, "Must keep fees at 11% or less");
741     }
742 
743     function excludeFromFees(address account, bool excluded) public onlyOwner {
744         _isExcludedFromFees[account] = excluded;
745         emit ExcludeFromFees(account, excluded);
746     }
747 
748     function setAutomatedMarketMakerPair(address pair, bool value)
749         public
750         onlyOwner
751     {
752         require(
753             pair != uniswapV2Pair,
754             "The pair cannot be removed from automatedMarketMakerPairs"
755         );
756 
757         _setAutomatedMarketMakerPair(pair, value);
758     }
759 
760     function _setAutomatedMarketMakerPair(address pair, bool value) private {
761         automatedMarketMakerPairs[pair] = value;
762 
763         emit SetAutomatedMarketMakerPair(pair, value);
764     }
765 
766     function updateMarketingWallet(address newMarketingWallet)
767         external
768         onlyOwner
769     {
770         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
771         marketingWallet = newMarketingWallet;
772     }
773 
774     function updateDevWallet(address newWallet) external onlyOwner {
775         emit devWalletUpdated(newWallet, devWallet);
776         devWallet = newWallet;
777     }
778 
779     function isExcludedFromFees(address account) public view returns (bool) {
780         return _isExcludedFromFees[account];
781     }
782 
783     event BoughtEarly(address indexed sniper);
784 
785     function _transfer(
786         address from,
787         address to,
788         uint256 amount
789     ) internal override {
790         require(from != address(0), "ERC20: transfer from the zero address");
791         require(to != address(0), "ERC20: transfer to the zero address");
792 
793         if (amount == 0) {
794             super._transfer(from, to, 0);
795             return;
796         }
797 
798         if (limitsInEffect) {
799             if (
800                 from != owner() &&
801                 to != owner() &&
802                 to != address(0) &&
803                 to != address(0xdead) &&
804                 !swapping
805             ) {
806                 if (!tradingActive) {
807                     require(
808                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
809                         "Trading is not active."
810                     );
811                 }
812 
813                 if (transferDelayEnabled) {
814                     if (
815                         to != owner() &&
816                         to != address(uniswapV2Router) &&
817                         to != address(uniswapV2Pair)
818                     ) {
819                         require(
820                             _holderLastTransferTimestamp[tx.origin] <
821                                 block.number,
822                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
823                         );
824                         _holderLastTransferTimestamp[tx.origin] = block.number;
825                     }
826                 }
827 
828                 if (
829                     automatedMarketMakerPairs[from] &&
830                     !_isExcludedMaxTransactionAmount[to]
831                 ) {
832                     require(
833                         amount <= maxTransactionAmount,
834                         "Buy transfer amount exceeds the maxTransactionAmount."
835                     );
836                     require(
837                         amount + balanceOf(to) <= maxWallet,
838                         "Max wallet exceeded"
839                     );
840                 }
841                 else if (
842                     automatedMarketMakerPairs[to] &&
843                     !_isExcludedMaxTransactionAmount[from]
844                 ) {
845                     require(
846                         amount <= maxTransactionAmount,
847                         "Sell transfer amount exceeds the maxTransactionAmount."
848                     );
849                 } else if (!_isExcludedMaxTransactionAmount[to]) {
850                     require(
851                         amount + balanceOf(to) <= maxWallet,
852                         "Max wallet exceeded"
853                     );
854                 }
855             }
856         }
857 
858         uint256 contractTokenBalance = balanceOf(address(this));
859 
860         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
861 
862         if (
863             canSwap &&
864             swapEnabled &&
865             !swapping &&
866             !automatedMarketMakerPairs[from] &&
867             !_isExcludedFromFees[from] &&
868             !_isExcludedFromFees[to]
869         ) {
870             swapping = true;
871 
872             swapBack();
873 
874             swapping = false;
875         }
876 
877         if (
878             !swapping &&
879             automatedMarketMakerPairs[to] &&
880             lpBurnEnabled &&
881             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
882             !_isExcludedFromFees[from]
883         ) {
884             autoBurnLiquidityPairTokens();
885         }
886 
887         bool takeFee = !swapping;
888 
889         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
890             takeFee = false;
891         }
892 
893         uint256 fees = 0;
894         if (takeFee) {
895             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
896                 fees = amount.mul(sellTotalFees).div(100);
897                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
898                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
899                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
900             }
901             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
902                 fees = amount.mul(buyTotalFees).div(100);
903                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
904                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
905                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
906             }
907 
908             if (fees > 0) {
909                 super._transfer(from, address(this), fees);
910             }
911 
912             amount -= fees;
913         }
914 
915         super._transfer(from, to, amount);
916     }
917 
918     function swapTokensForEth(uint256 tokenAmount) private {
919         address[] memory path = new address[](2);
920         path[0] = address(this);
921         path[1] = uniswapV2Router.WETH();
922 
923         _approve(address(this), address(uniswapV2Router), tokenAmount);
924 
925         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
926             tokenAmount,
927             0,
928             path,
929             address(this),
930             block.timestamp
931         );
932     }
933 
934     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
935         _approve(address(this), address(uniswapV2Router), tokenAmount);
936 
937         uniswapV2Router.addLiquidityETH{value: ethAmount}(
938             address(this),
939             tokenAmount,
940             0,
941             0,
942             deadAddress,
943             block.timestamp
944         );
945     }
946 
947     function swapBack() private {
948         uint256 contractBalance = balanceOf(address(this));
949         uint256 totalTokensToSwap = tokensForLiquidity +
950             tokensForMarketing +
951             tokensForDev;
952         bool success;
953 
954         if (contractBalance == 0 || totalTokensToSwap == 0) {
955             return;
956         }
957 
958         if (contractBalance > swapTokensAtAmount * 20) {
959             contractBalance = swapTokensAtAmount * 20;
960         }
961 
962         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
963             totalTokensToSwap /
964             2;
965         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
966 
967         uint256 initialETHBalance = address(this).balance;
968 
969         swapTokensForEth(amountToSwapForETH);
970 
971         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
972 
973         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
974             totalTokensToSwap
975         );
976         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
977 
978         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
979 
980         tokensForLiquidity = 0;
981         tokensForMarketing = 0;
982         tokensForDev = 0;
983 
984         (success, ) = address(devWallet).call{value: ethForDev}("");
985 
986         if (liquidityTokens > 0 && ethForLiquidity > 0) {
987             addLiquidity(liquidityTokens, ethForLiquidity);
988             emit SwapAndLiquify(
989                 amountToSwapForETH,
990                 ethForLiquidity,
991                 tokensForLiquidity
992             );
993         }
994 
995         (success, ) = address(marketingWallet).call{
996             value: address(this).balance
997         }("");
998     }
999 
1000     function setAutoLPBurnSettings(
1001         uint256 _frequencyInSeconds,
1002         uint256 _percent,
1003         bool _Enabled
1004     ) external onlyOwner {
1005         require(
1006             _frequencyInSeconds >= 600,
1007             "cannot set buyback more often than every 10 minutes"
1008         );
1009         require(
1010             _percent <= 1000 && _percent >= 0,
1011             "Must set auto LP burn percent between 0% and 10%"
1012         );
1013         lpBurnFrequency = _frequencyInSeconds;
1014         percentForLPBurn = _percent;
1015         lpBurnEnabled = _Enabled;
1016     }
1017 
1018     function autoBurnLiquidityPairTokens() internal returns (bool) {
1019         lastLpBurnTime = block.timestamp;
1020 
1021         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1022         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1023             10000
1024         );
1025 
1026         if (amountToBurn > 0) {
1027             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1028         }
1029 
1030         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1031         pair.sync();
1032         emit AutoNukeLP();
1033         return true;
1034     }
1035 
1036     function manualBurnLiquidityPairTokens(uint256 percent)
1037         external
1038         onlyOwner
1039         returns (bool)
1040     {
1041         require(
1042             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1043             "Must wait for cooldown to finish"
1044         );
1045         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1046         lastManualLpBurnTime = block.timestamp;
1047 
1048         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1049 
1050         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1051 
1052         if (amountToBurn > 0) {
1053             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1054         }
1055 
1056         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1057         pair.sync();
1058         emit ManualNukeLP();
1059         return true;
1060     }
1061 }