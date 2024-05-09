1 /**                                                                                                                                                                                                                                                                                                                                                                                        
2                                   - YETI -
3             |---------------------------------------------|
4             | Website -  https://yeticoin.net/            |
5             | Twitter -  https://twitter.com/YetiCoinErc  |
6             | Telegram - https://t.me/YetiCoinOfficial    |
7             |---------------------------------------------|
8 */ 
9 
10 // SPDX-License-Identifier: MIT
11 
12 pragma solidity 0.8.19;
13 pragma experimental ABIEncoderV2;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 abstract contract Ownable is Context {
26     address private _owner;
27 
28     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29 
30     constructor() {
31         _transferOwnership(_msgSender());
32     }
33 
34     function owner() public view virtual returns (address) {
35         return _owner;
36     }
37 
38     modifier onlyOwner() {
39         require(owner() == _msgSender(), "Ownable: caller is not the owner");
40         _;
41     }
42 
43     function renounceOwnership() public virtual onlyOwner {
44         _transferOwnership(address(0));
45     }
46 
47     function transferOwnership(address newOwner) public virtual onlyOwner {
48         require(newOwner != address(0), "Ownable: new owner is the zero address");
49         _transferOwnership(newOwner);
50     }
51 
52     function _transferOwnership(address newOwner) internal virtual {
53         address oldOwner = _owner;
54         _owner = newOwner;
55         emit OwnershipTransferred(oldOwner, newOwner);
56     }
57 }
58 
59 interface IERC20 {
60 
61     function totalSupply() external view returns (uint256);
62 
63     function balanceOf(address account) external view returns (uint256);
64 
65     function transfer(address recipient, uint256 amount) external returns (bool);
66 
67     function allowance(address owner, address spender) external view returns (uint256);
68 
69     function approve(address spender, uint256 amount) external returns (bool);
70 
71     function transferFrom(
72         address sender,
73         address recipient,
74         uint256 amount
75     ) external returns (bool);
76 
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 interface IERC20Metadata is IERC20 {
83 
84     function name() external view returns (string memory);
85 
86     function symbol() external view returns (string memory);
87 
88     function decimals() external view returns (uint8);
89 }
90 
91 contract ERC20 is Context, IERC20, IERC20Metadata {
92     mapping(address => uint256) private _balances;
93 
94     mapping(address => mapping(address => uint256)) private _allowances;
95 
96     uint256 private _totalSupply;
97 
98     string private _name;
99     string private _symbol;
100 
101     constructor(string memory name_, string memory symbol_) {
102         _name = name_;
103         _symbol = symbol_;
104     }
105 
106     function name() public view virtual override returns (string memory) {
107         return _name;
108     }
109 
110     function symbol() public view virtual override returns (string memory) {
111         return _symbol;
112     }
113 
114     function decimals() public view virtual override returns (uint8) {
115         return 18;
116     }
117 
118     function totalSupply() public view virtual override returns (uint256) {
119         return _totalSupply;
120     }
121 
122     function balanceOf(address account) public view virtual override returns (uint256) {
123         return _balances[account];
124     }
125 
126     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
127         _transfer(_msgSender(), recipient, amount);
128         return true;
129     }
130 
131     function allowance(address owner, address spender) public view virtual override returns (uint256) {
132         return _allowances[owner][spender];
133     }
134 
135     function approve(address spender, uint256 amount) public virtual override returns (bool) {
136         _approve(_msgSender(), spender, amount);
137         return true;
138     }
139 
140     function transferFrom(
141         address sender,
142         address recipient,
143         uint256 amount
144     ) public virtual override returns (bool) {
145         _transfer(sender, recipient, amount);
146 
147         uint256 currentAllowance = _allowances[sender][_msgSender()];
148         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
149         unchecked {
150             _approve(sender, _msgSender(), currentAllowance - amount);
151         }
152 
153         return true;
154     }
155 
156     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
157         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
158         return true;
159     }
160 
161     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
162         uint256 currentAllowance = _allowances[_msgSender()][spender];
163         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
164         unchecked {
165             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
166         }
167 
168         return true;
169     }
170 
171     function _transfer(
172         address sender,
173         address recipient,
174         uint256 amount
175     ) internal virtual {
176         require(sender != address(0), "ERC20: transfer from the zero address");
177         require(recipient != address(0), "ERC20: transfer to the zero address");
178 
179         _beforeTokenTransfer(sender, recipient, amount);
180 
181         uint256 senderBalance = _balances[sender];
182         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
183         unchecked {
184             _balances[sender] = senderBalance - amount;
185         }
186         _balances[recipient] += amount;
187 
188         emit Transfer(sender, recipient, amount);
189 
190         _afterTokenTransfer(sender, recipient, amount);
191     }
192 
193     function _mint(address account, uint256 amount) internal virtual {
194         require(account != address(0), "ERC20: mint to the zero address");
195 
196         _beforeTokenTransfer(address(0), account, amount);
197 
198         _totalSupply += amount;
199         _balances[account] += amount;
200         emit Transfer(address(0), account, amount);
201 
202         _afterTokenTransfer(address(0), account, amount);
203     }
204 
205     function _burn(address account, uint256 amount) internal virtual {
206         require(account != address(0), "ERC20: burn from the zero address");
207 
208         _beforeTokenTransfer(account, address(0), amount);
209 
210         uint256 accountBalance = _balances[account];
211         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
212         unchecked {
213             _balances[account] = accountBalance - amount;
214         }
215         _totalSupply -= amount;
216 
217         emit Transfer(account, address(0), amount);
218 
219         _afterTokenTransfer(account, address(0), amount);
220     }
221 
222     function _approve(
223         address owner,
224         address spender,
225         uint256 amount
226     ) internal virtual {
227         require(owner != address(0), "ERC20: approve from the zero address");
228         require(spender != address(0), "ERC20: approve to the zero address");
229 
230         _allowances[owner][spender] = amount;
231         emit Approval(owner, spender, amount);
232     }
233 
234     function _beforeTokenTransfer(
235         address from,
236         address to,
237         uint256 amount
238     ) internal virtual {}
239 
240     function _afterTokenTransfer(
241         address from,
242         address to,
243         uint256 amount
244     ) internal virtual {}
245 }
246 
247 library SafeMath {
248 
249     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
250         unchecked {
251             uint256 c = a + b;
252             if (c < a) return (false, 0);
253             return (true, c);
254         }
255     }
256 
257     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
258         unchecked {
259             if (b > a) return (false, 0);
260             return (true, a - b);
261         }
262     }
263 
264     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
265         unchecked {
266             if (a == 0) return (true, 0);
267             uint256 c = a * b;
268             if (c / a != b) return (false, 0);
269             return (true, c);
270         }
271     }
272 
273     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
274         unchecked {
275             if (b == 0) return (false, 0);
276             return (true, a / b);
277         }
278     }
279 
280     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
281         unchecked {
282             if (b == 0) return (false, 0);
283             return (true, a % b);
284         }
285     }
286 
287     function add(uint256 a, uint256 b) internal pure returns (uint256) {
288         return a + b;
289     }
290 
291     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
292         return a - b;
293     }
294 
295     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
296         return a * b;
297     }
298 
299     function div(uint256 a, uint256 b) internal pure returns (uint256) {
300         return a / b;
301     }
302 
303     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
304         return a % b;
305     }
306 
307     function sub(
308         uint256 a,
309         uint256 b,
310         string memory errorMessage
311     ) internal pure returns (uint256) {
312         unchecked {
313             require(b <= a, errorMessage);
314             return a - b;
315         }
316     }
317 
318     function div(
319         uint256 a,
320         uint256 b,
321         string memory errorMessage
322     ) internal pure returns (uint256) {
323         unchecked {
324             require(b > 0, errorMessage);
325             return a / b;
326         }
327     }
328 
329     function mod(
330         uint256 a,
331         uint256 b,
332         string memory errorMessage
333     ) internal pure returns (uint256) {
334         unchecked {
335             require(b > 0, errorMessage);
336             return a % b;
337         }
338     }
339 }
340 
341 interface IUniswapV2Factory {
342     event PairCreated(
343         address indexed token0,
344         address indexed token1,
345         address pair,
346         uint256
347     );
348 
349     function feeTo() external view returns (address);
350 
351     function feeToSetter() external view returns (address);
352 
353     function getPair(address tokenA, address tokenB)
354         external
355         view
356         returns (address pair);
357 
358     function allPairs(uint256) external view returns (address pair);
359 
360     function allPairsLength() external view returns (uint256);
361 
362     function createPair(address tokenA, address tokenB)
363         external
364         returns (address pair);
365 
366     function setFeeTo(address) external;
367 
368     function setFeeToSetter(address) external;
369 }
370 
371 interface IUniswapV2Pair {
372     event Approval(
373         address indexed owner,
374         address indexed spender,
375         uint256 value
376     );
377     event Transfer(address indexed from, address indexed to, uint256 value);
378 
379     function name() external pure returns (string memory);
380 
381     function symbol() external pure returns (string memory);
382 
383     function decimals() external pure returns (uint8);
384 
385     function totalSupply() external view returns (uint256);
386 
387     function balanceOf(address owner) external view returns (uint256);
388 
389     function allowance(address owner, address spender)
390         external
391         view
392         returns (uint256);
393 
394     function approve(address spender, uint256 value) external returns (bool);
395 
396     function transfer(address to, uint256 value) external returns (bool);
397 
398     function transferFrom(
399         address from,
400         address to,
401         uint256 value
402     ) external returns (bool);
403 
404     function DOMAIN_SEPARATOR() external view returns (bytes32);
405 
406     function PERMIT_TYPEHASH() external pure returns (bytes32);
407 
408     function nonces(address owner) external view returns (uint256);
409 
410     function permit(
411         address owner,
412         address spender,
413         uint256 value,
414         uint256 deadline,
415         uint8 v,
416         bytes32 r,
417         bytes32 s
418     ) external;
419 
420     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
421     event Burn(
422         address indexed sender,
423         uint256 amount0,
424         uint256 amount1,
425         address indexed to
426     );
427     event Swap(
428         address indexed sender,
429         uint256 amount0In,
430         uint256 amount1In,
431         uint256 amount0Out,
432         uint256 amount1Out,
433         address indexed to
434     );
435     event Sync(uint112 reserve0, uint112 reserve1);
436 
437     function MINIMUM_LIQUIDITY() external pure returns (uint256);
438 
439     function factory() external view returns (address);
440 
441     function token0() external view returns (address);
442 
443     function token1() external view returns (address);
444 
445     function getReserves()
446         external
447         view
448         returns (
449             uint112 reserve0,
450             uint112 reserve1,
451             uint32 blockTimestampLast
452         );
453 
454     function price0CumulativeLast() external view returns (uint256);
455 
456     function price1CumulativeLast() external view returns (uint256);
457 
458     function kLast() external view returns (uint256);
459 
460     function mint(address to) external returns (uint256 liquidity);
461 
462     function burn(address to)
463         external
464         returns (uint256 amount0, uint256 amount1);
465 
466     function swap(
467         uint256 amount0Out,
468         uint256 amount1Out,
469         address to,
470         bytes calldata data
471     ) external;
472 
473     function skim(address to) external;
474 
475     function sync() external;
476 
477     function initialize(address, address) external;
478 }
479 
480 interface IUniswapV2Router02 {
481     function factory() external pure returns (address);
482 
483     function WETH() external pure returns (address);
484 
485     function addLiquidity(
486         address tokenA,
487         address tokenB,
488         uint256 amountADesired,
489         uint256 amountBDesired,
490         uint256 amountAMin,
491         uint256 amountBMin,
492         address to,
493         uint256 deadline
494     )
495         external
496         returns (
497             uint256 amountA,
498             uint256 amountB,
499             uint256 liquidity
500         );
501 
502     function addLiquidityETH(
503         address token,
504         uint256 amountTokenDesired,
505         uint256 amountTokenMin,
506         uint256 amountETHMin,
507         address to,
508         uint256 deadline
509     )
510         external
511         payable
512         returns (
513             uint256 amountToken,
514             uint256 amountETH,
515             uint256 liquidity
516         );
517 
518     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
519         uint256 amountIn,
520         uint256 amountOutMin,
521         address[] calldata path,
522         address to,
523         uint256 deadline
524     ) external;
525 
526     function swapExactETHForTokensSupportingFeeOnTransferTokens(
527         uint256 amountOutMin,
528         address[] calldata path,
529         address to,
530         uint256 deadline
531     ) external payable;
532 
533     function swapExactTokensForETHSupportingFeeOnTransferTokens(
534         uint256 amountIn,
535         uint256 amountOutMin,
536         address[] calldata path,
537         address to,
538         uint256 deadline
539     ) external;
540 }
541 
542 contract Yeti is ERC20, Ownable {
543     using SafeMath for uint256;
544 
545     IUniswapV2Router02 public immutable uniswapV2Router;
546     address public immutable uniswapV2Pair;
547     address public constant deadAddress = address(0xdead);
548     address public routerCA = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D uniswap
549 
550     bool private swapping;
551 
552     address public marketingwallet;
553     address public devWallet;
554     address public liqWallet;
555     address public operationsWallet;
556     address public cexWallet;
557 
558     uint256 public maxTransactionAmount;
559     uint256 public swapTokensAtAmount;
560     uint256 public maxWallet;
561 
562     bool public limitsInEffect = true;
563     bool public tradingActive = false;
564     bool public swapEnabled = false;
565 
566     // Anti-bot and anti-whale mappings and variables
567     mapping(address => uint256) private _holderLastTransferTimestamp;
568     bool public transferDelayEnabled = true;
569     uint256 private launchBlock;
570     uint256 private deadBlocks;
571     mapping(address => bool) public blocked;
572 
573     uint256 public buyTotalFees;
574     uint256 public buyMarkFee;
575     uint256 public buyLiquidityFee;
576     uint256 public buyDevFee;
577     uint256 public buyOperationsFee;
578 
579     uint256 public sellTotalFees;
580     uint256 public sellMarkFee;
581     uint256 public sellLiquidityFee;
582     uint256 public sellDevFee;
583     uint256 public sellOperationsFee;
584 
585     uint256 public tokensForMark;
586     uint256 public tokensForLiquidity;
587     uint256 public tokensForDev;
588     uint256 public tokensForOperations;
589 
590     mapping(address => bool) private _isExcludedFromFees;
591     mapping(address => bool) public _isExcludedMaxTransactionAmount;
592     mapping(address => bool) public _isExcludedMaxWalletAmount;
593 
594     mapping(address => bool) public automatedMarketMakerPairs;
595 
596     event UpdateUniswapV2Router(
597         address indexed newAddress,
598         address indexed oldAddress
599     );
600 
601     event ExcludeFromFees(address indexed account, bool isExcluded);
602 
603     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
604 
605     event mktWalletUpdated(
606         address indexed newWallet,
607         address indexed oldWallet
608     );
609 
610     event devWalletUpdated(
611         address indexed newWallet,
612         address indexed oldWallet
613     );
614 
615     event liqWalletUpdated(
616         address indexed newWallet,
617         address indexed oldWallet
618     );
619 
620     event operationsWalletUpdated(
621         address indexed newWallet,
622         address indexed oldWallet
623     );
624 
625     event cexWalletUpdated(
626         address indexed newWallet,
627         address indexed oldWallet
628     );
629 
630     event SwapAndLiquify(
631         uint256 tokensSwapped,
632         uint256 ethReceived,
633         uint256 tokensIntoLiquidity
634     );
635 
636     constructor() ERC20("Yeti", "YETI") {
637         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(routerCA); 
638 
639         excludeFromMaxTransaction(address(_uniswapV2Router), true);
640         uniswapV2Router = _uniswapV2Router;
641 
642         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
643             .createPair(address(this), _uniswapV2Router.WETH());
644         excludeFromMaxTransaction(address(uniswapV2Pair), true);
645         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
646 
647         // launch buy fees
648         uint256 _buyMarkFee = 9;
649         uint256 _buyLiquidityFee = 1;
650         uint256 _buyDevFee = 0;
651         uint256 _buyOperationsFee = 0;
652         
653         // launch sell fees
654         uint256 _sellMarkFee = 19;
655         uint256 _sellLiquidityFee = 1;
656         uint256 _sellDevFee = 0;
657         uint256 _sellOperationsFee = 0;
658 
659         uint256 totalSupply = 100_000_000 * 1e18;
660 
661         maxTransactionAmount = 2_000_000 * 1e18; // 2% max txn at launch
662         maxWallet = 2_000_000 * 1e18; // 2% max wallet at launch
663         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.01% swap wallet
664 
665         buyMarkFee = _buyMarkFee;
666         buyLiquidityFee = _buyLiquidityFee;
667         buyDevFee = _buyDevFee;
668         buyOperationsFee = _buyOperationsFee;
669         buyTotalFees = buyMarkFee + buyLiquidityFee + buyDevFee + buyOperationsFee;
670 
671         sellMarkFee = _sellMarkFee;
672         sellLiquidityFee = _sellLiquidityFee;
673         sellDevFee = _sellDevFee;
674         sellOperationsFee = _sellOperationsFee;
675         sellTotalFees = sellMarkFee + sellLiquidityFee + sellDevFee + sellOperationsFee;
676 
677         marketingwallet = address(0x036a03dE0c80cdf77dFbc7eFf55BDACC6ABC5F8c); 
678         devWallet = address(0x036a03dE0c80cdf77dFbc7eFf55BDACC6ABC5F8c); 
679         liqWallet = address(0x90FFc4539D538148692FcF033cd6ba8eCC061e11); 
680         operationsWallet = address(0x036a03dE0c80cdf77dFbc7eFf55BDACC6ABC5F8c);
681         cexWallet = address(0xc65B1fE901572f09f52d864521e6b4d046b18009);
682 
683         // exclude from paying fees or having max transaction amount
684         excludeFromFees(owner(), true);
685         excludeFromFees(address(this), true);
686         excludeFromFees(address(0xdead), true);
687         excludeFromFees(address(cexWallet), true);
688         excludeFromFees(address(marketingwallet), true);
689         excludeFromFees(address(liqWallet), true);
690 
691         excludeFromMaxTransaction(owner(), true);
692         excludeFromMaxTransaction(address(this), true);
693         excludeFromMaxTransaction(address(0xdead), true);
694         excludeFromMaxTransaction(address(cexWallet), true);
695         excludeFromMaxTransaction(address(marketingwallet), true);
696         excludeFromMaxTransaction(address(liqWallet), true);
697 
698         excludeFromMaxWallet(owner(), true);
699         excludeFromMaxWallet(address(this), true);
700         excludeFromMaxWallet(address(0xdead), true);
701         excludeFromMaxWallet(address(cexWallet), true);
702         excludeFromMaxWallet(address(marketingwallet), true);
703         excludeFromMaxWallet(address(liqWallet), true);
704 
705         _mint(msg.sender, totalSupply);
706     }
707 
708     receive() external payable {}
709 
710     function enableTrading(uint256 _deadBlocks) external onlyOwner {
711         require(!tradingActive, "Token launched");
712         tradingActive = true;
713         launchBlock = block.number;
714         swapEnabled = true;
715         deadBlocks = _deadBlocks;
716     }
717 
718     // remove limits after token is stable
719     function removeLimits() external onlyOwner returns (bool) {
720         limitsInEffect = false;
721         return true;
722     }
723 
724     // disable Transfer delay - cannot be reenabled
725     function disableTransferDelay() external onlyOwner returns (bool) {
726         transferDelayEnabled = false;
727         return true;
728     }
729 
730     // change the minimum amount of tokens to sell from fees
731     function updateSwapTokensAtAmount(uint256 newAmount)
732         external
733         onlyOwner
734         returns (bool)
735     {
736         require(
737             newAmount >= (totalSupply() * 1) / 100000,
738             "Swap amount cannot be lower than 0.001% total supply."
739         );
740         require(
741             newAmount <= (totalSupply() * 5) / 1000,
742             "Swap amount cannot be higher than 0.5% total supply."
743         );
744         swapTokensAtAmount = newAmount;
745         return true;
746     }
747 
748     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
749         require(
750             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
751             "Cannot set maxTransactionAmount lower than 0.1%"
752         );
753         maxTransactionAmount = newNum * (10**18);
754     }
755 
756     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
757         require(
758             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
759             "Cannot set maxWallet lower than 0.5%"
760         );
761         maxWallet = newNum * (10**18);
762     }
763 
764     function excludeFromMaxTransaction(address updAds, bool isEx)
765         public
766         onlyOwner
767     {
768         _isExcludedMaxTransactionAmount[updAds] = isEx;
769     }
770 
771     function excludeFromMaxWallet(address updAds, bool isEx)
772         public
773         onlyOwner
774     {
775         _isExcludedMaxWalletAmount[updAds] = isEx;
776     }
777 
778     // only use to disable contract sales if absolutely necessary (emergency use only)
779     function updateSwapEnabled(bool enabled) external onlyOwner {
780         swapEnabled = enabled;
781     }
782 
783     function updateBuyFees(
784         uint256 _markFee,
785         uint256 _liquidityFee,
786         uint256 _devFee,
787         uint256 _operationsFee
788     ) external onlyOwner {
789         buyMarkFee = _markFee;
790         buyLiquidityFee = _liquidityFee;
791         buyDevFee = _devFee;
792         buyOperationsFee = _operationsFee;
793         buyTotalFees = buyMarkFee + buyLiquidityFee + buyDevFee + buyOperationsFee;
794         require(buyTotalFees <= 99);
795     }
796 
797     function updateSellFees(
798         uint256 _markFee,
799         uint256 _liquidityFee,
800         uint256 _devFee,
801         uint256 _operationsFee
802     ) external onlyOwner {
803         sellMarkFee = _markFee;
804         sellLiquidityFee = _liquidityFee;
805         sellDevFee = _devFee;
806         sellOperationsFee = _operationsFee;
807         sellTotalFees = sellMarkFee + sellLiquidityFee + sellDevFee + sellOperationsFee;
808         require(sellTotalFees <= 99); 
809     }
810 
811     function excludeFromFees(address account, bool excluded) public onlyOwner {
812         _isExcludedFromFees[account] = excluded;
813         emit ExcludeFromFees(account, excluded);
814     }
815 
816     function setAutomatedMarketMakerPair(address pair, bool value)
817         public
818         onlyOwner
819     {
820         require(
821             pair != uniswapV2Pair,
822             "The pair cannot be removed from automatedMarketMakerPairs"
823         );
824 
825         _setAutomatedMarketMakerPair(pair, value);
826     }
827 
828     function _setAutomatedMarketMakerPair(address pair, bool value) private {
829         automatedMarketMakerPairs[pair] = value;
830 
831         emit SetAutomatedMarketMakerPair(pair, value);
832     }
833 
834     function updatemktWallet(address newmktWallet) external onlyOwner {
835         emit mktWalletUpdated(newmktWallet, marketingwallet);
836         marketingwallet = newmktWallet;
837     }
838 
839     function updateDevWallet(address newWallet) external onlyOwner {
840         emit devWalletUpdated(newWallet, devWallet);
841         devWallet = newWallet;
842     }
843 
844     function updateoperationsWallet(address newWallet) external onlyOwner{
845         emit operationsWalletUpdated(newWallet, operationsWallet);
846         operationsWallet = newWallet;
847     }
848 
849     function updateLiqWallet(address newLiqWallet) external onlyOwner {
850         emit liqWalletUpdated(newLiqWallet, liqWallet);
851         liqWallet = newLiqWallet;
852     }
853 
854     function updatecexWallet(address newcexWallet) external onlyOwner {
855         emit cexWalletUpdated(newcexWallet, cexWallet);
856         cexWallet = newcexWallet;
857     }
858 
859     function isExcludedFromFees(address account) public view returns (bool) {
860         return _isExcludedFromFees[account];
861     }
862 
863     event BoughtEarly(address indexed sniper);
864 
865     function _transfer(
866         address from,
867         address to,
868         uint256 amount
869     ) internal override {
870         require(from != address(0), "ERC20: transfer from the zero address");
871         require(to != address(0), "ERC20: transfer to the zero address");
872         require(!blocked[from], "Sniper blocked");
873 
874         if (amount == 0) {
875             super._transfer(from, to, 0);
876             return;
877         }
878 
879         if (limitsInEffect) {
880             if (
881                 from != owner() &&
882                 to != owner() &&
883                 to != address(0) &&
884                 to != address(0xdead) &&
885                 !swapping
886             ) {
887                 if (!tradingActive) {
888                     require(
889                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
890                         "Trading is not active."
891                     );
892                 }
893 
894                 if(block.number <= launchBlock + deadBlocks && from == address(uniswapV2Pair) &&  
895                 to != routerCA && to != address(this) && to != address(uniswapV2Pair)){
896                     blocked[to] = true;
897                     emit BoughtEarly(to);
898                 }
899 
900                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
901                 if (transferDelayEnabled) {
902                     if (
903                         to != owner() &&
904                         to != address(uniswapV2Router) &&
905                         to != address(uniswapV2Pair)
906                     ) {
907                         require(
908                             _holderLastTransferTimestamp[tx.origin] <
909                                 block.number,
910                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
911                         );
912                         _holderLastTransferTimestamp[tx.origin] = block.number;
913                     }
914                 }
915 
916                 //when buy
917                 if (
918                     automatedMarketMakerPairs[from] &&
919                     !_isExcludedMaxTransactionAmount[to]
920                 ) {
921                     require(
922                         amount <= maxTransactionAmount,
923                         "Buy transfer amount exceeds the maxTransactionAmount."
924                     );
925                     if (!_isExcludedMaxWalletAmount[to]) { // Added this condition
926                         require(
927                             amount + balanceOf(to) <= maxWallet,
928                             "Max wallet exceeded"
929                         );
930                     }
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
942                     if (!_isExcludedMaxWalletAmount[to]) { // Added this condition
943                         require(
944                             amount + balanceOf(to) <= maxWallet,
945                             "Max wallet exceeded"
946                         );
947                     }
948                 }
949             }
950         }
951 
952         uint256 contractTokenBalance = balanceOf(address(this));
953 
954         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
955 
956         if (
957             canSwap &&
958             swapEnabled &&
959             !swapping &&
960             !automatedMarketMakerPairs[from] &&
961             !_isExcludedFromFees[from] &&
962             !_isExcludedFromFees[to]
963         ) {
964             swapping = true;
965 
966             swapBack();
967 
968             swapping = false;
969         }
970 
971         bool takeFee = !swapping;
972 
973         // if any account belongs to _isExcludedFromFee account then remove the fee
974         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
975             takeFee = false;
976         }
977 
978         uint256 fees = 0;
979         // only take fees on buys/sells, do not take on wallet transfers
980         if (takeFee) {
981             // on sell
982             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
983                 fees = amount.mul(sellTotalFees).div(100);
984                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
985                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
986                 tokensForMark += (fees * sellMarkFee) / sellTotalFees;
987                 tokensForOperations += (fees * sellOperationsFee) / sellTotalFees;
988             }
989             // on buy
990             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
991                 fees = amount.mul(buyTotalFees).div(100);
992                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
993                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
994                 tokensForMark += (fees * buyMarkFee) / buyTotalFees;
995                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
996             }
997 
998             if (fees > 0) {
999                 super._transfer(from, address(this), fees);
1000             }
1001 
1002             amount -= fees;
1003         }
1004 
1005         super._transfer(from, to, amount);
1006     }
1007 
1008     function swapTokensForEth(uint256 tokenAmount) private {
1009         // generate the uniswap pair path of token -> weth
1010         address[] memory path = new address[](2);
1011         path[0] = address(this);
1012         path[1] = uniswapV2Router.WETH();
1013 
1014         _approve(address(this), address(uniswapV2Router), tokenAmount);
1015 
1016         // make the swap
1017         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1018             tokenAmount,
1019             0, // accept any amount of ETH
1020             path,
1021             address(this),
1022             block.timestamp
1023         );
1024     }
1025 
1026     function multiBlock(address[] calldata blockees, bool shouldBlock) external onlyOwner {
1027         for(uint256 i = 0;i<blockees.length;i++){
1028             address blockee = blockees[i];
1029             if(blockee != address(this) && 
1030                blockee != routerCA && 
1031                blockee != address(uniswapV2Pair))
1032                 blocked[blockee] = shouldBlock;
1033         }
1034     }
1035 
1036     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1037         // approve token transfer to cover all possible scenarios
1038         _approve(address(this), address(uniswapV2Router), tokenAmount);
1039 
1040         // add the liquidity
1041         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1042             address(this),
1043             tokenAmount,
1044             0, // slippage is unavoidable
1045             0, // slippage is unavoidable
1046             liqWallet,
1047             block.timestamp
1048         );
1049     }
1050 
1051     function swapBack() private {
1052         uint256 contractBalance = balanceOf(address(this));
1053         uint256 totalTokensToSwap = tokensForLiquidity +
1054             tokensForMark +
1055             tokensForDev +
1056             tokensForOperations;
1057         bool success;
1058 
1059         if (contractBalance == 0 || totalTokensToSwap == 0) {
1060             return;
1061         }
1062 
1063         if (contractBalance > swapTokensAtAmount * 20) {
1064             contractBalance = swapTokensAtAmount * 20;
1065         }
1066 
1067         // Halve the amount of liquidity tokens
1068         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1069         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1070 
1071         uint256 initialETHBalance = address(this).balance;
1072 
1073         swapTokensForEth(amountToSwapForETH);
1074 
1075         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1076 
1077         uint256 ethForMark = ethBalance.mul(tokensForMark).div(totalTokensToSwap);
1078         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1079         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap);
1080 
1081         uint256 ethForLiquidity = ethBalance - ethForMark - ethForDev - ethForOperations;
1082 
1083         tokensForLiquidity = 0;
1084         tokensForMark = 0;
1085         tokensForDev = 0;
1086         tokensForOperations = 0;
1087 
1088         (success, ) = address(devWallet).call{value: ethForDev}("");
1089 
1090         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1091             addLiquidity(liquidityTokens, ethForLiquidity);
1092             emit SwapAndLiquify(
1093                 amountToSwapForETH,
1094                 ethForLiquidity,
1095                 tokensForLiquidity
1096             );
1097         }
1098         (success, ) = address(operationsWallet).call{value: ethForOperations}("");
1099         (success, ) = address(marketingwallet).call{value: address(this).balance}("");
1100     }
1101 }