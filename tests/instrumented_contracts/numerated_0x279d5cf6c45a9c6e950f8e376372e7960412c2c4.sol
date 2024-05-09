1 // File: erc-20.sol
2 
3 /**
4 */
5 
6 pragma solidity ^0.8.10;
7 pragma experimental ABIEncoderV2;
8 
9 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
10 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
11 
12 /* pragma solidity ^0.8.0; */
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
24 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
25 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
26 
27 /* pragma solidity ^0.8.0; */
28 
29 /* import "../utils/Context.sol"; */
30 
31 
32 abstract contract Ownable is Context {
33     address private _owner;
34 
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     constructor() {
38         _transferOwnership(_msgSender());
39     }
40 
41     function owner() public view virtual returns (address) {
42         return _owner;
43     }
44 
45     modifier onlyOwner() {
46         require(owner() == _msgSender(), "Ownable: caller is not the owner");
47         _;
48     }
49 
50     
51     function renounceOwnership() public virtual onlyOwner {
52         _transferOwnership(address(0));
53     }
54 
55    
56     function transferOwnership(address newOwner) public virtual onlyOwner {
57         require(newOwner != address(0), "Ownable: new owner is the zero address");
58         _transferOwnership(newOwner);
59     }
60 
61     
62     function _transferOwnership(address newOwner) internal virtual {
63         address oldOwner = _owner;
64         _owner = newOwner;
65         emit OwnershipTransferred(oldOwner, newOwner);
66     }
67 }
68 
69 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
70 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
71 
72 /* pragma solidity ^0.8.0; */
73 
74 interface IERC20 {
75    
76     function totalSupply() external view returns (uint256);
77 
78     
79     function balanceOf(address account) external view returns (uint256);
80 
81    
82     function transfer(address recipient, uint256 amount) external returns (bool);
83 
84    
85     function allowance(address owner, address spender) external view returns (uint256);
86 
87     
88     function approve(address spender, uint256 amount) external returns (bool);
89 
90    
91     function transferFrom(
92         address sender,
93         address recipient,
94         uint256 amount
95     ) external returns (bool);
96 
97    
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 
100    
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
105 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
106 
107 /* pragma solidity ^0.8.0; */
108 
109 /* import "../IERC20.sol"; */
110 
111 
112 interface IERC20Metadata is IERC20 {
113    
114     function name() external view returns (string memory);
115 
116     function symbol() external view returns (string memory);
117 
118     function decimals() external view returns (uint8);
119 }
120 
121 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
122 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
123 
124 /* pragma solidity ^0.8.0; */
125 
126 /* import "./IERC20.sol"; */
127 /* import "./extensions/IERC20Metadata.sol"; */
128 /* import "../../utils/Context.sol"; */
129 
130 
131 contract ERC20 is Context, IERC20, IERC20Metadata {
132     mapping(address => uint256) private _balances;
133 
134     mapping(address => mapping(address => uint256)) private _allowances;
135 
136     uint256 private _totalSupply;
137 
138     string private _name;
139     string private _symbol;
140 
141     constructor(string memory name_, string memory symbol_) {
142         _name = name_;
143         _symbol = symbol_;
144     }
145 
146     function name() public view virtual override returns (string memory) {
147         return _name;
148     }
149 
150     function symbol() public view virtual override returns (string memory) {
151         return _symbol;
152     }
153 
154     function decimals() public view virtual override returns (uint8) {
155         return 18;
156     }
157 
158     function totalSupply() public view virtual override returns (uint256) {
159         return _totalSupply;
160     }
161 
162     function balanceOf(address account) public view virtual override returns (uint256) {
163         return _balances[account];
164     }
165 
166     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
167         _transfer(_msgSender(), recipient, amount);
168         return true;
169     }
170 
171     function allowance(address owner, address spender) public view virtual override returns (uint256) {
172         return _allowances[owner][spender];
173     }
174 
175     function approve(address spender, uint256 amount) public virtual override returns (bool) {
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
188         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
189         unchecked {
190             _approve(sender, _msgSender(), currentAllowance - amount);
191         }
192 
193         return true;
194     }
195 
196     function _transfer(
197         address sender,
198         address recipient,
199         uint256 amount
200     ) internal virtual {
201         require(sender != address(0), "ERC20: transfer from the zero address");
202         require(recipient != address(0), "ERC20: transfer to the zero address");
203 
204         _beforeTokenTransfer(sender, recipient, amount);
205 
206         uint256 senderBalance = _balances[sender];
207         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
208         unchecked {
209             _balances[sender] = senderBalance - amount;
210         }
211         _balances[recipient] += amount;
212 
213         emit Transfer(sender, recipient, amount);
214 
215         _afterTokenTransfer(sender, recipient, amount);
216     }
217 
218     function _mint(address account, uint256 amount) internal virtual {
219         require(account != address(0), "ERC20: mint to the zero address");
220 
221         _beforeTokenTransfer(address(0), account, amount);
222 
223         _totalSupply += amount;
224         _balances[account] += amount;
225         emit Transfer(address(0), account, amount);
226 
227         _afterTokenTransfer(address(0), account, amount);
228     }
229 
230     function _approve(
231         address owner,
232         address spender,
233         uint256 amount
234     ) internal virtual {
235         require(owner != address(0), "ERC20: approve from the zero address");
236         require(spender != address(0), "ERC20: approve to the zero address");
237 
238         _allowances[owner][spender] = amount;
239         emit Approval(owner, spender, amount);
240     }
241 
242     function _beforeTokenTransfer(
243         address from,
244         address to,
245         uint256 amount
246     ) internal virtual {}
247 
248     function _afterTokenTransfer(
249         address from,
250         address to,
251         uint256 amount
252     ) internal virtual {}
253 }
254 
255 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
256 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
257 
258 /* pragma solidity ^0.8.0; */
259 
260 // CAUTION
261 // This version of SafeMath should only be used with Solidity 0.8 or later,
262 // because it relies on the compiler's built in overflow checks.
263 
264 library SafeMath {
265     /**
266      * @dev Returns the addition of two unsigned integers, with an overflow flag.
267      *
268      * _Available since v3.4._
269      */
270     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
271         unchecked {
272             uint256 c = a + b;
273             if (c < a) return (false, 0);
274             return (true, c);
275         }
276     }
277 
278     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
279         unchecked {
280             if (b > a) return (false, 0);
281             return (true, a - b);
282         }
283     }
284 
285     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
286         unchecked {
287             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
288             // benefit is lost if 'b' is also tested.
289             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
290             if (a == 0) return (true, 0);
291             uint256 c = a * b;
292             if (c / a != b) return (false, 0);
293             return (true, c);
294         }
295     }
296 
297     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
298         unchecked {
299             if (b == 0) return (false, 0);
300             return (true, a / b);
301         }
302     }
303 
304     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
305         unchecked {
306             if (b == 0) return (false, 0);
307             return (true, a % b);
308         }
309     }
310 
311     function add(uint256 a, uint256 b) internal pure returns (uint256) {
312         return a + b;
313     }
314 
315     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
316         return a - b;
317     }
318 
319     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
320         return a * b;
321     }
322 
323     function div(uint256 a, uint256 b) internal pure returns (uint256) {
324         return a / b;
325     }
326 
327     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
328         return a % b;
329     }
330 
331     function sub(
332         uint256 a,
333         uint256 b,
334         string memory errorMessage
335     ) internal pure returns (uint256) {
336         unchecked {
337             require(b <= a, errorMessage);
338             return a - b;
339         }
340     }
341 
342     function div(
343         uint256 a,
344         uint256 b,
345         string memory errorMessage
346     ) internal pure returns (uint256) {
347         unchecked {
348             require(b > 0, errorMessage);
349             return a / b;
350         }
351     }
352 
353     function mod(
354         uint256 a,
355         uint256 b,
356         string memory errorMessage
357     ) internal pure returns (uint256) {
358         unchecked {
359             require(b > 0, errorMessage);
360             return a % b;
361         }
362     }
363 }
364 
365 interface IUniswapV2Factory {
366     event PairCreated(
367         address indexed token0,
368         address indexed token1,
369         address pair,
370         uint256
371     );
372 
373     function createPair(address tokenA, address tokenB)
374         external
375         returns (address pair);
376 }
377 
378 interface IUniswapV2Router02 {
379     function factory() external pure returns (address);
380 
381     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
382         uint256 amountIn,
383         uint256 amountOutMin,
384         address[] calldata path,
385         address to,
386         uint256 deadline
387     ) external;
388 }
389 
390 contract inure is ERC20, Ownable {
391     using SafeMath for uint256;
392 
393     IUniswapV2Router02 public immutable uniswapV2Router;
394     address public immutable uniswapV2Pair;
395     address public constant deadAddress = address(0xdead);
396     address public DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
397 
398     bool private swapping;
399 
400     address public devWallet;
401 
402     uint256 public maxTransactionAmount;
403     uint256 public swapTokensAtAmount;
404     uint256 public maxWallet;
405 
406     bool public limitsInEffect = true;
407     bool public tradingActive = false;
408     bool public swapEnabled = false;
409 
410     uint256 public buyTotalFees;
411     uint256 public buyDevFee;
412     uint256 public buyLiquidityFee;
413 
414     uint256 public sellTotalFees;
415     uint256 public sellDevFee;
416     uint256 public sellLiquidityFee;
417 
418     /******************/
419 
420     // exlcude from fees and max transaction amount
421     mapping(address => bool) private _isExcludedFromFees;
422     mapping(address => bool) public _isExcludedMaxTransactionAmount;
423 
424 
425     event ExcludeFromFees(address indexed account, bool isExcluded);
426 
427     event devWalletUpdated(
428         address indexed newWallet,
429         address indexed oldWallet
430     );
431 
432     constructor() ERC20("Inure", "i") {
433         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
434             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
435         );
436 
437         excludeFromMaxTransaction(address(_uniswapV2Router), true);
438         uniswapV2Router = _uniswapV2Router;
439 
440         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
441             .createPair(address(this), DAI);
442         excludeFromMaxTransaction(address(uniswapV2Pair), true);
443 
444 
445         uint256 _buyDevFee = 1;
446         uint256 _buyLiquidityFee = 0;
447 
448         uint256 _sellDevFee = 1;
449         uint256 _sellLiquidityFee = 0;
450 
451         uint256 totalSupply = 100_000_000_000 * 1e18;
452 
453         maxTransactionAmount =  totalSupply * 2 / 100; // 2% from total supply maxTransactionAmountTxn
454         maxWallet = totalSupply * 2 / 100; // 2% from total supply maxWallet
455         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
456 
457         buyDevFee = _buyDevFee;
458         buyLiquidityFee = _buyLiquidityFee;
459         buyTotalFees = buyDevFee + buyLiquidityFee;
460 
461         sellDevFee = _sellDevFee;
462         sellLiquidityFee = _sellLiquidityFee;
463         sellTotalFees = sellDevFee + sellLiquidityFee;
464 
465         devWallet = address(0xa6455CeB9ADf998d2A23669feE2d45b2Df11d592); // set as dev wallet
466 
467         // exclude from paying fees or having max transaction amount
468         excludeFromFees(owner(), true);
469         excludeFromFees(address(this), true);
470         excludeFromFees(address(0xdead), true);
471 
472         excludeFromMaxTransaction(owner(), true);
473         excludeFromMaxTransaction(address(this), true);
474         excludeFromMaxTransaction(address(0xdead), true);
475 
476         _mint(msg.sender, totalSupply);
477     }
478 
479     receive() external payable {}
480 
481     // once enabled, can NEVER be turned off
482     function enableTrading() external onlyOwner {
483         tradingActive = true;
484         swapEnabled = true;
485     }
486 
487     // remove limits 
488     function removeLimits() external onlyOwner returns (bool) {
489         limitsInEffect = false;
490         return true;
491     }
492 
493     // change the minimum amount of tokens to sell from fees
494     function updateSwapTokensAtAmount(uint256 newAmount)
495         external
496         onlyOwner
497         returns (bool)
498     {
499         require(
500             newAmount >= (totalSupply() * 1) / 100000,
501             "Swap amount cannot be lower than 0.001% total supply."
502         );
503         require(
504             newAmount <= (totalSupply() * 5) / 1000,
505             "Swap amount cannot be higher than 0.5% total supply."
506         );
507         swapTokensAtAmount = newAmount;
508         return true;
509     }
510 
511     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
512         require(
513             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
514             "Cannot set maxTransactionAmount lower than 0.1%"
515         );
516         maxTransactionAmount = newNum * (10**18);
517     }
518 
519     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
520         require(
521             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
522             "Cannot set maxWallet lower than 0.5%"
523         );
524         maxWallet = newNum * (10**18);
525     }
526 
527     function excludeFromMaxTransaction(address updAds, bool isEx)
528         public
529         onlyOwner
530     {
531         _isExcludedMaxTransactionAmount[updAds] = isEx;
532     }
533 
534     // only use to disable contract sales if absolutely necessary (emergency use only)
535     function updateSwapEnabled(bool enabled) external onlyOwner {
536         swapEnabled = enabled;
537     }
538 
539     function updateBuyFees(
540         uint256 _devFee,
541         uint256 _liquidityFee
542     ) external onlyOwner {
543         buyDevFee = _devFee;
544         buyLiquidityFee = _liquidityFee;
545         buyTotalFees = buyDevFee + buyLiquidityFee;
546         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
547     }
548 
549     function updateSellFees(
550         uint256 _devFee,
551         uint256 _liquidityFee
552     ) external onlyOwner {
553         sellDevFee = _devFee;
554         sellLiquidityFee = _liquidityFee;
555         sellTotalFees = sellDevFee + sellLiquidityFee;
556         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
557     }
558 
559     function excludeFromFees(address account, bool excluded) public onlyOwner {
560         _isExcludedFromFees[account] = excluded;
561         emit ExcludeFromFees(account, excluded);
562     }
563 
564     function updateDevWallet(address newDevWallet)
565         external
566         onlyOwner
567     {
568         emit devWalletUpdated(newDevWallet, devWallet);
569         devWallet = newDevWallet;
570     }
571 
572 
573     function isExcludedFromFees(address account) public view returns (bool) {
574         return _isExcludedFromFees[account];
575     }
576 
577     function _transfer(
578         address from,
579         address to,
580         uint256 amount
581     ) internal override {
582         require(from != address(0), "ERC20: transfer from the zero address");
583         require(to != address(0), "ERC20: transfer to the zero address");
584 
585         if (amount == 0) {
586             super._transfer(from, to, 0);
587             return;
588         }
589 
590         if (limitsInEffect) {
591             if (
592                 from != owner() &&
593                 to != owner() &&
594                 to != address(0) &&
595                 to != address(0xdead) &&
596                 !swapping
597             ) {
598                 if (!tradingActive) {
599                     require(
600                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
601                         "Trading is not active."
602                     );
603                 }
604 
605                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
606                 //when buy
607                 if (
608                     from == uniswapV2Pair &&
609                     !_isExcludedMaxTransactionAmount[to]
610                 ) {
611                     require(
612                         amount <= maxTransactionAmount,
613                         "Buy transfer amount exceeds the maxTransactionAmount."
614                     );
615                     require(
616                         amount + balanceOf(to) <= maxWallet,
617                         "Max wallet exceeded"
618                     );
619                 }
620                 else if (!_isExcludedMaxTransactionAmount[to]) {
621                     require(
622                         amount + balanceOf(to) <= maxWallet,
623                         "Max wallet exceeded"
624                     );
625                 }
626             }
627         }
628 
629         uint256 contractTokenBalance = balanceOf(address(this));
630 
631         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
632 
633         if (
634             canSwap &&
635             swapEnabled &&
636             !swapping &&
637             to == uniswapV2Pair &&
638             !_isExcludedFromFees[from] &&
639             !_isExcludedFromFees[to]
640         ) {
641             swapping = true;
642 
643             swapBack();
644 
645             swapping = false;
646         }
647 
648         bool takeFee = !swapping;
649 
650         // if any account belongs to _isExcludedFromFee account then remove the fee
651         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
652             takeFee = false;
653         }
654 
655         uint256 fees = 0;
656         uint256 tokensForLiquidity = 0;
657         uint256 tokensForDev = 0;
658         // only take fees on buys/sells, do not take on wallet transfers
659         if (takeFee) {
660             // on sell
661             if (to == uniswapV2Pair && sellTotalFees > 0) {
662                 fees = amount.mul(sellTotalFees).div(100);
663                 tokensForLiquidity = (fees * sellLiquidityFee) / sellTotalFees;
664                 tokensForDev = (fees * sellDevFee) / sellTotalFees;
665             }
666             // on buy
667             else if (from == uniswapV2Pair && buyTotalFees > 0) {
668                 fees = amount.mul(buyTotalFees).div(100);
669                 tokensForLiquidity = (fees * buyLiquidityFee) / buyTotalFees; 
670                 tokensForDev = (fees * buyDevFee) / buyTotalFees;
671             }
672 
673             if (fees> 0) {
674                 super._transfer(from, address(this), fees);
675             }
676             if (tokensForLiquidity > 0) {
677                 super._transfer(address(this), uniswapV2Pair, tokensForLiquidity);
678             }
679 
680             amount -= fees;
681         }
682 
683         super._transfer(from, to, amount);
684     }
685 
686     function swapTokensForDAI(uint256 tokenAmount) private {
687         // generate the uniswap pair path of token -> weth
688         address[] memory path = new address[](2);
689         path[0] = address(this);
690         path[1] = DAI;
691 
692         _approve(address(this), address(uniswapV2Router), tokenAmount);
693 
694         // make the swap
695         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
696             tokenAmount,
697             0, // accept any amount of DAI
698             path,
699             devWallet,
700             block.timestamp
701         );
702     }
703 
704     function swapBack() private {
705         uint256 contractBalance = balanceOf(address(this));
706         if (contractBalance == 0) {
707             return;
708         }
709 
710         if (contractBalance > swapTokensAtAmount * 20) {
711             contractBalance = swapTokensAtAmount * 20;
712         }
713 
714         swapTokensForDAI(contractBalance);
715     }
716 
717 }