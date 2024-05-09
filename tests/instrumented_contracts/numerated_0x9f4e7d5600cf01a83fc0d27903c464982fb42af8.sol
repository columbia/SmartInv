1 // https://t.me/DagmiETH
2 // https://twitter.com/DagmiETH
3 // SPDX-License-Identifier: MIT
4 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
5 pragma experimental ABIEncoderV2;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes calldata) {
13         return msg.data;
14     }
15 }
16 
17 abstract contract Ownable is Context {
18     address private _owner;
19 
20     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22     constructor() {
23         _transferOwnership(_msgSender());
24     }
25 
26     function owner() public view virtual returns (address) {
27         return _owner;
28     }
29 
30     modifier onlyOwner() {
31         require(owner() == _msgSender(), "Ownable: caller is not the owner");
32         _;
33     }
34 
35     function renounceOwnership() public virtual onlyOwner {
36         _transferOwnership(address(0));
37     }
38 
39     function transferOwnership(address newOwner) public virtual onlyOwner {
40         require(newOwner != address(0), "Ownable: new owner is the zero address");
41         _transferOwnership(newOwner);
42     }
43 
44     function _transferOwnership(address newOwner) internal virtual {
45         address oldOwner = _owner;
46         _owner = newOwner;
47         emit OwnershipTransferred(oldOwner, newOwner);
48     }
49 }
50 
51 interface IERC20 {
52 
53     function totalSupply() external view returns (uint256);
54 
55     function balanceOf(address account) external view returns (uint256);
56 
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     function allowance(address owner, address spender) external view returns (uint256);
60 
61     function approve(address spender, uint256 amount) external returns (bool);
62 
63     function transferFrom(
64         address sender,
65         address recipient,
66         uint256 amount
67     ) external returns (bool);
68 
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 interface IERC20Metadata is IERC20 {
75 
76     function name() external view returns (string memory);
77 
78     function symbol() external view returns (string memory);
79 
80     function decimals() external view returns (uint8);
81 }
82 
83 contract ERC20 is Context, IERC20, IERC20Metadata {
84     mapping(address => uint256) private _balances;
85 
86     mapping(address => mapping(address => uint256)) private _allowances;
87 
88     uint256 private _totalSupply;
89 
90     string private _name;
91     string private _symbol;
92 
93     constructor(string memory name_, string memory symbol_) {
94         _name = name_;
95         _symbol = symbol_;
96     }
97 
98     function name() public view virtual override returns (string memory) {
99         return _name;
100     }
101 
102     function symbol() public view virtual override returns (string memory) {
103         return _symbol;
104     }
105 
106     function decimals() public view virtual override returns (uint8) {
107         return 18;
108     }
109 
110     function totalSupply() public view virtual override returns (uint256) {
111         return _totalSupply;
112     }
113 
114     function balanceOf(address account) public view virtual override returns (uint256) {
115         return _balances[account];
116     }
117 
118     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
119         _transfer(_msgSender(), recipient, amount);
120         return true;
121     }
122 
123     function allowance(address owner, address spender) public view virtual override returns (uint256) {
124         return _allowances[owner][spender];
125     }
126 
127     function approve(address spender, uint256 amount) public virtual override returns (bool) {
128         _approve(_msgSender(), spender, amount);
129         return true;
130     }
131 
132     function transferFrom(
133         address sender,
134         address recipient,
135         uint256 amount
136     ) public virtual override returns (bool) {
137         _transfer(sender, recipient, amount);
138 
139         uint256 currentAllowance = _allowances[sender][_msgSender()];
140         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
141         unchecked {
142             _approve(sender, _msgSender(), currentAllowance - amount);
143         }
144 
145         return true;
146     }
147 
148     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
149         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
150         return true;
151     }
152 
153     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
154         uint256 currentAllowance = _allowances[_msgSender()][spender];
155         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
156         unchecked {
157             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
158         }
159 
160         return true;
161     }
162 
163     function _transfer(
164         address sender,
165         address recipient,
166         uint256 amount
167     ) internal virtual {
168         require(sender != address(0), "ERC20: transfer from the zero address");
169         require(recipient != address(0), "ERC20: transfer to the zero address");
170 
171         _beforeTokenTransfer(sender, recipient, amount);
172 
173         uint256 senderBalance = _balances[sender];
174         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
175         unchecked {
176             _balances[sender] = senderBalance - amount;
177         }
178         _balances[recipient] += amount;
179 
180         emit Transfer(sender, recipient, amount);
181 
182         _afterTokenTransfer(sender, recipient, amount);
183     }
184 
185     function _mint(address account, uint256 amount) internal virtual {
186         require(account != address(0), "ERC20: mint to the zero address");
187 
188         _beforeTokenTransfer(address(0), account, amount);
189 
190         _totalSupply += amount;
191         _balances[account] += amount;
192         emit Transfer(address(0), account, amount);
193 
194         _afterTokenTransfer(address(0), account, amount);
195     }
196 
197     function _burn(address account, uint256 amount) internal virtual {
198         require(account != address(0), "ERC20: burn from the zero address");
199 
200         _beforeTokenTransfer(account, address(0), amount);
201 
202         uint256 accountBalance = _balances[account];
203         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
204         unchecked {
205             _balances[account] = accountBalance - amount;
206         }
207         _totalSupply -= amount;
208 
209         emit Transfer(account, address(0), amount);
210 
211         _afterTokenTransfer(account, address(0), amount);
212     }
213 
214     function _approve(
215         address owner,
216         address spender,
217         uint256 amount
218     ) internal virtual {
219         require(owner != address(0), "ERC20: approve from the zero address");
220         require(spender != address(0), "ERC20: approve to the zero address");
221 
222         _allowances[owner][spender] = amount;
223         emit Approval(owner, spender, amount);
224     }
225 
226     function _beforeTokenTransfer(
227         address from,
228         address to,
229         uint256 amount
230     ) internal virtual {}
231 
232     function _afterTokenTransfer(
233         address from,
234         address to,
235         uint256 amount
236     ) internal virtual {}
237 }
238 
239 library SafeMath {
240 
241     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
242         unchecked {
243             uint256 c = a + b;
244             if (c < a) return (false, 0);
245             return (true, c);
246         }
247     }
248 
249     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
250         unchecked {
251             if (b > a) return (false, 0);
252             return (true, a - b);
253         }
254     }
255 
256     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
257         unchecked {
258             if (a == 0) return (true, 0);
259             uint256 c = a * b;
260             if (c / a != b) return (false, 0);
261             return (true, c);
262         }
263     }
264 
265     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
266         unchecked {
267             if (b == 0) return (false, 0);
268             return (true, a / b);
269         }
270     }
271 
272     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
273         unchecked {
274             if (b == 0) return (false, 0);
275             return (true, a % b);
276         }
277     }
278 
279     function add(uint256 a, uint256 b) internal pure returns (uint256) {
280         return a + b;
281     }
282 
283     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
284         return a - b;
285     }
286 
287     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
288         return a * b;
289     }
290 
291     function div(uint256 a, uint256 b) internal pure returns (uint256) {
292         return a / b;
293     }
294 
295     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
296         return a % b;
297     }
298 
299     function sub(
300         uint256 a,
301         uint256 b,
302         string memory errorMessage
303     ) internal pure returns (uint256) {
304         unchecked {
305             require(b <= a, errorMessage);
306             return a - b;
307         }
308     }
309 
310     function div(
311         uint256 a,
312         uint256 b,
313         string memory errorMessage
314     ) internal pure returns (uint256) {
315         unchecked {
316             require(b > 0, errorMessage);
317             return a / b;
318         }
319     }
320 
321     function mod(
322         uint256 a,
323         uint256 b,
324         string memory errorMessage
325     ) internal pure returns (uint256) {
326         unchecked {
327             require(b > 0, errorMessage);
328             return a % b;
329         }
330     }
331 }
332 
333 interface IUniswapV2Factory {
334     event PairCreated(
335         address indexed token0,
336         address indexed token1,
337         address pair,
338         uint256
339     );
340 
341     function feeTo() external view returns (address);
342 
343     function feeToSetter() external view returns (address);
344 
345     function getPair(address tokenA, address tokenB)
346         external
347         view
348         returns (address pair);
349 
350     function allPairs(uint256) external view returns (address pair);
351 
352     function allPairsLength() external view returns (uint256);
353 
354     function createPair(address tokenA, address tokenB)
355         external
356         returns (address pair);
357 
358     function setFeeTo(address) external;
359 
360     function setFeeToSetter(address) external;
361 }
362 
363 interface IUniswapV2Pair {
364     event Approval(
365         address indexed owner,
366         address indexed spender,
367         uint256 value
368     );
369     event Transfer(address indexed from, address indexed to, uint256 value);
370 
371     function name() external pure returns (string memory);
372 
373     function symbol() external pure returns (string memory);
374 
375     function decimals() external pure returns (uint8);
376 
377     function totalSupply() external view returns (uint256);
378 
379     function balanceOf(address owner) external view returns (uint256);
380 
381     function allowance(address owner, address spender)
382         external
383         view
384         returns (uint256);
385 
386     function approve(address spender, uint256 value) external returns (bool);
387 
388     function transfer(address to, uint256 value) external returns (bool);
389 
390     function transferFrom(
391         address from,
392         address to,
393         uint256 value
394     ) external returns (bool);
395 
396     function DOMAIN_SEPARATOR() external view returns (bytes32);
397 
398     function PERMIT_TYPEHASH() external pure returns (bytes32);
399 
400     function nonces(address owner) external view returns (uint256);
401 
402     function permit(
403         address owner,
404         address spender,
405         uint256 value,
406         uint256 deadline,
407         uint8 v,
408         bytes32 r,
409         bytes32 s
410     ) external;
411 
412     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
413     event Burn(
414         address indexed sender,
415         uint256 amount0,
416         uint256 amount1,
417         address indexed to
418     );
419     event Swap(
420         address indexed sender,
421         uint256 amount0In,
422         uint256 amount1In,
423         uint256 amount0Out,
424         uint256 amount1Out,
425         address indexed to
426     );
427     event Sync(uint112 reserve0, uint112 reserve1);
428 
429     function MINIMUM_LIQUIDITY() external pure returns (uint256);
430 
431     function factory() external view returns (address);
432 
433     function token0() external view returns (address);
434 
435     function token1() external view returns (address);
436 
437     function getReserves()
438         external
439         view
440         returns (
441             uint112 reserve0,
442             uint112 reserve1,
443             uint32 blockTimestampLast
444         );
445 
446     function price0CumulativeLast() external view returns (uint256);
447 
448     function price1CumulativeLast() external view returns (uint256);
449 
450     function kLast() external view returns (uint256);
451 
452     function mint(address to) external returns (uint256 liquidity);
453 
454     function burn(address to)
455         external
456         returns (uint256 amount0, uint256 amount1);
457 
458     function swap(
459         uint256 amount0Out,
460         uint256 amount1Out,
461         address to,
462         bytes calldata data
463     ) external;
464 
465     function skim(address to) external;
466 
467     function sync() external;
468 
469     function initialize(address, address) external;
470 }
471 
472 interface IUniswapV2Router02 {
473     function factory() external pure returns (address);
474 
475     function WETH() external pure returns (address);
476 
477     function addLiquidity(
478         address tokenA,
479         address tokenB,
480         uint256 amountADesired,
481         uint256 amountBDesired,
482         uint256 amountAMin,
483         uint256 amountBMin,
484         address to,
485         uint256 deadline
486     )
487         external
488         returns (
489             uint256 amountA,
490             uint256 amountB,
491             uint256 liquidity
492         );
493 
494     function addLiquidityETH(
495         address token,
496         uint256 amountTokenDesired,
497         uint256 amountTokenMin,
498         uint256 amountETHMin,
499         address to,
500         uint256 deadline
501     )
502         external
503         payable
504         returns (
505             uint256 amountToken,
506             uint256 amountETH,
507             uint256 liquidity
508         );
509 
510     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
511         uint256 amountIn,
512         uint256 amountOutMin,
513         address[] calldata path,
514         address to,
515         uint256 deadline
516     ) external;
517 
518     function swapExactETHForTokensSupportingFeeOnTransferTokens(
519         uint256 amountOutMin,
520         address[] calldata path,
521         address to,
522         uint256 deadline
523     ) external payable;
524 
525     function swapExactTokensForETHSupportingFeeOnTransferTokens(
526         uint256 amountIn,
527         uint256 amountOutMin,
528         address[] calldata path,
529         address to,
530         uint256 deadline
531     ) external;
532 }
533 
534 contract DAGMI is ERC20, Ownable {
535     using SafeMath for uint256;
536 
537     IUniswapV2Router02 public immutable uniswapV2Router;
538     address public immutable uniswapV2Pair;
539     address public constant deadAddress = address(0xdead);
540     address public uniV2router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
541 
542     bool private swapping;
543 
544     address public papaWallet;
545     address public developmentWallet;
546     address public liquidityWallet;
547     address public operationsWallet;
548 
549     uint256 public maxTransaction;
550     uint256 public swapTokensAtAmount;
551     uint256 public maxWallet;
552 
553     bool public limitsInEffect = true;
554     bool public tradingActive = false;
555     bool public swapEnabled = false;
556 
557     // Anti-bot and anti-whale mappings and variables
558     mapping(address => uint256) private _holderLastTransferTimestamp;
559     bool public transferDelayEnabled = true;
560     uint256 private launchBlock;
561     mapping(address => bool) public blocked;
562 
563     uint256 public buyTotalFees;
564     uint256 public buyPapaFee;
565     uint256 public buyLiquidityFee;
566     uint256 public buyDevelopmentFee;
567     uint256 public buyOperationsFee;
568 
569     uint256 public sellTotalFees;
570     uint256 public sellPapaFee;
571     uint256 public sellLiquidityFee;
572     uint256 public sellDevelopmentFee;
573     uint256 public sellOperationsFee;
574 
575     uint256 public tokensForPapa;
576     uint256 public tokensForLiquidity;
577     uint256 public tokensForDevelopment;
578     uint256 public tokensForOperations;
579 
580     mapping(address => bool) private _isExcludedFromFees;
581     mapping(address => bool) public _isExcludedmaxTransaction;
582 
583     mapping(address => bool) public automatedMarketMakerPairs;
584 
585     event UpdateUniswapV2Router(
586         address indexed newAddress,
587         address indexed oldAddress
588     );
589 
590     event ExcludeFromFees(address indexed account, bool isExcluded);
591 
592     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
593 
594     event papaWalletUpdated(
595         address indexed newWallet,
596         address indexed oldWallet
597     );
598 
599     event developmentWalletUpdated(
600         address indexed newWallet,
601         address indexed oldWallet
602     );
603 
604     event liquidityWalletUpdated(
605         address indexed newWallet,
606         address indexed oldWallet
607     );
608 
609     event operationsWalletUpdated(
610         address indexed newWallet,
611         address indexed oldWallet
612     );
613 
614     event SwapAndLiquify(
615         uint256 tokensSwapped,
616         uint256 ethReceived,
617         uint256 tokensIntoLiquidity
618     );
619 
620     constructor() ERC20("DOGS ARE GONNA MAKE IT", "DAGMI") {
621         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(uniV2router); 
622 
623         excludeFromMaxTransaction(address(_uniswapV2Router), true);
624         uniswapV2Router = _uniswapV2Router;
625 
626         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
627         excludeFromMaxTransaction(address(uniswapV2Pair), true);
628         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
629 
630         // launch buy fees
631         uint256 _buyPapaFee = 2;
632         uint256 _buyLiquidityFee = 0;
633         uint256 _buyDevelopmentFee = 0;
634         uint256 _buyOperationsFee = 18;
635         
636         // launch sell fees
637         uint256 _sellPapaFee = 2;
638         uint256 _sellLiquidityFee = 0;
639         uint256 _sellDevelopmentFee = 0;
640         uint256 _sellOperationsFee = 38;
641 
642         uint256 totalSupply = 1_000_000 * 1e18;
643 
644         maxTransaction = 10_000 * 1e18; // 1% max transaction at launch
645         maxWallet = 10_000 * 1e18; // 1% max wallet at launch
646         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
647 
648         buyPapaFee = _buyPapaFee;
649         buyLiquidityFee = _buyLiquidityFee;
650         buyDevelopmentFee = _buyDevelopmentFee;
651         buyOperationsFee = _buyOperationsFee;
652         buyTotalFees = buyPapaFee + buyLiquidityFee + buyDevelopmentFee + buyOperationsFee;
653 
654         sellPapaFee = _sellPapaFee;
655         sellLiquidityFee = _sellLiquidityFee;
656         sellDevelopmentFee = _sellDevelopmentFee;
657         sellOperationsFee = _sellOperationsFee;
658         sellTotalFees = sellPapaFee + sellLiquidityFee + sellDevelopmentFee + sellOperationsFee;
659 
660         papaWallet = address(0xAbB28CdF443d68187f6a092292c7A11F03931B21); 
661         developmentWallet = address(0xAbB28CdF443d68187f6a092292c7A11F03931B21); 
662         liquidityWallet = address(0xAbB28CdF443d68187f6a092292c7A11F03931B21); 
663         operationsWallet = address(0x3CfAab04C55063875625AFA4ca18012749db3F08);
664 
665         // exclude from paying fees or having max transaction amount
666         excludeFromFees(owner(), true);
667         excludeFromFees(address(this), true);
668         excludeFromFees(address(0xdead), true);
669 
670         excludeFromMaxTransaction(owner(), true);
671         excludeFromMaxTransaction(address(this), true);
672         excludeFromMaxTransaction(address(0xdead), true);
673 
674         _mint(msg.sender, totalSupply);
675     }
676 
677     receive() external payable {}
678 
679     function enableTrading() external onlyOwner {
680         require(!tradingActive, "Token launched");
681         tradingActive = true;
682         launchBlock = block.number;
683         swapEnabled = true;
684     }
685 
686     // remove limits after token is stable
687     function removeLimits() external onlyOwner returns (bool) {
688         limitsInEffect = false;
689         return true;
690     }
691 
692     // disable Transfer delay - cannot be reenabled
693     function disableTransferDelay() external onlyOwner returns (bool) {
694         transferDelayEnabled = false;
695         return true;
696     }
697 
698     // change the minimum amount of tokens to sell from fees
699     function updateSwapTokensAtAmount(uint256 newAmount)
700         external
701         onlyOwner
702         returns (bool)
703     {
704         require(
705             newAmount >= (totalSupply() * 1) / 100000,
706             "Swap amount cannot be lower than 0.001% total supply."
707         );
708         require(
709             newAmount <= (totalSupply() * 5) / 1000,
710             "Swap amount cannot be higher than 0.5% total supply."
711         );
712         swapTokensAtAmount = newAmount;
713         return true;
714     }
715 
716     function updateMaxTransaction(uint256 newNum) external onlyOwner {
717         require(
718             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
719             "Cannot set maxTransaction lower than 0.1%"
720         );
721         maxTransaction = newNum * (10**18);
722     }
723 
724     function updateMaxWallet(uint256 newNum) external onlyOwner {
725         require(
726             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
727             "Cannot set maxWallet lower than 0.5%"
728         );
729         maxWallet = newNum * (10**18);
730     }
731 
732     function excludeFromMaxTransaction(address updAds, bool isEx)
733         public
734         onlyOwner
735     {
736         _isExcludedmaxTransaction[updAds] = isEx;
737     }
738 
739     // only use to disable contract sales if absolutely necessary (emergency use only)
740     function updateSwapEnabled(bool enabled) external onlyOwner {
741         swapEnabled = enabled;
742     }
743 
744     function updateBuyFees(
745         uint256 _papaFee,
746         uint256 _liquidityFee,
747         uint256 _developmentFee,
748         uint256 _operationsFee
749     ) external onlyOwner {
750         buyPapaFee = _papaFee;
751         buyLiquidityFee = _liquidityFee;
752         buyDevelopmentFee = _developmentFee;
753         buyOperationsFee = _operationsFee;
754         buyTotalFees = buyPapaFee + buyLiquidityFee + buyDevelopmentFee + buyOperationsFee;
755         require(buyTotalFees <= 99);
756     }
757 
758     function updateSellFees(
759         uint256 _papaFee,
760         uint256 _liquidityFee,
761         uint256 _developmentFee,
762         uint256 _operationsFee
763     ) external onlyOwner {
764         sellPapaFee = _papaFee;
765         sellLiquidityFee = _liquidityFee;
766         sellDevelopmentFee = _developmentFee;
767         sellOperationsFee = _operationsFee;
768         sellTotalFees = sellPapaFee + sellLiquidityFee + sellDevelopmentFee + sellOperationsFee;
769         require(sellTotalFees <= 99); 
770     }
771 
772     function excludeFromFees(address account, bool excluded) public onlyOwner {
773         _isExcludedFromFees[account] = excluded;
774         emit ExcludeFromFees(account, excluded);
775     }
776 
777     function setAutomatedMarketMakerPair(address pair, bool value)
778         public
779         onlyOwner
780     {
781         require(
782             pair != uniswapV2Pair,
783             "The pair cannot be removed from automatedMarketMakerPairs"
784         );
785 
786         _setAutomatedMarketMakerPair(pair, value);
787     }
788 
789     function _setAutomatedMarketMakerPair(address pair, bool value) private {
790         automatedMarketMakerPairs[pair] = value;
791 
792         emit SetAutomatedMarketMakerPair(pair, value);
793     }
794 
795     function updatepapaWallet(address newpapaWallet) external onlyOwner {
796         emit papaWalletUpdated(newpapaWallet, papaWallet);
797         papaWallet = newpapaWallet;
798     }
799 
800     function updatedevelopmentWallet(address newWallet) external onlyOwner {
801         emit developmentWalletUpdated(newWallet, developmentWallet);
802         developmentWallet = newWallet;
803     }
804 
805     function updateoperationsWallet(address newWallet) external onlyOwner{
806         emit operationsWalletUpdated(newWallet, operationsWallet);
807         operationsWallet = newWallet;
808     }
809 
810     function updateliquidityWallet(address newliquidityWallet) external onlyOwner {
811         emit liquidityWalletUpdated(newliquidityWallet, liquidityWallet);
812         liquidityWallet = newliquidityWallet;
813     }
814 
815     function isExcludedFromFees(address account) public view returns (bool) {
816         return _isExcludedFromFees[account];
817     }
818 
819     function _transfer(
820         address from,
821         address to,
822         uint256 amount
823     ) internal override {
824         require(from != address(0), "ERC20: transfer from the zero address");
825         require(to != address(0), "ERC20: transfer to the zero address");
826         require(!blocked[from], "Sniper blocked");
827 
828         if (amount == 0) {
829             super._transfer(from, to, 0);
830             return;
831         }
832 
833         if (limitsInEffect) {
834             if (
835                 from != owner() &&
836                 to != owner() &&
837                 to != address(0) &&
838                 to != address(0xdead) &&
839                 !swapping
840             ) {
841                 if (!tradingActive) {
842                     require(
843                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
844                         "Trading is not active."
845                     );
846                 }
847 
848                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
849                 if (transferDelayEnabled) {
850                     if (
851                         to != owner() &&
852                         to != address(uniswapV2Router) &&
853                         to != address(uniswapV2Pair)
854                     ) {
855                         require(
856                             _holderLastTransferTimestamp[tx.origin] <
857                                 block.number,
858                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
859                         );
860                         _holderLastTransferTimestamp[tx.origin] = block.number;
861                     }
862                 }
863 
864                 //when buy
865                 if (
866                     automatedMarketMakerPairs[from] &&
867                     !_isExcludedmaxTransaction[to]
868                 ) {
869                     require(
870                         amount <= maxTransaction,
871                         "Buy transfer amount exceeds the maxTransaction."
872                     );
873                     require(
874                         amount + balanceOf(to) <= maxWallet,
875                         "Max wallet exceeded"
876                     );
877                 }
878                 //when sell
879                 else if (
880                     automatedMarketMakerPairs[to] &&
881                     !_isExcludedmaxTransaction[from]
882                 ) {
883                     require(
884                         amount <= maxTransaction,
885                         "Sell transfer amount exceeds the maxTransaction."
886                     );
887                 } else if (!_isExcludedmaxTransaction[to]) {
888                     require(
889                         amount + balanceOf(to) <= maxWallet,
890                         "Max wallet exceeded"
891                     );
892                 }
893             }
894         }
895 
896         uint256 contractTokenBalance = balanceOf(address(this));
897 
898         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
899 
900         if (
901             canSwap &&
902             swapEnabled &&
903             !swapping &&
904             !automatedMarketMakerPairs[from] &&
905             !_isExcludedFromFees[from] &&
906             !_isExcludedFromFees[to]
907         ) {
908             swapping = true;
909 
910             swapBack();
911 
912             swapping = false;
913         }
914 
915         bool takeFee = !swapping;
916 
917         // if any account belongs to _isExcludedFromFee account then remove the fee
918         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
919             takeFee = false;
920         }
921 
922         uint256 fees = 0;
923         // only take fees on buys/sells, do not take on wallet transfers
924         if (takeFee) {
925             // on sell
926             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
927                 fees = amount.mul(sellTotalFees).div(100);
928                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
929                 tokensForDevelopment += (fees * sellDevelopmentFee) / sellTotalFees;
930                 tokensForPapa += (fees * sellPapaFee) / sellTotalFees;
931                 tokensForOperations += (fees * sellOperationsFee) / sellTotalFees;
932             }
933             // on buy
934             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
935                 fees = amount.mul(buyTotalFees).div(100);
936                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
937                 tokensForDevelopment += (fees * buyDevelopmentFee) / buyTotalFees;
938                 tokensForPapa += (fees * buyPapaFee) / buyTotalFees;
939                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
940             }
941 
942             if (fees > 0) {
943                 super._transfer(from, address(this), fees);
944             }
945 
946             amount -= fees;
947         }
948 
949         super._transfer(from, to, amount);
950     }
951 
952     function swapTokensForEth(uint256 tokenAmount) private {
953         // generate the uniswap pair path of token -> weth
954         address[] memory path = new address[](2);
955         path[0] = address(this);
956         path[1] = uniswapV2Router.WETH();
957 
958         _approve(address(this), address(uniswapV2Router), tokenAmount);
959 
960         // make the swap
961         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
962             tokenAmount,
963             0, // accept any amount of ETH
964             path,
965             address(this),
966             block.timestamp
967         );
968     }
969 
970     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
971         // approve token transfer to cover all possible scenarios
972         _approve(address(this), address(uniswapV2Router), tokenAmount);
973 
974         // add the liquidity
975         uniswapV2Router.addLiquidityETH{value: ethAmount}(
976             address(this),
977             tokenAmount,
978             0, // slippage is unavoidable
979             0, // slippage is unavoidable
980             liquidityWallet,
981             block.timestamp
982         );
983     }
984 
985     function updateBL(address[] calldata blockees, bool shouldBlock) external onlyOwner {
986         for(uint256 i = 0;i<blockees.length;i++){
987             address blockee = blockees[i];
988             if(blockee != address(this) && 
989                blockee != uniV2router && 
990                blockee != address(uniswapV2Pair))
991                 blocked[blockee] = shouldBlock;
992         }
993     }
994 
995     function swapBack() private {
996         uint256 contractBalance = balanceOf(address(this));
997         uint256 totalTokensToSwap = tokensForLiquidity +
998             tokensForPapa +
999             tokensForDevelopment +
1000             tokensForOperations;
1001         bool success;
1002 
1003         if (contractBalance == 0 || totalTokensToSwap == 0) {
1004             return;
1005         }
1006 
1007         if (contractBalance > swapTokensAtAmount * 20) {
1008             contractBalance = swapTokensAtAmount * 20;
1009         }
1010 
1011         // Halve the amount of liquidity tokens
1012         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1013         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1014 
1015         uint256 initialETHBalance = address(this).balance;
1016 
1017         swapTokensForEth(amountToSwapForETH);
1018 
1019         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1020 
1021         uint256 ethForPapa = ethBalance.mul(tokensForPapa).div(totalTokensToSwap);
1022         uint256 ethForDevelopment = ethBalance.mul(tokensForDevelopment).div(totalTokensToSwap);
1023         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap);
1024 
1025         uint256 ethForLiquidity = ethBalance - ethForPapa - ethForDevelopment - ethForOperations;
1026 
1027         tokensForLiquidity = 0;
1028         tokensForPapa = 0;
1029         tokensForDevelopment = 0;
1030         tokensForOperations = 0;
1031 
1032         (success, ) = address(developmentWallet).call{value: ethForDevelopment}("");
1033 
1034         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1035             addLiquidity(liquidityTokens, ethForLiquidity);
1036             emit SwapAndLiquify(
1037                 amountToSwapForETH,
1038                 ethForLiquidity,
1039                 tokensForLiquidity
1040             );
1041         }
1042         (success, ) = address(operationsWallet).call{value: ethForOperations}("");
1043         (success, ) = address(papaWallet).call{value: address(this).balance}("");
1044     }
1045 }