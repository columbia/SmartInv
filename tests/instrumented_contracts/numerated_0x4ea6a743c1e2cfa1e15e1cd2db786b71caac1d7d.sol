1 // 
2 // https://twitter.com/EtherRock_ETH
3 // https://t.me/EtherROCKETH
4 // Just a $ROCK
5 // 
6 
7 // SPDX-License-Identifier: MIT
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
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 interface IERC20Metadata is IERC20 {
85 
86     function name() external view returns (string memory);
87 
88     function symbol() external view returns (string memory);
89 
90     function decimals() external view returns (uint8);
91 }
92 
93 
94 contract ERC20 is Context, IERC20, IERC20Metadata {
95     mapping(address => uint256) private _balances;
96 
97     mapping(address => mapping(address => uint256)) private _allowances;
98 
99     uint256 private _totalSupply;
100 
101     string private _name;
102     string private _symbol;
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
559 contract ROCK is ERC20, Ownable {
560     using SafeMath for uint256;
561 
562     IUniswapV2Router02 public immutable uniswapV2Router;
563     address public immutable uniswapV2Pair;
564     address public constant deadAddress = address(0xdead);
565 
566     bool private swapping;
567 
568     address private marketingWallet;
569     address private developmentWallet;
570 
571     uint256 public maxTransactionAmount;
572     uint256 public swapTokensAtAmount;
573     uint256 public maxWallet;
574 
575     uint256 public percentForLPBurn = 0; 
576     bool public lpBurnEnabled = false;
577     uint256 public lpBurnFrequency = 3600 seconds;
578     uint256 public lastLpBurnTime;
579 
580     uint256 public manualBurnFrequency = 30 minutes;
581     uint256 public lastManualLpBurnTime;
582 
583     bool public limitsInEffect = true;
584     bool public tradingActive = false;
585     bool public swapEnabled = true;
586 
587     mapping(address => uint256) private _holderLastTransferTimestamp; 
588     bool public transferDelayEnabled = true;
589 
590     uint256 public buyTotalFees;
591     uint256 public buyMarketingFee;
592     uint256 public buyLiquidityFee;
593     uint256 public buyDevelopmentFee;
594 
595     uint256 public sellTotalFees;
596     uint256 public sellMarketingFee;
597     uint256 public sellLiquidityFee;
598     uint256 public sellDevelopmentFee;
599 
600     uint256 public tokensForMarketing;
601     uint256 public tokensForLiquidity;
602     uint256 public tokensForDev;
603 
604     mapping(address => bool) private _isExcludedFromFees;
605     mapping(address => bool) public _isExcludedMaxTransactionAmount;
606 
607     mapping(address => bool) public automatedMarketMakerPairs;
608 
609     event UpdateUniswapV2Router(
610         address indexed newAddress,
611         address indexed oldAddress
612     );
613 
614     event ExcludeFromFees(address indexed account, bool isExcluded);
615 
616     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
617 
618     event marketingWalletUpdated(
619         address indexed newWallet,
620         address indexed oldWallet
621     );
622 
623     event developmentWalletUpdated(
624         address indexed newWallet,
625         address indexed oldWallet
626     );
627 
628     event SwapAndLiquify(
629         uint256 tokensSwapped,
630         uint256 ethReceived,
631         uint256 tokensIntoLiquidity
632     );
633 
634     event AutoNukeLP();
635 
636     event ManualNukeLP();
637 
638     constructor() ERC20("ROCK", "ROCK") {
639         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
640             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
641         );
642 
643         excludeFromMaxTransaction(address(_uniswapV2Router), true);
644         uniswapV2Router = _uniswapV2Router;
645 
646         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
647             .createPair(address(this), _uniswapV2Router.WETH());
648         excludeFromMaxTransaction(address(uniswapV2Pair), true);
649         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
650 
651         uint256 _buyMarketingFee = 25;
652         uint256 _buyLiquidityFee = 0;
653         uint256 _buyDevelopmentFee = 0;
654 
655         uint256 _sellMarketingFee = 30;
656         uint256 _sellLiquidityFee = 0;
657         uint256 _sellDevelopmentFee = 0;
658 
659         uint256 totalSupply = 100_000_000 * 1e18;
660 
661         maxTransactionAmount = 2_000_000 * 1e18; 
662         maxWallet = 2_000_000 * 1e18; 
663         swapTokensAtAmount = (totalSupply * 10) / 10000;
664 
665         buyMarketingFee = _buyMarketingFee;
666         buyLiquidityFee = _buyLiquidityFee;
667         buyDevelopmentFee = _buyDevelopmentFee;
668         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
669 
670         sellMarketingFee = _sellMarketingFee;
671         sellLiquidityFee = _sellLiquidityFee;
672         sellDevelopmentFee = _sellDevelopmentFee;
673         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
674 
675         marketingWallet = address(0xB6D39a1782697be088188d58AE8b48b540182A80); 
676         developmentWallet = address(0xB6D39a1782697be088188d58AE8b48b540182A80); 
677 
678         excludeFromFees(owner(), true);
679         excludeFromFees(address(this), true);
680         excludeFromFees(address(0xdead), true);
681 
682         excludeFromMaxTransaction(owner(), true);
683         excludeFromMaxTransaction(address(this), true);
684         excludeFromMaxTransaction(address(0xdead), true);
685 
686         _mint(msg.sender, totalSupply);
687     }
688 
689     receive() external payable {}
690 
691     function enableTrading() external onlyOwner {
692         tradingActive = true;
693         swapEnabled = true;
694         lastLpBurnTime = block.timestamp;
695     }
696 
697     function removeLimits() external onlyOwner returns (bool) {
698         limitsInEffect = false;
699         return true;
700     }
701 
702     function disableTransferDelay() external onlyOwner returns (bool) {
703         transferDelayEnabled = false;
704         return true;
705     }
706 
707     function updateSwapTokensAtAmount(uint256 newAmount)
708         external
709         onlyOwner
710         returns (bool)
711     {
712         require(
713             newAmount >= (totalSupply() * 1) / 100000,
714             "Swap amount cannot be lower than 0.001% total supply."
715         );
716         require(
717             newAmount <= (totalSupply() * 5) / 1000,
718             "Swap amount cannot be higher than 0.5% total supply."
719         );
720         swapTokensAtAmount = newAmount;
721         return true;
722     }
723 
724     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
725         require(
726             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
727             "Cannot set maxTransactionAmount lower than 0.1%"
728         );
729         maxTransactionAmount = newNum * (10**18);
730     }
731 
732     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
733         require(
734             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
735             "Cannot set maxWallet lower than 0.5%"
736         );
737         maxWallet = newNum * (10**18);
738     }
739 
740     function excludeFromMaxTransaction(address updAds, bool isEx)
741         public
742         onlyOwner
743     {
744         _isExcludedMaxTransactionAmount[updAds] = isEx;
745     }
746 
747     function updateSwapEnabled(bool enabled) external onlyOwner {
748         swapEnabled = enabled;
749     }
750 
751     function updateBuyFees(
752         uint256 _marketingFee,
753         uint256 _liquidityFee,
754         uint256 _developmentFee
755     ) external onlyOwner {
756         buyMarketingFee = _marketingFee;
757         buyLiquidityFee = _liquidityFee;
758         buyDevelopmentFee = _developmentFee;
759         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
760         require(buyTotalFees <= 35, "Must keep fees at 35% or less");
761     }
762 
763     function updateSellFees(
764         uint256 _marketingFee,
765         uint256 _liquidityFee,
766         uint256 _developmentFee
767     ) external onlyOwner {
768         sellMarketingFee = _marketingFee;
769         sellLiquidityFee = _liquidityFee;
770         sellDevelopmentFee = _developmentFee;
771         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
772         require(sellTotalFees <= 40, "Must keep fees at 40% or less");
773     }
774 
775     function excludeFromFees(address account, bool excluded) public onlyOwner {
776         _isExcludedFromFees[account] = excluded;
777         emit ExcludeFromFees(account, excluded);
778     }
779 
780     function setAutomatedMarketMakerPair(address pair, bool value)
781         public
782         onlyOwner
783     {
784         require(
785             pair != uniswapV2Pair,
786             "The pair cannot be removed from automatedMarketMakerPairs"
787         );
788 
789         _setAutomatedMarketMakerPair(pair, value);
790     }
791 
792     function _setAutomatedMarketMakerPair(address pair, bool value) private {
793         automatedMarketMakerPairs[pair] = value;
794 
795         emit SetAutomatedMarketMakerPair(pair, value);
796     }
797 
798     function updateMarketingWalletInfo(address newMarketingWallet)
799         external
800         onlyOwner
801     {
802         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
803         marketingWallet = newMarketingWallet;
804     }
805 
806     function updateDevelopmentWalletInfo(address newWallet) external onlyOwner {
807         emit developmentWalletUpdated(newWallet, developmentWallet);
808         developmentWallet = newWallet;
809     }
810 
811     function isExcludedFromFees(address account) public view returns (bool) {
812         return _isExcludedFromFees[account];
813     }
814 
815     event BoughtEarly(address indexed sniper);
816 
817     function _transfer(
818         address from,
819         address to,
820         uint256 amount
821     ) internal override {
822         require(from != address(0), "ERC20: transfer from the zero address");
823         require(to != address(0), "ERC20: transfer to the zero address");
824 
825         if (amount == 0) {
826             super._transfer(from, to, 0);
827             return;
828         }
829 
830         if (limitsInEffect) {
831             if (
832                 from != owner() &&
833                 to != owner() &&
834                 to != address(0) &&
835                 to != address(0xdead) &&
836                 !swapping
837             ) {
838                 if (!tradingActive) {
839                     require(
840                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
841                         "Trading is not active."
842                     );
843                 }
844 
845                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
846                 if (transferDelayEnabled) {
847                     if (
848                         to != owner() &&
849                         to != address(uniswapV2Router) &&
850                         to != address(uniswapV2Pair)
851                     ) {
852                         require(
853                             _holderLastTransferTimestamp[tx.origin] <
854                                 block.number,
855                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
856                         );
857                         _holderLastTransferTimestamp[tx.origin] = block.number;
858                     }
859                 }
860 
861                 //when buy
862                 if (
863                     automatedMarketMakerPairs[from] &&
864                     !_isExcludedMaxTransactionAmount[to]
865                 ) {
866                     require(
867                         amount <= maxTransactionAmount,
868                         "Buy transfer amount exceeds the maxTransactionAmount."
869                     );
870                     require(
871                         amount + balanceOf(to) <= maxWallet,
872                         "Max wallet exceeded"
873                     );
874                 }
875                 //when sell
876                 else if (
877                     automatedMarketMakerPairs[to] &&
878                     !_isExcludedMaxTransactionAmount[from]
879                 ) {
880                     require(
881                         amount <= maxTransactionAmount,
882                         "Sell transfer amount exceeds the maxTransactionAmount."
883                     );
884                 } else if (!_isExcludedMaxTransactionAmount[to]) {
885                     require(
886                         amount + balanceOf(to) <= maxWallet,
887                         "Max wallet exceeded"
888                     );
889                 }
890             }
891         }
892 
893         uint256 contractTokenBalance = balanceOf(address(this));
894 
895         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
896 
897         if (
898             canSwap &&
899             swapEnabled &&
900             !swapping &&
901             !automatedMarketMakerPairs[from] &&
902             !_isExcludedFromFees[from] &&
903             !_isExcludedFromFees[to]
904         ) {
905             swapping = true;
906 
907             swapBack();
908 
909             swapping = false;
910         }
911 
912         if (
913             !swapping &&
914             automatedMarketMakerPairs[to] &&
915             lpBurnEnabled &&
916             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
917             !_isExcludedFromFees[from]
918         ) {
919             autoBurnLiquidityPairTokens();
920         }
921 
922         bool takeFee = !swapping;
923 
924         // if any account belongs to _isExcludedFromFee account then remove the fee
925         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
926             takeFee = false;
927         }
928 
929         uint256 fees = 0;
930         // only take fees on buys/sells, do not take on wallet transfers
931         if (takeFee) {
932             // on sell
933             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
934                 fees = amount.mul(sellTotalFees).div(100);
935                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
936                 tokensForDev += (fees * sellDevelopmentFee) / sellTotalFees;
937                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
938             }
939             // on buy
940             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
941                 fees = amount.mul(buyTotalFees).div(100);
942                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
943                 tokensForDev += (fees * buyDevelopmentFee) / buyTotalFees;
944                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
945             }
946 
947             if (fees > 0) {
948                 super._transfer(from, address(this), fees);
949             }
950 
951             amount -= fees;
952         }
953 
954         super._transfer(from, to, amount);
955     }
956 
957     function swapTokensForEth(uint256 tokenAmount) private {
958         // generate the uniswap pair path of token -> weth
959         address[] memory path = new address[](2);
960         path[0] = address(this);
961         path[1] = uniswapV2Router.WETH();
962 
963         _approve(address(this), address(uniswapV2Router), tokenAmount);
964 
965         // make the swap
966         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
967             tokenAmount,
968             0, // accept any amount of ETH
969             path,
970             address(this),
971             block.timestamp
972         );
973     }
974 
975     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
976         // approve token transfer to cover all possible scenarios
977         _approve(address(this), address(uniswapV2Router), tokenAmount);
978 
979         // add the liquidity
980         uniswapV2Router.addLiquidityETH{value: ethAmount}(
981             address(this),
982             tokenAmount,
983             0, // slippage is unavoidable
984             0, // slippage is unavoidable
985             deadAddress,
986             block.timestamp
987         );
988     }
989 
990     function swapBack() private {
991         uint256 contractBalance = balanceOf(address(this));
992         uint256 totalTokensToSwap = tokensForLiquidity +
993             tokensForMarketing +
994             tokensForDev;
995         bool success;
996 
997         if (contractBalance == 0 || totalTokensToSwap == 0) {
998             return;
999         }
1000 
1001         if (contractBalance > swapTokensAtAmount * 20) {
1002             contractBalance = swapTokensAtAmount * 20;
1003         }
1004 
1005         // Halve the amount of liquidity tokens
1006         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1007             totalTokensToSwap /
1008             2;
1009         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1010 
1011         uint256 initialETHBalance = address(this).balance;
1012 
1013         swapTokensForEth(amountToSwapForETH);
1014 
1015         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1016 
1017         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1018             totalTokensToSwap
1019         );
1020         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1021 
1022         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1023 
1024         tokensForLiquidity = 0;
1025         tokensForMarketing = 0;
1026         tokensForDev = 0;
1027 
1028         (success, ) = address(developmentWallet).call{value: ethForDev}("");
1029 
1030         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1031             addLiquidity(liquidityTokens, ethForLiquidity);
1032             emit SwapAndLiquify(
1033                 amountToSwapForETH,
1034                 ethForLiquidity,
1035                 tokensForLiquidity
1036             );
1037         }
1038 
1039         (success, ) = address(marketingWallet).call{
1040             value: address(this).balance
1041         }("");
1042     }
1043 
1044     function setAutoLPBurnSettings(
1045         uint256 _frequencyInSeconds,
1046         uint256 _percent,
1047         bool _Enabled
1048     ) external onlyOwner {
1049         require(
1050             _frequencyInSeconds >= 600,
1051             "cannot set buyback more often than every 10 minutes"
1052         );
1053         require(
1054             _percent <= 1000 && _percent >= 0,
1055             "Must set auto LP burn percent between 0% and 10%"
1056         );
1057         lpBurnFrequency = _frequencyInSeconds;
1058         percentForLPBurn = _percent;
1059         lpBurnEnabled = _Enabled;
1060     }
1061 
1062     function autoBurnLiquidityPairTokens() internal returns (bool) {
1063         lastLpBurnTime = block.timestamp;
1064 
1065         // get balance of liquidity pair
1066         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1067 
1068         // calculate amount to burn
1069         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1070             10000
1071         );
1072 
1073         // pull tokens from pancakePair liquidity and move to dead address permanently
1074         if (amountToBurn > 0) {
1075             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1076         }
1077 
1078         //sync price since this is not in a swap transaction!
1079         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1080         pair.sync();
1081         emit AutoNukeLP();
1082         return true;
1083     }
1084 
1085     function manualBurnLiquidityPairTokens(uint256 percent)
1086         external
1087         onlyOwner
1088         returns (bool)
1089     {
1090         require(
1091             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1092             "Must wait for cooldown to finish"
1093         );
1094         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1095         lastManualLpBurnTime = block.timestamp;
1096 
1097         // get balance of liquidity pair
1098         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1099 
1100         // calculate amount to burn
1101         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1102 
1103         // pull tokens from pancakePair liquidity and move to dead address permanently
1104         if (amountToBurn > 0) {
1105             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1106         }
1107 
1108         //sync price since this is not in a swap transaction!
1109         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1110         pair.sync();
1111         emit ManualNukeLP();
1112         return true;
1113     }
1114 }