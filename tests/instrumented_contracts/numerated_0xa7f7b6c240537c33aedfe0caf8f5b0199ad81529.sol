1 /**
2 
3 The bit size version of your favourite memecoin
4 
5 https://twitter.com/bitpepecoin
6 https://t.me/bitpepecoin
7  
8  */
9 
10 // SPDX-License-Identifier: MIT
11 pragma solidity >=0.8.19;
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
31     /**
32      * @dev Initializes the contract setting the deployer as the initial owner.
33      */
34     constructor() {
35         address msgSender = _msgSender();
36         _owner = msgSender;
37         emit OwnershipTransferred(address(0), msgSender);
38     }
39 
40     /**
41      * @dev Returns the address of the current owner.
42      */
43     function owner() public view returns (address) {
44         return _owner;
45     }
46 
47     /**
48      * @dev Throws if called by any account other than the owner.
49      */
50     modifier onlyOwner() {
51         require(_owner == _msgSender(), "Ownable: caller is not the owner");
52         _;
53     }
54 
55     /**
56      * @dev Leaves the contract without owner. It will not be possible to call
57      * `onlyOwner` functions anymore. Can only be called by the current owner.
58      *
59      * NOTE: Renouncing ownership will leave the contract without an owner,
60      * thereby removing any functionality that is only available to the owner.
61      */
62     function renounceOwnership() public virtual onlyOwner {
63         emit OwnershipTransferred(_owner, address(0));
64         _owner = address(0);
65     }
66 
67     /**
68      * @dev Transfers ownership of the contract to a new account (`newOwner`).
69      * Can only be called by the current owner.
70      */
71     function transferOwnership(address newOwner) public virtual onlyOwner {
72         require(
73             newOwner != address(0),
74             "Ownable: new owner is the zero address"
75         );
76         emit OwnershipTransferred(_owner, newOwner);
77         _owner = newOwner;
78     }
79 }
80 
81 interface IERC20 {
82     function totalSupply() external view returns (uint256);
83 
84     function balanceOf(address account) external view returns (uint256);
85 
86     function transfer(
87         address recipient,
88         uint256 amount
89     ) external returns (bool);
90 
91     function allowance(
92         address owner,
93         address spender
94     ) external view returns (uint256);
95 
96     function approve(address spender, uint256 amount) external returns (bool);
97 
98     function transferFrom(
99         address sender,
100         address recipient,
101         uint256 amount
102     ) external returns (bool);
103 
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 
106     event Approval(
107         address indexed owner,
108         address indexed spender,
109         uint256 value
110     );
111 }
112 
113 interface IERC20Metadata is IERC20 {
114     function name() external view returns (string memory);
115 
116     function symbol() external view returns (string memory);
117 
118     function decimals() external view returns (uint8);
119 }
120 
121 contract ERC20 is Context, IERC20, IERC20Metadata {
122     mapping(address => uint256) private _balances;
123 
124     mapping(address => mapping(address => uint256)) private _allowances;
125 
126     uint256 private _totalSupply;
127 
128     string private _name;
129     string private _symbol;
130 
131     constructor(string memory name_, string memory symbol_) {
132         _name = name_;
133         _symbol = symbol_;
134     }
135 
136     function name() public view virtual override returns (string memory) {
137         return _name;
138     }
139 
140     function symbol() public view virtual override returns (string memory) {
141         return _symbol;
142     }
143 
144     function decimals() public view virtual override returns (uint8) {
145         return 9;
146     }
147 
148     function totalSupply() public view virtual override returns (uint256) {
149         return _totalSupply;
150     }
151 
152     function balanceOf(
153         address account
154     ) public view virtual override returns (uint256) {
155         return _balances[account];
156     }
157 
158     function transfer(
159         address recipient,
160         uint256 amount
161     ) public virtual override returns (bool) {
162         _transfer(_msgSender(), recipient, amount);
163         return true;
164     }
165 
166     function allowance(
167         address owner,
168         address spender
169     ) public view virtual override returns (uint256) {
170         return _allowances[owner][spender];
171     }
172 
173     function approve(
174         address spender,
175         uint256 amount
176     ) public virtual override returns (bool) {
177         _approve(_msgSender(), spender, amount);
178         return true;
179     }
180 
181     function transferFrom(
182         address sender,
183         address recipient,
184         uint256 amount
185     ) public virtual override returns (bool) {
186         _transfer(sender, recipient, amount);
187 
188         uint256 currentAllowance = _allowances[sender][_msgSender()];
189         require(
190             currentAllowance >= amount,
191             "ERC20: transfer amount exceeds allowance"
192         );
193         unchecked {
194             _approve(sender, _msgSender(), currentAllowance - amount);
195         }
196 
197         return true;
198     }
199 
200     function increaseAllowance(
201         address spender,
202         uint256 addedValue
203     ) public virtual returns (bool) {
204         _approve(
205             _msgSender(),
206             spender,
207             _allowances[_msgSender()][spender] + addedValue
208         );
209         return true;
210     }
211 
212     function decreaseAllowance(
213         address spender,
214         uint256 subtractedValue
215     ) public virtual returns (bool) {
216         uint256 currentAllowance = _allowances[_msgSender()][spender];
217         require(
218             currentAllowance >= subtractedValue,
219             "ERC20: decreased allowance below zero"
220         );
221         unchecked {
222             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
223         }
224 
225         return true;
226     }
227 
228     function _transfer(
229         address sender,
230         address recipient,
231         uint256 amount
232     ) internal virtual {
233         require(sender != address(0), "ERC20: transfer from the zero address");
234         require(recipient != address(0), "ERC20: transfer to the zero address");
235 
236         _beforeTokenTransfer(sender, recipient, amount);
237 
238         uint256 senderBalance = _balances[sender];
239         require(
240             senderBalance >= amount,
241             "ERC20: transfer amount exceeds balance"
242         );
243         unchecked {
244             _balances[sender] = senderBalance - amount;
245         }
246         _balances[recipient] += amount;
247 
248         emit Transfer(sender, recipient, amount);
249 
250         _afterTokenTransfer(sender, recipient, amount);
251     }
252 
253     function _mint(address account, uint256 amount) internal virtual {
254         require(account != address(0), "ERC20: mint to the zero address");
255 
256         _beforeTokenTransfer(address(0), account, amount);
257 
258         _totalSupply += amount;
259         _balances[account] += amount;
260         emit Transfer(address(0), account, amount);
261 
262         _afterTokenTransfer(address(0), account, amount);
263     }
264 
265     function _burn(address account, uint256 amount) internal virtual {
266         require(account != address(0), "ERC20: burn from the zero address");
267 
268         _beforeTokenTransfer(account, address(0), amount);
269 
270         uint256 accountBalance = _balances[account];
271         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
272         unchecked {
273             _balances[account] = accountBalance - amount;
274         }
275         _totalSupply -= amount;
276 
277         emit Transfer(account, address(0), amount);
278 
279         _afterTokenTransfer(account, address(0), amount);
280     }
281 
282     function _approve(
283         address owner,
284         address spender,
285         uint256 amount
286     ) internal virtual {
287         require(owner != address(0), "ERC20: approve from the zero address");
288         require(spender != address(0), "ERC20: approve to the zero address");
289 
290         _allowances[owner][spender] = amount;
291         emit Approval(owner, spender, amount);
292     }
293 
294     function _beforeTokenTransfer(
295         address from,
296         address to,
297         uint256 amount
298     ) internal virtual {}
299 
300     function _afterTokenTransfer(
301         address from,
302         address to,
303         uint256 amount
304     ) internal virtual {}
305 }
306 
307 library SafeMath {
308     function tryAdd(
309         uint256 a,
310         uint256 b
311     ) internal pure returns (bool, uint256) {
312         unchecked {
313             uint256 c = a + b;
314             if (c < a) return (false, 0);
315             return (true, c);
316         }
317     }
318 
319     function trySub(
320         uint256 a,
321         uint256 b
322     ) internal pure returns (bool, uint256) {
323         unchecked {
324             if (b > a) return (false, 0);
325             return (true, a - b);
326         }
327     }
328 
329     function tryMul(
330         uint256 a,
331         uint256 b
332     ) internal pure returns (bool, uint256) {
333         unchecked {
334             if (a == 0) return (true, 0);
335             uint256 c = a * b;
336             if (c / a != b) return (false, 0);
337             return (true, c);
338         }
339     }
340 
341     function tryDiv(
342         uint256 a,
343         uint256 b
344     ) internal pure returns (bool, uint256) {
345         unchecked {
346             if (b == 0) return (false, 0);
347             return (true, a / b);
348         }
349     }
350 
351     function tryMod(
352         uint256 a,
353         uint256 b
354     ) internal pure returns (bool, uint256) {
355         unchecked {
356             if (b == 0) return (false, 0);
357             return (true, a % b);
358         }
359     }
360 
361     function add(uint256 a, uint256 b) internal pure returns (uint256) {
362         return a + b;
363     }
364 
365     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
366         return a - b;
367     }
368 
369     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
370         return a * b;
371     }
372 
373     function div(uint256 a, uint256 b) internal pure returns (uint256) {
374         return a / b;
375     }
376 
377     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
378         return a % b;
379     }
380 
381     function sub(
382         uint256 a,
383         uint256 b,
384         string memory errorMessage
385     ) internal pure returns (uint256) {
386         unchecked {
387             require(b <= a, errorMessage);
388             return a - b;
389         }
390     }
391 
392     function div(
393         uint256 a,
394         uint256 b,
395         string memory errorMessage
396     ) internal pure returns (uint256) {
397         unchecked {
398             require(b > 0, errorMessage);
399             return a / b;
400         }
401     }
402 
403     function mod(
404         uint256 a,
405         uint256 b,
406         string memory errorMessage
407     ) internal pure returns (uint256) {
408         unchecked {
409             require(b > 0, errorMessage);
410             return a % b;
411         }
412     }
413 }
414 
415 interface IUniswapV2Factory {
416     event PairCreated(
417         address indexed token0,
418         address indexed token1,
419         address pair,
420         uint256
421     );
422 
423     function feeTo() external view returns (address);
424 
425     function feeToSetter() external view returns (address);
426 
427     function getPair(
428         address tokenA,
429         address tokenB
430     ) external view returns (address pair);
431 
432     function allPairs(uint256) external view returns (address pair);
433 
434     function allPairsLength() external view returns (uint256);
435 
436     function createPair(
437         address tokenA,
438         address tokenB
439     ) external returns (address pair);
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
464     function allowance(
465         address owner,
466         address spender
467     ) external view returns (uint256);
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
523         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
524 
525     function price0CumulativeLast() external view returns (uint256);
526 
527     function price1CumulativeLast() external view returns (uint256);
528 
529     function kLast() external view returns (uint256);
530 
531     function mint(address to) external returns (uint256 liquidity);
532 
533     function burn(
534         address to
535     ) external returns (uint256 amount0, uint256 amount1);
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
565     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
566 
567     function addLiquidityETH(
568         address token,
569         uint256 amountTokenDesired,
570         uint256 amountTokenMin,
571         uint256 amountETHMin,
572         address to,
573         uint256 deadline
574     )
575         external
576         payable
577         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
578 
579     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
580         uint256 amountIn,
581         uint256 amountOutMin,
582         address[] calldata path,
583         address to,
584         uint256 deadline
585     ) external;
586 
587     function swapExactETHForTokensSupportingFeeOnTransferTokens(
588         uint256 amountOutMin,
589         address[] calldata path,
590         address to,
591         uint256 deadline
592     ) external payable;
593 
594     function swapExactTokensForETHSupportingFeeOnTransferTokens(
595         uint256 amountIn,
596         uint256 amountOutMin,
597         address[] calldata path,
598         address to,
599         uint256 deadline
600     ) external;
601 }
602 
603 contract BITPEPE is ERC20, Ownable {
604     using SafeMath for uint256;
605 
606     IUniswapV2Router02 public immutable uniswapV2Router;
607     address public immutable uniswapV2Pair;
608     address public constant deadAddress = address(0xdead);
609 
610     bool private swapping;
611 
612     address public marketingWallet;
613 
614     uint256 public swapTokensAtAmount;
615 
616     uint256 public maxTransactionAmount;
617     uint256 public maxWallet;
618 
619     bool public lpBurnEnabled = true;
620     uint256 public percentForLPBurn = 25; // 25 = .25%
621     uint256 public lpBurnFrequency = 3600 seconds;
622     uint256 public lastLpBurnTime;
623 
624     uint256 public manualBurnFrequency = 30 minutes;
625     uint256 public lastManualLpBurnTime;
626 
627     uint256 public buyTotalFees;
628     uint256 public buyMarketingFee;
629     uint256 public buyLiquidityFee;
630 
631     uint256 public sellTotalFees;
632     uint256 public sellMarketingFee;
633     uint256 public sellLiquidityFee;
634 
635     uint256 public tokensForMarketing;
636     uint256 public tokensForLiquidity;
637 
638     bool public limitsInEffect = true;
639 
640     /******************/
641 
642     // exlcude from fees
643     mapping(address => bool) private _isExcludedFromFees;
644     mapping(address => bool) public _isExcludedMaxTransactionAmount;
645 
646     mapping(address => bool) public automatedMarketMakerPairs;
647 
648     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
649     
650     event SwapAndLiquify(
651         uint256 tokensSwapped,
652         uint256 ethReceived,
653         uint256 tokensIntoLiquidity
654     );
655 
656     event AutoNukeLP();
657 
658     constructor() ERC20("Bitpepe", "BITPEPE") {
659         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
660             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
661         );
662 
663         uniswapV2Router = _uniswapV2Router;
664 
665         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
666             .createPair(address(this), _uniswapV2Router.WETH());
667         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
668 
669         uint256 _buyMarketingFee = 15;
670         uint256 _buyLiquidityFee = 0;
671 
672         uint256 _sellMarketingFee = 40;
673         uint256 _sellLiquidityFee = 0;
674 
675         uint256 totalSupply = 420_690_000_000_000 * 1e9;
676 
677         maxTransactionAmount = (totalSupply) / 100;
678         maxWallet = (totalSupply) / 100;
679 
680         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
681 
682         buyMarketingFee = _buyMarketingFee;
683         buyLiquidityFee = _buyLiquidityFee;
684         buyTotalFees = buyMarketingFee + buyLiquidityFee;
685 
686         sellMarketingFee = _sellMarketingFee;
687         sellLiquidityFee = _sellLiquidityFee;
688         sellTotalFees = sellMarketingFee + sellLiquidityFee;
689 
690         marketingWallet = address(0xEec925078f2Af1225Dd5c7099ad9FdC04892ADA9); //
691 
692         // exclude from paying fees
693         _isExcludedFromFees[msg.sender] = true;
694         _isExcludedFromFees[marketingWallet] = true;
695         _isExcludedFromFees[address(this)] = true;
696         _isExcludedFromFees[address(0xdead)] = true;
697 
698         _isExcludedMaxTransactionAmount[owner()] = true;
699         _isExcludedMaxTransactionAmount[address(this)] = true;
700         _isExcludedMaxTransactionAmount[address(0xdead)] = true;
701         _isExcludedMaxTransactionAmount[marketingWallet] = true;
702 
703         /*
704             _mint is an internal function in ERC20.sol that is only called here,
705             and CANNOT be called ever again
706         */
707         _mint(msg.sender, totalSupply);
708     }
709 
710     receive() external payable {}
711 
712     function Bitpepe() external onlyOwner returns (bool) {
713         buyTotalFees = 1;
714         buyMarketingFee = 1;
715         buyLiquidityFee = 0;
716         sellTotalFees = 1;
717         sellMarketingFee = 1;
718         sellLiquidityFee = 0;
719         
720         limitsInEffect = false;
721         return true;
722     }
723 
724     function _setAutomatedMarketMakerPair(address pair, bool value) private {
725         automatedMarketMakerPairs[pair] = value;
726 
727         emit SetAutomatedMarketMakerPair(pair, value);
728     }
729 
730     function _transfer(
731         address from,
732         address to,
733         uint256 amount
734     ) internal override {
735         require(from != address(0), "ERC20: transfer from the zero address");
736         require(to != address(0), "ERC20: transfer to the zero address");
737 
738         if (amount == 0) {
739             super._transfer(from, to, 0);
740             return;
741         }
742 
743         if (limitsInEffect) {
744             if (
745                 from != owner() &&
746                 to != owner() &&
747                 to != address(0) &&
748                 to != address(0xdead) &&
749                 !swapping
750             ) {
751                 //when buy
752                 if (
753                     automatedMarketMakerPairs[from] &&
754                     !_isExcludedMaxTransactionAmount[to]
755                 ) {
756                     require(
757                         amount <= maxTransactionAmount,
758                         "Buy transfer amount exceeds the maxTransactionAmount."
759                     );
760                     require(
761                         amount + balanceOf(to) <= maxWallet,
762                         "Max wallet exceeded"
763                     );
764                 }
765                 //when sell
766                 else if (
767                     automatedMarketMakerPairs[to] &&
768                     !_isExcludedMaxTransactionAmount[from]
769                 ) {
770                     require(
771                         amount <= maxTransactionAmount,
772                         "Sell transfer amount exceeds the maxTransactionAmount."
773                     );
774                 } else if (!_isExcludedMaxTransactionAmount[to]) {
775                     require(
776                         amount + balanceOf(to) <= maxWallet,
777                         "Max wallet exceeded"
778                     );
779                 }
780             }
781         }
782 
783         uint256 contractTokenBalance = balanceOf(address(this));
784 
785         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
786 
787         if (
788             canSwap &&
789             !swapping &&
790             !automatedMarketMakerPairs[from] &&
791             !_isExcludedFromFees[from] &&
792             !_isExcludedFromFees[to]
793         ) {
794             swapping = true;
795 
796             swapBack();
797 
798             swapping = false;
799         }
800 
801         if (
802             !swapping &&
803             automatedMarketMakerPairs[to] &&
804             lpBurnEnabled &&
805             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
806             !_isExcludedFromFees[from]
807         ) {
808             autoBurnLiquidityPairTokens();
809         }
810 
811         bool takeFee = !swapping;
812 
813         // if any account belongs to _isExcludedFromFee account then remove the fee
814         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
815             takeFee = false;
816         }
817 
818         uint256 fees = 0;
819         // only take fees on buys/sells, do not take on wallet transfers
820         if (takeFee) {
821             // on sell
822             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
823                 fees = amount.mul(sellTotalFees).div(100);
824                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
825                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
826             }
827             // on buy
828             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
829                 fees = amount.mul(buyTotalFees).div(100);
830                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
831                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
832             }
833 
834             if (fees > 0) {
835                 super._transfer(from, address(this), fees);
836             }
837 
838             amount -= fees;
839         }
840 
841         super._transfer(from, to, amount);
842     }
843 
844     function swapTokensForEth(uint256 tokenAmount) private {
845         // generate the uniswap pair path of token -> weth
846         address[] memory path = new address[](2);
847         path[0] = address(this);
848         path[1] = uniswapV2Router.WETH();
849 
850         _approve(address(this), address(uniswapV2Router), tokenAmount);
851 
852         // make the swap
853         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
854             tokenAmount,
855             0, // accept any amount of ETH
856             path,
857             address(this),
858             block.timestamp
859         );
860     }
861 
862     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
863         // approve token transfer to cover all possible scenarios
864         _approve(address(this), address(uniswapV2Router), tokenAmount);
865 
866         // add the liquidity
867         uniswapV2Router.addLiquidityETH{value: ethAmount}(
868             address(this),
869             tokenAmount,
870             0, // slippage is unavoidable
871             0, // slippage is unavoidable
872             deadAddress,
873             block.timestamp
874         );
875     }
876 
877     function swapBack() private {
878         uint256 contractBalance = balanceOf(address(this));
879         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
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
890         // Halve the amount of liquidity tokens
891         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
892             totalTokensToSwap /
893             2;
894         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
895 
896         uint256 initialETHBalance = address(this).balance;
897 
898         swapTokensForEth(amountToSwapForETH);
899 
900         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
901 
902         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
903             totalTokensToSwap
904         );
905 
906         uint256 ethForLiquidity = ethBalance - ethForMarketing;
907 
908         tokensForLiquidity = 0;
909         tokensForMarketing = 0;
910 
911         if (liquidityTokens > 0 && ethForLiquidity > 0) {
912             addLiquidity(liquidityTokens, ethForLiquidity);
913             emit SwapAndLiquify(
914                 amountToSwapForETH,
915                 ethForLiquidity,
916                 tokensForLiquidity
917             );
918         }
919 
920         (success, ) = address(marketingWallet).call{
921             value: address(this).balance
922         }("");
923     }
924 
925     function autoBurnLiquidityPairTokens() internal returns (bool) {
926         lastLpBurnTime = block.timestamp;
927 
928         // get balance of liquidity pair
929         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
930 
931         // calculate amount to burn
932         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
933             10000
934         );
935 
936         // pull tokens from pancakePair liquidity and move to dead address permanently
937         if (amountToBurn > 0) {
938             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
939         }
940 
941         //sync price since this is not in a swap transaction!
942         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
943         pair.sync();
944         emit AutoNukeLP();
945         return true;
946     }
947 }