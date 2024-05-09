1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.18;
3 pragma experimental ABIEncoderV2;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 contract Ownable is Context {
16     address private _owner;
17 
18     event OwnershipTransferred(
19         address indexed previousOwner,
20         address indexed newOwner
21     );
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
36     function renounceOwnership() public virtual onlyOwner {
37         _transferOwnership(address(0));
38     }
39 
40     function transferOwnership(address newOwner) public virtual onlyOwner {
41         require(
42             newOwner != address(0),
43             "Ownable: new owner is the zero address"
44         );
45         _transferOwnership(newOwner);
46     }
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
61     function transfer(address recipient, uint256 amount)
62         external
63         returns (bool);
64 
65     function allowance(address owner, address spender)
66         external
67         view
68         returns (uint256);
69 
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     function transferFrom(
73         address sender,
74         address recipient,
75         uint256 amount
76     ) external returns (bool);
77 
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     event Approval(
81         address indexed owner,
82         address indexed spender,
83         uint256 value
84     );
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
106     constructor(string memory name_, string memory symbol_) {
107         _name = name_;
108         _symbol = symbol_;
109     }
110 
111     function name() public view virtual override returns (string memory) {
112         return _name;
113     }
114 
115     function symbol() public view virtual override returns (string memory) {
116         return _symbol;
117     }
118 
119     function decimals() public view virtual override returns (uint8) {
120         return 18;
121     }
122 
123     function totalSupply() public view virtual override returns (uint256) {
124         return _totalSupply;
125     }
126 
127     function balanceOf(address account)
128         public
129         view
130         virtual
131         override
132         returns (uint256)
133     {
134         return _balances[account];
135     }
136 
137     function transfer(address recipient, uint256 amount)
138         public
139         virtual
140         override
141         returns (bool)
142     {
143         _transfer(_msgSender(), recipient, amount);
144         return true;
145     }
146 
147     function allowance(address owner, address spender)
148         public
149         view
150         virtual
151         override
152         returns (uint256)
153     {
154         return _allowances[owner][spender];
155     }
156 
157     function approve(address spender, uint256 amount)
158         public
159         virtual
160         override
161         returns (bool)
162     {
163         _approve(_msgSender(), spender, amount);
164         return true;
165     }
166 
167     function transferFrom(
168         address sender,
169         address recipient,
170         uint256 amount
171     ) public virtual override returns (bool) {
172         _transfer(sender, recipient, amount);
173 
174         uint256 currentAllowance = _allowances[sender][_msgSender()];
175         require(
176             currentAllowance >= amount,
177             "ERC20: transfer amount exceeds allowance"
178         );
179         unchecked {
180             _approve(sender, _msgSender(), currentAllowance - amount);
181         }
182 
183         return true;
184     }
185 
186     function increaseAllowance(address spender, uint256 addedValue)
187         public
188         virtual
189         returns (bool)
190     {
191         _approve(
192             _msgSender(),
193             spender,
194             _allowances[_msgSender()][spender] + addedValue
195         );
196         return true;
197     }
198 
199     function decreaseAllowance(address spender, uint256 subtractedValue)
200         public
201         virtual
202         returns (bool)
203     {
204         uint256 currentAllowance = _allowances[_msgSender()][spender];
205         require(
206             currentAllowance >= subtractedValue,
207             "ERC20: decreased allowance below zero"
208         );
209         unchecked {
210             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
211         }
212 
213         return true;
214     }
215 
216     function _transfer(
217         address sender,
218         address recipient,
219         uint256 amount
220     ) internal virtual {
221         require(sender != address(0), "ERC20: transfer from the zero address");
222         require(recipient != address(0), "ERC20: transfer to the zero address");
223 
224         _beforeTokenTransfer(sender, recipient, amount);
225 
226         uint256 senderBalance = _balances[sender];
227         require(
228             senderBalance >= amount,
229             "ERC20: transfer amount exceeds balance"
230         );
231         unchecked {
232             _balances[sender] = senderBalance - amount;
233         }
234         _balances[recipient] += amount;
235 
236         emit Transfer(sender, recipient, amount);
237 
238         _afterTokenTransfer(sender, recipient, amount);
239     }
240 
241     function _mint(address account, uint256 amount) internal virtual {
242         require(account != address(0), "ERC20: mint to the zero address");
243 
244         _beforeTokenTransfer(address(0), account, amount);
245 
246         _totalSupply += amount;
247         _balances[account] += amount;
248         emit Transfer(address(0), account, amount);
249 
250         _afterTokenTransfer(address(0), account, amount);
251     }
252 
253     function _burn(address account, uint256 amount) internal virtual {
254         require(account != address(0), "ERC20: burn from the zero address");
255 
256         _beforeTokenTransfer(account, address(0), amount);
257 
258         uint256 accountBalance = _balances[account];
259         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
260         unchecked {
261             _balances[account] = accountBalance - amount;
262         }
263         _totalSupply -= amount;
264 
265         emit Transfer(account, address(0), amount);
266 
267         _afterTokenTransfer(account, address(0), amount);
268     }
269 
270     function _approve(
271         address owner,
272         address spender,
273         uint256 amount
274     ) internal virtual {
275         require(owner != address(0), "ERC20: approve from the zero address");
276         require(spender != address(0), "ERC20: approve to the zero address");
277 
278         _allowances[owner][spender] = amount;
279         emit Approval(owner, spender, amount);
280     }
281 
282     function _beforeTokenTransfer(
283         address from,
284         address to,
285         uint256 amount
286     ) internal virtual {}
287 
288     function _afterTokenTransfer(
289         address from,
290         address to,
291         uint256 amount
292     ) internal virtual {}
293 }
294 
295 library SafeMath {
296     function tryAdd(uint256 a, uint256 b)
297         internal
298         pure
299         returns (bool, uint256)
300     {
301         unchecked {
302             uint256 c = a + b;
303             if (c < a) return (false, 0);
304             return (true, c);
305         }
306     }
307 
308     function trySub(uint256 a, uint256 b)
309         internal
310         pure
311         returns (bool, uint256)
312     {
313         unchecked {
314             if (b > a) return (false, 0);
315             return (true, a - b);
316         }
317     }
318 
319     function tryMul(uint256 a, uint256 b)
320         internal
321         pure
322         returns (bool, uint256)
323     {
324         unchecked {
325             if (a == 0) return (true, 0);
326             uint256 c = a * b;
327             if (c / a != b) return (false, 0);
328             return (true, c);
329         }
330     }
331 
332     function tryDiv(uint256 a, uint256 b)
333         internal
334         pure
335         returns (bool, uint256)
336     {
337         unchecked {
338             if (b == 0) return (false, 0);
339             return (true, a / b);
340         }
341     }
342 
343     function tryMod(uint256 a, uint256 b)
344         internal
345         pure
346         returns (bool, uint256)
347     {
348         unchecked {
349             if (b == 0) return (false, 0);
350             return (true, a % b);
351         }
352     }
353 
354     function add(uint256 a, uint256 b) internal pure returns (uint256) {
355         return a + b;
356     }
357 
358     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
359         return a - b;
360     }
361 
362     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
363         return a * b;
364     }
365 
366     function div(uint256 a, uint256 b) internal pure returns (uint256) {
367         return a / b;
368     }
369 
370     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
371         return a % b;
372     }
373 
374     function sub(
375         uint256 a,
376         uint256 b,
377         string memory errorMessage
378     ) internal pure returns (uint256) {
379         unchecked {
380             require(b <= a, errorMessage);
381             return a - b;
382         }
383     }
384 
385     function div(
386         uint256 a,
387         uint256 b,
388         string memory errorMessage
389     ) internal pure returns (uint256) {
390         unchecked {
391             require(b > 0, errorMessage);
392             return a / b;
393         }
394     }
395 
396     function mod(
397         uint256 a,
398         uint256 b,
399         string memory errorMessage
400     ) internal pure returns (uint256) {
401         unchecked {
402             require(b > 0, errorMessage);
403             return a % b;
404         }
405     }
406 }
407 
408 interface IUniswapV2Factory {
409     event PairCreated(
410         address indexed token0,
411         address indexed token1,
412         address pair,
413         uint256
414     );
415 
416     function feeTo() external view returns (address);
417 
418     function feeToSetter() external view returns (address);
419 
420     function getPair(address tokenA, address tokenB)
421         external
422         view
423         returns (address pair);
424 
425     function allPairs(uint256) external view returns (address pair);
426 
427     function allPairsLength() external view returns (uint256);
428 
429     function createPair(address tokenA, address tokenB)
430         external
431         returns (address pair);
432 
433     function setFeeTo(address) external;
434 
435     function setFeeToSetter(address) external;
436 }
437 
438 interface IUniswapV2Pair {
439     event Approval(
440         address indexed owner,
441         address indexed spender,
442         uint256 value
443     );
444     event Transfer(address indexed from, address indexed to, uint256 value);
445 
446     function name() external pure returns (string memory);
447 
448     function symbol() external pure returns (string memory);
449 
450     function decimals() external pure returns (uint8);
451 
452     function totalSupply() external view returns (uint256);
453 
454     function balanceOf(address owner) external view returns (uint256);
455 
456     function allowance(address owner, address spender)
457         external
458         view
459         returns (uint256);
460 
461     function approve(address spender, uint256 value) external returns (bool);
462 
463     function transfer(address to, uint256 value) external returns (bool);
464 
465     function transferFrom(
466         address from,
467         address to,
468         uint256 value
469     ) external returns (bool);
470 
471     function DOMAIN_SEPARATOR() external view returns (bytes32);
472 
473     function PERMIT_TYPEHASH() external pure returns (bytes32);
474 
475     function nonces(address owner) external view returns (uint256);
476 
477     function permit(
478         address owner,
479         address spender,
480         uint256 value,
481         uint256 deadline,
482         uint8 v,
483         bytes32 r,
484         bytes32 s
485     ) external;
486 
487     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
488     event Burn(
489         address indexed sender,
490         uint256 amount0,
491         uint256 amount1,
492         address indexed to
493     );
494     event Swap(
495         address indexed sender,
496         uint256 amount0In,
497         uint256 amount1In,
498         uint256 amount0Out,
499         uint256 amount1Out,
500         address indexed to
501     );
502     event Sync(uint112 reserve0, uint112 reserve1);
503 
504     function MINIMUM_LIQUIDITY() external pure returns (uint256);
505 
506     function factory() external view returns (address);
507 
508     function token0() external view returns (address);
509 
510     function token1() external view returns (address);
511 
512     function getReserves()
513         external
514         view
515         returns (
516             uint112 reserve0,
517             uint112 reserve1,
518             uint32 blockTimestampLast
519         );
520 
521     function price0CumulativeLast() external view returns (uint256);
522 
523     function price1CumulativeLast() external view returns (uint256);
524 
525     function kLast() external view returns (uint256);
526 
527     function mint(address to) external returns (uint256 liquidity);
528 
529     function burn(address to)
530         external
531         returns (uint256 amount0, uint256 amount1);
532 
533     function swap(
534         uint256 amount0Out,
535         uint256 amount1Out,
536         address to,
537         bytes calldata data
538     ) external;
539 
540     function skim(address to) external;
541 
542     function sync() external;
543 
544     function initialize(address, address) external;
545 }
546 
547 interface IUniswapV2Router02 {
548     function factory() external pure returns (address);
549 
550     function WETH() external pure returns (address);
551 
552     function addLiquidity(
553         address tokenA,
554         address tokenB,
555         uint256 amountADesired,
556         uint256 amountBDesired,
557         uint256 amountAMin,
558         uint256 amountBMin,
559         address to,
560         uint256 deadline
561     )
562         external
563         returns (
564             uint256 amountA,
565             uint256 amountB,
566             uint256 liquidity
567         );
568 
569     function addLiquidityETH(
570         address token,
571         uint256 amountTokenDesired,
572         uint256 amountTokenMin,
573         uint256 amountETHMin,
574         address to,
575         uint256 deadline
576     )
577         external
578         payable
579         returns (
580             uint256 amountToken,
581             uint256 amountETH,
582             uint256 liquidity
583         );
584 
585     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
586         uint256 amountIn,
587         uint256 amountOutMin,
588         address[] calldata path,
589         address to,
590         uint256 deadline
591     ) external;
592 
593     function swapExactETHForTokensSupportingFeeOnTransferTokens(
594         uint256 amountOutMin,
595         address[] calldata path,
596         address to,
597         uint256 deadline
598     ) external payable;
599 
600     function swapExactTokensForETHSupportingFeeOnTransferTokens(
601         uint256 amountIn,
602         uint256 amountOutMin,
603         address[] calldata path,
604         address to,
605         uint256 deadline
606     ) external;
607 }
608 
609 contract CommunityNotes is ERC20, Ownable {
610     using SafeMath for uint256;
611 
612     IUniswapV2Router02 public immutable uniswapV2Router;
613     address public immutable uniswapV2Pair;
614     address public constant deadAddress = address(0xdead);
615 
616     bool private swapping;
617 
618     address public AWallet;
619     address public BWallet;
620     address public CWallet;
621 
622     uint256 public maxTransactionAmount;
623     uint256 public swapTokensAtAmount;
624     uint256 public maxWallet;
625 
626     bool public limitsInEffect = true;
627     bool public tradingActive = false;
628 
629     uint256 public launchedAt;
630     uint256 public launchedAtTimestamp;
631     uint256 antiBot = 3 seconds;
632 
633     uint256 public buyTotalFees = 8;
634     uint256 public buyAFee = 8;
635     uint256 public buyBFee = 0;
636     uint256 public buyCFee = 0;
637     uint256 public buyLiquidityFee = 0;
638     uint256 public buyAutoBurnFee = 0;
639 
640     uint256 public sellTotalFees = 60;
641     uint256 public sellAFee = 30;
642     uint256 public sellBFee = 0;
643     uint256 public sellCFee = 0;
644     uint256 public sellLiquidityFee = 30;
645     uint256 public sellAutoBurnFee = 0;
646 
647     uint256 public tokensForA;
648     uint256 public tokensForLiquidity;
649     uint256 public tokensForB;
650     uint256 public tokensForC;
651     uint256 public tokensForAutoburn;
652 
653     mapping(address => bool) private _isExcludedFromFees;
654     mapping(address => bool) public _isExcludedMaxTransactionAmount;
655     mapping(address => bool) public isBot;
656 
657     mapping(address => bool) public automatedMarketMakerPairs;
658 
659     event UpdateUniswapV2Router(
660         address indexed newAddress,
661         address indexed oldAddress
662     );
663 
664     event ExcludeFromFees(address indexed account, bool isExcluded);
665 
666     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
667 
668     event AWalletUpdated(
669         address indexed newWallet,
670         address indexed oldWallet
671     );
672 
673     event BWalletUpdated(
674         address indexed newWallet,
675         address indexed oldWallet
676     );
677 
678     event CWalletUpdated(
679         address indexed newWallet,
680         address indexed oldWallet
681     );
682     event SwapAndLiquify(
683         uint256 tokensSwapped,
684         uint256 ethReceived,
685         uint256 tokensIntoLiquidity
686     );
687 
688     constructor(
689 
690     ) ERC20("Community Notes", "cNotes") {
691         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
692             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
693         );
694 
695         excludeFromMaxTransaction(address(_uniswapV2Router), true);
696         uniswapV2Router = _uniswapV2Router;
697 
698         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
699             .createPair(address(this), _uniswapV2Router.WETH());
700         excludeFromMaxTransaction(address(uniswapV2Pair), true);
701         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
702 
703         uint256 totalSupply = 1_000_000 * 1e18;
704 
705         maxTransactionAmount = 20000 * 1e18;
706         maxWallet = 20000 * 1e18;
707         swapTokensAtAmount = 3000 * 1e18;
708 
709         AWallet = address(0x2373f8165b2242D54EC91ce4Ed8F0c651f32Cd2E); 
710         BWallet = address(0x2373f8165b2242D54EC91ce4Ed8F0c651f32Cd2E);
711         CWallet = address(0x2373f8165b2242D54EC91ce4Ed8F0c651f32Cd2E);
712         excludeFromFees(owner(), true);
713         excludeFromFees(address(this), true);
714         excludeFromFees(address(0xdead), true);
715 
716         excludeFromMaxTransaction(owner(), true);
717         excludeFromMaxTransaction(address(this), true);
718         excludeFromMaxTransaction(address(0xdead), true);
719 
720         _mint(owner(), totalSupply);
721     }
722 
723     receive() external payable {}
724 
725     function launched() internal view returns (bool) {
726         return launchedAt != 0;
727     }
728 
729     function launch() public onlyOwner {
730         require(launchedAt == 0, "Already launched");
731         launchedAt = block.number;
732         launchedAtTimestamp = block.timestamp;
733         tradingActive = true;
734     }
735 
736     function removeLimits() external onlyOwner returns (bool) {
737         limitsInEffect = false;
738         return true;
739     }
740 
741     function excludeFromMaxTransaction(address updAds, bool isEx)
742         public
743         onlyOwner
744     {
745         _isExcludedMaxTransactionAmount[updAds] = isEx;
746     }
747 
748     function updateBuyFees(
749         uint256 _AFee,
750         uint256 _BFee,
751         uint256 _CFee,
752         uint256 _liquidityFee,
753         uint256 _autoBurnFee
754     ) external onlyOwner {
755         buyAFee = _AFee;
756         buyBFee = _BFee;
757         buyCFee = _CFee;
758         buyLiquidityFee = _liquidityFee;
759         buyAutoBurnFee = _autoBurnFee;
760         buyTotalFees =
761             buyAFee +
762             buyBFee +
763             buyCFee +
764             buyLiquidityFee +
765             buyAutoBurnFee;
766     }
767 
768     function updateSellFees(
769         uint256 _AFee,
770         uint256 _BFee,
771         uint256 _CFee,
772         uint256 _liquidityFee,
773         uint256 _autoBurnFee
774     ) external onlyOwner {
775         sellAFee = _AFee;
776         sellBFee = _BFee;
777         sellCFee = _CFee;
778         sellLiquidityFee = _liquidityFee;
779         sellAutoBurnFee = _autoBurnFee;
780         sellTotalFees =
781             sellAFee +
782             sellBFee +
783             sellCFee +
784             sellLiquidityFee +
785             sellAutoBurnFee;
786     }
787 
788     function excludeFromFees(address account, bool excluded) public onlyOwner {
789         _isExcludedFromFees[account] = excluded;
790         emit ExcludeFromFees(account, excluded);
791     }
792 
793     function setAutomatedMarketMakerPair(address pair, bool value)
794         public
795         onlyOwner
796     {
797         require(
798             pair != uniswapV2Pair,
799             "The pair cannot be removed from automatedMarketMakerPairs"
800         );
801 
802         _setAutomatedMarketMakerPair(pair, value);
803     }
804 
805     function _setAutomatedMarketMakerPair(address pair, bool value) private {
806         automatedMarketMakerPairs[pair] = value;
807 
808         emit SetAutomatedMarketMakerPair(pair, value);
809     }
810 
811     function updateAWallet(address newAWallet) external onlyOwner {
812         emit AWalletUpdated(newAWallet, AWallet);
813         AWallet = newAWallet;
814     }
815 
816     function updateBWallet(address newBWallet) external onlyOwner {
817         emit BWalletUpdated(newBWallet, BWallet);
818         BWallet = newBWallet;
819     }
820 
821     function updateCWallet(address newWallet) external onlyOwner {
822         emit CWalletUpdated(newWallet, CWallet);
823         CWallet = newWallet;
824     }
825 
826     function isExcludedFromFees(address account) public view returns (bool) {
827         return _isExcludedFromFees[account];
828     }
829 
830     function addBotInList(address _account) external onlyOwner {
831         require(
832             _account != address(uniswapV2Router),
833             "Can not blacklist router"
834         );
835         require(!isBot[_account], "Bot already added");
836         isBot[_account] = true;
837     }
838 
839     function removeBotFromList(address _account) external onlyOwner {
840         require(isBot[_account], "Bot not found");
841         isBot[_account] = false;
842     }
843 
844     function _transfer(
845         address from,
846         address to,
847         uint256 amount
848     ) internal override {
849         require(from != address(0), "ERC20: transfer from the zero address");
850         require(to != address(0), "ERC20: transfer to the zero address");
851         require(!isBot[to], "Bot detected");
852         require(!isBot[from], "Bot detected");
853 
854         if (amount == 0) {
855             super._transfer(from, to, 0);
856             return;
857         }
858 
859         if (limitsInEffect) {
860             if (
861                 from != owner() &&
862                 to != owner() &&
863                 to != address(0) &&
864                 to != address(0xdead) &&
865                 !swapping
866             ) {
867                 if (!tradingActive) {
868                     require(
869                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
870                         "Trading is not active."
871                     );
872                 }
873                 if (
874                     block.timestamp < launchedAtTimestamp + antiBot &&
875                     from != address(uniswapV2Router)
876                 ) {
877                     if (from == uniswapV2Pair) {
878                         isBot[to] = true;
879                     } else if (to == uniswapV2Pair) {
880                         isBot[from] = true;
881                     }
882                 }
883                 if (
884                     automatedMarketMakerPairs[from] &&
885                     !_isExcludedMaxTransactionAmount[to]
886                 ) {
887                     require(
888                         amount <= maxTransactionAmount,
889                         "Buy transfer amount exceeds the maxTransactionAmount."
890                     );
891                     require(
892                         amount + balanceOf(to) <= maxWallet,
893                         "Max wallet exceeded"
894                     );
895                 }
896                 else if (
897                     automatedMarketMakerPairs[to] &&
898                     !_isExcludedMaxTransactionAmount[from]
899                 ) {
900                     require(
901                         amount <= maxTransactionAmount,
902                         "Sell transfer amount exceeds the maxTransactionAmount."
903                     );
904                 } else if (!_isExcludedMaxTransactionAmount[to]) {
905                     require(
906                         amount + balanceOf(to) <= maxWallet,
907                         "Max wallet exceeded"
908                     );
909                 }
910             }
911         }
912 
913         uint256 contractTokenBalance = balanceOf(address(this));
914 
915         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
916 
917         if (
918             canSwap &&
919             !swapping &&
920             !automatedMarketMakerPairs[from] &&
921             !_isExcludedFromFees[from] &&
922             !_isExcludedFromFees[to]
923         ) {
924             swapping = true;
925 
926             swapBack();
927 
928             swapping = false;
929         }
930 
931         bool takeFee = !swapping;
932 
933         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
934             takeFee = false;
935         }
936 
937         uint256 fees = 0;
938         if (takeFee) {
939             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
940                 fees = amount.mul(sellTotalFees).div(100);
941                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
942                 tokensForB += (fees * sellCFee) / sellTotalFees;
943                 tokensForA += (fees * sellAFee) / sellTotalFees;
944                 tokensForC += (fees * sellCFee) / sellTotalFees;
945                 tokensForAutoburn = (fees * sellAutoBurnFee) / sellTotalFees;
946             }
947             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
948                 fees = amount.mul(buyTotalFees).div(100);
949                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
950                 tokensForB += (fees * buyCFee) / buyTotalFees;
951                 tokensForA += (fees * buyAFee) / buyTotalFees;
952                 tokensForC += (fees * buyCFee) / buyTotalFees;
953                 tokensForAutoburn = (fees * buyAutoBurnFee) / buyTotalFees;
954             }
955 
956             if (fees > 0) {
957                 _burn(from, tokensForAutoburn);
958                 super._transfer(from, address(this), fees - tokensForAutoburn);
959             }
960 
961             amount -= fees;
962         }
963 
964         super._transfer(from, to, amount);
965     }
966 
967     function swapTokensForEth(uint256 tokenAmount) private {
968         address[] memory path = new address[](2);
969         path[0] = address(this);
970         path[1] = uniswapV2Router.WETH();
971 
972         _approve(address(this), address(uniswapV2Router), tokenAmount);
973 
974         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
975             tokenAmount,
976             0,
977             path,
978             address(this),
979             block.timestamp
980         );
981     }
982 
983     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
984         _approve(address(this), address(uniswapV2Router), tokenAmount);
985 
986         uniswapV2Router.addLiquidityETH{value: ethAmount}(
987             address(this),
988             tokenAmount,
989             0, 
990             0, 
991             deadAddress,
992             block.timestamp
993         );
994     }
995 
996     function swapBack() private {
997         uint256 contractBalance = balanceOf(address(this));
998         uint256 totalTokensToSwap = tokensForLiquidity +
999             tokensForA +
1000             tokensForB +
1001             tokensForC;
1002         bool success;
1003 
1004         if (contractBalance == 0 || totalTokensToSwap == 0) {
1005             return;
1006         }
1007 
1008         if (contractBalance > swapTokensAtAmount) {
1009             contractBalance = swapTokensAtAmount;
1010         }
1011 
1012         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1013             totalTokensToSwap /
1014             2;
1015         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1016 
1017         uint256 initialETHBalance = address(this).balance;
1018 
1019         swapTokensForEth(amountToSwapForETH);
1020 
1021         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1022 
1023         uint256 ethForA = ethBalance.mul(tokensForA).div(
1024             totalTokensToSwap
1025         );
1026         uint256 ethForB = ethBalance.mul(tokensForB).div(
1027             totalTokensToSwap
1028         );
1029         uint256 ethForC = ethBalance.mul(tokensForC).div(
1030             totalTokensToSwap
1031         );
1032         uint256 ethForLiquidity = ethBalance -
1033             ethForA -
1034             ethForB -
1035             ethForC;
1036 
1037         tokensForLiquidity = 0;
1038         tokensForA = 0;
1039         tokensForB = 0;
1040         tokensForC = 0;
1041 
1042         (success, ) = address(BWallet).call{value: ethForB}("");
1043 
1044         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1045             addLiquidity(liquidityTokens, ethForLiquidity);
1046             emit SwapAndLiquify(
1047                 amountToSwapForETH,
1048                 ethForLiquidity,
1049                 tokensForLiquidity
1050             );
1051         }
1052 
1053         (success, ) = address(AWallet).call{value: ethForA}("");
1054         (success, ) = address(CWallet).call{
1055             value: address(this).balance
1056         }("");
1057     }
1058 
1059     function withdrawETH(uint256 _amount) external onlyOwner {
1060         require(address(this).balance >= _amount, "Invalid Amount");
1061         payable(msg.sender).transfer(_amount);
1062     }
1063 }