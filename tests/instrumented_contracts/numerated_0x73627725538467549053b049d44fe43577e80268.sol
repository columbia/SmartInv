1 // https://t.me/madara_portal
2 // SPDX-License-Identifier: MIT
3 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
4 pragma experimental ABIEncoderV2;
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes calldata) {
12         return msg.data;
13     }
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
34 
35     function renounceOwnership() public virtual onlyOwner {
36         _transferOwnership(address(0));
37     }
38 
39     function transferOwnership(address newOwner) public virtual onlyOwner {
40         require(newOwner != address(0), "Ownable: new owner is the zero address");
41         _transferOwnership(newOwner);
42     }
43 
44 
45     function _transferOwnership(address newOwner) internal virtual {
46         address oldOwner = _owner;
47         _owner = newOwner;
48         emit OwnershipTransferred(oldOwner, newOwner);
49     }
50 }
51 
52 interface IERC20 {
53 
54     function totalSupply() external view returns (uint256);
55 
56     function balanceOf(address account) external view returns (uint256);
57 
58 
59     function transfer(address recipient, uint256 amount) external returns (bool);
60 
61 
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66 
67     function transferFrom(
68         address sender,
69         address recipient,
70         uint256 amount
71     ) external returns (bool);
72 
73 
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 interface IERC20Metadata is IERC20 {
80 
81     function name() external view returns (string memory);
82 
83     function symbol() external view returns (string memory);
84 
85     function decimals() external view returns (uint8);
86 }
87 
88 
89 contract ERC20 is Context, IERC20, IERC20Metadata {
90     mapping(address => uint256) private _balances;
91 
92     mapping(address => mapping(address => uint256)) private _allowances;
93 
94     uint256 private _totalSupply;
95 
96     string private _name;
97     string private _symbol;
98 
99 
100     constructor(string memory name_, string memory symbol_) {
101         _name = name_;
102         _symbol = symbol_;
103     }
104 
105 
106     function name() public view virtual override returns (string memory) {
107         return _name;
108     }
109 
110 
111     function symbol() public view virtual override returns (string memory) {
112         return _symbol;
113     }
114 
115 
116     function decimals() public view virtual override returns (uint8) {
117         return 18;
118     }
119 
120 
121     function totalSupply() public view virtual override returns (uint256) {
122         return _totalSupply;
123     }
124 
125     function balanceOf(address account) public view virtual override returns (uint256) {
126         return _balances[account];
127     }
128 
129     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
130         _transfer(_msgSender(), recipient, amount);
131         return true;
132     }
133 
134 
135     function allowance(address owner, address spender) public view virtual override returns (uint256) {
136         return _allowances[owner][spender];
137     }
138 
139     function approve(address spender, uint256 amount) public virtual override returns (bool) {
140         _approve(_msgSender(), spender, amount);
141         return true;
142     }
143 
144     function transferFrom(
145         address sender,
146         address recipient,
147         uint256 amount
148     ) public virtual override returns (bool) {
149         _transfer(sender, recipient, amount);
150 
151         uint256 currentAllowance = _allowances[sender][_msgSender()];
152         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
153         unchecked {
154             _approve(sender, _msgSender(), currentAllowance - amount);
155         }
156 
157         return true;
158     }
159 
160     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
161         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
162         return true;
163     }
164 
165     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
166         uint256 currentAllowance = _allowances[_msgSender()][spender];
167         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
168         unchecked {
169             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
170         }
171 
172         return true;
173     }
174 
175     function _transfer(
176         address sender,
177         address recipient,
178         uint256 amount
179     ) internal virtual {
180         require(sender != address(0), "ERC20: transfer from the zero address");
181         require(recipient != address(0), "ERC20: transfer to the zero address");
182 
183         _beforeTokenTransfer(sender, recipient, amount);
184 
185         uint256 senderBalance = _balances[sender];
186         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
187         unchecked {
188             _balances[sender] = senderBalance - amount;
189         }
190         _balances[recipient] += amount;
191 
192         emit Transfer(sender, recipient, amount);
193 
194         _afterTokenTransfer(sender, recipient, amount);
195     }
196 
197     function _mint(address account, uint256 amount) internal virtual {
198         require(account != address(0), "ERC20: mint to the zero address");
199 
200         _beforeTokenTransfer(address(0), account, amount);
201 
202         _totalSupply += amount;
203         _balances[account] += amount;
204         emit Transfer(address(0), account, amount);
205 
206         _afterTokenTransfer(address(0), account, amount);
207     }
208 
209     function _burn(address account, uint256 amount) internal virtual {
210         require(account != address(0), "ERC20: burn from the zero address");
211 
212         _beforeTokenTransfer(account, address(0), amount);
213 
214         uint256 accountBalance = _balances[account];
215         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
216         unchecked {
217             _balances[account] = accountBalance - amount;
218         }
219         _totalSupply -= amount;
220 
221         emit Transfer(account, address(0), amount);
222 
223         _afterTokenTransfer(account, address(0), amount);
224     }
225 
226     function _approve(
227         address owner,
228         address spender,
229         uint256 amount
230     ) internal virtual {
231         require(owner != address(0), "ERC20: approve from the zero address");
232         require(spender != address(0), "ERC20: approve to the zero address");
233 
234         _allowances[owner][spender] = amount;
235         emit Approval(owner, spender, amount);
236     }
237 
238     function _beforeTokenTransfer(
239         address from,
240         address to,
241         uint256 amount
242     ) internal virtual {}
243 
244     function _afterTokenTransfer(
245         address from,
246         address to,
247         uint256 amount
248     ) internal virtual {}
249 }
250 
251 
252 library SafeMath {
253 
254     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
255         unchecked {
256             uint256 c = a + b;
257             if (c < a) return (false, 0);
258             return (true, c);
259         }
260     }
261 
262     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
263         unchecked {
264             if (b > a) return (false, 0);
265             return (true, a - b);
266         }
267     }
268 
269 
270     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
271         unchecked {
272             if (a == 0) return (true, 0);
273             uint256 c = a * b;
274             if (c / a != b) return (false, 0);
275             return (true, c);
276         }
277     }
278 
279     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
280         unchecked {
281             if (b == 0) return (false, 0);
282             return (true, a / b);
283         }
284     }
285 
286     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
287         unchecked {
288             if (b == 0) return (false, 0);
289             return (true, a % b);
290         }
291     }
292 
293 
294     function add(uint256 a, uint256 b) internal pure returns (uint256) {
295         return a + b;
296     }
297 
298     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
299         return a - b;
300     }
301 
302     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
303         return a * b;
304     }
305 
306     function div(uint256 a, uint256 b) internal pure returns (uint256) {
307         return a / b;
308     }
309 
310     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
311         return a % b;
312     }
313 
314     function sub(
315         uint256 a,
316         uint256 b,
317         string memory errorMessage
318     ) internal pure returns (uint256) {
319         unchecked {
320             require(b <= a, errorMessage);
321             return a - b;
322         }
323     }
324 
325     function div(
326         uint256 a,
327         uint256 b,
328         string memory errorMessage
329     ) internal pure returns (uint256) {
330         unchecked {
331             require(b > 0, errorMessage);
332             return a / b;
333         }
334     }
335 
336 
337     function mod(
338         uint256 a,
339         uint256 b,
340         string memory errorMessage
341     ) internal pure returns (uint256) {
342         unchecked {
343             require(b > 0, errorMessage);
344             return a % b;
345         }
346     }
347 }
348 
349 
350 interface IUniswapV2Factory {
351     event PairCreated(
352         address indexed token0,
353         address indexed token1,
354         address pair,
355         uint256
356     );
357 
358     function feeTo() external view returns (address);
359 
360     function feeToSetter() external view returns (address);
361 
362     function getPair(address tokenA, address tokenB)
363         external
364         view
365         returns (address pair);
366 
367     function allPairs(uint256) external view returns (address pair);
368 
369     function allPairsLength() external view returns (uint256);
370 
371     function createPair(address tokenA, address tokenB)
372         external
373         returns (address pair);
374 
375     function setFeeTo(address) external;
376 
377     function setFeeToSetter(address) external;
378 }
379 
380 
381 interface IUniswapV2Pair {
382     event Approval(
383         address indexed owner,
384         address indexed spender,
385         uint256 value
386     );
387     event Transfer(address indexed from, address indexed to, uint256 value);
388 
389     function name() external pure returns (string memory);
390 
391     function symbol() external pure returns (string memory);
392 
393     function decimals() external pure returns (uint8);
394 
395     function totalSupply() external view returns (uint256);
396 
397     function balanceOf(address owner) external view returns (uint256);
398 
399     function allowance(address owner, address spender)
400         external
401         view
402         returns (uint256);
403 
404     function approve(address spender, uint256 value) external returns (bool);
405 
406     function transfer(address to, uint256 value) external returns (bool);
407 
408     function transferFrom(
409         address from,
410         address to,
411         uint256 value
412     ) external returns (bool);
413 
414     function DOMAIN_SEPARATOR() external view returns (bytes32);
415 
416     function PERMIT_TYPEHASH() external pure returns (bytes32);
417 
418     function nonces(address owner) external view returns (uint256);
419 
420     function permit(
421         address owner,
422         address spender,
423         uint256 value,
424         uint256 deadline,
425         uint8 v,
426         bytes32 r,
427         bytes32 s
428     ) external;
429 
430     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
431     event Burn(
432         address indexed sender,
433         uint256 amount0,
434         uint256 amount1,
435         address indexed to
436     );
437     event Swap(
438         address indexed sender,
439         uint256 amount0In,
440         uint256 amount1In,
441         uint256 amount0Out,
442         uint256 amount1Out,
443         address indexed to
444     );
445     event Sync(uint112 reserve0, uint112 reserve1);
446 
447     function MINIMUM_LIQUIDITY() external pure returns (uint256);
448 
449     function factory() external view returns (address);
450 
451     function token0() external view returns (address);
452 
453     function token1() external view returns (address);
454 
455     function getReserves()
456         external
457         view
458         returns (
459             uint112 reserve0,
460             uint112 reserve1,
461             uint32 blockTimestampLast
462         );
463 
464     function price0CumulativeLast() external view returns (uint256);
465 
466     function price1CumulativeLast() external view returns (uint256);
467 
468     function kLast() external view returns (uint256);
469 
470     function mint(address to) external returns (uint256 liquidity);
471 
472     function burn(address to)
473         external
474         returns (uint256 amount0, uint256 amount1);
475 
476     function swap(
477         uint256 amount0Out,
478         uint256 amount1Out,
479         address to,
480         bytes calldata data
481     ) external;
482 
483     function skim(address to) external;
484 
485     function sync() external;
486 
487     function initialize(address, address) external;
488 }
489 
490 
491 interface IUniswapV2Router02 {
492     function factory() external pure returns (address);
493 
494     function WETH() external pure returns (address);
495 
496     function addLiquidity(
497         address tokenA,
498         address tokenB,
499         uint256 amountADesired,
500         uint256 amountBDesired,
501         uint256 amountAMin,
502         uint256 amountBMin,
503         address to,
504         uint256 deadline
505     )
506         external
507         returns (
508             uint256 amountA,
509             uint256 amountB,
510             uint256 liquidity
511         );
512 
513     function addLiquidityETH(
514         address token,
515         uint256 amountTokenDesired,
516         uint256 amountTokenMin,
517         uint256 amountETHMin,
518         address to,
519         uint256 deadline
520     )
521         external
522         payable
523         returns (
524             uint256 amountToken,
525             uint256 amountETH,
526             uint256 liquidity
527         );
528 
529     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
530         uint256 amountIn,
531         uint256 amountOutMin,
532         address[] calldata path,
533         address to,
534         uint256 deadline
535     ) external;
536 
537     function swapExactETHForTokensSupportingFeeOnTransferTokens(
538         uint256 amountOutMin,
539         address[] calldata path,
540         address to,
541         uint256 deadline
542     ) external payable;
543 
544     function swapExactTokensForETHSupportingFeeOnTransferTokens(
545         uint256 amountIn,
546         uint256 amountOutMin,
547         address[] calldata path,
548         address to,
549         uint256 deadline
550     ) external;
551 }
552 
553 
554 contract MADARA is ERC20, Ownable {
555     using SafeMath for uint256;
556 
557     IUniswapV2Router02 public immutable uniswapV2Router;
558     address public immutable uniswapV2Pair;
559     address public constant deadAddress = address(0xdead);
560 
561     bool private swapping;
562 
563     address private marketingWallet;
564     address private developmentWallet;
565 
566     uint256 public maxTransactionAmount;
567     uint256 public swapTokensAtAmount;
568     uint256 public maxWallet;
569 
570     uint256 public percentForLPBurn = 0; 
571     bool public lpBurnEnabled = false;
572     uint256 public lpBurnFrequency = 3600 seconds;
573     uint256 public lastLpBurnTime;
574 
575     uint256 public manualBurnFrequency = 30 minutes;
576     uint256 public lastManualLpBurnTime;
577 
578     bool public limitsInEffect = true;
579     bool public tradingActive = false;
580     bool public swapEnabled = true;
581 
582     mapping(address => uint256) private _holderLastTransferTimestamp; 
583     bool public transferDelayEnabled = true;
584 
585     uint256 public buyTotalFees;
586     uint256 public buyMarketingFee;
587     uint256 public buyLiquidityFee;
588     uint256 public buyDevelopmentFee;
589 
590     uint256 public sellTotalFees;
591     uint256 public sellMarketingFee;
592     uint256 public sellLiquidityFee;
593     uint256 public sellDevelopmentFee;
594 
595     uint256 public tokensForMarketing;
596     uint256 public tokensForLiquidity;
597     uint256 public tokensForDev;
598 
599     mapping(address => bool) private _isExcludedFromFees;
600     mapping(address => bool) public _isExcludedMaxTransactionAmount;
601 
602     mapping(address => bool) public automatedMarketMakerPairs;
603 
604     event UpdateUniswapV2Router(
605         address indexed newAddress,
606         address indexed oldAddress
607     );
608 
609     event ExcludeFromFees(address indexed account, bool isExcluded);
610 
611     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
612 
613     event marketingWalletUpdated(
614         address indexed newWallet,
615         address indexed oldWallet
616     );
617 
618     event developmentWalletUpdated(
619         address indexed newWallet,
620         address indexed oldWallet
621     );
622 
623     event SwapAndLiquify(
624         uint256 tokensSwapped,
625         uint256 ethReceived,
626         uint256 tokensIntoLiquidity
627     );
628 
629     event AutoNukeLP();
630 
631     event ManualNukeLP();
632 
633     constructor() ERC20("Madara Uchiha", "MADARA") {
634         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
635             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
636         );
637 
638         excludeFromMaxTransaction(address(_uniswapV2Router), true);
639         uniswapV2Router = _uniswapV2Router;
640 
641         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
642             .createPair(address(this), _uniswapV2Router.WETH());
643         excludeFromMaxTransaction(address(uniswapV2Pair), true);
644         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
645 
646         uint256 _buyMarketingFee = 10;
647         uint256 _buyLiquidityFee = 0;
648         uint256 _buyDevelopmentFee = 10;
649 
650         uint256 _sellMarketingFee = 10;
651         uint256 _sellLiquidityFee = 0;
652         uint256 _sellDevelopmentFee = 10;
653 
654         uint256 totalSupply = 100_000_000 * 1e18;
655 
656         maxTransactionAmount = 2_000_000 * 1e18; 
657         maxWallet = 100_000 * 1e18; 
658         swapTokensAtAmount = (totalSupply * 10) / 10000;
659 
660         buyMarketingFee = _buyMarketingFee;
661         buyLiquidityFee = _buyLiquidityFee;
662         buyDevelopmentFee = _buyDevelopmentFee;
663         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
664 
665         sellMarketingFee = _sellMarketingFee;
666         sellLiquidityFee = _sellLiquidityFee;
667         sellDevelopmentFee = _sellDevelopmentFee;
668         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
669 
670         marketingWallet = address(0xe8fbc53F2BfF67b109a7849637BacDac4022aA1e); 
671         developmentWallet = address(0xe8fbc53F2BfF67b109a7849637BacDac4022aA1e); 
672 
673         excludeFromFees(owner(), true);
674         excludeFromFees(address(this), true);
675         excludeFromFees(address(0xdead), true);
676 
677         excludeFromMaxTransaction(owner(), true);
678         excludeFromMaxTransaction(address(this), true);
679         excludeFromMaxTransaction(address(0xdead), true);
680 
681         _mint(msg.sender, totalSupply);
682     }
683 
684     receive() external payable {}
685 
686     function enableTrading() external onlyOwner {
687         tradingActive = true;
688         swapEnabled = true;
689         lastLpBurnTime = block.timestamp;
690     }
691 
692     function removeLimits() external onlyOwner returns (bool) {
693         limitsInEffect = false;
694         return true;
695     }
696 
697     function disableTransferDelay() external onlyOwner returns (bool) {
698         transferDelayEnabled = false;
699         return true;
700     }
701 
702     function updateSwapTokensAtAmount(uint256 newAmount)
703         external
704         onlyOwner
705         returns (bool)
706     {
707         require(
708             newAmount >= (totalSupply() * 1) / 100000,
709             "Swap amount cannot be lower than 0.001% total supply."
710         );
711         require(
712             newAmount <= (totalSupply() * 5) / 1000,
713             "Swap amount cannot be higher than 0.5% total supply."
714         );
715         swapTokensAtAmount = newAmount;
716         return true;
717     }
718 
719     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
720         require(
721             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
722             "Cannot set maxTransactionAmount lower than 0.1%"
723         );
724         maxTransactionAmount = newNum * (10**18);
725     }
726 
727     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
728         require(
729             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
730             "Cannot set maxWallet lower than 0.1%"
731         );
732         maxWallet = newNum * (10**18);
733     }
734 
735     function excludeFromMaxTransaction(address updAds, bool isEx)
736         public
737         onlyOwner
738     {
739         _isExcludedMaxTransactionAmount[updAds] = isEx;
740     }
741 
742     function updateSwapEnabled(bool enabled) external onlyOwner {
743         swapEnabled = enabled;
744     }
745 
746     function updateBuyFees(
747         uint256 _marketingFee,
748         uint256 _liquidityFee,
749         uint256 _developmentFee
750     ) external onlyOwner {
751         buyMarketingFee = _marketingFee;
752         buyLiquidityFee = _liquidityFee;
753         buyDevelopmentFee = _developmentFee;
754         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
755         require(buyTotalFees <= 35, "Must keep fees at 35% or less");
756     }
757 
758     function updateSellFees(
759         uint256 _marketingFee,
760         uint256 _liquidityFee,
761         uint256 _developmentFee
762     ) external onlyOwner {
763         sellMarketingFee = _marketingFee;
764         sellLiquidityFee = _liquidityFee;
765         sellDevelopmentFee = _developmentFee;
766         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
767         require(sellTotalFees <= 35, "Must keep fees at 35% or less");
768     }
769 
770     function excludeFromFees(address account, bool excluded) public onlyOwner {
771         _isExcludedFromFees[account] = excluded;
772         emit ExcludeFromFees(account, excluded);
773     }
774 
775     function setAutomatedMarketMakerPair(address pair, bool value)
776         public
777         onlyOwner
778     {
779         require(
780             pair != uniswapV2Pair,
781             "The pair cannot be removed from automatedMarketMakerPairs"
782         );
783 
784         _setAutomatedMarketMakerPair(pair, value);
785     }
786 
787     function _setAutomatedMarketMakerPair(address pair, bool value) private {
788         automatedMarketMakerPairs[pair] = value;
789 
790         emit SetAutomatedMarketMakerPair(pair, value);
791     }
792 
793     function updateMarketingWalletInfo(address newMarketingWallet)
794         external
795         onlyOwner
796     {
797         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
798         marketingWallet = newMarketingWallet;
799     }
800 
801     function updateDevelopmentWalletInfo(address newWallet) external onlyOwner {
802         emit developmentWalletUpdated(newWallet, developmentWallet);
803         developmentWallet = newWallet;
804     }
805 
806     function isExcludedFromFees(address account) public view returns (bool) {
807         return _isExcludedFromFees[account];
808     }
809 
810     event BoughtEarly(address indexed sniper);
811 
812     function _transfer(
813         address from,
814         address to,
815         uint256 amount
816     ) internal override {
817         require(from != address(0), "ERC20: transfer from the zero address");
818         require(to != address(0), "ERC20: transfer to the zero address");
819 
820         if (amount == 0) {
821             super._transfer(from, to, 0);
822             return;
823         }
824 
825         if (limitsInEffect) {
826             if (
827                 from != owner() &&
828                 to != owner() &&
829                 to != address(0) &&
830                 to != address(0xdead) &&
831                 !swapping
832             ) {
833                 if (!tradingActive) {
834                     require(
835                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
836                         "Trading is not active."
837                     );
838                 }
839 
840                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
841                 if (transferDelayEnabled) {
842                     if (
843                         to != owner() &&
844                         to != address(uniswapV2Router) &&
845                         to != address(uniswapV2Pair)
846                     ) {
847                         require(
848                             _holderLastTransferTimestamp[tx.origin] <
849                                 block.number,
850                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
851                         );
852                         _holderLastTransferTimestamp[tx.origin] = block.number;
853                     }
854                 }
855 
856                 //when buy
857                 if (
858                     automatedMarketMakerPairs[from] &&
859                     !_isExcludedMaxTransactionAmount[to]
860                 ) {
861                     require(
862                         amount <= maxTransactionAmount,
863                         "Buy transfer amount exceeds the maxTransactionAmount."
864                     );
865                     require(
866                         amount + balanceOf(to) <= maxWallet,
867                         "Max wallet exceeded"
868                     );
869                 }
870                 //when sell
871                 else if (
872                     automatedMarketMakerPairs[to] &&
873                     !_isExcludedMaxTransactionAmount[from]
874                 ) {
875                     require(
876                         amount <= maxTransactionAmount,
877                         "Sell transfer amount exceeds the maxTransactionAmount."
878                     );
879                 } else if (!_isExcludedMaxTransactionAmount[to]) {
880                     require(
881                         amount + balanceOf(to) <= maxWallet,
882                         "Max wallet exceeded"
883                     );
884                 }
885             }
886         }
887 
888         uint256 contractTokenBalance = balanceOf(address(this));
889 
890         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
891 
892         if (
893             canSwap &&
894             swapEnabled &&
895             !swapping &&
896             !automatedMarketMakerPairs[from] &&
897             !_isExcludedFromFees[from] &&
898             !_isExcludedFromFees[to]
899         ) {
900             swapping = true;
901 
902             swapBack();
903 
904             swapping = false;
905         }
906 
907         if (
908             !swapping &&
909             automatedMarketMakerPairs[to] &&
910             lpBurnEnabled &&
911             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
912             !_isExcludedFromFees[from]
913         ) {
914             autoBurnLiquidityPairTokens();
915         }
916 
917         bool takeFee = !swapping;
918 
919         // if any account belongs to _isExcludedFromFee account then remove the fee
920         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
921             takeFee = false;
922         }
923 
924         uint256 fees = 0;
925         // only take fees on buys/sells, do not take on wallet transfers
926         if (takeFee) {
927             // on sell
928             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
929                 fees = amount.mul(sellTotalFees).div(100);
930                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
931                 tokensForDev += (fees * sellDevelopmentFee) / sellTotalFees;
932                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
933             }
934             // on buy
935             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
936                 fees = amount.mul(buyTotalFees).div(100);
937                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
938                 tokensForDev += (fees * buyDevelopmentFee) / buyTotalFees;
939                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
940             }
941 
942             if (fees > 0) {
943                 super._transfer(from, address(this), fees);
944             }
945 
946             amount -= fees;
947         }
948 
949         super._transfer(from, to, amount);
950     }
951 
952     function swapTokensForEth(uint256 tokenAmount) private {
953         // generate the uniswap pair path of token -> weth
954         address[] memory path = new address[](2);
955         path[0] = address(this);
956         path[1] = uniswapV2Router.WETH();
957 
958         _approve(address(this), address(uniswapV2Router), tokenAmount);
959 
960         // make the swap
961         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
962             tokenAmount,
963             0, // accept any amount of ETH
964             path,
965             address(this),
966             block.timestamp
967         );
968     }
969 
970     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
971         // approve token transfer to cover all possible scenarios
972         _approve(address(this), address(uniswapV2Router), tokenAmount);
973 
974         // add the liquidity
975         uniswapV2Router.addLiquidityETH{value: ethAmount}(
976             address(this),
977             tokenAmount,
978             0, // slippage is unavoidable
979             0, // slippage is unavoidable
980             deadAddress,
981             block.timestamp
982         );
983     }
984 
985     function swapBack() private {
986         uint256 contractBalance = balanceOf(address(this));
987         uint256 totalTokensToSwap = tokensForLiquidity +
988             tokensForMarketing +
989             tokensForDev;
990         bool success;
991 
992         if (contractBalance == 0 || totalTokensToSwap == 0) {
993             return;
994         }
995 
996         if (contractBalance > swapTokensAtAmount * 20) {
997             contractBalance = swapTokensAtAmount * 20;
998         }
999 
1000         // Halve the amount of liquidity tokens
1001         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1002             totalTokensToSwap /
1003             2;
1004         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1005 
1006         uint256 initialETHBalance = address(this).balance;
1007 
1008         swapTokensForEth(amountToSwapForETH);
1009 
1010         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1011 
1012         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1013             totalTokensToSwap
1014         );
1015         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1016 
1017         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1018 
1019         tokensForLiquidity = 0;
1020         tokensForMarketing = 0;
1021         tokensForDev = 0;
1022 
1023         (success, ) = address(developmentWallet).call{value: ethForDev}("");
1024 
1025         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1026             addLiquidity(liquidityTokens, ethForLiquidity);
1027             emit SwapAndLiquify(
1028                 amountToSwapForETH,
1029                 ethForLiquidity,
1030                 tokensForLiquidity
1031             );
1032         }
1033 
1034         (success, ) = address(marketingWallet).call{
1035             value: address(this).balance
1036         }("");
1037     }
1038 
1039     function setAutoLPBurnSettings(
1040         uint256 _frequencyInSeconds,
1041         uint256 _percent,
1042         bool _Enabled
1043     ) external onlyOwner {
1044         require(
1045             _frequencyInSeconds >= 600,
1046             "cannot set buyback more often than every 10 minutes"
1047         );
1048         require(
1049             _percent <= 1000 && _percent >= 0,
1050             "Must set auto LP burn percent between 0% and 10%"
1051         );
1052         lpBurnFrequency = _frequencyInSeconds;
1053         percentForLPBurn = _percent;
1054         lpBurnEnabled = _Enabled;
1055     }
1056 
1057     function autoBurnLiquidityPairTokens() internal returns (bool) {
1058         lastLpBurnTime = block.timestamp;
1059 
1060         // get balance of liquidity pair
1061         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1062 
1063         // calculate amount to burn
1064         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1065             10000
1066         );
1067 
1068         // pull tokens from pancakePair liquidity and move to dead address permanently
1069         if (amountToBurn > 0) {
1070             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1071         }
1072 
1073         //sync price since this is not in a swap transaction!
1074         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1075         pair.sync();
1076         emit AutoNukeLP();
1077         return true;
1078     }
1079 
1080     function manualBurnLiquidityPairTokens(uint256 percent)
1081         external
1082         onlyOwner
1083         returns (bool)
1084     {
1085         require(
1086             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1087             "Must wait for cooldown to finish"
1088         );
1089         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1090         lastManualLpBurnTime = block.timestamp;
1091 
1092         // get balance of liquidity pair
1093         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1094 
1095         // calculate amount to burn
1096         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1097 
1098         // pull tokens from pancakePair liquidity and move to dead address permanently
1099         if (amountToBurn > 0) {
1100             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1101         }
1102 
1103         //sync price since this is not in a swap transaction!
1104         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1105         pair.sync();
1106         emit ManualNukeLP();
1107         return true;
1108     }
1109 }