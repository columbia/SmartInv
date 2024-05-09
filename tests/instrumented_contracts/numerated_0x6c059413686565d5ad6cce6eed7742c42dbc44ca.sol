1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
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
43 
44     function _transferOwnership(address newOwner) internal virtual {
45         address oldOwner = _owner;
46         _owner = newOwner;
47         emit OwnershipTransferred(oldOwner, newOwner);
48     }
49 }
50 
51 interface IERC20 {
52 
53     function totalSupply() external view returns (uint256);
54 
55     function balanceOf(address account) external view returns (uint256);
56 
57 
58     function transfer(address recipient, uint256 amount) external returns (bool);
59 
60 
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65 
66     function transferFrom(
67         address sender,
68         address recipient,
69         uint256 amount
70     ) external returns (bool);
71 
72 
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     /**
76      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
77      * a call to {approve}. `value` is the new allowance.
78      */
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 interface IERC20Metadata is IERC20 {
83 
84     function name() external view returns (string memory);
85 
86     function symbol() external view returns (string memory);
87 
88     function decimals() external view returns (uint8);
89 }
90 
91 
92 contract ERC20 is Context, IERC20, IERC20Metadata {
93     mapping(address => uint256) private _balances;
94 
95     mapping(address => mapping(address => uint256)) private _allowances;
96 
97     uint256 private _totalSupply;
98 
99     string private _name;
100     string private _symbol;
101 
102 
103     constructor(string memory name_, string memory symbol_) {
104         _name = name_;
105         _symbol = symbol_;
106     }
107 
108 
109     function name() public view virtual override returns (string memory) {
110         return _name;
111     }
112 
113 
114     function symbol() public view virtual override returns (string memory) {
115         return _symbol;
116     }
117 
118 
119     function decimals() public view virtual override returns (uint8) {
120         return 18;
121     }
122 
123 
124     function totalSupply() public view virtual override returns (uint256) {
125         return _totalSupply;
126     }
127 
128     function balanceOf(address account) public view virtual override returns (uint256) {
129         return _balances[account];
130     }
131 
132     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
133         _transfer(_msgSender(), recipient, amount);
134         return true;
135     }
136 
137 
138     function allowance(address owner, address spender) public view virtual override returns (uint256) {
139         return _allowances[owner][spender];
140     }
141 
142     function approve(address spender, uint256 amount) public virtual override returns (bool) {
143         _approve(_msgSender(), spender, amount);
144         return true;
145     }
146 
147     function transferFrom(
148         address sender,
149         address recipient,
150         uint256 amount
151     ) public virtual override returns (bool) {
152         _transfer(sender, recipient, amount);
153 
154         uint256 currentAllowance = _allowances[sender][_msgSender()];
155         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
156         unchecked {
157             _approve(sender, _msgSender(), currentAllowance - amount);
158         }
159 
160         return true;
161     }
162 
163     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
164         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
165         return true;
166     }
167 
168     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
169         uint256 currentAllowance = _allowances[_msgSender()][spender];
170         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
171         unchecked {
172             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
173         }
174 
175         return true;
176     }
177 
178     function _transfer(
179         address sender,
180         address recipient,
181         uint256 amount
182     ) internal virtual {
183         require(sender != address(0), "ERC20: transfer from the zero address");
184         require(recipient != address(0), "ERC20: transfer to the zero address");
185 
186         _beforeTokenTransfer(sender, recipient, amount);
187 
188         uint256 senderBalance = _balances[sender];
189         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
190         unchecked {
191             _balances[sender] = senderBalance - amount;
192         }
193         _balances[recipient] += amount;
194 
195         emit Transfer(sender, recipient, amount);
196 
197         _afterTokenTransfer(sender, recipient, amount);
198     }
199 
200     function _mint(address account, uint256 amount) internal virtual {
201         require(account != address(0), "ERC20: mint to the zero address");
202 
203         _beforeTokenTransfer(address(0), account, amount);
204 
205         _totalSupply += amount;
206         _balances[account] += amount;
207         emit Transfer(address(0), account, amount);
208 
209         _afterTokenTransfer(address(0), account, amount);
210     }
211 
212     function _burn(address account, uint256 amount) internal virtual {
213         require(account != address(0), "ERC20: burn from the zero address");
214 
215         _beforeTokenTransfer(account, address(0), amount);
216 
217         uint256 accountBalance = _balances[account];
218         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
219         unchecked {
220             _balances[account] = accountBalance - amount;
221         }
222         _totalSupply -= amount;
223 
224         emit Transfer(account, address(0), amount);
225 
226         _afterTokenTransfer(account, address(0), amount);
227     }
228 
229     function _approve(
230         address owner,
231         address spender,
232         uint256 amount
233     ) internal virtual {
234         require(owner != address(0), "ERC20: approve from the zero address");
235         require(spender != address(0), "ERC20: approve to the zero address");
236 
237         _allowances[owner][spender] = amount;
238         emit Approval(owner, spender, amount);
239     }
240 
241     function _beforeTokenTransfer(
242         address from,
243         address to,
244         uint256 amount
245     ) internal virtual {}
246 
247     function _afterTokenTransfer(
248         address from,
249         address to,
250         uint256 amount
251     ) internal virtual {}
252 }
253 
254 
255 library SafeMath {
256 
257     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
258         unchecked {
259             uint256 c = a + b;
260             if (c < a) return (false, 0);
261             return (true, c);
262         }
263     }
264 
265     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
266         unchecked {
267             if (b > a) return (false, 0);
268             return (true, a - b);
269         }
270     }
271 
272 
273     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
274         unchecked {
275             if (a == 0) return (true, 0);
276             uint256 c = a * b;
277             if (c / a != b) return (false, 0);
278             return (true, c);
279         }
280     }
281 
282     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
283         unchecked {
284             if (b == 0) return (false, 0);
285             return (true, a / b);
286         }
287     }
288 
289     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
290         unchecked {
291             if (b == 0) return (false, 0);
292             return (true, a % b);
293         }
294     }
295 
296 
297     function add(uint256 a, uint256 b) internal pure returns (uint256) {
298         return a + b;
299     }
300 
301     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
302         return a - b;
303     }
304 
305     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
306         return a * b;
307     }
308 
309     function div(uint256 a, uint256 b) internal pure returns (uint256) {
310         return a / b;
311     }
312 
313     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
314         return a % b;
315     }
316 
317     function sub(
318         uint256 a,
319         uint256 b,
320         string memory errorMessage
321     ) internal pure returns (uint256) {
322         unchecked {
323             require(b <= a, errorMessage);
324             return a - b;
325         }
326     }
327 
328     function div(
329         uint256 a,
330         uint256 b,
331         string memory errorMessage
332     ) internal pure returns (uint256) {
333         unchecked {
334             require(b > 0, errorMessage);
335             return a / b;
336         }
337     }
338 
339 
340     function mod(
341         uint256 a,
342         uint256 b,
343         string memory errorMessage
344     ) internal pure returns (uint256) {
345         unchecked {
346             require(b > 0, errorMessage);
347             return a % b;
348         }
349     }
350 }
351 
352 
353 interface IUniswapV2Factory {
354     event PairCreated(
355         address indexed token0,
356         address indexed token1,
357         address pair,
358         uint256
359     );
360 
361     function feeTo() external view returns (address);
362 
363     function feeToSetter() external view returns (address);
364 
365     function getPair(address tokenA, address tokenB)
366         external
367         view
368         returns (address pair);
369 
370     function allPairs(uint256) external view returns (address pair);
371 
372     function allPairsLength() external view returns (uint256);
373 
374     function createPair(address tokenA, address tokenB)
375         external
376         returns (address pair);
377 
378     function setFeeTo(address) external;
379 
380     function setFeeToSetter(address) external;
381 }
382 
383 
384 interface IUniswapV2Pair {
385     event Approval(
386         address indexed owner,
387         address indexed spender,
388         uint256 value
389     );
390     event Transfer(address indexed from, address indexed to, uint256 value);
391 
392     function name() external pure returns (string memory);
393 
394     function symbol() external pure returns (string memory);
395 
396     function decimals() external pure returns (uint8);
397 
398     function totalSupply() external view returns (uint256);
399 
400     function balanceOf(address owner) external view returns (uint256);
401 
402     function allowance(address owner, address spender)
403         external
404         view
405         returns (uint256);
406 
407     function approve(address spender, uint256 value) external returns (bool);
408 
409     function transfer(address to, uint256 value) external returns (bool);
410 
411     function transferFrom(
412         address from,
413         address to,
414         uint256 value
415     ) external returns (bool);
416 
417     function DOMAIN_SEPARATOR() external view returns (bytes32);
418 
419     function PERMIT_TYPEHASH() external pure returns (bytes32);
420 
421     function nonces(address owner) external view returns (uint256);
422 
423     function permit(
424         address owner,
425         address spender,
426         uint256 value,
427         uint256 deadline,
428         uint8 v,
429         bytes32 r,
430         bytes32 s
431     ) external;
432 
433     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
434     event Burn(
435         address indexed sender,
436         uint256 amount0,
437         uint256 amount1,
438         address indexed to
439     );
440     event Swap(
441         address indexed sender,
442         uint256 amount0In,
443         uint256 amount1In,
444         uint256 amount0Out,
445         uint256 amount1Out,
446         address indexed to
447     );
448     event Sync(uint112 reserve0, uint112 reserve1);
449 
450     function MINIMUM_LIQUIDITY() external pure returns (uint256);
451 
452     function factory() external view returns (address);
453 
454     function token0() external view returns (address);
455 
456     function token1() external view returns (address);
457 
458     function getReserves()
459         external
460         view
461         returns (
462             uint112 reserve0,
463             uint112 reserve1,
464             uint32 blockTimestampLast
465         );
466 
467     function price0CumulativeLast() external view returns (uint256);
468 
469     function price1CumulativeLast() external view returns (uint256);
470 
471     function kLast() external view returns (uint256);
472 
473     function mint(address to) external returns (uint256 liquidity);
474 
475     function burn(address to)
476         external
477         returns (uint256 amount0, uint256 amount1);
478 
479     function swap(
480         uint256 amount0Out,
481         uint256 amount1Out,
482         address to,
483         bytes calldata data
484     ) external;
485 
486     function skim(address to) external;
487 
488     function sync() external;
489 
490     function initialize(address, address) external;
491 }
492 
493 
494 interface IUniswapV2Router02 {
495     function factory() external pure returns (address);
496 
497     function WETH() external pure returns (address);
498 
499     function addLiquidity(
500         address tokenA,
501         address tokenB,
502         uint256 amountADesired,
503         uint256 amountBDesired,
504         uint256 amountAMin,
505         uint256 amountBMin,
506         address to,
507         uint256 deadline
508     )
509         external
510         returns (
511             uint256 amountA,
512             uint256 amountB,
513             uint256 liquidity
514         );
515 
516     function addLiquidityETH(
517         address token,
518         uint256 amountTokenDesired,
519         uint256 amountTokenMin,
520         uint256 amountETHMin,
521         address to,
522         uint256 deadline
523     )
524         external
525         payable
526         returns (
527             uint256 amountToken,
528             uint256 amountETH,
529             uint256 liquidity
530         );
531 
532     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
533         uint256 amountIn,
534         uint256 amountOutMin,
535         address[] calldata path,
536         address to,
537         uint256 deadline
538     ) external;
539 
540     function swapExactETHForTokensSupportingFeeOnTransferTokens(
541         uint256 amountOutMin,
542         address[] calldata path,
543         address to,
544         uint256 deadline
545     ) external payable;
546 
547     function swapExactTokensForETHSupportingFeeOnTransferTokens(
548         uint256 amountIn,
549         uint256 amountOutMin,
550         address[] calldata path,
551         address to,
552         uint256 deadline
553     ) external;
554 }
555 
556 
557 contract LAELAPS is ERC20, Ownable {
558     using SafeMath for uint256;
559 
560     IUniswapV2Router02 public immutable uniswapV2Router;
561     address public immutable uniswapV2Pair;
562     address public constant deadAddress = address(0xdead);
563 
564     bool private swapping;
565 
566     address public marketingWallet;
567     address public devWallet;
568 
569     uint256 public maxTransactionAmount;
570     uint256 public swapTokensAtAmount;
571     uint256 public maxWallet;
572 
573     uint256 public percentForLPBurn = 0; 
574     bool public lpBurnEnabled = false;
575     uint256 public lpBurnFrequency = 3600 seconds;
576     uint256 public lastLpBurnTime;
577 
578     uint256 public manualBurnFrequency = 30 minutes;
579     uint256 public lastManualLpBurnTime;
580 
581     bool public limitsInEffect = true;
582     bool public tradingActive = false;
583     bool public swapEnabled = true;
584 
585     mapping(address => uint256) private _holderLastTransferTimestamp; 
586     bool public transferDelayEnabled = true;
587 
588     uint256 public buyTotalFees;
589     uint256 public buyMarketingFee;
590     uint256 public buyLiquidityFee;
591     uint256 public buyDevFee;
592 
593     uint256 public sellTotalFees;
594     uint256 public sellMarketingFee;
595     uint256 public sellLiquidityFee;
596     uint256 public sellDevFee;
597 
598     uint256 public tokensForMarketing;
599     uint256 public tokensForLiquidity;
600     uint256 public tokensForDev;
601 
602     mapping(address => bool) private _isExcludedFromFees;
603     mapping(address => bool) public _isExcludedMaxTransactionAmount;
604 
605     mapping(address => bool) public automatedMarketMakerPairs;
606 
607     event UpdateUniswapV2Router(
608         address indexed newAddress,
609         address indexed oldAddress
610     );
611 
612     event ExcludeFromFees(address indexed account, bool isExcluded);
613 
614     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
615 
616     event marketingWalletUpdated(
617         address indexed newWallet,
618         address indexed oldWallet
619     );
620 
621     event devWalletUpdated(
622         address indexed newWallet,
623         address indexed oldWallet
624     );
625 
626     event SwapAndLiquify(
627         uint256 tokensSwapped,
628         uint256 ethReceived,
629         uint256 tokensIntoLiquidity
630     );
631 
632     event AutoNukeLP();
633 
634     event ManualNukeLP();
635 
636     constructor() ERC20("Laelaps", "LAELAPS") {
637         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
638             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
639         );
640 
641         excludeFromMaxTransaction(address(_uniswapV2Router), true);
642         uniswapV2Router = _uniswapV2Router;
643 
644         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
645             .createPair(address(this), _uniswapV2Router.WETH());
646         excludeFromMaxTransaction(address(uniswapV2Pair), true);
647         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
648 
649         uint256 _buyMarketingFee = 15;
650         uint256 _buyLiquidityFee = 5;
651         uint256 _buyDevFee = 0;
652 
653         uint256 _sellMarketingFee = 25;
654         uint256 _sellLiquidityFee = 10;
655         uint256 _sellDevFee = 5;
656 
657         uint256 totalSupply = 1_000_000_000 * 1e18;
658 
659         maxTransactionAmount = 20_000_000 * 1e18; 
660         maxWallet = 20_000_000 * 1e18; 
661         swapTokensAtAmount = (totalSupply * 5) / 10000;
662 
663         buyMarketingFee = _buyMarketingFee;
664         buyLiquidityFee = _buyLiquidityFee;
665         buyDevFee = _buyDevFee;
666         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
667 
668         sellMarketingFee = _sellMarketingFee;
669         sellLiquidityFee = _sellLiquidityFee;
670         sellDevFee = _sellDevFee;
671         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
672 
673         marketingWallet = address(0xd95435171a1Fc5fCC9516786dF1cD3e22eeed52F); 
674         devWallet = address(0x6f84C8352e21C947757c07fF6ae7f6AA2d573078); 
675 
676         // exclude from paying fees or having max transaction amount
677         excludeFromFees(owner(), true);
678         excludeFromFees(address(this), true);
679         excludeFromFees(address(0xdead), true);
680 
681         excludeFromMaxTransaction(owner(), true);
682         excludeFromMaxTransaction(address(this), true);
683         excludeFromMaxTransaction(address(0xdead), true);
684 
685         _mint(msg.sender, totalSupply);
686     }
687 
688     receive() external payable {}
689 
690     function enableTrading() external onlyOwner {
691         tradingActive = true;
692         swapEnabled = true;
693         lastLpBurnTime = block.timestamp;
694     }
695 
696     function removeLimits() external onlyOwner returns (bool) {
697         limitsInEffect = false;
698         return true;
699     }
700 
701     function disableTransferDelay() external onlyOwner returns (bool) {
702         transferDelayEnabled = false;
703         return true;
704     }
705 
706     function updateSwapTokensAtAmount(uint256 newAmount)
707         external
708         onlyOwner
709         returns (bool)
710     {
711         require(
712             newAmount >= (totalSupply() * 1) / 100000,
713             "Swap amount cannot be lower than 0.001% total supply."
714         );
715         require(
716             newAmount <= (totalSupply() * 5) / 1000,
717             "Swap amount cannot be higher than 0.5% total supply."
718         );
719         swapTokensAtAmount = newAmount;
720         return true;
721     }
722 
723     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
724         require(
725             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
726             "Cannot set maxTransactionAmount lower than 0.1%"
727         );
728         maxTransactionAmount = newNum * (10**18);
729     }
730 
731     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
732         require(
733             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
734             "Cannot set maxWallet lower than 0.5%"
735         );
736         maxWallet = newNum * (10**18);
737     }
738 
739     function excludeFromMaxTransaction(address updAds, bool isEx)
740         public
741         onlyOwner
742     {
743         _isExcludedMaxTransactionAmount[updAds] = isEx;
744     }
745 
746     function updateSwapEnabled(bool enabled) external onlyOwner {
747         swapEnabled = enabled;
748     }
749 
750     function updateBuyFees(
751         uint256 _marketingFee,
752         uint256 _liquidityFee,
753         uint256 _devFee
754     ) external onlyOwner {
755         buyMarketingFee = _marketingFee;
756         buyLiquidityFee = _liquidityFee;
757         buyDevFee = _devFee;
758         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
759         require(buyTotalFees <= 50, "Must keep fees at 50% or less");
760     }
761 
762     function updateSellFees(
763         uint256 _marketingFee,
764         uint256 _liquidityFee,
765         uint256 _devFee
766     ) external onlyOwner {
767         sellMarketingFee = _marketingFee;
768         sellLiquidityFee = _liquidityFee;
769         sellDevFee = _devFee;
770         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
771         require(sellTotalFees <= 90, "Must keep fees at 90% or less");
772     }
773 
774     function excludeFromFees(address account, bool excluded) public onlyOwner {
775         _isExcludedFromFees[account] = excluded;
776         emit ExcludeFromFees(account, excluded);
777     }
778 
779     function setAutomatedMarketMakerPair(address pair, bool value)
780         public
781         onlyOwner
782     {
783         require(
784             pair != uniswapV2Pair,
785             "The pair cannot be removed from automatedMarketMakerPairs"
786         );
787 
788         _setAutomatedMarketMakerPair(pair, value);
789     }
790 
791     function _setAutomatedMarketMakerPair(address pair, bool value) private {
792         automatedMarketMakerPairs[pair] = value;
793 
794         emit SetAutomatedMarketMakerPair(pair, value);
795     }
796 
797     function updateMarketingWallet(address newMarketingWallet)
798         external
799         onlyOwner
800     {
801         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
802         marketingWallet = newMarketingWallet;
803     }
804 
805     function updateDevWallet(address newWallet) external onlyOwner {
806         emit devWalletUpdated(newWallet, devWallet);
807         devWallet = newWallet;
808     }
809 
810     function isExcludedFromFees(address account) public view returns (bool) {
811         return _isExcludedFromFees[account];
812     }
813 
814     event BoughtEarly(address indexed sniper);
815 
816     function _transfer(
817         address from,
818         address to,
819         uint256 amount
820     ) internal override {
821         require(from != address(0), "ERC20: transfer from the zero address");
822         require(to != address(0), "ERC20: transfer to the zero address");
823 
824         if (amount == 0) {
825             super._transfer(from, to, 0);
826             return;
827         }
828 
829         if (limitsInEffect) {
830             if (
831                 from != owner() &&
832                 to != owner() &&
833                 to != address(0) &&
834                 to != address(0xdead) &&
835                 !swapping
836             ) {
837                 if (!tradingActive) {
838                     require(
839                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
840                         "Trading is not active."
841                     );
842                 }
843 
844                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
845                 if (transferDelayEnabled) {
846                     if (
847                         to != owner() &&
848                         to != address(uniswapV2Router) &&
849                         to != address(uniswapV2Pair)
850                     ) {
851                         require(
852                             _holderLastTransferTimestamp[tx.origin] <
853                                 block.number,
854                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
855                         );
856                         _holderLastTransferTimestamp[tx.origin] = block.number;
857                     }
858                 }
859 
860                 //when buy
861                 if (
862                     automatedMarketMakerPairs[from] &&
863                     !_isExcludedMaxTransactionAmount[to]
864                 ) {
865                     require(
866                         amount <= maxTransactionAmount,
867                         "Buy transfer amount exceeds the maxTransactionAmount."
868                     );
869                     require(
870                         amount + balanceOf(to) <= maxWallet,
871                         "Max wallet exceeded"
872                     );
873                 }
874                 //when sell
875                 else if (
876                     automatedMarketMakerPairs[to] &&
877                     !_isExcludedMaxTransactionAmount[from]
878                 ) {
879                     require(
880                         amount <= maxTransactionAmount,
881                         "Sell transfer amount exceeds the maxTransactionAmount."
882                     );
883                 } else if (!_isExcludedMaxTransactionAmount[to]) {
884                     require(
885                         amount + balanceOf(to) <= maxWallet,
886                         "Max wallet exceeded"
887                     );
888                 }
889             }
890         }
891 
892         uint256 contractTokenBalance = balanceOf(address(this));
893 
894         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
895 
896         if (
897             canSwap &&
898             swapEnabled &&
899             !swapping &&
900             !automatedMarketMakerPairs[from] &&
901             !_isExcludedFromFees[from] &&
902             !_isExcludedFromFees[to]
903         ) {
904             swapping = true;
905 
906             swapBack();
907 
908             swapping = false;
909         }
910 
911         if (
912             !swapping &&
913             automatedMarketMakerPairs[to] &&
914             lpBurnEnabled &&
915             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
916             !_isExcludedFromFees[from]
917         ) {
918             autoBurnLiquidityPairTokens();
919         }
920 
921         bool takeFee = !swapping;
922 
923         // if any account belongs to _isExcludedFromFee account then remove the fee
924         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
925             takeFee = false;
926         }
927 
928         uint256 fees = 0;
929         // only take fees on buys/sells, do not take on wallet transfers
930         if (takeFee) {
931             // on sell
932             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
933                 fees = amount.mul(sellTotalFees).div(100);
934                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
935                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
936                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
937             }
938             // on buy
939             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
940                 fees = amount.mul(buyTotalFees).div(100);
941                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
942                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
943                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
944             }
945 
946             if (fees > 0) {
947                 super._transfer(from, address(this), fees);
948             }
949 
950             amount -= fees;
951         }
952 
953         super._transfer(from, to, amount);
954     }
955 
956     function swapTokensForEth(uint256 tokenAmount) private {
957         // generate the uniswap pair path of token -> weth
958         address[] memory path = new address[](2);
959         path[0] = address(this);
960         path[1] = uniswapV2Router.WETH();
961 
962         _approve(address(this), address(uniswapV2Router), tokenAmount);
963 
964         // make the swap
965         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
966             tokenAmount,
967             0, // accept any amount of ETH
968             path,
969             address(this),
970             block.timestamp
971         );
972     }
973 
974     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
975         // approve token transfer to cover all possible scenarios
976         _approve(address(this), address(uniswapV2Router), tokenAmount);
977 
978         // add the liquidity
979         uniswapV2Router.addLiquidityETH{value: ethAmount}(
980             address(this),
981             tokenAmount,
982             0, // slippage is unavoidable
983             0, // slippage is unavoidable
984             deadAddress,
985             block.timestamp
986         );
987     }
988 
989     function swapBack() private {
990         uint256 contractBalance = balanceOf(address(this));
991         uint256 totalTokensToSwap = tokensForLiquidity +
992             tokensForMarketing +
993             tokensForDev;
994         bool success;
995 
996         if (contractBalance == 0 || totalTokensToSwap == 0) {
997             return;
998         }
999 
1000         if (contractBalance > swapTokensAtAmount * 20) {
1001             contractBalance = swapTokensAtAmount * 20;
1002         }
1003 
1004         // Halve the amount of liquidity tokens
1005         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1006             totalTokensToSwap /
1007             2;
1008         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1009 
1010         uint256 initialETHBalance = address(this).balance;
1011 
1012         swapTokensForEth(amountToSwapForETH);
1013 
1014         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1015 
1016         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1017             totalTokensToSwap
1018         );
1019         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1020 
1021         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1022 
1023         tokensForLiquidity = 0;
1024         tokensForMarketing = 0;
1025         tokensForDev = 0;
1026 
1027         (success, ) = address(devWallet).call{value: ethForDev}("");
1028 
1029         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1030             addLiquidity(liquidityTokens, ethForLiquidity);
1031             emit SwapAndLiquify(
1032                 amountToSwapForETH,
1033                 ethForLiquidity,
1034                 tokensForLiquidity
1035             );
1036         }
1037 
1038         (success, ) = address(marketingWallet).call{
1039             value: address(this).balance
1040         }("");
1041     }
1042 
1043     function setAutoLPBurnSettings(
1044         uint256 _frequencyInSeconds,
1045         uint256 _percent,
1046         bool _Enabled
1047     ) external onlyOwner {
1048         require(
1049             _frequencyInSeconds >= 600,
1050             "cannot set buyback more often than every 10 minutes"
1051         );
1052         require(
1053             _percent <= 1000 && _percent >= 0,
1054             "Must set auto LP burn percent between 0% and 10%"
1055         );
1056         lpBurnFrequency = _frequencyInSeconds;
1057         percentForLPBurn = _percent;
1058         lpBurnEnabled = _Enabled;
1059     }
1060 
1061     function autoBurnLiquidityPairTokens() internal returns (bool) {
1062         lastLpBurnTime = block.timestamp;
1063 
1064         // get balance of liquidity pair
1065         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1066 
1067         // calculate amount to burn
1068         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1069             10000
1070         );
1071 
1072         // pull tokens from pancakePair liquidity and move to dead address permanently
1073         if (amountToBurn > 0) {
1074             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1075         }
1076 
1077         //sync price since this is not in a swap transaction!
1078         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1079         pair.sync();
1080         emit AutoNukeLP();
1081         return true;
1082     }
1083 
1084     function manualBurnLiquidityPairTokens(uint256 percent)
1085         external
1086         onlyOwner
1087         returns (bool)
1088     {
1089         require(
1090             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1091             "Must wait for cooldown to finish"
1092         );
1093         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1094         lastManualLpBurnTime = block.timestamp;
1095 
1096         // get balance of liquidity pair
1097         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1098 
1099         // calculate amount to burn
1100         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1101 
1102         // pull tokens from pancakePair liquidity and move to dead address permanently
1103         if (amountToBurn > 0) {
1104             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1105         }
1106 
1107         //sync price since this is not in a swap transaction!
1108         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1109         pair.sync();
1110         emit ManualNukeLP();
1111         return true;
1112     }
1113 }