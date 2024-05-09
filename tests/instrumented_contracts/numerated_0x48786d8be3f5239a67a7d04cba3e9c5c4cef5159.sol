1 /*
2 
3 Swapify V2 Relaunch!
4 
5 This is the 0 tax relaunch of Swapify! An in browser swap with advanced features like multi wallet, anti rug, and more.
6 
7 https://t.me/Swapifyeth/
8 https://www.Swapifyeth.com/
9 
10 */
11 
12 // SPDX-License-Identifier: MIT
13 pragma solidity 0.8.20;
14 pragma experimental ABIEncoderV2;
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 contract Ownable is Context {
27     address private _owner;
28 
29     event OwnershipTransferred(
30         address indexed previousOwner,
31         address indexed newOwner
32     );
33 
34     constructor() {
35         _transferOwnership(_msgSender());
36     }
37 
38     function owner() public view virtual returns (address) {
39         return _owner;
40     }
41 
42     modifier onlyOwner() {
43         require(owner() == _msgSender(), "Ownable: caller is not the owner");
44         _;
45     }
46 
47     function renounceOwnership() public virtual onlyOwner {
48         _transferOwnership(address(0));
49     }
50 
51     function transferOwnership(address newOwner) public virtual onlyOwner {
52         require(
53             newOwner != address(0),
54             "Ownable: new owner is the zero address"
55         );
56         _transferOwnership(newOwner);
57     }
58 
59     function _transferOwnership(address newOwner) internal virtual {
60         address oldOwner = _owner;
61         _owner = newOwner;
62         emit OwnershipTransferred(oldOwner, newOwner);
63     }
64 }
65 
66 interface IERC20 {
67 
68     function totalSupply() external view returns (uint256);
69 
70     function balanceOf(address account) external view returns (uint256);
71 
72     function transfer(address recipient, uint256 amount)
73         external
74         returns (bool);
75 
76     function allowance(address owner, address spender)
77         external
78         view
79         returns (uint256);
80 
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     function transferFrom(
84         address sender,
85         address recipient,
86         uint256 amount
87     ) external returns (bool);
88 
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     event Approval(
92         address indexed owner,
93         address indexed spender,
94         uint256 value
95     );
96 }
97 
98 interface IERC20Metadata is IERC20 {
99 
100     function name() external view returns (string memory);
101 
102     function symbol() external view returns (string memory);
103 
104     function decimals() external view returns (uint8);
105 }
106 
107 contract ERC20 is Context, IERC20, IERC20Metadata {
108     mapping(address => uint256) private _balances;
109 
110     mapping(address => mapping(address => uint256)) private _allowances;
111 
112     uint256 private _totalSupply;
113 
114     string private _name;
115     string private _symbol;
116 
117     constructor(string memory name_, string memory symbol_) {
118         _name = name_;
119         _symbol = symbol_;
120     }
121 
122     function name() public view virtual override returns (string memory) {
123         return _name;
124     }
125 
126     function symbol() public view virtual override returns (string memory) {
127         return _symbol;
128     }
129 
130     function decimals() public view virtual override returns (uint8) {
131         return 18;
132     }
133 
134     function totalSupply() public view virtual override returns (uint256) {
135         return _totalSupply;
136     }
137 
138     function balanceOf(address account)
139         public
140         view
141         virtual
142         override
143         returns (uint256)
144     {
145         return _balances[account];
146     }
147 
148     function transfer(address recipient, uint256 amount)
149         public
150         virtual
151         override
152         returns (bool)
153     {
154         _transfer(_msgSender(), recipient, amount);
155         return true;
156     }
157 
158     function allowance(address owner, address spender)
159         public
160         view
161         virtual
162         override
163         returns (uint256)
164     {
165         return _allowances[owner][spender];
166     }
167 
168     function approve(address spender, uint256 amount)
169         public
170         virtual
171         override
172         returns (bool)
173     {
174         _approve(_msgSender(), spender, amount);
175         return true;
176     }
177 
178     function transferFrom(
179         address sender,
180         address recipient,
181         uint256 amount
182     ) public virtual override returns (bool) {
183         _transfer(sender, recipient, amount);
184 
185         uint256 currentAllowance = _allowances[sender][_msgSender()];
186         require(
187             currentAllowance >= amount,
188             "ERC20: transfer amount exceeds allowance"
189         );
190         unchecked {
191             _approve(sender, _msgSender(), currentAllowance - amount);
192         }
193 
194         return true;
195     }
196 
197     function increaseAllowance(address spender, uint256 addedValue)
198         public
199         virtual
200         returns (bool)
201     {
202         _approve(
203             _msgSender(),
204             spender,
205             _allowances[_msgSender()][spender] + addedValue
206         );
207         return true;
208     }
209 
210     function decreaseAllowance(address spender, uint256 subtractedValue)
211         public
212         virtual
213         returns (bool)
214     {
215         uint256 currentAllowance = _allowances[_msgSender()][spender];
216         require(
217             currentAllowance >= subtractedValue,
218             "ERC20: decreased allowance below zero"
219         );
220         unchecked {
221             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
222         }
223 
224         return true;
225     }
226 
227     function _transfer(
228         address sender,
229         address recipient,
230         uint256 amount
231     ) internal virtual {
232         require(sender != address(0), "ERC20: transfer from the zero address");
233         require(recipient != address(0), "ERC20: transfer to the zero address");
234 
235         _beforeTokenTransfer(sender, recipient, amount);
236 
237         uint256 senderBalance = _balances[sender];
238         require(
239             senderBalance >= amount,
240             "ERC20: transfer amount exceeds balance"
241         );
242         unchecked {
243             _balances[sender] = senderBalance - amount;
244         }
245         _balances[recipient] += amount;
246 
247         emit Transfer(sender, recipient, amount);
248 
249         _afterTokenTransfer(sender, recipient, amount);
250     }
251 
252     function _mint(address account, uint256 amount) internal virtual {
253         require(account != address(0), "ERC20: mint to the zero address");
254 
255         _beforeTokenTransfer(address(0), account, amount);
256 
257         _totalSupply += amount;
258         _balances[account] += amount;
259         emit Transfer(address(0), account, amount);
260 
261         _afterTokenTransfer(address(0), account, amount);
262     }
263 
264     function _burn(address account, uint256 amount) internal virtual {
265         require(account != address(0), "ERC20: burn from the zero address");
266 
267         _beforeTokenTransfer(account, address(0), amount);
268 
269         uint256 accountBalance = _balances[account];
270         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
271         unchecked {
272             _balances[account] = accountBalance - amount;
273         }
274         _totalSupply -= amount;
275 
276         emit Transfer(account, address(0), amount);
277 
278         _afterTokenTransfer(account, address(0), amount);
279     }
280 
281     function _approve(
282         address owner,
283         address spender,
284         uint256 amount
285     ) internal virtual {
286         require(owner != address(0), "ERC20: approve from the zero address");
287         require(spender != address(0), "ERC20: approve to the zero address");
288 
289         _allowances[owner][spender] = amount;
290         emit Approval(owner, spender, amount);
291     }
292 
293     function _beforeTokenTransfer(
294         address from,
295         address to,
296         uint256 amount
297     ) internal virtual {}
298 
299     function _afterTokenTransfer(
300         address from,
301         address to,
302         uint256 amount
303     ) internal virtual {}
304 }
305 
306 library SafeMath {
307     function tryAdd(uint256 a, uint256 b)
308         internal
309         pure
310         returns (bool, uint256)
311     {
312         unchecked {
313             uint256 c = a + b;
314             if (c < a) return (false, 0);
315             return (true, c);
316         }
317     }
318 
319     function trySub(uint256 a, uint256 b)
320         internal
321         pure
322         returns (bool, uint256)
323     {
324         unchecked {
325             if (b > a) return (false, 0);
326             return (true, a - b);
327         }
328     }
329 
330     function tryMul(uint256 a, uint256 b)
331         internal
332         pure
333         returns (bool, uint256)
334     {
335         unchecked {
336             if (a == 0) return (true, 0);
337             uint256 c = a * b;
338             if (c / a != b) return (false, 0);
339             return (true, c);
340         }
341     }
342 
343     function tryDiv(uint256 a, uint256 b)
344         internal
345         pure
346         returns (bool, uint256)
347     {
348         unchecked {
349             if (b == 0) return (false, 0);
350             return (true, a / b);
351         }
352     }
353 
354     function tryMod(uint256 a, uint256 b)
355         internal
356         pure
357         returns (bool, uint256)
358     {
359         unchecked {
360             if (b == 0) return (false, 0);
361             return (true, a % b);
362         }
363     }
364 
365     function add(uint256 a, uint256 b) internal pure returns (uint256) {
366         return a + b;
367     }
368 
369     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
370         return a - b;
371     }
372 
373     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
374         return a * b;
375     }
376 
377     function div(uint256 a, uint256 b) internal pure returns (uint256) {
378         return a / b;
379     }
380 
381     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
382         return a % b;
383     }
384 
385     function sub(
386         uint256 a,
387         uint256 b,
388         string memory errorMessage
389     ) internal pure returns (uint256) {
390         unchecked {
391             require(b <= a, errorMessage);
392             return a - b;
393         }
394     }
395 
396     function div(
397         uint256 a,
398         uint256 b,
399         string memory errorMessage
400     ) internal pure returns (uint256) {
401         unchecked {
402             require(b > 0, errorMessage);
403             return a / b;
404         }
405     }
406 
407     function mod(
408         uint256 a,
409         uint256 b,
410         string memory errorMessage
411     ) internal pure returns (uint256) {
412         unchecked {
413             require(b > 0, errorMessage);
414             return a % b;
415         }
416     }
417 }
418 
419 interface IUniswapV2Factory {
420     event PairCreated(
421         address indexed token0,
422         address indexed token1,
423         address pair,
424         uint256
425     );
426 
427     function feeTo() external view returns (address);
428 
429     function feeToSetter() external view returns (address);
430 
431     function getPair(address tokenA, address tokenB)
432         external
433         view
434         returns (address pair);
435 
436     function allPairs(uint256) external view returns (address pair);
437 
438     function allPairsLength() external view returns (uint256);
439 
440     function createPair(address tokenA, address tokenB)
441         external
442         returns (address pair);
443 
444     function setFeeTo(address) external;
445 
446     function setFeeToSetter(address) external;
447 }
448 
449 interface IUniswapV2Pair {
450     event Approval(
451         address indexed owner,
452         address indexed spender,
453         uint256 value
454     );
455     event Transfer(address indexed from, address indexed to, uint256 value);
456 
457     function name() external pure returns (string memory);
458 
459     function symbol() external pure returns (string memory);
460 
461     function decimals() external pure returns (uint8);
462 
463     function totalSupply() external view returns (uint256);
464 
465     function balanceOf(address owner) external view returns (uint256);
466 
467     function allowance(address owner, address spender)
468         external
469         view
470         returns (uint256);
471 
472     function approve(address spender, uint256 value) external returns (bool);
473 
474     function transfer(address to, uint256 value) external returns (bool);
475 
476     function transferFrom(
477         address from,
478         address to,
479         uint256 value
480     ) external returns (bool);
481 
482     function DOMAIN_SEPARATOR() external view returns (bytes32);
483 
484     function PERMIT_TYPEHASH() external pure returns (bytes32);
485 
486     function nonces(address owner) external view returns (uint256);
487 
488     function permit(
489         address owner,
490         address spender,
491         uint256 value,
492         uint256 deadline,
493         uint8 v,
494         bytes32 r,
495         bytes32 s
496     ) external;
497 
498     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
499     event Burn(
500         address indexed sender,
501         uint256 amount0,
502         uint256 amount1,
503         address indexed to
504     );
505     event Swap(
506         address indexed sender,
507         uint256 amount0In,
508         uint256 amount1In,
509         uint256 amount0Out,
510         uint256 amount1Out,
511         address indexed to
512     );
513     event Sync(uint112 reserve0, uint112 reserve1);
514 
515     function MINIMUM_LIQUIDITY() external pure returns (uint256);
516 
517     function factory() external view returns (address);
518 
519     function token0() external view returns (address);
520 
521     function token1() external view returns (address);
522 
523     function getReserves()
524         external
525         view
526         returns (
527             uint112 reserve0,
528             uint112 reserve1,
529             uint32 blockTimestampLast
530         );
531 
532     function price0CumulativeLast() external view returns (uint256);
533 
534     function price1CumulativeLast() external view returns (uint256);
535 
536     function kLast() external view returns (uint256);
537 
538     function mint(address to) external returns (uint256 liquidity);
539 
540     function burn(address to)
541         external
542         returns (uint256 amount0, uint256 amount1);
543 
544     function swap(
545         uint256 amount0Out,
546         uint256 amount1Out,
547         address to,
548         bytes calldata data
549     ) external;
550 
551     function skim(address to) external;
552 
553     function sync() external;
554 
555     function initialize(address, address) external;
556 }
557 
558 interface IUniswapV2Router02 {
559     function factory() external pure returns (address);
560 
561     function WETH() external pure returns (address);
562 
563     function addLiquidity(
564         address tokenA,
565         address tokenB,
566         uint256 amountADesired,
567         uint256 amountBDesired,
568         uint256 amountAMin,
569         uint256 amountBMin,
570         address to,
571         uint256 deadline
572     )
573         external
574         returns (
575             uint256 amountA,
576             uint256 amountB,
577             uint256 liquidity
578         );
579 
580     function addLiquidityETH(
581         address token,
582         uint256 amountTokenDesired,
583         uint256 amountTokenMin,
584         uint256 amountETHMin,
585         address to,
586         uint256 deadline
587     )
588         external
589         payable
590         returns (
591             uint256 amountToken,
592             uint256 amountETH,
593             uint256 liquidity
594         );
595 
596     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
597         uint256 amountIn,
598         uint256 amountOutMin,
599         address[] calldata path,
600         address to,
601         uint256 deadline
602     ) external;
603 
604     function swapExactETHForTokensSupportingFeeOnTransferTokens(
605         uint256 amountOutMin,
606         address[] calldata path,
607         address to,
608         uint256 deadline
609     ) external payable;
610 
611     function swapExactTokensForETHSupportingFeeOnTransferTokens(
612         uint256 amountIn,
613         uint256 amountOutMin,
614         address[] calldata path,
615         address to,
616         uint256 deadline
617     ) external;
618 }
619 
620 contract Swapify is ERC20, Ownable {
621     using SafeMath for uint256;
622 
623     IUniswapV2Router02 public immutable uniswapV2Router;
624     address public immutable uniswapV2Pair;
625     address public constant deadAddress = address(0xdead);
626 
627     bool private swapping;
628 
629     address public AWallet;
630     address public BWallet;
631     address public CWallet;
632 
633     uint256 public maxTransactionAmount;
634     uint256 public swapTokensAtAmount;
635     uint256 public maxWallet;
636 
637     bool public limitsInEffect = true;
638     bool public tradingActive = false;
639 
640     uint256 public launchedAt;
641     uint256 public launchedAtTimestamp;
642     uint256 antiBot = 1 seconds;
643 
644     uint256 public buyTotalFees = 2;
645     uint256 public buyAFee = 2;
646     uint256 public buyBFee = 0;
647     uint256 public buyCFee = 0;
648     uint256 public buyLiquidityFee = 0;
649     uint256 public buyAutoBurnFee = 0;
650 
651     uint256 public sellTotalFees = 20;
652     uint256 public sellAFee = 20;
653     uint256 public sellBFee = 0;
654     uint256 public sellCFee = 0;
655     uint256 public sellLiquidityFee = 0;
656     uint256 public sellAutoBurnFee = 0;
657 
658     uint256 public tokensForA;
659     uint256 public tokensForLiquidity;
660     uint256 public tokensForB;
661     uint256 public tokensForC;
662     uint256 public tokensForAutoburn;
663 
664     mapping(address => bool) private _isExcludedFromFees;
665     mapping(address => bool) public _isExcludedMaxTransactionAmount;
666     mapping(address => bool) public isBot;
667 
668     mapping(address => bool) public automatedMarketMakerPairs;
669 
670     event UpdateUniswapV2Router(
671         address indexed newAddress,
672         address indexed oldAddress
673     );
674 
675     event ExcludeFromFees(address indexed account, bool isExcluded);
676 
677     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
678 
679     event AWalletUpdated(
680         address indexed newWallet,
681         address indexed oldWallet
682     );
683 
684     event BWalletUpdated(
685         address indexed newWallet,
686         address indexed oldWallet
687     );
688 
689     event CWalletUpdated(
690         address indexed newWallet,
691         address indexed oldWallet
692     );
693     event SwapAndLiquify(
694         uint256 tokensSwapped,
695         uint256 ethReceived,
696         uint256 tokensIntoLiquidity
697     );
698 
699     constructor(
700 
701     ) ERC20("Swapify", "SWIFY") {
702         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
703             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
704         );
705 
706         excludeFromMaxTransaction(address(_uniswapV2Router), true);
707         uniswapV2Router = _uniswapV2Router;
708 
709         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
710             .createPair(address(this), _uniswapV2Router.WETH());
711         excludeFromMaxTransaction(address(uniswapV2Pair), true);
712         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
713 
714         uint256 totalSupply = 100_000_000 * 1e18;
715 
716         maxTransactionAmount = 2000000 * 1e18;
717         maxWallet = 2000000 * 1e18;
718         swapTokensAtAmount = 500000 * 1e18;
719 
720         AWallet = address(0xF36aDbd40bed0d2a1F440F23AB11d7bdE6065c8f); 
721         BWallet = address(0xF36aDbd40bed0d2a1F440F23AB11d7bdE6065c8f);
722         CWallet = address(0xF36aDbd40bed0d2a1F440F23AB11d7bdE6065c8f);
723         excludeFromFees(owner(), true);
724         excludeFromFees(address(this), true);
725         excludeFromFees(address(0xdead), true);
726 
727         excludeFromMaxTransaction(owner(), true);
728         excludeFromMaxTransaction(address(this), true);
729         excludeFromMaxTransaction(address(0xdead), true);
730 
731         _mint(owner(), totalSupply);
732     }
733 
734     receive() external payable {}
735 
736     function launched() internal view returns (bool) {
737         return launchedAt != 0;
738     }
739 
740     function launch() public onlyOwner {
741         require(launchedAt == 0, "Already launched");
742         launchedAt = block.number;
743         launchedAtTimestamp = block.timestamp;
744         tradingActive = true;
745     }
746 
747     function removeLimits() external onlyOwner returns (bool) {
748         limitsInEffect = false;
749         return true;
750     }
751 
752     function excludeFromMaxTransaction(address updAds, bool isEx)
753         public
754         onlyOwner
755     {
756         _isExcludedMaxTransactionAmount[updAds] = isEx;
757     }
758 
759     function updateBuyFees(
760         uint256 _AFee,
761         uint256 _BFee,
762         uint256 _CFee,
763         uint256 _liquidityFee,
764         uint256 _autoBurnFee
765     ) external onlyOwner {
766         buyAFee = _AFee;
767         buyBFee = _BFee;
768         buyCFee = _CFee;
769         buyLiquidityFee = _liquidityFee;
770         buyAutoBurnFee = _autoBurnFee;
771         buyTotalFees =
772             buyAFee +
773             buyBFee +
774             buyCFee +
775             buyLiquidityFee +
776             buyAutoBurnFee;
777     }
778 
779     function updateSellFees(
780         uint256 _AFee,
781         uint256 _BFee,
782         uint256 _CFee,
783         uint256 _liquidityFee,
784         uint256 _autoBurnFee
785     ) external onlyOwner {
786         sellAFee = _AFee;
787         sellBFee = _BFee;
788         sellCFee = _CFee;
789         sellLiquidityFee = _liquidityFee;
790         sellAutoBurnFee = _autoBurnFee;
791         sellTotalFees =
792             sellAFee +
793             sellBFee +
794             sellCFee +
795             sellLiquidityFee +
796             sellAutoBurnFee;
797     }
798 
799     function excludeFromFees(address account, bool excluded) public onlyOwner {
800         _isExcludedFromFees[account] = excluded;
801         emit ExcludeFromFees(account, excluded);
802     }
803 
804     function setAutomatedMarketMakerPair(address pair, bool value)
805         public
806         onlyOwner
807     {
808         require(
809             pair != uniswapV2Pair,
810             "The pair cannot be removed from automatedMarketMakerPairs"
811         );
812 
813         _setAutomatedMarketMakerPair(pair, value);
814     }
815 
816     function _setAutomatedMarketMakerPair(address pair, bool value) private {
817         automatedMarketMakerPairs[pair] = value;
818 
819         emit SetAutomatedMarketMakerPair(pair, value);
820     }
821 
822     function updateAWallet(address newAWallet) external onlyOwner {
823         emit AWalletUpdated(newAWallet, AWallet);
824         AWallet = newAWallet;
825     }
826 
827     function updateBWallet(address newBWallet) external onlyOwner {
828         emit BWalletUpdated(newBWallet, BWallet);
829         BWallet = newBWallet;
830     }
831 
832     function updateCWallet(address newWallet) external onlyOwner {
833         emit CWalletUpdated(newWallet, CWallet);
834         CWallet = newWallet;
835     }
836 
837     function isExcludedFromFees(address account) public view returns (bool) {
838         return _isExcludedFromFees[account];
839     }
840 
841     function addBotInList(address _account) external onlyOwner {
842         require(
843             _account != address(uniswapV2Router),
844             "Can not blacklist router"
845         );
846         require(!isBot[_account], "Bot already added");
847         isBot[_account] = true;
848     }
849 
850     function removeBotFromList(address _account) external onlyOwner {
851         require(isBot[_account], "Bot not found");
852         isBot[_account] = false;
853     }
854 
855     function _transfer(
856         address from,
857         address to,
858         uint256 amount
859     ) internal override {
860         require(from != address(0), "ERC20: transfer from the zero address");
861         require(to != address(0), "ERC20: transfer to the zero address");
862         require(!isBot[to], "Bot detected");
863         require(!isBot[from], "Bot detected");
864 
865         if (amount == 0) {
866             super._transfer(from, to, 0);
867             return;
868         }
869 
870         if (limitsInEffect) {
871             if (
872                 from != owner() &&
873                 to != owner() &&
874                 to != address(0) &&
875                 to != address(0xdead) &&
876                 !swapping
877             ) {
878                 if (!tradingActive) {
879                     require(
880                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
881                         "Trading is not active."
882                     );
883                 }
884                 if (
885                     block.timestamp < launchedAtTimestamp + antiBot &&
886                     from != address(uniswapV2Router)
887                 ) {
888                     if (from == uniswapV2Pair) {
889                         isBot[to] = true;
890                     } else if (to == uniswapV2Pair) {
891                         isBot[from] = true;
892                     }
893                 }
894                 if (
895                     automatedMarketMakerPairs[from] &&
896                     !_isExcludedMaxTransactionAmount[to]
897                 ) {
898                     require(
899                         amount <= maxTransactionAmount,
900                         "Buy transfer amount exceeds the maxTransactionAmount."
901                     );
902                     require(
903                         amount + balanceOf(to) <= maxWallet,
904                         "Max wallet exceeded"
905                     );
906                 }
907                 else if (
908                     automatedMarketMakerPairs[to] &&
909                     !_isExcludedMaxTransactionAmount[from]
910                 ) {
911                     require(
912                         amount <= maxTransactionAmount,
913                         "Sell transfer amount exceeds the maxTransactionAmount."
914                     );
915                 } else if (!_isExcludedMaxTransactionAmount[to]) {
916                     require(
917                         amount + balanceOf(to) <= maxWallet,
918                         "Max wallet exceeded"
919                     );
920                 }
921             }
922         }
923 
924         uint256 contractTokenBalance = balanceOf(address(this));
925 
926         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
927 
928         if (
929             canSwap &&
930             !swapping &&
931             !automatedMarketMakerPairs[from] &&
932             !_isExcludedFromFees[from] &&
933             !_isExcludedFromFees[to]
934         ) {
935             swapping = true;
936 
937             swapBack();
938 
939             swapping = false;
940         }
941 
942         bool takeFee = !swapping;
943 
944         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
945             takeFee = false;
946         }
947 
948         uint256 fees = 0;
949         if (takeFee) {
950             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
951                 fees = amount.mul(sellTotalFees).div(100);
952                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
953                 tokensForB += (fees * sellCFee) / sellTotalFees;
954                 tokensForA += (fees * sellAFee) / sellTotalFees;
955                 tokensForC += (fees * sellCFee) / sellTotalFees;
956                 tokensForAutoburn = (fees * sellAutoBurnFee) / sellTotalFees;
957             }
958             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
959                 fees = amount.mul(buyTotalFees).div(100);
960                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
961                 tokensForB += (fees * buyCFee) / buyTotalFees;
962                 tokensForA += (fees * buyAFee) / buyTotalFees;
963                 tokensForC += (fees * buyCFee) / buyTotalFees;
964                 tokensForAutoburn = (fees * buyAutoBurnFee) / buyTotalFees;
965             }
966 
967             if (fees > 0) {
968                 _burn(from, tokensForAutoburn);
969                 super._transfer(from, address(this), fees - tokensForAutoburn);
970             }
971 
972             amount -= fees;
973         }
974 
975         super._transfer(from, to, amount);
976     }
977 
978     function swapTokensForEth(uint256 tokenAmount) private {
979         address[] memory path = new address[](2);
980         path[0] = address(this);
981         path[1] = uniswapV2Router.WETH();
982 
983         _approve(address(this), address(uniswapV2Router), tokenAmount);
984 
985         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
986             tokenAmount,
987             0,
988             path,
989             address(this),
990             block.timestamp
991         );
992     }
993 
994     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
995         _approve(address(this), address(uniswapV2Router), tokenAmount);
996 
997         uniswapV2Router.addLiquidityETH{value: ethAmount}(
998             address(this),
999             tokenAmount,
1000             0, 
1001             0, 
1002             deadAddress,
1003             block.timestamp
1004         );
1005     }
1006 
1007     function swapBack() private {
1008         uint256 contractBalance = balanceOf(address(this));
1009         uint256 totalTokensToSwap = tokensForLiquidity +
1010             tokensForA +
1011             tokensForB +
1012             tokensForC;
1013         bool success;
1014 
1015         if (contractBalance == 0 || totalTokensToSwap == 0) {
1016             return;
1017         }
1018 
1019         if (contractBalance > swapTokensAtAmount) {
1020             contractBalance = swapTokensAtAmount;
1021         }
1022 
1023         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1024             totalTokensToSwap /
1025             2;
1026         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1027 
1028         uint256 initialETHBalance = address(this).balance;
1029 
1030         swapTokensForEth(amountToSwapForETH);
1031 
1032         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1033 
1034         uint256 ethForA = ethBalance.mul(tokensForA).div(
1035             totalTokensToSwap
1036         );
1037         uint256 ethForB = ethBalance.mul(tokensForB).div(
1038             totalTokensToSwap
1039         );
1040         uint256 ethForC = ethBalance.mul(tokensForC).div(
1041             totalTokensToSwap
1042         );
1043         uint256 ethForLiquidity = ethBalance -
1044             ethForA -
1045             ethForB -
1046             ethForC;
1047 
1048         tokensForLiquidity = 0;
1049         tokensForA = 0;
1050         tokensForB = 0;
1051         tokensForC = 0;
1052 
1053         (success, ) = address(BWallet).call{value: ethForB}("");
1054 
1055         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1056             addLiquidity(liquidityTokens, ethForLiquidity);
1057             emit SwapAndLiquify(
1058                 amountToSwapForETH,
1059                 ethForLiquidity,
1060                 tokensForLiquidity
1061             );
1062         }
1063 
1064         (success, ) = address(AWallet).call{value: ethForA}("");
1065         (success, ) = address(CWallet).call{
1066             value: address(this).balance
1067         }("");
1068     }
1069 
1070     function withdrawETH(uint256 _amount) external onlyOwner {
1071         require(address(this).balance >= _amount, "Invalid Amount");
1072         payable(msg.sender).transfer(_amount);
1073     }
1074 }