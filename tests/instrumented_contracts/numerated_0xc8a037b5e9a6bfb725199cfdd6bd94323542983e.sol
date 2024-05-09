1 /**
2 
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity 0.8.17;
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
19 contract Ownable is Context {
20     address private _owner;
21 
22     event OwnershipTransferred(
23         address indexed previousOwner,
24         address indexed newOwner
25     );
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
40     function renounceOwnership() public virtual onlyOwner {
41         _transferOwnership(address(0));
42     }
43 
44     function transferOwnership(address newOwner) public virtual onlyOwner {
45         require(
46             newOwner != address(0),
47             "Ownable: new owner is the zero address"
48         );
49         _transferOwnership(newOwner);
50     }
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
65     function transfer(address recipient, uint256 amount)
66         external
67         returns (bool);
68 
69     function allowance(address owner, address spender)
70         external
71         view
72         returns (uint256);
73 
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     function transferFrom(
77         address sender,
78         address recipient,
79         uint256 amount
80     ) external returns (bool);
81 
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     event Approval(
85         address indexed owner,
86         address indexed spender,
87         uint256 value
88     );
89 }
90 
91 interface IERC20Metadata is IERC20 {
92 
93     function name() external view returns (string memory);
94 
95     function symbol() external view returns (string memory);
96 
97     function decimals() external view returns (uint8);
98 }
99 
100 contract ERC20 is Context, IERC20, IERC20Metadata {
101     mapping(address => uint256) private _balances;
102 
103     mapping(address => mapping(address => uint256)) private _allowances;
104 
105     uint256 private _totalSupply;
106 
107     string private _name;
108     string private _symbol;
109 
110     constructor(string memory name_, string memory symbol_) {
111         _name = name_;
112         _symbol = symbol_;
113     }
114 
115     function name() public view virtual override returns (string memory) {
116         return _name;
117     }
118 
119     function symbol() public view virtual override returns (string memory) {
120         return _symbol;
121     }
122 
123     function decimals() public view virtual override returns (uint8) {
124         return 18;
125     }
126 
127     function totalSupply() public view virtual override returns (uint256) {
128         return _totalSupply;
129     }
130 
131     function balanceOf(address account)
132         public
133         view
134         virtual
135         override
136         returns (uint256)
137     {
138         return _balances[account];
139     }
140 
141     function transfer(address recipient, uint256 amount)
142         public
143         virtual
144         override
145         returns (bool)
146     {
147         _transfer(_msgSender(), recipient, amount);
148         return true;
149     }
150 
151     function allowance(address owner, address spender)
152         public
153         view
154         virtual
155         override
156         returns (uint256)
157     {
158         return _allowances[owner][spender];
159     }
160 
161     function approve(address spender, uint256 amount)
162         public
163         virtual
164         override
165         returns (bool)
166     {
167         _approve(_msgSender(), spender, amount);
168         return true;
169     }
170 
171     function transferFrom(
172         address sender,
173         address recipient,
174         uint256 amount
175     ) public virtual override returns (bool) {
176         _transfer(sender, recipient, amount);
177 
178         uint256 currentAllowance = _allowances[sender][_msgSender()];
179         require(
180             currentAllowance >= amount,
181             "ERC20: transfer amount exceeds allowance"
182         );
183         unchecked {
184             _approve(sender, _msgSender(), currentAllowance - amount);
185         }
186 
187         return true;
188     }
189 
190     function increaseAllowance(address spender, uint256 addedValue)
191         public
192         virtual
193         returns (bool)
194     {
195         _approve(
196             _msgSender(),
197             spender,
198             _allowances[_msgSender()][spender] + addedValue
199         );
200         return true;
201     }
202 
203     function decreaseAllowance(address spender, uint256 subtractedValue)
204         public
205         virtual
206         returns (bool)
207     {
208         uint256 currentAllowance = _allowances[_msgSender()][spender];
209         require(
210             currentAllowance >= subtractedValue,
211             "ERC20: decreased allowance below zero"
212         );
213         unchecked {
214             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
215         }
216 
217         return true;
218     }
219 
220     function _transfer(
221         address sender,
222         address recipient,
223         uint256 amount
224     ) internal virtual {
225         require(sender != address(0), "ERC20: transfer from the zero address");
226         require(recipient != address(0), "ERC20: transfer to the zero address");
227 
228         _beforeTokenTransfer(sender, recipient, amount);
229 
230         uint256 senderBalance = _balances[sender];
231         require(
232             senderBalance >= amount,
233             "ERC20: transfer amount exceeds balance"
234         );
235         unchecked {
236             _balances[sender] = senderBalance - amount;
237         }
238         _balances[recipient] += amount;
239 
240         emit Transfer(sender, recipient, amount);
241 
242         _afterTokenTransfer(sender, recipient, amount);
243     }
244 
245     function _mint(address account, uint256 amount) internal virtual {
246         require(account != address(0), "ERC20: mint to the zero address");
247 
248         _beforeTokenTransfer(address(0), account, amount);
249 
250         _totalSupply += amount;
251         _balances[account] += amount;
252         emit Transfer(address(0), account, amount);
253 
254         _afterTokenTransfer(address(0), account, amount);
255     }
256 
257     function _burn(address account, uint256 amount) internal virtual {
258         require(account != address(0), "ERC20: burn from the zero address");
259 
260         _beforeTokenTransfer(account, address(0), amount);
261 
262         uint256 accountBalance = _balances[account];
263         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
264         unchecked {
265             _balances[account] = accountBalance - amount;
266         }
267         _totalSupply -= amount;
268 
269         emit Transfer(account, address(0), amount);
270 
271         _afterTokenTransfer(account, address(0), amount);
272     }
273 
274     function _approve(
275         address owner,
276         address spender,
277         uint256 amount
278     ) internal virtual {
279         require(owner != address(0), "ERC20: approve from the zero address");
280         require(spender != address(0), "ERC20: approve to the zero address");
281 
282         _allowances[owner][spender] = amount;
283         emit Approval(owner, spender, amount);
284     }
285 
286     function _beforeTokenTransfer(
287         address from,
288         address to,
289         uint256 amount
290     ) internal virtual {}
291 
292     function _afterTokenTransfer(
293         address from,
294         address to,
295         uint256 amount
296     ) internal virtual {}
297 }
298 
299 library SafeMath {
300     function tryAdd(uint256 a, uint256 b)
301         internal
302         pure
303         returns (bool, uint256)
304     {
305         unchecked {
306             uint256 c = a + b;
307             if (c < a) return (false, 0);
308             return (true, c);
309         }
310     }
311 
312     function trySub(uint256 a, uint256 b)
313         internal
314         pure
315         returns (bool, uint256)
316     {
317         unchecked {
318             if (b > a) return (false, 0);
319             return (true, a - b);
320         }
321     }
322 
323     function tryMul(uint256 a, uint256 b)
324         internal
325         pure
326         returns (bool, uint256)
327     {
328         unchecked {
329             if (a == 0) return (true, 0);
330             uint256 c = a * b;
331             if (c / a != b) return (false, 0);
332             return (true, c);
333         }
334     }
335 
336     function tryDiv(uint256 a, uint256 b)
337         internal
338         pure
339         returns (bool, uint256)
340     {
341         unchecked {
342             if (b == 0) return (false, 0);
343             return (true, a / b);
344         }
345     }
346 
347     function tryMod(uint256 a, uint256 b)
348         internal
349         pure
350         returns (bool, uint256)
351     {
352         unchecked {
353             if (b == 0) return (false, 0);
354             return (true, a % b);
355         }
356     }
357 
358     function add(uint256 a, uint256 b) internal pure returns (uint256) {
359         return a + b;
360     }
361 
362     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
363         return a - b;
364     }
365 
366     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
367         return a * b;
368     }
369 
370     function div(uint256 a, uint256 b) internal pure returns (uint256) {
371         return a / b;
372     }
373 
374     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
375         return a % b;
376     }
377 
378     function sub(
379         uint256 a,
380         uint256 b,
381         string memory errorMessage
382     ) internal pure returns (uint256) {
383         unchecked {
384             require(b <= a, errorMessage);
385             return a - b;
386         }
387     }
388 
389     function div(
390         uint256 a,
391         uint256 b,
392         string memory errorMessage
393     ) internal pure returns (uint256) {
394         unchecked {
395             require(b > 0, errorMessage);
396             return a / b;
397         }
398     }
399 
400     function mod(
401         uint256 a,
402         uint256 b,
403         string memory errorMessage
404     ) internal pure returns (uint256) {
405         unchecked {
406             require(b > 0, errorMessage);
407             return a % b;
408         }
409     }
410 }
411 
412 interface IUniswapV2Factory {
413     event PairCreated(
414         address indexed token0,
415         address indexed token1,
416         address pair,
417         uint256
418     );
419 
420     function feeTo() external view returns (address);
421 
422     function feeToSetter() external view returns (address);
423 
424     function getPair(address tokenA, address tokenB)
425         external
426         view
427         returns (address pair);
428 
429     function allPairs(uint256) external view returns (address pair);
430 
431     function allPairsLength() external view returns (uint256);
432 
433     function createPair(address tokenA, address tokenB)
434         external
435         returns (address pair);
436 
437     function setFeeTo(address) external;
438 
439     function setFeeToSetter(address) external;
440 }
441 
442 interface IUniswapV2Pair {
443     event Approval(
444         address indexed owner,
445         address indexed spender,
446         uint256 value
447     );
448     event Transfer(address indexed from, address indexed to, uint256 value);
449 
450     function name() external pure returns (string memory);
451 
452     function symbol() external pure returns (string memory);
453 
454     function decimals() external pure returns (uint8);
455 
456     function totalSupply() external view returns (uint256);
457 
458     function balanceOf(address owner) external view returns (uint256);
459 
460     function allowance(address owner, address spender)
461         external
462         view
463         returns (uint256);
464 
465     function approve(address spender, uint256 value) external returns (bool);
466 
467     function transfer(address to, uint256 value) external returns (bool);
468 
469     function transferFrom(
470         address from,
471         address to,
472         uint256 value
473     ) external returns (bool);
474 
475     function DOMAIN_SEPARATOR() external view returns (bytes32);
476 
477     function PERMIT_TYPEHASH() external pure returns (bytes32);
478 
479     function nonces(address owner) external view returns (uint256);
480 
481     function permit(
482         address owner,
483         address spender,
484         uint256 value,
485         uint256 deadline,
486         uint8 v,
487         bytes32 r,
488         bytes32 s
489     ) external;
490 
491     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
492     event Burn(
493         address indexed sender,
494         uint256 amount0,
495         uint256 amount1,
496         address indexed to
497     );
498     event Swap(
499         address indexed sender,
500         uint256 amount0In,
501         uint256 amount1In,
502         uint256 amount0Out,
503         uint256 amount1Out,
504         address indexed to
505     );
506     event Sync(uint112 reserve0, uint112 reserve1);
507 
508     function MINIMUM_LIQUIDITY() external pure returns (uint256);
509 
510     function factory() external view returns (address);
511 
512     function token0() external view returns (address);
513 
514     function token1() external view returns (address);
515 
516     function getReserves()
517         external
518         view
519         returns (
520             uint112 reserve0,
521             uint112 reserve1,
522             uint32 blockTimestampLast
523         );
524 
525     function price0CumulativeLast() external view returns (uint256);
526 
527     function price1CumulativeLast() external view returns (uint256);
528 
529     function kLast() external view returns (uint256);
530 
531     function mint(address to) external returns (uint256 liquidity);
532 
533     function burn(address to)
534         external
535         returns (uint256 amount0, uint256 amount1);
536 
537     function swap(
538         uint256 amount0Out,
539         uint256 amount1Out,
540         address to,
541         bytes calldata data
542     ) external;
543 
544     function skim(address to) external;
545 
546     function sync() external;
547 
548     function initialize(address, address) external;
549 }
550 
551 interface IUniswapV2Router02 {
552     function factory() external pure returns (address);
553 
554     function WETH() external pure returns (address);
555 
556     function addLiquidity(
557         address tokenA,
558         address tokenB,
559         uint256 amountADesired,
560         uint256 amountBDesired,
561         uint256 amountAMin,
562         uint256 amountBMin,
563         address to,
564         uint256 deadline
565     )
566         external
567         returns (
568             uint256 amountA,
569             uint256 amountB,
570             uint256 liquidity
571         );
572 
573     function addLiquidityETH(
574         address token,
575         uint256 amountTokenDesired,
576         uint256 amountTokenMin,
577         uint256 amountETHMin,
578         address to,
579         uint256 deadline
580     )
581         external
582         payable
583         returns (
584             uint256 amountToken,
585             uint256 amountETH,
586             uint256 liquidity
587         );
588 
589     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
590         uint256 amountIn,
591         uint256 amountOutMin,
592         address[] calldata path,
593         address to,
594         uint256 deadline
595     ) external;
596 
597     function swapExactETHForTokensSupportingFeeOnTransferTokens(
598         uint256 amountOutMin,
599         address[] calldata path,
600         address to,
601         uint256 deadline
602     ) external payable;
603 
604     function swapExactTokensForETHSupportingFeeOnTransferTokens(
605         uint256 amountIn,
606         uint256 amountOutMin,
607         address[] calldata path,
608         address to,
609         uint256 deadline
610     ) external;
611 }
612 
613 contract VILLAGE is ERC20, Ownable {
614     using SafeMath for uint256;
615 
616     IUniswapV2Router02 public immutable uniswapV2Router;
617     address public immutable uniswapV2Pair;
618     address public constant deadAddress = address(0xdead);
619 
620     bool private swapping;
621 
622     address public AWallet;
623     address public BWallet;
624     address public CWallet;
625 
626     uint256 public maxTransactionAmount;
627     uint256 public swapTokensAtAmount;
628     uint256 public maxWallet;
629 
630     bool public limitsInEffect = true;
631     bool public tradingActive = false;
632 
633     uint256 public launchedAt;
634     uint256 public launchedAtTimestamp;
635     uint256 antiBot = 2 seconds;
636 
637     uint256 public buyTotalFees = 1;
638     uint256 public buyAFee = 1;
639     uint256 public buyBFee = 0;
640     uint256 public buyCFee = 0;
641     uint256 public buyLiquidityFee = 0;
642     uint256 public buyAutoBurnFee = 0;
643 
644     uint256 public sellTotalFees = 30;
645     uint256 public sellAFee = 30;
646     uint256 public sellBFee = 0;
647     uint256 public sellCFee = 0;
648     uint256 public sellLiquidityFee = 0;
649     uint256 public sellAutoBurnFee = 0;
650 
651     uint256 public tokensForA;
652     uint256 public tokensForLiquidity;
653     uint256 public tokensForB;
654     uint256 public tokensForC;
655     uint256 public tokensForAutoburn;
656 
657     mapping(address => bool) private _isExcludedFromFees;
658     mapping(address => bool) public _isExcludedMaxTransactionAmount;
659     mapping(address => bool) public isBot;
660 
661     mapping(address => bool) public automatedMarketMakerPairs;
662 
663     event UpdateUniswapV2Router(
664         address indexed newAddress,
665         address indexed oldAddress
666     );
667 
668     event ExcludeFromFees(address indexed account, bool isExcluded);
669 
670     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
671 
672     event AWalletUpdated(
673         address indexed newWallet,
674         address indexed oldWallet
675     );
676 
677     event BWalletUpdated(
678         address indexed newWallet,
679         address indexed oldWallet
680     );
681 
682     event CWalletUpdated(
683         address indexed newWallet,
684         address indexed oldWallet
685     );
686     event SwapAndLiquify(
687         uint256 tokensSwapped,
688         uint256 ethReceived,
689         uint256 tokensIntoLiquidity
690     );
691 
692     constructor(
693 
694     ) ERC20("PleaseSerINeedToFeedMyVillage", "VILLAGE") {
695         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
696             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
697         );
698 
699         excludeFromMaxTransaction(address(_uniswapV2Router), true);
700         uniswapV2Router = _uniswapV2Router;
701 
702         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
703             .createPair(address(this), _uniswapV2Router.WETH());
704         excludeFromMaxTransaction(address(uniswapV2Pair), true);
705         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
706 
707         uint256 totalSupply = 100_000_000 * 1e18;
708 
709         maxTransactionAmount = 2000000 * 1e18;
710         maxWallet = 2000000 * 1e18;
711         swapTokensAtAmount = 250000 * 1e18;
712 
713         AWallet = address(0xF7BeCd01Ca7aD676Bd72457e73404D0E30F4e1B8); 
714         BWallet = address(0xF7BeCd01Ca7aD676Bd72457e73404D0E30F4e1B8);
715         CWallet = address(0xF7BeCd01Ca7aD676Bd72457e73404D0E30F4e1B8);
716         excludeFromFees(owner(), true);
717         excludeFromFees(address(this), true);
718         excludeFromFees(address(0xdead), true);
719 
720         excludeFromMaxTransaction(owner(), true);
721         excludeFromMaxTransaction(address(this), true);
722         excludeFromMaxTransaction(address(0xdead), true);
723 
724         _mint(owner(), totalSupply);
725     }
726 
727     receive() external payable {}
728 
729     function launched() internal view returns (bool) {
730         return launchedAt != 0;
731     }
732 
733     function launch() public onlyOwner {
734         require(launchedAt == 0, "Already launched");
735         launchedAt = block.number;
736         launchedAtTimestamp = block.timestamp;
737         tradingActive = true;
738     }
739 
740     function removeLimits() external onlyOwner returns (bool) {
741         limitsInEffect = false;
742         return true;
743     }
744 
745     function excludeFromMaxTransaction(address updAds, bool isEx)
746         public
747         onlyOwner
748     {
749         _isExcludedMaxTransactionAmount[updAds] = isEx;
750     }
751 
752     function updateBuyFees(
753         uint256 _AFee,
754         uint256 _BFee,
755         uint256 _CFee,
756         uint256 _liquidityFee,
757         uint256 _autoBurnFee
758     ) external onlyOwner {
759         buyAFee = _AFee;
760         buyBFee = _BFee;
761         buyCFee = _CFee;
762         buyLiquidityFee = _liquidityFee;
763         buyAutoBurnFee = _autoBurnFee;
764         buyTotalFees =
765             buyAFee +
766             buyBFee +
767             buyCFee +
768             buyLiquidityFee +
769             buyAutoBurnFee;
770     }
771 
772     function updateSellFees(
773         uint256 _AFee,
774         uint256 _BFee,
775         uint256 _CFee,
776         uint256 _liquidityFee,
777         uint256 _autoBurnFee
778     ) external onlyOwner {
779         sellAFee = _AFee;
780         sellBFee = _BFee;
781         sellCFee = _CFee;
782         sellLiquidityFee = _liquidityFee;
783         sellAutoBurnFee = _autoBurnFee;
784         sellTotalFees =
785             sellAFee +
786             sellBFee +
787             sellCFee +
788             sellLiquidityFee +
789             sellAutoBurnFee;
790     }
791 
792     function excludeFromFees(address account, bool excluded) public onlyOwner {
793         _isExcludedFromFees[account] = excluded;
794         emit ExcludeFromFees(account, excluded);
795     }
796 
797     function setAutomatedMarketMakerPair(address pair, bool value)
798         public
799         onlyOwner
800     {
801         require(
802             pair != uniswapV2Pair,
803             "The pair cannot be removed from automatedMarketMakerPairs"
804         );
805 
806         _setAutomatedMarketMakerPair(pair, value);
807     }
808 
809     function _setAutomatedMarketMakerPair(address pair, bool value) private {
810         automatedMarketMakerPairs[pair] = value;
811 
812         emit SetAutomatedMarketMakerPair(pair, value);
813     }
814 
815     function updateAWallet(address newAWallet) external onlyOwner {
816         emit AWalletUpdated(newAWallet, AWallet);
817         AWallet = newAWallet;
818     }
819 
820     function updateBWallet(address newBWallet) external onlyOwner {
821         emit BWalletUpdated(newBWallet, BWallet);
822         BWallet = newBWallet;
823     }
824 
825     function updateCWallet(address newWallet) external onlyOwner {
826         emit CWalletUpdated(newWallet, CWallet);
827         CWallet = newWallet;
828     }
829 
830     function isExcludedFromFees(address account) public view returns (bool) {
831         return _isExcludedFromFees[account];
832     }
833 
834     function addBotInList(address _account) external onlyOwner {
835         require(
836             _account != address(uniswapV2Router),
837             "Can not blacklist router"
838         );
839         require(!isBot[_account], "Bot already added");
840         isBot[_account] = true;
841     }
842 
843     function removeBotFromList(address _account) external onlyOwner {
844         require(isBot[_account], "Bot not found");
845         isBot[_account] = false;
846     }
847 
848     function _transfer(
849         address from,
850         address to,
851         uint256 amount
852     ) internal override {
853         require(from != address(0), "ERC20: transfer from the zero address");
854         require(to != address(0), "ERC20: transfer to the zero address");
855         require(!isBot[to], "Bot detected");
856         require(!isBot[from], "Bot detected");
857 
858         if (amount == 0) {
859             super._transfer(from, to, 0);
860             return;
861         }
862 
863         if (limitsInEffect) {
864             if (
865                 from != owner() &&
866                 to != owner() &&
867                 to != address(0) &&
868                 to != address(0xdead) &&
869                 !swapping
870             ) {
871                 if (!tradingActive) {
872                     require(
873                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
874                         "Trading is not active."
875                     );
876                 }
877                 if (
878                     block.timestamp < launchedAtTimestamp + antiBot &&
879                     from != address(uniswapV2Router)
880                 ) {
881                     if (from == uniswapV2Pair) {
882                         isBot[to] = true;
883                     } else if (to == uniswapV2Pair) {
884                         isBot[from] = true;
885                     }
886                 }
887                 if (
888                     automatedMarketMakerPairs[from] &&
889                     !_isExcludedMaxTransactionAmount[to]
890                 ) {
891                     require(
892                         amount <= maxTransactionAmount,
893                         "Buy transfer amount exceeds the maxTransactionAmount."
894                     );
895                     require(
896                         amount + balanceOf(to) <= maxWallet,
897                         "Max wallet exceeded"
898                     );
899                 }
900                 else if (
901                     automatedMarketMakerPairs[to] &&
902                     !_isExcludedMaxTransactionAmount[from]
903                 ) {
904                     require(
905                         amount <= maxTransactionAmount,
906                         "Sell transfer amount exceeds the maxTransactionAmount."
907                     );
908                 } else if (!_isExcludedMaxTransactionAmount[to]) {
909                     require(
910                         amount + balanceOf(to) <= maxWallet,
911                         "Max wallet exceeded"
912                     );
913                 }
914             }
915         }
916 
917         uint256 contractTokenBalance = balanceOf(address(this));
918 
919         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
920 
921         if (
922             canSwap &&
923             !swapping &&
924             !automatedMarketMakerPairs[from] &&
925             !_isExcludedFromFees[from] &&
926             !_isExcludedFromFees[to]
927         ) {
928             swapping = true;
929 
930             swapBack();
931 
932             swapping = false;
933         }
934 
935         bool takeFee = !swapping;
936 
937         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
938             takeFee = false;
939         }
940 
941         uint256 fees = 0;
942         if (takeFee) {
943             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
944                 fees = amount.mul(sellTotalFees).div(100);
945                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
946                 tokensForB += (fees * sellCFee) / sellTotalFees;
947                 tokensForA += (fees * sellAFee) / sellTotalFees;
948                 tokensForC += (fees * sellCFee) / sellTotalFees;
949                 tokensForAutoburn = (fees * sellAutoBurnFee) / sellTotalFees;
950             }
951             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
952                 fees = amount.mul(buyTotalFees).div(100);
953                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
954                 tokensForB += (fees * buyCFee) / buyTotalFees;
955                 tokensForA += (fees * buyAFee) / buyTotalFees;
956                 tokensForC += (fees * buyCFee) / buyTotalFees;
957                 tokensForAutoburn = (fees * buyAutoBurnFee) / buyTotalFees;
958             }
959 
960             if (fees > 0) {
961                 _burn(from, tokensForAutoburn);
962                 super._transfer(from, address(this), fees - tokensForAutoburn);
963             }
964 
965             amount -= fees;
966         }
967 
968         super._transfer(from, to, amount);
969     }
970 
971     function swapTokensForEth(uint256 tokenAmount) private {
972         address[] memory path = new address[](2);
973         path[0] = address(this);
974         path[1] = uniswapV2Router.WETH();
975 
976         _approve(address(this), address(uniswapV2Router), tokenAmount);
977 
978         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
979             tokenAmount,
980             0,
981             path,
982             address(this),
983             block.timestamp
984         );
985     }
986 
987     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
988         _approve(address(this), address(uniswapV2Router), tokenAmount);
989 
990         uniswapV2Router.addLiquidityETH{value: ethAmount}(
991             address(this),
992             tokenAmount,
993             0, 
994             0, 
995             deadAddress,
996             block.timestamp
997         );
998     }
999 
1000     function swapBack() private {
1001         uint256 contractBalance = balanceOf(address(this));
1002         uint256 totalTokensToSwap = tokensForLiquidity +
1003             tokensForA +
1004             tokensForB +
1005             tokensForC;
1006         bool success;
1007 
1008         if (contractBalance == 0 || totalTokensToSwap == 0) {
1009             return;
1010         }
1011 
1012         if (contractBalance > swapTokensAtAmount) {
1013             contractBalance = swapTokensAtAmount;
1014         }
1015 
1016         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1017             totalTokensToSwap /
1018             2;
1019         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1020 
1021         uint256 initialETHBalance = address(this).balance;
1022 
1023         swapTokensForEth(amountToSwapForETH);
1024 
1025         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1026 
1027         uint256 ethForA = ethBalance.mul(tokensForA).div(
1028             totalTokensToSwap
1029         );
1030         uint256 ethForB = ethBalance.mul(tokensForB).div(
1031             totalTokensToSwap
1032         );
1033         uint256 ethForC = ethBalance.mul(tokensForC).div(
1034             totalTokensToSwap
1035         );
1036         uint256 ethForLiquidity = ethBalance -
1037             ethForA -
1038             ethForB -
1039             ethForC;
1040 
1041         tokensForLiquidity = 0;
1042         tokensForA = 0;
1043         tokensForB = 0;
1044         tokensForC = 0;
1045 
1046         (success, ) = address(BWallet).call{value: ethForB}("");
1047 
1048         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1049             addLiquidity(liquidityTokens, ethForLiquidity);
1050             emit SwapAndLiquify(
1051                 amountToSwapForETH,
1052                 ethForLiquidity,
1053                 tokensForLiquidity
1054             );
1055         }
1056 
1057         (success, ) = address(AWallet).call{value: ethForA}("");
1058         (success, ) = address(CWallet).call{
1059             value: address(this).balance
1060         }("");
1061     }
1062 
1063     function withdrawETH(uint256 _amount) external onlyOwner {
1064         require(address(this).balance >= _amount, "Invalid Amount");
1065         payable(msg.sender).transfer(_amount);
1066     }
1067 }