1 /**
2 
3 GryffindorSlytherinRetroArcade09inu ($LUNA)
4 https://t.me/GSRA09i
5 
6 */
7 // SPDX-License-Identifier: MIT
8 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
9 pragma experimental ABIEncoderV2;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes calldata) {
17         return msg.data;
18     }
19 }
20 
21 abstract contract Ownable is Context {
22     address private _owner;
23 
24     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26     constructor() {
27         _transferOwnership(_msgSender());
28     }
29 
30     function owner() public view virtual returns (address) {
31         return _owner;
32     }
33 
34     modifier onlyOwner() {
35         require(owner() == _msgSender(), "Ownable: caller is not the owner");
36         _;
37     }
38 
39     function renounceOwnership() public virtual onlyOwner {
40         _transferOwnership(address(0));
41     }
42 
43     function transferOwnership(address newOwner) public virtual onlyOwner {
44         require(newOwner != address(0), "Ownable: new owner is the zero address");
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
61     function transfer(address recipient, uint256 amount) external returns (bool);
62 
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     function approve(address spender, uint256 amount) external returns (bool);
66 
67     function transferFrom(
68         address sender,
69         address recipient,
70         uint256 amount
71     ) external returns (bool);
72 
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 interface IERC20Metadata is IERC20 {
79 
80     function name() external view returns (string memory);
81 
82     function symbol() external view returns (string memory);
83 
84     function decimals() external view returns (uint8);
85 }
86 
87 contract ERC20 is Context, IERC20, IERC20Metadata {
88     mapping(address => uint256) private _balances;
89 
90     mapping(address => mapping(address => uint256)) private _allowances;
91 
92     uint256 private _totalSupply;
93 
94     string private _name;
95     string private _symbol;
96 
97     constructor(string memory name_, string memory symbol_) {
98         _name = name_;
99         _symbol = symbol_;
100     }
101 
102     function name() public view virtual override returns (string memory) {
103         return _name;
104     }
105 
106     function symbol() public view virtual override returns (string memory) {
107         return _symbol;
108     }
109 
110     function decimals() public view virtual override returns (uint8) {
111         return 18;
112     }
113 
114     function totalSupply() public view virtual override returns (uint256) {
115         return _totalSupply;
116     }
117 
118     function balanceOf(address account) public view virtual override returns (uint256) {
119         return _balances[account];
120     }
121 
122     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
123         _transfer(_msgSender(), recipient, amount);
124         return true;
125     }
126 
127     function allowance(address owner, address spender) public view virtual override returns (uint256) {
128         return _allowances[owner][spender];
129     }
130 
131     function approve(address spender, uint256 amount) public virtual override returns (bool) {
132         _approve(_msgSender(), spender, amount);
133         return true;
134     }
135 
136     function transferFrom(
137         address sender,
138         address recipient,
139         uint256 amount
140     ) public virtual override returns (bool) {
141         _transfer(sender, recipient, amount);
142 
143         uint256 currentAllowance = _allowances[sender][_msgSender()];
144         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
145         unchecked {
146             _approve(sender, _msgSender(), currentAllowance - amount);
147         }
148 
149         return true;
150     }
151 
152     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
153         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
154         return true;
155     }
156 
157     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
158         uint256 currentAllowance = _allowances[_msgSender()][spender];
159         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
160         unchecked {
161             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
162         }
163 
164         return true;
165     }
166 
167     function _transfer(
168         address sender,
169         address recipient,
170         uint256 amount
171     ) internal virtual {
172         require(sender != address(0), "ERC20: transfer from the zero address");
173         require(recipient != address(0), "ERC20: transfer to the zero address");
174 
175         _beforeTokenTransfer(sender, recipient, amount);
176 
177         uint256 senderBalance = _balances[sender];
178         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
179         unchecked {
180             _balances[sender] = senderBalance - amount;
181         }
182         _balances[recipient] += amount;
183 
184         emit Transfer(sender, recipient, amount);
185 
186         _afterTokenTransfer(sender, recipient, amount);
187     }
188 
189     function _mint(address account, uint256 amount) internal virtual {
190         require(account != address(0), "ERC20: mint to the zero address");
191 
192         _beforeTokenTransfer(address(0), account, amount);
193 
194         _totalSupply += amount;
195         _balances[account] += amount;
196         emit Transfer(address(0), account, amount);
197 
198         _afterTokenTransfer(address(0), account, amount);
199     }
200 
201     function _burn(address account, uint256 amount) internal virtual {
202         require(account != address(0), "ERC20: burn from the zero address");
203 
204         _beforeTokenTransfer(account, address(0), amount);
205 
206         uint256 accountBalance = _balances[account];
207         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
208         unchecked {
209             _balances[account] = accountBalance - amount;
210         }
211         _totalSupply -= amount;
212 
213         emit Transfer(account, address(0), amount);
214 
215         _afterTokenTransfer(account, address(0), amount);
216     }
217 
218     function _approve(
219         address owner,
220         address spender,
221         uint256 amount
222     ) internal virtual {
223         require(owner != address(0), "ERC20: approve from the zero address");
224         require(spender != address(0), "ERC20: approve to the zero address");
225 
226         _allowances[owner][spender] = amount;
227         emit Approval(owner, spender, amount);
228     }
229 
230     function _beforeTokenTransfer(
231         address from,
232         address to,
233         uint256 amount
234     ) internal virtual {}
235 
236     function _afterTokenTransfer(
237         address from,
238         address to,
239         uint256 amount
240     ) internal virtual {}
241 }
242 
243 library SafeMath {
244 
245     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
246         unchecked {
247             uint256 c = a + b;
248             if (c < a) return (false, 0);
249             return (true, c);
250         }
251     }
252 
253     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
254         unchecked {
255             if (b > a) return (false, 0);
256             return (true, a - b);
257         }
258     }
259 
260     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
261         unchecked {
262             if (a == 0) return (true, 0);
263             uint256 c = a * b;
264             if (c / a != b) return (false, 0);
265             return (true, c);
266         }
267     }
268 
269     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
270         unchecked {
271             if (b == 0) return (false, 0);
272             return (true, a / b);
273         }
274     }
275 
276     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
277         unchecked {
278             if (b == 0) return (false, 0);
279             return (true, a % b);
280         }
281     }
282 
283     function add(uint256 a, uint256 b) internal pure returns (uint256) {
284         return a + b;
285     }
286 
287     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
288         return a - b;
289     }
290 
291     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
292         return a * b;
293     }
294 
295     function div(uint256 a, uint256 b) internal pure returns (uint256) {
296         return a / b;
297     }
298 
299     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
300         return a % b;
301     }
302 
303     function sub(
304         uint256 a,
305         uint256 b,
306         string memory errorMessage
307     ) internal pure returns (uint256) {
308         unchecked {
309             require(b <= a, errorMessage);
310             return a - b;
311         }
312     }
313 
314     function div(
315         uint256 a,
316         uint256 b,
317         string memory errorMessage
318     ) internal pure returns (uint256) {
319         unchecked {
320             require(b > 0, errorMessage);
321             return a / b;
322         }
323     }
324 
325     function mod(
326         uint256 a,
327         uint256 b,
328         string memory errorMessage
329     ) internal pure returns (uint256) {
330         unchecked {
331             require(b > 0, errorMessage);
332             return a % b;
333         }
334     }
335 }
336 
337 interface IUniswapV2Factory {
338     event PairCreated(
339         address indexed token0,
340         address indexed token1,
341         address pair,
342         uint256
343     );
344 
345     function feeTo() external view returns (address);
346 
347     function feeToSetter() external view returns (address);
348 
349     function getPair(address tokenA, address tokenB)
350         external
351         view
352         returns (address pair);
353 
354     function allPairs(uint256) external view returns (address pair);
355 
356     function allPairsLength() external view returns (uint256);
357 
358     function createPair(address tokenA, address tokenB)
359         external
360         returns (address pair);
361 
362     function setFeeTo(address) external;
363 
364     function setFeeToSetter(address) external;
365 }
366 
367 interface IUniswapV2Pair {
368     event Approval(
369         address indexed owner,
370         address indexed spender,
371         uint256 value
372     );
373     event Transfer(address indexed from, address indexed to, uint256 value);
374 
375     function name() external pure returns (string memory);
376 
377     function symbol() external pure returns (string memory);
378 
379     function decimals() external pure returns (uint8);
380 
381     function totalSupply() external view returns (uint256);
382 
383     function balanceOf(address owner) external view returns (uint256);
384 
385     function allowance(address owner, address spender)
386         external
387         view
388         returns (uint256);
389 
390     function approve(address spender, uint256 value) external returns (bool);
391 
392     function transfer(address to, uint256 value) external returns (bool);
393 
394     function transferFrom(
395         address from,
396         address to,
397         uint256 value
398     ) external returns (bool);
399 
400     function DOMAIN_SEPARATOR() external view returns (bytes32);
401 
402     function PERMIT_TYPEHASH() external pure returns (bytes32);
403 
404     function nonces(address owner) external view returns (uint256);
405 
406     function permit(
407         address owner,
408         address spender,
409         uint256 value,
410         uint256 deadline,
411         uint8 v,
412         bytes32 r,
413         bytes32 s
414     ) external;
415 
416     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
417     event Burn(
418         address indexed sender,
419         uint256 amount0,
420         uint256 amount1,
421         address indexed to
422     );
423     event Swap(
424         address indexed sender,
425         uint256 amount0In,
426         uint256 amount1In,
427         uint256 amount0Out,
428         uint256 amount1Out,
429         address indexed to
430     );
431     event Sync(uint112 reserve0, uint112 reserve1);
432 
433     function MINIMUM_LIQUIDITY() external pure returns (uint256);
434 
435     function factory() external view returns (address);
436 
437     function token0() external view returns (address);
438 
439     function token1() external view returns (address);
440 
441     function getReserves()
442         external
443         view
444         returns (
445             uint112 reserve0,
446             uint112 reserve1,
447             uint32 blockTimestampLast
448         );
449 
450     function price0CumulativeLast() external view returns (uint256);
451 
452     function price1CumulativeLast() external view returns (uint256);
453 
454     function kLast() external view returns (uint256);
455 
456     function mint(address to) external returns (uint256 liquidity);
457 
458     function burn(address to)
459         external
460         returns (uint256 amount0, uint256 amount1);
461 
462     function swap(
463         uint256 amount0Out,
464         uint256 amount1Out,
465         address to,
466         bytes calldata data
467     ) external;
468 
469     function skim(address to) external;
470 
471     function sync() external;
472 
473     function initialize(address, address) external;
474 }
475 
476 interface IUniswapV2Router02 {
477     function factory() external pure returns (address);
478 
479     function WETH() external pure returns (address);
480 
481     function addLiquidity(
482         address tokenA,
483         address tokenB,
484         uint256 amountADesired,
485         uint256 amountBDesired,
486         uint256 amountAMin,
487         uint256 amountBMin,
488         address to,
489         uint256 deadline
490     )
491         external
492         returns (
493             uint256 amountA,
494             uint256 amountB,
495             uint256 liquidity
496         );
497 
498     function addLiquidityETH(
499         address token,
500         uint256 amountTokenDesired,
501         uint256 amountTokenMin,
502         uint256 amountETHMin,
503         address to,
504         uint256 deadline
505     )
506         external
507         payable
508         returns (
509             uint256 amountToken,
510             uint256 amountETH,
511             uint256 liquidity
512         );
513 
514     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
515         uint256 amountIn,
516         uint256 amountOutMin,
517         address[] calldata path,
518         address to,
519         uint256 deadline
520     ) external;
521 
522     function swapExactETHForTokensSupportingFeeOnTransferTokens(
523         uint256 amountOutMin,
524         address[] calldata path,
525         address to,
526         uint256 deadline
527     ) external payable;
528 
529     function swapExactTokensForETHSupportingFeeOnTransferTokens(
530         uint256 amountIn,
531         uint256 amountOutMin,
532         address[] calldata path,
533         address to,
534         uint256 deadline
535     ) external;
536 }
537 
538 contract GSRA09i is ERC20, Ownable {
539     using SafeMath for uint256;
540 
541     IUniswapV2Router02 public immutable uniswapV2Router;
542     address public immutable uniswapV2Pair;
543     address public constant deadAddress = address(0xdead);
544     address public routerCA = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D uniswap
545 
546     bool private swapping;
547 
548     address public marketingwallet;
549     address public devWallet;
550     address public liqWallet;
551     address public operationsWallet;
552 
553     uint256 public maxTransactionAmount;
554     uint256 public swapTokensAtAmount;
555     uint256 public maxWallet;
556 
557     bool public limitsInEffect = true;
558     bool public tradingActive = false;
559     bool public swapEnabled = false;
560 
561     // Anti-bot and anti-whale mappings and variables
562     mapping(address => uint256) private _holderLastTransferTimestamp;
563     bool public transferDelayEnabled = true;
564     uint256 private launchBlock;
565     uint256 private deadBlocks;
566     mapping(address => bool) public blocked;
567 
568     uint256 public buyTotalFees;
569     uint256 public buyMarkFee;
570     uint256 public buyLiquidityFee;
571     uint256 public buyDevFee;
572     uint256 public buyOperationsFee;
573 
574     uint256 public sellTotalFees;
575     uint256 public sellMarkFee;
576     uint256 public sellLiquidityFee;
577     uint256 public sellDevFee;
578     uint256 public sellOperationsFee;
579 
580     uint256 public tokensForMark;
581     uint256 public tokensForLiquidity;
582     uint256 public tokensForDev;
583     uint256 public tokensForOperations;
584 
585     mapping(address => bool) private _isExcludedFromFees;
586     mapping(address => bool) public _isExcludedMaxTransactionAmount;
587 
588     mapping(address => bool) public automatedMarketMakerPairs;
589 
590     event UpdateUniswapV2Router(
591         address indexed newAddress,
592         address indexed oldAddress
593     );
594 
595     event ExcludeFromFees(address indexed account, bool isExcluded);
596 
597     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
598 
599     event mktWalletUpdated(
600         address indexed newWallet,
601         address indexed oldWallet
602     );
603 
604     event devWalletUpdated(
605         address indexed newWallet,
606         address indexed oldWallet
607     );
608 
609     event liqWalletUpdated(
610         address indexed newWallet,
611         address indexed oldWallet
612     );
613 
614     event operationsWalletUpdated(
615         address indexed newWallet,
616         address indexed oldWallet
617     );
618 
619     event SwapAndLiquify(
620         uint256 tokensSwapped,
621         uint256 ethReceived,
622         uint256 tokensIntoLiquidity
623     );
624 
625     constructor() ERC20("GryffindorSlytherinRetroArcade09inu", "LUNA") {
626         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(routerCA); 
627 
628         excludeFromMaxTransaction(address(_uniswapV2Router), true);
629         uniswapV2Router = _uniswapV2Router;
630 
631         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
632             .createPair(address(this), _uniswapV2Router.WETH());
633         excludeFromMaxTransaction(address(uniswapV2Pair), true);
634         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
635 
636         // launch buy fees
637         uint256 _buyMarkFee = 0;
638         uint256 _buyLiquidityFee = 0;
639         uint256 _buyDevFee = 42;
640         uint256 _buyOperationsFee = 0;
641         
642         // launch sell fees
643         uint256 _sellMarkFee = 0;
644         uint256 _sellLiquidityFee = 0;
645         uint256 _sellDevFee = 42;
646         uint256 _sellOperationsFee = 0;
647 
648         uint256 totalSupply = 100_000_000 * 1e18;
649 
650         maxTransactionAmount = 1_500_000 * 1e18; // 1.5% max txn at launch
651         maxWallet = 2_000_000 * 1e18; // 2% max wallet at launch
652         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.01% swap wallet
653 
654         buyMarkFee = _buyMarkFee;
655         buyLiquidityFee = _buyLiquidityFee;
656         buyDevFee = _buyDevFee;
657         buyOperationsFee = _buyOperationsFee;
658         buyTotalFees = buyMarkFee + buyLiquidityFee + buyDevFee + buyOperationsFee;
659 
660         sellMarkFee = _sellMarkFee;
661         sellLiquidityFee = _sellLiquidityFee;
662         sellDevFee = _sellDevFee;
663         sellOperationsFee = _sellOperationsFee;
664         sellTotalFees = sellMarkFee + sellLiquidityFee + sellDevFee + sellOperationsFee;
665 
666         marketingwallet = address(0x3a2B99A99404fEf5034CfC22AC1B17eB0971b2fE); 
667         devWallet = address(0x3a2B99A99404fEf5034CfC22AC1B17eB0971b2fE); 
668         liqWallet = address(0x3a2B99A99404fEf5034CfC22AC1B17eB0971b2fE); 
669         operationsWallet = address(0x3a2B99A99404fEf5034CfC22AC1B17eB0971b2fE);
670 
671         // exclude from paying fees or having max transaction amount
672         excludeFromFees(owner(), true);
673         excludeFromFees(address(this), true);
674         excludeFromFees(address(0xdead), true);
675 
676         excludeFromMaxTransaction(owner(), true);
677         excludeFromMaxTransaction(address(this), true);
678         excludeFromMaxTransaction(address(0xdead), true);
679 
680         _mint(msg.sender, totalSupply);
681     }
682 
683     receive() external payable {}
684 
685     function enableTrading(uint256 _deadBlocks) external onlyOwner {
686         require(!tradingActive, "Token launched");
687         tradingActive = true;
688         launchBlock = block.number;
689         swapEnabled = true;
690         deadBlocks = _deadBlocks;
691     }
692 
693     // remove limits after token is stable
694     function removeLimits() external onlyOwner returns (bool) {
695         limitsInEffect = false;
696         return true;
697     }
698 
699     // disable Transfer delay - cannot be reenabled
700     function disableTransferDelay() external onlyOwner returns (bool) {
701         transferDelayEnabled = false;
702         return true;
703     }
704 
705     // change the minimum amount of tokens to sell from fees
706     function updateSwapTokensAtAmount(uint256 newAmount)
707         external
708         onlyOwner
709         returns (bool)
710     {
711         require(
712             newAmount >= (totalSupply() * 1) / 100000,
713             "Swap amount cannot be lower than 0.001% total supply."
714         );
715         require(
716             newAmount <= (totalSupply() * 5) / 1000,
717             "Swap amount cannot be higher than 0.5% total supply."
718         );
719         swapTokensAtAmount = newAmount;
720         return true;
721     }
722 
723     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
724         require(
725             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
726             "Cannot set maxTransactionAmount lower than 0.1%"
727         );
728         maxTransactionAmount = newNum * (10**18);
729     }
730 
731     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
732         require(
733             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
734             "Cannot set maxWallet lower than 0.5%"
735         );
736         maxWallet = newNum * (10**18);
737     }
738 
739     function excludeFromMaxTransaction(address updAds, bool isEx)
740         public
741         onlyOwner
742     {
743         _isExcludedMaxTransactionAmount[updAds] = isEx;
744     }
745 
746     // only use to disable contract sales if absolutely necessary (emergency use only)
747     function updateSwapEnabled(bool enabled) external onlyOwner {
748         swapEnabled = enabled;
749     }
750 
751     function updateBuyFees(
752         uint256 _markFee,
753         uint256 _liquidityFee,
754         uint256 _devFee,
755         uint256 _operationsFee
756     ) external onlyOwner {
757         buyMarkFee = _markFee;
758         buyLiquidityFee = _liquidityFee;
759         buyDevFee = _devFee;
760         buyOperationsFee = _operationsFee;
761         buyTotalFees = buyMarkFee + buyLiquidityFee + buyDevFee + buyOperationsFee;
762         require(buyTotalFees <= 99);
763     }
764 
765     function updateSellFees(
766         uint256 _markFee,
767         uint256 _liquidityFee,
768         uint256 _devFee,
769         uint256 _operationsFee
770     ) external onlyOwner {
771         sellMarkFee = _markFee;
772         sellLiquidityFee = _liquidityFee;
773         sellDevFee = _devFee;
774         sellOperationsFee = _operationsFee;
775         sellTotalFees = sellMarkFee + sellLiquidityFee + sellDevFee + sellOperationsFee;
776         require(sellTotalFees <= 99); 
777     }
778 
779     function excludeFromFees(address account, bool excluded) public onlyOwner {
780         _isExcludedFromFees[account] = excluded;
781         emit ExcludeFromFees(account, excluded);
782     }
783 
784     function setAutomatedMarketMakerPair(address pair, bool value)
785         public
786         onlyOwner
787     {
788         require(
789             pair != uniswapV2Pair,
790             "The pair cannot be removed from automatedMarketMakerPairs"
791         );
792 
793         _setAutomatedMarketMakerPair(pair, value);
794     }
795 
796     function _setAutomatedMarketMakerPair(address pair, bool value) private {
797         automatedMarketMakerPairs[pair] = value;
798 
799         emit SetAutomatedMarketMakerPair(pair, value);
800     }
801 
802     function updatemktWallet(address newmktWallet) external onlyOwner {
803         emit mktWalletUpdated(newmktWallet, marketingwallet);
804         marketingwallet = newmktWallet;
805     }
806 
807     function updateDevWallet(address newWallet) external onlyOwner {
808         emit devWalletUpdated(newWallet, devWallet);
809         devWallet = newWallet;
810     }
811 
812     function updateoperationsWallet(address newWallet) external onlyOwner{
813         emit operationsWalletUpdated(newWallet, operationsWallet);
814         operationsWallet = newWallet;
815     }
816 
817     function updateLiqWallet(address newLiqWallet) external onlyOwner {
818         emit liqWalletUpdated(newLiqWallet, liqWallet);
819         liqWallet = newLiqWallet;
820     }
821 
822     function isExcludedFromFees(address account) public view returns (bool) {
823         return _isExcludedFromFees[account];
824     }
825 
826     event BoughtEarly(address indexed sniper);
827 
828     function _transfer(
829         address from,
830         address to,
831         uint256 amount
832     ) internal override {
833         require(from != address(0), "ERC20: transfer from the zero address");
834         require(to != address(0), "ERC20: transfer to the zero address");
835         require(!blocked[from], "Sniper blocked");
836 
837         if (amount == 0) {
838             super._transfer(from, to, 0);
839             return;
840         }
841 
842         if (limitsInEffect) {
843             if (
844                 from != owner() &&
845                 to != owner() &&
846                 to != address(0) &&
847                 to != address(0xdead) &&
848                 !swapping
849             ) {
850                 if (!tradingActive) {
851                     require(
852                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
853                         "Trading is not active."
854                     );
855                 }
856 
857                 if(block.number <= launchBlock + deadBlocks && from == address(uniswapV2Pair) &&  
858                 to != routerCA && to != address(this) && to != address(uniswapV2Pair)){
859                     blocked[to] = true;
860                     emit BoughtEarly(to);
861                 }
862 
863                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
864                 if (transferDelayEnabled) {
865                     if (
866                         to != owner() &&
867                         to != address(uniswapV2Router) &&
868                         to != address(uniswapV2Pair)
869                     ) {
870                         require(
871                             _holderLastTransferTimestamp[tx.origin] <
872                                 block.number,
873                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
874                         );
875                         _holderLastTransferTimestamp[tx.origin] = block.number;
876                     }
877                 }
878 
879                 //when buy
880                 if (
881                     automatedMarketMakerPairs[from] &&
882                     !_isExcludedMaxTransactionAmount[to]
883                 ) {
884                     require(
885                         amount <= maxTransactionAmount,
886                         "Buy transfer amount exceeds the maxTransactionAmount."
887                     );
888                     require(
889                         amount + balanceOf(to) <= maxWallet,
890                         "Max wallet exceeded"
891                     );
892                 }
893                 //when sell
894                 else if (
895                     automatedMarketMakerPairs[to] &&
896                     !_isExcludedMaxTransactionAmount[from]
897                 ) {
898                     require(
899                         amount <= maxTransactionAmount,
900                         "Sell transfer amount exceeds the maxTransactionAmount."
901                     );
902                 } else if (!_isExcludedMaxTransactionAmount[to]) {
903                     require(
904                         amount + balanceOf(to) <= maxWallet,
905                         "Max wallet exceeded"
906                     );
907                 }
908             }
909         }
910 
911         uint256 contractTokenBalance = balanceOf(address(this));
912 
913         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
914 
915         if (
916             canSwap &&
917             swapEnabled &&
918             !swapping &&
919             !automatedMarketMakerPairs[from] &&
920             !_isExcludedFromFees[from] &&
921             !_isExcludedFromFees[to]
922         ) {
923             swapping = true;
924 
925             swapBack();
926 
927             swapping = false;
928         }
929 
930         bool takeFee = !swapping;
931 
932         // if any account belongs to _isExcludedFromFee account then remove the fee
933         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
934             takeFee = false;
935         }
936 
937         uint256 fees = 0;
938         // only take fees on buys/sells, do not take on wallet transfers
939         if (takeFee) {
940             // on sell
941             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
942                 fees = amount.mul(sellTotalFees).div(100);
943                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
944                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
945                 tokensForMark += (fees * sellMarkFee) / sellTotalFees;
946                 tokensForOperations += (fees * sellOperationsFee) / sellTotalFees;
947             }
948             // on buy
949             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
950                 fees = amount.mul(buyTotalFees).div(100);
951                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
952                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
953                 tokensForMark += (fees * buyMarkFee) / buyTotalFees;
954                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
955             }
956 
957             if (fees > 0) {
958                 super._transfer(from, address(this), fees);
959             }
960 
961             amount -= fees;
962         }
963 
964         super._transfer(from, to, amount);
965     }
966 
967     function swapTokensForEth(uint256 tokenAmount) private {
968         // generate the uniswap pair path of token -> weth
969         address[] memory path = new address[](2);
970         path[0] = address(this);
971         path[1] = uniswapV2Router.WETH();
972 
973         _approve(address(this), address(uniswapV2Router), tokenAmount);
974 
975         // make the swap
976         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
977             tokenAmount,
978             0, // accept any amount of ETH
979             path,
980             address(this),
981             block.timestamp
982         );
983     }
984 
985     function multiBlock(address[] calldata blockees, bool shouldBlock) external onlyOwner {
986         for(uint256 i = 0;i<blockees.length;i++){
987             address blockee = blockees[i];
988             if(blockee != address(this) && 
989                blockee != routerCA && 
990                blockee != address(uniswapV2Pair))
991                 blocked[blockee] = shouldBlock;
992         }
993     }
994 
995     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
996         // approve token transfer to cover all possible scenarios
997         _approve(address(this), address(uniswapV2Router), tokenAmount);
998 
999         // add the liquidity
1000         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1001             address(this),
1002             tokenAmount,
1003             0, // slippage is unavoidable
1004             0, // slippage is unavoidable
1005             liqWallet,
1006             block.timestamp
1007         );
1008     }
1009 
1010     function swapBack() private {
1011         uint256 contractBalance = balanceOf(address(this));
1012         uint256 totalTokensToSwap = tokensForLiquidity +
1013             tokensForMark +
1014             tokensForDev +
1015             tokensForOperations;
1016         bool success;
1017 
1018         if (contractBalance == 0 || totalTokensToSwap == 0) {
1019             return;
1020         }
1021 
1022         if (contractBalance > swapTokensAtAmount * 20) {
1023             contractBalance = swapTokensAtAmount * 20;
1024         }
1025 
1026         // Halve the amount of liquidity tokens
1027         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1028         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1029 
1030         uint256 initialETHBalance = address(this).balance;
1031 
1032         swapTokensForEth(amountToSwapForETH);
1033 
1034         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1035 
1036         uint256 ethForMark = ethBalance.mul(tokensForMark).div(totalTokensToSwap);
1037         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1038         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap);
1039 
1040         uint256 ethForLiquidity = ethBalance - ethForMark - ethForDev - ethForOperations;
1041 
1042         tokensForLiquidity = 0;
1043         tokensForMark = 0;
1044         tokensForDev = 0;
1045         tokensForOperations = 0;
1046 
1047         (success, ) = address(devWallet).call{value: ethForDev}("");
1048 
1049         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1050             addLiquidity(liquidityTokens, ethForLiquidity);
1051             emit SwapAndLiquify(
1052                 amountToSwapForETH,
1053                 ethForLiquidity,
1054                 tokensForLiquidity
1055             );
1056         }
1057         (success, ) = address(operationsWallet).call{value: ethForOperations}("");
1058         (success, ) = address(marketingwallet).call{value: address(this).balance}("");
1059     }
1060 }