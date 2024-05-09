1 /*         
2     https://t.me/frenstoken
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
7 pragma experimental ABIEncoderV2;
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
47 
48     function _transferOwnership(address newOwner) internal virtual {
49         address oldOwner = _owner;
50         _owner = newOwner;
51         emit OwnershipTransferred(oldOwner, newOwner);
52     }
53 }
54 
55 interface IERC20 {
56 
57     function totalSupply() external view returns (uint256);
58 
59     function balanceOf(address account) external view returns (uint256);
60 
61 
62     function transfer(address recipient, uint256 amount) external returns (bool);
63 
64 
65     function allowance(address owner, address spender) external view returns (uint256);
66 
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69 
70     function transferFrom(
71         address sender,
72         address recipient,
73         uint256 amount
74     ) external returns (bool);
75 
76 
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
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
557 contract FRENS is ERC20, Ownable {
558     using SafeMath for uint256;
559 
560     IUniswapV2Router02 public immutable uniswapV2Router;
561     address public immutable uniswapV2Pair;
562     address public constant deadAddress = address(0xdead);
563 
564     bool private swapping;
565 
566     address private marketingWallet;
567     address private developmentWallet;
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
591     uint256 public buyDevelopmentFee;
592 
593     uint256 public sellTotalFees;
594     uint256 public sellMarketingFee;
595     uint256 public sellLiquidityFee;
596     uint256 public sellDevelopmentFee;
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
621     event developmentWalletUpdated(
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
636     constructor() ERC20("Frens", "FRENS") {
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
650         uint256 _buyLiquidityFee = 0;
651         uint256 _buyDevelopmentFee = 0;
652 
653         uint256 _sellMarketingFee = 25;
654         uint256 _sellLiquidityFee = 0;
655         uint256 _sellDevelopmentFee = 0;
656 
657         uint256 totalSupply = 100_000_000 * 1e18;
658 
659         maxTransactionAmount = 2_500_000 * 1e18; 
660         maxWallet = 2_500_000 * 1e18; 
661         swapTokensAtAmount = (totalSupply * 10) / 10000;
662 
663         buyMarketingFee = _buyMarketingFee;
664         buyLiquidityFee = _buyLiquidityFee;
665         buyDevelopmentFee = _buyDevelopmentFee;
666         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
667 
668         sellMarketingFee = _sellMarketingFee;
669         sellLiquidityFee = _sellLiquidityFee;
670         sellDevelopmentFee = _sellDevelopmentFee;
671         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
672 
673         marketingWallet = address(0x19E95783d5c4CE94286EE95Dceb47ffE1B1e6233); 
674         developmentWallet = address(0x19E95783d5c4CE94286EE95Dceb47ffE1B1e6233); 
675 
676         excludeFromFees(owner(), true);
677         excludeFromFees(address(this), true);
678         excludeFromFees(address(0xdead), true);
679 
680         excludeFromMaxTransaction(owner(), true);
681         excludeFromMaxTransaction(address(this), true);
682         excludeFromMaxTransaction(address(0xdead), true);
683 
684         _mint(msg.sender, totalSupply);
685     }
686 
687     receive() external payable {}
688 
689     function enableTrading() external onlyOwner {
690         tradingActive = true;
691         swapEnabled = true;
692         lastLpBurnTime = block.timestamp;
693     }
694 
695     function removeLimits() external onlyOwner returns (bool) {
696         limitsInEffect = false;
697         return true;
698     }
699 
700     function disableTransferDelay() external onlyOwner returns (bool) {
701         transferDelayEnabled = false;
702         return true;
703     }
704 
705     function updateSwapTokensAtAmount(uint256 newAmount)
706         external
707         onlyOwner
708         returns (bool)
709     {
710         require(
711             newAmount >= (totalSupply() * 1) / 100000,
712             "Swap amount cannot be lower than 0.001% total supply."
713         );
714         require(
715             newAmount <= (totalSupply() * 5) / 1000,
716             "Swap amount cannot be higher than 0.5% total supply."
717         );
718         swapTokensAtAmount = newAmount;
719         return true;
720     }
721 
722     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
723         require(
724             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
725             "Cannot set maxTransactionAmount lower than 0.1%"
726         );
727         maxTransactionAmount = newNum * (10**18);
728     }
729 
730     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
731         require(
732             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
733             "Cannot set maxWallet lower than 0.5%"
734         );
735         maxWallet = newNum * (10**18);
736     }
737 
738     function excludeFromMaxTransaction(address updAds, bool isEx)
739         public
740         onlyOwner
741     {
742         _isExcludedMaxTransactionAmount[updAds] = isEx;
743     }
744 
745     function updateSwapEnabled(bool enabled) external onlyOwner {
746         swapEnabled = enabled;
747     }
748 
749     function updateBuyFees(
750         uint256 _marketingFee,
751         uint256 _liquidityFee,
752         uint256 _developmentFee
753     ) external onlyOwner {
754         buyMarketingFee = _marketingFee;
755         buyLiquidityFee = _liquidityFee;
756         buyDevelopmentFee = _developmentFee;
757         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
758         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
759     }
760 
761     function updateSellFees(
762         uint256 _marketingFee,
763         uint256 _liquidityFee,
764         uint256 _developmentFee
765     ) external onlyOwner {
766         sellMarketingFee = _marketingFee;
767         sellLiquidityFee = _liquidityFee;
768         sellDevelopmentFee = _developmentFee;
769         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
770         require(sellTotalFees <= 15, "Must keep fees at 15% or less");
771     }
772 
773     function excludeFromFees(address account, bool excluded) public onlyOwner {
774         _isExcludedFromFees[account] = excluded;
775         emit ExcludeFromFees(account, excluded);
776     }
777 
778     function setAutomatedMarketMakerPair(address pair, bool value)
779         public
780         onlyOwner
781     {
782         require(
783             pair != uniswapV2Pair,
784             "The pair cannot be removed from automatedMarketMakerPairs"
785         );
786 
787         _setAutomatedMarketMakerPair(pair, value);
788     }
789 
790     function _setAutomatedMarketMakerPair(address pair, bool value) private {
791         automatedMarketMakerPairs[pair] = value;
792 
793         emit SetAutomatedMarketMakerPair(pair, value);
794     }
795 
796     function updateMarketingWalletInfo(address newMarketingWallet)
797         external
798         onlyOwner
799     {
800         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
801         marketingWallet = newMarketingWallet;
802     }
803 
804     function updateDevelopmentWalletInfo(address newWallet) external onlyOwner {
805         emit developmentWalletUpdated(newWallet, developmentWallet);
806         developmentWallet = newWallet;
807     }
808 
809     function isExcludedFromFees(address account) public view returns (bool) {
810         return _isExcludedFromFees[account];
811     }
812 
813     event BoughtEarly(address indexed sniper);
814 
815     function _transfer(
816         address from,
817         address to,
818         uint256 amount
819     ) internal override {
820         require(from != address(0), "ERC20: transfer from the zero address");
821         require(to != address(0), "ERC20: transfer to the zero address");
822 
823         if (amount == 0) {
824             super._transfer(from, to, 0);
825             return;
826         }
827 
828         if (limitsInEffect) {
829             if (
830                 from != owner() &&
831                 to != owner() &&
832                 to != address(0) &&
833                 to != address(0xdead) &&
834                 !swapping
835             ) {
836                 if (!tradingActive) {
837                     require(
838                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
839                         "Trading is not active."
840                     );
841                 }
842 
843                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
844                 if (transferDelayEnabled) {
845                     if (
846                         to != owner() &&
847                         to != address(uniswapV2Router) &&
848                         to != address(uniswapV2Pair)
849                     ) {
850                         require(
851                             _holderLastTransferTimestamp[tx.origin] <
852                                 block.number,
853                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
854                         );
855                         _holderLastTransferTimestamp[tx.origin] = block.number;
856                     }
857                 }
858 
859                 //when buy
860                 if (
861                     automatedMarketMakerPairs[from] &&
862                     !_isExcludedMaxTransactionAmount[to]
863                 ) {
864                     require(
865                         amount <= maxTransactionAmount,
866                         "Buy transfer amount exceeds the maxTransactionAmount."
867                     );
868                     require(
869                         amount + balanceOf(to) <= maxWallet,
870                         "Max wallet exceeded"
871                     );
872                 }
873                 //when sell
874                 else if (
875                     automatedMarketMakerPairs[to] &&
876                     !_isExcludedMaxTransactionAmount[from]
877                 ) {
878                     require(
879                         amount <= maxTransactionAmount,
880                         "Sell transfer amount exceeds the maxTransactionAmount."
881                     );
882                 } else if (!_isExcludedMaxTransactionAmount[to]) {
883                     require(
884                         amount + balanceOf(to) <= maxWallet,
885                         "Max wallet exceeded"
886                     );
887                 }
888             }
889         }
890 
891         uint256 contractTokenBalance = balanceOf(address(this));
892 
893         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
894 
895         if (
896             canSwap &&
897             swapEnabled &&
898             !swapping &&
899             !automatedMarketMakerPairs[from] &&
900             !_isExcludedFromFees[from] &&
901             !_isExcludedFromFees[to]
902         ) {
903             swapping = true;
904 
905             swapBack();
906 
907             swapping = false;
908         }
909 
910         if (
911             !swapping &&
912             automatedMarketMakerPairs[to] &&
913             lpBurnEnabled &&
914             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
915             !_isExcludedFromFees[from]
916         ) {
917             autoBurnLiquidityPairTokens();
918         }
919 
920         bool takeFee = !swapping;
921 
922         // if any account belongs to _isExcludedFromFee account then remove the fee
923         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
924             takeFee = false;
925         }
926 
927         uint256 fees = 0;
928         // only take fees on buys/sells, do not take on wallet transfers
929         if (takeFee) {
930             // on sell
931             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
932                 fees = amount.mul(sellTotalFees).div(100);
933                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
934                 tokensForDev += (fees * sellDevelopmentFee) / sellTotalFees;
935                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
936             }
937             // on buy
938             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
939                 fees = amount.mul(buyTotalFees).div(100);
940                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
941                 tokensForDev += (fees * buyDevelopmentFee) / buyTotalFees;
942                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
943             }
944 
945             if (fees > 0) {
946                 super._transfer(from, address(this), fees);
947             }
948 
949             amount -= fees;
950         }
951 
952         super._transfer(from, to, amount);
953     }
954 
955     function swapTokensForEth(uint256 tokenAmount) private {
956         // generate the uniswap pair path of token -> weth
957         address[] memory path = new address[](2);
958         path[0] = address(this);
959         path[1] = uniswapV2Router.WETH();
960 
961         _approve(address(this), address(uniswapV2Router), tokenAmount);
962 
963         // make the swap
964         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
965             tokenAmount,
966             0, // accept any amount of ETH
967             path,
968             address(this),
969             block.timestamp
970         );
971     }
972 
973     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
974         // approve token transfer to cover all possible scenarios
975         _approve(address(this), address(uniswapV2Router), tokenAmount);
976 
977         // add the liquidity
978         uniswapV2Router.addLiquidityETH{value: ethAmount}(
979             address(this),
980             tokenAmount,
981             0, // slippage is unavoidable
982             0, // slippage is unavoidable
983             deadAddress,
984             block.timestamp
985         );
986     }
987 
988     function swapBack() private {
989         uint256 contractBalance = balanceOf(address(this));
990         uint256 totalTokensToSwap = tokensForLiquidity +
991             tokensForMarketing +
992             tokensForDev;
993         bool success;
994 
995         if (contractBalance == 0 || totalTokensToSwap == 0) {
996             return;
997         }
998 
999         if (contractBalance > swapTokensAtAmount * 20) {
1000             contractBalance = swapTokensAtAmount * 20;
1001         }
1002 
1003         // Halve the amount of liquidity tokens
1004         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1005             totalTokensToSwap /
1006             2;
1007         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1008 
1009         uint256 initialETHBalance = address(this).balance;
1010 
1011         swapTokensForEth(amountToSwapForETH);
1012 
1013         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1014 
1015         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1016             totalTokensToSwap
1017         );
1018         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1019 
1020         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1021 
1022         tokensForLiquidity = 0;
1023         tokensForMarketing = 0;
1024         tokensForDev = 0;
1025 
1026         (success, ) = address(developmentWallet).call{value: ethForDev}("");
1027 
1028         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1029             addLiquidity(liquidityTokens, ethForLiquidity);
1030             emit SwapAndLiquify(
1031                 amountToSwapForETH,
1032                 ethForLiquidity,
1033                 tokensForLiquidity
1034             );
1035         }
1036 
1037         (success, ) = address(marketingWallet).call{
1038             value: address(this).balance
1039         }("");
1040     }
1041 
1042     function setAutoLPBurnSettings(
1043         uint256 _frequencyInSeconds,
1044         uint256 _percent,
1045         bool _Enabled
1046     ) external onlyOwner {
1047         require(
1048             _frequencyInSeconds >= 600,
1049             "cannot set buyback more often than every 10 minutes"
1050         );
1051         require(
1052             _percent <= 1000 && _percent >= 0,
1053             "Must set auto LP burn percent between 0% and 10%"
1054         );
1055         lpBurnFrequency = _frequencyInSeconds;
1056         percentForLPBurn = _percent;
1057         lpBurnEnabled = _Enabled;
1058     }
1059 
1060     function autoBurnLiquidityPairTokens() internal returns (bool) {
1061         lastLpBurnTime = block.timestamp;
1062 
1063         // get balance of liquidity pair
1064         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1065 
1066         // calculate amount to burn
1067         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1068             10000
1069         );
1070 
1071         // pull tokens from pancakePair liquidity and move to dead address permanently
1072         if (amountToBurn > 0) {
1073             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1074         }
1075 
1076         //sync price since this is not in a swap transaction!
1077         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1078         pair.sync();
1079         emit AutoNukeLP();
1080         return true;
1081     }
1082 
1083     function manualBurnLiquidityPairTokens(uint256 percent)
1084         external
1085         onlyOwner
1086         returns (bool)
1087     {
1088         require(
1089             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1090             "Must wait for cooldown to finish"
1091         );
1092         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1093         lastManualLpBurnTime = block.timestamp;
1094 
1095         // get balance of liquidity pair
1096         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1097 
1098         // calculate amount to burn
1099         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1100 
1101         // pull tokens from pancakePair liquidity and move to dead address permanently
1102         if (amountToBurn > 0) {
1103             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1104         }
1105 
1106         //sync price since this is not in a swap transaction!
1107         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1108         pair.sync();
1109         emit ManualNukeLP();
1110         return true;
1111     }
1112 }