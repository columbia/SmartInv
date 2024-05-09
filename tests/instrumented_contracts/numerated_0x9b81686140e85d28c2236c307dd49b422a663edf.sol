1 /*
2 
3 Twitter: https://twitter.com/CombustionAlpha
4 Telegram: https://t.me/combustionalpha
5 Website: https://combustion.pro
6 
7 */
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity 0.8.20;
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
23 contract Ownable is Context {
24     address private _owner;
25 
26     event OwnershipTransferred(
27         address indexed previousOwner,
28         address indexed newOwner
29     );
30 
31     constructor() {
32         _transferOwnership(_msgSender());
33     }
34 
35     function owner() public view virtual returns (address) {
36         return _owner;
37     }
38 
39     modifier onlyOwner() {
40         require(owner() == _msgSender(), "Ownable: caller is not the owner");
41         _;
42     }
43 
44     function renounceOwnership() public virtual onlyOwner {
45         _transferOwnership(address(0));
46     }
47 
48     function transferOwnership(address newOwner) public virtual onlyOwner {
49         require(
50             newOwner != address(0),
51             "Ownable: new owner is the zero address"
52         );
53         _transferOwnership(newOwner);
54     }
55 
56     function _transferOwnership(address newOwner) internal virtual {
57         address oldOwner = _owner;
58         _owner = newOwner;
59         emit OwnershipTransferred(oldOwner, newOwner);
60     }
61 }
62 
63 interface IERC20 {
64 
65     function totalSupply() external view returns (uint256);
66 
67     function balanceOf(address account) external view returns (uint256);
68 
69     function transfer(address recipient, uint256 amount)
70         external
71         returns (bool);
72 
73     function allowance(address owner, address spender)
74         external
75         view
76         returns (uint256);
77 
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     function transferFrom(
81         address sender,
82         address recipient,
83         uint256 amount
84     ) external returns (bool);
85 
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 
88     event Approval(
89         address indexed owner,
90         address indexed spender,
91         uint256 value
92     );
93 }
94 
95 interface IERC20Metadata is IERC20 {
96 
97     function name() external view returns (string memory);
98 
99     function symbol() external view returns (string memory);
100 
101     function decimals() external view returns (uint8);
102 }
103 
104 contract ERC20 is Context, IERC20, IERC20Metadata {
105     mapping(address => uint256) private _balances;
106 
107     mapping(address => mapping(address => uint256)) private _allowances;
108 
109     uint256 private _totalSupply;
110 
111     string private _name;
112     string private _symbol;
113 
114     constructor(string memory name_, string memory symbol_) {
115         _name = name_;
116         _symbol = symbol_;
117     }
118 
119     function name() public view virtual override returns (string memory) {
120         return _name;
121     }
122 
123     function symbol() public view virtual override returns (string memory) {
124         return _symbol;
125     }
126 
127     function decimals() public view virtual override returns (uint8) {
128         return 18;
129     }
130 
131     function totalSupply() public view virtual override returns (uint256) {
132         return _totalSupply;
133     }
134 
135     function balanceOf(address account)
136         public
137         view
138         virtual
139         override
140         returns (uint256)
141     {
142         return _balances[account];
143     }
144 
145     function transfer(address recipient, uint256 amount)
146         public
147         virtual
148         override
149         returns (bool)
150     {
151         _transfer(_msgSender(), recipient, amount);
152         return true;
153     }
154 
155     function allowance(address owner, address spender)
156         public
157         view
158         virtual
159         override
160         returns (uint256)
161     {
162         return _allowances[owner][spender];
163     }
164 
165     function approve(address spender, uint256 amount)
166         public
167         virtual
168         override
169         returns (bool)
170     {
171         _approve(_msgSender(), spender, amount);
172         return true;
173     }
174 
175     function transferFrom(
176         address sender,
177         address recipient,
178         uint256 amount
179     ) public virtual override returns (bool) {
180         _transfer(sender, recipient, amount);
181 
182         uint256 currentAllowance = _allowances[sender][_msgSender()];
183         require(
184             currentAllowance >= amount,
185             "ERC20: transfer amount exceeds allowance"
186         );
187         unchecked {
188             _approve(sender, _msgSender(), currentAllowance - amount);
189         }
190 
191         return true;
192     }
193 
194     function increaseAllowance(address spender, uint256 addedValue)
195         public
196         virtual
197         returns (bool)
198     {
199         _approve(
200             _msgSender(),
201             spender,
202             _allowances[_msgSender()][spender] + addedValue
203         );
204         return true;
205     }
206 
207     function decreaseAllowance(address spender, uint256 subtractedValue)
208         public
209         virtual
210         returns (bool)
211     {
212         uint256 currentAllowance = _allowances[_msgSender()][spender];
213         require(
214             currentAllowance >= subtractedValue,
215             "ERC20: decreased allowance below zero"
216         );
217         unchecked {
218             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
219         }
220 
221         return true;
222     }
223 
224     function _transfer(
225         address sender,
226         address recipient,
227         uint256 amount
228     ) internal virtual {
229         require(sender != address(0), "ERC20: transfer from the zero address");
230         require(recipient != address(0), "ERC20: transfer to the zero address");
231 
232         _beforeTokenTransfer(sender, recipient, amount);
233 
234         uint256 senderBalance = _balances[sender];
235         require(
236             senderBalance >= amount,
237             "ERC20: transfer amount exceeds balance"
238         );
239         unchecked {
240             _balances[sender] = senderBalance - amount;
241         }
242         _balances[recipient] += amount;
243 
244         emit Transfer(sender, recipient, amount);
245 
246         _afterTokenTransfer(sender, recipient, amount);
247     }
248 
249     function _mint(address account, uint256 amount) internal virtual {
250         require(account != address(0), "ERC20: mint to the zero address");
251 
252         _beforeTokenTransfer(address(0), account, amount);
253 
254         _totalSupply += amount;
255         _balances[account] += amount;
256         emit Transfer(address(0), account, amount);
257 
258         _afterTokenTransfer(address(0), account, amount);
259     }
260 
261     function _burn(address account, uint256 amount) internal virtual {
262         require(account != address(0), "ERC20: burn from the zero address");
263 
264         _beforeTokenTransfer(account, address(0), amount);
265 
266         uint256 accountBalance = _balances[account];
267         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
268         unchecked {
269             _balances[account] = accountBalance - amount;
270         }
271         _totalSupply -= amount;
272 
273         emit Transfer(account, address(0), amount);
274 
275         _afterTokenTransfer(account, address(0), amount);
276     }
277 
278     function _approve(
279         address owner,
280         address spender,
281         uint256 amount
282     ) internal virtual {
283         require(owner != address(0), "ERC20: approve from the zero address");
284         require(spender != address(0), "ERC20: approve to the zero address");
285 
286         _allowances[owner][spender] = amount;
287         emit Approval(owner, spender, amount);
288     }
289 
290     function _beforeTokenTransfer(
291         address from,
292         address to,
293         uint256 amount
294     ) internal virtual {}
295 
296     function _afterTokenTransfer(
297         address from,
298         address to,
299         uint256 amount
300     ) internal virtual {}
301 }
302 
303 library SafeMath {
304     function tryAdd(uint256 a, uint256 b)
305         internal
306         pure
307         returns (bool, uint256)
308     {
309         unchecked {
310             uint256 c = a + b;
311             if (c < a) return (false, 0);
312             return (true, c);
313         }
314     }
315 
316     function trySub(uint256 a, uint256 b)
317         internal
318         pure
319         returns (bool, uint256)
320     {
321         unchecked {
322             if (b > a) return (false, 0);
323             return (true, a - b);
324         }
325     }
326 
327     function tryMul(uint256 a, uint256 b)
328         internal
329         pure
330         returns (bool, uint256)
331     {
332         unchecked {
333             if (a == 0) return (true, 0);
334             uint256 c = a * b;
335             if (c / a != b) return (false, 0);
336             return (true, c);
337         }
338     }
339 
340     function tryDiv(uint256 a, uint256 b)
341         internal
342         pure
343         returns (bool, uint256)
344     {
345         unchecked {
346             if (b == 0) return (false, 0);
347             return (true, a / b);
348         }
349     }
350 
351     function tryMod(uint256 a, uint256 b)
352         internal
353         pure
354         returns (bool, uint256)
355     {
356         unchecked {
357             if (b == 0) return (false, 0);
358             return (true, a % b);
359         }
360     }
361 
362     function add(uint256 a, uint256 b) internal pure returns (uint256) {
363         return a + b;
364     }
365 
366     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
367         return a - b;
368     }
369 
370     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
371         return a * b;
372     }
373 
374     function div(uint256 a, uint256 b) internal pure returns (uint256) {
375         return a / b;
376     }
377 
378     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
379         return a % b;
380     }
381 
382     function sub(
383         uint256 a,
384         uint256 b,
385         string memory errorMessage
386     ) internal pure returns (uint256) {
387         unchecked {
388             require(b <= a, errorMessage);
389             return a - b;
390         }
391     }
392 
393     function div(
394         uint256 a,
395         uint256 b,
396         string memory errorMessage
397     ) internal pure returns (uint256) {
398         unchecked {
399             require(b > 0, errorMessage);
400             return a / b;
401         }
402     }
403 
404     function mod(
405         uint256 a,
406         uint256 b,
407         string memory errorMessage
408     ) internal pure returns (uint256) {
409         unchecked {
410             require(b > 0, errorMessage);
411             return a % b;
412         }
413     }
414 }
415 
416 interface IUniswapV2Factory {
417     event PairCreated(
418         address indexed token0,
419         address indexed token1,
420         address pair,
421         uint256
422     );
423 
424     function feeTo() external view returns (address);
425 
426     function feeToSetter() external view returns (address);
427 
428     function getPair(address tokenA, address tokenB)
429         external
430         view
431         returns (address pair);
432 
433     function allPairs(uint256) external view returns (address pair);
434 
435     function allPairsLength() external view returns (uint256);
436 
437     function createPair(address tokenA, address tokenB)
438         external
439         returns (address pair);
440 
441     function setFeeTo(address) external;
442 
443     function setFeeToSetter(address) external;
444 }
445 
446 interface IUniswapV2Pair {
447     event Approval(
448         address indexed owner,
449         address indexed spender,
450         uint256 value
451     );
452     event Transfer(address indexed from, address indexed to, uint256 value);
453 
454     function name() external pure returns (string memory);
455 
456     function symbol() external pure returns (string memory);
457 
458     function decimals() external pure returns (uint8);
459 
460     function totalSupply() external view returns (uint256);
461 
462     function balanceOf(address owner) external view returns (uint256);
463 
464     function allowance(address owner, address spender)
465         external
466         view
467         returns (uint256);
468 
469     function approve(address spender, uint256 value) external returns (bool);
470 
471     function transfer(address to, uint256 value) external returns (bool);
472 
473     function transferFrom(
474         address from,
475         address to,
476         uint256 value
477     ) external returns (bool);
478 
479     function DOMAIN_SEPARATOR() external view returns (bytes32);
480 
481     function PERMIT_TYPEHASH() external pure returns (bytes32);
482 
483     function nonces(address owner) external view returns (uint256);
484 
485     function permit(
486         address owner,
487         address spender,
488         uint256 value,
489         uint256 deadline,
490         uint8 v,
491         bytes32 r,
492         bytes32 s
493     ) external;
494 
495     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
496     event Burn(
497         address indexed sender,
498         uint256 amount0,
499         uint256 amount1,
500         address indexed to
501     );
502     event Swap(
503         address indexed sender,
504         uint256 amount0In,
505         uint256 amount1In,
506         uint256 amount0Out,
507         uint256 amount1Out,
508         address indexed to
509     );
510     event Sync(uint112 reserve0, uint112 reserve1);
511 
512     function MINIMUM_LIQUIDITY() external pure returns (uint256);
513 
514     function factory() external view returns (address);
515 
516     function token0() external view returns (address);
517 
518     function token1() external view returns (address);
519 
520     function getReserves()
521         external
522         view
523         returns (
524             uint112 reserve0,
525             uint112 reserve1,
526             uint32 blockTimestampLast
527         );
528 
529     function price0CumulativeLast() external view returns (uint256);
530 
531     function price1CumulativeLast() external view returns (uint256);
532 
533     function kLast() external view returns (uint256);
534 
535     function mint(address to) external returns (uint256 liquidity);
536 
537     function burn(address to)
538         external
539         returns (uint256 amount0, uint256 amount1);
540 
541     function swap(
542         uint256 amount0Out,
543         uint256 amount1Out,
544         address to,
545         bytes calldata data
546     ) external;
547 
548     function skim(address to) external;
549 
550     function sync() external;
551 
552     function initialize(address, address) external;
553 }
554 
555 interface IUniswapV2Router02 {
556     function factory() external pure returns (address);
557 
558     function WETH() external pure returns (address);
559 
560     function addLiquidity(
561         address tokenA,
562         address tokenB,
563         uint256 amountADesired,
564         uint256 amountBDesired,
565         uint256 amountAMin,
566         uint256 amountBMin,
567         address to,
568         uint256 deadline
569     )
570         external
571         returns (
572             uint256 amountA,
573             uint256 amountB,
574             uint256 liquidity
575         );
576 
577     function addLiquidityETH(
578         address token,
579         uint256 amountTokenDesired,
580         uint256 amountTokenMin,
581         uint256 amountETHMin,
582         address to,
583         uint256 deadline
584     )
585         external
586         payable
587         returns (
588             uint256 amountToken,
589             uint256 amountETH,
590             uint256 liquidity
591         );
592 
593     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
594         uint256 amountIn,
595         uint256 amountOutMin,
596         address[] calldata path,
597         address to,
598         uint256 deadline
599     ) external;
600 
601     function swapExactETHForTokensSupportingFeeOnTransferTokens(
602         uint256 amountOutMin,
603         address[] calldata path,
604         address to,
605         uint256 deadline
606     ) external payable;
607 
608     function swapExactTokensForETHSupportingFeeOnTransferTokens(
609         uint256 amountIn,
610         uint256 amountOutMin,
611         address[] calldata path,
612         address to,
613         uint256 deadline
614     ) external;
615 }
616 
617 contract Combustion is ERC20, Ownable {
618     using SafeMath for uint256;
619 
620     IUniswapV2Router02 public immutable uniswapV2Router;
621     address public immutable uniswapV2Pair;
622     address public constant deadAddress = address(0xdead);
623 
624     bool private swapping;
625 
626     address public AWallet;
627     address public BWallet;
628     address public CWallet;
629 
630     uint256 public maxTransactionAmount;
631     uint256 public swapTokensAtAmount;
632     uint256 public maxWallet;
633 
634     bool public limitsInEffect = true;
635     bool public tradingActive = false;
636 
637     uint256 public launchedAt;
638     uint256 public launchedAtTimestamp;
639     uint256 antiBot = 0 seconds;
640 
641     uint256 public buyTotalFees = 25;
642     uint256 public buyAFee = 23;
643     uint256 public buyBFee = 2;
644     uint256 public buyCFee = 0;
645     uint256 public buyLiquidityFee = 0;
646     uint256 public buyAutoBurnFee = 0;
647 
648     uint256 public sellTotalFees = 25;
649     uint256 public sellAFee = 23;
650     uint256 public sellBFee = 2;
651     uint256 public sellCFee = 0;
652     uint256 public sellLiquidityFee = 0;
653     uint256 public sellAutoBurnFee = 0;
654 
655     uint256 public tokensForA;
656     uint256 public tokensForLiquidity;
657     uint256 public tokensForB;
658     uint256 public tokensForC;
659     uint256 public tokensForAutoburn;
660 
661     mapping(address => bool) private _isExcludedFromFees;
662     mapping(address => bool) public _isExcludedMaxTransactionAmount;
663     mapping(address => bool) public isBot;
664 
665     mapping(address => bool) public automatedMarketMakerPairs;
666 
667     event UpdateUniswapV2Router(
668         address indexed newAddress,
669         address indexed oldAddress
670     );
671 
672     event ExcludeFromFees(address indexed account, bool isExcluded);
673 
674     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
675 
676     event AWalletUpdated(
677         address indexed newWallet,
678         address indexed oldWallet
679     );
680 
681     event BWalletUpdated(
682         address indexed newWallet,
683         address indexed oldWallet
684     );
685 
686     event CWalletUpdated(
687         address indexed newWallet,
688         address indexed oldWallet
689     );
690     event SwapAndLiquify(
691         uint256 tokensSwapped,
692         uint256 ethReceived,
693         uint256 tokensIntoLiquidity
694     );
695 
696     constructor(
697 
698     ) ERC20("Combustion", "FIRE") {
699         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
700             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
701         );
702 
703         excludeFromMaxTransaction(address(_uniswapV2Router), true);
704         uniswapV2Router = _uniswapV2Router;
705 
706         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
707             .createPair(address(this), _uniswapV2Router.WETH());
708         excludeFromMaxTransaction(address(uniswapV2Pair), true);
709         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
710 
711         uint256 totalSupply = 1_000_000_000 * 1e18;
712 
713         maxTransactionAmount = 20000000 * 1e18;
714         maxWallet = 20000000 * 1e18;
715         swapTokensAtAmount = 3500000 * 1e18;
716 
717         AWallet = address(0x5B172cb3509c21997839AEB2b1B647a7535F86dd); 
718         BWallet = address(0x04c0287f193F72AB826620A567A3299Fd9b66902);
719         CWallet = address(0x04c0287f193F72AB826620A567A3299Fd9b66902);
720         excludeFromFees(owner(), true);
721         excludeFromFees(address(this), true);
722         excludeFromFees(address(0xdead), true);
723 
724         excludeFromMaxTransaction(owner(), true);
725         excludeFromMaxTransaction(address(this), true);
726         excludeFromMaxTransaction(address(0xdead), true);
727 
728         _mint(owner(), totalSupply);
729     }
730 
731     receive() external payable {}
732 
733     function launched() internal view returns (bool) {
734         return launchedAt != 0;
735     }
736 
737     function launch() public onlyOwner {
738         require(launchedAt == 0, "Already launched");
739         launchedAt = block.number;
740         launchedAtTimestamp = block.timestamp;
741         tradingActive = true;
742     }
743 
744     function removeLimits() external onlyOwner returns (bool) {
745         limitsInEffect = false;
746         return true;
747     }
748 
749     function excludeFromMaxTransaction(address updAds, bool isEx)
750         public
751         onlyOwner
752     {
753         _isExcludedMaxTransactionAmount[updAds] = isEx;
754     }
755 
756     function updateBuyFees(
757         uint256 _AFee,
758         uint256 _BFee,
759         uint256 _CFee,
760         uint256 _liquidityFee,
761         uint256 _autoBurnFee
762     ) external onlyOwner {
763         buyAFee = _AFee;
764         buyBFee = _BFee;
765         buyCFee = _CFee;
766         buyLiquidityFee = _liquidityFee;
767         buyAutoBurnFee = _autoBurnFee;
768         buyTotalFees =
769             buyAFee +
770             buyBFee +
771             buyCFee +
772             buyLiquidityFee +
773             buyAutoBurnFee;
774     }
775 
776     function updateSellFees(
777         uint256 _AFee,
778         uint256 _BFee,
779         uint256 _CFee,
780         uint256 _liquidityFee,
781         uint256 _autoBurnFee
782     ) external onlyOwner {
783         sellAFee = _AFee;
784         sellBFee = _BFee;
785         sellCFee = _CFee;
786         sellLiquidityFee = _liquidityFee;
787         sellAutoBurnFee = _autoBurnFee;
788         sellTotalFees =
789             sellAFee +
790             sellBFee +
791             sellCFee +
792             sellLiquidityFee +
793             sellAutoBurnFee;
794     }
795 
796     function excludeFromFees(address account, bool excluded) public onlyOwner {
797         _isExcludedFromFees[account] = excluded;
798         emit ExcludeFromFees(account, excluded);
799     }
800 
801     function setAutomatedMarketMakerPair(address pair, bool value)
802         public
803         onlyOwner
804     {
805         require(
806             pair != uniswapV2Pair,
807             "The pair cannot be removed from automatedMarketMakerPairs"
808         );
809 
810         _setAutomatedMarketMakerPair(pair, value);
811     }
812 
813     function _setAutomatedMarketMakerPair(address pair, bool value) private {
814         automatedMarketMakerPairs[pair] = value;
815 
816         emit SetAutomatedMarketMakerPair(pair, value);
817     }
818 
819     function updateAWallet(address newAWallet) external onlyOwner {
820         emit AWalletUpdated(newAWallet, AWallet);
821         AWallet = newAWallet;
822     }
823 
824     function updateBWallet(address newBWallet) external onlyOwner {
825         emit BWalletUpdated(newBWallet, BWallet);
826         BWallet = newBWallet;
827     }
828 
829     function updateCWallet(address newWallet) external onlyOwner {
830         emit CWalletUpdated(newWallet, CWallet);
831         CWallet = newWallet;
832     }
833 
834     function isExcludedFromFees(address account) public view returns (bool) {
835         return _isExcludedFromFees[account];
836     }
837 
838     function addBotInList(address _account) external onlyOwner {
839         require(
840             _account != address(uniswapV2Router),
841             "Can not blacklist router"
842         );
843         require(!isBot[_account], "Bot already added");
844         isBot[_account] = true;
845     }
846 
847     function removeBotFromList(address _account) external onlyOwner {
848         require(isBot[_account], "Bot not found");
849         isBot[_account] = false;
850     }
851 
852     function _transfer(
853         address from,
854         address to,
855         uint256 amount
856     ) internal override {
857         require(from != address(0), "ERC20: transfer from the zero address");
858         require(to != address(0), "ERC20: transfer to the zero address");
859         require(!isBot[to], "Bot detected");
860         require(!isBot[from], "Bot detected");
861 
862         if (amount == 0) {
863             super._transfer(from, to, 0);
864             return;
865         }
866 
867         if (limitsInEffect) {
868             if (
869                 from != owner() &&
870                 to != owner() &&
871                 to != address(0) &&
872                 to != address(0xdead) &&
873                 !swapping
874             ) {
875                 if (!tradingActive) {
876                     require(
877                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
878                         "Trading is not active."
879                     );
880                 }
881                 if (
882                     block.timestamp < launchedAtTimestamp + antiBot &&
883                     from != address(uniswapV2Router)
884                 ) {
885                     if (from == uniswapV2Pair) {
886                         isBot[to] = true;
887                     } else if (to == uniswapV2Pair) {
888                         isBot[from] = true;
889                     }
890                 }
891                 if (
892                     automatedMarketMakerPairs[from] &&
893                     !_isExcludedMaxTransactionAmount[to]
894                 ) {
895                     require(
896                         amount <= maxTransactionAmount,
897                         "Buy transfer amount exceeds the maxTransactionAmount."
898                     );
899                     require(
900                         amount + balanceOf(to) <= maxWallet,
901                         "Max wallet exceeded"
902                     );
903                 }
904                 else if (
905                     automatedMarketMakerPairs[to] &&
906                     !_isExcludedMaxTransactionAmount[from]
907                 ) {
908                     require(
909                         amount <= maxTransactionAmount,
910                         "Sell transfer amount exceeds the maxTransactionAmount."
911                     );
912                 } else if (!_isExcludedMaxTransactionAmount[to]) {
913                     require(
914                         amount + balanceOf(to) <= maxWallet,
915                         "Max wallet exceeded"
916                     );
917                 }
918             }
919         }
920 
921         uint256 contractTokenBalance = balanceOf(address(this));
922 
923         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
924 
925         if (
926             canSwap &&
927             !swapping &&
928             !automatedMarketMakerPairs[from] &&
929             !_isExcludedFromFees[from] &&
930             !_isExcludedFromFees[to]
931         ) {
932             swapping = true;
933 
934             swapBack();
935 
936             swapping = false;
937         }
938 
939         bool takeFee = !swapping;
940 
941         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
942             takeFee = false;
943         }
944 
945         uint256 fees = 0;
946         if (takeFee) {
947             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
948                 fees = amount.mul(sellTotalFees).div(100);
949                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
950                 tokensForB += (fees * sellCFee) / sellTotalFees;
951                 tokensForA += (fees * sellAFee) / sellTotalFees;
952                 tokensForC += (fees * sellCFee) / sellTotalFees;
953                 tokensForAutoburn = (fees * sellAutoBurnFee) / sellTotalFees;
954             }
955             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
956                 fees = amount.mul(buyTotalFees).div(100);
957                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
958                 tokensForB += (fees * buyCFee) / buyTotalFees;
959                 tokensForA += (fees * buyAFee) / buyTotalFees;
960                 tokensForC += (fees * buyCFee) / buyTotalFees;
961                 tokensForAutoburn = (fees * buyAutoBurnFee) / buyTotalFees;
962             }
963 
964             if (fees > 0) {
965                 _burn(from, tokensForAutoburn);
966                 super._transfer(from, address(this), fees - tokensForAutoburn);
967             }
968 
969             amount -= fees;
970         }
971 
972         super._transfer(from, to, amount);
973     }
974 
975     function swapTokensForEth(uint256 tokenAmount) private {
976         address[] memory path = new address[](2);
977         path[0] = address(this);
978         path[1] = uniswapV2Router.WETH();
979 
980         _approve(address(this), address(uniswapV2Router), tokenAmount);
981 
982         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
983             tokenAmount,
984             0,
985             path,
986             address(this),
987             block.timestamp
988         );
989     }
990 
991     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
992         _approve(address(this), address(uniswapV2Router), tokenAmount);
993 
994         uniswapV2Router.addLiquidityETH{value: ethAmount}(
995             address(this),
996             tokenAmount,
997             0, 
998             0, 
999             deadAddress,
1000             block.timestamp
1001         );
1002     }
1003 
1004     function swapBack() private {
1005         uint256 contractBalance = balanceOf(address(this));
1006         uint256 totalTokensToSwap = tokensForLiquidity +
1007             tokensForA +
1008             tokensForB +
1009             tokensForC;
1010         bool success;
1011 
1012         if (contractBalance == 0 || totalTokensToSwap == 0) {
1013             return;
1014         }
1015 
1016         if (contractBalance > swapTokensAtAmount) {
1017             contractBalance = swapTokensAtAmount;
1018         }
1019 
1020         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1021             totalTokensToSwap /
1022             2;
1023         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1024 
1025         uint256 initialETHBalance = address(this).balance;
1026 
1027         swapTokensForEth(amountToSwapForETH);
1028 
1029         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1030 
1031         uint256 ethForA = ethBalance.mul(tokensForA).div(
1032             totalTokensToSwap
1033         );
1034         uint256 ethForB = ethBalance.mul(tokensForB).div(
1035             totalTokensToSwap
1036         );
1037         uint256 ethForC = ethBalance.mul(tokensForC).div(
1038             totalTokensToSwap
1039         );
1040         uint256 ethForLiquidity = ethBalance -
1041             ethForA -
1042             ethForB -
1043             ethForC;
1044 
1045         tokensForLiquidity = 0;
1046         tokensForA = 0;
1047         tokensForB = 0;
1048         tokensForC = 0;
1049 
1050         (success, ) = address(BWallet).call{value: ethForB}("");
1051 
1052         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1053             addLiquidity(liquidityTokens, ethForLiquidity);
1054             emit SwapAndLiquify(
1055                 amountToSwapForETH,
1056                 ethForLiquidity,
1057                 tokensForLiquidity
1058             );
1059         }
1060 
1061         (success, ) = address(AWallet).call{value: ethForA}("");
1062         (success, ) = address(CWallet).call{
1063             value: address(this).balance
1064         }("");
1065     }
1066 
1067     function withdrawETH(uint256 _amount) external onlyOwner {
1068         require(address(this).balance >= _amount, "Invalid Amount");
1069         payable(msg.sender).transfer(_amount);
1070     }
1071 }