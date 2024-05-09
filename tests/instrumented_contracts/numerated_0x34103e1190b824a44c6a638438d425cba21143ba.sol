1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
4 pragma experimental ABIEncoderV2;
5 
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
17 
18 abstract contract Ownable is Context {
19     address private _owner;
20 
21     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23     constructor() {
24         _transferOwnership(_msgSender());
25     }
26 
27     function owner() public view virtual returns (address) {
28         return _owner;
29     }
30 
31     modifier onlyOwner() {
32         require(owner() == _msgSender(), "Ownable: caller is not the owner");
33         _;
34     }
35 
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
46 
47     function _transferOwnership(address newOwner) internal virtual {
48         address oldOwner = _owner;
49         _owner = newOwner;
50         emit OwnershipTransferred(oldOwner, newOwner);
51     }
52 }
53 
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
82 
83 interface IERC20Metadata is IERC20 {
84 
85     function name() external view returns (string memory);
86 
87     function symbol() external view returns (string memory);
88 
89     function decimals() external view returns (uint8);
90 }
91 
92 
93 contract ERC20 is Context, IERC20, IERC20Metadata {
94     mapping(address => uint256) private _balances;
95 
96     mapping(address => mapping(address => uint256)) private _allowances;
97 
98     uint256 private _totalSupply;
99 
100     string private _name;
101     string private _symbol;
102 
103 
104 
105     constructor(string memory name_, string memory symbol_) {
106         _name = name_;
107         _symbol = symbol_;
108     }
109 
110 
111     function name() public view virtual override returns (string memory) {
112         return _name;
113     }
114 
115 
116     function symbol() public view virtual override returns (string memory) {
117         return _symbol;
118     }
119 
120 
121     function decimals() public view virtual override returns (uint8) {
122         return 18;
123     }
124 
125 
126     function totalSupply() public view virtual override returns (uint256) {
127         return _totalSupply;
128     }
129 
130     function balanceOf(address account) public view virtual override returns (uint256) {
131         return _balances[account];
132     }
133 
134     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
135         _transfer(_msgSender(), recipient, amount);
136         return true;
137     }
138 
139 
140     function allowance(address owner, address spender) public view virtual override returns (uint256) {
141         return _allowances[owner][spender];
142     }
143 
144     function approve(address spender, uint256 amount) public virtual override returns (bool) {
145         _approve(_msgSender(), spender, amount);
146         return true;
147     }
148 
149     function transferFrom(
150         address sender,
151         address recipient,
152         uint256 amount
153     ) public virtual override returns (bool) {
154         _transfer(sender, recipient, amount);
155 
156         uint256 currentAllowance = _allowances[sender][_msgSender()];
157         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
158         unchecked {
159             _approve(sender, _msgSender(), currentAllowance - amount);
160         }
161 
162         return true;
163     }
164 
165     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
166         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
167         return true;
168     }
169 
170     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
171         uint256 currentAllowance = _allowances[_msgSender()][spender];
172         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
173         unchecked {
174             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
175         }
176 
177         return true;
178     }
179 
180     function _transfer(
181         address sender,
182         address recipient,
183         uint256 amount
184     ) internal virtual {
185         require(sender != address(0), "ERC20: transfer from the zero address");
186         require(recipient != address(0), "ERC20: transfer to the zero address");
187 
188         _beforeTokenTransfer(sender, recipient, amount);
189 
190         uint256 senderBalance = _balances[sender];
191         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
192         unchecked {
193             _balances[sender] = senderBalance - amount;
194         }
195         _balances[recipient] += amount;
196 
197         emit Transfer(sender, recipient, amount);
198 
199         _afterTokenTransfer(sender, recipient, amount);
200     }
201 
202     function _mint(address account, uint256 amount) internal virtual {
203         require(account != address(0), "ERC20: mint to the zero address");
204 
205         _beforeTokenTransfer(address(0), account, amount);
206 
207         _totalSupply += amount;
208         _balances[account] += amount;
209         emit Transfer(address(0), account, amount);
210 
211         _afterTokenTransfer(address(0), account, amount);
212     }
213 
214     function _burn(address account, uint256 amount) internal virtual {
215         require(account != address(0), "ERC20: burn from the zero address");
216 
217         _beforeTokenTransfer(account, address(0), amount);
218 
219         uint256 accountBalance = _balances[account];
220         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
221         unchecked {
222             _balances[account] = accountBalance - amount;
223         }
224         _totalSupply -= amount;
225 
226         emit Transfer(account, address(0), amount);
227 
228         _afterTokenTransfer(account, address(0), amount);
229     }
230 
231     function _approve(
232         address owner,
233         address spender,
234         uint256 amount
235     ) internal virtual {
236         require(owner != address(0), "ERC20: approve from the zero address");
237         require(spender != address(0), "ERC20: approve to the zero address");
238 
239         _allowances[owner][spender] = amount;
240         emit Approval(owner, spender, amount);
241     }
242 
243     function _beforeTokenTransfer(
244         address from,
245         address to,
246         uint256 amount
247     ) internal virtual {}
248 
249     function _afterTokenTransfer(
250         address from,
251         address to,
252         uint256 amount
253     ) internal virtual {}
254 }
255 
256 
257 library SafeMath {
258 
259     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
260         unchecked {
261             uint256 c = a + b;
262             if (c < a) return (false, 0);
263             return (true, c);
264         }
265     }
266 
267     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
268         unchecked {
269             if (b > a) return (false, 0);
270             return (true, a - b);
271         }
272     }
273 
274 
275     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
276         unchecked {
277             if (a == 0) return (true, 0);
278             uint256 c = a * b;
279             if (c / a != b) return (false, 0);
280             return (true, c);
281         }
282     }
283 
284     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
285         unchecked {
286             if (b == 0) return (false, 0);
287             return (true, a / b);
288         }
289     }
290 
291     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
292         unchecked {
293             if (b == 0) return (false, 0);
294             return (true, a % b);
295         }
296     }
297 
298 
299     function add(uint256 a, uint256 b) internal pure returns (uint256) {
300         return a + b;
301     }
302 
303     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
304         return a - b;
305     }
306 
307     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
308         return a * b;
309     }
310 
311     function div(uint256 a, uint256 b) internal pure returns (uint256) {
312         return a / b;
313     }
314 
315     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
316         return a % b;
317     }
318 
319     function sub(
320         uint256 a,
321         uint256 b,
322         string memory errorMessage
323     ) internal pure returns (uint256) {
324         unchecked {
325             require(b <= a, errorMessage);
326             return a - b;
327         }
328     }
329 
330     function div(
331         uint256 a,
332         uint256 b,
333         string memory errorMessage
334     ) internal pure returns (uint256) {
335         unchecked {
336             require(b > 0, errorMessage);
337             return a / b;
338         }
339     }
340 
341 
342     function mod(
343         uint256 a,
344         uint256 b,
345         string memory errorMessage
346     ) internal pure returns (uint256) {
347         unchecked {
348             require(b > 0, errorMessage);
349             return a % b;
350         }
351     }
352 }
353 
354 
355 interface IUniswapV2Factory {
356     event PairCreated(
357         address indexed token0,
358         address indexed token1,
359         address pair,
360         uint256
361     );
362 
363     function feeTo() external view returns (address);
364 
365     function feeToSetter() external view returns (address);
366 
367     function getPair(address tokenA, address tokenB)
368         external
369         view
370         returns (address pair);
371 
372     function allPairs(uint256) external view returns (address pair);
373 
374     function allPairsLength() external view returns (uint256);
375 
376     function createPair(address tokenA, address tokenB)
377         external
378         returns (address pair);
379 
380     function setFeeTo(address) external;
381 
382     function setFeeToSetter(address) external;
383 }
384 
385 
386 interface IUniswapV2Pair {
387     event Approval(
388         address indexed owner,
389         address indexed spender,
390         uint256 value
391     );
392     event Transfer(address indexed from, address indexed to, uint256 value);
393 
394     function name() external pure returns (string memory);
395 
396     function symbol() external pure returns (string memory);
397 
398     function decimals() external pure returns (uint8);
399 
400     function totalSupply() external view returns (uint256);
401 
402     function balanceOf(address owner) external view returns (uint256);
403 
404     function allowance(address owner, address spender)
405         external
406         view
407         returns (uint256);
408 
409     function approve(address spender, uint256 value) external returns (bool);
410 
411     function transfer(address to, uint256 value) external returns (bool);
412 
413     function transferFrom(
414         address from,
415         address to,
416         uint256 value
417     ) external returns (bool);
418 
419     function DOMAIN_SEPARATOR() external view returns (bytes32);
420 
421     function PERMIT_TYPEHASH() external pure returns (bytes32);
422 
423     function nonces(address owner) external view returns (uint256);
424 
425     function permit(
426         address owner,
427         address spender,
428         uint256 value,
429         uint256 deadline,
430         uint8 v,
431         bytes32 r,
432         bytes32 s
433     ) external;
434 
435     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
436     event Burn(
437         address indexed sender,
438         uint256 amount0,
439         uint256 amount1,
440         address indexed to
441     );
442     event Swap(
443         address indexed sender,
444         uint256 amount0In,
445         uint256 amount1In,
446         uint256 amount0Out,
447         uint256 amount1Out,
448         address indexed to
449     );
450     event Sync(uint112 reserve0, uint112 reserve1);
451 
452     function MINIMUM_LIQUIDITY() external pure returns (uint256);
453 
454     function factory() external view returns (address);
455 
456     function token0() external view returns (address);
457 
458     function token1() external view returns (address);
459 
460     function getReserves()
461         external
462         view
463         returns (
464             uint112 reserve0,
465             uint112 reserve1,
466             uint32 blockTimestampLast
467         );
468 
469     function price0CumulativeLast() external view returns (uint256);
470 
471     function price1CumulativeLast() external view returns (uint256);
472 
473     function kLast() external view returns (uint256);
474 
475     function mint(address to) external returns (uint256 liquidity);
476 
477     function burn(address to)
478         external
479         returns (uint256 amount0, uint256 amount1);
480 
481     function swap(
482         uint256 amount0Out,
483         uint256 amount1Out,
484         address to,
485         bytes calldata data
486     ) external;
487 
488     function skim(address to) external;
489 
490     function sync() external;
491 
492     function initialize(address, address) external;
493 }
494 
495 
496 interface IUniswapV2Router02 {
497     function factory() external pure returns (address);
498 
499     function WETH() external pure returns (address);
500 
501     function addLiquidity(
502         address tokenA,
503         address tokenB,
504         uint256 amountADesired,
505         uint256 amountBDesired,
506         uint256 amountAMin,
507         uint256 amountBMin,
508         address to,
509         uint256 deadline
510     )
511         external
512         returns (
513             uint256 amountA,
514             uint256 amountB,
515             uint256 liquidity
516         );
517 
518     function addLiquidityETH(
519         address token,
520         uint256 amountTokenDesired,
521         uint256 amountTokenMin,
522         uint256 amountETHMin,
523         address to,
524         uint256 deadline
525     )
526         external
527         payable
528         returns (
529             uint256 amountToken,
530             uint256 amountETH,
531             uint256 liquidity
532         );
533 
534     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
535         uint256 amountIn,
536         uint256 amountOutMin,
537         address[] calldata path,
538         address to,
539         uint256 deadline
540     ) external;
541 
542     function swapExactETHForTokensSupportingFeeOnTransferTokens(
543         uint256 amountOutMin,
544         address[] calldata path,
545         address to,
546         uint256 deadline
547     ) external payable;
548 
549     function swapExactTokensForETHSupportingFeeOnTransferTokens(
550         uint256 amountIn,
551         uint256 amountOutMin,
552         address[] calldata path,
553         address to,
554         uint256 deadline
555     ) external;
556 }
557 
558 
559 
560 contract BITE is ERC20, Ownable {
561     using SafeMath for uint256;
562 
563     IUniswapV2Router02 public immutable uniswapV2Router;
564     address public immutable uniswapV2Pair;
565     address public constant deadAddress = address(0xdead);
566 
567     bool private swapping;
568 
569     address private marketingWallet;
570     address private developmentWallet;
571 
572     uint256 public percentForLPBurn = 0; 
573     bool public lpBurnEnabled = false;
574     uint256 public lpBurnFrequency = 3600 seconds;
575     uint256 public lastLpBurnTime;
576 
577     uint256 public maxTransactionAmount;
578     uint256 public swapTokensAtAmount;
579     uint256 public maxWallet;
580 
581     bool public limitsInEffect = true;
582     bool public tradingActive = false;
583     bool public swapEnabled = true;
584 
585     uint256 public manualBurnFrequency = 30 minutes;
586     uint256 public lastManualLpBurnTime;
587 
588 
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
641     constructor() ERC20("Bite", "BITE") {
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
654         uint256 _buyMarketingFee = 20;
655         uint256 _buyLiquidityFee = 0;
656         uint256 _buyDevelopmentFee = 5;
657 
658         uint256 _sellMarketingFee = 28;
659         uint256 _sellLiquidityFee = 0;
660         uint256 _sellDevelopmentFee = 7;
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
678         marketingWallet = address(0xe9cAf349AF117D25653996ac828eed04242C60de); 
679         developmentWallet = address(0x17D3DFFCf5354CabAcF148F629DD900EC7fe1ea1); 
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
694     function enableBite() external onlyOwner {
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
775         require(sellTotalFees <= 40, "Must keep fees at 40% or less");
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