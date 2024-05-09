1 //TW:https://twitter.com/poor_erc20 
2 //TG:https://t.me/poor_portal
3 // SPDX-License-Identifier: MIT
4 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
5 pragma experimental ABIEncoderV2;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes calldata) {
13         return msg.data;
14     }
15 }
16 
17 abstract contract Ownable is Context {
18     address private _owner;
19 
20     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22     constructor() {
23         _transferOwnership(_msgSender());
24     }
25 
26     function owner() public view virtual returns (address) {
27         return _owner;
28     }
29 
30     modifier onlyOwner() {
31         require(owner() == _msgSender(), "Ownable: caller is not the owner");
32         _;
33     }
34 
35 
36     function renounceOwnership() public virtual onlyOwner {
37         _transferOwnership(address(0));
38     }
39 
40     function transferOwnership(address newOwner) public virtual onlyOwner {
41         require(newOwner != address(0), "Ownable: new owner is the zero address");
42         _transferOwnership(newOwner);
43     }
44 
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
56 
57     function balanceOf(address account) external view returns (uint256);
58 
59 
60     function transfer(address recipient, uint256 amount) external returns (bool);
61 
62 
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     function approve(address spender, uint256 amount) external returns (bool);
66 
67 
68     function transferFrom(
69         address sender,
70         address recipient,
71         uint256 amount
72     ) external returns (bool);
73 
74 
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 interface IERC20Metadata is IERC20 {
81 
82     function name() external view returns (string memory);
83 
84     function symbol() external view returns (string memory);
85 
86     function decimals() external view returns (uint8);
87 }
88 
89 
90 contract ERC20 is Context, IERC20, IERC20Metadata {
91     mapping(address => uint256) private _balances;
92 
93     mapping(address => mapping(address => uint256)) private _allowances;
94 
95     uint256 private _totalSupply;
96 
97     string private _name;
98     string private _symbol;
99 
100 
101     constructor(string memory name_, string memory symbol_) {
102         _name = name_;
103         _symbol = symbol_;
104     }
105 
106 
107     function name() public view virtual override returns (string memory) {
108         return _name;
109     }
110 
111 
112     function symbol() public view virtual override returns (string memory) {
113         return _symbol;
114     }
115 
116 
117     function decimals() public view virtual override returns (uint8) {
118         return 18;
119     }
120 
121 
122     function totalSupply() public view virtual override returns (uint256) {
123         return _totalSupply;
124     }
125 
126     function balanceOf(address account) public view virtual override returns (uint256) {
127         return _balances[account];
128     }
129 
130     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
131         _transfer(_msgSender(), recipient, amount);
132         return true;
133     }
134 
135 
136     function allowance(address owner, address spender) public view virtual override returns (uint256) {
137         return _allowances[owner][spender];
138     }
139 
140     function approve(address spender, uint256 amount) public virtual override returns (bool) {
141         _approve(_msgSender(), spender, amount);
142         return true;
143     }
144 
145     function transferFrom(
146         address sender,
147         address recipient,
148         uint256 amount
149     ) public virtual override returns (bool) {
150         _transfer(sender, recipient, amount);
151 
152         uint256 currentAllowance = _allowances[sender][_msgSender()];
153         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
154         unchecked {
155             _approve(sender, _msgSender(), currentAllowance - amount);
156         }
157 
158         return true;
159     }
160 
161     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
162         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
163         return true;
164     }
165 
166     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
167         uint256 currentAllowance = _allowances[_msgSender()][spender];
168         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
169         unchecked {
170             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
171         }
172 
173         return true;
174     }
175 
176     function _transfer(
177         address sender,
178         address recipient,
179         uint256 amount
180     ) internal virtual {
181         require(sender != address(0), "ERC20: transfer from the zero address");
182         require(recipient != address(0), "ERC20: transfer to the zero address");
183 
184         _beforeTokenTransfer(sender, recipient, amount);
185 
186         uint256 senderBalance = _balances[sender];
187         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
188         unchecked {
189             _balances[sender] = senderBalance - amount;
190         }
191         _balances[recipient] += amount;
192 
193         emit Transfer(sender, recipient, amount);
194 
195         _afterTokenTransfer(sender, recipient, amount);
196     }
197 
198     function _mint(address account, uint256 amount) internal virtual {
199         require(account != address(0), "ERC20: mint to the zero address");
200 
201         _beforeTokenTransfer(address(0), account, amount);
202 
203         _totalSupply += amount;
204         _balances[account] += amount;
205         emit Transfer(address(0), account, amount);
206 
207         _afterTokenTransfer(address(0), account, amount);
208     }
209 
210     function _burn(address account, uint256 amount) internal virtual {
211         require(account != address(0), "ERC20: burn from the zero address");
212 
213         _beforeTokenTransfer(account, address(0), amount);
214 
215         uint256 accountBalance = _balances[account];
216         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
217         unchecked {
218             _balances[account] = accountBalance - amount;
219         }
220         _totalSupply -= amount;
221 
222         emit Transfer(account, address(0), amount);
223 
224         _afterTokenTransfer(account, address(0), amount);
225     }
226 
227     function _approve(
228         address owner,
229         address spender,
230         uint256 amount
231     ) internal virtual {
232         require(owner != address(0), "ERC20: approve from the zero address");
233         require(spender != address(0), "ERC20: approve to the zero address");
234 
235         _allowances[owner][spender] = amount;
236         emit Approval(owner, spender, amount);
237     }
238 
239     function _beforeTokenTransfer(
240         address from,
241         address to,
242         uint256 amount
243     ) internal virtual {}
244 
245     function _afterTokenTransfer(
246         address from,
247         address to,
248         uint256 amount
249     ) internal virtual {}
250 }
251 
252 
253 library SafeMath {
254 
255     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
256         unchecked {
257             uint256 c = a + b;
258             if (c < a) return (false, 0);
259             return (true, c);
260         }
261     }
262 
263     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
264         unchecked {
265             if (b > a) return (false, 0);
266             return (true, a - b);
267         }
268     }
269 
270 
271     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
272         unchecked {
273             if (a == 0) return (true, 0);
274             uint256 c = a * b;
275             if (c / a != b) return (false, 0);
276             return (true, c);
277         }
278     }
279 
280     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
281         unchecked {
282             if (b == 0) return (false, 0);
283             return (true, a / b);
284         }
285     }
286 
287     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
288         unchecked {
289             if (b == 0) return (false, 0);
290             return (true, a % b);
291         }
292     }
293 
294 
295     function add(uint256 a, uint256 b) internal pure returns (uint256) {
296         return a + b;
297     }
298 
299     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
300         return a - b;
301     }
302 
303     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
304         return a * b;
305     }
306 
307     function div(uint256 a, uint256 b) internal pure returns (uint256) {
308         return a / b;
309     }
310 
311     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
312         return a % b;
313     }
314 
315     function sub(
316         uint256 a,
317         uint256 b,
318         string memory errorMessage
319     ) internal pure returns (uint256) {
320         unchecked {
321             require(b <= a, errorMessage);
322             return a - b;
323         }
324     }
325 
326     function div(
327         uint256 a,
328         uint256 b,
329         string memory errorMessage
330     ) internal pure returns (uint256) {
331         unchecked {
332             require(b > 0, errorMessage);
333             return a / b;
334         }
335     }
336 
337 
338     function mod(
339         uint256 a,
340         uint256 b,
341         string memory errorMessage
342     ) internal pure returns (uint256) {
343         unchecked {
344             require(b > 0, errorMessage);
345             return a % b;
346         }
347     }
348 }
349 
350 
351 interface IUniswapV2Factory {
352     event PairCreated(
353         address indexed token0,
354         address indexed token1,
355         address pair,
356         uint256
357     );
358 
359     function feeTo() external view returns (address);
360 
361     function feeToSetter() external view returns (address);
362 
363     function getPair(address tokenA, address tokenB)
364         external
365         view
366         returns (address pair);
367 
368     function allPairs(uint256) external view returns (address pair);
369 
370     function allPairsLength() external view returns (uint256);
371 
372     function createPair(address tokenA, address tokenB)
373         external
374         returns (address pair);
375 
376     function setFeeTo(address) external;
377 
378     function setFeeToSetter(address) external;
379 }
380 
381 
382 interface IUniswapV2Pair {
383     event Approval(
384         address indexed owner,
385         address indexed spender,
386         uint256 value
387     );
388     event Transfer(address indexed from, address indexed to, uint256 value);
389 
390     function name() external pure returns (string memory);
391 
392     function symbol() external pure returns (string memory);
393 
394     function decimals() external pure returns (uint8);
395 
396     function totalSupply() external view returns (uint256);
397 
398     function balanceOf(address owner) external view returns (uint256);
399 
400     function allowance(address owner, address spender)
401         external
402         view
403         returns (uint256);
404 
405     function approve(address spender, uint256 value) external returns (bool);
406 
407     function transfer(address to, uint256 value) external returns (bool);
408 
409     function transferFrom(
410         address from,
411         address to,
412         uint256 value
413     ) external returns (bool);
414 
415     function DOMAIN_SEPARATOR() external view returns (bytes32);
416 
417     function PERMIT_TYPEHASH() external pure returns (bytes32);
418 
419     function nonces(address owner) external view returns (uint256);
420 
421     function permit(
422         address owner,
423         address spender,
424         uint256 value,
425         uint256 deadline,
426         uint8 v,
427         bytes32 r,
428         bytes32 s
429     ) external;
430 
431     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
432     event Burn(
433         address indexed sender,
434         uint256 amount0,
435         uint256 amount1,
436         address indexed to
437     );
438     event Swap(
439         address indexed sender,
440         uint256 amount0In,
441         uint256 amount1In,
442         uint256 amount0Out,
443         uint256 amount1Out,
444         address indexed to
445     );
446     event Sync(uint112 reserve0, uint112 reserve1);
447 
448     function MINIMUM_LIQUIDITY() external pure returns (uint256);
449 
450     function factory() external view returns (address);
451 
452     function token0() external view returns (address);
453 
454     function token1() external view returns (address);
455 
456     function getReserves()
457         external
458         view
459         returns (
460             uint112 reserve0,
461             uint112 reserve1,
462             uint32 blockTimestampLast
463         );
464 
465     function price0CumulativeLast() external view returns (uint256);
466 
467     function price1CumulativeLast() external view returns (uint256);
468 
469     function kLast() external view returns (uint256);
470 
471     function mint(address to) external returns (uint256 liquidity);
472 
473     function burn(address to)
474         external
475         returns (uint256 amount0, uint256 amount1);
476 
477     function swap(
478         uint256 amount0Out,
479         uint256 amount1Out,
480         address to,
481         bytes calldata data
482     ) external;
483 
484     function skim(address to) external;
485 
486     function sync() external;
487 
488     function initialize(address, address) external;
489 }
490 
491 
492 interface IUniswapV2Router02 {
493     function factory() external pure returns (address);
494 
495     function WETH() external pure returns (address);
496 
497     function addLiquidity(
498         address tokenA,
499         address tokenB,
500         uint256 amountADesired,
501         uint256 amountBDesired,
502         uint256 amountAMin,
503         uint256 amountBMin,
504         address to,
505         uint256 deadline
506     )
507         external
508         returns (
509             uint256 amountA,
510             uint256 amountB,
511             uint256 liquidity
512         );
513 
514     function addLiquidityETH(
515         address token,
516         uint256 amountTokenDesired,
517         uint256 amountTokenMin,
518         uint256 amountETHMin,
519         address to,
520         uint256 deadline
521     )
522         external
523         payable
524         returns (
525             uint256 amountToken,
526             uint256 amountETH,
527             uint256 liquidity
528         );
529 
530     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
531         uint256 amountIn,
532         uint256 amountOutMin,
533         address[] calldata path,
534         address to,
535         uint256 deadline
536     ) external;
537 
538     function swapExactETHForTokensSupportingFeeOnTransferTokens(
539         uint256 amountOutMin,
540         address[] calldata path,
541         address to,
542         uint256 deadline
543     ) external payable;
544 
545     function swapExactTokensForETHSupportingFeeOnTransferTokens(
546         uint256 amountIn,
547         uint256 amountOutMin,
548         address[] calldata path,
549         address to,
550         uint256 deadline
551     ) external;
552 }
553 
554 
555 contract POOR is ERC20, Ownable {
556     using SafeMath for uint256;
557 
558     IUniswapV2Router02 public immutable uniswapV2Router;
559     address public immutable uniswapV2Pair;
560     address public constant deadAddress = address(0xdead);
561 
562     bool private swapping;
563 
564     address private marketingWallet;
565     address private developmentWallet;
566 
567     uint256 public maxTransactionAmount;
568     uint256 public swapTokensAtAmount;
569     uint256 public maxWallet;
570 
571     uint256 public percentForLPBurn = 0; 
572     bool public lpBurnEnabled = false;
573     uint256 public lpBurnFrequency = 3600 seconds;
574     uint256 public lastLpBurnTime;
575 
576     uint256 public manualBurnFrequency = 30 minutes;
577     uint256 public lastManualLpBurnTime;
578 
579     bool public limitsInEffect = true;
580     bool public tradingActive = false;
581     bool public swapEnabled = true;
582 
583     mapping(address => uint256) private _holderLastTransferTimestamp; 
584     bool public transferDelayEnabled = true;
585 
586     uint256 public buyTotalFees;
587     uint256 public buyMarketingFee;
588     uint256 public buyLiquidityFee;
589     uint256 public buyDevelopmentFee;
590 
591     uint256 public sellTotalFees;
592     uint256 public sellMarketingFee;
593     uint256 public sellLiquidityFee;
594     uint256 public sellDevelopmentFee;
595 
596     uint256 public tokensForMarketing;
597     uint256 public tokensForLiquidity;
598     uint256 public tokensForDev;
599 
600     mapping(address => bool) private _isExcludedFromFees;
601     mapping(address => bool) public _isExcludedMaxTransactionAmount;
602 
603     mapping(address => bool) public automatedMarketMakerPairs;
604 
605     event UpdateUniswapV2Router(
606         address indexed newAddress,
607         address indexed oldAddress
608     );
609 
610     event ExcludeFromFees(address indexed account, bool isExcluded);
611 
612     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
613 
614     event marketingWalletUpdated(
615         address indexed newWallet,
616         address indexed oldWallet
617     );
618 
619     event developmentWalletUpdated(
620         address indexed newWallet,
621         address indexed oldWallet
622     );
623 
624     event SwapAndLiquify(
625         uint256 tokensSwapped,
626         uint256 ethReceived,
627         uint256 tokensIntoLiquidity
628     );
629 
630     event AutoNukeLP();
631 
632     event ManualNukeLP();
633 
634     constructor() ERC20("POOR", "POOR") {
635         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
636             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
637         );
638 
639         excludeFromMaxTransaction(address(_uniswapV2Router), true);
640         uniswapV2Router = _uniswapV2Router;
641 
642         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
643             .createPair(address(this), _uniswapV2Router.WETH());
644         excludeFromMaxTransaction(address(uniswapV2Pair), true);
645         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
646 
647         uint256 _buyMarketingFee = 15;
648         uint256 _buyLiquidityFee = 0;
649         uint256 _buyDevelopmentFee = 15;
650 
651         uint256 _sellMarketingFee = 28;
652         uint256 _sellLiquidityFee = 0;
653         uint256 _sellDevelopmentFee = 7;
654 
655         uint256 totalSupply = 100_000_000 * 1e18;
656 
657         maxTransactionAmount = 1_500_000 * 1e18; 
658         maxWallet = 2_000_000 * 1e18; 
659         swapTokensAtAmount = (totalSupply * 10) / 10000;
660 
661         buyMarketingFee = _buyMarketingFee;
662         buyLiquidityFee = _buyLiquidityFee;
663         buyDevelopmentFee = _buyDevelopmentFee;
664         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
665 
666         sellMarketingFee = _sellMarketingFee;
667         sellLiquidityFee = _sellLiquidityFee;
668         sellDevelopmentFee = _sellDevelopmentFee;
669         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
670 
671         marketingWallet = address(0x4C176152C744aFa2CD6334c9E4D00F69242160Ce); 
672         developmentWallet = address(0x4C176152C744aFa2CD6334c9E4D00F69242160Ce); 
673 
674         excludeFromFees(owner(), true);
675         excludeFromFees(address(this), true);
676         excludeFromFees(address(0xdead), true);
677 
678         excludeFromMaxTransaction(owner(), true);
679         excludeFromMaxTransaction(address(this), true);
680         excludeFromMaxTransaction(address(0xdead), true);
681 
682         _mint(msg.sender, totalSupply);
683     }
684 
685     receive() external payable {}
686 
687     function enableTrading() external onlyOwner {
688         tradingActive = true;
689         swapEnabled = true;
690         lastLpBurnTime = block.timestamp;
691     }
692 
693     function removeLimits() external onlyOwner returns (bool) {
694         limitsInEffect = false;
695         return true;
696     }
697 
698     function disableTransferDelay() external onlyOwner returns (bool) {
699         transferDelayEnabled = false;
700         return true;
701     }
702 
703     function updateSwapTokensAtAmount(uint256 newAmount)
704         external
705         onlyOwner
706         returns (bool)
707     {
708         require(
709             newAmount >= (totalSupply() * 1) / 100000,
710             "Swap amount cannot be lower than 0.001% total supply."
711         );
712         require(
713             newAmount <= (totalSupply() * 5) / 1000,
714             "Swap amount cannot be higher than 0.5% total supply."
715         );
716         swapTokensAtAmount = newAmount;
717         return true;
718     }
719 
720     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
721         require(
722             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
723             "Cannot set maxTransactionAmount lower than 0.1%"
724         );
725         maxTransactionAmount = newNum * (10**18);
726     }
727 
728     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
729         require(
730             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
731             "Cannot set maxWallet lower than 0.5%"
732         );
733         maxWallet = newNum * (10**18);
734     }
735 
736     function excludeFromMaxTransaction(address updAds, bool isEx)
737         public
738         onlyOwner
739     {
740         _isExcludedMaxTransactionAmount[updAds] = isEx;
741     }
742 
743     function updateSwapEnabled(bool enabled) external onlyOwner {
744         swapEnabled = enabled;
745     }
746 
747     function updateBuyFees(
748         uint256 _marketingFee,
749         uint256 _liquidityFee,
750         uint256 _developmentFee
751     ) external onlyOwner {
752         buyMarketingFee = _marketingFee;
753         buyLiquidityFee = _liquidityFee;
754         buyDevelopmentFee = _developmentFee;
755         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
756         require(buyTotalFees <= 35, "Must keep fees at 35% or less");
757     }
758 
759     function updateSellFees(
760         uint256 _marketingFee,
761         uint256 _liquidityFee,
762         uint256 _developmentFee
763     ) external onlyOwner {
764         sellMarketingFee = _marketingFee;
765         sellLiquidityFee = _liquidityFee;
766         sellDevelopmentFee = _developmentFee;
767         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
768         require(sellTotalFees <= 40, "Must keep fees at 40% or less");
769     }
770 
771     function excludeFromFees(address account, bool excluded) public onlyOwner {
772         _isExcludedFromFees[account] = excluded;
773         emit ExcludeFromFees(account, excluded);
774     }
775 
776     function setAutomatedMarketMakerPair(address pair, bool value)
777         public
778         onlyOwner
779     {
780         require(
781             pair != uniswapV2Pair,
782             "The pair cannot be removed from automatedMarketMakerPairs"
783         );
784 
785         _setAutomatedMarketMakerPair(pair, value);
786     }
787 
788     function _setAutomatedMarketMakerPair(address pair, bool value) private {
789         automatedMarketMakerPairs[pair] = value;
790 
791         emit SetAutomatedMarketMakerPair(pair, value);
792     }
793 
794     function updateMarketingWalletInfo(address newMarketingWallet)
795         external
796         onlyOwner
797     {
798         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
799         marketingWallet = newMarketingWallet;
800     }
801 
802     function updateDevelopmentWalletInfo(address newWallet) external onlyOwner {
803         emit developmentWalletUpdated(newWallet, developmentWallet);
804         developmentWallet = newWallet;
805     }
806 
807     function isExcludedFromFees(address account) public view returns (bool) {
808         return _isExcludedFromFees[account];
809     }
810 
811     event BoughtEarly(address indexed sniper);
812 
813     function _transfer(
814         address from,
815         address to,
816         uint256 amount
817     ) internal override {
818         require(from != address(0), "ERC20: transfer from the zero address");
819         require(to != address(0), "ERC20: transfer to the zero address");
820 
821         if (amount == 0) {
822             super._transfer(from, to, 0);
823             return;
824         }
825 
826         if (limitsInEffect) {
827             if (
828                 from != owner() &&
829                 to != owner() &&
830                 to != address(0) &&
831                 to != address(0xdead) &&
832                 !swapping
833             ) {
834                 if (!tradingActive) {
835                     require(
836                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
837                         "Trading is not active."
838                     );
839                 }
840 
841                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
842                 if (transferDelayEnabled) {
843                     if (
844                         to != owner() &&
845                         to != address(uniswapV2Router) &&
846                         to != address(uniswapV2Pair)
847                     ) {
848                         require(
849                             _holderLastTransferTimestamp[tx.origin] <
850                                 block.number,
851                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
852                         );
853                         _holderLastTransferTimestamp[tx.origin] = block.number;
854                     }
855                 }
856 
857                 //when buy
858                 if (
859                     automatedMarketMakerPairs[from] &&
860                     !_isExcludedMaxTransactionAmount[to]
861                 ) {
862                     require(
863                         amount <= maxTransactionAmount,
864                         "Buy transfer amount exceeds the maxTransactionAmount."
865                     );
866                     require(
867                         amount + balanceOf(to) <= maxWallet,
868                         "Max wallet exceeded"
869                     );
870                 }
871                 //when sell
872                 else if (
873                     automatedMarketMakerPairs[to] &&
874                     !_isExcludedMaxTransactionAmount[from]
875                 ) {
876                     require(
877                         amount <= maxTransactionAmount,
878                         "Sell transfer amount exceeds the maxTransactionAmount."
879                     );
880                 } else if (!_isExcludedMaxTransactionAmount[to]) {
881                     require(
882                         amount + balanceOf(to) <= maxWallet,
883                         "Max wallet exceeded"
884                     );
885                 }
886             }
887         }
888 
889         uint256 contractTokenBalance = balanceOf(address(this));
890 
891         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
892 
893         if (
894             canSwap &&
895             swapEnabled &&
896             !swapping &&
897             !automatedMarketMakerPairs[from] &&
898             !_isExcludedFromFees[from] &&
899             !_isExcludedFromFees[to]
900         ) {
901             swapping = true;
902 
903             swapBack();
904 
905             swapping = false;
906         }
907 
908         if (
909             !swapping &&
910             automatedMarketMakerPairs[to] &&
911             lpBurnEnabled &&
912             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
913             !_isExcludedFromFees[from]
914         ) {
915             autoBurnLiquidityPairTokens();
916         }
917 
918         bool takeFee = !swapping;
919 
920         // if any account belongs to _isExcludedFromFee account then remove the fee
921         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
922             takeFee = false;
923         }
924 
925         uint256 fees = 0;
926         // only take fees on buys/sells, do not take on wallet transfers
927         if (takeFee) {
928             // on sell
929             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
930                 fees = amount.mul(sellTotalFees).div(100);
931                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
932                 tokensForDev += (fees * sellDevelopmentFee) / sellTotalFees;
933                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
934             }
935             // on buy
936             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
937                 fees = amount.mul(buyTotalFees).div(100);
938                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
939                 tokensForDev += (fees * buyDevelopmentFee) / buyTotalFees;
940                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
941             }
942 
943             if (fees > 0) {
944                 super._transfer(from, address(this), fees);
945             }
946 
947             amount -= fees;
948         }
949 
950         super._transfer(from, to, amount);
951     }
952 
953     function swapTokensForEth(uint256 tokenAmount) private {
954         // generate the uniswap pair path of token -> weth
955         address[] memory path = new address[](2);
956         path[0] = address(this);
957         path[1] = uniswapV2Router.WETH();
958 
959         _approve(address(this), address(uniswapV2Router), tokenAmount);
960 
961         // make the swap
962         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
963             tokenAmount,
964             0, // accept any amount of ETH
965             path,
966             address(this),
967             block.timestamp
968         );
969     }
970 
971     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
972         // approve token transfer to cover all possible scenarios
973         _approve(address(this), address(uniswapV2Router), tokenAmount);
974 
975         // add the liquidity
976         uniswapV2Router.addLiquidityETH{value: ethAmount}(
977             address(this),
978             tokenAmount,
979             0, // slippage is unavoidable
980             0, // slippage is unavoidable
981             deadAddress,
982             block.timestamp
983         );
984     }
985 
986     function swapBack() private {
987         uint256 contractBalance = balanceOf(address(this));
988         uint256 totalTokensToSwap = tokensForLiquidity +
989             tokensForMarketing +
990             tokensForDev;
991         bool success;
992 
993         if (contractBalance == 0 || totalTokensToSwap == 0) {
994             return;
995         }
996 
997         if (contractBalance > swapTokensAtAmount * 20) {
998             contractBalance = swapTokensAtAmount * 20;
999         }
1000 
1001         // Halve the amount of liquidity tokens
1002         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1003             totalTokensToSwap /
1004             2;
1005         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1006 
1007         uint256 initialETHBalance = address(this).balance;
1008 
1009         swapTokensForEth(amountToSwapForETH);
1010 
1011         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1012 
1013         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1014             totalTokensToSwap
1015         );
1016         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1017 
1018         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1019 
1020         tokensForLiquidity = 0;
1021         tokensForMarketing = 0;
1022         tokensForDev = 0;
1023 
1024         (success, ) = address(developmentWallet).call{value: ethForDev}("");
1025 
1026         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1027             addLiquidity(liquidityTokens, ethForLiquidity);
1028             emit SwapAndLiquify(
1029                 amountToSwapForETH,
1030                 ethForLiquidity,
1031                 tokensForLiquidity
1032             );
1033         }
1034 
1035         (success, ) = address(marketingWallet).call{
1036             value: address(this).balance
1037         }("");
1038     }
1039 
1040     function setAutoLPBurnSettings(
1041         uint256 _frequencyInSeconds,
1042         uint256 _percent,
1043         bool _Enabled
1044     ) external onlyOwner {
1045         require(
1046             _frequencyInSeconds >= 600,
1047             "cannot set buyback more often than every 10 minutes"
1048         );
1049         require(
1050             _percent <= 1000 && _percent >= 0,
1051             "Must set auto LP burn percent between 0% and 10%"
1052         );
1053         lpBurnFrequency = _frequencyInSeconds;
1054         percentForLPBurn = _percent;
1055         lpBurnEnabled = _Enabled;
1056     }
1057 
1058     function autoBurnLiquidityPairTokens() internal returns (bool) {
1059         lastLpBurnTime = block.timestamp;
1060 
1061         // get balance of liquidity pair
1062         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1063 
1064         // calculate amount to burn
1065         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1066             10000
1067         );
1068 
1069         // pull tokens from pancakePair liquidity and move to dead address permanently
1070         if (amountToBurn > 0) {
1071             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1072         }
1073 
1074         //sync price since this is not in a swap transaction!
1075         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1076         pair.sync();
1077         emit AutoNukeLP();
1078         return true;
1079     }
1080 
1081     function manualBurnLiquidityPairTokens(uint256 percent)
1082         external
1083         onlyOwner
1084         returns (bool)
1085     {
1086         require(
1087             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1088             "Must wait for cooldown to finish"
1089         );
1090         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1091         lastManualLpBurnTime = block.timestamp;
1092 
1093         // get balance of liquidity pair
1094         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1095 
1096         // calculate amount to burn
1097         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1098 
1099         // pull tokens from pancakePair liquidity and move to dead address permanently
1100         if (amountToBurn > 0) {
1101             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1102         }
1103 
1104         //sync price since this is not in a swap transaction!
1105         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1106         pair.sync();
1107         emit ManualNukeLP();
1108         return true;
1109     }
1110 }