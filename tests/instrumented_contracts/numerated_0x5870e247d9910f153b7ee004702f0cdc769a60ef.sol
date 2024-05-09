1 /**
2  
3 ██████████▀███████████▀█
4 █░▄▄░█─▄▄▄▄██▀▄─██─▄▄▄▄█
5 █▄▄▄░█─██▄─██─▀─██─██▄─█
6 ▀▄▄▄▄▀▄▄▄▄▄▀▄▄▀▄▄▀▄▄▄▄▄▀
7  
8  The Largest Meme Community
9 
10  https://t.me/ninegagcoin
11  
12  */
13 
14 // SPDX-License-Identifier: MIT
15 pragma solidity >=0.8.19;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 contract Ownable is Context {
28     address private _owner;
29 
30     event OwnershipTransferred(
31         address indexed previousOwner,
32         address indexed newOwner
33     );
34 
35     /**
36      * @dev Initializes the contract setting the deployer as the initial owner.
37      */
38     constructor() {
39         address msgSender = _msgSender();
40         _owner = msgSender;
41         emit OwnershipTransferred(address(0), msgSender);
42     }
43 
44     /**
45      * @dev Returns the address of the current owner.
46      */
47     function owner() public view returns (address) {
48         return _owner;
49     }
50 
51     /**
52      * @dev Throws if called by any account other than the owner.
53      */
54     modifier onlyOwner() {
55         require(_owner == _msgSender(), "Ownable: caller is not the owner");
56         _;
57     }
58 
59     /**
60      * @dev Leaves the contract without owner. It will not be possible to call
61      * `onlyOwner` functions anymore. Can only be called by the current owner.
62      *
63      * NOTE: Renouncing ownership will leave the contract without an owner,
64      * thereby removing any functionality that is only available to the owner.
65      */
66     function renounceOwnership() public virtual onlyOwner {
67         emit OwnershipTransferred(_owner, address(0));
68         _owner = address(0);
69     }
70 
71     /**
72      * @dev Transfers ownership of the contract to a new account (`newOwner`).
73      * Can only be called by the current owner.
74      */
75     function transferOwnership(address newOwner) public virtual onlyOwner {
76         require(
77             newOwner != address(0),
78             "Ownable: new owner is the zero address"
79         );
80         emit OwnershipTransferred(_owner, newOwner);
81         _owner = newOwner;
82     }
83 }
84 
85 interface IERC20 {
86     function totalSupply() external view returns (uint256);
87 
88     function balanceOf(address account) external view returns (uint256);
89 
90     function transfer(
91         address recipient,
92         uint256 amount
93     ) external returns (bool);
94 
95     function allowance(
96         address owner,
97         address spender
98     ) external view returns (uint256);
99 
100     function approve(address spender, uint256 amount) external returns (bool);
101 
102     function transferFrom(
103         address sender,
104         address recipient,
105         uint256 amount
106     ) external returns (bool);
107 
108     event Transfer(address indexed from, address indexed to, uint256 value);
109 
110     event Approval(
111         address indexed owner,
112         address indexed spender,
113         uint256 value
114     );
115 }
116 
117 interface IERC20Metadata is IERC20 {
118     function name() external view returns (string memory);
119 
120     function symbol() external view returns (string memory);
121 
122     function decimals() external view returns (uint8);
123 }
124 
125 contract ERC20 is Context, IERC20, IERC20Metadata {
126     mapping(address => uint256) private _balances;
127 
128     mapping(address => mapping(address => uint256)) private _allowances;
129 
130     uint256 private _totalSupply;
131 
132     string private _name;
133     string private _symbol;
134 
135     constructor(string memory name_, string memory symbol_) {
136         _name = name_;
137         _symbol = symbol_;
138     }
139 
140     function name() public view virtual override returns (string memory) {
141         return _name;
142     }
143 
144     function symbol() public view virtual override returns (string memory) {
145         return _symbol;
146     }
147 
148     function decimals() public view virtual override returns (uint8) {
149         return 9;
150     }
151 
152     function totalSupply() public view virtual override returns (uint256) {
153         return _totalSupply;
154     }
155 
156     function balanceOf(
157         address account
158     ) public view virtual override returns (uint256) {
159         return _balances[account];
160     }
161 
162     function transfer(
163         address recipient,
164         uint256 amount
165     ) public virtual override returns (bool) {
166         _transfer(_msgSender(), recipient, amount);
167         return true;
168     }
169 
170     function allowance(
171         address owner,
172         address spender
173     ) public view virtual override returns (uint256) {
174         return _allowances[owner][spender];
175     }
176 
177     function approve(
178         address spender,
179         uint256 amount
180     ) public virtual override returns (bool) {
181         _approve(_msgSender(), spender, amount);
182         return true;
183     }
184 
185     function transferFrom(
186         address sender,
187         address recipient,
188         uint256 amount
189     ) public virtual override returns (bool) {
190         _transfer(sender, recipient, amount);
191 
192         uint256 currentAllowance = _allowances[sender][_msgSender()];
193         require(
194             currentAllowance >= amount,
195             "ERC20: transfer amount exceeds allowance"
196         );
197         unchecked {
198             _approve(sender, _msgSender(), currentAllowance - amount);
199         }
200 
201         return true;
202     }
203 
204     function increaseAllowance(
205         address spender,
206         uint256 addedValue
207     ) public virtual returns (bool) {
208         _approve(
209             _msgSender(),
210             spender,
211             _allowances[_msgSender()][spender] + addedValue
212         );
213         return true;
214     }
215 
216     function decreaseAllowance(
217         address spender,
218         uint256 subtractedValue
219     ) public virtual returns (bool) {
220         uint256 currentAllowance = _allowances[_msgSender()][spender];
221         require(
222             currentAllowance >= subtractedValue,
223             "ERC20: decreased allowance below zero"
224         );
225         unchecked {
226             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
227         }
228 
229         return true;
230     }
231 
232     function _transfer(
233         address sender,
234         address recipient,
235         uint256 amount
236     ) internal virtual {
237         require(sender != address(0), "ERC20: transfer from the zero address");
238         require(recipient != address(0), "ERC20: transfer to the zero address");
239 
240         _beforeTokenTransfer(sender, recipient, amount);
241 
242         uint256 senderBalance = _balances[sender];
243         require(
244             senderBalance >= amount,
245             "ERC20: transfer amount exceeds balance"
246         );
247         unchecked {
248             _balances[sender] = senderBalance - amount;
249         }
250         _balances[recipient] += amount;
251 
252         emit Transfer(sender, recipient, amount);
253 
254         _afterTokenTransfer(sender, recipient, amount);
255     }
256 
257     function _mint(address account, uint256 amount) internal virtual {
258         require(account != address(0), "ERC20: mint to the zero address");
259 
260         _beforeTokenTransfer(address(0), account, amount);
261 
262         _totalSupply += amount;
263         _balances[account] += amount;
264         emit Transfer(address(0), account, amount);
265 
266         _afterTokenTransfer(address(0), account, amount);
267     }
268 
269     function _burn(address account, uint256 amount) internal virtual {
270         require(account != address(0), "ERC20: burn from the zero address");
271 
272         _beforeTokenTransfer(account, address(0), amount);
273 
274         uint256 accountBalance = _balances[account];
275         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
276         unchecked {
277             _balances[account] = accountBalance - amount;
278         }
279         _totalSupply -= amount;
280 
281         emit Transfer(account, address(0), amount);
282 
283         _afterTokenTransfer(account, address(0), amount);
284     }
285 
286     function _approve(
287         address owner,
288         address spender,
289         uint256 amount
290     ) internal virtual {
291         require(owner != address(0), "ERC20: approve from the zero address");
292         require(spender != address(0), "ERC20: approve to the zero address");
293 
294         _allowances[owner][spender] = amount;
295         emit Approval(owner, spender, amount);
296     }
297 
298     function _beforeTokenTransfer(
299         address from,
300         address to,
301         uint256 amount
302     ) internal virtual {}
303 
304     function _afterTokenTransfer(
305         address from,
306         address to,
307         uint256 amount
308     ) internal virtual {}
309 }
310 
311 library SafeMath {
312     function tryAdd(
313         uint256 a,
314         uint256 b
315     ) internal pure returns (bool, uint256) {
316         unchecked {
317             uint256 c = a + b;
318             if (c < a) return (false, 0);
319             return (true, c);
320         }
321     }
322 
323     function trySub(
324         uint256 a,
325         uint256 b
326     ) internal pure returns (bool, uint256) {
327         unchecked {
328             if (b > a) return (false, 0);
329             return (true, a - b);
330         }
331     }
332 
333     function tryMul(
334         uint256 a,
335         uint256 b
336     ) internal pure returns (bool, uint256) {
337         unchecked {
338             if (a == 0) return (true, 0);
339             uint256 c = a * b;
340             if (c / a != b) return (false, 0);
341             return (true, c);
342         }
343     }
344 
345     function tryDiv(
346         uint256 a,
347         uint256 b
348     ) internal pure returns (bool, uint256) {
349         unchecked {
350             if (b == 0) return (false, 0);
351             return (true, a / b);
352         }
353     }
354 
355     function tryMod(
356         uint256 a,
357         uint256 b
358     ) internal pure returns (bool, uint256) {
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
431     function getPair(
432         address tokenA,
433         address tokenB
434     ) external view returns (address pair);
435 
436     function allPairs(uint256) external view returns (address pair);
437 
438     function allPairsLength() external view returns (uint256);
439 
440     function createPair(
441         address tokenA,
442         address tokenB
443     ) external returns (address pair);
444 
445     function setFeeTo(address) external;
446 
447     function setFeeToSetter(address) external;
448 }
449 
450 interface IUniswapV2Pair {
451     event Approval(
452         address indexed owner,
453         address indexed spender,
454         uint256 value
455     );
456     event Transfer(address indexed from, address indexed to, uint256 value);
457 
458     function name() external pure returns (string memory);
459 
460     function symbol() external pure returns (string memory);
461 
462     function decimals() external pure returns (uint8);
463 
464     function totalSupply() external view returns (uint256);
465 
466     function balanceOf(address owner) external view returns (uint256);
467 
468     function allowance(
469         address owner,
470         address spender
471     ) external view returns (uint256);
472 
473     function approve(address spender, uint256 value) external returns (bool);
474 
475     function transfer(address to, uint256 value) external returns (bool);
476 
477     function transferFrom(
478         address from,
479         address to,
480         uint256 value
481     ) external returns (bool);
482 
483     function DOMAIN_SEPARATOR() external view returns (bytes32);
484 
485     function PERMIT_TYPEHASH() external pure returns (bytes32);
486 
487     function nonces(address owner) external view returns (uint256);
488 
489     function permit(
490         address owner,
491         address spender,
492         uint256 value,
493         uint256 deadline,
494         uint8 v,
495         bytes32 r,
496         bytes32 s
497     ) external;
498 
499     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
500     event Burn(
501         address indexed sender,
502         uint256 amount0,
503         uint256 amount1,
504         address indexed to
505     );
506     event Swap(
507         address indexed sender,
508         uint256 amount0In,
509         uint256 amount1In,
510         uint256 amount0Out,
511         uint256 amount1Out,
512         address indexed to
513     );
514     event Sync(uint112 reserve0, uint112 reserve1);
515 
516     function MINIMUM_LIQUIDITY() external pure returns (uint256);
517 
518     function factory() external view returns (address);
519 
520     function token0() external view returns (address);
521 
522     function token1() external view returns (address);
523 
524     function getReserves()
525         external
526         view
527         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
528 
529     function price0CumulativeLast() external view returns (uint256);
530 
531     function price1CumulativeLast() external view returns (uint256);
532 
533     function kLast() external view returns (uint256);
534 
535     function mint(address to) external returns (uint256 liquidity);
536 
537     function burn(
538         address to
539     ) external returns (uint256 amount0, uint256 amount1);
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
569     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
570 
571     function addLiquidityETH(
572         address token,
573         uint256 amountTokenDesired,
574         uint256 amountTokenMin,
575         uint256 amountETHMin,
576         address to,
577         uint256 deadline
578     )
579         external
580         payable
581         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
582 
583     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
584         uint256 amountIn,
585         uint256 amountOutMin,
586         address[] calldata path,
587         address to,
588         uint256 deadline
589     ) external;
590 
591     function swapExactETHForTokensSupportingFeeOnTransferTokens(
592         uint256 amountOutMin,
593         address[] calldata path,
594         address to,
595         uint256 deadline
596     ) external payable;
597 
598     function swapExactTokensForETHSupportingFeeOnTransferTokens(
599         uint256 amountIn,
600         uint256 amountOutMin,
601         address[] calldata path,
602         address to,
603         uint256 deadline
604     ) external;
605 }
606 
607 contract NINEGAG is ERC20, Ownable {
608     using SafeMath for uint256;
609 
610     IUniswapV2Router02 public immutable uniswapV2Router;
611     address public immutable uniswapV2Pair;
612     address public constant deadAddress = address(0xdead);
613 
614     bool private swapping;
615 
616     address public marketingWallet;
617 
618     uint256 public swapTokensAtAmount;
619 
620     uint256 public maxTransactionAmount;
621     uint256 public maxWallet;
622 
623     bool public lpBurnEnabled = true;
624     uint256 public percentForLPBurn = 25; // 25 = .25%
625     uint256 public lpBurnFrequency = 3600 seconds;
626     uint256 public lastLpBurnTime;
627 
628     uint256 public manualBurnFrequency = 30 minutes;
629     uint256 public lastManualLpBurnTime;
630 
631     uint256 public buyTotalFees;
632     uint256 public buyMarketingFee;
633     uint256 public buyLiquidityFee;
634 
635     uint256 public sellTotalFees;
636     uint256 public sellMarketingFee;
637     uint256 public sellLiquidityFee;
638 
639     uint256 public tokensForMarketing;
640     uint256 public tokensForLiquidity;
641 
642     bool public limitsInEffect = true;
643 
644     /******************/
645 
646     // exlcude from fees
647     mapping(address => bool) private _isExcludedFromFees;
648     mapping(address => bool) public _isExcludedMaxTransactionAmount;
649 
650     mapping(address => bool) public automatedMarketMakerPairs;
651 
652     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
653     
654     event SwapAndLiquify(
655         uint256 tokensSwapped,
656         uint256 ethReceived,
657         uint256 tokensIntoLiquidity
658     );
659 
660     event AutoNukeLP();
661 
662     constructor() ERC20("9GAG", "9GAG") {
663         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
664             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
665         );
666 
667         uniswapV2Router = _uniswapV2Router;
668 
669         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
670             .createPair(address(this), _uniswapV2Router.WETH());
671         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
672 
673         uint256 _buyMarketingFee = 15;
674         uint256 _buyLiquidityFee = 0;
675 
676         uint256 _sellMarketingFee = 45;
677         uint256 _sellLiquidityFee = 0;
678 
679         uint256 totalSupply = 999_999_999_999_999_999 * 1e9;
680 
681         maxTransactionAmount = (totalSupply) / 100;
682         maxWallet = (totalSupply) / 100;
683 
684         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
685 
686         buyMarketingFee = _buyMarketingFee;
687         buyLiquidityFee = _buyLiquidityFee;
688         buyTotalFees = buyMarketingFee + buyLiquidityFee;
689 
690         sellMarketingFee = _sellMarketingFee;
691         sellLiquidityFee = _sellLiquidityFee;
692         sellTotalFees = sellMarketingFee + sellLiquidityFee;
693 
694         marketingWallet = address(0x9f063165e868352C9d8c26C9418488F20855D962); //
695 
696         // exclude from paying fees
697         _isExcludedFromFees[msg.sender] = true;
698         _isExcludedFromFees[marketingWallet] = true;
699         _isExcludedFromFees[address(this)] = true;
700         _isExcludedFromFees[address(0xdead)] = true;
701 
702         _isExcludedMaxTransactionAmount[owner()] = true;
703         _isExcludedMaxTransactionAmount[address(this)] = true;
704         _isExcludedMaxTransactionAmount[address(0xdead)] = true;
705         _isExcludedMaxTransactionAmount[marketingWallet] = true;
706 
707         /*
708             _mint is an internal function in ERC20.sol that is only called here,
709             and CANNOT be called ever again
710         */
711         _mint(msg.sender, totalSupply);
712     }
713 
714     receive() external payable {}
715 
716     function Meme() external onlyOwner returns (bool) {
717         buyTotalFees = 0;
718         buyMarketingFee = 0;
719         buyLiquidityFee = 0;
720         sellTotalFees = 0;
721         sellMarketingFee = 0;
722         sellLiquidityFee = 0;
723         
724         limitsInEffect = false;
725         return true;
726     }
727 
728     function _setAutomatedMarketMakerPair(address pair, bool value) private {
729         automatedMarketMakerPairs[pair] = value;
730 
731         emit SetAutomatedMarketMakerPair(pair, value);
732     }
733 
734     function _transfer(
735         address from,
736         address to,
737         uint256 amount
738     ) internal override {
739         require(from != address(0), "ERC20: transfer from the zero address");
740         require(to != address(0), "ERC20: transfer to the zero address");
741 
742         if (amount == 0) {
743             super._transfer(from, to, 0);
744             return;
745         }
746 
747         if (limitsInEffect) {
748             if (
749                 from != owner() &&
750                 to != owner() &&
751                 to != address(0) &&
752                 to != address(0xdead) &&
753                 !swapping
754             ) {
755                 //when buy
756                 if (
757                     automatedMarketMakerPairs[from] &&
758                     !_isExcludedMaxTransactionAmount[to]
759                 ) {
760                     require(
761                         amount <= maxTransactionAmount,
762                         "Buy transfer amount exceeds the maxTransactionAmount."
763                     );
764                     require(
765                         amount + balanceOf(to) <= maxWallet,
766                         "Max wallet exceeded"
767                     );
768                 }
769                 //when sell
770                 else if (
771                     automatedMarketMakerPairs[to] &&
772                     !_isExcludedMaxTransactionAmount[from]
773                 ) {
774                     require(
775                         amount <= maxTransactionAmount,
776                         "Sell transfer amount exceeds the maxTransactionAmount."
777                     );
778                 } else if (!_isExcludedMaxTransactionAmount[to]) {
779                     require(
780                         amount + balanceOf(to) <= maxWallet,
781                         "Max wallet exceeded"
782                     );
783                 }
784             }
785         }
786 
787         uint256 contractTokenBalance = balanceOf(address(this));
788 
789         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
790 
791         if (
792             canSwap &&
793             !swapping &&
794             !automatedMarketMakerPairs[from] &&
795             !_isExcludedFromFees[from] &&
796             !_isExcludedFromFees[to]
797         ) {
798             swapping = true;
799 
800             swapBack();
801 
802             swapping = false;
803         }
804 
805         if (
806             !swapping &&
807             automatedMarketMakerPairs[to] &&
808             lpBurnEnabled &&
809             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
810             !_isExcludedFromFees[from]
811         ) {
812             autoBurnLiquidityPairTokens();
813         }
814 
815         bool takeFee = !swapping;
816 
817         // if any account belongs to _isExcludedFromFee account then remove the fee
818         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
819             takeFee = false;
820         }
821 
822         uint256 fees = 0;
823         // only take fees on buys/sells, do not take on wallet transfers
824         if (takeFee) {
825             // on sell
826             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
827                 fees = amount.mul(sellTotalFees).div(100);
828                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
829                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
830             }
831             // on buy
832             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
833                 fees = amount.mul(buyTotalFees).div(100);
834                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
835                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
836             }
837 
838             if (fees > 0) {
839                 super._transfer(from, address(this), fees);
840             }
841 
842             amount -= fees;
843         }
844 
845         super._transfer(from, to, amount);
846     }
847 
848     function swapTokensForEth(uint256 tokenAmount) private {
849         // generate the uniswap pair path of token -> weth
850         address[] memory path = new address[](2);
851         path[0] = address(this);
852         path[1] = uniswapV2Router.WETH();
853 
854         _approve(address(this), address(uniswapV2Router), tokenAmount);
855 
856         // make the swap
857         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
858             tokenAmount,
859             0, // accept any amount of ETH
860             path,
861             address(this),
862             block.timestamp
863         );
864     }
865 
866     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
867         // approve token transfer to cover all possible scenarios
868         _approve(address(this), address(uniswapV2Router), tokenAmount);
869 
870         // add the liquidity
871         uniswapV2Router.addLiquidityETH{value: ethAmount}(
872             address(this),
873             tokenAmount,
874             0, // slippage is unavoidable
875             0, // slippage is unavoidable
876             deadAddress,
877             block.timestamp
878         );
879     }
880 
881     function swapBack() private {
882         uint256 contractBalance = balanceOf(address(this));
883         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
884         bool success;
885 
886         if (contractBalance == 0 || totalTokensToSwap == 0) {
887             return;
888         }
889 
890         if (contractBalance > swapTokensAtAmount * 20) {
891             contractBalance = swapTokensAtAmount * 20;
892         }
893 
894         // Halve the amount of liquidity tokens
895         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
896             totalTokensToSwap /
897             2;
898         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
899 
900         uint256 initialETHBalance = address(this).balance;
901 
902         swapTokensForEth(amountToSwapForETH);
903 
904         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
905 
906         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
907             totalTokensToSwap
908         );
909 
910         uint256 ethForLiquidity = ethBalance - ethForMarketing;
911 
912         tokensForLiquidity = 0;
913         tokensForMarketing = 0;
914 
915         if (liquidityTokens > 0 && ethForLiquidity > 0) {
916             addLiquidity(liquidityTokens, ethForLiquidity);
917             emit SwapAndLiquify(
918                 amountToSwapForETH,
919                 ethForLiquidity,
920                 tokensForLiquidity
921             );
922         }
923 
924         (success, ) = address(marketingWallet).call{
925             value: address(this).balance
926         }("");
927     }
928 
929     function autoBurnLiquidityPairTokens() internal returns (bool) {
930         lastLpBurnTime = block.timestamp;
931 
932         // get balance of liquidity pair
933         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
934 
935         // calculate amount to burn
936         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
937             10000
938         );
939 
940         // pull tokens from pancakePair liquidity and move to dead address permanently
941         if (amountToBurn > 0) {
942             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
943         }
944 
945         //sync price since this is not in a swap transaction!
946         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
947         pair.sync();
948         emit AutoNukeLP();
949         return true;
950     }
951 }