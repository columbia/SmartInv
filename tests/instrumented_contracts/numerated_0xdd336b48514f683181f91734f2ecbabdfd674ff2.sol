1 // ░░██╗██╗██████╗░
2 // ░██╔╝██║╚════██╗
3 // ██╔╝░██║░░███╔═╝
4 // ███████║██╔══╝░░
5 // ╚════██║███████╗
6 // ░░░░░╚═╝╚══════╝
7 
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
11 pragma experimental ABIEncoderV2;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         return msg.data;
20     }
21 }
22 
23 abstract contract Ownable is Context {
24     address private _owner;
25 
26     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28     constructor() {
29         _transferOwnership(_msgSender());
30     }
31 
32     function owner() public view virtual returns (address) {
33         return _owner;
34     }
35 
36     modifier onlyOwner() {
37         require(owner() == _msgSender(), "Ownable: caller is not the owner");
38         _;
39     }
40 
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
51 
52     function _transferOwnership(address newOwner) internal virtual {
53         address oldOwner = _owner;
54         _owner = newOwner;
55         emit OwnershipTransferred(oldOwner, newOwner);
56     }
57 }
58 
59 interface IERC20 {
60 
61     function totalSupply() external view returns (uint256);
62 
63     function balanceOf(address account) external view returns (uint256);
64 
65 
66     function transfer(address recipient, uint256 amount) external returns (bool);
67 
68 
69     function allowance(address owner, address spender) external view returns (uint256);
70 
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73 
74     function transferFrom(
75         address sender,
76         address recipient,
77         uint256 amount
78     ) external returns (bool);
79 
80 
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 interface IERC20Metadata is IERC20 {
87 
88     function name() external view returns (string memory);
89 
90     function symbol() external view returns (string memory);
91 
92     function decimals() external view returns (uint8);
93 }
94 
95 
96 contract ERC20 is Context, IERC20, IERC20Metadata {
97     mapping(address => uint256) private _balances;
98 
99     mapping(address => mapping(address => uint256)) private _allowances;
100 
101     uint256 private _totalSupply;
102 
103     string private _name;
104     string private _symbol;
105 
106 
107     constructor(string memory name_, string memory symbol_) {
108         _name = name_;
109         _symbol = symbol_;
110     }
111 
112 
113     function name() public view virtual override returns (string memory) {
114         return _name;
115     }
116 
117 
118     function symbol() public view virtual override returns (string memory) {
119         return _symbol;
120     }
121 
122 
123     function decimals() public view virtual override returns (uint8) {
124         return 18;
125     }
126 
127 
128     function totalSupply() public view virtual override returns (uint256) {
129         return _totalSupply;
130     }
131 
132     function balanceOf(address account) public view virtual override returns (uint256) {
133         return _balances[account];
134     }
135 
136     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
137         _transfer(_msgSender(), recipient, amount);
138         return true;
139     }
140 
141 
142     function allowance(address owner, address spender) public view virtual override returns (uint256) {
143         return _allowances[owner][spender];
144     }
145 
146     function approve(address spender, uint256 amount) public virtual override returns (bool) {
147         _approve(_msgSender(), spender, amount);
148         return true;
149     }
150 
151     function transferFrom(
152         address sender,
153         address recipient,
154         uint256 amount
155     ) public virtual override returns (bool) {
156         _transfer(sender, recipient, amount);
157 
158         uint256 currentAllowance = _allowances[sender][_msgSender()];
159         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
160         unchecked {
161             _approve(sender, _msgSender(), currentAllowance - amount);
162         }
163 
164         return true;
165     }
166 
167     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
168         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
169         return true;
170     }
171 
172     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
173         uint256 currentAllowance = _allowances[_msgSender()][spender];
174         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
175         unchecked {
176             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
177         }
178 
179         return true;
180     }
181 
182     function _transfer(
183         address sender,
184         address recipient,
185         uint256 amount
186     ) internal virtual {
187         require(sender != address(0), "ERC20: transfer from the zero address");
188         require(recipient != address(0), "ERC20: transfer to the zero address");
189 
190         _beforeTokenTransfer(sender, recipient, amount);
191 
192         uint256 senderBalance = _balances[sender];
193         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
194         unchecked {
195             _balances[sender] = senderBalance - amount;
196         }
197         _balances[recipient] += amount;
198 
199         emit Transfer(sender, recipient, amount);
200 
201         _afterTokenTransfer(sender, recipient, amount);
202     }
203 
204     function _mint(address account, uint256 amount) internal virtual {
205         require(account != address(0), "ERC20: mint to the zero address");
206 
207         _beforeTokenTransfer(address(0), account, amount);
208 
209         _totalSupply += amount;
210         _balances[account] += amount;
211         emit Transfer(address(0), account, amount);
212 
213         _afterTokenTransfer(address(0), account, amount);
214     }
215 
216     function _burn(address account, uint256 amount) internal virtual {
217         require(account != address(0), "ERC20: burn from the zero address");
218 
219         _beforeTokenTransfer(account, address(0), amount);
220 
221         uint256 accountBalance = _balances[account];
222         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
223         unchecked {
224             _balances[account] = accountBalance - amount;
225         }
226         _totalSupply -= amount;
227 
228         emit Transfer(account, address(0), amount);
229 
230         _afterTokenTransfer(account, address(0), amount);
231     }
232 
233     function _approve(
234         address owner,
235         address spender,
236         uint256 amount
237     ) internal virtual {
238         require(owner != address(0), "ERC20: approve from the zero address");
239         require(spender != address(0), "ERC20: approve to the zero address");
240 
241         _allowances[owner][spender] = amount;
242         emit Approval(owner, spender, amount);
243     }
244 
245     function _beforeTokenTransfer(
246         address from,
247         address to,
248         uint256 amount
249     ) internal virtual {}
250 
251     function _afterTokenTransfer(
252         address from,
253         address to,
254         uint256 amount
255     ) internal virtual {}
256 }
257 
258 
259 library SafeMath {
260 
261     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
262         unchecked {
263             uint256 c = a + b;
264             if (c < a) return (false, 0);
265             return (true, c);
266         }
267     }
268 
269     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
270         unchecked {
271             if (b > a) return (false, 0);
272             return (true, a - b);
273         }
274     }
275 
276 
277     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
278         unchecked {
279             if (a == 0) return (true, 0);
280             uint256 c = a * b;
281             if (c / a != b) return (false, 0);
282             return (true, c);
283         }
284     }
285 
286     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
287         unchecked {
288             if (b == 0) return (false, 0);
289             return (true, a / b);
290         }
291     }
292 
293     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
294         unchecked {
295             if (b == 0) return (false, 0);
296             return (true, a % b);
297         }
298     }
299 
300 
301     function add(uint256 a, uint256 b) internal pure returns (uint256) {
302         return a + b;
303     }
304 
305     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
306         return a - b;
307     }
308 
309     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
310         return a * b;
311     }
312 
313     function div(uint256 a, uint256 b) internal pure returns (uint256) {
314         return a / b;
315     }
316 
317     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
318         return a % b;
319     }
320 
321     function sub(
322         uint256 a,
323         uint256 b,
324         string memory errorMessage
325     ) internal pure returns (uint256) {
326         unchecked {
327             require(b <= a, errorMessage);
328             return a - b;
329         }
330     }
331 
332     function div(
333         uint256 a,
334         uint256 b,
335         string memory errorMessage
336     ) internal pure returns (uint256) {
337         unchecked {
338             require(b > 0, errorMessage);
339             return a / b;
340         }
341     }
342 
343 
344     function mod(
345         uint256 a,
346         uint256 b,
347         string memory errorMessage
348     ) internal pure returns (uint256) {
349         unchecked {
350             require(b > 0, errorMessage);
351             return a % b;
352         }
353     }
354 }
355 
356 
357 interface IUniswapV2Factory {
358     event PairCreated(
359         address indexed token0,
360         address indexed token1,
361         address pair,
362         uint256
363     );
364 
365     function feeTo() external view returns (address);
366 
367     function feeToSetter() external view returns (address);
368 
369     function getPair(address tokenA, address tokenB)
370         external
371         view
372         returns (address pair);
373 
374     function allPairs(uint256) external view returns (address pair);
375 
376     function allPairsLength() external view returns (uint256);
377 
378     function createPair(address tokenA, address tokenB)
379         external
380         returns (address pair);
381 
382     function setFeeTo(address) external;
383 
384     function setFeeToSetter(address) external;
385 }
386 
387 
388 interface IUniswapV2Pair {
389     event Approval(
390         address indexed owner,
391         address indexed spender,
392         uint256 value
393     );
394     event Transfer(address indexed from, address indexed to, uint256 value);
395 
396     function name() external pure returns (string memory);
397 
398     function symbol() external pure returns (string memory);
399 
400     function decimals() external pure returns (uint8);
401 
402     function totalSupply() external view returns (uint256);
403 
404     function balanceOf(address owner) external view returns (uint256);
405 
406     function allowance(address owner, address spender)
407         external
408         view
409         returns (uint256);
410 
411     function approve(address spender, uint256 value) external returns (bool);
412 
413     function transfer(address to, uint256 value) external returns (bool);
414 
415     function transferFrom(
416         address from,
417         address to,
418         uint256 value
419     ) external returns (bool);
420 
421     function DOMAIN_SEPARATOR() external view returns (bytes32);
422 
423     function PERMIT_TYPEHASH() external pure returns (bytes32);
424 
425     function nonces(address owner) external view returns (uint256);
426 
427     function permit(
428         address owner,
429         address spender,
430         uint256 value,
431         uint256 deadline,
432         uint8 v,
433         bytes32 r,
434         bytes32 s
435     ) external;
436 
437     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
438     event Burn(
439         address indexed sender,
440         uint256 amount0,
441         uint256 amount1,
442         address indexed to
443     );
444     event Swap(
445         address indexed sender,
446         uint256 amount0In,
447         uint256 amount1In,
448         uint256 amount0Out,
449         uint256 amount1Out,
450         address indexed to
451     );
452     event Sync(uint112 reserve0, uint112 reserve1);
453 
454     function MINIMUM_LIQUIDITY() external pure returns (uint256);
455 
456     function factory() external view returns (address);
457 
458     function token0() external view returns (address);
459 
460     function token1() external view returns (address);
461 
462     function getReserves()
463         external
464         view
465         returns (
466             uint112 reserve0,
467             uint112 reserve1,
468             uint32 blockTimestampLast
469         );
470 
471     function price0CumulativeLast() external view returns (uint256);
472 
473     function price1CumulativeLast() external view returns (uint256);
474 
475     function kLast() external view returns (uint256);
476 
477     function mint(address to) external returns (uint256 liquidity);
478 
479     function burn(address to)
480         external
481         returns (uint256 amount0, uint256 amount1);
482 
483     function swap(
484         uint256 amount0Out,
485         uint256 amount1Out,
486         address to,
487         bytes calldata data
488     ) external;
489 
490     function skim(address to) external;
491 
492     function sync() external;
493 
494     function initialize(address, address) external;
495 }
496 
497 
498 interface IUniswapV2Router02 {
499     function factory() external pure returns (address);
500 
501     function WETH() external pure returns (address);
502 
503     function addLiquidity(
504         address tokenA,
505         address tokenB,
506         uint256 amountADesired,
507         uint256 amountBDesired,
508         uint256 amountAMin,
509         uint256 amountBMin,
510         address to,
511         uint256 deadline
512     )
513         external
514         returns (
515             uint256 amountA,
516             uint256 amountB,
517             uint256 liquidity
518         );
519 
520     function addLiquidityETH(
521         address token,
522         uint256 amountTokenDesired,
523         uint256 amountTokenMin,
524         uint256 amountETHMin,
525         address to,
526         uint256 deadline
527     )
528         external
529         payable
530         returns (
531             uint256 amountToken,
532             uint256 amountETH,
533             uint256 liquidity
534         );
535 
536     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
537         uint256 amountIn,
538         uint256 amountOutMin,
539         address[] calldata path,
540         address to,
541         uint256 deadline
542     ) external;
543 
544     function swapExactETHForTokensSupportingFeeOnTransferTokens(
545         uint256 amountOutMin,
546         address[] calldata path,
547         address to,
548         uint256 deadline
549     ) external payable;
550 
551     function swapExactTokensForETHSupportingFeeOnTransferTokens(
552         uint256 amountIn,
553         uint256 amountOutMin,
554         address[] calldata path,
555         address to,
556         uint256 deadline
557     ) external;
558 }
559 
560 
561 contract Four is ERC20, Ownable {
562     using SafeMath for uint256;
563 
564     IUniswapV2Router02 public immutable uniswapV2Router;
565     address public immutable uniswapV2Pair;
566     address public constant deadAddress = address(0xdead);
567 
568     bool private swapping;
569 
570     address private marketingWallet;
571     address private developmentWallet;
572 
573     uint256 public maxTransactionAmount;
574     uint256 public swapTokensAtAmount;
575     uint256 public maxWallet;
576 
577     uint256 public percentForLPBurn = 0; 
578     bool public lpBurnEnabled = false;
579     uint256 public lpBurnFrequency = 3600 seconds;
580     uint256 public lastLpBurnTime;
581 
582     uint256 public manualBurnFrequency = 30 minutes;
583     uint256 public lastManualLpBurnTime;
584 
585     bool public limitsInEffect = true;
586     bool public tradingActive = false;
587     bool public swapEnabled = true;
588 
589     mapping(address => uint256) private _holderLastTransferTimestamp; 
590     bool public transferDelayEnabled = true;
591 
592     uint256 public buyTotalFees;
593     uint256 public buyMarketingFee;
594     uint256 public buyLiquidityFee;
595     uint256 public buyDevelopmentFee;
596 
597     uint256 public sellTotalFees;
598     uint256 public sellMarketingFee;
599     uint256 public sellLiquidityFee;
600     uint256 public sellDevelopmentFee;
601 
602     uint256 public tokensForMarketing;
603     uint256 public tokensForLiquidity;
604     uint256 public tokensForDev;
605 
606     mapping(address => bool) private _isExcludedFromFees;
607     mapping(address => bool) public _isExcludedMaxTransactionAmount;
608 
609     mapping(address => bool) public automatedMarketMakerPairs;
610 
611     event UpdateUniswapV2Router(
612         address indexed newAddress,
613         address indexed oldAddress
614     );
615 
616     event ExcludeFromFees(address indexed account, bool isExcluded);
617 
618     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
619 
620     event marketingWalletUpdated(
621         address indexed newWallet,
622         address indexed oldWallet
623     );
624 
625     event developmentWalletUpdated(
626         address indexed newWallet,
627         address indexed oldWallet
628     );
629 
630     event SwapAndLiquify(
631         uint256 tokensSwapped,
632         uint256 ethReceived,
633         uint256 tokensIntoLiquidity
634     );
635 
636     event AutoNukeLP();
637 
638     event ManualNukeLP();
639 
640     constructor() ERC20("42", "42") {
641         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
642             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
643         );
644 
645         excludeFromMaxTransaction(address(_uniswapV2Router), true);
646         uniswapV2Router = _uniswapV2Router;
647 
648         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
649             .createPair(address(this), _uniswapV2Router.WETH());
650         excludeFromMaxTransaction(address(uniswapV2Pair), true);
651         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
652 
653         uint256 _buyMarketingFee = 4;
654         uint256 _buyLiquidityFee = 0;
655         uint256 _buyDevelopmentFee = 0;
656 
657         uint256 _sellMarketingFee = 4;
658         uint256 _sellLiquidityFee = 0;
659         uint256 _sellDevelopmentFee = 0;
660 
661         uint256 totalSupply = 42 * 1e18;
662 
663         maxTransactionAmount = 42 * 1e18; 
664         maxWallet = 42 * 1e18; 
665         swapTokensAtAmount = (totalSupply * 10) / 10000;
666 
667         buyMarketingFee = _buyMarketingFee;
668         buyLiquidityFee = _buyLiquidityFee;
669         buyDevelopmentFee = _buyDevelopmentFee;
670         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
671 
672         sellMarketingFee = _sellMarketingFee;
673         sellLiquidityFee = _sellLiquidityFee;
674         sellDevelopmentFee = _sellDevelopmentFee;
675         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
676 
677         marketingWallet = address(0x649D54fbcDcde8e202E03858fca626790E2F895d); 
678         developmentWallet = address(0x7e3883851F6cA94f8594433C7f36D5A23c21554B); 
679 
680         excludeFromFees(owner(), true);
681         excludeFromFees(address(this), true);
682         excludeFromFees(address(0xdead), true);
683 
684         excludeFromMaxTransaction(owner(), true);
685         excludeFromMaxTransaction(address(this), true);
686         excludeFromMaxTransaction(address(0xdead), true);
687 
688         _mint(msg.sender, totalSupply);
689     }
690 
691     receive() external payable {}
692 
693     function enableTrading() external onlyOwner {
694         tradingActive = true;
695         swapEnabled = true;
696         lastLpBurnTime = block.timestamp;
697     }
698 
699     function removeLimits() external onlyOwner returns (bool) {
700         limitsInEffect = false;
701         return true;
702     }
703 
704     function disableTransferDelay() external onlyOwner returns (bool) {
705         transferDelayEnabled = false;
706         return true;
707     }
708 
709     function updateSwapTokensAtAmount(uint256 newAmount)
710         external
711         onlyOwner
712         returns (bool)
713     {
714         require(
715             newAmount >= (totalSupply() * 1) / 100000,
716             "Swap amount cannot be lower than 0.001% total supply."
717         );
718         require(
719             newAmount <= (totalSupply() * 5) / 1000,
720             "Swap amount cannot be higher than 0.5% total supply."
721         );
722         swapTokensAtAmount = newAmount;
723         return true;
724     }
725 
726     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
727         require(
728             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
729             "Cannot set maxTransactionAmount lower than 0.1%"
730         );
731         maxTransactionAmount = newNum * (10**18);
732     }
733 
734     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
735         require(
736             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
737             "Cannot set maxWallet lower than 0.5%"
738         );
739         maxWallet = newNum * (10**18);
740     }
741 
742     function excludeFromMaxTransaction(address updAds, bool isEx)
743         public
744         onlyOwner
745     {
746         _isExcludedMaxTransactionAmount[updAds] = isEx;
747     }
748 
749     function updateSwapEnabled(bool enabled) external onlyOwner {
750         swapEnabled = enabled;
751     }
752 
753     function updateBuyFees(
754         uint256 _marketingFee,
755         uint256 _liquidityFee,
756         uint256 _developmentFee
757     ) external onlyOwner {
758         buyMarketingFee = _marketingFee;
759         buyLiquidityFee = _liquidityFee;
760         buyDevelopmentFee = _developmentFee;
761         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
762         require(buyTotalFees <= 35, "Must keep fees at 35% or less");
763     }
764 
765     function updateSellFees(
766         uint256 _marketingFee,
767         uint256 _liquidityFee,
768         uint256 _developmentFee
769     ) external onlyOwner {
770         sellMarketingFee = _marketingFee;
771         sellLiquidityFee = _liquidityFee;
772         sellDevelopmentFee = _developmentFee;
773         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
774         require(sellTotalFees <= 40, "Must keep fees at 40% or less");
775     }
776 
777     function excludeFromFees(address account, bool excluded) public onlyOwner {
778         _isExcludedFromFees[account] = excluded;
779         emit ExcludeFromFees(account, excluded);
780     }
781 
782     function setAutomatedMarketMakerPair(address pair, bool value)
783         public
784         onlyOwner
785     {
786         require(
787             pair != uniswapV2Pair,
788             "The pair cannot be removed from automatedMarketMakerPairs"
789         );
790 
791         _setAutomatedMarketMakerPair(pair, value);
792     }
793 
794     function _setAutomatedMarketMakerPair(address pair, bool value) private {
795         automatedMarketMakerPairs[pair] = value;
796 
797         emit SetAutomatedMarketMakerPair(pair, value);
798     }
799 
800     function updateMarketingWalletInfo(address newMarketingWallet)
801         external
802         onlyOwner
803     {
804         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
805         marketingWallet = newMarketingWallet;
806     }
807 
808     function updateDevelopmentWalletInfo(address newWallet) external onlyOwner {
809         emit developmentWalletUpdated(newWallet, developmentWallet);
810         developmentWallet = newWallet;
811     }
812 
813     function isExcludedFromFees(address account) public view returns (bool) {
814         return _isExcludedFromFees[account];
815     }
816 
817     event BoughtEarly(address indexed sniper);
818 
819     function _transfer(
820         address from,
821         address to,
822         uint256 amount
823     ) internal override {
824         require(from != address(0), "ERC20: transfer from the zero address");
825         require(to != address(0), "ERC20: transfer to the zero address");
826 
827         if (amount == 0) {
828             super._transfer(from, to, 0);
829             return;
830         }
831 
832         if (limitsInEffect) {
833             if (
834                 from != owner() &&
835                 to != owner() &&
836                 to != address(0) &&
837                 to != address(0xdead) &&
838                 !swapping
839             ) {
840                 if (!tradingActive) {
841                     require(
842                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
843                         "Trading is not active."
844                     );
845                 }
846 
847                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
848                 if (transferDelayEnabled) {
849                     if (
850                         to != owner() &&
851                         to != address(uniswapV2Router) &&
852                         to != address(uniswapV2Pair)
853                     ) {
854                         require(
855                             _holderLastTransferTimestamp[tx.origin] <
856                                 block.number,
857                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
858                         );
859                         _holderLastTransferTimestamp[tx.origin] = block.number;
860                     }
861                 }
862 
863                 //when buy
864                 if (
865                     automatedMarketMakerPairs[from] &&
866                     !_isExcludedMaxTransactionAmount[to]
867                 ) {
868                     require(
869                         amount <= maxTransactionAmount,
870                         "Buy transfer amount exceeds the maxTransactionAmount."
871                     );
872                     require(
873                         amount + balanceOf(to) <= maxWallet,
874                         "Max wallet exceeded"
875                     );
876                 }
877                 //when sell
878                 else if (
879                     automatedMarketMakerPairs[to] &&
880                     !_isExcludedMaxTransactionAmount[from]
881                 ) {
882                     require(
883                         amount <= maxTransactionAmount,
884                         "Sell transfer amount exceeds the maxTransactionAmount."
885                     );
886                 } else if (!_isExcludedMaxTransactionAmount[to]) {
887                     require(
888                         amount + balanceOf(to) <= maxWallet,
889                         "Max wallet exceeded"
890                     );
891                 }
892             }
893         }
894 
895         uint256 contractTokenBalance = balanceOf(address(this));
896 
897         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
898 
899         if (
900             canSwap &&
901             swapEnabled &&
902             !swapping &&
903             !automatedMarketMakerPairs[from] &&
904             !_isExcludedFromFees[from] &&
905             !_isExcludedFromFees[to]
906         ) {
907             swapping = true;
908 
909             swapBack();
910 
911             swapping = false;
912         }
913 
914         if (
915             !swapping &&
916             automatedMarketMakerPairs[to] &&
917             lpBurnEnabled &&
918             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
919             !_isExcludedFromFees[from]
920         ) {
921             autoBurnLiquidityPairTokens();
922         }
923 
924         bool takeFee = !swapping;
925 
926         // if any account belongs to _isExcludedFromFee account then remove the fee
927         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
928             takeFee = false;
929         }
930 
931         uint256 fees = 0;
932         // only take fees on buys/sells, do not take on wallet transfers
933         if (takeFee) {
934             // on sell
935             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
936                 fees = amount.mul(sellTotalFees).div(100);
937                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
938                 tokensForDev += (fees * sellDevelopmentFee) / sellTotalFees;
939                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
940             }
941             // on buy
942             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
943                 fees = amount.mul(buyTotalFees).div(100);
944                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
945                 tokensForDev += (fees * buyDevelopmentFee) / buyTotalFees;
946                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
947             }
948 
949             if (fees > 0) {
950                 super._transfer(from, address(this), fees);
951             }
952 
953             amount -= fees;
954         }
955 
956         super._transfer(from, to, amount);
957     }
958 
959     function swapTokensForEth(uint256 tokenAmount) private {
960         // generate the uniswap pair path of token -> weth
961         address[] memory path = new address[](2);
962         path[0] = address(this);
963         path[1] = uniswapV2Router.WETH();
964 
965         _approve(address(this), address(uniswapV2Router), tokenAmount);
966 
967         // make the swap
968         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
969             tokenAmount,
970             0, // accept any amount of ETH
971             path,
972             address(this),
973             block.timestamp
974         );
975     }
976 
977     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
978         // approve token transfer to cover all possible scenarios
979         _approve(address(this), address(uniswapV2Router), tokenAmount);
980 
981         // add the liquidity
982         uniswapV2Router.addLiquidityETH{value: ethAmount}(
983             address(this),
984             tokenAmount,
985             0, // slippage is unavoidable
986             0, // slippage is unavoidable
987             deadAddress,
988             block.timestamp
989         );
990     }
991 
992     function swapBack() private {
993         uint256 contractBalance = balanceOf(address(this));
994         uint256 totalTokensToSwap = tokensForLiquidity +
995             tokensForMarketing +
996             tokensForDev;
997         bool success;
998 
999         if (contractBalance == 0 || totalTokensToSwap == 0) {
1000             return;
1001         }
1002 
1003         if (contractBalance > swapTokensAtAmount * 20) {
1004             contractBalance = swapTokensAtAmount * 20;
1005         }
1006 
1007         // Halve the amount of liquidity tokens
1008         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1009             totalTokensToSwap /
1010             2;
1011         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1012 
1013         uint256 initialETHBalance = address(this).balance;
1014 
1015         swapTokensForEth(amountToSwapForETH);
1016 
1017         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1018 
1019         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1020             totalTokensToSwap
1021         );
1022         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1023 
1024         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1025 
1026         tokensForLiquidity = 0;
1027         tokensForMarketing = 0;
1028         tokensForDev = 0;
1029 
1030         (success, ) = address(developmentWallet).call{value: ethForDev}("");
1031 
1032         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1033             addLiquidity(liquidityTokens, ethForLiquidity);
1034             emit SwapAndLiquify(
1035                 amountToSwapForETH,
1036                 ethForLiquidity,
1037                 tokensForLiquidity
1038             );
1039         }
1040 
1041         (success, ) = address(marketingWallet).call{
1042             value: address(this).balance
1043         }("");
1044     }
1045 
1046     function setAutoLPBurnSettings(
1047         uint256 _frequencyInSeconds,
1048         uint256 _percent,
1049         bool _Enabled
1050     ) external onlyOwner {
1051         require(
1052             _frequencyInSeconds >= 600,
1053             "cannot set buyback more often than every 10 minutes"
1054         );
1055         require(
1056             _percent <= 1000 && _percent >= 0,
1057             "Must set auto LP burn percent between 0% and 10%"
1058         );
1059         lpBurnFrequency = _frequencyInSeconds;
1060         percentForLPBurn = _percent;
1061         lpBurnEnabled = _Enabled;
1062     }
1063 
1064     function autoBurnLiquidityPairTokens() internal returns (bool) {
1065         lastLpBurnTime = block.timestamp;
1066 
1067         // get balance of liquidity pair
1068         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1069 
1070         // calculate amount to burn
1071         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1072             10000
1073         );
1074 
1075         // pull tokens from pancakePair liquidity and move to dead address permanently
1076         if (amountToBurn > 0) {
1077             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1078         }
1079 
1080         //sync price since this is not in a swap transaction!
1081         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1082         pair.sync();
1083         emit AutoNukeLP();
1084         return true;
1085     }
1086 
1087     function manualBurnLiquidityPairTokens(uint256 percent)
1088         external
1089         onlyOwner
1090         returns (bool)
1091     {
1092         require(
1093             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1094             "Must wait for cooldown to finish"
1095         );
1096         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1097         lastManualLpBurnTime = block.timestamp;
1098 
1099         // get balance of liquidity pair
1100         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1101 
1102         // calculate amount to burn
1103         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1104 
1105         // pull tokens from pancakePair liquidity and move to dead address permanently
1106         if (amountToBurn > 0) {
1107             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1108         }
1109 
1110         //sync price since this is not in a swap transaction!
1111         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1112         pair.sync();
1113         emit ManualNukeLP();
1114         return true;
1115     }
1116 }