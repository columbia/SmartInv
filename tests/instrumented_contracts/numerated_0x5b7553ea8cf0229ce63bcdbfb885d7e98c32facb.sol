1 /**
2 
3 https://t.me/pupaerc
4 
5 https://pupa-coin.xyz/
6 
7 https://twitter.com/pupa_coin
8 
9 **/
10 // SPDX-License-Identifier: MIT
11 pragma solidity 0.8.17;
12 pragma experimental ABIEncoderV2;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 contract Ownable is Context {
25     address private _owner;
26 
27     event OwnershipTransferred(
28         address indexed previousOwner,
29         address indexed newOwner
30     );
31 
32     constructor() {
33         _transferOwnership(_msgSender());
34     }
35 
36     function owner() public view virtual returns (address) {
37         return _owner;
38     }
39 
40     modifier onlyOwner() {
41         require(owner() == _msgSender(), "Ownable: caller is not the owner");
42         _;
43     }
44 
45     function renounceOwnership() public virtual onlyOwner {
46         _transferOwnership(address(0));
47     }
48 
49     function transferOwnership(address newOwner) public virtual onlyOwner {
50         require(
51             newOwner != address(0),
52             "Ownable: new owner is the zero address"
53         );
54         _transferOwnership(newOwner);
55     }
56 
57     function _transferOwnership(address newOwner) internal virtual {
58         address oldOwner = _owner;
59         _owner = newOwner;
60         emit OwnershipTransferred(oldOwner, newOwner);
61     }
62 }
63 
64 interface IERC20 {
65 
66     function totalSupply() external view returns (uint256);
67 
68     function balanceOf(address account) external view returns (uint256);
69 
70     function transfer(address recipient, uint256 amount)
71         external
72         returns (bool);
73 
74     function allowance(address owner, address spender)
75         external
76         view
77         returns (uint256);
78 
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     function transferFrom(
82         address sender,
83         address recipient,
84         uint256 amount
85     ) external returns (bool);
86 
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     event Approval(
90         address indexed owner,
91         address indexed spender,
92         uint256 value
93     );
94 }
95 
96 interface IERC20Metadata is IERC20 {
97 
98     function name() external view returns (string memory);
99 
100     function symbol() external view returns (string memory);
101 
102     function decimals() external view returns (uint8);
103 }
104 
105 contract ERC20 is Context, IERC20, IERC20Metadata {
106     mapping(address => uint256) private _balances;
107 
108     mapping(address => mapping(address => uint256)) private _allowances;
109 
110     uint256 private _totalSupply;
111 
112     string private _name;
113     string private _symbol;
114 
115     constructor(string memory name_, string memory symbol_) {
116         _name = name_;
117         _symbol = symbol_;
118     }
119 
120     function name() public view virtual override returns (string memory) {
121         return _name;
122     }
123 
124     function symbol() public view virtual override returns (string memory) {
125         return _symbol;
126     }
127 
128     function decimals() public view virtual override returns (uint8) {
129         return 18;
130     }
131 
132     function totalSupply() public view virtual override returns (uint256) {
133         return _totalSupply;
134     }
135 
136     function balanceOf(address account)
137         public
138         view
139         virtual
140         override
141         returns (uint256)
142     {
143         return _balances[account];
144     }
145 
146     function transfer(address recipient, uint256 amount)
147         public
148         virtual
149         override
150         returns (bool)
151     {
152         _transfer(_msgSender(), recipient, amount);
153         return true;
154     }
155 
156     function allowance(address owner, address spender)
157         public
158         view
159         virtual
160         override
161         returns (uint256)
162     {
163         return _allowances[owner][spender];
164     }
165 
166     function approve(address spender, uint256 amount)
167         public
168         virtual
169         override
170         returns (bool)
171     {
172         _approve(_msgSender(), spender, amount);
173         return true;
174     }
175 
176     function transferFrom(
177         address sender,
178         address recipient,
179         uint256 amount
180     ) public virtual override returns (bool) {
181         _transfer(sender, recipient, amount);
182 
183         uint256 currentAllowance = _allowances[sender][_msgSender()];
184         require(
185             currentAllowance >= amount,
186             "ERC20: transfer amount exceeds allowance"
187         );
188         unchecked {
189             _approve(sender, _msgSender(), currentAllowance - amount);
190         }
191 
192         return true;
193     }
194 
195     function increaseAllowance(address spender, uint256 addedValue)
196         public
197         virtual
198         returns (bool)
199     {
200         _approve(
201             _msgSender(),
202             spender,
203             _allowances[_msgSender()][spender] + addedValue
204         );
205         return true;
206     }
207 
208     function decreaseAllowance(address spender, uint256 subtractedValue)
209         public
210         virtual
211         returns (bool)
212     {
213         uint256 currentAllowance = _allowances[_msgSender()][spender];
214         require(
215             currentAllowance >= subtractedValue,
216             "ERC20: decreased allowance below zero"
217         );
218         unchecked {
219             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
220         }
221 
222         return true;
223     }
224 
225     function _transfer(
226         address sender,
227         address recipient,
228         uint256 amount
229     ) internal virtual {
230         require(sender != address(0), "ERC20: transfer from the zero address");
231         require(recipient != address(0), "ERC20: transfer to the zero address");
232 
233         _beforeTokenTransfer(sender, recipient, amount);
234 
235         uint256 senderBalance = _balances[sender];
236         require(
237             senderBalance >= amount,
238             "ERC20: transfer amount exceeds balance"
239         );
240         unchecked {
241             _balances[sender] = senderBalance - amount;
242         }
243         _balances[recipient] += amount;
244 
245         emit Transfer(sender, recipient, amount);
246 
247         _afterTokenTransfer(sender, recipient, amount);
248     }
249 
250     function _mint(address account, uint256 amount) internal virtual {
251         require(account != address(0), "ERC20: mint to the zero address");
252 
253         _beforeTokenTransfer(address(0), account, amount);
254 
255         _totalSupply += amount;
256         _balances[account] += amount;
257         emit Transfer(address(0), account, amount);
258 
259         _afterTokenTransfer(address(0), account, amount);
260     }
261 
262     function _burn(address account, uint256 amount) internal virtual {
263         require(account != address(0), "ERC20: burn from the zero address");
264 
265         _beforeTokenTransfer(account, address(0), amount);
266 
267         uint256 accountBalance = _balances[account];
268         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
269         unchecked {
270             _balances[account] = accountBalance - amount;
271         }
272         _totalSupply -= amount;
273 
274         emit Transfer(account, address(0), amount);
275 
276         _afterTokenTransfer(account, address(0), amount);
277     }
278 
279     function _approve(
280         address owner,
281         address spender,
282         uint256 amount
283     ) internal virtual {
284         require(owner != address(0), "ERC20: approve from the zero address");
285         require(spender != address(0), "ERC20: approve to the zero address");
286 
287         _allowances[owner][spender] = amount;
288         emit Approval(owner, spender, amount);
289     }
290 
291     function _beforeTokenTransfer(
292         address from,
293         address to,
294         uint256 amount
295     ) internal virtual {}
296 
297     function _afterTokenTransfer(
298         address from,
299         address to,
300         uint256 amount
301     ) internal virtual {}
302 }
303 
304 library SafeMath {
305     function tryAdd(uint256 a, uint256 b)
306         internal
307         pure
308         returns (bool, uint256)
309     {
310         unchecked {
311             uint256 c = a + b;
312             if (c < a) return (false, 0);
313             return (true, c);
314         }
315     }
316 
317     function trySub(uint256 a, uint256 b)
318         internal
319         pure
320         returns (bool, uint256)
321     {
322         unchecked {
323             if (b > a) return (false, 0);
324             return (true, a - b);
325         }
326     }
327 
328     function tryMul(uint256 a, uint256 b)
329         internal
330         pure
331         returns (bool, uint256)
332     {
333         unchecked {
334             if (a == 0) return (true, 0);
335             uint256 c = a * b;
336             if (c / a != b) return (false, 0);
337             return (true, c);
338         }
339     }
340 
341     function tryDiv(uint256 a, uint256 b)
342         internal
343         pure
344         returns (bool, uint256)
345     {
346         unchecked {
347             if (b == 0) return (false, 0);
348             return (true, a / b);
349         }
350     }
351 
352     function tryMod(uint256 a, uint256 b)
353         internal
354         pure
355         returns (bool, uint256)
356     {
357         unchecked {
358             if (b == 0) return (false, 0);
359             return (true, a % b);
360         }
361     }
362 
363     function add(uint256 a, uint256 b) internal pure returns (uint256) {
364         return a + b;
365     }
366 
367     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
368         return a - b;
369     }
370 
371     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
372         return a * b;
373     }
374 
375     function div(uint256 a, uint256 b) internal pure returns (uint256) {
376         return a / b;
377     }
378 
379     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
380         return a % b;
381     }
382 
383     function sub(
384         uint256 a,
385         uint256 b,
386         string memory errorMessage
387     ) internal pure returns (uint256) {
388         unchecked {
389             require(b <= a, errorMessage);
390             return a - b;
391         }
392     }
393 
394     function div(
395         uint256 a,
396         uint256 b,
397         string memory errorMessage
398     ) internal pure returns (uint256) {
399         unchecked {
400             require(b > 0, errorMessage);
401             return a / b;
402         }
403     }
404 
405     function mod(
406         uint256 a,
407         uint256 b,
408         string memory errorMessage
409     ) internal pure returns (uint256) {
410         unchecked {
411             require(b > 0, errorMessage);
412             return a % b;
413         }
414     }
415 }
416 
417 interface IUniswapV2Factory {
418     event PairCreated(
419         address indexed token0,
420         address indexed token1,
421         address pair,
422         uint256
423     );
424 
425     function feeTo() external view returns (address);
426 
427     function feeToSetter() external view returns (address);
428 
429     function getPair(address tokenA, address tokenB)
430         external
431         view
432         returns (address pair);
433 
434     function allPairs(uint256) external view returns (address pair);
435 
436     function allPairsLength() external view returns (uint256);
437 
438     function createPair(address tokenA, address tokenB)
439         external
440         returns (address pair);
441 
442     function setFeeTo(address) external;
443 
444     function setFeeToSetter(address) external;
445 }
446 
447 interface IUniswapV2Pair {
448     event Approval(
449         address indexed owner,
450         address indexed spender,
451         uint256 value
452     );
453     event Transfer(address indexed from, address indexed to, uint256 value);
454 
455     function name() external pure returns (string memory);
456 
457     function symbol() external pure returns (string memory);
458 
459     function decimals() external pure returns (uint8);
460 
461     function totalSupply() external view returns (uint256);
462 
463     function balanceOf(address owner) external view returns (uint256);
464 
465     function allowance(address owner, address spender)
466         external
467         view
468         returns (uint256);
469 
470     function approve(address spender, uint256 value) external returns (bool);
471 
472     function transfer(address to, uint256 value) external returns (bool);
473 
474     function transferFrom(
475         address from,
476         address to,
477         uint256 value
478     ) external returns (bool);
479 
480     function DOMAIN_SEPARATOR() external view returns (bytes32);
481 
482     function PERMIT_TYPEHASH() external pure returns (bytes32);
483 
484     function nonces(address owner) external view returns (uint256);
485 
486     function permit(
487         address owner,
488         address spender,
489         uint256 value,
490         uint256 deadline,
491         uint8 v,
492         bytes32 r,
493         bytes32 s
494     ) external;
495 
496     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
497     event Burn(
498         address indexed sender,
499         uint256 amount0,
500         uint256 amount1,
501         address indexed to
502     );
503     event Swap(
504         address indexed sender,
505         uint256 amount0In,
506         uint256 amount1In,
507         uint256 amount0Out,
508         uint256 amount1Out,
509         address indexed to
510     );
511     event Sync(uint112 reserve0, uint112 reserve1);
512 
513     function MINIMUM_LIQUIDITY() external pure returns (uint256);
514 
515     function factory() external view returns (address);
516 
517     function token0() external view returns (address);
518 
519     function token1() external view returns (address);
520 
521     function getReserves()
522         external
523         view
524         returns (
525             uint112 reserve0,
526             uint112 reserve1,
527             uint32 blockTimestampLast
528         );
529 
530     function price0CumulativeLast() external view returns (uint256);
531 
532     function price1CumulativeLast() external view returns (uint256);
533 
534     function kLast() external view returns (uint256);
535 
536     function mint(address to) external returns (uint256 liquidity);
537 
538     function burn(address to)
539         external
540         returns (uint256 amount0, uint256 amount1);
541 
542     function swap(
543         uint256 amount0Out,
544         uint256 amount1Out,
545         address to,
546         bytes calldata data
547     ) external;
548 
549     function skim(address to) external;
550 
551     function sync() external;
552 
553     function initialize(address, address) external;
554 }
555 
556 interface IUniswapV2Router02 {
557     function factory() external pure returns (address);
558 
559     function WETH() external pure returns (address);
560 
561     function addLiquidity(
562         address tokenA,
563         address tokenB,
564         uint256 amountADesired,
565         uint256 amountBDesired,
566         uint256 amountAMin,
567         uint256 amountBMin,
568         address to,
569         uint256 deadline
570     )
571         external
572         returns (
573             uint256 amountA,
574             uint256 amountB,
575             uint256 liquidity
576         );
577 
578     function addLiquidityETH(
579         address token,
580         uint256 amountTokenDesired,
581         uint256 amountTokenMin,
582         uint256 amountETHMin,
583         address to,
584         uint256 deadline
585     )
586         external
587         payable
588         returns (
589             uint256 amountToken,
590             uint256 amountETH,
591             uint256 liquidity
592         );
593 
594     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
595         uint256 amountIn,
596         uint256 amountOutMin,
597         address[] calldata path,
598         address to,
599         uint256 deadline
600     ) external;
601 
602     function swapExactETHForTokensSupportingFeeOnTransferTokens(
603         uint256 amountOutMin,
604         address[] calldata path,
605         address to,
606         uint256 deadline
607     ) external payable;
608 
609     function swapExactTokensForETHSupportingFeeOnTransferTokens(
610         uint256 amountIn,
611         uint256 amountOutMin,
612         address[] calldata path,
613         address to,
614         uint256 deadline
615     ) external;
616 }
617 
618 contract PUPA is ERC20, Ownable {
619     using SafeMath for uint256;
620 
621     IUniswapV2Router02 public immutable uniswapV2Router;
622     address public immutable uniswapV2Pair;
623     address public constant deadAddress = address(0xdead);
624 
625     bool private swapping;
626 
627     address public AWallet;
628     address public BWallet;
629     address public CWallet;
630 
631     uint256 public maxTransactionAmount;
632     uint256 public swapTokensAtAmount;
633     uint256 public maxWallet;
634 
635     bool public limitsInEffect = true;
636     bool public tradingActive = false;
637 
638     uint256 public launchedAt;
639     uint256 public launchedAtTimestamp;
640     uint256 antiBot = 0 seconds;
641 
642     uint256 public buyTotalFees = 4;
643     uint256 public buyAFee = 4;
644     uint256 public buyBFee = 0;
645     uint256 public buyCFee = 0;
646     uint256 public buyLiquidityFee = 0;
647     uint256 public buyAutoBurnFee = 0;
648 
649     uint256 public sellTotalFees = 4;
650     uint256 public sellAFee = 4;
651     uint256 public sellBFee = 0;
652     uint256 public sellCFee = 0;
653     uint256 public sellLiquidityFee = 0;
654     uint256 public sellAutoBurnFee = 0;
655 
656     uint256 public tokensForA;
657     uint256 public tokensForLiquidity;
658     uint256 public tokensForB;
659     uint256 public tokensForC;
660     uint256 public tokensForAutoburn;
661 
662     mapping(address => bool) private _isExcludedFromFees;
663     mapping(address => bool) public _isExcludedMaxTransactionAmount;
664     mapping(address => bool) public isBot;
665 
666     mapping(address => bool) public automatedMarketMakerPairs;
667 
668     event UpdateUniswapV2Router(
669         address indexed newAddress,
670         address indexed oldAddress
671     );
672 
673     event ExcludeFromFees(address indexed account, bool isExcluded);
674 
675     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
676 
677     event AWalletUpdated(
678         address indexed newWallet,
679         address indexed oldWallet
680     );
681 
682     event BWalletUpdated(
683         address indexed newWallet,
684         address indexed oldWallet
685     );
686 
687     event CWalletUpdated(
688         address indexed newWallet,
689         address indexed oldWallet
690     );
691     event SwapAndLiquify(
692         uint256 tokensSwapped,
693         uint256 ethReceived,
694         uint256 tokensIntoLiquidity
695     );
696 
697     constructor(
698 
699     ) ERC20("Pupa Coin", "PUPA") {
700         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
701             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
702         );
703 
704         excludeFromMaxTransaction(address(_uniswapV2Router), true);
705         uniswapV2Router = _uniswapV2Router;
706 
707         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
708             .createPair(address(this), _uniswapV2Router.WETH());
709         excludeFromMaxTransaction(address(uniswapV2Pair), true);
710         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
711 
712         uint256 totalSupply = 1_000_000 * 1e18;
713 
714         maxTransactionAmount = 20000 * 1e18;
715         maxWallet = 20000 * 1e18;
716         swapTokensAtAmount = 5000 * 1e18;
717 
718         AWallet = address(0x951bcb2198f18a2ce53B1A076d5E3B0E8702CBdD); 
719         BWallet = address(0x951bcb2198f18a2ce53B1A076d5E3B0E8702CBdD);
720         CWallet = address(0x951bcb2198f18a2ce53B1A076d5E3B0E8702CBdD);
721         excludeFromFees(owner(), true);
722         excludeFromFees(address(this), true);
723         excludeFromFees(address(0xdead), true);
724 
725         excludeFromMaxTransaction(owner(), true);
726         excludeFromMaxTransaction(address(this), true);
727         excludeFromMaxTransaction(address(0xdead), true);
728 
729         _mint(owner(), totalSupply);
730     }
731 
732     receive() external payable {}
733 
734     function launched() internal view returns (bool) {
735         return launchedAt != 0;
736     }
737 
738     function launch() public onlyOwner {
739         require(launchedAt == 0, "Already launched");
740         launchedAt = block.number;
741         launchedAtTimestamp = block.timestamp;
742         tradingActive = true;
743     }
744 
745     function removeLimits() external onlyOwner returns (bool) {
746         limitsInEffect = false;
747         return true;
748     }
749 
750     function excludeFromMaxTransaction(address updAds, bool isEx)
751         public
752         onlyOwner
753     {
754         _isExcludedMaxTransactionAmount[updAds] = isEx;
755     }
756 
757     function updateBuyFees(
758         uint256 _AFee,
759         uint256 _BFee,
760         uint256 _CFee,
761         uint256 _liquidityFee,
762         uint256 _autoBurnFee
763     ) external onlyOwner {
764         buyAFee = _AFee;
765         buyBFee = _BFee;
766         buyCFee = _CFee;
767         buyLiquidityFee = _liquidityFee;
768         buyAutoBurnFee = _autoBurnFee;
769         buyTotalFees =
770             buyAFee +
771             buyBFee +
772             buyCFee +
773             buyLiquidityFee +
774             buyAutoBurnFee;
775     }
776 
777     function updateSellFees(
778         uint256 _AFee,
779         uint256 _BFee,
780         uint256 _CFee,
781         uint256 _liquidityFee,
782         uint256 _autoBurnFee
783     ) external onlyOwner {
784         sellAFee = _AFee;
785         sellBFee = _BFee;
786         sellCFee = _CFee;
787         sellLiquidityFee = _liquidityFee;
788         sellAutoBurnFee = _autoBurnFee;
789         sellTotalFees =
790             sellAFee +
791             sellBFee +
792             sellCFee +
793             sellLiquidityFee +
794             sellAutoBurnFee;
795     }
796 
797     function excludeFromFees(address account, bool excluded) public onlyOwner {
798         _isExcludedFromFees[account] = excluded;
799         emit ExcludeFromFees(account, excluded);
800     }
801 
802     function setAutomatedMarketMakerPair(address pair, bool value)
803         public
804         onlyOwner
805     {
806         require(
807             pair != uniswapV2Pair,
808             "The pair cannot be removed from automatedMarketMakerPairs"
809         );
810 
811         _setAutomatedMarketMakerPair(pair, value);
812     }
813 
814     function _setAutomatedMarketMakerPair(address pair, bool value) private {
815         automatedMarketMakerPairs[pair] = value;
816 
817         emit SetAutomatedMarketMakerPair(pair, value);
818     }
819 
820     function updateAWallet(address newAWallet) external onlyOwner {
821         emit AWalletUpdated(newAWallet, AWallet);
822         AWallet = newAWallet;
823     }
824 
825     function updateBWallet(address newBWallet) external onlyOwner {
826         emit BWalletUpdated(newBWallet, BWallet);
827         BWallet = newBWallet;
828     }
829 
830     function updateCWallet(address newWallet) external onlyOwner {
831         emit CWalletUpdated(newWallet, CWallet);
832         CWallet = newWallet;
833     }
834 
835     function isExcludedFromFees(address account) public view returns (bool) {
836         return _isExcludedFromFees[account];
837     }
838 
839     function addBotInList(address _account) external onlyOwner {
840         require(
841             _account != address(uniswapV2Router),
842             "Can not blacklist router"
843         );
844         require(!isBot[_account], "Bot already added");
845         isBot[_account] = true;
846     }
847 
848     function removeBotFromList(address _account) external onlyOwner {
849         require(isBot[_account], "Bot not found");
850         isBot[_account] = false;
851     }
852 
853     function _transfer(
854         address from,
855         address to,
856         uint256 amount
857     ) internal override {
858         require(from != address(0), "ERC20: transfer from the zero address");
859         require(to != address(0), "ERC20: transfer to the zero address");
860         require(!isBot[to], "Bot detected");
861         require(!isBot[from], "Bot detected");
862 
863         if (amount == 0) {
864             super._transfer(from, to, 0);
865             return;
866         }
867 
868         if (limitsInEffect) {
869             if (
870                 from != owner() &&
871                 to != owner() &&
872                 to != address(0) &&
873                 to != address(0xdead) &&
874                 !swapping
875             ) {
876                 if (!tradingActive) {
877                     require(
878                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
879                         "Trading is not active."
880                     );
881                 }
882                 if (
883                     block.timestamp < launchedAtTimestamp + antiBot &&
884                     from != address(uniswapV2Router)
885                 ) {
886                     if (from == uniswapV2Pair) {
887                         isBot[to] = true;
888                     } else if (to == uniswapV2Pair) {
889                         isBot[from] = true;
890                     }
891                 }
892                 if (
893                     automatedMarketMakerPairs[from] &&
894                     !_isExcludedMaxTransactionAmount[to]
895                 ) {
896                     require(
897                         amount <= maxTransactionAmount,
898                         "Buy transfer amount exceeds the maxTransactionAmount."
899                     );
900                     require(
901                         amount + balanceOf(to) <= maxWallet,
902                         "Max wallet exceeded"
903                     );
904                 }
905                 else if (
906                     automatedMarketMakerPairs[to] &&
907                     !_isExcludedMaxTransactionAmount[from]
908                 ) {
909                     require(
910                         amount <= maxTransactionAmount,
911                         "Sell transfer amount exceeds the maxTransactionAmount."
912                     );
913                 } else if (!_isExcludedMaxTransactionAmount[to]) {
914                     require(
915                         amount + balanceOf(to) <= maxWallet,
916                         "Max wallet exceeded"
917                     );
918                 }
919             }
920         }
921 
922         uint256 contractTokenBalance = balanceOf(address(this));
923 
924         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
925 
926         if (
927             canSwap &&
928             !swapping &&
929             !automatedMarketMakerPairs[from] &&
930             !_isExcludedFromFees[from] &&
931             !_isExcludedFromFees[to]
932         ) {
933             swapping = true;
934 
935             swapBack();
936 
937             swapping = false;
938         }
939 
940         bool takeFee = !swapping;
941 
942         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
943             takeFee = false;
944         }
945 
946         uint256 fees = 0;
947         if (takeFee) {
948             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
949                 fees = amount.mul(sellTotalFees).div(100);
950                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
951                 tokensForB += (fees * sellCFee) / sellTotalFees;
952                 tokensForA += (fees * sellAFee) / sellTotalFees;
953                 tokensForC += (fees * sellCFee) / sellTotalFees;
954                 tokensForAutoburn = (fees * sellAutoBurnFee) / sellTotalFees;
955             }
956             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
957                 fees = amount.mul(buyTotalFees).div(100);
958                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
959                 tokensForB += (fees * buyCFee) / buyTotalFees;
960                 tokensForA += (fees * buyAFee) / buyTotalFees;
961                 tokensForC += (fees * buyCFee) / buyTotalFees;
962                 tokensForAutoburn = (fees * buyAutoBurnFee) / buyTotalFees;
963             }
964 
965             if (fees > 0) {
966                 _burn(from, tokensForAutoburn);
967                 super._transfer(from, address(this), fees - tokensForAutoburn);
968             }
969 
970             amount -= fees;
971         }
972 
973         super._transfer(from, to, amount);
974     }
975 
976     function swapTokensForEth(uint256 tokenAmount) private {
977         address[] memory path = new address[](2);
978         path[0] = address(this);
979         path[1] = uniswapV2Router.WETH();
980 
981         _approve(address(this), address(uniswapV2Router), tokenAmount);
982 
983         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
984             tokenAmount,
985             0,
986             path,
987             address(this),
988             block.timestamp
989         );
990     }
991 
992     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
993         _approve(address(this), address(uniswapV2Router), tokenAmount);
994 
995         uniswapV2Router.addLiquidityETH{value: ethAmount}(
996             address(this),
997             tokenAmount,
998             0, 
999             0, 
1000             deadAddress,
1001             block.timestamp
1002         );
1003     }
1004 
1005     function swapBack() private {
1006         uint256 contractBalance = balanceOf(address(this));
1007         uint256 totalTokensToSwap = tokensForLiquidity +
1008             tokensForA +
1009             tokensForB +
1010             tokensForC;
1011         bool success;
1012 
1013         if (contractBalance == 0 || totalTokensToSwap == 0) {
1014             return;
1015         }
1016 
1017         if (contractBalance > swapTokensAtAmount) {
1018             contractBalance = swapTokensAtAmount;
1019         }
1020 
1021         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1022             totalTokensToSwap /
1023             2;
1024         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1025 
1026         uint256 initialETHBalance = address(this).balance;
1027 
1028         swapTokensForEth(amountToSwapForETH);
1029 
1030         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1031 
1032         uint256 ethForA = ethBalance.mul(tokensForA).div(
1033             totalTokensToSwap
1034         );
1035         uint256 ethForB = ethBalance.mul(tokensForB).div(
1036             totalTokensToSwap
1037         );
1038         uint256 ethForC = ethBalance.mul(tokensForC).div(
1039             totalTokensToSwap
1040         );
1041         uint256 ethForLiquidity = ethBalance -
1042             ethForA -
1043             ethForB -
1044             ethForC;
1045 
1046         tokensForLiquidity = 0;
1047         tokensForA = 0;
1048         tokensForB = 0;
1049         tokensForC = 0;
1050 
1051         (success, ) = address(BWallet).call{value: ethForB}("");
1052 
1053         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1054             addLiquidity(liquidityTokens, ethForLiquidity);
1055             emit SwapAndLiquify(
1056                 amountToSwapForETH,
1057                 ethForLiquidity,
1058                 tokensForLiquidity
1059             );
1060         }
1061 
1062         (success, ) = address(AWallet).call{value: ethForA}("");
1063         (success, ) = address(CWallet).call{
1064             value: address(this).balance
1065         }("");
1066     }
1067 
1068     function withdrawETH(uint256 _amount) external onlyOwner {
1069         require(address(this).balance >= _amount, "Invalid Amount");
1070         payable(msg.sender).transfer(_amount);
1071     }
1072 }