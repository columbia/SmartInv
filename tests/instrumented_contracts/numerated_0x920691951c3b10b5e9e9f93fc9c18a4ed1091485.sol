1 /**
2  *https://www.derpmeme.com/
3 
4 https://t.me/+o766wsEykEhiZTdk
5 
6 https://twitter.com/derpderpmeme
7 
8 The anti whale tokenamik that wurks.
9 */
10 
11 // SPDX-License-Identifier: MIT
12 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
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
542 contract DERP is ERC20, Ownable {
543     using SafeMath for uint256;
544 
545     IUniswapV2Router02 public immutable uniswapV2Router;
546     address public immutable uniswapV2Pair;
547     address public constant deadAddress = address(0xdead);
548     address public routerCA = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D uniswap
549 
550     bool private swapping;
551 
552     address public mktgWallet;
553     address public devWallet;
554     address public liqWallet;
555     address public operationsWallet;
556 
557     uint256 public maxTransactionAmount;
558     uint256 public swapTokensAtAmount;
559     uint256 public maxWallet;
560 
561     bool public limitsInEffect = true;
562     bool public tradingActive = false;
563     bool public swapEnabled = false;
564 
565     // Anti-bot and anti-whale mappings and variables
566     mapping(address => uint256) private _holderLastTransferTimestamp;
567     bool public transferDelayEnabled = true;
568     uint256 private launchBlock;
569     uint256 private deadBlocks;
570     mapping(address => bool) public blocked;
571 
572     uint256 public buyTotalFees;
573     uint256 public buyMktgFee;
574     uint256 public buyLiquidityFee;
575     uint256 public buyDevFee;
576     uint256 public buyOperationsFee;
577 
578     uint256 public sellTotalFees;
579     uint256 public sellMktgFee;
580     uint256 public sellLiquidityFee;
581     uint256 public sellDevFee;
582     uint256 public sellOperationsFee;
583 
584     uint256 public tokensForMktg;
585     uint256 public tokensForLiquidity;
586     uint256 public tokensForDev;
587     uint256 public tokensForOperations;
588 
589     mapping(address => bool) private _isExcludedFromFees;
590     mapping(address => bool) public _isExcludedMaxTransactionAmount;
591 
592     mapping(address => bool) public automatedMarketMakerPairs;
593 
594     event UpdateUniswapV2Router(
595         address indexed newAddress,
596         address indexed oldAddress
597     );
598 
599     event ExcludeFromFees(address indexed account, bool isExcluded);
600 
601     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
602 
603     event mktgWalletUpdated(
604         address indexed newWallet,
605         address indexed oldWallet
606     );
607 
608     event devWalletUpdated(
609         address indexed newWallet,
610         address indexed oldWallet
611     );
612 
613     event liqWalletUpdated(
614         address indexed newWallet,
615         address indexed oldWallet
616     );
617 
618     event operationsWalletUpdated(
619         address indexed newWallet,
620         address indexed oldWallet
621     );
622 
623     event SwapAndLiquify(
624         uint256 tokensSwapped,
625         uint256 ethReceived,
626         uint256 tokensIntoLiquidity
627     );
628 
629     constructor() ERC20("DERP", "DERP") {
630         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(routerCA); 
631 
632         excludeFromMaxTransaction(address(_uniswapV2Router), true);
633         uniswapV2Router = _uniswapV2Router;
634 
635         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
636             .createPair(address(this), _uniswapV2Router.WETH());
637         excludeFromMaxTransaction(address(uniswapV2Pair), true);
638         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
639 
640         // launch buy fees
641         uint256 _buyMktgFee = 23;
642         uint256 _buyLiquidityFee = 0;
643         uint256 _buyDevFee = 2;
644         uint256 _buyOperationsFee = 0;
645         
646         // launch sell fees
647         uint256 _sellMktgFee = 25;
648         uint256 _sellLiquidityFee = 0;
649         uint256 _sellDevFee = 5;
650         uint256 _sellOperationsFee = 0;
651 
652         uint256 totalSupply = 1_000_000 * 1e18;
653 
654         maxTransactionAmount = 5_000 * 1e18; // 0.5% max txn
655         maxWallet = 10_000 * 1e18; // 1% max wallet
656         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
657 
658         buyMktgFee = _buyMktgFee;
659         buyLiquidityFee = _buyLiquidityFee;
660         buyDevFee = _buyDevFee;
661         buyOperationsFee = _buyOperationsFee;
662         buyTotalFees = buyMktgFee + buyLiquidityFee + buyDevFee + buyOperationsFee;
663 
664         sellMktgFee = _sellMktgFee;
665         sellLiquidityFee = _sellLiquidityFee;
666         sellDevFee = _sellDevFee;
667         sellOperationsFee = _sellOperationsFee;
668         sellTotalFees = sellMktgFee + sellLiquidityFee + sellDevFee + sellOperationsFee;
669         mktgWallet = address(0x7f21E6353c3472E2c8d74bCb8d6AdbD27a44Ab95); 
670         devWallet = address(0x7f21E6353c3472E2c8d74bCb8d6AdbD27a44Ab95); 
671         liqWallet = address(0x3C8E25Ed154cA17EAb6FB3333d2291579b1281aa); 
672         operationsWallet = address(0x7f21E6353c3472E2c8d74bCb8d6AdbD27a44Ab95);
673 
674         // exclude from paying fees or having max transaction amount
675         excludeFromFees(owner(), true);
676         excludeFromFees(address(this), true);
677         excludeFromFees(address(0xdead), true);
678 
679         excludeFromMaxTransaction(owner(), true);
680         excludeFromMaxTransaction(address(this), true);
681         excludeFromMaxTransaction(address(0xdead), true);
682 
683         _mint(msg.sender, totalSupply);
684     }
685 
686     receive() external payable {}
687 
688     function enableTrading(uint256 _deadBlocks) external onlyOwner {
689         require(!tradingActive, "Token launched");
690         tradingActive = true;
691         launchBlock = block.number;
692         swapEnabled = true;
693         deadBlocks = _deadBlocks;
694     }
695 
696     // remove limits after token is stable
697     function removeLimits() external onlyOwner returns (bool) {
698         limitsInEffect = false;
699         return true;
700     }
701 
702     // disable Transfer delay - cannot be reenabled
703     function disableTransferDelay() external onlyOwner returns (bool) {
704         transferDelayEnabled = false;
705         return true;
706     }
707 
708     // change the minimum amount of tokens to sell from fees
709     function updateSwapTokensAtAmount(uint256 newAmount)
710         external
711         onlyOwner
712         returns (bool)
713     {
714         require(
715             newAmount >= (totalSupply() * 1) / 100000,
716             "Swap amount cannot be lower than 0.001% total supply."
717         );
718         require(
719             newAmount <= (totalSupply() * 5) / 1000,
720             "Swap amount cannot be higher than 0.5% total supply."
721         );
722         swapTokensAtAmount = newAmount;
723         return true;
724     }
725 
726     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
727         require(
728             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
729             "Cannot set maxTransactionAmount lower than 0.1%"
730         );
731         maxTransactionAmount = newNum * (10**18);
732     }
733 
734     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
735         require(
736             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
737             "Cannot set maxWallet lower than 0.5%"
738         );
739         maxWallet = newNum * (10**18);
740     }
741 
742     function excludeFromMaxTransaction(address updAds, bool isEx)
743         public
744         onlyOwner
745     {
746         _isExcludedMaxTransactionAmount[updAds] = isEx;
747     }
748 
749     // only use to disable contract sales if absolutely necessary (emergency use only)
750     function updateSwapEnabled(bool enabled) external onlyOwner {
751         swapEnabled = enabled;
752     }
753 
754     function updateBuyFees(
755         uint256 _mktgFee,
756         uint256 _liquidityFee,
757         uint256 _devFee,
758         uint256 _operationsFee
759     ) external onlyOwner {
760         buyMktgFee = _mktgFee;
761         buyLiquidityFee = _liquidityFee;
762         buyDevFee = _devFee;
763         buyOperationsFee = _operationsFee;
764         buyTotalFees = buyMktgFee + buyLiquidityFee + buyDevFee + buyOperationsFee;
765         require(buyTotalFees <= 99);
766     }
767 
768     function updateSellFees(
769         uint256 _mktgFee,
770         uint256 _liquidityFee,
771         uint256 _devFee,
772         uint256 _operationsFee
773     ) external onlyOwner {
774         sellMktgFee = _mktgFee;
775         sellLiquidityFee = _liquidityFee;
776         sellDevFee = _devFee;
777         sellOperationsFee = _operationsFee;
778         sellTotalFees = sellMktgFee + sellLiquidityFee + sellDevFee + sellOperationsFee;
779         require(sellTotalFees <= 99); 
780     }
781 
782     function excludeFromFees(address account, bool excluded) public onlyOwner {
783         _isExcludedFromFees[account] = excluded;
784         emit ExcludeFromFees(account, excluded);
785     }
786 
787     function setAutomatedMarketMakerPair(address pair, bool value)
788         public
789         onlyOwner
790     {
791         require(
792             pair != uniswapV2Pair,
793             "The pair cannot be removed from automatedMarketMakerPairs"
794         );
795 
796         _setAutomatedMarketMakerPair(pair, value);
797     }
798 
799     function _setAutomatedMarketMakerPair(address pair, bool value) private {
800         automatedMarketMakerPairs[pair] = value;
801 
802         emit SetAutomatedMarketMakerPair(pair, value);
803     }
804 
805     function updatemktgWallet(address newmktgWallet) external onlyOwner {
806         emit mktgWalletUpdated(newmktgWallet, mktgWallet);
807         mktgWallet = newmktgWallet;
808     }
809 
810     function updateDevWallet(address newWallet) external onlyOwner {
811         emit devWalletUpdated(newWallet, devWallet);
812         devWallet = newWallet;
813     }
814 
815     function updateoperationsWallet(address newWallet) external onlyOwner{
816         emit operationsWalletUpdated(newWallet, operationsWallet);
817         operationsWallet = newWallet;
818     }
819 
820     function updateLiqWallet(address newLiqWallet) external onlyOwner {
821         emit liqWalletUpdated(newLiqWallet, liqWallet);
822         liqWallet = newLiqWallet;
823     }
824 
825     function isExcludedFromFees(address account) public view returns (bool) {
826         return _isExcludedFromFees[account];
827     }
828 
829     event BoughtEarly(address indexed sniper);
830 
831     function _transfer(
832         address from,
833         address to,
834         uint256 amount
835     ) internal override {
836         require(from != address(0), "ERC20: transfer from the zero address");
837         require(to != address(0), "ERC20: transfer to the zero address");
838         require(!blocked[from], "Sniper blocked");
839 
840         if (amount == 0) {
841             super._transfer(from, to, 0);
842             return;
843         }
844 
845         if (limitsInEffect) {
846             if (
847                 from != owner() &&
848                 to != owner() &&
849                 to != address(0) &&
850                 to != address(0xdead) &&
851                 !swapping
852             ) {
853                 if (!tradingActive) {
854                     require(
855                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
856                         "Trading is not active."
857                     );
858                 }
859 
860                 if(block.number <= launchBlock + deadBlocks && from == address(uniswapV2Pair) &&  
861                 to != routerCA && to != address(this) && to != address(uniswapV2Pair)){
862                     blocked[to] = true;
863                     emit BoughtEarly(to);
864                 }
865 
866                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
867                 if (transferDelayEnabled) {
868                     if (
869                         to != owner() &&
870                         to != address(uniswapV2Router) &&
871                         to != address(uniswapV2Pair)
872                     ) {
873                         require(
874                             _holderLastTransferTimestamp[tx.origin] <
875                                 block.number,
876                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
877                         );
878                         _holderLastTransferTimestamp[tx.origin] = block.number;
879                     }
880                 }
881 
882                 //when buy
883                 if (
884                     automatedMarketMakerPairs[from] &&
885                     !_isExcludedMaxTransactionAmount[to]
886                 ) {
887                     require(
888                         amount <= maxTransactionAmount,
889                         "Buy transfer amount exceeds the maxTransactionAmount."
890                     );
891                     require(
892                         amount + balanceOf(to) <= maxWallet,
893                         "Max wallet exceeded"
894                     );
895                 }
896                 //when sell
897                 else if (
898                     automatedMarketMakerPairs[to] &&
899                     !_isExcludedMaxTransactionAmount[from]
900                 ) {
901                     require(
902                         amount <= maxTransactionAmount,
903                         "Sell transfer amount exceeds the maxTransactionAmount."
904                     );
905                 } else if (!_isExcludedMaxTransactionAmount[to]) {
906                     require(
907                         amount + balanceOf(to) <= maxWallet,
908                         "Max wallet exceeded"
909                     );
910                 }
911             }
912         }
913 
914         uint256 contractTokenBalance = balanceOf(address(this));
915 
916         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
917 
918         if (
919             canSwap &&
920             swapEnabled &&
921             !swapping &&
922             !automatedMarketMakerPairs[from] &&
923             !_isExcludedFromFees[from] &&
924             !_isExcludedFromFees[to]
925         ) {
926             swapping = true;
927 
928             swapBack();
929 
930             swapping = false;
931         }
932 
933         bool takeFee = !swapping;
934 
935         // if any account belongs to _isExcludedFromFee account then remove the fee
936         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
937             takeFee = false;
938         }
939 
940         uint256 fees = 0;
941         // only take fees on buys/sells, do not take on wallet transfers
942         if (takeFee) {
943             // on sell
944             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
945                 fees = amount.mul(sellTotalFees).div(100);
946                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
947                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
948                 tokensForMktg += (fees * sellMktgFee) / sellTotalFees;
949                 tokensForOperations += (fees * sellOperationsFee) / sellTotalFees;
950             }
951             // on buy
952             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
953                 fees = amount.mul(buyTotalFees).div(100);
954                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
955                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
956                 tokensForMktg += (fees * buyMktgFee) / buyTotalFees;
957                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
958             }
959 
960             if (fees > 0) {
961                 super._transfer(from, address(this), fees);
962             }
963 
964             amount -= fees;
965         }
966 
967         super._transfer(from, to, amount);
968     }
969 
970     function swapTokensForEth(uint256 tokenAmount) private {
971         // generate the uniswap pair path of token -> weth
972         address[] memory path = new address[](2);
973         path[0] = address(this);
974         path[1] = uniswapV2Router.WETH();
975 
976         _approve(address(this), address(uniswapV2Router), tokenAmount);
977 
978         // make the swap
979         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
980             tokenAmount,
981             0, // accept any amount of ETH
982             path,
983             address(this),
984             block.timestamp
985         );
986     }
987 
988     function multiBlock(address[] calldata blockees, bool shouldBlock) external onlyOwner {
989         for(uint256 i = 0;i<blockees.length;i++){
990             address blockee = blockees[i];
991             if(blockee != address(this) && 
992                blockee != routerCA && 
993                blockee != address(uniswapV2Pair))
994                 blocked[blockee] = shouldBlock;
995         }
996     }
997 
998     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
999         // approve token transfer to cover all possible scenarios
1000         _approve(address(this), address(uniswapV2Router), tokenAmount);
1001 
1002         // add the liquidity
1003         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1004             address(this),
1005             tokenAmount,
1006             0, // slippage is unavoidable
1007             0, // slippage is unavoidable
1008             liqWallet,
1009             block.timestamp
1010         );
1011     }
1012 
1013     function swapBack() private {
1014         uint256 contractBalance = balanceOf(address(this));
1015         uint256 totalTokensToSwap = tokensForLiquidity +
1016             tokensForMktg +
1017             tokensForDev +
1018             tokensForOperations;
1019         bool success;
1020 
1021         if (contractBalance == 0 || totalTokensToSwap == 0) {
1022             return;
1023         }
1024 
1025         if (contractBalance > swapTokensAtAmount * 20) {
1026             contractBalance = swapTokensAtAmount * 20;
1027         }
1028 
1029         // Halve the amount of liquidity tokens
1030         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1031         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1032 
1033         uint256 initialETHBalance = address(this).balance;
1034 
1035         swapTokensForEth(amountToSwapForETH);
1036 
1037         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1038 
1039         uint256 ethForMktg = ethBalance.mul(tokensForMktg).div(totalTokensToSwap);
1040         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1041         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(totalTokensToSwap);
1042 
1043         uint256 ethForLiquidity = ethBalance - ethForMktg - ethForDev - ethForOperations;
1044 
1045         tokensForLiquidity = 0;
1046         tokensForMktg = 0;
1047         tokensForDev = 0;
1048         tokensForOperations = 0;
1049 
1050         (success, ) = address(devWallet).call{value: ethForDev}("");
1051 
1052         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1053             addLiquidity(liquidityTokens, ethForLiquidity);
1054             emit SwapAndLiquify(
1055                 amountToSwapForETH,
1056                 ethForLiquidity,
1057                 tokensForLiquidity
1058             );
1059         }
1060         (success, ) = address(operationsWallet).call{value: ethForOperations}("");
1061         (success, ) = address(mktgWallet).call{value: address(this).balance}("");
1062     }
1063 }