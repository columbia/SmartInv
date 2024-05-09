1 /**
2 
3 
4 Ambo somniant.
5 
6 These are the words of him who holds the seven stars in his right hand and walks among the seven golden lampstands.
7 
8 v=Ai0Dk9q8IbE 
9 
10 (0.57)
11 
12 
13 LXYSM IX XAE LEVK YJ MHO LXAN
14 
15 ***/
16 
17 
18 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
19 pragma experimental ABIEncoderV2;
20 
21 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 
33 abstract contract Ownable is Context {
34     address private _owner;
35 
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38 
39     constructor() {
40         _transferOwnership(_msgSender());
41     }
42 
43 
44     function owner() public view virtual returns (address) {
45         return _owner;
46     }
47 
48 
49     modifier onlyOwner() {
50         require(owner() == _msgSender(), "Ownable: caller is not the owner");
51         _;
52     }
53 
54 
55     function renounceOwnership() public virtual onlyOwner {
56         _transferOwnership(address(0));
57     }
58 
59 
60     function transferOwnership(address newOwner) public virtual onlyOwner {
61         require(newOwner != address(0), "Ownable: new owner is the zero address");
62         _transferOwnership(newOwner);
63     }
64 
65 
66     function _transferOwnership(address newOwner) internal virtual {
67         address oldOwner = _owner;
68         _owner = newOwner;
69         emit OwnershipTransferred(oldOwner, newOwner);
70     }
71 }
72 
73 //... . . -.- / .- -. -.. / -.-- --- ..- / .-- .. .-.. .-.. / ... . . -.- / ... --- -- . / -- --- .-. .
74 
75 interface IERC20 {
76 
77     function totalSupply() external view returns (uint256);
78 
79 
80     function balanceOf(address account) external view returns (uint256);
81 
82 
83     function transfer(address recipient, uint256 amount) external returns (bool);
84 
85 
86     function allowance(address owner, address spender) external view returns (uint256);
87 
88     function approve(address spender, uint256 amount) external returns (bool);
89 
90     function transferFrom(
91         address sender,
92         address recipient,
93         uint256 amount
94     ) external returns (bool);
95 
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98 
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 
103 
104 
105 
106 interface IERC20Metadata is IERC20 {
107 
108     function name() external view returns (string memory);
109 
110 
111     function symbol() external view returns (string memory);
112 
113 
114     function decimals() external view returns (uint8);
115 }
116 
117 
118 
119 contract ERC20 is Context, IERC20, IERC20Metadata {
120     mapping(address => uint256) private _balances;
121 
122     mapping(address => mapping(address => uint256)) private _allowances;
123 
124     uint256 private _totalSupply;
125 
126     string private _name;
127     string private _symbol;
128 
129 
130     constructor(string memory name_, string memory symbol_) {
131         _name = name_;
132         _symbol = symbol_;
133     }
134 
135 
136     function name() public view virtual override returns (string memory) {
137         return _name;
138     }
139 
140 
141     function symbol() public view virtual override returns (string memory) {
142         return _symbol;
143     }
144 
145 
146     function decimals() public view virtual override returns (uint8) {
147         return 18;
148     }
149 
150 
151     function totalSupply() public view virtual override returns (uint256) {
152         return _totalSupply;
153     }
154 
155 
156     function balanceOf(address account) public view virtual override returns (uint256) {
157         return _balances[account];
158     }
159 
160 
161     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
162         _transfer(_msgSender(), recipient, amount);
163         return true;
164     }
165 
166 
167     function allowance(address owner, address spender) public view virtual override returns (uint256) {
168         return _allowances[owner][spender];
169     }
170 
171 
172     function approve(address spender, uint256 amount) public virtual override returns (bool) {
173         _approve(_msgSender(), spender, amount);
174         return true;
175     }
176 
177 
178     function transferFrom(
179         address sender,
180         address recipient,
181         uint256 amount
182     ) public virtual override returns (bool) {
183         _transfer(sender, recipient, amount);
184 
185         uint256 currentAllowance = _allowances[sender][_msgSender()];
186         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
187         unchecked {
188             _approve(sender, _msgSender(), currentAllowance - amount);
189         }
190 
191         return true;
192     }
193 
194 
195     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
196         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
197         return true;
198     }
199 
200 
201     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
202         uint256 currentAllowance = _allowances[_msgSender()][spender];
203         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
204         unchecked {
205             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
206         }
207 
208         return true;
209     }
210 
211 
212     function _transfer(
213         address sender,
214         address recipient,
215         uint256 amount
216     ) internal virtual {
217         require(sender != address(0), "ERC20: transfer from the zero address");
218         require(recipient != address(0), "ERC20: transfer to the zero address");
219 
220         _beforeTokenTransfer(sender, recipient, amount);
221 
222         uint256 senderBalance = _balances[sender];
223         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
224         unchecked {
225             _balances[sender] = senderBalance - amount;
226         }
227         _balances[recipient] += amount;
228 
229         emit Transfer(sender, recipient, amount);
230 
231         _afterTokenTransfer(sender, recipient, amount);
232     }
233 
234 
235     function _mint(address account, uint256 amount) internal virtual {
236         require(account != address(0), "ERC20: mint to the zero address");
237 
238         _beforeTokenTransfer(address(0), account, amount);
239 
240         _totalSupply += amount;
241         _balances[account] += amount;
242         emit Transfer(address(0), account, amount);
243 
244         _afterTokenTransfer(address(0), account, amount);
245     }
246 
247 
248     function _burn(address account, uint256 amount) internal virtual {
249         require(account != address(0), "ERC20: burn from the zero address");
250 
251         _beforeTokenTransfer(account, address(0), amount);
252 
253         uint256 accountBalance = _balances[account];
254         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
255         unchecked {
256             _balances[account] = accountBalance - amount;
257         }
258         _totalSupply -= amount;
259 
260         emit Transfer(account, address(0), amount);
261 
262         _afterTokenTransfer(account, address(0), amount);
263     }
264 
265 
266     function _approve(
267         address owner,
268         address spender,
269         uint256 amount
270     ) internal virtual {
271         require(owner != address(0), "ERC20: approve from the zero address");
272         require(spender != address(0), "ERC20: approve to the zero address");
273 
274         _allowances[owner][spender] = amount;
275         emit Approval(owner, spender, amount);
276     }
277 
278 
279     function _beforeTokenTransfer(
280         address from,
281         address to,
282         uint256 amount
283     ) internal virtual {}
284 
285 
286     function _afterTokenTransfer(
287         address from,
288         address to,
289         uint256 amount
290     ) internal virtual {}
291 }
292 
293 
294 library SafeMath {
295 
296     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
297         unchecked {
298             uint256 c = a + b;
299             if (c < a) return (false, 0);
300             return (true, c);
301         }
302     }
303 
304 
305     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
306         unchecked {
307             if (b > a) return (false, 0);
308             return (true, a - b);
309         }
310     }
311 
312 
313     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
314         unchecked {
315 
316             if (a == 0) return (true, 0);
317             uint256 c = a * b;
318             if (c / a != b) return (false, 0);
319             return (true, c);
320         }
321     }
322 
323 
324     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
325         unchecked {
326             if (b == 0) return (false, 0);
327             return (true, a / b);
328         }
329     }
330 
331 
332     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
333         unchecked {
334             if (b == 0) return (false, 0);
335             return (true, a % b);
336         }
337     }
338 
339 
340     function add(uint256 a, uint256 b) internal pure returns (uint256) {
341         return a + b;
342     }
343 
344 
345     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
346         return a - b;
347     }
348 
349 
350     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
351         return a * b;
352     }
353 
354 
355     function div(uint256 a, uint256 b) internal pure returns (uint256) {
356         return a / b;
357     }
358 
359 
360     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
361         return a % b;
362     }
363 
364 
365     function sub(
366         uint256 a,
367         uint256 b,
368         string memory errorMessage
369     ) internal pure returns (uint256) {
370         unchecked {
371             require(b <= a, errorMessage);
372             return a - b;
373         }
374     }
375 
376 
377     function div(
378         uint256 a,
379         uint256 b,
380         string memory errorMessage
381     ) internal pure returns (uint256) {
382         unchecked {
383             require(b > 0, errorMessage);
384             return a / b;
385         }
386     }
387 
388 
389     function mod(
390         uint256 a,
391         uint256 b,
392         string memory errorMessage
393     ) internal pure returns (uint256) {
394         unchecked {
395             require(b > 0, errorMessage);
396             return a % b;
397         }
398     }
399 }
400 
401 
402 interface IUniswapV2Factory {
403     event PairCreated(
404         address indexed token0,
405         address indexed token1,
406         address pair,
407         uint256
408     );
409 
410     function feeTo() external view returns (address);
411 
412     function feeToSetter() external view returns (address);
413 
414     function getPair(address tokenA, address tokenB)
415         external
416         view
417         returns (address pair);
418 
419     function allPairs(uint256) external view returns (address pair);
420 
421     function allPairsLength() external view returns (uint256);
422 
423     function createPair(address tokenA, address tokenB)
424         external
425         returns (address pair);
426 
427     function setFeeTo(address) external;
428 
429     function setFeeToSetter(address) external;
430 }
431 
432 
433 
434 interface IUniswapV2Pair {
435     event Approval(
436         address indexed owner,
437         address indexed spender,
438         uint256 value
439     );
440     event Transfer(address indexed from, address indexed to, uint256 value);
441 
442     function name() external pure returns (string memory);
443 
444     function symbol() external pure returns (string memory);
445 
446     function decimals() external pure returns (uint8);
447 
448     function totalSupply() external view returns (uint256);
449 
450     function balanceOf(address owner) external view returns (uint256);
451 
452     function allowance(address owner, address spender)
453         external
454         view
455         returns (uint256);
456 
457     function approve(address spender, uint256 value) external returns (bool);
458 
459     function transfer(address to, uint256 value) external returns (bool);
460 
461     function transferFrom(
462         address from,
463         address to,
464         uint256 value
465     ) external returns (bool);
466 
467     function DOMAIN_SEPARATOR() external view returns (bytes32);
468 
469     function PERMIT_TYPEHASH() external pure returns (bytes32);
470 
471     function nonces(address owner) external view returns (uint256);
472 
473     function permit(
474         address owner,
475         address spender,
476         uint256 value,
477         uint256 deadline,
478         uint8 v,
479         bytes32 r,
480         bytes32 s
481     ) external;
482 
483     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
484     event Burn(
485         address indexed sender,
486         uint256 amount0,
487         uint256 amount1,
488         address indexed to
489     );
490     event Swap(
491         address indexed sender,
492         uint256 amount0In,
493         uint256 amount1In,
494         uint256 amount0Out,
495         uint256 amount1Out,
496         address indexed to
497     );
498     event Sync(uint112 reserve0, uint112 reserve1);
499 
500     function MINIMUM_LIQUIDITY() external pure returns (uint256);
501 
502     function factory() external view returns (address);
503 
504     function token0() external view returns (address);
505 
506     function token1() external view returns (address);
507 
508     function getReserves()
509         external
510         view
511         returns (
512             uint112 reserve0,
513             uint112 reserve1,
514             uint32 blockTimestampLast
515         );
516 
517     function price0CumulativeLast() external view returns (uint256);
518 
519     function price1CumulativeLast() external view returns (uint256);
520 
521     function kLast() external view returns (uint256);
522 
523     function mint(address to) external returns (uint256 liquidity);
524 
525     function burn(address to)
526         external
527         returns (uint256 amount0, uint256 amount1);
528 
529     function swap(
530         uint256 amount0Out,
531         uint256 amount1Out,
532         address to,
533         bytes calldata data
534     ) external;
535 
536     function skim(address to) external;
537 
538     function sync() external;
539 
540     function initialize(address, address) external;
541 }
542 
543 
544 interface IUniswapV2Router02 {
545     function factory() external pure returns (address);
546 
547     function WETH() external pure returns (address);
548 
549     function addLiquidity(
550         address tokenA,
551         address tokenB,
552         uint256 amountADesired,
553         uint256 amountBDesired,
554         uint256 amountAMin,
555         uint256 amountBMin,
556         address to,
557         uint256 deadline
558     )
559         external
560         returns (
561             uint256 amountA,
562             uint256 amountB,
563             uint256 liquidity
564         );
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
576         returns (
577             uint256 amountToken,
578             uint256 amountETH,
579             uint256 liquidity
580         );
581 
582     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
583         uint256 amountIn,
584         uint256 amountOutMin,
585         address[] calldata path,
586         address to,
587         uint256 deadline
588     ) external;
589 
590     function swapExactETHForTokensSupportingFeeOnTransferTokens(
591         uint256 amountOutMin,
592         address[] calldata path,
593         address to,
594         uint256 deadline
595     ) external payable;
596 
597     function swapExactTokensForETHSupportingFeeOnTransferTokens(
598         uint256 amountIn,
599         uint256 amountOutMin,
600         address[] calldata path,
601         address to,
602         uint256 deadline
603     ) external;
604 }
605 
606 
607 
608 contract SEFIROT is ERC20, Ownable {
609     using SafeMath for uint256;
610 
611     IUniswapV2Router02 public immutable uniswapV2Router;
612     address public immutable uniswapV2Pair;
613     address public constant deadAddress = address(0xdead);
614 
615     bool private swapping;
616 
617     address public X647265616dWallet;
618     address public X68656c706572Wallet;
619 
620     uint256 public maxTransactionAmount;
621     uint256 public swapTokensAtAmount;
622     uint256 public maxWallet;
623 
624     uint256 public percentForLPBurn = 25; // 25 = .25%
625     bool public lpBurnEnabled = true;
626     uint256 public lpBurnFrequency = 3600 seconds;
627     uint256 public lastLpBurnTime;
628 
629     uint256 public manualBurnFrequency = 30 minutes;
630     uint256 public lastManualLpBurnTime;
631 
632     bool public limitsInEffect = true;
633     bool public tradingActive = false;
634     bool public swapEnabled = false;
635 
636 
637     mapping(address => uint256) private _holderLastTransferTimestamp;
638     bool public transferDelayEnabled = true;
639 
640     uint256 public buyTotalFees;
641     uint256 public buyX647265616dFee;
642     uint256 public buyLiquidityFee;
643     uint256 public buyX68656c706572Fee;
644 
645     uint256 public sellTotalFees;
646     uint256 public sellX647265616dFee;
647     uint256 public sellLiquidityFee;
648     uint256 public sellX68656c706572Fee;
649 
650     uint256 public tokensForX647265616d;
651     uint256 public tokensForLiquidity;
652     uint256 public tokensForX68656c706572;
653 
654     mapping(address => bool) private _isExcludedFromFees;
655     mapping(address => bool) public _isExcludedMaxTransactionAmount;
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
668     event X647265616dWalletUpdated(
669         address indexed newWallet,
670         address indexed oldWallet
671     );
672 
673     event X68656c706572WalletUpdated(
674         address indexed newWallet,
675         address indexed oldWallet
676     );
677 
678     event SwapAndLiquify(
679         uint256 tokensSwapped,
680         uint256 ethReceived,
681         uint256 tokensIntoLiquidity
682     );
683 
684     event AutoNukeLP();
685 
686     event ManualNukeLP();
687 
688     constructor() ERC20("656e69676d61", "KETER") {
689         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
690             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
691         );
692 
693         excludeFromMaxTransaction(address(_uniswapV2Router), true);
694         uniswapV2Router = _uniswapV2Router;
695 
696         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
697             .createPair(address(this), _uniswapV2Router.WETH());
698         excludeFromMaxTransaction(address(uniswapV2Pair), true);
699         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
700 
701         uint256 _buyX647265616dFee = 2;
702         uint256 _buyLiquidityFee = 1;
703         uint256 _buyX68656c706572Fee = 2;
704 
705         uint256 _sellX647265616dFee = 5;
706         uint256 _sellLiquidityFee = 3;
707         uint256 _sellX68656c706572Fee = 2;
708 
709         uint256 totalSupply = 1_000_000_000 * 1e18;
710 
711         maxTransactionAmount = 1_270_000 * 1e18;
712         maxWallet = 2_400_000 * 1e18; //
713         swapTokensAtAmount = (totalSupply * 5) / 10000;
714 
715         buyX647265616dFee = _buyX647265616dFee;
716         buyLiquidityFee = _buyLiquidityFee;
717         buyX68656c706572Fee = _buyX68656c706572Fee;
718         buyTotalFees = buyX647265616dFee + buyLiquidityFee + buyX68656c706572Fee;
719 
720         sellX647265616dFee = _sellX647265616dFee;
721         sellLiquidityFee = _sellLiquidityFee;
722         sellX68656c706572Fee = _sellX68656c706572Fee;
723         sellTotalFees = sellX647265616dFee + sellLiquidityFee + sellX68656c706572Fee;
724 
725         X647265616dWallet = address(0xDd71522e62F9a66DCFc7Ad4dF19ACc2DB9496113); // set as X647265616d wallet
726         X68656c706572Wallet = address(0xa47E16D724A490Be220114ab6dc244D6B188C459); // set as X68656c706572 wallet
727 
728 
729         excludeFromFees(owner(), true);
730         excludeFromFees(address(this), true);
731         excludeFromFees(address(0xdead), true);
732 
733         excludeFromMaxTransaction(owner(), true);
734         excludeFromMaxTransaction(address(this), true);
735         excludeFromMaxTransaction(address(0xdead), true);
736 
737 
738         _mint(msg.sender, totalSupply);
739     }
740 
741     receive() external payable {}
742 
743 
744     function enableTrading() external onlyOwner {
745         tradingActive = true;
746         swapEnabled = true;
747         lastLpBurnTime = block.timestamp;
748     }
749 
750 
751     function removeLimits() external onlyOwner returns (bool) {
752         limitsInEffect = false;
753         return true;
754     }
755 
756 
757     function disableTransferDelay() external onlyOwner returns (bool) {
758         transferDelayEnabled = false;
759         return true;
760     }
761 
762 
763     function updateSwapTokensAtAmount(uint256 newAmount)
764         external
765         onlyOwner
766         returns (bool)
767     {
768         require(
769             newAmount >= (totalSupply() * 1) / 100000,
770             "Swap amount cannot be lower than 0.001% total supply."
771         );
772         require(
773             newAmount <= (totalSupply() * 5) / 1000,
774             "Swap amount cannot be higher than 0.5% total supply."
775         );
776         swapTokensAtAmount = newAmount;
777         return true;
778     }
779 
780     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
781         require(
782             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
783             "Cannot set maxTransactionAmount lower than 0.1%"
784         );
785         maxTransactionAmount = newNum * (10**18);
786     }
787 
788     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
789         require(
790             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
791             "Cannot set maxWallet lower than 0.5%"
792         );
793         maxWallet = newNum * (10**18);
794     }
795 
796     function excludeFromMaxTransaction(address updAds, bool isEx)
797         public
798         onlyOwner
799     {
800         _isExcludedMaxTransactionAmount[updAds] = isEx;
801     }
802 
803 
804     function updateSwapEnabled(bool enabled) external onlyOwner {
805         swapEnabled = enabled;
806     }
807 
808     function updateBuyFees(
809         uint256 _X647265616dFee,
810         uint256 _liquidityFee,
811         uint256 _X68656c706572Fee
812     ) external onlyOwner {
813         buyX647265616dFee = _X647265616dFee;
814         buyLiquidityFee = _liquidityFee;
815         buyX68656c706572Fee = _X68656c706572Fee;
816         buyTotalFees = buyX647265616dFee + buyLiquidityFee + buyX68656c706572Fee;
817         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
818     }
819 
820     function updateSellFees(
821         uint256 _X647265616dFee,
822         uint256 _liquidityFee,
823         uint256 _X68656c706572Fee
824     ) external onlyOwner {
825         sellX647265616dFee = _X647265616dFee;
826         sellLiquidityFee = _liquidityFee;
827         sellX68656c706572Fee = _X68656c706572Fee;
828         sellTotalFees = sellX647265616dFee + sellLiquidityFee + sellX68656c706572Fee;
829         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
830     }
831 
832     function excludeFromFees(address account, bool excluded) public onlyOwner {
833         _isExcludedFromFees[account] = excluded;
834         emit ExcludeFromFees(account, excluded);
835     }
836 
837     function setAutomatedMarketMakerPair(address pair, bool value)
838         public
839         onlyOwner
840     {
841         require(
842             pair != uniswapV2Pair,
843             "The pair cannot be removed from automatedMarketMakerPairs"
844         );
845 
846         _setAutomatedMarketMakerPair(pair, value);
847     }
848 
849     function _setAutomatedMarketMakerPair(address pair, bool value) private {
850         automatedMarketMakerPairs[pair] = value;
851 
852         emit SetAutomatedMarketMakerPair(pair, value);
853     }
854 
855     function updateX647265616dWallet(address newX647265616dWallet)
856         external
857         onlyOwner
858     {
859         emit X647265616dWalletUpdated(newX647265616dWallet, X647265616dWallet);
860         X647265616dWallet = newX647265616dWallet;
861     }
862 
863     function updateX68656c706572Wallet(address newWallet) external onlyOwner {
864         emit X68656c706572WalletUpdated(newWallet, X68656c706572Wallet);
865         X68656c706572Wallet = newWallet;
866     }
867 
868     function isExcludedFromFees(address account) public view returns (bool) {
869         return _isExcludedFromFees[account];
870     }
871 
872     event BoughtEarly(address indexed sniper);
873 
874     function _transfer(
875         address from,
876         address to,
877         uint256 amount
878     ) internal override {
879         require(from != address(0), "ERC20: transfer from the zero address");
880         require(to != address(0), "ERC20: transfer to the zero address");
881 
882         if (amount == 0) {
883             super._transfer(from, to, 0);
884             return;
885         }
886 
887         if (limitsInEffect) {
888             if (
889                 from != owner() &&
890                 to != owner() &&
891                 to != address(0) &&
892                 to != address(0xdead) &&
893                 !swapping
894             ) {
895                 if (!tradingActive) {
896                     require(
897                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
898                         "Trading is not active."
899                     );
900                 }
901 
902                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
903                 if (transferDelayEnabled) {
904                     if (
905                         to != owner() &&
906                         to != address(uniswapV2Router) &&
907                         to != address(uniswapV2Pair)
908                     ) {
909                         require(
910                             _holderLastTransferTimestamp[tx.origin] <
911                                 block.number,
912                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
913                         );
914                         _holderLastTransferTimestamp[tx.origin] = block.number;
915                     }
916                 }
917 
918                 //when buy
919                 if (
920                     automatedMarketMakerPairs[from] &&
921                     !_isExcludedMaxTransactionAmount[to]
922                 ) {
923                     require(
924                         amount <= maxTransactionAmount,
925                         "Buy transfer amount exceeds the maxTransactionAmount."
926                     );
927                     require(
928                         amount + balanceOf(to) <= maxWallet,
929                         "Max wallet exceeded"
930                     );
931                 }
932                 //when sell
933                 else if (
934                     automatedMarketMakerPairs[to] &&
935                     !_isExcludedMaxTransactionAmount[from]
936                 ) {
937                     require(
938                         amount <= maxTransactionAmount,
939                         "Sell transfer amount exceeds the maxTransactionAmount."
940                     );
941                 } else if (!_isExcludedMaxTransactionAmount[to]) {
942                     require(
943                         amount + balanceOf(to) <= maxWallet,
944                         "Max wallet exceeded"
945                     );
946                 }
947             }
948         }
949 
950         uint256 contractTokenBalance = balanceOf(address(this));
951 
952         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
953 
954         if (
955             canSwap &&
956             swapEnabled &&
957             !swapping &&
958             !automatedMarketMakerPairs[from] &&
959             !_isExcludedFromFees[from] &&
960             !_isExcludedFromFees[to]
961         ) {
962             swapping = true;
963 
964             swapBack();
965 
966             swapping = false;
967         }
968 
969         if (
970             !swapping &&
971             automatedMarketMakerPairs[to] &&
972             lpBurnEnabled &&
973             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
974             !_isExcludedFromFees[from]
975         ) {
976             autoBurnLiquidityPairTokens();
977         }
978 
979         bool takeFee = !swapping;
980 
981         // if any account belongs to _isExcludedFromFee account then remove the fee
982         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
983             takeFee = false;
984         }
985 
986         uint256 fees = 0;
987         // only take fees on buys/sells, do not take on wallet transfers
988         if (takeFee) {
989             // on sell
990             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
991                 fees = amount.mul(sellTotalFees).div(100);
992                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
993                 tokensForX68656c706572 += (fees * sellX68656c706572Fee) / sellTotalFees;
994                 tokensForX647265616d += (fees * sellX647265616dFee) / sellTotalFees;
995             }
996             // on buy
997             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
998                 fees = amount.mul(buyTotalFees).div(100);
999                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1000                 tokensForX68656c706572 += (fees * buyX68656c706572Fee) / buyTotalFees;
1001                 tokensForX647265616d += (fees * buyX647265616dFee) / buyTotalFees;
1002             }
1003 
1004             if (fees > 0) {
1005                 super._transfer(from, address(this), fees);
1006             }
1007 
1008             amount -= fees;
1009         }
1010 
1011         super._transfer(from, to, amount);
1012     }
1013 
1014     function swapTokensForEth(uint256 tokenAmount) private {
1015         // generate the uniswap pair path of token -> weth
1016         address[] memory path = new address[](2);
1017         path[0] = address(this);
1018         path[1] = uniswapV2Router.WETH();
1019 
1020         _approve(address(this), address(uniswapV2Router), tokenAmount);
1021 
1022         // make the swap
1023         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1024             tokenAmount,
1025             0, // accept any amount of ETH
1026             path,
1027             address(this),
1028             block.timestamp
1029         );
1030     }
1031 
1032     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1033         // approve token transfer to cover all possible scenarios
1034         _approve(address(this), address(uniswapV2Router), tokenAmount);
1035 
1036         // add the liquidity
1037         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1038             address(this),
1039             tokenAmount,
1040             0, // slippage is unavoidable
1041             0, // slippage is unavoidable
1042             deadAddress,
1043             block.timestamp
1044         );
1045     }
1046 
1047     function swapBack() private {
1048         uint256 contractBalance = balanceOf(address(this));
1049         uint256 totalTokensToSwap = tokensForLiquidity +
1050             tokensForX647265616d +
1051             tokensForX68656c706572;
1052         bool success;
1053 
1054         if (contractBalance == 0 || totalTokensToSwap == 0) {
1055             return;
1056         }
1057 
1058         if (contractBalance > swapTokensAtAmount * 20) {
1059             contractBalance = swapTokensAtAmount * 20;
1060         }
1061 
1062         // Et sic incepit, ipsum verum principium 11B-X-1371
1063 
1064         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1065             totalTokensToSwap /
1066             2;
1067         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1068 
1069         uint256 initialETHBalance = address(this).balance;
1070 
1071         swapTokensForEth(amountToSwapForETH);
1072 
1073         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1074 
1075         uint256 ethForX647265616d = ethBalance.mul(tokensForX647265616d).div(
1076             totalTokensToSwap
1077         );
1078         uint256 ethForX68656c706572 = ethBalance.mul(tokensForX68656c706572).div(totalTokensToSwap);
1079 
1080         uint256 ethForLiquidity = ethBalance - ethForX647265616d - ethForX68656c706572;
1081 
1082         tokensForLiquidity = 0;
1083         tokensForX647265616d = 0;
1084         tokensForX68656c706572 = 0;
1085 
1086         (success, ) = address(X68656c706572Wallet).call{value: ethForX68656c706572}("");
1087 
1088         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1089             addLiquidity(liquidityTokens, ethForLiquidity);
1090             emit SwapAndLiquify(
1091                 amountToSwapForETH,
1092                 ethForLiquidity,
1093                 tokensForLiquidity
1094             );
1095         }
1096 
1097         (success, ) = address(X647265616dWallet).call{
1098             value: address(this).balance
1099         }("");
1100     }
1101 
1102     function setAutoLPBurnSettings(
1103         uint256 _frequencyInSeconds,
1104         uint256 _percent,
1105         bool _Enabled
1106     ) external onlyOwner {
1107         require(
1108             _frequencyInSeconds >= 600,
1109             "cannot set buyback more often than every 10 minutes"
1110         );
1111         require(
1112             _percent <= 1000 && _percent >= 0,
1113             "Must set auto LP burn percent between 0% and 10%"
1114         );
1115         lpBurnFrequency = _frequencyInSeconds;
1116         percentForLPBurn = _percent;
1117         lpBurnEnabled = _Enabled;
1118     }
1119 
1120     function autoBurnLiquidityPairTokens() internal returns (bool) {
1121         lastLpBurnTime = block.timestamp;
1122 
1123         // get balance of liquidity pair
1124         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1125 
1126         // calculate amount to burn
1127         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1128             10000
1129         );
1130 
1131         // pull tokens from pancakePair liquidity and move to dead address permanently
1132         if (amountToBurn > 0) {
1133             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1134         }
1135 
1136         //sync price since this is not in a swap transaction!
1137         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1138         pair.sync();
1139         emit AutoNukeLP();
1140         return true;
1141     }
1142 
1143     function manualBurnLiquidityPairTokens(uint256 percent)
1144         external
1145         onlyOwner
1146         returns (bool)
1147     {
1148         require(
1149             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1150             "Must wait for cooldown to finish"
1151         );
1152         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1153         lastManualLpBurnTime = block.timestamp;
1154 
1155         // get balance of liquidity pair
1156         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1157 
1158         // calculate amount to burn
1159         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1160 
1161         // pull tokens from pancakePair liquidity and move to dead address permanently
1162         if (amountToBurn > 0) {
1163             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1164         }
1165 
1166         //sync price since this is not in a swap transaction!
1167         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1168         pair.sync();
1169         emit ManualNukeLP();
1170         return true;
1171     }
1172 }
1173 /* 22 59 6f 75 20 68 61 76 65 20 70 65 72 73 65 76 65 72 65 64 20 61 6e 64 20 68 61 76 65 20 65 6e 64 75 72 65 64 20 68 61 72 64 73 68 69 70 73 20 66 6f 72 20 6d 79 20 6e 61 6d 65 2c 20 61 6e 64 20 68 61 76 65 20 6e 6f 74 20 67 72 6f 77 6e 20 77 65 61 72 79 2e 22  */