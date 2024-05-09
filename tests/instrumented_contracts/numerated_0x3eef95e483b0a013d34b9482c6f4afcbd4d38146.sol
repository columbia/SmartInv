1 /* 
2 
3 Website: https://multiport.io/
4 Telegram: https://t.me/multiport_portal
5 Twitter: https://twitter.com/multiport_io
6 
7 */
8 // SPDX-License-Identifier: MIT
9 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
10 pragma experimental ABIEncoderV2;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes calldata) {
18         return msg.data;
19     }
20 }
21 
22 abstract contract Ownable is Context {
23     address private _owner;
24 
25     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27     constructor() {
28         _transferOwnership(_msgSender());
29     }
30 
31     function owner() public view virtual returns (address) {
32         return _owner;
33     }
34 
35     modifier onlyOwner() {
36         require(owner() == _msgSender(), "Ownable: caller is not the owner");
37         _;
38     }
39 
40 
41     function renounceOwnership() public virtual onlyOwner {
42         _transferOwnership(address(0));
43     }
44 
45     function transferOwnership(address newOwner) public virtual onlyOwner {
46         require(newOwner != address(0), "Ownable: new owner is the zero address");
47         _transferOwnership(newOwner);
48     }
49 
50 
51     function _transferOwnership(address newOwner) internal virtual {
52         address oldOwner = _owner;
53         _owner = newOwner;
54         emit OwnershipTransferred(oldOwner, newOwner);
55     }
56 }
57 
58 interface IERC20 {
59 
60     function totalSupply() external view returns (uint256);
61 
62     function balanceOf(address account) external view returns (uint256);
63 
64 
65     function transfer(address recipient, uint256 amount) external returns (bool);
66 
67 
68     function allowance(address owner, address spender) external view returns (uint256);
69 
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72 
73     function transferFrom(
74         address sender,
75         address recipient,
76         uint256 amount
77     ) external returns (bool);
78 
79 
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 interface IERC20Metadata is IERC20 {
86 
87     function name() external view returns (string memory);
88 
89     function symbol() external view returns (string memory);
90 
91     function decimals() external view returns (uint8);
92 }
93 
94 
95 contract ERC20 is Context, IERC20, IERC20Metadata {
96     mapping(address => uint256) private _balances;
97 
98     mapping(address => mapping(address => uint256)) private _allowances;
99 
100     uint256 private _totalSupply;
101 
102     string private _name;
103     string private _symbol;
104 
105 
106     constructor(string memory name_, string memory symbol_) {
107         _name = name_;
108         _symbol = symbol_;
109     }
110 
111 
112     function name() public view virtual override returns (string memory) {
113         return _name;
114     }
115 
116 
117     function symbol() public view virtual override returns (string memory) {
118         return _symbol;
119     }
120 
121 
122     function decimals() public view virtual override returns (uint8) {
123         return 18;
124     }
125 
126 
127     function totalSupply() public view virtual override returns (uint256) {
128         return _totalSupply;
129     }
130 
131     function balanceOf(address account) public view virtual override returns (uint256) {
132         return _balances[account];
133     }
134 
135     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
136         _transfer(_msgSender(), recipient, amount);
137         return true;
138     }
139 
140 
141     function allowance(address owner, address spender) public view virtual override returns (uint256) {
142         return _allowances[owner][spender];
143     }
144 
145     function approve(address spender, uint256 amount) public virtual override returns (bool) {
146         _approve(_msgSender(), spender, amount);
147         return true;
148     }
149 
150     function transferFrom(
151         address sender,
152         address recipient,
153         uint256 amount
154     ) public virtual override returns (bool) {
155         _transfer(sender, recipient, amount);
156 
157         uint256 currentAllowance = _allowances[sender][_msgSender()];
158         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
159         unchecked {
160             _approve(sender, _msgSender(), currentAllowance - amount);
161         }
162 
163         return true;
164     }
165 
166     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
167         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
168         return true;
169     }
170 
171     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
172         uint256 currentAllowance = _allowances[_msgSender()][spender];
173         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
174         unchecked {
175             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
176         }
177 
178         return true;
179     }
180 
181     function _transfer(
182         address sender,
183         address recipient,
184         uint256 amount
185     ) internal virtual {
186         require(sender != address(0), "ERC20: transfer from the zero address");
187         require(recipient != address(0), "ERC20: transfer to the zero address");
188 
189         _beforeTokenTransfer(sender, recipient, amount);
190 
191         uint256 senderBalance = _balances[sender];
192         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
193         unchecked {
194             _balances[sender] = senderBalance - amount;
195         }
196         _balances[recipient] += amount;
197 
198         emit Transfer(sender, recipient, amount);
199 
200         _afterTokenTransfer(sender, recipient, amount);
201     }
202 
203     function _mint(address account, uint256 amount) internal virtual {
204         require(account != address(0), "ERC20: mint to the zero address");
205 
206         _beforeTokenTransfer(address(0), account, amount);
207 
208         _totalSupply += amount;
209         _balances[account] += amount;
210         emit Transfer(address(0), account, amount);
211 
212         _afterTokenTransfer(address(0), account, amount);
213     }
214 
215     function _burn(address account, uint256 amount) internal virtual {
216         require(account != address(0), "ERC20: burn from the zero address");
217 
218         _beforeTokenTransfer(account, address(0), amount);
219 
220         uint256 accountBalance = _balances[account];
221         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
222         unchecked {
223             _balances[account] = accountBalance - amount;
224         }
225         _totalSupply -= amount;
226 
227         emit Transfer(account, address(0), amount);
228 
229         _afterTokenTransfer(account, address(0), amount);
230     }
231 
232     function _approve(
233         address owner,
234         address spender,
235         uint256 amount
236     ) internal virtual {
237         require(owner != address(0), "ERC20: approve from the zero address");
238         require(spender != address(0), "ERC20: approve to the zero address");
239 
240         _allowances[owner][spender] = amount;
241         emit Approval(owner, spender, amount);
242     }
243 
244     function _beforeTokenTransfer(
245         address from,
246         address to,
247         uint256 amount
248     ) internal virtual {}
249 
250     function _afterTokenTransfer(
251         address from,
252         address to,
253         uint256 amount
254     ) internal virtual {}
255 }
256 
257 
258 library SafeMath {
259 
260     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
261         unchecked {
262             uint256 c = a + b;
263             if (c < a) return (false, 0);
264             return (true, c);
265         }
266     }
267 
268     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
269         unchecked {
270             if (b > a) return (false, 0);
271             return (true, a - b);
272         }
273     }
274 
275 
276     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
277         unchecked {
278             if (a == 0) return (true, 0);
279             uint256 c = a * b;
280             if (c / a != b) return (false, 0);
281             return (true, c);
282         }
283     }
284 
285     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
286         unchecked {
287             if (b == 0) return (false, 0);
288             return (true, a / b);
289         }
290     }
291 
292     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
293         unchecked {
294             if (b == 0) return (false, 0);
295             return (true, a % b);
296         }
297     }
298 
299 
300     function add(uint256 a, uint256 b) internal pure returns (uint256) {
301         return a + b;
302     }
303 
304     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
305         return a - b;
306     }
307 
308     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
309         return a * b;
310     }
311 
312     function div(uint256 a, uint256 b) internal pure returns (uint256) {
313         return a / b;
314     }
315 
316     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
317         return a % b;
318     }
319 
320     function sub(
321         uint256 a,
322         uint256 b,
323         string memory errorMessage
324     ) internal pure returns (uint256) {
325         unchecked {
326             require(b <= a, errorMessage);
327             return a - b;
328         }
329     }
330 
331     function div(
332         uint256 a,
333         uint256 b,
334         string memory errorMessage
335     ) internal pure returns (uint256) {
336         unchecked {
337             require(b > 0, errorMessage);
338             return a / b;
339         }
340     }
341 
342 
343     function mod(
344         uint256 a,
345         uint256 b,
346         string memory errorMessage
347     ) internal pure returns (uint256) {
348         unchecked {
349             require(b > 0, errorMessage);
350             return a % b;
351         }
352     }
353 }
354 
355 
356 interface IUniswapV2Factory {
357     event PairCreated(
358         address indexed token0,
359         address indexed token1,
360         address pair,
361         uint256
362     );
363 
364     function feeTo() external view returns (address);
365 
366     function feeToSetter() external view returns (address);
367 
368     function getPair(address tokenA, address tokenB)
369         external
370         view
371         returns (address pair);
372 
373     function allPairs(uint256) external view returns (address pair);
374 
375     function allPairsLength() external view returns (uint256);
376 
377     function createPair(address tokenA, address tokenB)
378         external
379         returns (address pair);
380 
381     function setFeeTo(address) external;
382 
383     function setFeeToSetter(address) external;
384 }
385 
386 
387 interface IUniswapV2Pair {
388     event Approval(
389         address indexed owner,
390         address indexed spender,
391         uint256 value
392     );
393     event Transfer(address indexed from, address indexed to, uint256 value);
394 
395     function name() external pure returns (string memory);
396 
397     function symbol() external pure returns (string memory);
398 
399     function decimals() external pure returns (uint8);
400 
401     function totalSupply() external view returns (uint256);
402 
403     function balanceOf(address owner) external view returns (uint256);
404 
405     function allowance(address owner, address spender)
406         external
407         view
408         returns (uint256);
409 
410     function approve(address spender, uint256 value) external returns (bool);
411 
412     function transfer(address to, uint256 value) external returns (bool);
413 
414     function transferFrom(
415         address from,
416         address to,
417         uint256 value
418     ) external returns (bool);
419 
420     function DOMAIN_SEPARATOR() external view returns (bytes32);
421 
422     function PERMIT_TYPEHASH() external pure returns (bytes32);
423 
424     function nonces(address owner) external view returns (uint256);
425 
426     function permit(
427         address owner,
428         address spender,
429         uint256 value,
430         uint256 deadline,
431         uint8 v,
432         bytes32 r,
433         bytes32 s
434     ) external;
435 
436     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
437     event Burn(
438         address indexed sender,
439         uint256 amount0,
440         uint256 amount1,
441         address indexed to
442     );
443     event Swap(
444         address indexed sender,
445         uint256 amount0In,
446         uint256 amount1In,
447         uint256 amount0Out,
448         uint256 amount1Out,
449         address indexed to
450     );
451     event Sync(uint112 reserve0, uint112 reserve1);
452 
453     function MINIMUM_LIQUIDITY() external pure returns (uint256);
454 
455     function factory() external view returns (address);
456 
457     function token0() external view returns (address);
458 
459     function token1() external view returns (address);
460 
461     function getReserves()
462         external
463         view
464         returns (
465             uint112 reserve0,
466             uint112 reserve1,
467             uint32 blockTimestampLast
468         );
469 
470     function price0CumulativeLast() external view returns (uint256);
471 
472     function price1CumulativeLast() external view returns (uint256);
473 
474     function kLast() external view returns (uint256);
475 
476     function mint(address to) external returns (uint256 liquidity);
477 
478     function burn(address to)
479         external
480         returns (uint256 amount0, uint256 amount1);
481 
482     function swap(
483         uint256 amount0Out,
484         uint256 amount1Out,
485         address to,
486         bytes calldata data
487     ) external;
488 
489     function skim(address to) external;
490 
491     function sync() external;
492 
493     function initialize(address, address) external;
494 }
495 
496 
497 interface IUniswapV2Router02 {
498     function factory() external pure returns (address);
499 
500     function WETH() external pure returns (address);
501 
502     function addLiquidity(
503         address tokenA,
504         address tokenB,
505         uint256 amountADesired,
506         uint256 amountBDesired,
507         uint256 amountAMin,
508         uint256 amountBMin,
509         address to,
510         uint256 deadline
511     )
512         external
513         returns (
514             uint256 amountA,
515             uint256 amountB,
516             uint256 liquidity
517         );
518 
519     function addLiquidityETH(
520         address token,
521         uint256 amountTokenDesired,
522         uint256 amountTokenMin,
523         uint256 amountETHMin,
524         address to,
525         uint256 deadline
526     )
527         external
528         payable
529         returns (
530             uint256 amountToken,
531             uint256 amountETH,
532             uint256 liquidity
533         );
534 
535     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
536         uint256 amountIn,
537         uint256 amountOutMin,
538         address[] calldata path,
539         address to,
540         uint256 deadline
541     ) external;
542 
543     function swapExactETHForTokensSupportingFeeOnTransferTokens(
544         uint256 amountOutMin,
545         address[] calldata path,
546         address to,
547         uint256 deadline
548     ) external payable;
549 
550     function swapExactTokensForETHSupportingFeeOnTransferTokens(
551         uint256 amountIn,
552         uint256 amountOutMin,
553         address[] calldata path,
554         address to,
555         uint256 deadline
556     ) external;
557 }
558 
559 
560 contract MultiPort is ERC20, Ownable {
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
572     uint256 public maxTransactionAmount;
573     uint256 public swapTokensAtAmount;
574     uint256 public maxWallet;
575 
576     uint256 public percentForLPBurn = 0; 
577     bool public lpBurnEnabled = false;
578     uint256 public lpBurnFrequency = 3600 seconds;
579     uint256 public lastLpBurnTime;
580 
581     uint256 public manualBurnFrequency = 30 minutes;
582     uint256 public lastManualLpBurnTime;
583 
584     bool public limitsInEffect = true;
585     bool public tradingActive = false;
586     bool public swapEnabled = true;
587 
588     mapping(address => uint256) private _holderLastTransferTimestamp; 
589     bool public transferDelayEnabled = true;
590 
591     uint256 public buyTotalFees;
592     uint256 public buyMarketingFee;
593     uint256 public buyLiquidityFee;
594     uint256 public buyDevelopmentFee;
595 
596     uint256 public sellTotalFees;
597     uint256 public sellMarketingFee;
598     uint256 public sellLiquidityFee;
599     uint256 public sellDevelopmentFee;
600 
601     uint256 public tokensForMarketing;
602     uint256 public tokensForLiquidity;
603     uint256 public tokensForDev;
604 
605     mapping(address => bool) private _isExcludedFromFees;
606     mapping(address => bool) public _isExcludedMaxTransactionAmount;
607 
608     mapping(address => bool) public automatedMarketMakerPairs;
609 
610     event UpdateUniswapV2Router(
611         address indexed newAddress,
612         address indexed oldAddress
613     );
614 
615     event ExcludeFromFees(address indexed account, bool isExcluded);
616 
617     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
618 
619     event marketingWalletUpdated(
620         address indexed newWallet,
621         address indexed oldWallet
622     );
623 
624     event developmentWalletUpdated(
625         address indexed newWallet,
626         address indexed oldWallet
627     );
628 
629     event SwapAndLiquify(
630         uint256 tokensSwapped,
631         uint256 ethReceived,
632         uint256 tokensIntoLiquidity
633     );
634 
635     event AutoNukeLP();
636 
637     event ManualNukeLP();
638 
639     constructor() ERC20("Multiport", "PORT") {
640         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
641             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
642         );
643 
644         excludeFromMaxTransaction(address(_uniswapV2Router), true);
645         uniswapV2Router = _uniswapV2Router;
646 
647         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
648             .createPair(address(this), _uniswapV2Router.WETH());
649         excludeFromMaxTransaction(address(uniswapV2Pair), true);
650         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
651 
652         uint256 _buyMarketingFee = 20;
653         uint256 _buyLiquidityFee = 0;
654         uint256 _buyDevelopmentFee = 5;
655 
656         uint256 _sellMarketingFee = 20;
657         uint256 _sellLiquidityFee = 0;
658         uint256 _sellDevelopmentFee = 5;
659 
660         uint256 totalSupply = 1_000_000 * 1e18;
661 
662         maxTransactionAmount = 15_000 * 1e18; 
663         maxWallet = 20_000 * 1e18; 
664         swapTokensAtAmount = (totalSupply * 10) / 10000;
665 
666         buyMarketingFee = _buyMarketingFee;
667         buyLiquidityFee = _buyLiquidityFee;
668         buyDevelopmentFee = _buyDevelopmentFee;
669         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
670 
671         sellMarketingFee = _sellMarketingFee;
672         sellLiquidityFee = _sellLiquidityFee;
673         sellDevelopmentFee = _sellDevelopmentFee;
674         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
675 
676         marketingWallet = address(0x27AA4EF86aFA76ce37fb2Eef1b9CBf1eBA4d7F2d); 
677         developmentWallet = address(0x935c91582b94C1A6739625DE6640599667678424); 
678 
679         excludeFromFees(owner(), true);
680         excludeFromFees(address(this), true);
681         excludeFromFees(address(0xdead), true);
682 
683         excludeFromMaxTransaction(owner(), true);
684         excludeFromMaxTransaction(address(this), true);
685         excludeFromMaxTransaction(address(0xdead), true);
686 
687         _mint(msg.sender, totalSupply);
688     }
689 
690     receive() external payable {}
691 
692     function enableTrading() external onlyOwner {
693         tradingActive = true;
694         swapEnabled = true;
695         lastLpBurnTime = block.timestamp;
696     }
697 
698     function removeLimits() external onlyOwner returns (bool) {
699         limitsInEffect = false;
700         return true;
701     }
702 
703     function disableTransferDelay() external onlyOwner returns (bool) {
704         transferDelayEnabled = false;
705         return true;
706     }
707 
708     function updateSwapTokensAtAmount(uint256 newAmount)
709         external
710         onlyOwner
711         returns (bool)
712     {
713         require(
714             newAmount >= (totalSupply() * 1) / 100000,
715             "Swap amount cannot be lower than 0.001% total supply."
716         );
717         require(
718             newAmount <= (totalSupply() * 5) / 1000,
719             "Swap amount cannot be higher than 0.5% total supply."
720         );
721         swapTokensAtAmount = newAmount;
722         return true;
723     }
724 
725     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
726         require(
727             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
728             "Cannot set maxTransactionAmount lower than 0.1%"
729         );
730         maxTransactionAmount = newNum * (10**18);
731     }
732 
733     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
734         require(
735             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
736             "Cannot set maxWallet lower than 0.5%"
737         );
738         maxWallet = newNum * (10**18);
739     }
740 
741     function excludeFromMaxTransaction(address updAds, bool isEx)
742         public
743         onlyOwner
744     {
745         _isExcludedMaxTransactionAmount[updAds] = isEx;
746     }
747 
748     function updateSwapEnabled(bool enabled) external onlyOwner {
749         swapEnabled = enabled;
750     }
751 
752     function updateBuyFees(
753         uint256 _marketingFee,
754         uint256 _liquidityFee,
755         uint256 _developmentFee
756     ) external onlyOwner {
757         buyMarketingFee = _marketingFee;
758         buyLiquidityFee = _liquidityFee;
759         buyDevelopmentFee = _developmentFee;
760         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
761         require(buyTotalFees <= 35, "Must keep fees at 35% or less");
762     }
763 
764     function updateSellFees(
765         uint256 _marketingFee,
766         uint256 _liquidityFee,
767         uint256 _developmentFee
768     ) external onlyOwner {
769         sellMarketingFee = _marketingFee;
770         sellLiquidityFee = _liquidityFee;
771         sellDevelopmentFee = _developmentFee;
772         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
773         require(sellTotalFees <= 99, "Must keep fees at 99% or less");
774     }
775 
776     function excludeFromFees(address account, bool excluded) public onlyOwner {
777         _isExcludedFromFees[account] = excluded;
778         emit ExcludeFromFees(account, excluded);
779     }
780 
781     function setAutomatedMarketMakerPair(address pair, bool value)
782         public
783         onlyOwner
784     {
785         require(
786             pair != uniswapV2Pair,
787             "The pair cannot be removed from automatedMarketMakerPairs"
788         );
789 
790         _setAutomatedMarketMakerPair(pair, value);
791     }
792 
793     function _setAutomatedMarketMakerPair(address pair, bool value) private {
794         automatedMarketMakerPairs[pair] = value;
795 
796         emit SetAutomatedMarketMakerPair(pair, value);
797     }
798 
799     function updateMarketingWalletInfo(address newMarketingWallet)
800         external
801         onlyOwner
802     {
803         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
804         marketingWallet = newMarketingWallet;
805     }
806 
807     function updateDevelopmentWalletInfo(address newWallet) external onlyOwner {
808         emit developmentWalletUpdated(newWallet, developmentWallet);
809         developmentWallet = newWallet;
810     }
811 
812     function isExcludedFromFees(address account) public view returns (bool) {
813         return _isExcludedFromFees[account];
814     }
815 
816     event BoughtEarly(address indexed sniper);
817 
818     function _transfer(
819         address from,
820         address to,
821         uint256 amount
822     ) internal override {
823         require(from != address(0), "ERC20: transfer from the zero address");
824         require(to != address(0), "ERC20: transfer to the zero address");
825 
826         if (amount == 0) {
827             super._transfer(from, to, 0);
828             return;
829         }
830 
831         if (limitsInEffect) {
832             if (
833                 from != owner() &&
834                 to != owner() &&
835                 to != address(0) &&
836                 to != address(0xdead) &&
837                 !swapping
838             ) {
839                 if (!tradingActive) {
840                     require(
841                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
842                         "Trading is not active."
843                     );
844                 }
845 
846                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
847                 if (transferDelayEnabled) {
848                     if (
849                         to != owner() &&
850                         to != address(uniswapV2Router) &&
851                         to != address(uniswapV2Pair)
852                     ) {
853                         require(
854                             _holderLastTransferTimestamp[tx.origin] <
855                                 block.number,
856                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
857                         );
858                         _holderLastTransferTimestamp[tx.origin] = block.number;
859                     }
860                 }
861 
862                 //when buy
863                 if (
864                     automatedMarketMakerPairs[from] &&
865                     !_isExcludedMaxTransactionAmount[to]
866                 ) {
867                     require(
868                         amount <= maxTransactionAmount,
869                         "Buy transfer amount exceeds the maxTransactionAmount."
870                     );
871                     require(
872                         amount + balanceOf(to) <= maxWallet,
873                         "Max wallet exceeded"
874                     );
875                 }
876                 //when sell
877                 else if (
878                     automatedMarketMakerPairs[to] &&
879                     !_isExcludedMaxTransactionAmount[from]
880                 ) {
881                     require(
882                         amount <= maxTransactionAmount,
883                         "Sell transfer amount exceeds the maxTransactionAmount."
884                     );
885                 } else if (!_isExcludedMaxTransactionAmount[to]) {
886                     require(
887                         amount + balanceOf(to) <= maxWallet,
888                         "Max wallet exceeded"
889                     );
890                 }
891             }
892         }
893 
894         uint256 contractTokenBalance = balanceOf(address(this));
895 
896         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
897 
898         if (
899             canSwap &&
900             swapEnabled &&
901             !swapping &&
902             !automatedMarketMakerPairs[from] &&
903             !_isExcludedFromFees[from] &&
904             !_isExcludedFromFees[to]
905         ) {
906             swapping = true;
907 
908             swapBack();
909 
910             swapping = false;
911         }
912 
913         if (
914             !swapping &&
915             automatedMarketMakerPairs[to] &&
916             lpBurnEnabled &&
917             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
918             !_isExcludedFromFees[from]
919         ) {
920             autoBurnLiquidityPairTokens();
921         }
922 
923         bool takeFee = !swapping;
924 
925         // if any account belongs to _isExcludedFromFee account then remove the fee
926         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
927             takeFee = false;
928         }
929 
930         uint256 fees = 0;
931         // only take fees on buys/sells, do not take on wallet transfers
932         if (takeFee) {
933             // on sell
934             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
935                 fees = amount.mul(sellTotalFees).div(100);
936                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
937                 tokensForDev += (fees * sellDevelopmentFee) / sellTotalFees;
938                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
939             }
940             // on buy
941             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
942                 fees = amount.mul(buyTotalFees).div(100);
943                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
944                 tokensForDev += (fees * buyDevelopmentFee) / buyTotalFees;
945                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
946             }
947 
948             if (fees > 0) {
949                 super._transfer(from, address(this), fees);
950             }
951 
952             amount -= fees;
953         }
954 
955         super._transfer(from, to, amount);
956     }
957 
958     function swapTokensForEth(uint256 tokenAmount) private {
959         // generate the uniswap pair path of token -> weth
960         address[] memory path = new address[](2);
961         path[0] = address(this);
962         path[1] = uniswapV2Router.WETH();
963 
964         _approve(address(this), address(uniswapV2Router), tokenAmount);
965 
966         // make the swap
967         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
968             tokenAmount,
969             0, // accept any amount of ETH
970             path,
971             address(this),
972             block.timestamp
973         );
974     }
975 
976     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
977         // approve token transfer to cover all possible scenarios
978         _approve(address(this), address(uniswapV2Router), tokenAmount);
979 
980         // add the liquidity
981         uniswapV2Router.addLiquidityETH{value: ethAmount}(
982             address(this),
983             tokenAmount,
984             0, // slippage is unavoidable
985             0, // slippage is unavoidable
986             deadAddress,
987             block.timestamp
988         );
989     }
990 
991     function swapBack() private {
992         uint256 contractBalance = balanceOf(address(this));
993         uint256 totalTokensToSwap = tokensForLiquidity +
994             tokensForMarketing +
995             tokensForDev;
996         bool success;
997 
998         if (contractBalance == 0 || totalTokensToSwap == 0) {
999             return;
1000         }
1001 
1002         if (contractBalance > swapTokensAtAmount * 20) {
1003             contractBalance = swapTokensAtAmount * 20;
1004         }
1005 
1006         // Halve the amount of liquidity tokens
1007         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1008             totalTokensToSwap /
1009             2;
1010         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1011 
1012         uint256 initialETHBalance = address(this).balance;
1013 
1014         swapTokensForEth(amountToSwapForETH);
1015 
1016         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1017 
1018         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1019             totalTokensToSwap
1020         );
1021         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1022 
1023         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1024 
1025         tokensForLiquidity = 0;
1026         tokensForMarketing = 0;
1027         tokensForDev = 0;
1028 
1029         (success, ) = address(developmentWallet).call{value: ethForDev}("");
1030 
1031         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1032             addLiquidity(liquidityTokens, ethForLiquidity);
1033             emit SwapAndLiquify(
1034                 amountToSwapForETH,
1035                 ethForLiquidity,
1036                 tokensForLiquidity
1037             );
1038         }
1039 
1040         (success, ) = address(marketingWallet).call{
1041             value: address(this).balance
1042         }("");
1043     }
1044 
1045     function setAutoLPBurnSettings(
1046         uint256 _frequencyInSeconds,
1047         uint256 _percent,
1048         bool _Enabled
1049     ) external onlyOwner {
1050         require(
1051             _frequencyInSeconds >= 600,
1052             "cannot set buyback more often than every 10 minutes"
1053         );
1054         require(
1055             _percent <= 1000 && _percent >= 0,
1056             "Must set auto LP burn percent between 0% and 10%"
1057         );
1058         lpBurnFrequency = _frequencyInSeconds;
1059         percentForLPBurn = _percent;
1060         lpBurnEnabled = _Enabled;
1061     }
1062 
1063     function autoBurnLiquidityPairTokens() internal returns (bool) {
1064         lastLpBurnTime = block.timestamp;
1065 
1066         // get balance of liquidity pair
1067         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1068 
1069         // calculate amount to burn
1070         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1071             10000
1072         );
1073 
1074         // pull tokens from pancakePair liquidity and move to dead address permanently
1075         if (amountToBurn > 0) {
1076             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1077         }
1078 
1079         //sync price since this is not in a swap transaction!
1080         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1081         pair.sync();
1082         emit AutoNukeLP();
1083         return true;
1084     }
1085 
1086     function manualBurnLiquidityPairTokens(uint256 percent)
1087         external
1088         onlyOwner
1089         returns (bool)
1090     {
1091         require(
1092             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1093             "Must wait for cooldown to finish"
1094         );
1095         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1096         lastManualLpBurnTime = block.timestamp;
1097 
1098         // get balance of liquidity pair
1099         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1100 
1101         // calculate amount to burn
1102         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1103 
1104         // pull tokens from pancakePair liquidity and move to dead address permanently
1105         if (amountToBurn > 0) {
1106             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1107         }
1108 
1109         //sync price since this is not in a swap transaction!
1110         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1111         pair.sync();
1112         emit ManualNukeLP();
1113         return true;
1114     }
1115 }