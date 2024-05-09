1 /**
2 */
3 
4 // TG: https://t.me/Shino_Portal 
5 // Twitter:https://twitter.com/Shino_Finance
6 // Website: https://www.shino.finance/index.html
7 // Docs: https://shinofinance.gitbook.io/shino/
8 // 
9 
10 // SPDX-License-Identifier: MIT
11 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
12 pragma experimental ABIEncoderV2;
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
42 
43     function renounceOwnership() public virtual onlyOwner {
44         _transferOwnership(address(0));
45     }
46 
47     function transferOwnership(address newOwner) public virtual onlyOwner {
48         require(newOwner != address(0), "Ownable: new owner is the zero address");
49         _transferOwnership(newOwner);
50     }
51 
52 
53     function _transferOwnership(address newOwner) internal virtual {
54         address oldOwner = _owner;
55         _owner = newOwner;
56         emit OwnershipTransferred(oldOwner, newOwner);
57     }
58 }
59 
60 interface IERC20 {
61 
62     function totalSupply() external view returns (uint256);
63 
64     function balanceOf(address account) external view returns (uint256);
65 
66 
67     function transfer(address recipient, uint256 amount) external returns (bool);
68 
69 
70     function allowance(address owner, address spender) external view returns (uint256);
71 
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74 
75     function transferFrom(
76         address sender,
77         address recipient,
78         uint256 amount
79     ) external returns (bool);
80 
81 
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 interface IERC20Metadata is IERC20 {
88 
89     function name() external view returns (string memory);
90 
91     function symbol() external view returns (string memory);
92 
93     function decimals() external view returns (uint8);
94 }
95 
96 
97 contract ERC20 is Context, IERC20, IERC20Metadata {
98     mapping(address => uint256) private _balances;
99 
100     mapping(address => mapping(address => uint256)) private _allowances;
101 
102     uint256 private _totalSupply;
103 
104     string private _name;
105     string private _symbol;
106 
107 
108     constructor(string memory name_, string memory symbol_) {
109         _name = name_;
110         _symbol = symbol_;
111     }
112 
113 
114     function name() public view virtual override returns (string memory) {
115         return _name;
116     }
117 
118 
119     function symbol() public view virtual override returns (string memory) {
120         return _symbol;
121     }
122 
123 
124     function decimals() public view virtual override returns (uint8) {
125         return 18;
126     }
127 
128 
129     function totalSupply() public view virtual override returns (uint256) {
130         return _totalSupply;
131     }
132 
133     function balanceOf(address account) public view virtual override returns (uint256) {
134         return _balances[account];
135     }
136 
137     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
138         _transfer(_msgSender(), recipient, amount);
139         return true;
140     }
141 
142 
143     function allowance(address owner, address spender) public view virtual override returns (uint256) {
144         return _allowances[owner][spender];
145     }
146 
147     function approve(address spender, uint256 amount) public virtual override returns (bool) {
148         _approve(_msgSender(), spender, amount);
149         return true;
150     }
151 
152     function transferFrom(
153         address sender,
154         address recipient,
155         uint256 amount
156     ) public virtual override returns (bool) {
157         _transfer(sender, recipient, amount);
158 
159         uint256 currentAllowance = _allowances[sender][_msgSender()];
160         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
161         unchecked {
162             _approve(sender, _msgSender(), currentAllowance - amount);
163         }
164 
165         return true;
166     }
167 
168     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
169         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
170         return true;
171     }
172 
173     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
174         uint256 currentAllowance = _allowances[_msgSender()][spender];
175         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
176         unchecked {
177             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
178         }
179 
180         return true;
181     }
182 
183     function _transfer(
184         address sender,
185         address recipient,
186         uint256 amount
187     ) internal virtual {
188         require(sender != address(0), "ERC20: transfer from the zero address");
189         require(recipient != address(0), "ERC20: transfer to the zero address");
190 
191         _beforeTokenTransfer(sender, recipient, amount);
192 
193         uint256 senderBalance = _balances[sender];
194         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
195         unchecked {
196             _balances[sender] = senderBalance - amount;
197         }
198         _balances[recipient] += amount;
199 
200         emit Transfer(sender, recipient, amount);
201 
202         _afterTokenTransfer(sender, recipient, amount);
203     }
204 
205     function _mint(address account, uint256 amount) internal virtual {
206         require(account != address(0), "ERC20: mint to the zero address");
207 
208         _beforeTokenTransfer(address(0), account, amount);
209 
210         _totalSupply += amount;
211         _balances[account] += amount;
212         emit Transfer(address(0), account, amount);
213 
214         _afterTokenTransfer(address(0), account, amount);
215     }
216 
217     function _burn(address account, uint256 amount) internal virtual {
218         require(account != address(0), "ERC20: burn from the zero address");
219 
220         _beforeTokenTransfer(account, address(0), amount);
221 
222         uint256 accountBalance = _balances[account];
223         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
224         unchecked {
225             _balances[account] = accountBalance - amount;
226         }
227         _totalSupply -= amount;
228 
229         emit Transfer(account, address(0), amount);
230 
231         _afterTokenTransfer(account, address(0), amount);
232     }
233 
234     function _approve(
235         address owner,
236         address spender,
237         uint256 amount
238     ) internal virtual {
239         require(owner != address(0), "ERC20: approve from the zero address");
240         require(spender != address(0), "ERC20: approve to the zero address");
241 
242         _allowances[owner][spender] = amount;
243         emit Approval(owner, spender, amount);
244     }
245 
246     function _beforeTokenTransfer(
247         address from,
248         address to,
249         uint256 amount
250     ) internal virtual {}
251 
252     function _afterTokenTransfer(
253         address from,
254         address to,
255         uint256 amount
256     ) internal virtual {}
257 }
258 
259 
260 library SafeMath {
261 
262     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
263         unchecked {
264             uint256 c = a + b;
265             if (c < a) return (false, 0);
266             return (true, c);
267         }
268     }
269 
270     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
271         unchecked {
272             if (b > a) return (false, 0);
273             return (true, a - b);
274         }
275     }
276 
277 
278     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
279         unchecked {
280             if (a == 0) return (true, 0);
281             uint256 c = a * b;
282             if (c / a != b) return (false, 0);
283             return (true, c);
284         }
285     }
286 
287     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
288         unchecked {
289             if (b == 0) return (false, 0);
290             return (true, a / b);
291         }
292     }
293 
294     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
295         unchecked {
296             if (b == 0) return (false, 0);
297             return (true, a % b);
298         }
299     }
300 
301 
302     function add(uint256 a, uint256 b) internal pure returns (uint256) {
303         return a + b;
304     }
305 
306     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
307         return a - b;
308     }
309 
310     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
311         return a * b;
312     }
313 
314     function div(uint256 a, uint256 b) internal pure returns (uint256) {
315         return a / b;
316     }
317 
318     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
319         return a % b;
320     }
321 
322     function sub(
323         uint256 a,
324         uint256 b,
325         string memory errorMessage
326     ) internal pure returns (uint256) {
327         unchecked {
328             require(b <= a, errorMessage);
329             return a - b;
330         }
331     }
332 
333     function div(
334         uint256 a,
335         uint256 b,
336         string memory errorMessage
337     ) internal pure returns (uint256) {
338         unchecked {
339             require(b > 0, errorMessage);
340             return a / b;
341         }
342     }
343 
344 
345     function mod(
346         uint256 a,
347         uint256 b,
348         string memory errorMessage
349     ) internal pure returns (uint256) {
350         unchecked {
351             require(b > 0, errorMessage);
352             return a % b;
353         }
354     }
355 }
356 
357 
358 interface IUniswapV2Factory {
359     event PairCreated(
360         address indexed token0,
361         address indexed token1,
362         address pair,
363         uint256
364     );
365 
366     function feeTo() external view returns (address);
367 
368     function feeToSetter() external view returns (address);
369 
370     function getPair(address tokenA, address tokenB)
371         external
372         view
373         returns (address pair);
374 
375     function allPairs(uint256) external view returns (address pair);
376 
377     function allPairsLength() external view returns (uint256);
378 
379     function createPair(address tokenA, address tokenB)
380         external
381         returns (address pair);
382 
383     function setFeeTo(address) external;
384 
385     function setFeeToSetter(address) external;
386 }
387 
388 
389 interface IUniswapV2Pair {
390     event Approval(
391         address indexed owner,
392         address indexed spender,
393         uint256 value
394     );
395     event Transfer(address indexed from, address indexed to, uint256 value);
396 
397     function name() external pure returns (string memory);
398 
399     function symbol() external pure returns (string memory);
400 
401     function decimals() external pure returns (uint8);
402 
403     function totalSupply() external view returns (uint256);
404 
405     function balanceOf(address owner) external view returns (uint256);
406 
407     function allowance(address owner, address spender)
408         external
409         view
410         returns (uint256);
411 
412     function approve(address spender, uint256 value) external returns (bool);
413 
414     function transfer(address to, uint256 value) external returns (bool);
415 
416     function transferFrom(
417         address from,
418         address to,
419         uint256 value
420     ) external returns (bool);
421 
422     function DOMAIN_SEPARATOR() external view returns (bytes32);
423 
424     function PERMIT_TYPEHASH() external pure returns (bytes32);
425 
426     function nonces(address owner) external view returns (uint256);
427 
428     function permit(
429         address owner,
430         address spender,
431         uint256 value,
432         uint256 deadline,
433         uint8 v,
434         bytes32 r,
435         bytes32 s
436     ) external;
437 
438     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
439     event Burn(
440         address indexed sender,
441         uint256 amount0,
442         uint256 amount1,
443         address indexed to
444     );
445     event Swap(
446         address indexed sender,
447         uint256 amount0In,
448         uint256 amount1In,
449         uint256 amount0Out,
450         uint256 amount1Out,
451         address indexed to
452     );
453     event Sync(uint112 reserve0, uint112 reserve1);
454 
455     function MINIMUM_LIQUIDITY() external pure returns (uint256);
456 
457     function factory() external view returns (address);
458 
459     function token0() external view returns (address);
460 
461     function token1() external view returns (address);
462 
463     function getReserves()
464         external
465         view
466         returns (
467             uint112 reserve0,
468             uint112 reserve1,
469             uint32 blockTimestampLast
470         );
471 
472     function price0CumulativeLast() external view returns (uint256);
473 
474     function price1CumulativeLast() external view returns (uint256);
475 
476     function kLast() external view returns (uint256);
477 
478     function mint(address to) external returns (uint256 liquidity);
479 
480     function burn(address to)
481         external
482         returns (uint256 amount0, uint256 amount1);
483 
484     function swap(
485         uint256 amount0Out,
486         uint256 amount1Out,
487         address to,
488         bytes calldata data
489     ) external;
490 
491     function skim(address to) external;
492 
493     function sync() external;
494 
495     function initialize(address, address) external;
496 }
497 
498 
499 interface IUniswapV2Router02 {
500     function factory() external pure returns (address);
501 
502     function WETH() external pure returns (address);
503 
504     function addLiquidity(
505         address tokenA,
506         address tokenB,
507         uint256 amountADesired,
508         uint256 amountBDesired,
509         uint256 amountAMin,
510         uint256 amountBMin,
511         address to,
512         uint256 deadline
513     )
514         external
515         returns (
516             uint256 amountA,
517             uint256 amountB,
518             uint256 liquidity
519         );
520 
521     function addLiquidityETH(
522         address token,
523         uint256 amountTokenDesired,
524         uint256 amountTokenMin,
525         uint256 amountETHMin,
526         address to,
527         uint256 deadline
528     )
529         external
530         payable
531         returns (
532             uint256 amountToken,
533             uint256 amountETH,
534             uint256 liquidity
535         );
536 
537     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
538         uint256 amountIn,
539         uint256 amountOutMin,
540         address[] calldata path,
541         address to,
542         uint256 deadline
543     ) external;
544 
545     function swapExactETHForTokensSupportingFeeOnTransferTokens(
546         uint256 amountOutMin,
547         address[] calldata path,
548         address to,
549         uint256 deadline
550     ) external payable;
551 
552     function swapExactTokensForETHSupportingFeeOnTransferTokens(
553         uint256 amountIn,
554         uint256 amountOutMin,
555         address[] calldata path,
556         address to,
557         uint256 deadline
558     ) external;
559 }
560 
561 
562 contract SHINO is ERC20, Ownable {
563     using SafeMath for uint256;
564 
565     IUniswapV2Router02 public immutable uniswapV2Router;
566     address public immutable uniswapV2Pair;
567     address public constant deadAddress = address(0xdead);
568 
569     bool private swapping;
570 
571     address private marketingWallet;
572     address private developmentWallet;
573 
574     uint256 public maxTransactionAmount;
575     uint256 public swapTokensAtAmount;
576     uint256 public maxWallet;
577 
578     uint256 public percentForLPBurn = 0; 
579     bool public lpBurnEnabled = false;
580     uint256 public lpBurnFrequency = 3600 seconds;
581     uint256 public lastLpBurnTime;
582 
583     uint256 public manualBurnFrequency = 30 minutes;
584     uint256 public lastManualLpBurnTime;
585 
586     bool public limitsInEffect = true;
587     bool public tradingActive = false;
588     bool public swapEnabled = true;
589 
590     mapping(address => uint256) private _holderLastTransferTimestamp; 
591     bool public transferDelayEnabled = true;
592 
593     uint256 public buyTotalFees;
594     uint256 public buyMarketingFee;
595     uint256 public buyLiquidityFee;
596     uint256 public buyDevelopmentFee;
597 
598     uint256 public sellTotalFees;
599     uint256 public sellMarketingFee;
600     uint256 public sellLiquidityFee;
601     uint256 public sellDevelopmentFee;
602 
603     uint256 public tokensForMarketing;
604     uint256 public tokensForLiquidity;
605     uint256 public tokensForDev;
606 
607     mapping(address => bool) private _isExcludedFromFees;
608     mapping(address => bool) public _isExcludedMaxTransactionAmount;
609 
610     mapping(address => bool) public automatedMarketMakerPairs;
611 
612     event UpdateUniswapV2Router(
613         address indexed newAddress,
614         address indexed oldAddress
615     );
616 
617     event ExcludeFromFees(address indexed account, bool isExcluded);
618 
619     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
620 
621     event marketingWalletUpdated(
622         address indexed newWallet,
623         address indexed oldWallet
624     );
625 
626     event developmentWalletUpdated(
627         address indexed newWallet,
628         address indexed oldWallet
629     );
630 
631     event SwapAndLiquify(
632         uint256 tokensSwapped,
633         uint256 ethReceived,
634         uint256 tokensIntoLiquidity
635     );
636 
637     event AutoNukeLP();
638 
639     event ManualNukeLP();
640 
641     constructor() ERC20("Shiba Casino", "SHINO") {
642         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
643             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
644         );
645 
646         excludeFromMaxTransaction(address(_uniswapV2Router), true);
647         uniswapV2Router = _uniswapV2Router;
648 
649         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
650             .createPair(address(this), _uniswapV2Router.WETH());
651         excludeFromMaxTransaction(address(uniswapV2Pair), true);
652         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
653 
654         uint256 _buyMarketingFee = 5;
655         uint256 _buyLiquidityFee = 0;
656         uint256 _buyDevelopmentFee = 20;
657 
658         uint256 _sellMarketingFee = 7;
659         uint256 _sellLiquidityFee = 0;
660         uint256 _sellDevelopmentFee = 28;
661 
662         uint256 totalSupply = 100_000_000 * 1e18;
663 
664         maxTransactionAmount = 1_500_000 * 1e18; 
665         maxWallet = 2_000_000 * 1e18; 
666         swapTokensAtAmount = (totalSupply * 10) / 10000;
667 
668         buyMarketingFee = _buyMarketingFee;
669         buyLiquidityFee = _buyLiquidityFee;
670         buyDevelopmentFee = _buyDevelopmentFee;
671         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
672 
673         sellMarketingFee = _sellMarketingFee;
674         sellLiquidityFee = _sellLiquidityFee;
675         sellDevelopmentFee = _sellDevelopmentFee;
676         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
677 
678         marketingWallet = address(0x0C5Ff2358aEE1f931c340DA41bc71C9a166c1C95); 
679         developmentWallet = address(0x402Fd8cCf0233036b713AbFA89518F174c25Ed4A); 
680 
681         excludeFromFees(owner(), true);
682         excludeFromFees(address(this), true);
683         excludeFromFees(address(0xdead), true);
684 
685         excludeFromMaxTransaction(owner(), true);
686         excludeFromMaxTransaction(address(this), true);
687         excludeFromMaxTransaction(address(0xdead), true);
688 
689         _mint(msg.sender, totalSupply);
690     }
691 
692     receive() external payable {}
693 
694     function enableTrading() external onlyOwner {
695         tradingActive = true;
696         swapEnabled = true;
697         lastLpBurnTime = block.timestamp;
698     }
699 
700     function removeLimits() external onlyOwner returns (bool) {
701         limitsInEffect = false;
702         return true;
703     }
704 
705     function disableTransferDelay() external onlyOwner returns (bool) {
706         transferDelayEnabled = false;
707         return true;
708     }
709 
710     function updateSwapTokensAtAmount(uint256 newAmount)
711         external
712         onlyOwner
713         returns (bool)
714     {
715         require(
716             newAmount >= (totalSupply() * 1) / 100000,
717             "Swap amount cannot be lower than 0.001% total supply."
718         );
719         require(
720             newAmount <= (totalSupply() * 5) / 1000,
721             "Swap amount cannot be higher than 0.5% total supply."
722         );
723         swapTokensAtAmount = newAmount;
724         return true;
725     }
726 
727     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
728         require(
729             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
730             "Cannot set maxTransactionAmount lower than 0.1%"
731         );
732         maxTransactionAmount = newNum * (10**18);
733     }
734 
735     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
736         require(
737             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
738             "Cannot set maxWallet lower than 0.5%"
739         );
740         maxWallet = newNum * (10**18);
741     }
742 
743     function excludeFromMaxTransaction(address updAds, bool isEx)
744         public
745         onlyOwner
746     {
747         _isExcludedMaxTransactionAmount[updAds] = isEx;
748     }
749 
750     function updateSwapEnabled(bool enabled) external onlyOwner {
751         swapEnabled = enabled;
752     }
753 
754     function updateBuyFees(
755         uint256 _marketingFee,
756         uint256 _liquidityFee,
757         uint256 _developmentFee
758     ) external onlyOwner {
759         buyMarketingFee = _marketingFee;
760         buyLiquidityFee = _liquidityFee;
761         buyDevelopmentFee = _developmentFee;
762         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
763         require(buyTotalFees <= 35, "Must keep fees at 35% or less");
764     }
765 
766     function updateSellFees(
767         uint256 _marketingFee,
768         uint256 _liquidityFee,
769         uint256 _developmentFee
770     ) external onlyOwner {
771         sellMarketingFee = _marketingFee;
772         sellLiquidityFee = _liquidityFee;
773         sellDevelopmentFee = _developmentFee;
774         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
775         require(sellTotalFees <= 99, "Must keep fees at 40% or less");
776     }
777 
778     function excludeFromFees(address account, bool excluded) public onlyOwner {
779         _isExcludedFromFees[account] = excluded;
780         emit ExcludeFromFees(account, excluded);
781     }
782 
783     function setAutomatedMarketMakerPair(address pair, bool value)
784         public
785         onlyOwner
786     {
787         require(
788             pair != uniswapV2Pair,
789             "The pair cannot be removed from automatedMarketMakerPairs"
790         );
791 
792         _setAutomatedMarketMakerPair(pair, value);
793     }
794 
795     function _setAutomatedMarketMakerPair(address pair, bool value) private {
796         automatedMarketMakerPairs[pair] = value;
797 
798         emit SetAutomatedMarketMakerPair(pair, value);
799     }
800 
801     function updateMarketingWalletInfo(address newMarketingWallet)
802         external
803         onlyOwner
804     {
805         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
806         marketingWallet = newMarketingWallet;
807     }
808 
809     function updateDevelopmentWalletInfo(address newWallet) external onlyOwner {
810         emit developmentWalletUpdated(newWallet, developmentWallet);
811         developmentWallet = newWallet;
812     }
813 
814     function isExcludedFromFees(address account) public view returns (bool) {
815         return _isExcludedFromFees[account];
816     }
817 
818     event BoughtEarly(address indexed sniper);
819 
820     function _transfer(
821         address from,
822         address to,
823         uint256 amount
824     ) internal override {
825         require(from != address(0), "ERC20: transfer from the zero address");
826         require(to != address(0), "ERC20: transfer to the zero address");
827 
828         if (amount == 0) {
829             super._transfer(from, to, 0);
830             return;
831         }
832 
833         if (limitsInEffect) {
834             if (
835                 from != owner() &&
836                 to != owner() &&
837                 to != address(0) &&
838                 to != address(0xdead) &&
839                 !swapping
840             ) {
841                 if (!tradingActive) {
842                     require(
843                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
844                         "Trading is not active."
845                     );
846                 }
847 
848                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
849                 if (transferDelayEnabled) {
850                     if (
851                         to != owner() &&
852                         to != address(uniswapV2Router) &&
853                         to != address(uniswapV2Pair)
854                     ) {
855                         require(
856                             _holderLastTransferTimestamp[tx.origin] <
857                                 block.number,
858                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
859                         );
860                         _holderLastTransferTimestamp[tx.origin] = block.number;
861                     }
862                 }
863 
864                 //when buy
865                 if (
866                     automatedMarketMakerPairs[from] &&
867                     !_isExcludedMaxTransactionAmount[to]
868                 ) {
869                     require(
870                         amount <= maxTransactionAmount,
871                         "Buy transfer amount exceeds the maxTransactionAmount."
872                     );
873                     require(
874                         amount + balanceOf(to) <= maxWallet,
875                         "Max wallet exceeded"
876                     );
877                 }
878                 //when sell
879                 else if (
880                     automatedMarketMakerPairs[to] &&
881                     !_isExcludedMaxTransactionAmount[from]
882                 ) {
883                     require(
884                         amount <= maxTransactionAmount,
885                         "Sell transfer amount exceeds the maxTransactionAmount."
886                     );
887                 } else if (!_isExcludedMaxTransactionAmount[to]) {
888                     require(
889                         amount + balanceOf(to) <= maxWallet,
890                         "Max wallet exceeded"
891                     );
892                 }
893             }
894         }
895 
896         uint256 contractTokenBalance = balanceOf(address(this));
897 
898         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
899 
900         if (
901             canSwap &&
902             swapEnabled &&
903             !swapping &&
904             !automatedMarketMakerPairs[from] &&
905             !_isExcludedFromFees[from] &&
906             !_isExcludedFromFees[to]
907         ) {
908             swapping = true;
909 
910             swapBack();
911 
912             swapping = false;
913         }
914 
915         if (
916             !swapping &&
917             automatedMarketMakerPairs[to] &&
918             lpBurnEnabled &&
919             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
920             !_isExcludedFromFees[from]
921         ) {
922             autoBurnLiquidityPairTokens();
923         }
924 
925         bool takeFee = !swapping;
926 
927         // if any account belongs to _isExcludedFromFee account then remove the fee
928         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
929             takeFee = false;
930         }
931 
932         uint256 fees = 0;
933         // only take fees on buys/sells, do not take on wallet transfers
934         if (takeFee) {
935             // on sell
936             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
937                 fees = amount.mul(sellTotalFees).div(100);
938                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
939                 tokensForDev += (fees * sellDevelopmentFee) / sellTotalFees;
940                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
941             }
942             // on buy
943             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
944                 fees = amount.mul(buyTotalFees).div(100);
945                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
946                 tokensForDev += (fees * buyDevelopmentFee) / buyTotalFees;
947                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
948             }
949 
950             if (fees > 0) {
951                 super._transfer(from, address(this), fees);
952             }
953 
954             amount -= fees;
955         }
956 
957         super._transfer(from, to, amount);
958     }
959 
960     function swapTokensForEth(uint256 tokenAmount) private {
961         // generate the uniswap pair path of token -> weth
962         address[] memory path = new address[](2);
963         path[0] = address(this);
964         path[1] = uniswapV2Router.WETH();
965 
966         _approve(address(this), address(uniswapV2Router), tokenAmount);
967 
968         // make the swap
969         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
970             tokenAmount,
971             0, // accept any amount of ETH
972             path,
973             address(this),
974             block.timestamp
975         );
976     }
977 
978     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
979         // approve token transfer to cover all possible scenarios
980         _approve(address(this), address(uniswapV2Router), tokenAmount);
981 
982         // add the liquidity
983         uniswapV2Router.addLiquidityETH{value: ethAmount}(
984             address(this),
985             tokenAmount,
986             0, // slippage is unavoidable
987             0, // slippage is unavoidable
988             deadAddress,
989             block.timestamp
990         );
991     }
992 
993     function swapBack() private {
994         uint256 contractBalance = balanceOf(address(this));
995         uint256 totalTokensToSwap = tokensForLiquidity +
996             tokensForMarketing +
997             tokensForDev;
998         bool success;
999 
1000         if (contractBalance == 0 || totalTokensToSwap == 0) {
1001             return;
1002         }
1003 
1004         if (contractBalance > swapTokensAtAmount * 20) {
1005             contractBalance = swapTokensAtAmount * 20;
1006         }
1007 
1008         // Halve the amount of liquidity tokens
1009         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1010             totalTokensToSwap /
1011             2;
1012         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1013 
1014         uint256 initialETHBalance = address(this).balance;
1015 
1016         swapTokensForEth(amountToSwapForETH);
1017 
1018         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1019 
1020         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1021             totalTokensToSwap
1022         );
1023         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1024 
1025         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1026 
1027         tokensForLiquidity = 0;
1028         tokensForMarketing = 0;
1029         tokensForDev = 0;
1030 
1031         (success, ) = address(developmentWallet).call{value: ethForDev}("");
1032 
1033         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1034             addLiquidity(liquidityTokens, ethForLiquidity);
1035             emit SwapAndLiquify(
1036                 amountToSwapForETH,
1037                 ethForLiquidity,
1038                 tokensForLiquidity
1039             );
1040         }
1041 
1042         (success, ) = address(marketingWallet).call{
1043             value: address(this).balance
1044         }("");
1045     }
1046 
1047     function setAutoLPBurnSettings(
1048         uint256 _frequencyInSeconds,
1049         uint256 _percent,
1050         bool _Enabled
1051     ) external onlyOwner {
1052         require(
1053             _frequencyInSeconds >= 600,
1054             "cannot set buyback more often than every 10 minutes"
1055         );
1056         require(
1057             _percent <= 1000 && _percent >= 0,
1058             "Must set auto LP burn percent between 0% and 10%"
1059         );
1060         lpBurnFrequency = _frequencyInSeconds;
1061         percentForLPBurn = _percent;
1062         lpBurnEnabled = _Enabled;
1063     }
1064 
1065     function autoBurnLiquidityPairTokens() internal returns (bool) {
1066         lastLpBurnTime = block.timestamp;
1067 
1068         // get balance of liquidity pair
1069         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1070 
1071         // calculate amount to burn
1072         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1073             10000
1074         );
1075 
1076         // pull tokens from pancakePair liquidity and move to dead address permanently
1077         if (amountToBurn > 0) {
1078             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1079         }
1080 
1081         //sync price since this is not in a swap transaction!
1082         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1083         pair.sync();
1084         emit AutoNukeLP();
1085         return true;
1086     }
1087 
1088     function manualBurnLiquidityPairTokens(uint256 percent)
1089         external
1090         onlyOwner
1091         returns (bool)
1092     {
1093         require(
1094             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1095             "Must wait for cooldown to finish"
1096         );
1097         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1098         lastManualLpBurnTime = block.timestamp;
1099 
1100         // get balance of liquidity pair
1101         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1102 
1103         // calculate amount to burn
1104         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1105 
1106         // pull tokens from pancakePair liquidity and move to dead address permanently
1107         if (amountToBurn > 0) {
1108             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1109         }
1110 
1111         //sync price since this is not in a swap transaction!
1112         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1113         pair.sync();
1114         emit ManualNukeLP();
1115         return true;
1116     }
1117 }