1 /**     
2 
3 https://x.com/Eth_BabyPepe
4 
5 https://t.me/Eth_BabyPepe  
6 
7 https://babypepeerc.vip
8 
9 */ 
10 
11 // SPDX-License-Identifier: MIT
12 
13 pragma solidity 0.8.19;
14 pragma experimental ABIEncoderV2;
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 abstract contract Ownable is Context {
27     address private _owner;
28 
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31     constructor() {
32         _transferOwnership(_msgSender());
33     }
34 
35     function owner() public view virtual returns (address) {
36         return _owner;
37     }
38 
39     modifier onlyOwner() {
40         require(owner() == _msgSender(), "Ownable: caller is not the owner");
41         _;
42     }
43 
44     function renounceOwnership() public virtual onlyOwner {
45         _transferOwnership(address(0));
46     }
47 
48     function transferOwnership(address newOwner) public virtual onlyOwner {
49         require(newOwner != address(0), "Ownable: new owner is the zero address");
50         _transferOwnership(newOwner);
51     }
52 
53     function _transferOwnership(address newOwner) internal virtual {
54         address oldOwner = _owner;
55         _owner = newOwner;
56         emit OwnershipTransferred(oldOwner, newOwner);
57     }
58 }
59 
60 interface IERC20 {
61 
62     function totalSupply() external view returns (uint256);
63 
64     function balanceOf(address account) external view returns (uint256);
65 
66     function transfer(address recipient, uint256 amount) external returns (bool);
67 
68     function allowance(address owner, address spender) external view returns (uint256);
69 
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     function transferFrom(
73         address sender,
74         address recipient,
75         uint256 amount
76     ) external returns (bool);
77 
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 interface IERC20Metadata is IERC20 {
84 
85     function name() external view returns (string memory);
86 
87     function symbol() external view returns (string memory);
88 
89     function decimals() external view returns (uint8);
90 }
91 
92 contract ERC20 is Context, IERC20, IERC20Metadata {
93     mapping(address => uint256) private _balances;
94 
95     mapping(address => mapping(address => uint256)) private _allowances;
96 
97     uint256 private _totalSupply;
98 
99     string private _name;
100     string private _symbol;
101 
102     constructor(string memory name_, string memory symbol_) {
103         _name = name_;
104         _symbol = symbol_;
105     }
106 
107     function name() public view virtual override returns (string memory) {
108         return _name;
109     }
110 
111     function symbol() public view virtual override returns (string memory) {
112         return _symbol;
113     }
114 
115     function decimals() public view virtual override returns (uint8) {
116         return 18;
117     }
118 
119     function totalSupply() public view virtual override returns (uint256) {
120         return _totalSupply;
121     }
122 
123     function balanceOf(address account) public view virtual override returns (uint256) {
124         return _balances[account];
125     }
126 
127     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
128         _transfer(_msgSender(), recipient, amount);
129         return true;
130     }
131 
132     function allowance(address owner, address spender) public view virtual override returns (uint256) {
133         return _allowances[owner][spender];
134     }
135 
136     function approve(address spender, uint256 amount) public virtual override returns (bool) {
137         _approve(_msgSender(), spender, amount);
138         return true;
139     }
140 
141     function transferFrom(
142         address sender,
143         address recipient,
144         uint256 amount
145     ) public virtual override returns (bool) {
146         _transfer(sender, recipient, amount);
147 
148         uint256 currentAllowance = _allowances[sender][_msgSender()];
149         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
150         unchecked {
151             _approve(sender, _msgSender(), currentAllowance - amount);
152         }
153 
154         return true;
155     }
156 
157     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
158         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
159         return true;
160     }
161 
162     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
163         uint256 currentAllowance = _allowances[_msgSender()][spender];
164         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
165         unchecked {
166             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
167         }
168 
169         return true;
170     }
171 
172     function _transfer(
173         address sender,
174         address recipient,
175         uint256 amount
176     ) internal virtual {
177         require(sender != address(0), "ERC20: transfer from the zero address");
178         require(recipient != address(0), "ERC20: transfer to the zero address");
179 
180         _beforeTokenTransfer(sender, recipient, amount);
181 
182         uint256 senderBalance = _balances[sender];
183         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
184         unchecked {
185             _balances[sender] = senderBalance - amount;
186         }
187         _balances[recipient] += amount;
188 
189         emit Transfer(sender, recipient, amount);
190 
191         _afterTokenTransfer(sender, recipient, amount);
192     }
193 
194     function _mint(address account, uint256 amount) internal virtual {
195         require(account != address(0), "ERC20: mint to the zero address");
196 
197         _beforeTokenTransfer(address(0), account, amount);
198 
199         _totalSupply += amount;
200         _balances[account] += amount;
201         emit Transfer(address(0), account, amount);
202 
203         _afterTokenTransfer(address(0), account, amount);
204     }
205 
206     function _burn(address account, uint256 amount) internal virtual {
207         require(account != address(0), "ERC20: burn from the zero address");
208 
209         _beforeTokenTransfer(account, address(0), amount);
210 
211         uint256 accountBalance = _balances[account];
212         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
213         unchecked {
214             _balances[account] = accountBalance - amount;
215         }
216         _totalSupply -= amount;
217 
218         emit Transfer(account, address(0), amount);
219 
220         _afterTokenTransfer(account, address(0), amount);
221     }
222 
223     function _approve(
224         address owner,
225         address spender,
226         uint256 amount
227     ) internal virtual {
228         require(owner != address(0), "ERC20: approve from the zero address");
229         require(spender != address(0), "ERC20: approve to the zero address");
230 
231         _allowances[owner][spender] = amount;
232         emit Approval(owner, spender, amount);
233     }
234 
235     function _beforeTokenTransfer(
236         address from,
237         address to,
238         uint256 amount
239     ) internal virtual {}
240 
241     function _afterTokenTransfer(
242         address from,
243         address to,
244         uint256 amount
245     ) internal virtual {}
246 }
247 
248 library SafeMath {
249 
250     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
251         unchecked {
252             uint256 c = a + b;
253             if (c < a) return (false, 0);
254             return (true, c);
255         }
256     }
257 
258     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
259         unchecked {
260             if (b > a) return (false, 0);
261             return (true, a - b);
262         }
263     }
264 
265     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
266         unchecked {
267             if (a == 0) return (true, 0);
268             uint256 c = a * b;
269             if (c / a != b) return (false, 0);
270             return (true, c);
271         }
272     }
273 
274     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
275         unchecked {
276             if (b == 0) return (false, 0);
277             return (true, a / b);
278         }
279     }
280 
281     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
282         unchecked {
283             if (b == 0) return (false, 0);
284             return (true, a % b);
285         }
286     }
287 
288     function add(uint256 a, uint256 b) internal pure returns (uint256) {
289         return a + b;
290     }
291 
292     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
293         return a - b;
294     }
295 
296     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
297         return a * b;
298     }
299 
300     function div(uint256 a, uint256 b) internal pure returns (uint256) {
301         return a / b;
302     }
303 
304     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
305         return a % b;
306     }
307 
308     function sub(
309         uint256 a,
310         uint256 b,
311         string memory errorMessage
312     ) internal pure returns (uint256) {
313         unchecked {
314             require(b <= a, errorMessage);
315             return a - b;
316         }
317     }
318 
319     function div(
320         uint256 a,
321         uint256 b,
322         string memory errorMessage
323     ) internal pure returns (uint256) {
324         unchecked {
325             require(b > 0, errorMessage);
326             return a / b;
327         }
328     }
329 
330     function mod(
331         uint256 a,
332         uint256 b,
333         string memory errorMessage
334     ) internal pure returns (uint256) {
335         unchecked {
336             require(b > 0, errorMessage);
337             return a % b;
338         }
339     }
340 }
341 
342 interface IUniswapV2Factory {
343     event PairCreated(
344         address indexed token0,
345         address indexed token1,
346         address pair,
347         uint256
348     );
349 
350     function feeTo() external view returns (address);
351 
352     function feeToSetter() external view returns (address);
353 
354     function getPair(address tokenA, address tokenB)
355         external
356         view
357         returns (address pair);
358 
359     function allPairs(uint256) external view returns (address pair);
360 
361     function allPairsLength() external view returns (uint256);
362 
363     function createPair(address tokenA, address tokenB)
364         external
365         returns (address pair);
366 
367     function setFeeTo(address) external;
368 
369     function setFeeToSetter(address) external;
370 }
371 
372 interface IUniswapV2Pair {
373     event Approval(
374         address indexed owner,
375         address indexed spender,
376         uint256 value
377     );
378     event Transfer(address indexed from, address indexed to, uint256 value);
379 
380     function name() external pure returns (string memory);
381 
382     function symbol() external pure returns (string memory);
383 
384     function decimals() external pure returns (uint8);
385 
386     function totalSupply() external view returns (uint256);
387 
388     function balanceOf(address owner) external view returns (uint256);
389 
390     function allowance(address owner, address spender)
391         external
392         view
393         returns (uint256);
394 
395     function approve(address spender, uint256 value) external returns (bool);
396 
397     function transfer(address to, uint256 value) external returns (bool);
398 
399     function transferFrom(
400         address from,
401         address to,
402         uint256 value
403     ) external returns (bool);
404 
405     function DOMAIN_SEPARATOR() external view returns (bytes32);
406 
407     function PERMIT_TYPEHASH() external pure returns (bytes32);
408 
409     function nonces(address owner) external view returns (uint256);
410 
411     function permit(
412         address owner,
413         address spender,
414         uint256 value,
415         uint256 deadline,
416         uint8 v,
417         bytes32 r,
418         bytes32 s
419     ) external;
420 
421     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
422     event Burn(
423         address indexed sender,
424         uint256 amount0,
425         uint256 amount1,
426         address indexed to
427     );
428     event Swap(
429         address indexed sender,
430         uint256 amount0In,
431         uint256 amount1In,
432         uint256 amount0Out,
433         uint256 amount1Out,
434         address indexed to
435     );
436     event Sync(uint112 reserve0, uint112 reserve1);
437 
438     function MINIMUM_LIQUIDITY() external pure returns (uint256);
439 
440     function factory() external view returns (address);
441 
442     function token0() external view returns (address);
443 
444     function token1() external view returns (address);
445 
446     function getReserves()
447         external
448         view
449         returns (
450             uint112 reserve0,
451             uint112 reserve1,
452             uint32 blockTimestampLast
453         );
454 
455     function price0CumulativeLast() external view returns (uint256);
456 
457     function price1CumulativeLast() external view returns (uint256);
458 
459     function kLast() external view returns (uint256);
460 
461     function mint(address to) external returns (uint256 liquidity);
462 
463     function burn(address to)
464         external
465         returns (uint256 amount0, uint256 amount1);
466 
467     function swap(
468         uint256 amount0Out,
469         uint256 amount1Out,
470         address to,
471         bytes calldata data
472     ) external;
473 
474     function skim(address to) external;
475 
476     function sync() external;
477 
478     function initialize(address, address) external;
479 }
480 
481 interface IUniswapV2Router02 {
482     function factory() external pure returns (address);
483 
484     function WETH() external pure returns (address);
485 
486     function addLiquidity(
487         address tokenA,
488         address tokenB,
489         uint256 amountADesired,
490         uint256 amountBDesired,
491         uint256 amountAMin,
492         uint256 amountBMin,
493         address to,
494         uint256 deadline
495     )
496         external
497         returns (
498             uint256 amountA,
499             uint256 amountB,
500             uint256 liquidity
501         );
502 
503     function addLiquidityETH(
504         address token,
505         uint256 amountTokenDesired,
506         uint256 amountTokenMin,
507         uint256 amountETHMin,
508         address to,
509         uint256 deadline
510     )
511         external
512         payable
513         returns (
514             uint256 amountToken,
515             uint256 amountETH,
516             uint256 liquidity
517         );
518 
519     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
520         uint256 amountIn,
521         uint256 amountOutMin,
522         address[] calldata path,
523         address to,
524         uint256 deadline
525     ) external;
526 
527     function swapExactETHForTokensSupportingFeeOnTransferTokens(
528         uint256 amountOutMin,
529         address[] calldata path,
530         address to,
531         uint256 deadline
532     ) external payable;
533 
534     function swapExactTokensForETHSupportingFeeOnTransferTokens(
535         uint256 amountIn,
536         uint256 amountOutMin,
537         address[] calldata path,
538         address to,
539         uint256 deadline
540     ) external;
541 }
542 
543 contract BabyPepe is ERC20, Ownable {
544     using SafeMath for uint256;
545 
546     IUniswapV2Router02 public immutable uniswapV2Router;
547     address public immutable uniswapV2Pair;
548     address public constant deadAddress = address(0xdead);
549     address public routerCA = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D uniswap
550 
551     bool private swapping;
552 
553     address public marketingwallet;
554     address public devWallet;
555     address public liqWallet;
556     address public operationsWallet;
557     address public cexWallet;
558 
559     uint256 public maxTransactionAmount;
560     uint256 public swapTokensAtAmount;
561     uint256 public maxWallet;
562 
563     bool public limitsInEffect = true;
564     bool public tradingActive = false;
565     bool public swapEnabled = false;
566 
567     // Anti-bot and anti-whale mappings and variables
568     mapping(address => uint256) private _holderLastTransferTimestamp;
569     bool public transferDelayEnabled = true;
570     uint256 private launchBlock;
571     uint256 private deadBlocks;
572     mapping(address => bool) public blocked;
573 
574     uint256 public buyTotalFees;
575     uint256 public buyMarkFee;
576     uint256 public buyLiquidityFee;
577     uint256 public buyDevFee;
578     uint256 public buyOperationsFee;
579 
580     uint256 public sellTotalFees;
581     uint256 public sellMarkFee;
582     uint256 public sellLiquidityFee;
583     uint256 public sellDevFee;
584     uint256 public sellOperationsFee;
585 
586     uint256 public tokensForMark;
587     uint256 public tokensForLiquidity;
588     uint256 public tokensForDev;
589     uint256 public tokensForOperations;
590 
591     mapping(address => bool) private _isExcludedFromFees;
592     mapping(address => bool) public _isExcludedMaxTransactionAmount;
593     mapping(address => bool) public _isExcludedMaxWalletAmount;
594 
595     mapping(address => bool) public automatedMarketMakerPairs;
596 
597     event UpdateUniswapV2Router(
598         address indexed newAddress,
599         address indexed oldAddress
600     );
601 
602     event ExcludeFromFees(address indexed account, bool isExcluded);
603 
604     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
605 
606     event mktWalletUpdated(
607         address indexed newWallet,
608         address indexed oldWallet
609     );
610 
611     event devWalletUpdated(
612         address indexed newWallet,
613         address indexed oldWallet
614     );
615 
616     event liqWalletUpdated(
617         address indexed newWallet,
618         address indexed oldWallet
619     );
620 
621     event operationsWalletUpdated(
622         address indexed newWallet,
623         address indexed oldWallet
624     );
625 
626     event cexWalletUpdated(
627         address indexed newWallet,
628         address indexed oldWallet
629     );
630 
631     event SwapAndLiquify(
632         uint256 tokensSwapped,
633         uint256 ethReceived,
634         uint256 tokensIntoLiquidity
635     );
636 
637     constructor() ERC20("BabyPepe", "BAPE") {
638         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(routerCA); 
639 
640         excludeFromMaxTransaction(address(_uniswapV2Router), true);
641         uniswapV2Router = _uniswapV2Router;
642 
643         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
644             .createPair(address(this), _uniswapV2Router.WETH());
645         excludeFromMaxTransaction(address(uniswapV2Pair), true);
646         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
647 
648         // launch buy fees
649         uint256 _buyMarkFee = 30;
650         uint256 _buyLiquidityFee = 0;
651         uint256 _buyDevFee = 0;
652         uint256 _buyOperationsFee = 0;
653         
654         // launch sell fees
655         uint256 _sellMarkFee = 50;
656         uint256 _sellLiquidityFee = 0;
657         uint256 _sellDevFee = 0;
658         uint256 _sellOperationsFee = 0;
659 
660         uint256 totalSupply = 1_000_000_000_000 * 1e18;
661 
662         maxTransactionAmount = 20_000_000_000 * 1e18;
663         maxWallet = 20_000_000_000 * 1e18;
664         swapTokensAtAmount = (totalSupply * 10) / 10000;
665 
666         buyMarkFee = _buyMarkFee;
667         buyLiquidityFee = _buyLiquidityFee;
668         buyDevFee = _buyDevFee;
669         buyOperationsFee = _buyOperationsFee;
670         buyTotalFees = buyMarkFee + buyLiquidityFee + buyDevFee + buyOperationsFee;
671 
672         sellMarkFee = _sellMarkFee;
673         sellLiquidityFee = _sellLiquidityFee;
674         sellDevFee = _sellDevFee;
675         sellOperationsFee = _sellOperationsFee;
676         sellTotalFees = sellMarkFee + sellLiquidityFee + sellDevFee + sellOperationsFee;
677 
678         marketingwallet = address(0x331b434749d40a2f8C334B0e559301D14560ab64); 
679         devWallet = address(0x331b434749d40a2f8C334B0e559301D14560ab64); 
680         liqWallet = address(0xfe035fEB200e3bB359C16181580b0e7C989bEB4b); 
681         operationsWallet = address(0x331b434749d40a2f8C334B0e559301D14560ab64);
682         cexWallet = address(0x331b434749d40a2f8C334B0e559301D14560ab64);
683 
684         // exclude from paying fees or having max transaction amount
685         excludeFromFees(owner(), true);
686         excludeFromFees(address(this), true);
687         excludeFromFees(address(0xdead), true);
688         excludeFromFees(address(cexWallet), true);
689         excludeFromFees(address(marketingwallet), true);
690         excludeFromFees(address(liqWallet), true);
691 
692         excludeFromMaxTransaction(owner(), true);
693         excludeFromMaxTransaction(address(this), true);
694         excludeFromMaxTransaction(address(0xdead), true);
695         excludeFromMaxTransaction(address(cexWallet), true);
696         excludeFromMaxTransaction(address(marketingwallet), true);
697         excludeFromMaxTransaction(address(liqWallet), true);
698 
699         excludeFromMaxWallet(owner(), true);
700         excludeFromMaxWallet(address(this), true);
701         excludeFromMaxWallet(address(0xdead), true);
702         excludeFromMaxWallet(address(cexWallet), true);
703         excludeFromMaxWallet(address(marketingwallet), true);
704         excludeFromMaxWallet(address(liqWallet), true);
705 
706         _mint(msg.sender, totalSupply);
707     }
708 
709     receive() external payable {}
710 
711     function enableTrading(uint256 _deadBlocks) external onlyOwner {
712         require(!tradingActive, "Token launched");
713         tradingActive = true;
714         launchBlock = block.number;
715         swapEnabled = true;
716         deadBlocks = _deadBlocks;
717     }
718 
719     // remove limits after token is stable
720     function removeLimits() external onlyOwner returns (bool) {
721         limitsInEffect = false;
722         return true;
723     }
724 
725     // disable Transfer delay - cannot be reenabled
726     function disableTransferDelay() external onlyOwner returns (bool) {
727         transferDelayEnabled = false;
728         return true;
729     }
730 
731     // change the minimum amount of tokens to sell from fees
732     function updateSwapTokensAtAmount(uint256 newAmount)
733         external
734         onlyOwner
735         returns (bool)
736     {
737         require(
738             newAmount >= (totalSupply() * 1) / 100000,
739             "Swap amount cannot be lower than 0.001% total supply."
740         );
741         require(
742             newAmount <= (totalSupply() * 5) / 1000,
743             "Swap amount cannot be higher than 0.5% total supply."
744         );
745         swapTokensAtAmount = newAmount;
746         return true;
747     }
748 
749     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
750         require(
751             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
752             "Cannot set maxTransactionAmount lower than 0.1%"
753         );
754         maxTransactionAmount = newNum * (10**18);
755     }
756 
757     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
758         require(
759             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
760             "Cannot set maxWallet lower than 0.5%"
761         );
762         maxWallet = newNum * (10**18);
763     }
764 
765     function excludeFromMaxTransaction(address updAds, bool isEx)
766         public
767         onlyOwner
768     {
769         _isExcludedMaxTransactionAmount[updAds] = isEx;
770     }
771 
772     function excludeFromMaxWallet(address updAds, bool isEx)
773         public
774         onlyOwner
775     {
776         _isExcludedMaxWalletAmount[updAds] = isEx;
777     }
778 
779     // only use to disable contract sales if absolutely necessary (emergency use only)
780     function updateSwapEnabled(bool enabled) external onlyOwner {
781         swapEnabled = enabled;
782     }
783 
784     function updateBuyFees(
785         uint256 _markFee,
786         uint256 _liquidityFee,
787         uint256 _devFee,
788         uint256 _operationsFee
789     ) external onlyOwner {
790         buyMarkFee = _markFee;
791         buyLiquidityFee = _liquidityFee;
792         buyDevFee = _devFee;
793         buyOperationsFee = _operationsFee;
794         buyTotalFees = buyMarkFee + buyLiquidityFee + buyDevFee + buyOperationsFee;
795         require(buyTotalFees <= 99);
796     }
797 
798     function updateSellFees(
799         uint256 _markFee,
800         uint256 _liquidityFee,
801         uint256 _devFee,
802         uint256 _operationsFee
803     ) external onlyOwner {
804         sellMarkFee = _markFee;
805         sellLiquidityFee = _liquidityFee;
806         sellDevFee = _devFee;
807         sellOperationsFee = _operationsFee;
808         sellTotalFees = sellMarkFee + sellLiquidityFee + sellDevFee + sellOperationsFee;
809         require(sellTotalFees <= 99); 
810     }
811 
812     function excludeFromFees(address account, bool excluded) public onlyOwner {
813         _isExcludedFromFees[account] = excluded;
814         emit ExcludeFromFees(account, excluded);
815     }
816 
817     function setAutomatedMarketMakerPair(address pair, bool value)
818         public
819         onlyOwner
820     {
821         require(
822             pair != uniswapV2Pair,
823             "The pair cannot be removed from automatedMarketMakerPairs"
824         );
825 
826         _setAutomatedMarketMakerPair(pair, value);
827     }
828 
829     function _setAutomatedMarketMakerPair(address pair, bool value) private {
830         automatedMarketMakerPairs[pair] = value;
831 
832         emit SetAutomatedMarketMakerPair(pair, value);
833     }
834 
835     function updatemktWallet(address newmktWallet) external onlyOwner {
836         emit mktWalletUpdated(newmktWallet, marketingwallet);
837         marketingwallet = newmktWallet;
838     }
839 
840     function updateDevWallet(address newWallet) external onlyOwner {
841         emit devWalletUpdated(newWallet, devWallet);
842         devWallet = newWallet;
843     }
844 
845     function updateoperationsWallet(address newWallet) external onlyOwner{
846         emit operationsWalletUpdated(newWallet, operationsWallet);
847         operationsWallet = newWallet;
848     }
849 
850     function updateLiqWallet(address newLiqWallet) external onlyOwner {
851         emit liqWalletUpdated(newLiqWallet, liqWallet);
852         liqWallet = newLiqWallet;
853     }
854 
855     function updatecexWallet(address newcexWallet) external onlyOwner {
856         emit cexWalletUpdated(newcexWallet, cexWallet);
857         cexWallet = newcexWallet;
858     }
859 
860     function isExcludedFromFees(address account) public view returns (bool) {
861         return _isExcludedFromFees[account];
862     }
863 
864     event BoughtEarly(address indexed sniper);
865 
866     function _transfer(
867         address from,
868         address to,
869         uint256 amount
870     ) internal override {
871         require(from != address(0), "ERC20: transfer from the zero address");
872         require(to != address(0), "ERC20: transfer to the zero address");
873         require(!blocked[from], "Sniper blocked");
874 
875         if (amount == 0) {
876             super._transfer(from, to, 0);
877             return;
878         }
879 
880         if (limitsInEffect) {
881             if (
882                 from != owner() &&
883                 to != owner() &&
884                 to != address(0) &&
885                 to != address(0xdead) &&
886                 !swapping
887             ) {
888                 if (!tradingActive) {
889                     require(
890                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
891                         "Trading is not active."
892                     );
893                 }
894 
895                 if(block.number <= launchBlock + deadBlocks && from == address(uniswapV2Pair) &&  
896                 to != routerCA && to != address(this) && to != address(uniswapV2Pair)){
897                     blocked[to] = true;
898                     emit BoughtEarly(to);
899                 }
900 
901                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
902                 if (transferDelayEnabled) {
903                     if (
904                         to != owner() &&
905                         to != address(uniswapV2Router) &&
906                         to != address(uniswapV2Pair)
907                     ) {
908                         require(
909                             _holderLastTransferTimestamp[tx.origin] <
910                                 block.number,
911                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
912                         );
913                         _holderLastTransferTimestamp[tx.origin] = block.number;
914                     }
915                 }
916 
917                 //when buy
918                 if (
919                     automatedMarketMakerPairs[from] &&
920                     !_isExcludedMaxTransactionAmount[to]
921                 ) {
922                     require(
923                         amount <= maxTransactionAmount,
924                         "Buy transfer amount exceeds the maxTransactionAmount."
925                     );
926                     if (!_isExcludedMaxWalletAmount[to]) { // Added this condition
927                         require(
928                             amount + balanceOf(to) <= maxWallet,
929                             "Max wallet exceeded"
930                         );
931                     }
932                 }
933                 //when sell
934                 else if (
935                     automatedMarketMakerPairs[to] &&
936                     !_isExcludedMaxTransactionAmount[from]
937                 ) {
938                     require(
939                         amount <= maxTransactionAmount,
940                         "Sell transfer amount exceeds the maxTransactionAmount."
941                     );
942                 } else if (!_isExcludedMaxTransactionAmount[to]) {
943                     if (!_isExcludedMaxWalletAmount[to]) { // Added this condition
944                         require(
945                             amount + balanceOf(to) <= maxWallet,
946                             "Max wallet exceeded"
947                         );
948                     }
949                 }
950             }
951         }
952 
953         uint256 contractTokenBalance = balanceOf(address(this));
954 
955         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
956 
957         if (
958             canSwap &&
959             swapEnabled &&
960             !swapping &&
961             !automatedMarketMakerPairs[from] &&
962             !_isExcludedFromFees[from] &&
963             !_isExcludedFromFees[to]
964         ) {
965             swapping = true;
966 
967             swapBack();
968 
969             swapping = false;
970         }
971 
972         bool takeFee = !swapping;
973 
974         // if any account belongs to _isExcludedFromFee account then remove the fee
975         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
976             takeFee = false;
977         }
978 
979         uint256 fees = 0;
980         // only take fees on buys/sells, do not take on wallet transfers
981         if (takeFee) {
982             // on sell
983             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
984                 fees = amount.mul(sellTotalFees).div(100);
985                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
986                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
987                 tokensForMark += (fees * sellMarkFee) / sellTotalFees;
988                 tokensForOperations += (fees * sellOperationsFee) / sellTotalFees;
989             }
990             // on buy
991             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
992                 fees = amount.mul(buyTotalFees).div(100);
993                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
994                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
995                 tokensForMark += (fees * buyMarkFee) / buyTotalFees;
996                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
997             }
998 
999             if (fees > 0) {
1000                 super._transfer(from, address(this), fees);
1001             }
1002 
1003             amount -= fees;
1004         }
1005 
1006         super._transfer(from, to, amount);
1007     }
1008 
1009     function swapTokensForEth(uint256 tokenAmount) private {
1010         // generate the uniswap pair path of token -> weth
1011         address[] memory path = new address[](2);
1012         path[0] = address(this);
1013         path[1] = uniswapV2Router.WETH();
1014 
1015         _approve(address(this), address(uniswapV2Router), tokenAmount);
1016 
1017         // make the swap
1018         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1019             tokenAmount,
1020             0, // accept any amount of ETH
1021             path,
1022             address(this),
1023             block.timestamp
1024         );
1025     }
1026 
1027     function multiBlock(address[] calldata blockees, bool shouldBlock) external onlyOwner {
1028         for(uint256 i = 0;i<blockees.length;i++){
1029             address blockee = blockees[i];
1030             if(blockee != address(this) && 
1031                blockee != routerCA && 
1032                blockee != address(uniswapV2Pair))
1033                 blocked[blockee] = shouldBlock;
1034         }
1035     }
1036 
1037     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1038         // approve token transfer to cover all possible scenarios
1039         _approve(address(this), address(uniswapV2Router), tokenAmount);
1040 
1041         // add the liquidity
1042         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1043             address(this),
1044             tokenAmount,
1045             0, // slippage is unavoidable
1046             0, // slippage is unavoidable
1047             liqWallet,
1048             block.timestamp
1049         );
1050     }
1051 
1052     function swapBack() private {
1053         uint256 contractBalance = balanceOf(address(this));
1054         uint256 totalTokensToSwap = tokensForLiquidity +
1055             tokensForMark +
1056             tokensForDev +
1057             tokensForOperations;
1058         bool success;
1059 
1060         if (contractBalance == 0 || totalTokensToSwap == 0) {
1061             return;
1062         }
1063 
1064         if (contractBalance > swapTokensAtAmount * 20) {
1065             contractBalance = swapTokensAtAmount * 20;
1066         }
1067 
1068         // Halve the amount of liquidity tokens
1069         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1070         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1071 
1072         uint256 initialETHBalance = address(this).balance;
1073 
1074         swapTokensForEth(amountToSwapForETH);
1075 
1076         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1077 
1078         uint256 ethForMark = ethBalance.mul(tokensForMark).div(totalTokensToSwap);
1079         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1080         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap);
1081 
1082         uint256 ethForLiquidity = ethBalance - ethForMark - ethForDev - ethForOperations;
1083 
1084         tokensForLiquidity = 0;
1085         tokensForMark = 0;
1086         tokensForDev = 0;
1087         tokensForOperations = 0;
1088 
1089         (success, ) = address(devWallet).call{value: ethForDev}("");
1090 
1091         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1092             addLiquidity(liquidityTokens, ethForLiquidity);
1093             emit SwapAndLiquify(
1094                 amountToSwapForETH,
1095                 ethForLiquidity,
1096                 tokensForLiquidity
1097             );
1098         }
1099         (success, ) = address(operationsWallet).call{value: ethForOperations}("");
1100         (success, ) = address(marketingwallet).call{value: address(this).balance}("");
1101     }
1102 }