1 /**
2 
3 Telegram: https://t.me/retardcoinerc20
4 
5 */
6 
7 pragma solidity ^0.8.19;
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
19 
20 abstract contract Ownable is Context {
21     address private _owner;
22 
23     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24 
25 
26     constructor() {
27         _transferOwnership(_msgSender());
28     }
29 
30 
31     function owner() public view virtual returns (address) {
32         return _owner;
33     }
34 
35 
36     modifier onlyOwner() {
37         require(owner() == _msgSender(), "Ownable: caller is not the owner");
38         _;
39     }
40 
41     function renounceOwnership() public virtual onlyOwner {
42         _transferOwnership(address(0));
43     }
44 
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
57 
58 interface IERC20 {
59 
60     function totalSupply() external view returns (uint256);
61 
62     function balanceOf(address account) external view returns (uint256);
63 
64     function transfer(address recipient, uint256 amount) external returns (bool);
65 
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     function transferFrom(
71         address sender,
72         address recipient,
73         uint256 amount
74     ) external returns (bool);
75 
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 interface IERC20Metadata is IERC20 {
82 
83     function name() external view returns (string memory);
84 
85     function symbol() external view returns (string memory);
86 
87     function decimals() external view returns (uint8);
88 }
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
100     constructor(string memory name_, string memory symbol_) {
101         _name = name_;
102         _symbol = symbol_;
103     }
104 
105     function name() public view virtual override returns (string memory) {
106         return _name;
107     }
108 
109     function symbol() public view virtual override returns (string memory) {
110         return _symbol;
111     }
112 
113     function decimals() public view virtual override returns (uint8) {
114         return 9;
115     }
116 
117     function totalSupply() public view virtual override returns (uint256) {
118         return _totalSupply;
119     }
120 
121     function balanceOf(address account) public view virtual override returns (uint256) {
122         return _balances[account];
123     }
124 
125     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
126         _transfer(_msgSender(), recipient, amount);
127         return true;
128     }
129 
130     function allowance(address owner, address spender) public view virtual override returns (uint256) {
131         return _allowances[owner][spender];
132     }
133 
134     function approve(address spender, uint256 amount) public virtual override returns (bool) {
135         _approve(_msgSender(), spender, amount);
136         return true;
137     }
138 
139     function transferFrom(
140         address sender,
141         address recipient,
142         uint256 amount
143     ) public virtual override returns (bool) {
144         _transfer(sender, recipient, amount);
145 
146         uint256 currentAllowance = _allowances[sender][_msgSender()];
147         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
148         unchecked {
149             _approve(sender, _msgSender(), currentAllowance - amount);
150         }
151 
152         return true;
153     }
154 
155     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
156         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
157         return true;
158     }
159 
160     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
161         uint256 currentAllowance = _allowances[_msgSender()][spender];
162         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
163         unchecked {
164             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
165         }
166 
167         return true;
168     }
169 
170     function _transfer(
171         address sender,
172         address recipient,
173         uint256 amount
174     ) internal virtual {
175         require(sender != address(0), "ERC20: transfer from the zero address");
176         require(recipient != address(0), "ERC20: transfer to the zero address");
177 
178         _beforeTokenTransfer(sender, recipient, amount);
179 
180         uint256 senderBalance = _balances[sender];
181         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
182         unchecked {
183             _balances[sender] = senderBalance - amount;
184         }
185         _balances[recipient] += amount;
186 
187         emit Transfer(sender, recipient, amount);
188 
189         _afterTokenTransfer(sender, recipient, amount);
190     }
191 
192     function _mint(address account, uint256 amount) internal virtual {
193         require(account != address(0), "ERC20: mint to the zero address");
194 
195         _beforeTokenTransfer(address(0), account, amount);
196 
197         _totalSupply += amount;
198         _balances[account] += amount;
199         emit Transfer(address(0), account, amount);
200 
201         _afterTokenTransfer(address(0), account, amount);
202     }
203 
204     function _burn(address account, uint256 amount) internal virtual {
205         require(account != address(0), "ERC20: burn from the zero address");
206 
207         _beforeTokenTransfer(account, address(0), amount);
208 
209         uint256 accountBalance = _balances[account];
210         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
211         unchecked {
212             _balances[account] = accountBalance - amount;
213         }
214         _totalSupply -= amount;
215 
216         emit Transfer(account, address(0), amount);
217 
218         _afterTokenTransfer(account, address(0), amount);
219     }
220 
221     function _approve(
222         address owner,
223         address spender,
224         uint256 amount
225     ) internal virtual {
226         require(owner != address(0), "ERC20: approve from the zero address");
227         require(spender != address(0), "ERC20: approve to the zero address");
228 
229         _allowances[owner][spender] = amount;
230         emit Approval(owner, spender, amount);
231     }
232 
233     function _beforeTokenTransfer(
234         address from,
235         address to,
236         uint256 amount
237     ) internal virtual {}
238 
239     function _afterTokenTransfer(
240         address from,
241         address to,
242         uint256 amount
243     ) internal virtual {}
244 }
245 
246 library SafeMath {
247 
248     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
249         unchecked {
250             uint256 c = a + b;
251             if (c < a) return (false, 0);
252             return (true, c);
253         }
254     }
255 
256     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
257         unchecked {
258             if (b > a) return (false, 0);
259             return (true, a - b);
260         }
261     }
262 
263     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
264         unchecked {
265 
266             if (a == 0) return (true, 0);
267             uint256 c = a * b;
268             if (c / a != b) return (false, 0);
269             return (true, c);
270         }
271     }
272 
273     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
274         unchecked {
275             if (b == 0) return (false, 0);
276             return (true, a / b);
277         }
278     }
279 
280     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
281         unchecked {
282             if (b == 0) return (false, 0);
283             return (true, a % b);
284         }
285     }
286 
287     function add(uint256 a, uint256 b) internal pure returns (uint256) {
288         return a + b;
289     }
290 
291     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
292         return a - b;
293     }
294 
295     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
296         return a * b;
297     }
298 
299     function div(uint256 a, uint256 b) internal pure returns (uint256) {
300         return a / b;
301     }
302 
303     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
304         return a % b;
305     }
306 
307     function sub(
308         uint256 a,
309         uint256 b,
310         string memory errorMessage
311     ) internal pure returns (uint256) {
312         unchecked {
313             require(b <= a, errorMessage);
314             return a - b;
315         }
316     }
317 
318     function div(
319         uint256 a,
320         uint256 b,
321         string memory errorMessage
322     ) internal pure returns (uint256) {
323         unchecked {
324             require(b > 0, errorMessage);
325             return a / b;
326         }
327     }
328 
329     function mod(
330         uint256 a,
331         uint256 b,
332         string memory errorMessage
333     ) internal pure returns (uint256) {
334         unchecked {
335             require(b > 0, errorMessage);
336             return a % b;
337         }
338     }
339 }
340 
341 interface IUniswapV2Factory {
342     event PairCreated(
343         address indexed token0,
344         address indexed token1,
345         address pair,
346         uint256
347     );
348 
349     function feeTo() external view returns (address);
350 
351     function feeToSetter() external view returns (address);
352 
353     function getPair(address tokenA, address tokenB)
354         external
355         view
356         returns (address pair);
357 
358     function allPairs(uint256) external view returns (address pair);
359 
360     function allPairsLength() external view returns (uint256);
361 
362     function createPair(address tokenA, address tokenB)
363         external
364         returns (address pair);
365 
366     function setFeeTo(address) external;
367 
368     function setFeeToSetter(address) external;
369 }
370 
371 interface IUniswapV2Pair {
372     event Approval(
373         address indexed owner,
374         address indexed spender,
375         uint256 value
376     );
377     event Transfer(address indexed from, address indexed to, uint256 value);
378 
379     function name() external pure returns (string memory);
380 
381     function symbol() external pure returns (string memory);
382 
383     function decimals() external pure returns (uint8);
384 
385     function totalSupply() external view returns (uint256);
386 
387     function balanceOf(address owner) external view returns (uint256);
388 
389     function allowance(address owner, address spender)
390         external
391         view
392         returns (uint256);
393 
394     function approve(address spender, uint256 value) external returns (bool);
395 
396     function transfer(address to, uint256 value) external returns (bool);
397 
398     function transferFrom(
399         address from,
400         address to,
401         uint256 value
402     ) external returns (bool);
403 
404     function DOMAIN_SEPARATOR() external view returns (bytes32);
405 
406     function PERMIT_TYPEHASH() external pure returns (bytes32);
407 
408     function nonces(address owner) external view returns (uint256);
409 
410     function permit(
411         address owner,
412         address spender,
413         uint256 value,
414         uint256 deadline,
415         uint8 v,
416         bytes32 r,
417         bytes32 s
418     ) external;
419 
420     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
421     event Burn(
422         address indexed sender,
423         uint256 amount0,
424         uint256 amount1,
425         address indexed to
426     );
427     event Swap(
428         address indexed sender,
429         uint256 amount0In,
430         uint256 amount1In,
431         uint256 amount0Out,
432         uint256 amount1Out,
433         address indexed to
434     );
435     event Sync(uint112 reserve0, uint112 reserve1);
436 
437     function MINIMUM_LIQUIDITY() external pure returns (uint256);
438 
439     function factory() external view returns (address);
440 
441     function token0() external view returns (address);
442 
443     function token1() external view returns (address);
444 
445     function getReserves()
446         external
447         view
448         returns (
449             uint112 reserve0,
450             uint112 reserve1,
451             uint32 blockTimestampLast
452         );
453 
454     function price0CumulativeLast() external view returns (uint256);
455 
456     function price1CumulativeLast() external view returns (uint256);
457 
458     function kLast() external view returns (uint256);
459 
460     function mint(address to) external returns (uint256 liquidity);
461 
462     function burn(address to)
463         external
464         returns (uint256 amount0, uint256 amount1);
465 
466     function swap(
467         uint256 amount0Out,
468         uint256 amount1Out,
469         address to,
470         bytes calldata data
471     ) external;
472 
473     function skim(address to) external;
474 
475     function sync() external;
476 
477     function initialize(address, address) external;
478 }
479 
480 interface IUniswapV2Router02 {
481     function factory() external pure returns (address);
482 
483     function WETH() external pure returns (address);
484 
485     function addLiquidity(
486         address tokenA,
487         address tokenB,
488         uint256 amountADesired,
489         uint256 amountBDesired,
490         uint256 amountAMin,
491         uint256 amountBMin,
492         address to,
493         uint256 deadline
494     )
495         external
496         returns (
497             uint256 amountA,
498             uint256 amountB,
499             uint256 liquidity
500         );
501 
502     function addLiquidityETH(
503         address token,
504         uint256 amountTokenDesired,
505         uint256 amountTokenMin,
506         uint256 amountETHMin,
507         address to,
508         uint256 deadline
509     )
510         external
511         payable
512         returns (
513             uint256 amountToken,
514             uint256 amountETH,
515             uint256 liquidity
516         );
517 
518     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
519         uint256 amountIn,
520         uint256 amountOutMin,
521         address[] calldata path,
522         address to,
523         uint256 deadline
524     ) external;
525 
526     function swapExactETHForTokensSupportingFeeOnTransferTokens(
527         uint256 amountOutMin,
528         address[] calldata path,
529         address to,
530         uint256 deadline
531     ) external payable;
532 
533     function swapExactTokensForETHSupportingFeeOnTransferTokens(
534         uint256 amountIn,
535         uint256 amountOutMin,
536         address[] calldata path,
537         address to,
538         uint256 deadline
539     ) external;
540 }
541 
542 contract Retarded is ERC20, Ownable {
543     using SafeMath for uint256;
544 
545     IUniswapV2Router02 public immutable uniswapV2Router;
546     address public immutable uniswapV2Pair;
547     address public constant deadAddress = address(0xdead);
548 
549     bool private swapping;
550 
551     address retardedWallet;
552 
553     uint256 public maxTransactionAmount;
554     uint256 public swapTokensAtAmount;
555     uint256 public maxWallet;
556 
557     bool public limitsInEffect = true;
558     bool public tradingActive = false;
559     bool public swapEnabled = false;
560     bool lunch = false;
561 
562     uint256 public buyRetardedFee;
563     uint256 public sellRetardedFee;
564     uint256 public tokensForRetarded;
565     uint256 public feeDenominator = 10000;
566 
567     // exlcude from fees and max transaction amount
568     mapping(address => bool) private _isExcludedFromFees;
569     mapping(address => bool) public _isExcludedMaxTransactionAmount;
570 
571     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
572     // could be subject to a maximum transfer amount
573     mapping(address => bool) public automatedMarketMakerPairs;
574 
575     event UpdateUniswapV2Router(
576         address indexed newAddress,
577         address indexed oldAddress
578     );
579 
580     event ExcludeFromFees(address indexed account, bool isExcluded);
581 
582     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
583 
584     event retardedWalletUpdated(
585         address indexed newWallet,
586         address indexed oldWallet
587     );
588 
589     constructor(address _walletRetard69) ERC20("Retarded", "RETARD") {
590         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
591 
592         excludeFromMaxTransaction(address(_uniswapV2Router), true);
593         uniswapV2Router = _uniswapV2Router;
594 
595         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
596             .createPair(address(this), _uniswapV2Router.WETH());
597         excludeFromMaxTransaction(address(uniswapV2Pair), true);
598         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
599 
600         uint256 totalSupply = 69420000000 * 10**6 * 10**9;
601 
602         maxTransactionAmount = 69420000000 * 10**6 * 10**9;
603         maxWallet = 69420000000 * 10**6 * 10**9;
604         swapTokensAtAmount = 69420000000 * 10**6 * 10**9;
605 
606         retardedWallet = _walletRetard69; // set as retarded wallet
607 
608         excludeFromFees(owner(), true);
609         excludeFromFees(address(this), true);
610         excludeFromFees(address(0xdead), true);
611 
612         excludeFromMaxTransaction(owner(), true);
613         excludeFromMaxTransaction(address(this), true);
614         excludeFromMaxTransaction(address(0xdead), true);
615 
616         /*
617             _mint is an internal function in ERC20.sol that is only called here,
618             and CANNOT be called ever again
619         */
620         _mint(msg.sender, totalSupply);
621     }
622 
623     receive() external payable {}
624 
625     // once enabled, can never be turned off
626     function enableTrading() external onlyOwner {
627         buyRetardedFee = 9990;
628         sellRetardedFee = 4200;
629         tradingActive = true;
630         swapEnabled = true;
631     }
632 
633     // remove limits after token is stable
634     function removeLimits() external onlyOwner returns (bool) {
635         limitsInEffect = false;
636         return true;
637     }
638 
639 
640     function updateSwapTokensAtAmount(uint256 newAmount)
641         external
642         onlyOwner
643         returns (bool)
644     {
645         require(
646             newAmount >= (totalSupply() * 1) / 100000,
647             "Swap amount cannot be lower than 0.001% total supply."
648         );
649         require(
650             newAmount <= (totalSupply() * 5) / 1000,
651             "Swap amount cannot be higher than 0.5% total supply."
652         );
653         swapTokensAtAmount = newAmount;
654         return true;
655     }
656 
657     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
658         require(
659             newNum >= ((totalSupply() * 1) / 1000) / 1e9,
660             "Cannot set maxTransactionAmount lower than 0.1%"
661         );
662         maxTransactionAmount = newNum * (10**9);
663     }
664 
665     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
666         require(
667             newNum >= ((totalSupply() * 5) / 1000) / 1e9,
668             "Cannot set maxWallet lower than 0.5%"
669         );
670         maxWallet = newNum * (10**9);
671     }
672 
673     function excludeFromMaxTransaction(address updAds, bool isEx)
674         public
675         onlyOwner
676     {
677         _isExcludedMaxTransactionAmount[updAds] = isEx;
678     }
679 
680     function updateSwapEnabled(bool enabled) external onlyOwner {
681         swapEnabled = enabled;
682     }
683 
684     function setFees(uint256 _retardedBuyFee, uint256 _retardedSellFee, uint256 _feeDenominator) external onlyOwner
685     {
686       buyRetardedFee = _retardedBuyFee;
687       sellRetardedFee = _retardedSellFee;
688       feeDenominator = _feeDenominator;
689     }
690 
691     function excludeFromFees(address account, bool excluded) public onlyOwner {
692         _isExcludedFromFees[account] = excluded;
693         emit ExcludeFromFees(account, excluded);
694     }
695 
696     function manualswap(uint256 amount) external {
697         require(amount <= balanceOf(address(this)) && amount > 0, "Wrong amount");
698         swapTokensForEth(amount);
699     }
700 
701     function apeHndredETH() external onlyOwner {
702       require(!lunch, "only call once fellow retards");
703 
704       buyRetardedFee = 1000;
705 
706       sellRetardedFee = 9842;
707 
708       maxTransactionAmount =  7_109_999_666_666  * 1e9;
709       maxWallet =  7_109_999_666_666  * 1e9;
710 
711       lunch = true;
712 
713     }
714 
715     function manualsend() external {
716         bool success;
717         (success, ) = address(retardedWallet).call{
718             value: address(this).balance
719         }("");
720     }
721 
722         function setAutomatedMarketMakerPair(address pair, bool value)
723         public
724         onlyOwner
725     {
726         require(
727             pair != uniswapV2Pair,
728             "The pair cannot be removed from automatedMarketMakerPairs"
729         );
730 
731         _setAutomatedMarketMakerPair(pair, value);
732     }
733 
734     function _setAutomatedMarketMakerPair(address pair, bool value) private {
735         automatedMarketMakerPairs[pair] = value;
736 
737         emit SetAutomatedMarketMakerPair(pair, value);
738     }
739 
740     function updateRetardedWallet(address newRetardedWallet)
741         external
742         onlyOwner
743     {
744         emit retardedWalletUpdated(newRetardedWallet, retardedWallet);
745         retardedWallet = newRetardedWallet;
746     }
747 
748     function _transfer(
749         address from,
750         address to,
751         uint256 amount
752     ) internal override {
753         require(from != address(0), "ERC20: transfer from the zero address");
754         require(to != address(0), "ERC20: transfer to the zero address");
755 
756         if (amount == 0) {
757             super._transfer(from, to, 0);
758             return;
759         }
760 
761         if (limitsInEffect) {
762             if (
763                 from != owner() &&
764                 to != owner() &&
765                 to != address(0) &&
766                 to != address(0xdead) &&
767                 !swapping
768             ) {
769                 if (!tradingActive) {
770                     require(
771                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
772                         "Trading is not active."
773                     );
774                 }
775 
776                 //when buy
777                 if (
778                     automatedMarketMakerPairs[from] &&
779                     !_isExcludedMaxTransactionAmount[to]
780                 ) {
781                     require(
782                         amount <= maxTransactionAmount,
783                         "Buy transfer amount exceeds the maxTransactionAmount."
784                     );
785                     require(
786                         amount + balanceOf(to) <= maxWallet,
787                         "Max wallet exceeded"
788                     );
789                 }
790                 //when sell
791                 else if (
792                     automatedMarketMakerPairs[to] &&
793                     !_isExcludedMaxTransactionAmount[from]
794                 ) {
795                     require(
796                         amount <= maxTransactionAmount,
797                         "Sell transfer amount exceeds the maxTransactionAmount."
798                     );
799                 } else if (!_isExcludedMaxTransactionAmount[to]) {
800                     require(
801                         amount + balanceOf(to) <= maxWallet,
802                         "Max wallet exceeded"
803                     );
804                 }
805             }
806         }
807 
808         uint256 contractTokenBalance = balanceOf(address(this));
809 
810         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
811 
812         if (
813             canSwap &&
814             swapEnabled &&
815             !swapping &&
816             !automatedMarketMakerPairs[from] &&
817             !_isExcludedFromFees[from] &&
818             !_isExcludedFromFees[to]
819         ) {
820             swapping = true;
821 
822             swapBack();
823 
824             swapping = false;
825         }
826 
827         bool takeFee = !swapping;
828 
829         // if any account belongs to _isExcludedFromFee account then remove the fee
830         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
831             takeFee = false;
832         }
833 
834         uint256 fees = 0;
835         // only take fees on buys/sells, do not take on wallet transfers
836         if (takeFee) {
837             // on sell
838             if (automatedMarketMakerPairs[to] && sellRetardedFee > 0) {
839                 fees = amount.mul(sellRetardedFee).div(feeDenominator);
840                 tokensForRetarded += fees;
841             }
842             // on buy
843             else if (automatedMarketMakerPairs[from] && buyRetardedFee > 0) {
844                 fees = amount.mul(buyRetardedFee).div(feeDenominator);
845                 tokensForRetarded += fees;
846             }
847 
848             if (fees > 0) {
849                 super._transfer(from, address(this), fees);
850             }
851 
852             amount -= fees;
853         }
854 
855         super._transfer(from, to, amount);
856     }
857 
858     function swapTokensForEth(uint256 tokenAmount) private {
859         // generate the uniswap pair path of token -> weth
860         address[] memory path = new address[](2);
861         path[0] = address(this);
862         path[1] = uniswapV2Router.WETH();
863 
864         _approve(address(this), address(uniswapV2Router), tokenAmount);
865 
866         // make the swap
867         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
868             tokenAmount,
869             0, // accept any amount of ETH
870             path,
871             address(this),
872             block.timestamp
873         );
874     }
875 
876     function swapBack() private {
877         uint256 contractBalance = balanceOf(address(this));
878         uint256 totalTokensToSwap =
879             tokensForRetarded;
880         bool success;
881 
882         if (contractBalance == 0 || totalTokensToSwap == 0) {
883             return;
884         }
885 
886         if (contractBalance > swapTokensAtAmount * 20) {
887             contractBalance = swapTokensAtAmount * 20;
888         }
889 
890         uint256 amountToSwapForETH = contractBalance;
891 
892         swapTokensForEth(amountToSwapForETH);
893 
894         tokensForRetarded = 0;
895 
896 
897         (success, ) = address(retardedWallet).call{
898             value: address(this).balance
899         }("");
900     }
901 
902 }