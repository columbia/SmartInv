1 // SPDX-License-Identifier: MIT
2 /**
3  * https://ww3pepe.com/
4  * https://t.me/WW3PEPEToken
5  * https://X.com/ww3pepe
6  */
7 pragma solidity >=0.8.19;
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
27     /**
28      * @dev Initializes the contract setting the deployer as the initial owner.
29      */
30     constructor() {
31         address msgSender = _msgSender();
32         _owner = msgSender;
33         emit OwnershipTransferred(address(0), msgSender);
34     }
35 
36     /**
37      * @dev Returns the address of the current owner.
38      */
39     function owner() public view returns (address) {
40         return _owner;
41     }
42 
43     /**
44      * @dev Throws if called by any account other than the owner.
45      */
46     modifier onlyOwner() {
47         require(_owner == _msgSender(), "Ownable: caller is not the owner");
48         _;
49     }
50 
51     /**
52      * @dev Leaves the contract without owner. It will not be possible to call
53      * `onlyOwner` functions anymore. Can only be called by the current owner.
54      *
55      * NOTE: Renouncing ownership will leave the contract without an owner,
56      * thereby removing any functionality that is only available to the owner.
57      */
58     function renounceOwnership() public virtual onlyOwner {
59         emit OwnershipTransferred(_owner, address(0));
60         _owner = address(0);
61     }
62 
63     /**
64      * @dev Transfers ownership of the contract to a new account (`newOwner`).
65      * Can only be called by the current owner.
66      */
67     function transferOwnership(address newOwner) public virtual onlyOwner {
68         require(
69             newOwner != address(0),
70             "Ownable: new owner is the zero address"
71         );
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 }
76 
77 interface IERC20 {
78     function totalSupply() external view returns (uint256);
79 
80     function balanceOf(address account) external view returns (uint256);
81 
82     function transfer(
83         address recipient,
84         uint256 amount
85     ) external returns (bool);
86 
87     function allowance(
88         address owner,
89         address spender
90     ) external view returns (uint256);
91 
92     function approve(address spender, uint256 amount) external returns (bool);
93 
94     function transferFrom(
95         address sender,
96         address recipient,
97         uint256 amount
98     ) external returns (bool);
99 
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 
102     event Approval(
103         address indexed owner,
104         address indexed spender,
105         uint256 value
106     );
107 }
108 
109 interface IERC20Metadata is IERC20 {
110     function name() external view returns (string memory);
111 
112     function symbol() external view returns (string memory);
113 
114     function decimals() external view returns (uint8);
115 }
116 
117 interface IERC20Errors {
118     error ERC20InsufficientBalance(
119         address sender,
120         uint256 balance,
121         uint256 needed
122     );
123     error ERC20InvalidSender(address sender);
124     error ERC20InvalidReceiver(address receiver);
125     error ERC20InsufficientAllowance(
126         address spender,
127         uint256 allowance,
128         uint256 needed
129     );
130     error ERC20InvalidApprover(address approver);
131     error ERC20InvalidSpender(address spender);
132 }
133 
134 abstract contract ERC20 is Context, IERC20, IERC20Metadata, IERC20Errors {
135     mapping(address account => uint256) private _balances;
136 
137     mapping(address account => mapping(address spender => uint256))
138         private _allowances;
139 
140     uint256 private _totalSupply;
141 
142     string private _name;
143     string private _symbol;
144 
145     error ERC20FailedDecreaseAllowance(
146         address spender,
147         uint256 currentAllowance,
148         uint256 requestedDecrease
149     );
150 
151     constructor(string memory name_, string memory symbol_) {
152         _name = name_;
153         _symbol = symbol_;
154     }
155 
156     function name() public view virtual returns (string memory) {
157         return _name;
158     }
159 
160     function symbol() public view virtual returns (string memory) {
161         return _symbol;
162     }
163 
164     function decimals() public view virtual returns (uint8) {
165         return 18;
166     }
167 
168     function totalSupply() public view virtual returns (uint256) {
169         return _totalSupply;
170     }
171 
172     function balanceOf(address account) public view virtual returns (uint256) {
173         return _balances[account];
174     }
175 
176     function transfer(address to, uint256 value) public virtual returns (bool) {
177         address owner = _msgSender();
178         _transfer(owner, to, value);
179         return true;
180     }
181 
182     function allowance(
183         address owner,
184         address spender
185     ) public view virtual returns (uint256) {
186         return _allowances[owner][spender];
187     }
188 
189     function approve(
190         address spender,
191         uint256 value
192     ) public virtual returns (bool) {
193         address owner = _msgSender();
194         _approve(owner, spender, value);
195         return true;
196     }
197 
198     function transferFrom(
199         address from,
200         address to,
201         uint256 value
202     ) public virtual returns (bool) {
203         address spender = _msgSender();
204         _spendAllowance(from, spender, value);
205         _transfer(from, to, value);
206         return true;
207     }
208 
209     function increaseAllowance(
210         address spender,
211         uint256 addedValue
212     ) public virtual returns (bool) {
213         address owner = _msgSender();
214         _approve(owner, spender, allowance(owner, spender) + addedValue);
215         return true;
216     }
217 
218     function decreaseAllowance(
219         address spender,
220         uint256 requestedDecrease
221     ) public virtual returns (bool) {
222         address owner = _msgSender();
223         uint256 currentAllowance = allowance(owner, spender);
224         if (currentAllowance < requestedDecrease) {
225             revert ERC20FailedDecreaseAllowance(
226                 spender,
227                 currentAllowance,
228                 requestedDecrease
229             );
230         }
231         unchecked {
232             _approve(owner, spender, currentAllowance - requestedDecrease);
233         }
234 
235         return true;
236     }
237 
238     function _transfer(address from, address to, uint256 value) internal {
239         if (from == address(0)) {
240             revert ERC20InvalidSender(address(0));
241         }
242         if (to == address(0)) {
243             revert ERC20InvalidReceiver(address(0));
244         }
245         _update(from, to, value);
246     }
247 
248     function _update(address from, address to, uint256 value) internal virtual {
249         if (from == address(0)) {
250             // Overflow check required: The rest of the code assumes that totalSupply never overflows
251             _totalSupply += value;
252         } else {
253             uint256 fromBalance = _balances[from];
254             if (fromBalance < value) {
255                 revert ERC20InsufficientBalance(from, fromBalance, value);
256             }
257             unchecked {
258                 // Overflow not possible: value <= fromBalance <= totalSupply.
259                 _balances[from] = fromBalance - value;
260             }
261         }
262 
263         if (to == address(0)) {
264             unchecked {
265                 // Overflow not possible: value <= totalSupply or value <= fromBalance <= totalSupply.
266                 _totalSupply -= value;
267             }
268         } else {
269             unchecked {
270                 // Overflow not possible: balance + value is at most totalSupply, which we know fits into a uint256.
271                 _balances[to] += value;
272             }
273         }
274 
275         emit Transfer(from, to, value);
276     }
277 
278     function _mint(address account, uint256 value) internal {
279         if (account == address(0)) {
280             revert ERC20InvalidReceiver(address(0));
281         }
282         _update(address(0), account, value);
283     }
284 
285     function _burn(address account, uint256 value) internal {
286         if (account == address(0)) {
287             revert ERC20InvalidSender(address(0));
288         }
289         _update(account, address(0), value);
290     }
291 
292     function _approve(address owner, address spender, uint256 value) internal {
293         _approve(owner, spender, value, true);
294     }
295 
296     function _approve(
297         address owner,
298         address spender,
299         uint256 value,
300         bool emitEvent
301     ) internal virtual {
302         if (owner == address(0)) {
303             revert ERC20InvalidApprover(address(0));
304         }
305         if (spender == address(0)) {
306             revert ERC20InvalidSpender(address(0));
307         }
308         _allowances[owner][spender] = value;
309         if (emitEvent) {
310             emit Approval(owner, spender, value);
311         }
312     }
313 
314     function _spendAllowance(
315         address owner,
316         address spender,
317         uint256 value
318     ) internal virtual {
319         uint256 currentAllowance = allowance(owner, spender);
320         if (currentAllowance != type(uint256).max) {
321             if (currentAllowance < value) {
322                 revert ERC20InsufficientAllowance(
323                     spender,
324                     currentAllowance,
325                     value
326                 );
327             }
328             unchecked {
329                 _approve(owner, spender, currentAllowance - value, false);
330             }
331         }
332     }
333 }
334 
335 library SafeMath {
336     function tryAdd(
337         uint256 a,
338         uint256 b
339     ) internal pure returns (bool, uint256) {
340         unchecked {
341             uint256 c = a + b;
342             if (c < a) return (false, 0);
343             return (true, c);
344         }
345     }
346 
347     function trySub(
348         uint256 a,
349         uint256 b
350     ) internal pure returns (bool, uint256) {
351         unchecked {
352             if (b > a) return (false, 0);
353             return (true, a - b);
354         }
355     }
356 
357     function tryMul(
358         uint256 a,
359         uint256 b
360     ) internal pure returns (bool, uint256) {
361         unchecked {
362             if (a == 0) return (true, 0);
363             uint256 c = a * b;
364             if (c / a != b) return (false, 0);
365             return (true, c);
366         }
367     }
368 
369     function tryDiv(
370         uint256 a,
371         uint256 b
372     ) internal pure returns (bool, uint256) {
373         unchecked {
374             if (b == 0) return (false, 0);
375             return (true, a / b);
376         }
377     }
378 
379     function tryMod(
380         uint256 a,
381         uint256 b
382     ) internal pure returns (bool, uint256) {
383         unchecked {
384             if (b == 0) return (false, 0);
385             return (true, a % b);
386         }
387     }
388 
389     function add(uint256 a, uint256 b) internal pure returns (uint256) {
390         return a + b;
391     }
392 
393     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
394         return a - b;
395     }
396 
397     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
398         return a * b;
399     }
400 
401     function div(uint256 a, uint256 b) internal pure returns (uint256) {
402         return a / b;
403     }
404 
405     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
406         return a % b;
407     }
408 
409     function sub(
410         uint256 a,
411         uint256 b,
412         string memory errorMessage
413     ) internal pure returns (uint256) {
414         unchecked {
415             require(b <= a, errorMessage);
416             return a - b;
417         }
418     }
419 
420     function div(
421         uint256 a,
422         uint256 b,
423         string memory errorMessage
424     ) internal pure returns (uint256) {
425         unchecked {
426             require(b > 0, errorMessage);
427             return a / b;
428         }
429     }
430 
431     function mod(
432         uint256 a,
433         uint256 b,
434         string memory errorMessage
435     ) internal pure returns (uint256) {
436         unchecked {
437             require(b > 0, errorMessage);
438             return a % b;
439         }
440     }
441 }
442 
443 interface IDexFactory {
444     event PairCreated(
445         address indexed token0,
446         address indexed token1,
447         address pair,
448         uint256
449     );
450 
451     function feeTo() external view returns (address);
452 
453     function feeToSetter() external view returns (address);
454 
455     function getPair(
456         address tokenA,
457         address tokenB
458     ) external view returns (address pair);
459 
460     function allPairs(uint256) external view returns (address pair);
461 
462     function allPairsLength() external view returns (uint256);
463 
464     function createPair(
465         address tokenA,
466         address tokenB
467     ) external returns (address pair);
468 
469     function setFeeTo(address) external;
470 
471     function setFeeToSetter(address) external;
472 }
473 
474 interface IUniswapV2Pair {
475     event Approval(
476         address indexed owner,
477         address indexed spender,
478         uint256 value
479     );
480     event Transfer(address indexed from, address indexed to, uint256 value);
481 
482     function name() external pure returns (string memory);
483 
484     function symbol() external pure returns (string memory);
485 
486     function decimals() external pure returns (uint8);
487 
488     function totalSupply() external view returns (uint256);
489 
490     function balanceOf(address owner) external view returns (uint256);
491 
492     function allowance(
493         address owner,
494         address spender
495     ) external view returns (uint256);
496 
497     function approve(address spender, uint256 value) external returns (bool);
498 
499     function transfer(address to, uint256 value) external returns (bool);
500 
501     function transferFrom(
502         address from,
503         address to,
504         uint256 value
505     ) external returns (bool);
506 
507     function DOMAIN_SEPARATOR() external view returns (bytes32);
508 
509     function PERMIT_TYPEHASH() external pure returns (bytes32);
510 
511     function nonces(address owner) external view returns (uint256);
512 
513     function permit(
514         address owner,
515         address spender,
516         uint256 value,
517         uint256 deadline,
518         uint8 v,
519         bytes32 r,
520         bytes32 s
521     ) external;
522 
523     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
524     event Burn(
525         address indexed sender,
526         uint256 amount0,
527         uint256 amount1,
528         address indexed to
529     );
530     event Swap(
531         address indexed sender,
532         uint256 amount0In,
533         uint256 amount1In,
534         uint256 amount0Out,
535         uint256 amount1Out,
536         address indexed to
537     );
538     event Sync(uint112 reserve0, uint112 reserve1);
539 
540     function MINIMUM_LIQUIDITY() external pure returns (uint256);
541 
542     function factory() external view returns (address);
543 
544     function token0() external view returns (address);
545 
546     function token1() external view returns (address);
547 
548     function getReserves()
549         external
550         view
551         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
552 
553     function price0CumulativeLast() external view returns (uint256);
554 
555     function price1CumulativeLast() external view returns (uint256);
556 
557     function kLast() external view returns (uint256);
558 
559     function mint(address to) external returns (uint256 liquidity);
560 
561     function burn(
562         address to
563     ) external returns (uint256 amount0, uint256 amount1);
564 
565     function swap(
566         uint256 amount0Out,
567         uint256 amount1Out,
568         address to,
569         bytes calldata data
570     ) external;
571 
572     function skim(address to) external;
573 
574     function sync() external;
575 
576     function initialize(address, address) external;
577 }
578 
579 interface IDexRouter02 {
580     function factory() external pure returns (address);
581 
582     function WETH() external pure returns (address);
583 
584     function addLiquidity(
585         address tokenA,
586         address tokenB,
587         uint256 amountADesired,
588         uint256 amountBDesired,
589         uint256 amountAMin,
590         uint256 amountBMin,
591         address to,
592         uint256 deadline
593     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
594 
595     function addLiquidityETH(
596         address token,
597         uint256 amountTokenDesired,
598         uint256 amountTokenMin,
599         uint256 amountETHMin,
600         address to,
601         uint256 deadline
602     )
603         external
604         payable
605         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
606 
607     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
608         uint256 amountIn,
609         uint256 amountOutMin,
610         address[] calldata path,
611         address to,
612         uint256 deadline
613     ) external;
614 
615     function swapExactETHForTokensSupportingFeeOnTransferTokens(
616         uint256 amountOutMin,
617         address[] calldata path,
618         address to,
619         uint256 deadline
620     ) external payable;
621 
622     function swapExactTokensForETHSupportingFeeOnTransferTokens(
623         uint256 amountIn,
624         uint256 amountOutMin,
625         address[] calldata path,
626         address to,
627         uint256 deadline
628     ) external;
629 }
630 
631 contract WW3Pepe is ERC20, Ownable {
632     using SafeMath for uint256;
633 
634     IDexRouter02 private immutable _dexRouter;
635     address public immutable _dexPair;
636 
637     bool private onSwpBck;
638 
639     address public mktFeeReceiver;
640 
641     uint256 private _minSwapbackValue;
642     uint256 private _maxSwapbackValue;
643 
644     uint256 public _txLimit;
645     uint256 public _WalletLimit;
646 
647     uint256 public _feeOnBuys;
648     uint256 public _feeOnSells;
649 
650     bool public _antiWhaleOn = true;
651     bool public _tradingEnabled = false;
652 
653     mapping(address => bool) private feeExmpt;
654     mapping(address => bool) private _WalletLimitExmpt;
655 
656     mapping(address => bool) public _dexPairs;
657 
658     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
659 
660     event TaxesSwaped(uint256 tokensSwapped, uint256 ethReceived);
661 
662     constructor() ERC20("WW3 Pepe", "PEPE") {
663         IDexRouter02 __dexRouter = IDexRouter02(
664             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
665         );
666 
667         _dexRouter = __dexRouter;
668 
669         _dexPair = IDexFactory(__dexRouter.factory()).createPair(
670             address(this),
671             __dexRouter.WETH()
672         );
673         _setDexPair(address(_dexPair), true);
674 
675         uint256 totalSupply = 1_000_000 * 1e18;
676 
677         _txLimit = (totalSupply) / 100;
678         _WalletLimit = (totalSupply) / 100;
679 
680         _feeOnBuys = 25;
681         _feeOnSells = 25;
682 
683         _minSwapbackValue = (totalSupply * 5) / 10000;
684         _maxSwapbackValue = (totalSupply * 1) / 100;
685 
686         mktFeeReceiver = address(msg.sender);
687 
688         feeExmpt[msg.sender] = true;
689         feeExmpt[mktFeeReceiver] = true;
690         feeExmpt[address(this)] = true;
691         feeExmpt[address(0xdead)] = true;
692 
693         _WalletLimitExmpt[owner()] = true;
694         _WalletLimitExmpt[address(this)] = true;
695         _WalletLimitExmpt[address(0xdead)] = true;
696         _WalletLimitExmpt[mktFeeReceiver] = true;
697 
698         _mint(msg.sender, totalSupply);
699     }
700 
701     receive() external payable {}
702 
703     function declareWar() external onlyOwner {
704         _tradingEnabled = true;
705     }
706 
707     function setMktFeeReceiver(address newMktFeeReceiver) external onlyOwner {
708         mktFeeReceiver = newMktFeeReceiver;
709     }
710 
711     function setFeeOnBuys(uint256 buyFee) external onlyOwner {
712         _feeOnBuys = buyFee;
713         require(_feeOnBuys <= 25, "Buy fee can't be more than 25%");
714     }
715 
716     function setFeeOnSells(uint256 sellFee) external onlyOwner {
717         _feeOnSells = sellFee;
718         require(_feeOnSells <= 25, "Sell fee can't be more than 25%");
719     }
720 
721     function antiWhaleOff() external onlyOwner {
722         _antiWhaleOn = false;
723     }
724 
725     function setTxLimit(uint256 maxTx) external onlyOwner {
726         require(maxTx >= 5, "Max tx can't be less than 0.5%");
727         _txLimit = (maxTx * totalSupply()) / 10000;
728     }
729 
730     function setWalletLimit(uint256 maxWallet) external onlyOwner {
731         require(maxWallet >= 5, "Max wallet can't be less than 0.5%");
732         _WalletLimit = (maxWallet * totalSupply()) / 10000;
733     }
734 
735     function setSwapbackValue(
736         uint256 newMin,
737         uint256 newMax
738     ) external onlyOwner {
739         require(newMin <= 5, "Min swapback value can't be more than 0.5%");
740         require(
741             newMax >= newMin,
742             "Max swapback value can't be lower than the minimun"
743         );
744         _minSwapbackValue = (newMin * totalSupply()) / 10000;
745         _maxSwapbackValue = (newMax * totalSupply()) / 10000;
746     }
747 
748     function _setDexPair(address pair, bool value) private {
749         _dexPairs[pair] = value;
750 
751         emit SetAutomatedMarketMakerPair(pair, value);
752     }
753 
754     function triggerContractSell() private {
755         uint256 tokenBalance = balanceOf(address(this));
756         bool success;
757 
758         if (tokenBalance == 0) {
759             return;
760         }
761 
762         if (tokenBalance > _maxSwapbackValue) {
763             tokenBalance = _maxSwapbackValue;
764         }
765 
766         address[] memory path = new address[](2);
767         path[0] = address(this);
768         path[1] = _dexRouter.WETH();
769 
770         _approve(address(this), address(_dexRouter), tokenBalance);
771 
772         // make the swap
773         _dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
774             tokenBalance,
775             0, // accept any amount of ETH
776             path,
777             address(this),
778             block.timestamp
779         );
780 
781         emit TaxesSwaped(tokenBalance, address(this).balance);
782 
783         (success, ) = address(mktFeeReceiver).call{
784             value: address(this).balance
785         }("");
786     }
787 
788     function _update(
789         address from,
790         address to,
791         uint256 amount
792     ) internal override {
793         if (amount == 0) {
794             super._update(from, to, 0);
795             return;
796         }
797 
798         if (_antiWhaleOn) {
799             if (
800                 from != owner() &&
801                 to != owner() &&
802                 to != address(0) &&
803                 to != address(0xdead) &&
804                 !onSwpBck
805             ) {
806                 if (!_tradingEnabled) {
807                     require(
808                         feeExmpt[from] || feeExmpt[to],
809                         "Trading is not active."
810                     );
811                 }
812                 //when buy
813                 if (_dexPairs[from] && !_WalletLimitExmpt[to]) {
814                     require(
815                         amount <= _txLimit,
816                         "Buy transfer amount exceeds the _txLimit."
817                     );
818                     require(
819                         amount + balanceOf(to) <= _WalletLimit,
820                         "Max wallet exceeded"
821                     );
822                 }
823                 //when sell
824                 else if (_dexPairs[to] && !_WalletLimitExmpt[from]) {
825                     require(
826                         amount <= _txLimit,
827                         "Sell transfer amount exceeds the _txLimit."
828                     );
829                 } else if (!_WalletLimitExmpt[to]) {
830                     require(
831                         amount + balanceOf(to) <= _WalletLimit,
832                         "Max wallet exceeded"
833                     );
834                 }
835             }
836         }
837 
838         uint256 contractTokenBalance = balanceOf(address(this));
839 
840         bool canSwap = contractTokenBalance >= _minSwapbackValue;
841 
842         if (
843             canSwap &&
844             !onSwpBck &&
845             !_dexPairs[from] &&
846             !feeExmpt[from] &&
847             !feeExmpt[to]
848         ) {
849             onSwpBck = true;
850 
851             triggerContractSell();
852 
853             onSwpBck = false;
854         }
855 
856         bool takeFee = !onSwpBck;
857 
858         // if any account belongs to _isExcludedFromFee account then remove the fee
859         if (feeExmpt[from] || feeExmpt[to]) {
860             takeFee = false;
861         }
862 
863         uint256 fees = 0;
864         // only take fees on buys/sells, do not take on wallet transfers
865         if (takeFee) {
866             // on sell
867             if (_dexPairs[to] && _feeOnSells > 0) {
868                 fees = amount.mul(_feeOnSells).div(100);
869             }
870             // on buy
871             else if (_dexPairs[from] && _feeOnBuys > 0) {
872                 fees = amount.mul(_feeOnBuys).div(100);
873             }
874 
875             if (fees > 0) {
876                 super._update(from, address(this), fees);
877             }
878 
879             amount -= fees;
880         }
881 
882         super._update(from, to, amount);
883     }
884 }