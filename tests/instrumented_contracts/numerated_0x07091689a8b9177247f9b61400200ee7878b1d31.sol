1 /**
2 
3 $PEPEZILLA
4 
5 https://pepezillaeth.com/
6 https://t.me/pepezillacoin
7 https://twitter.com/Pepezillacoin
8  
9  */
10 
11 // SPDX-License-Identifier: MIT
12 pragma solidity >=0.8.19;
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
32     /**
33      * @dev Initializes the contract setting the deployer as the initial owner.
34      */
35     constructor() {
36         address msgSender = _msgSender();
37         _owner = msgSender;
38         emit OwnershipTransferred(address(0), msgSender);
39     }
40 
41     /**
42      * @dev Returns the address of the current owner.
43      */
44     function owner() public view returns (address) {
45         return _owner;
46     }
47 
48     /**
49      * @dev Throws if called by any account other than the owner.
50      */
51     modifier onlyOwner() {
52         require(_owner == _msgSender(), "Ownable: caller is not the owner");
53         _;
54     }
55 
56     /**
57      * @dev Leaves the contract without owner. It will not be possible to call
58      * `onlyOwner` functions anymore. Can only be called by the current owner.
59      *
60      * NOTE: Renouncing ownership will leave the contract without an owner,
61      * thereby removing any functionality that is only available to the owner.
62      */
63     function renounceOwnership() public virtual onlyOwner {
64         emit OwnershipTransferred(_owner, address(0));
65         _owner = address(0);
66     }
67 
68     /**
69      * @dev Transfers ownership of the contract to a new account (`newOwner`).
70      * Can only be called by the current owner.
71      */
72     function transferOwnership(address newOwner) public virtual onlyOwner {
73         require(
74             newOwner != address(0),
75             "Ownable: new owner is the zero address"
76         );
77         emit OwnershipTransferred(_owner, newOwner);
78         _owner = newOwner;
79     }
80 }
81 
82 interface IERC20 {
83     function totalSupply() external view returns (uint256);
84 
85     function balanceOf(address account) external view returns (uint256);
86 
87     function transfer(
88         address recipient,
89         uint256 amount
90     ) external returns (bool);
91 
92     function allowance(
93         address owner,
94         address spender
95     ) external view returns (uint256);
96 
97     function approve(address spender, uint256 amount) external returns (bool);
98 
99     function transferFrom(
100         address sender,
101         address recipient,
102         uint256 amount
103     ) external returns (bool);
104 
105     event Transfer(address indexed from, address indexed to, uint256 value);
106 
107     event Approval(
108         address indexed owner,
109         address indexed spender,
110         uint256 value
111     );
112 }
113 
114 interface IERC20Metadata is IERC20 {
115     function name() external view returns (string memory);
116 
117     function symbol() external view returns (string memory);
118 
119     function decimals() external view returns (uint8);
120 }
121 
122 contract ERC20 is Context, IERC20, IERC20Metadata {
123     mapping(address => uint256) private _balances;
124 
125     mapping(address => mapping(address => uint256)) private _allowances;
126 
127     uint256 private _totalSupply;
128 
129     string private _name;
130     string private _symbol;
131 
132     constructor(string memory name_, string memory symbol_) {
133         _name = name_;
134         _symbol = symbol_;
135     }
136 
137     function name() public view virtual override returns (string memory) {
138         return _name;
139     }
140 
141     function symbol() public view virtual override returns (string memory) {
142         return _symbol;
143     }
144 
145     function decimals() public view virtual override returns (uint8) {
146         return 18;
147     }
148 
149     function totalSupply() public view virtual override returns (uint256) {
150         return _totalSupply;
151     }
152 
153     function balanceOf(
154         address account
155     ) public view virtual override returns (uint256) {
156         return _balances[account];
157     }
158 
159     function transfer(
160         address recipient,
161         uint256 amount
162     ) public virtual override returns (bool) {
163         _transfer(_msgSender(), recipient, amount);
164         return true;
165     }
166 
167     function allowance(
168         address owner,
169         address spender
170     ) public view virtual override returns (uint256) {
171         return _allowances[owner][spender];
172     }
173 
174     function approve(
175         address spender,
176         uint256 amount
177     ) public virtual override returns (bool) {
178         _approve(_msgSender(), spender, amount);
179         return true;
180     }
181 
182     function transferFrom(
183         address sender,
184         address recipient,
185         uint256 amount
186     ) public virtual override returns (bool) {
187         _transfer(sender, recipient, amount);
188 
189         uint256 currentAllowance = _allowances[sender][_msgSender()];
190         require(
191             currentAllowance >= amount,
192             "ERC20: transfer amount exceeds allowance"
193         );
194         unchecked {
195             _approve(sender, _msgSender(), currentAllowance - amount);
196         }
197 
198         return true;
199     }
200 
201     function increaseAllowance(
202         address spender,
203         uint256 addedValue
204     ) public virtual returns (bool) {
205         _approve(
206             _msgSender(),
207             spender,
208             _allowances[_msgSender()][spender] + addedValue
209         );
210         return true;
211     }
212 
213     function decreaseAllowance(
214         address spender,
215         uint256 subtractedValue
216     ) public virtual returns (bool) {
217         uint256 currentAllowance = _allowances[_msgSender()][spender];
218         require(
219             currentAllowance >= subtractedValue,
220             "ERC20: decreased allowance below zero"
221         );
222         unchecked {
223             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
224         }
225 
226         return true;
227     }
228 
229     function _transfer(
230         address sender,
231         address recipient,
232         uint256 amount
233     ) internal virtual {
234         require(sender != address(0), "ERC20: transfer from the zero address");
235         require(recipient != address(0), "ERC20: transfer to the zero address");
236 
237         _beforeTokenTransfer(sender, recipient, amount);
238 
239         uint256 senderBalance = _balances[sender];
240         require(
241             senderBalance >= amount,
242             "ERC20: transfer amount exceeds balance"
243         );
244         unchecked {
245             _balances[sender] = senderBalance - amount;
246         }
247         _balances[recipient] += amount;
248 
249         emit Transfer(sender, recipient, amount);
250 
251         _afterTokenTransfer(sender, recipient, amount);
252     }
253 
254     function _mint(address account, uint256 amount) internal virtual {
255         require(account != address(0), "ERC20: mint to the zero address");
256 
257         _beforeTokenTransfer(address(0), account, amount);
258 
259         _totalSupply += amount;
260         _balances[account] += amount;
261         emit Transfer(address(0), account, amount);
262 
263         _afterTokenTransfer(address(0), account, amount);
264     }
265 
266     function _burn(address account, uint256 amount) internal virtual {
267         require(account != address(0), "ERC20: burn from the zero address");
268 
269         _beforeTokenTransfer(account, address(0), amount);
270 
271         uint256 accountBalance = _balances[account];
272         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
273         unchecked {
274             _balances[account] = accountBalance - amount;
275         }
276         _totalSupply -= amount;
277 
278         emit Transfer(account, address(0), amount);
279 
280         _afterTokenTransfer(account, address(0), amount);
281     }
282 
283     function _approve(
284         address owner,
285         address spender,
286         uint256 amount
287     ) internal virtual {
288         require(owner != address(0), "ERC20: approve from the zero address");
289         require(spender != address(0), "ERC20: approve to the zero address");
290 
291         _allowances[owner][spender] = amount;
292         emit Approval(owner, spender, amount);
293     }
294 
295     function _beforeTokenTransfer(
296         address from,
297         address to,
298         uint256 amount
299     ) internal virtual {}
300 
301     function _afterTokenTransfer(
302         address from,
303         address to,
304         uint256 amount
305     ) internal virtual {}
306 }
307 
308 library SafeMath {
309     function tryAdd(
310         uint256 a,
311         uint256 b
312     ) internal pure returns (bool, uint256) {
313         unchecked {
314             uint256 c = a + b;
315             if (c < a) return (false, 0);
316             return (true, c);
317         }
318     }
319 
320     function trySub(
321         uint256 a,
322         uint256 b
323     ) internal pure returns (bool, uint256) {
324         unchecked {
325             if (b > a) return (false, 0);
326             return (true, a - b);
327         }
328     }
329 
330     function tryMul(
331         uint256 a,
332         uint256 b
333     ) internal pure returns (bool, uint256) {
334         unchecked {
335             if (a == 0) return (true, 0);
336             uint256 c = a * b;
337             if (c / a != b) return (false, 0);
338             return (true, c);
339         }
340     }
341 
342     function tryDiv(
343         uint256 a,
344         uint256 b
345     ) internal pure returns (bool, uint256) {
346         unchecked {
347             if (b == 0) return (false, 0);
348             return (true, a / b);
349         }
350     }
351 
352     function tryMod(
353         uint256 a,
354         uint256 b
355     ) internal pure returns (bool, uint256) {
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
428     function getPair(
429         address tokenA,
430         address tokenB
431     ) external view returns (address pair);
432 
433     function allPairs(uint256) external view returns (address pair);
434 
435     function allPairsLength() external view returns (uint256);
436 
437     function createPair(
438         address tokenA,
439         address tokenB
440     ) external returns (address pair);
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
465     function allowance(
466         address owner,
467         address spender
468     ) external view returns (uint256);
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
524         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
525 
526     function price0CumulativeLast() external view returns (uint256);
527 
528     function price1CumulativeLast() external view returns (uint256);
529 
530     function kLast() external view returns (uint256);
531 
532     function mint(address to) external returns (uint256 liquidity);
533 
534     function burn(
535         address to
536     ) external returns (uint256 amount0, uint256 amount1);
537 
538     function swap(
539         uint256 amount0Out,
540         uint256 amount1Out,
541         address to,
542         bytes calldata data
543     ) external;
544 
545     function skim(address to) external;
546 
547     function sync() external;
548 
549     function initialize(address, address) external;
550 }
551 
552 interface IUniswapV2Router02 {
553     function factory() external pure returns (address);
554 
555     function WETH() external pure returns (address);
556 
557     function addLiquidity(
558         address tokenA,
559         address tokenB,
560         uint256 amountADesired,
561         uint256 amountBDesired,
562         uint256 amountAMin,
563         uint256 amountBMin,
564         address to,
565         uint256 deadline
566     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
567 
568     function addLiquidityETH(
569         address token,
570         uint256 amountTokenDesired,
571         uint256 amountTokenMin,
572         uint256 amountETHMin,
573         address to,
574         uint256 deadline
575     )
576         external
577         payable
578         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
579 
580     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
581         uint256 amountIn,
582         uint256 amountOutMin,
583         address[] calldata path,
584         address to,
585         uint256 deadline
586     ) external;
587 
588     function swapExactETHForTokensSupportingFeeOnTransferTokens(
589         uint256 amountOutMin,
590         address[] calldata path,
591         address to,
592         uint256 deadline
593     ) external payable;
594 
595     function swapExactTokensForETHSupportingFeeOnTransferTokens(
596         uint256 amountIn,
597         uint256 amountOutMin,
598         address[] calldata path,
599         address to,
600         uint256 deadline
601     ) external;
602 }
603 
604 contract PEPEZILLA is ERC20, Ownable {
605     using SafeMath for uint256;
606 
607     IUniswapV2Router02 public immutable uniswapV2Router;
608     address public immutable uniswapV2Pair;
609     address public constant deadAddress = address(0xdead);
610 
611     bool private swapping;
612 
613     address public marketingWallet;
614 
615     uint256 public swapTokensAtAmount;
616 
617     uint256 public maxTransactionAmount;
618     uint256 public maxWallet;
619 
620     bool public lpBurnEnabled = true;
621     uint256 public percentForLPBurn = 25; // 25 = .25%
622     uint256 public lpBurnFrequency = 3600 seconds;
623     uint256 public lastLpBurnTime;
624 
625     uint256 public manualBurnFrequency = 30 minutes;
626     uint256 public lastManualLpBurnTime;
627 
628     uint256 public buyTotalFees;
629     uint256 public buyMarketingFee;
630     uint256 public buyLiquidityFee;
631 
632     uint256 public sellTotalFees;
633     uint256 public sellMarketingFee;
634     uint256 public sellLiquidityFee;
635 
636     uint256 public tokensForMarketing;
637     uint256 public tokensForLiquidity;
638 
639     bool public limitsInEffect = true;
640 
641     /******************/
642 
643     // exlcude from fees
644     mapping(address => bool) private _isExcludedFromFees;
645     mapping(address => bool) public _isExcludedMaxTransactionAmount;
646 
647     mapping(address => bool) public automatedMarketMakerPairs;
648 
649     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
650     
651     event SwapAndLiquify(
652         uint256 tokensSwapped,
653         uint256 ethReceived,
654         uint256 tokensIntoLiquidity
655     );
656 
657     event AutoNukeLP();
658 
659     constructor() ERC20("Pepezilla", "PEPEZILLA") {
660         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
661             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
662         );
663 
664         uniswapV2Router = _uniswapV2Router;
665 
666         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
667             .createPair(address(this), _uniswapV2Router.WETH());
668         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
669 
670         uint256 _buyMarketingFee = 18;
671         uint256 _buyLiquidityFee = 0;
672 
673         uint256 _sellMarketingFee = 42;
674         uint256 _sellLiquidityFee = 0;
675 
676         uint256 totalSupply = 420_690_000_000_000 * 1e18;
677 
678         maxTransactionAmount = (totalSupply) / 100;
679         maxWallet = (totalSupply) / 100;
680 
681         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
682 
683         buyMarketingFee = _buyMarketingFee;
684         buyLiquidityFee = _buyLiquidityFee;
685         buyTotalFees = buyMarketingFee + buyLiquidityFee;
686 
687         sellMarketingFee = _sellMarketingFee;
688         sellLiquidityFee = _sellLiquidityFee;
689         sellTotalFees = sellMarketingFee + sellLiquidityFee;
690 
691         marketingWallet = address(0xCF73519A17BED05220EDaceB89d1dcF64792A8E2); //
692 
693         // exclude from paying fees
694         _isExcludedFromFees[msg.sender] = true;
695         _isExcludedFromFees[marketingWallet] = true;
696         _isExcludedFromFees[address(this)] = true;
697         _isExcludedFromFees[address(0xdead)] = true;
698 
699         _isExcludedMaxTransactionAmount[owner()] = true;
700         _isExcludedMaxTransactionAmount[address(this)] = true;
701         _isExcludedMaxTransactionAmount[address(0xdead)] = true;
702         _isExcludedMaxTransactionAmount[marketingWallet] = true;
703 
704         /*
705             _mint is an internal function in ERC20.sol that is only called here,
706             and CANNOT be called ever again
707         */
708         _mint(msg.sender, totalSupply);
709     }
710 
711     receive() external payable {}
712 
713     function Kek() external onlyOwner returns (bool) {
714         buyTotalFees = 0;
715         buyMarketingFee = 0;
716         buyLiquidityFee = 0;
717         sellTotalFees = 0;
718         sellMarketingFee = 0;
719         sellLiquidityFee = 0;
720         
721         limitsInEffect = false;
722         return true;
723     }
724 
725     function _setAutomatedMarketMakerPair(address pair, bool value) private {
726         automatedMarketMakerPairs[pair] = value;
727 
728         emit SetAutomatedMarketMakerPair(pair, value);
729     }
730 
731     function _transfer(
732         address from,
733         address to,
734         uint256 amount
735     ) internal override {
736         require(from != address(0), "ERC20: transfer from the zero address");
737         require(to != address(0), "ERC20: transfer to the zero address");
738 
739         if (amount == 0) {
740             super._transfer(from, to, 0);
741             return;
742         }
743 
744         if (limitsInEffect) {
745             if (
746                 from != owner() &&
747                 to != owner() &&
748                 to != address(0) &&
749                 to != address(0xdead) &&
750                 !swapping
751             ) {
752                 //when buy
753                 if (
754                     automatedMarketMakerPairs[from] &&
755                     !_isExcludedMaxTransactionAmount[to]
756                 ) {
757                     require(
758                         amount <= maxTransactionAmount,
759                         "Buy transfer amount exceeds the maxTransactionAmount."
760                     );
761                     require(
762                         amount + balanceOf(to) <= maxWallet,
763                         "Max wallet exceeded"
764                     );
765                 }
766                 //when sell
767                 else if (
768                     automatedMarketMakerPairs[to] &&
769                     !_isExcludedMaxTransactionAmount[from]
770                 ) {
771                     require(
772                         amount <= maxTransactionAmount,
773                         "Sell transfer amount exceeds the maxTransactionAmount."
774                     );
775                 } else if (!_isExcludedMaxTransactionAmount[to]) {
776                     require(
777                         amount + balanceOf(to) <= maxWallet,
778                         "Max wallet exceeded"
779                     );
780                 }
781             }
782         }
783 
784         uint256 contractTokenBalance = balanceOf(address(this));
785 
786         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
787 
788         if (
789             canSwap &&
790             !swapping &&
791             !automatedMarketMakerPairs[from] &&
792             !_isExcludedFromFees[from] &&
793             !_isExcludedFromFees[to]
794         ) {
795             swapping = true;
796 
797             swapBack();
798 
799             swapping = false;
800         }
801 
802         if (
803             !swapping &&
804             automatedMarketMakerPairs[to] &&
805             lpBurnEnabled &&
806             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
807             !_isExcludedFromFees[from]
808         ) {
809             autoBurnLiquidityPairTokens();
810         }
811 
812         bool takeFee = !swapping;
813 
814         // if any account belongs to _isExcludedFromFee account then remove the fee
815         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
816             takeFee = false;
817         }
818 
819         uint256 fees = 0;
820         // only take fees on buys/sells, do not take on wallet transfers
821         if (takeFee) {
822             // on sell
823             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
824                 fees = amount.mul(sellTotalFees).div(100);
825                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
826                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
827             }
828             // on buy
829             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
830                 fees = amount.mul(buyTotalFees).div(100);
831                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
832                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
833             }
834 
835             if (fees > 0) {
836                 super._transfer(from, address(this), fees);
837             }
838 
839             amount -= fees;
840         }
841 
842         super._transfer(from, to, amount);
843     }
844 
845     function swapTokensForEth(uint256 tokenAmount) private {
846         // generate the uniswap pair path of token -> weth
847         address[] memory path = new address[](2);
848         path[0] = address(this);
849         path[1] = uniswapV2Router.WETH();
850 
851         _approve(address(this), address(uniswapV2Router), tokenAmount);
852 
853         // make the swap
854         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
855             tokenAmount,
856             0, // accept any amount of ETH
857             path,
858             address(this),
859             block.timestamp
860         );
861     }
862 
863     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
864         // approve token transfer to cover all possible scenarios
865         _approve(address(this), address(uniswapV2Router), tokenAmount);
866 
867         // add the liquidity
868         uniswapV2Router.addLiquidityETH{value: ethAmount}(
869             address(this),
870             tokenAmount,
871             0, // slippage is unavoidable
872             0, // slippage is unavoidable
873             deadAddress,
874             block.timestamp
875         );
876     }
877 
878     function swapBack() private {
879         uint256 contractBalance = balanceOf(address(this));
880         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
881         bool success;
882 
883         if (contractBalance == 0 || totalTokensToSwap == 0) {
884             return;
885         }
886 
887         if (contractBalance > swapTokensAtAmount * 20) {
888             contractBalance = swapTokensAtAmount * 20;
889         }
890 
891         // Halve the amount of liquidity tokens
892         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
893             totalTokensToSwap /
894             2;
895         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
896 
897         uint256 initialETHBalance = address(this).balance;
898 
899         swapTokensForEth(amountToSwapForETH);
900 
901         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
902 
903         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
904             totalTokensToSwap
905         );
906 
907         uint256 ethForLiquidity = ethBalance - ethForMarketing;
908 
909         tokensForLiquidity = 0;
910         tokensForMarketing = 0;
911 
912         if (liquidityTokens > 0 && ethForLiquidity > 0) {
913             addLiquidity(liquidityTokens, ethForLiquidity);
914             emit SwapAndLiquify(
915                 amountToSwapForETH,
916                 ethForLiquidity,
917                 tokensForLiquidity
918             );
919         }
920 
921         (success, ) = address(marketingWallet).call{
922             value: address(this).balance
923         }("");
924     }
925 
926     function autoBurnLiquidityPairTokens() internal returns (bool) {
927         lastLpBurnTime = block.timestamp;
928 
929         // get balance of liquidity pair
930         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
931 
932         // calculate amount to burn
933         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
934             10000
935         );
936 
937         // pull tokens from pancakePair liquidity and move to dead address permanently
938         if (amountToBurn > 0) {
939             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
940         }
941 
942         //sync price since this is not in a swap transaction!
943         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
944         pair.sync();
945         emit AutoNukeLP();
946         return true;
947     }
948 }