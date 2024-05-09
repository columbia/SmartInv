1 /**
2  
3  quack quack motherducker
4 
5  https://t.me/Duckcoineth
6  
7  */
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity >=0.8.19;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes calldata) {
18         return msg.data;
19     }
20 }
21 
22 contract Ownable is Context {
23     address private _owner;
24 
25     event OwnershipTransferred(
26         address indexed previousOwner,
27         address indexed newOwner
28     );
29 
30     /**
31      * @dev Initializes the contract setting the deployer as the initial owner.
32      */
33     constructor() {
34         address msgSender = _msgSender();
35         _owner = msgSender;
36         emit OwnershipTransferred(address(0), msgSender);
37     }
38 
39     /**
40      * @dev Returns the address of the current owner.
41      */
42     function owner() public view returns (address) {
43         return _owner;
44     }
45 
46     /**
47      * @dev Throws if called by any account other than the owner.
48      */
49     modifier onlyOwner() {
50         require(_owner == _msgSender(), "Ownable: caller is not the owner");
51         _;
52     }
53 
54     /**
55      * @dev Leaves the contract without owner. It will not be possible to call
56      * `onlyOwner` functions anymore. Can only be called by the current owner.
57      *
58      * NOTE: Renouncing ownership will leave the contract without an owner,
59      * thereby removing any functionality that is only available to the owner.
60      */
61     function renounceOwnership() public virtual onlyOwner {
62         emit OwnershipTransferred(_owner, address(0));
63         _owner = address(0);
64     }
65 
66     /**
67      * @dev Transfers ownership of the contract to a new account (`newOwner`).
68      * Can only be called by the current owner.
69      */
70     function transferOwnership(address newOwner) public virtual onlyOwner {
71         require(
72             newOwner != address(0),
73             "Ownable: new owner is the zero address"
74         );
75         emit OwnershipTransferred(_owner, newOwner);
76         _owner = newOwner;
77     }
78 }
79 
80 interface IERC20 {
81     function totalSupply() external view returns (uint256);
82 
83     function balanceOf(address account) external view returns (uint256);
84 
85     function transfer(
86         address recipient,
87         uint256 amount
88     ) external returns (bool);
89 
90     function allowance(
91         address owner,
92         address spender
93     ) external view returns (uint256);
94 
95     function approve(address spender, uint256 amount) external returns (bool);
96 
97     function transferFrom(
98         address sender,
99         address recipient,
100         uint256 amount
101     ) external returns (bool);
102 
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     event Approval(
106         address indexed owner,
107         address indexed spender,
108         uint256 value
109     );
110 }
111 
112 interface IERC20Metadata is IERC20 {
113     function name() external view returns (string memory);
114 
115     function symbol() external view returns (string memory);
116 
117     function decimals() external view returns (uint8);
118 }
119 
120 contract ERC20 is Context, IERC20, IERC20Metadata {
121     mapping(address => uint256) private _balances;
122 
123     mapping(address => mapping(address => uint256)) private _allowances;
124 
125     uint256 private _totalSupply;
126 
127     string private _name;
128     string private _symbol;
129 
130     constructor(string memory name_, string memory symbol_) {
131         _name = name_;
132         _symbol = symbol_;
133     }
134 
135     function name() public view virtual override returns (string memory) {
136         return _name;
137     }
138 
139     function symbol() public view virtual override returns (string memory) {
140         return _symbol;
141     }
142 
143     function decimals() public view virtual override returns (uint8) {
144         return 18;
145     }
146 
147     function totalSupply() public view virtual override returns (uint256) {
148         return _totalSupply;
149     }
150 
151     function balanceOf(
152         address account
153     ) public view virtual override returns (uint256) {
154         return _balances[account];
155     }
156 
157     function transfer(
158         address recipient,
159         uint256 amount
160     ) public virtual override returns (bool) {
161         _transfer(_msgSender(), recipient, amount);
162         return true;
163     }
164 
165     function allowance(
166         address owner,
167         address spender
168     ) public view virtual override returns (uint256) {
169         return _allowances[owner][spender];
170     }
171 
172     function approve(
173         address spender,
174         uint256 amount
175     ) public virtual override returns (bool) {
176         _approve(_msgSender(), spender, amount);
177         return true;
178     }
179 
180     function transferFrom(
181         address sender,
182         address recipient,
183         uint256 amount
184     ) public virtual override returns (bool) {
185         _transfer(sender, recipient, amount);
186 
187         uint256 currentAllowance = _allowances[sender][_msgSender()];
188         require(
189             currentAllowance >= amount,
190             "ERC20: transfer amount exceeds allowance"
191         );
192         unchecked {
193             _approve(sender, _msgSender(), currentAllowance - amount);
194         }
195 
196         return true;
197     }
198 
199     function increaseAllowance(
200         address spender,
201         uint256 addedValue
202     ) public virtual returns (bool) {
203         _approve(
204             _msgSender(),
205             spender,
206             _allowances[_msgSender()][spender] + addedValue
207         );
208         return true;
209     }
210 
211     function decreaseAllowance(
212         address spender,
213         uint256 subtractedValue
214     ) public virtual returns (bool) {
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
307     function tryAdd(
308         uint256 a,
309         uint256 b
310     ) internal pure returns (bool, uint256) {
311         unchecked {
312             uint256 c = a + b;
313             if (c < a) return (false, 0);
314             return (true, c);
315         }
316     }
317 
318     function trySub(
319         uint256 a,
320         uint256 b
321     ) internal pure returns (bool, uint256) {
322         unchecked {
323             if (b > a) return (false, 0);
324             return (true, a - b);
325         }
326     }
327 
328     function tryMul(
329         uint256 a,
330         uint256 b
331     ) internal pure returns (bool, uint256) {
332         unchecked {
333             if (a == 0) return (true, 0);
334             uint256 c = a * b;
335             if (c / a != b) return (false, 0);
336             return (true, c);
337         }
338     }
339 
340     function tryDiv(
341         uint256 a,
342         uint256 b
343     ) internal pure returns (bool, uint256) {
344         unchecked {
345             if (b == 0) return (false, 0);
346             return (true, a / b);
347         }
348     }
349 
350     function tryMod(
351         uint256 a,
352         uint256 b
353     ) internal pure returns (bool, uint256) {
354         unchecked {
355             if (b == 0) return (false, 0);
356             return (true, a % b);
357         }
358     }
359 
360     function add(uint256 a, uint256 b) internal pure returns (uint256) {
361         return a + b;
362     }
363 
364     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
365         return a - b;
366     }
367 
368     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
369         return a * b;
370     }
371 
372     function div(uint256 a, uint256 b) internal pure returns (uint256) {
373         return a / b;
374     }
375 
376     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
377         return a % b;
378     }
379 
380     function sub(
381         uint256 a,
382         uint256 b,
383         string memory errorMessage
384     ) internal pure returns (uint256) {
385         unchecked {
386             require(b <= a, errorMessage);
387             return a - b;
388         }
389     }
390 
391     function div(
392         uint256 a,
393         uint256 b,
394         string memory errorMessage
395     ) internal pure returns (uint256) {
396         unchecked {
397             require(b > 0, errorMessage);
398             return a / b;
399         }
400     }
401 
402     function mod(
403         uint256 a,
404         uint256 b,
405         string memory errorMessage
406     ) internal pure returns (uint256) {
407         unchecked {
408             require(b > 0, errorMessage);
409             return a % b;
410         }
411     }
412 }
413 
414 interface IUniswapV2Factory {
415     event PairCreated(
416         address indexed token0,
417         address indexed token1,
418         address pair,
419         uint256
420     );
421 
422     function feeTo() external view returns (address);
423 
424     function feeToSetter() external view returns (address);
425 
426     function getPair(
427         address tokenA,
428         address tokenB
429     ) external view returns (address pair);
430 
431     function allPairs(uint256) external view returns (address pair);
432 
433     function allPairsLength() external view returns (uint256);
434 
435     function createPair(
436         address tokenA,
437         address tokenB
438     ) external returns (address pair);
439 
440     function setFeeTo(address) external;
441 
442     function setFeeToSetter(address) external;
443 }
444 
445 interface IUniswapV2Pair {
446     event Approval(
447         address indexed owner,
448         address indexed spender,
449         uint256 value
450     );
451     event Transfer(address indexed from, address indexed to, uint256 value);
452 
453     function name() external pure returns (string memory);
454 
455     function symbol() external pure returns (string memory);
456 
457     function decimals() external pure returns (uint8);
458 
459     function totalSupply() external view returns (uint256);
460 
461     function balanceOf(address owner) external view returns (uint256);
462 
463     function allowance(
464         address owner,
465         address spender
466     ) external view returns (uint256);
467 
468     function approve(address spender, uint256 value) external returns (bool);
469 
470     function transfer(address to, uint256 value) external returns (bool);
471 
472     function transferFrom(
473         address from,
474         address to,
475         uint256 value
476     ) external returns (bool);
477 
478     function DOMAIN_SEPARATOR() external view returns (bytes32);
479 
480     function PERMIT_TYPEHASH() external pure returns (bytes32);
481 
482     function nonces(address owner) external view returns (uint256);
483 
484     function permit(
485         address owner,
486         address spender,
487         uint256 value,
488         uint256 deadline,
489         uint8 v,
490         bytes32 r,
491         bytes32 s
492     ) external;
493 
494     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
495     event Burn(
496         address indexed sender,
497         uint256 amount0,
498         uint256 amount1,
499         address indexed to
500     );
501     event Swap(
502         address indexed sender,
503         uint256 amount0In,
504         uint256 amount1In,
505         uint256 amount0Out,
506         uint256 amount1Out,
507         address indexed to
508     );
509     event Sync(uint112 reserve0, uint112 reserve1);
510 
511     function MINIMUM_LIQUIDITY() external pure returns (uint256);
512 
513     function factory() external view returns (address);
514 
515     function token0() external view returns (address);
516 
517     function token1() external view returns (address);
518 
519     function getReserves()
520         external
521         view
522         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
523 
524     function price0CumulativeLast() external view returns (uint256);
525 
526     function price1CumulativeLast() external view returns (uint256);
527 
528     function kLast() external view returns (uint256);
529 
530     function mint(address to) external returns (uint256 liquidity);
531 
532     function burn(
533         address to
534     ) external returns (uint256 amount0, uint256 amount1);
535 
536     function swap(
537         uint256 amount0Out,
538         uint256 amount1Out,
539         address to,
540         bytes calldata data
541     ) external;
542 
543     function skim(address to) external;
544 
545     function sync() external;
546 
547     function initialize(address, address) external;
548 }
549 
550 interface IUniswapV2Router02 {
551     function factory() external pure returns (address);
552 
553     function WETH() external pure returns (address);
554 
555     function addLiquidity(
556         address tokenA,
557         address tokenB,
558         uint256 amountADesired,
559         uint256 amountBDesired,
560         uint256 amountAMin,
561         uint256 amountBMin,
562         address to,
563         uint256 deadline
564     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
565 
566     function addLiquidityETH(
567         address token,
568         uint256 amountTokenDesired,
569         uint256 amountTokenMin,
570         uint256 amountETHMin,
571         address to,
572         uint256 deadline
573     )
574         external
575         payable
576         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
577 
578     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
579         uint256 amountIn,
580         uint256 amountOutMin,
581         address[] calldata path,
582         address to,
583         uint256 deadline
584     ) external;
585 
586     function swapExactETHForTokensSupportingFeeOnTransferTokens(
587         uint256 amountOutMin,
588         address[] calldata path,
589         address to,
590         uint256 deadline
591     ) external payable;
592 
593     function swapExactTokensForETHSupportingFeeOnTransferTokens(
594         uint256 amountIn,
595         uint256 amountOutMin,
596         address[] calldata path,
597         address to,
598         uint256 deadline
599     ) external;
600 }
601 
602 contract DUCKIE is ERC20, Ownable {
603     using SafeMath for uint256;
604 
605     IUniswapV2Router02 public immutable uniswapV2Router;
606     address public immutable uniswapV2Pair;
607     address public constant deadAddress = address(0xdead);
608 
609     bool private swapping;
610 
611     address public marketingWallet;
612 
613     uint256 public swapTokensAtAmount;
614 
615     uint256 public maxTransactionAmount;
616     uint256 public maxWallet;
617 
618     bool public lpBurnEnabled = true;
619     uint256 public percentForLPBurn = 25; // 25 = .25%
620     uint256 public lpBurnFrequency = 3600 seconds;
621     uint256 public lastLpBurnTime;
622 
623     uint256 public manualBurnFrequency = 30 minutes;
624     uint256 public lastManualLpBurnTime;
625 
626     uint256 public buyTotalFees;
627     uint256 public buyMarketingFee;
628     uint256 public buyLiquidityFee;
629 
630     uint256 public sellTotalFees;
631     uint256 public sellMarketingFee;
632     uint256 public sellLiquidityFee;
633 
634     uint256 public tokensForMarketing;
635     uint256 public tokensForLiquidity;
636 
637     bool public limitsInEffect = true;
638 
639     /******************/
640 
641     // exlcude from fees
642     mapping(address => bool) private _isExcludedFromFees;
643     mapping(address => bool) public _isExcludedMaxTransactionAmount;
644 
645     mapping(address => bool) public automatedMarketMakerPairs;
646 
647     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
648     
649     event SwapAndLiquify(
650         uint256 tokensSwapped,
651         uint256 ethReceived,
652         uint256 tokensIntoLiquidity
653     );
654 
655     event AutoNukeLP();
656 
657     constructor() ERC20("Duckcoin", "DUCKIE") {
658         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
659             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
660         );
661 
662         uniswapV2Router = _uniswapV2Router;
663 
664         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
665             .createPair(address(this), _uniswapV2Router.WETH());
666         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
667 
668         uint256 _buyMarketingFee = 14;
669         uint256 _buyLiquidityFee = 0;
670 
671         uint256 _sellMarketingFee = 66;
672         uint256 _sellLiquidityFee = 0;
673 
674         uint256 totalSupply = 69_000_888_000 * 1e18;
675 
676         maxTransactionAmount = (totalSupply) / 100;
677         maxWallet = (totalSupply) / 100;
678 
679         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
680 
681         buyMarketingFee = _buyMarketingFee;
682         buyLiquidityFee = _buyLiquidityFee;
683         buyTotalFees = buyMarketingFee + buyLiquidityFee;
684 
685         sellMarketingFee = _sellMarketingFee;
686         sellLiquidityFee = _sellLiquidityFee;
687         sellTotalFees = sellMarketingFee + sellLiquidityFee;
688 
689         marketingWallet = address(0x45CA3374215A08C35823998d5e811C0C79F536E5); //
690 
691         // exclude from paying fees
692         _isExcludedFromFees[msg.sender] = true;
693         _isExcludedFromFees[marketingWallet] = true;
694         _isExcludedFromFees[address(this)] = true;
695         _isExcludedFromFees[address(0xdead)] = true;
696 
697         _isExcludedMaxTransactionAmount[owner()] = true;
698         _isExcludedMaxTransactionAmount[address(this)] = true;
699         _isExcludedMaxTransactionAmount[address(0xdead)] = true;
700         _isExcludedMaxTransactionAmount[marketingWallet] = true;
701 
702         /*
703             _mint is an internal function in ERC20.sol that is only called here,
704             and CANNOT be called ever again
705         */
706         _mint(msg.sender, totalSupply);
707     }
708 
709     receive() external payable {}
710 
711     function duckIt() external onlyOwner returns (bool) {
712         buyTotalFees = 0;
713         buyMarketingFee = 0;
714         buyLiquidityFee = 0;
715         sellTotalFees = 0;
716         sellMarketingFee = 0;
717         sellLiquidityFee = 0;
718         
719         limitsInEffect = false;
720         return true;
721     }
722 
723     function _setAutomatedMarketMakerPair(address pair, bool value) private {
724         automatedMarketMakerPairs[pair] = value;
725 
726         emit SetAutomatedMarketMakerPair(pair, value);
727     }
728 
729     function _transfer(
730         address from,
731         address to,
732         uint256 amount
733     ) internal override {
734         require(from != address(0), "ERC20: transfer from the zero address");
735         require(to != address(0), "ERC20: transfer to the zero address");
736 
737         if (amount == 0) {
738             super._transfer(from, to, 0);
739             return;
740         }
741 
742         if (limitsInEffect) {
743             if (
744                 from != owner() &&
745                 to != owner() &&
746                 to != address(0) &&
747                 to != address(0xdead) &&
748                 !swapping
749             ) {
750                 //when buy
751                 if (
752                     automatedMarketMakerPairs[from] &&
753                     !_isExcludedMaxTransactionAmount[to]
754                 ) {
755                     require(
756                         amount <= maxTransactionAmount,
757                         "Buy transfer amount exceeds the maxTransactionAmount."
758                     );
759                     require(
760                         amount + balanceOf(to) <= maxWallet,
761                         "Max wallet exceeded"
762                     );
763                 }
764                 //when sell
765                 else if (
766                     automatedMarketMakerPairs[to] &&
767                     !_isExcludedMaxTransactionAmount[from]
768                 ) {
769                     require(
770                         amount <= maxTransactionAmount,
771                         "Sell transfer amount exceeds the maxTransactionAmount."
772                     );
773                 } else if (!_isExcludedMaxTransactionAmount[to]) {
774                     require(
775                         amount + balanceOf(to) <= maxWallet,
776                         "Max wallet exceeded"
777                     );
778                 }
779             }
780         }
781 
782         uint256 contractTokenBalance = balanceOf(address(this));
783 
784         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
785 
786         if (
787             canSwap &&
788             !swapping &&
789             !automatedMarketMakerPairs[from] &&
790             !_isExcludedFromFees[from] &&
791             !_isExcludedFromFees[to]
792         ) {
793             swapping = true;
794 
795             swapBack();
796 
797             swapping = false;
798         }
799 
800         if (
801             !swapping &&
802             automatedMarketMakerPairs[to] &&
803             lpBurnEnabled &&
804             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
805             !_isExcludedFromFees[from]
806         ) {
807             autoBurnLiquidityPairTokens();
808         }
809 
810         bool takeFee = !swapping;
811 
812         // if any account belongs to _isExcludedFromFee account then remove the fee
813         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
814             takeFee = false;
815         }
816 
817         uint256 fees = 0;
818         // only take fees on buys/sells, do not take on wallet transfers
819         if (takeFee) {
820             // on sell
821             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
822                 fees = amount.mul(sellTotalFees).div(100);
823                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
824                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
825             }
826             // on buy
827             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
828                 fees = amount.mul(buyTotalFees).div(100);
829                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
830                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
831             }
832 
833             if (fees > 0) {
834                 super._transfer(from, address(this), fees);
835             }
836 
837             amount -= fees;
838         }
839 
840         super._transfer(from, to, amount);
841     }
842 
843     function swapTokensForEth(uint256 tokenAmount) private {
844         // generate the uniswap pair path of token -> weth
845         address[] memory path = new address[](2);
846         path[0] = address(this);
847         path[1] = uniswapV2Router.WETH();
848 
849         _approve(address(this), address(uniswapV2Router), tokenAmount);
850 
851         // make the swap
852         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
853             tokenAmount,
854             0, // accept any amount of ETH
855             path,
856             address(this),
857             block.timestamp
858         );
859     }
860 
861     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
862         // approve token transfer to cover all possible scenarios
863         _approve(address(this), address(uniswapV2Router), tokenAmount);
864 
865         // add the liquidity
866         uniswapV2Router.addLiquidityETH{value: ethAmount}(
867             address(this),
868             tokenAmount,
869             0, // slippage is unavoidable
870             0, // slippage is unavoidable
871             deadAddress,
872             block.timestamp
873         );
874     }
875 
876     function swapBack() private {
877         uint256 contractBalance = balanceOf(address(this));
878         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
879         bool success;
880 
881         if (contractBalance == 0 || totalTokensToSwap == 0) {
882             return;
883         }
884 
885         if (contractBalance > swapTokensAtAmount * 20) {
886             contractBalance = swapTokensAtAmount * 20;
887         }
888 
889         // Halve the amount of liquidity tokens
890         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
891             totalTokensToSwap /
892             2;
893         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
894 
895         uint256 initialETHBalance = address(this).balance;
896 
897         swapTokensForEth(amountToSwapForETH);
898 
899         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
900 
901         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
902             totalTokensToSwap
903         );
904 
905         uint256 ethForLiquidity = ethBalance - ethForMarketing;
906 
907         tokensForLiquidity = 0;
908         tokensForMarketing = 0;
909 
910         if (liquidityTokens > 0 && ethForLiquidity > 0) {
911             addLiquidity(liquidityTokens, ethForLiquidity);
912             emit SwapAndLiquify(
913                 amountToSwapForETH,
914                 ethForLiquidity,
915                 tokensForLiquidity
916             );
917         }
918 
919         (success, ) = address(marketingWallet).call{
920             value: address(this).balance
921         }("");
922     }
923 
924     function autoBurnLiquidityPairTokens() internal returns (bool) {
925         lastLpBurnTime = block.timestamp;
926 
927         // get balance of liquidity pair
928         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
929 
930         // calculate amount to burn
931         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
932             10000
933         );
934 
935         // pull tokens from pancakePair liquidity and move to dead address permanently
936         if (amountToBurn > 0) {
937             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
938         }
939 
940         //sync price since this is not in a swap transaction!
941         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
942         pair.sync();
943         emit AutoNukeLP();
944         return true;
945     }
946 }