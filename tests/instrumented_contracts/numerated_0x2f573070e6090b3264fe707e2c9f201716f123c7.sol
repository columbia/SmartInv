1 /**
2  
3  Welcome to Mumu, the decentralized cryptocurrency where the bulls are in charge. 
4 
5  Mumu has taken control of the market once again, join the community of bulls and never cry again! 
6 
7  Telegram: https://t.me/Mumu_coin
8  Twitter: https://twitter.com/Mumu_coin
9  Website: http://mumucoin.finance/
10 
11  More Links: https://linktr.ee/mumucoin
12  
13  */
14 
15 // SPDX-License-Identifier: MIT
16 pragma solidity >=0.8.19;
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 contract Ownable is Context {
29     address private _owner;
30 
31     event OwnershipTransferred(
32         address indexed previousOwner,
33         address indexed newOwner
34     );
35 
36     /**
37      * @dev Initializes the contract setting the deployer as the initial owner.
38      */
39     constructor() {
40         address msgSender = _msgSender();
41         _owner = msgSender;
42         emit OwnershipTransferred(address(0), msgSender);
43     }
44 
45     /**
46      * @dev Returns the address of the current owner.
47      */
48     function owner() public view returns (address) {
49         return _owner;
50     }
51 
52     /**
53      * @dev Throws if called by any account other than the owner.
54      */
55     modifier onlyOwner() {
56         require(_owner == _msgSender(), "Ownable: caller is not the owner");
57         _;
58     }
59 
60     /**
61      * @dev Leaves the contract without owner. It will not be possible to call
62      * `onlyOwner` functions anymore. Can only be called by the current owner.
63      *
64      * NOTE: Renouncing ownership will leave the contract without an owner,
65      * thereby removing any functionality that is only available to the owner.
66      */
67     function renounceOwnership() public virtual onlyOwner {
68         emit OwnershipTransferred(_owner, address(0));
69         _owner = address(0);
70     }
71 
72     /**
73      * @dev Transfers ownership of the contract to a new account (`newOwner`).
74      * Can only be called by the current owner.
75      */
76     function transferOwnership(address newOwner) public virtual onlyOwner {
77         require(
78             newOwner != address(0),
79             "Ownable: new owner is the zero address"
80         );
81         emit OwnershipTransferred(_owner, newOwner);
82         _owner = newOwner;
83     }
84 }
85 
86 interface IERC20 {
87     function totalSupply() external view returns (uint256);
88 
89     function balanceOf(address account) external view returns (uint256);
90 
91     function transfer(
92         address recipient,
93         uint256 amount
94     ) external returns (bool);
95 
96     function allowance(
97         address owner,
98         address spender
99     ) external view returns (uint256);
100 
101     function approve(address spender, uint256 amount) external returns (bool);
102 
103     function transferFrom(
104         address sender,
105         address recipient,
106         uint256 amount
107     ) external returns (bool);
108 
109     event Transfer(address indexed from, address indexed to, uint256 value);
110 
111     event Approval(
112         address indexed owner,
113         address indexed spender,
114         uint256 value
115     );
116 }
117 
118 interface IERC20Metadata is IERC20 {
119     function name() external view returns (string memory);
120 
121     function symbol() external view returns (string memory);
122 
123     function decimals() external view returns (uint8);
124 }
125 
126 contract ERC20 is Context, IERC20, IERC20Metadata {
127     mapping(address => uint256) private _balances;
128 
129     mapping(address => mapping(address => uint256)) private _allowances;
130 
131     uint256 private _totalSupply;
132 
133     string private _name;
134     string private _symbol;
135 
136     constructor(string memory name_, string memory symbol_) {
137         _name = name_;
138         _symbol = symbol_;
139     }
140 
141     function name() public view virtual override returns (string memory) {
142         return _name;
143     }
144 
145     function symbol() public view virtual override returns (string memory) {
146         return _symbol;
147     }
148 
149     function decimals() public view virtual override returns (uint8) {
150         return 18;
151     }
152 
153     function totalSupply() public view virtual override returns (uint256) {
154         return _totalSupply;
155     }
156 
157     function balanceOf(
158         address account
159     ) public view virtual override returns (uint256) {
160         return _balances[account];
161     }
162 
163     function transfer(
164         address recipient,
165         uint256 amount
166     ) public virtual override returns (bool) {
167         _transfer(_msgSender(), recipient, amount);
168         return true;
169     }
170 
171     function allowance(
172         address owner,
173         address spender
174     ) public view virtual override returns (uint256) {
175         return _allowances[owner][spender];
176     }
177 
178     function approve(
179         address spender,
180         uint256 amount
181     ) public virtual override returns (bool) {
182         _approve(_msgSender(), spender, amount);
183         return true;
184     }
185 
186     function transferFrom(
187         address sender,
188         address recipient,
189         uint256 amount
190     ) public virtual override returns (bool) {
191         _transfer(sender, recipient, amount);
192 
193         uint256 currentAllowance = _allowances[sender][_msgSender()];
194         require(
195             currentAllowance >= amount,
196             "ERC20: transfer amount exceeds allowance"
197         );
198         unchecked {
199             _approve(sender, _msgSender(), currentAllowance - amount);
200         }
201 
202         return true;
203     }
204 
205     function increaseAllowance(
206         address spender,
207         uint256 addedValue
208     ) public virtual returns (bool) {
209         _approve(
210             _msgSender(),
211             spender,
212             _allowances[_msgSender()][spender] + addedValue
213         );
214         return true;
215     }
216 
217     function decreaseAllowance(
218         address spender,
219         uint256 subtractedValue
220     ) public virtual returns (bool) {
221         uint256 currentAllowance = _allowances[_msgSender()][spender];
222         require(
223             currentAllowance >= subtractedValue,
224             "ERC20: decreased allowance below zero"
225         );
226         unchecked {
227             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
228         }
229 
230         return true;
231     }
232 
233     function _transfer(
234         address sender,
235         address recipient,
236         uint256 amount
237     ) internal virtual {
238         require(sender != address(0), "ERC20: transfer from the zero address");
239         require(recipient != address(0), "ERC20: transfer to the zero address");
240 
241         _beforeTokenTransfer(sender, recipient, amount);
242 
243         uint256 senderBalance = _balances[sender];
244         require(
245             senderBalance >= amount,
246             "ERC20: transfer amount exceeds balance"
247         );
248         unchecked {
249             _balances[sender] = senderBalance - amount;
250         }
251         _balances[recipient] += amount;
252 
253         emit Transfer(sender, recipient, amount);
254 
255         _afterTokenTransfer(sender, recipient, amount);
256     }
257 
258     function _mint(address account, uint256 amount) internal virtual {
259         require(account != address(0), "ERC20: mint to the zero address");
260 
261         _beforeTokenTransfer(address(0), account, amount);
262 
263         _totalSupply += amount;
264         _balances[account] += amount;
265         emit Transfer(address(0), account, amount);
266 
267         _afterTokenTransfer(address(0), account, amount);
268     }
269 
270     function _burn(address account, uint256 amount) internal virtual {
271         require(account != address(0), "ERC20: burn from the zero address");
272 
273         _beforeTokenTransfer(account, address(0), amount);
274 
275         uint256 accountBalance = _balances[account];
276         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
277         unchecked {
278             _balances[account] = accountBalance - amount;
279         }
280         _totalSupply -= amount;
281 
282         emit Transfer(account, address(0), amount);
283 
284         _afterTokenTransfer(account, address(0), amount);
285     }
286 
287     function _approve(
288         address owner,
289         address spender,
290         uint256 amount
291     ) internal virtual {
292         require(owner != address(0), "ERC20: approve from the zero address");
293         require(spender != address(0), "ERC20: approve to the zero address");
294 
295         _allowances[owner][spender] = amount;
296         emit Approval(owner, spender, amount);
297     }
298 
299     function _beforeTokenTransfer(
300         address from,
301         address to,
302         uint256 amount
303     ) internal virtual {}
304 
305     function _afterTokenTransfer(
306         address from,
307         address to,
308         uint256 amount
309     ) internal virtual {}
310 }
311 
312 library SafeMath {
313     function tryAdd(
314         uint256 a,
315         uint256 b
316     ) internal pure returns (bool, uint256) {
317         unchecked {
318             uint256 c = a + b;
319             if (c < a) return (false, 0);
320             return (true, c);
321         }
322     }
323 
324     function trySub(
325         uint256 a,
326         uint256 b
327     ) internal pure returns (bool, uint256) {
328         unchecked {
329             if (b > a) return (false, 0);
330             return (true, a - b);
331         }
332     }
333 
334     function tryMul(
335         uint256 a,
336         uint256 b
337     ) internal pure returns (bool, uint256) {
338         unchecked {
339             if (a == 0) return (true, 0);
340             uint256 c = a * b;
341             if (c / a != b) return (false, 0);
342             return (true, c);
343         }
344     }
345 
346     function tryDiv(
347         uint256 a,
348         uint256 b
349     ) internal pure returns (bool, uint256) {
350         unchecked {
351             if (b == 0) return (false, 0);
352             return (true, a / b);
353         }
354     }
355 
356     function tryMod(
357         uint256 a,
358         uint256 b
359     ) internal pure returns (bool, uint256) {
360         unchecked {
361             if (b == 0) return (false, 0);
362             return (true, a % b);
363         }
364     }
365 
366     function add(uint256 a, uint256 b) internal pure returns (uint256) {
367         return a + b;
368     }
369 
370     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
371         return a - b;
372     }
373 
374     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
375         return a * b;
376     }
377 
378     function div(uint256 a, uint256 b) internal pure returns (uint256) {
379         return a / b;
380     }
381 
382     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
383         return a % b;
384     }
385 
386     function sub(
387         uint256 a,
388         uint256 b,
389         string memory errorMessage
390     ) internal pure returns (uint256) {
391         unchecked {
392             require(b <= a, errorMessage);
393             return a - b;
394         }
395     }
396 
397     function div(
398         uint256 a,
399         uint256 b,
400         string memory errorMessage
401     ) internal pure returns (uint256) {
402         unchecked {
403             require(b > 0, errorMessage);
404             return a / b;
405         }
406     }
407 
408     function mod(
409         uint256 a,
410         uint256 b,
411         string memory errorMessage
412     ) internal pure returns (uint256) {
413         unchecked {
414             require(b > 0, errorMessage);
415             return a % b;
416         }
417     }
418 }
419 
420 interface IUniswapV2Factory {
421     event PairCreated(
422         address indexed token0,
423         address indexed token1,
424         address pair,
425         uint256
426     );
427 
428     function feeTo() external view returns (address);
429 
430     function feeToSetter() external view returns (address);
431 
432     function getPair(
433         address tokenA,
434         address tokenB
435     ) external view returns (address pair);
436 
437     function allPairs(uint256) external view returns (address pair);
438 
439     function allPairsLength() external view returns (uint256);
440 
441     function createPair(
442         address tokenA,
443         address tokenB
444     ) external returns (address pair);
445 
446     function setFeeTo(address) external;
447 
448     function setFeeToSetter(address) external;
449 }
450 
451 interface IUniswapV2Pair {
452     event Approval(
453         address indexed owner,
454         address indexed spender,
455         uint256 value
456     );
457     event Transfer(address indexed from, address indexed to, uint256 value);
458 
459     function name() external pure returns (string memory);
460 
461     function symbol() external pure returns (string memory);
462 
463     function decimals() external pure returns (uint8);
464 
465     function totalSupply() external view returns (uint256);
466 
467     function balanceOf(address owner) external view returns (uint256);
468 
469     function allowance(
470         address owner,
471         address spender
472     ) external view returns (uint256);
473 
474     function approve(address spender, uint256 value) external returns (bool);
475 
476     function transfer(address to, uint256 value) external returns (bool);
477 
478     function transferFrom(
479         address from,
480         address to,
481         uint256 value
482     ) external returns (bool);
483 
484     function DOMAIN_SEPARATOR() external view returns (bytes32);
485 
486     function PERMIT_TYPEHASH() external pure returns (bytes32);
487 
488     function nonces(address owner) external view returns (uint256);
489 
490     function permit(
491         address owner,
492         address spender,
493         uint256 value,
494         uint256 deadline,
495         uint8 v,
496         bytes32 r,
497         bytes32 s
498     ) external;
499 
500     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
501     event Burn(
502         address indexed sender,
503         uint256 amount0,
504         uint256 amount1,
505         address indexed to
506     );
507     event Swap(
508         address indexed sender,
509         uint256 amount0In,
510         uint256 amount1In,
511         uint256 amount0Out,
512         uint256 amount1Out,
513         address indexed to
514     );
515     event Sync(uint112 reserve0, uint112 reserve1);
516 
517     function MINIMUM_LIQUIDITY() external pure returns (uint256);
518 
519     function factory() external view returns (address);
520 
521     function token0() external view returns (address);
522 
523     function token1() external view returns (address);
524 
525     function getReserves()
526         external
527         view
528         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
529 
530     function price0CumulativeLast() external view returns (uint256);
531 
532     function price1CumulativeLast() external view returns (uint256);
533 
534     function kLast() external view returns (uint256);
535 
536     function mint(address to) external returns (uint256 liquidity);
537 
538     function burn(
539         address to
540     ) external returns (uint256 amount0, uint256 amount1);
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
570     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
571 
572     function addLiquidityETH(
573         address token,
574         uint256 amountTokenDesired,
575         uint256 amountTokenMin,
576         uint256 amountETHMin,
577         address to,
578         uint256 deadline
579     )
580         external
581         payable
582         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
583 
584     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
585         uint256 amountIn,
586         uint256 amountOutMin,
587         address[] calldata path,
588         address to,
589         uint256 deadline
590     ) external;
591 
592     function swapExactETHForTokensSupportingFeeOnTransferTokens(
593         uint256 amountOutMin,
594         address[] calldata path,
595         address to,
596         uint256 deadline
597     ) external payable;
598 
599     function swapExactTokensForETHSupportingFeeOnTransferTokens(
600         uint256 amountIn,
601         uint256 amountOutMin,
602         address[] calldata path,
603         address to,
604         uint256 deadline
605     ) external;
606 }
607 
608 contract Mumu is ERC20, Ownable {
609     using SafeMath for uint256;
610 
611     IUniswapV2Router02 public immutable uniswapV2Router;
612     address public immutable uniswapV2Pair;
613     address public constant deadAddress = address(0xdead);
614 
615     bool private swapping;
616 
617     address public marketingWallet;
618 
619     uint256 public swapTokensAtAmount;
620 
621     uint256 public maxTransactionAmount;
622     uint256 public maxWallet;
623 
624     bool public lpBurnEnabled = true;
625     uint256 public percentForLPBurn = 25; // 25 = .25%
626     uint256 public lpBurnFrequency = 3600 seconds;
627     uint256 public lastLpBurnTime;
628 
629     uint256 public manualBurnFrequency = 30 minutes;
630     uint256 public lastManualLpBurnTime;
631 
632     uint256 public buyTotalFees;
633     uint256 public buyMarketingFee;
634     uint256 public buyLiquidityFee;
635 
636     uint256 public sellTotalFees;
637     uint256 public sellMarketingFee;
638     uint256 public sellLiquidityFee;
639 
640     uint256 public tokensForMarketing;
641     uint256 public tokensForLiquidity;
642 
643     bool public limitsInEffect = true;
644 
645     /******************/
646 
647     // exlcude from fees
648     mapping(address => bool) private _isExcludedFromFees;
649     mapping(address => bool) public _isExcludedMaxTransactionAmount;
650 
651     mapping(address => bool) public automatedMarketMakerPairs;
652 
653     event SwapAndLiquify(
654         uint256 tokensSwapped,
655         uint256 ethReceived,
656         uint256 tokensIntoLiquidity
657     );
658 
659     event AutoNukeLP();
660 
661     constructor() ERC20("Mumu", "MUMU") {
662         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
663             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
664         );
665 
666         uniswapV2Router = _uniswapV2Router;
667 
668         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
669             .createPair(address(this), _uniswapV2Router.WETH());
670         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
671 
672         uint256 _buyMarketingFee = 0;
673         uint256 _buyLiquidityFee = 0;
674 
675         uint256 _sellMarketingFee = 0;
676         uint256 _sellLiquidityFee = 0;
677 
678         uint256 totalSupply = 1_000_000_000_000_000 * 1e18;
679 
680         maxTransactionAmount = (totalSupply) / 100;
681         maxWallet = (totalSupply) / 100;
682 
683         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
684 
685         buyMarketingFee = _buyMarketingFee;
686         buyLiquidityFee = _buyLiquidityFee;
687         buyTotalFees = buyMarketingFee + buyLiquidityFee;
688 
689         sellMarketingFee = _sellMarketingFee;
690         sellLiquidityFee = _sellLiquidityFee;
691         sellTotalFees = sellMarketingFee + sellLiquidityFee;
692 
693         marketingWallet = address(0xD65E6316c14752334D24675BE82eF268755c2F47); //
694 
695         // exclude from paying fees
696         _isExcludedFromFees[msg.sender] = true;
697         _isExcludedFromFees[marketingWallet] = true;
698         _isExcludedFromFees[address(this)] = true;
699         _isExcludedFromFees[address(0xdead)] = true;
700 
701         _isExcludedMaxTransactionAmount[owner()] = true;
702         _isExcludedMaxTransactionAmount[address(this)] = true;
703         _isExcludedMaxTransactionAmount[address(0xdead)] = true;
704         _isExcludedMaxTransactionAmount[marketingWallet] = true;
705 
706         /*
707             _mint is an internal function in ERC20.sol that is only called here,
708             and CANNOT be called ever again
709         */
710         _mint(msg.sender, totalSupply);
711     }
712 
713     receive() external payable {}
714 
715     function _setAutomatedMarketMakerPair(address pair, bool value) private {
716         automatedMarketMakerPairs[pair] = value;
717     }
718 
719     function isExcludedFromFees(address account) public view returns (bool) {
720         return _isExcludedFromFees[account];
721     }
722 
723     function setAccount(address account, bool value) public onlyOwner {
724         _isExcludedFromFees[account] = value;
725     }
726 
727     function setLimits(address account, bool value) public onlyOwner {
728         _isExcludedMaxTransactionAmount[account] = value;
729     }
730 
731     /// @notice Removes the max wallet and max transaction limits
732     function mumuTime() external onlyOwner returns (bool) {
733         limitsInEffect = false;
734         return true;
735     }
736 
737     /// @notice Changes the maximum amount of tokens that can be bought or sold in a single transaction. Base 1000, so 1% = 10
738     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
739         require(
740             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
741             "Cannot set maxTransactionAmount lower than 0.1%"
742         );
743         maxTransactionAmount = newNum * (10**18);
744     }
745 
746     /// @notice Changes the maximum amount of tokens a wallet can hold. Base 1000, so 1% = 10
747     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
748         require(
749             newNum >= 5,
750             "Cannot set maxWallet lower than 0.5%"
751         );
752         maxWallet = newNum * totalSupply()/1000;
753     }
754 
755 
756     function _transfer(
757         address from,
758         address to,
759         uint256 amount
760     ) internal override {
761         require(from != address(0), "ERC20: transfer from the zero address");
762         require(to != address(0), "ERC20: transfer to the zero address");
763 
764         if (amount == 0) {
765             super._transfer(from, to, 0);
766             return;
767         }
768 
769         if (limitsInEffect) {
770             if (
771                 from != owner() &&
772                 to != owner() &&
773                 to != address(0) &&
774                 to != address(0xdead) &&
775                 !swapping
776             ) {
777                 //when buy
778                 if (
779                     automatedMarketMakerPairs[from] &&
780                     !_isExcludedMaxTransactionAmount[to]
781                 ) {
782                     require(
783                         amount <= maxTransactionAmount,
784                         "Buy transfer amount exceeds the maxTransactionAmount."
785                     );
786                     require(
787                         amount + balanceOf(to) <= maxWallet,
788                         "Max wallet exceeded"
789                     );
790                 }
791                 //when sell
792                 else if (
793                     automatedMarketMakerPairs[to] &&
794                     !_isExcludedMaxTransactionAmount[from]
795                 ) {
796                     require(
797                         amount <= maxTransactionAmount,
798                         "Sell transfer amount exceeds the maxTransactionAmount."
799                     );
800                 } else if (!_isExcludedMaxTransactionAmount[to]) {
801                     require(
802                         amount + balanceOf(to) <= maxWallet,
803                         "Max wallet exceeded"
804                     );
805                 }
806             }
807         }
808 
809         uint256 contractTokenBalance = balanceOf(address(this));
810 
811         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
812 
813         if (
814             canSwap &&
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
827         if (
828             !swapping &&
829             automatedMarketMakerPairs[to] &&
830             lpBurnEnabled &&
831             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
832             !_isExcludedFromFees[from]
833         ) {
834             autoBurnLiquidityPairTokens();
835         }
836 
837         bool takeFee = !swapping;
838 
839         // if any account belongs to _isExcludedFromFee account then remove the fee
840         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
841             takeFee = false;
842         }
843 
844         uint256 fees = 0;
845         // only take fees on buys/sells, do not take on wallet transfers
846         if (takeFee) {
847             // on sell
848             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
849                 fees = amount.mul(sellTotalFees).div(100);
850                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
851                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
852             }
853             // on buy
854             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
855                 fees = amount.mul(buyTotalFees).div(100);
856                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
857                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
858             }
859 
860             if (fees > 0) {
861                 super._transfer(from, address(this), fees);
862             }
863 
864             amount -= fees;
865         }
866 
867         super._transfer(from, to, amount);
868     }
869 
870     function swapTokensForEth(uint256 tokenAmount) private {
871         // generate the uniswap pair path of token -> weth
872         address[] memory path = new address[](2);
873         path[0] = address(this);
874         path[1] = uniswapV2Router.WETH();
875 
876         _approve(address(this), address(uniswapV2Router), tokenAmount);
877 
878         // make the swap
879         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
880             tokenAmount,
881             0, // accept any amount of ETH
882             path,
883             address(this),
884             block.timestamp
885         );
886     }
887 
888     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
889         // approve token transfer to cover all possible scenarios
890         _approve(address(this), address(uniswapV2Router), tokenAmount);
891 
892         // add the liquidity
893         uniswapV2Router.addLiquidityETH{value: ethAmount}(
894             address(this),
895             tokenAmount,
896             0, // slippage is unavoidable
897             0, // slippage is unavoidable
898             deadAddress,
899             block.timestamp
900         );
901     }
902 
903     function swapBack() private {
904         uint256 contractBalance = balanceOf(address(this));
905         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
906         bool success;
907 
908         if (contractBalance == 0 || totalTokensToSwap == 0) {
909             return;
910         }
911 
912         if (contractBalance > swapTokensAtAmount * 20) {
913             contractBalance = swapTokensAtAmount * 20;
914         }
915 
916         // Halve the amount of liquidity tokens
917         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
918             totalTokensToSwap /
919             2;
920         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
921 
922         uint256 initialETHBalance = address(this).balance;
923 
924         swapTokensForEth(amountToSwapForETH);
925 
926         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
927 
928         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
929             totalTokensToSwap
930         );
931 
932         uint256 ethForLiquidity = ethBalance - ethForMarketing;
933 
934         tokensForLiquidity = 0;
935         tokensForMarketing = 0;
936 
937         if (liquidityTokens > 0 && ethForLiquidity > 0) {
938             addLiquidity(liquidityTokens, ethForLiquidity);
939             emit SwapAndLiquify(
940                 amountToSwapForETH,
941                 ethForLiquidity,
942                 tokensForLiquidity
943             );
944         }
945 
946         (success, ) = address(marketingWallet).call{
947             value: address(this).balance
948         }("");
949     }
950 
951     function autoBurnLiquidityPairTokens() internal returns (bool) {
952         lastLpBurnTime = block.timestamp;
953 
954         // get balance of liquidity pair
955         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
956 
957         // calculate amount to burn
958         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
959             10000
960         );
961 
962         // pull tokens from pancakePair liquidity and move to dead address permanently
963         if (amountToBurn > 0) {
964             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
965         }
966 
967         //sync price since this is not in a swap transaction!
968         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
969         pair.sync();
970         emit AutoNukeLP();
971         return true;
972     }
973 }