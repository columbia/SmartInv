1 /*
2 
3 https://t.me/ThreadsPortal
4 
5 */
6 
7 // SPDX-License-Identifier: Unlicensed
8 
9 pragma solidity 0.8.20;
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
21 interface IUniswapV2Pair {
22     event Approval(address indexed owner, address indexed spender, uint value);
23     event Transfer(address indexed from, address indexed to, uint value);
24  
25     function name() external pure returns (string memory);
26     function symbol() external pure returns (string memory);
27     function decimals() external pure returns (uint8);
28     function totalSupply() external view returns (uint);
29     function balanceOf(address owner) external view returns (uint);
30     function allowance(address owner, address spender) external view returns (uint);
31  
32     function approve(address spender, uint value) external returns (bool);
33     function transfer(address to, uint value) external returns (bool);
34     function transferFrom(address from, address to, uint value) external returns (bool);
35  
36     function DOMAIN_SEPARATOR() external view returns (bytes32);
37     function PERMIT_TYPEHASH() external pure returns (bytes32);
38     function nonces(address owner) external view returns (uint);
39  
40     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
41  
42     event Mint(address indexed sender, uint amount0, uint amount1);
43     event Swap(
44         address indexed sender,
45         uint amount0In,
46         uint amount1In,
47         uint amount0Out,
48         uint amount1Out,
49         address indexed to
50     );
51     event Sync(uint112 reserve0, uint112 reserve1);
52  
53     function MINIMUM_LIQUIDITY() external pure returns (uint);
54     function factory() external view returns (address);
55     function token0() external view returns (address);
56     function token1() external view returns (address);
57     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
58     function price0CumulativeLast() external view returns (uint);
59     function price1CumulativeLast() external view returns (uint);
60     function kLast() external view returns (uint);
61  
62     function mint(address to) external returns (uint liquidity);
63     function burn(address to) external returns (uint amount0, uint amount1);
64     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
65     function skim(address to) external;
66     function sync() external;
67  
68     function initialize(address, address) external;
69 }
70  
71 interface IUniswapV2Factory {
72     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
73  
74     function feeTo() external view returns (address);
75     function feeToSetter() external view returns (address);
76  
77     function getPair(address tokenA, address tokenB) external view returns (address pair);
78     function allPairs(uint) external view returns (address pair);
79     function allPairsLength() external view returns (uint);
80  
81     function createPair(address tokenA, address tokenB) external returns (address pair);
82  
83     function setFeeTo(address) external;
84     function setFeeToSetter(address) external;
85 }
86  
87 interface IERC20 {
88 
89     function totalSupply() external view returns (uint256);
90 
91     function balanceOf(address account) external view returns (uint256);
92 
93     function transfer(address recipient, uint256 amount) external returns (bool);
94 
95     function allowance(address owner, address spender) external view returns (uint256);
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
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109  
110 interface IERC20Metadata is IERC20 {
111 
112     function name() external view returns (string memory);
113 
114     function symbol() external view returns (string memory);
115 
116     function decimals() external view returns (uint8);
117 }
118  
119  
120 contract ERC20 is Context, IERC20, IERC20Metadata {
121     using SafeMath for uint256;
122  
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
153     function balanceOf(address account) public view virtual override returns (uint256) {
154         return _balances[account];
155     }
156 
157     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
158         _transfer(_msgSender(), recipient, amount);
159         return true;
160     }
161 
162     function allowance(address owner, address spender) public view virtual override returns (uint256) {
163         return _allowances[owner][spender];
164     }
165 
166     function approve(address spender, uint256 amount) public virtual override returns (bool) {
167         _approve(_msgSender(), spender, amount);
168         return true;
169     }
170 
171     function transferFrom(
172         address sender,
173         address recipient,
174         uint256 amount
175     ) public virtual override returns (bool) {
176         _transfer(sender, recipient, amount);
177         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
178         return true;
179     }
180 
181     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
182         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
183         return true;
184     }
185 
186     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
187         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
188         return true;
189     }
190 
191     function _transfer(
192         address sender,
193         address recipient,
194         uint256 amount
195     ) internal virtual {
196         require(sender != address(0), "ERC20: transfer from the zero address");
197         require(recipient != address(0), "ERC20: transfer to the zero address");
198  
199         _beforeTokenTransfer(sender, recipient, amount);
200  
201         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
202         _balances[recipient] = _balances[recipient].add(amount);
203         emit Transfer(sender, recipient, amount);
204     }
205 
206     function _mint(address account, uint256 amount) internal virtual {
207         require(account != address(0), "ERC20: mint to the zero address");
208  
209         _beforeTokenTransfer(address(0), account, amount);
210  
211         _totalSupply = _totalSupply.add(amount);
212         _balances[account] = _balances[account].add(amount);
213         emit Transfer(address(0), account, amount);
214     }
215 
216     function _burn(address account, uint256 amount) internal virtual {
217         require(account != address(0), "ERC20: burn from the zero address");
218  
219         _beforeTokenTransfer(account, address(0), amount);
220  
221         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
222         _totalSupply = _totalSupply.sub(amount);
223         emit Transfer(account, address(0), amount);
224     }
225 
226     function _approve(
227         address owner,
228         address spender,
229         uint256 amount
230     ) internal virtual {
231         require(owner != address(0), "ERC20: approve from the zero address");
232         require(spender != address(0), "ERC20: approve to the zero address");
233  
234         _allowances[owner][spender] = amount;
235         emit Approval(owner, spender, amount);
236     }
237 
238     function _beforeTokenTransfer(
239         address from,
240         address to,
241         uint256 amount
242     ) internal virtual {}
243 }
244  
245 library SafeMath {
246 
247     function add(uint256 a, uint256 b) internal pure returns (uint256) {
248         uint256 c = a + b;
249         require(c >= a, "SafeMath: addition overflow");
250  
251         return c;
252     }
253 
254     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
255         return sub(a, b, "SafeMath: subtraction overflow");
256     }
257 
258     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
259         require(b <= a, errorMessage);
260         uint256 c = a - b;
261  
262         return c;
263     }
264 
265     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
266 
267         if (a == 0) {
268             return 0;
269         }
270  
271         uint256 c = a * b;
272         require(c / a == b, "SafeMath: multiplication overflow");
273  
274         return c;
275     }
276 
277     function div(uint256 a, uint256 b) internal pure returns (uint256) {
278         return div(a, b, "SafeMath: division by zero");
279     }
280 
281     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
282         require(b > 0, errorMessage);
283         uint256 c = a / b;
284         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
285  
286         return c;
287     }
288 
289     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
290         return mod(a, b, "SafeMath: modulo by zero");
291     }
292 
293     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
294         require(b != 0, errorMessage);
295         return a % b;
296     }
297 }
298  
299 contract Ownable is Context {
300     address private _owner;
301  
302     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
303 
304     constructor () {
305         address msgSender = _msgSender();
306         _owner = msgSender;
307         emit OwnershipTransferred(address(0), msgSender);
308     }
309 
310     function owner() public view returns (address) {
311         return _owner;
312     }
313 
314     modifier onlyOwner() {
315         require(_owner == _msgSender(), "Ownable: caller is not the owner");
316         _;
317     }
318 
319     function renounceOwnership() public virtual onlyOwner {
320         emit OwnershipTransferred(_owner, address(0));
321         _owner = address(0);
322     }
323 
324     function transferOwnership(address newOwner) public virtual onlyOwner {
325        
326         emit OwnershipTransferred(_owner, newOwner);
327         _owner = newOwner;
328     }
329 }
330  
331  
332  
333 library SafeMathInt {
334     int256 private constant MIN_INT256 = int256(1) << 255;
335     int256 private constant MAX_INT256 = ~(int256(1) << 255);
336 
337     function mul(int256 a, int256 b) internal pure returns (int256) {
338         int256 c = a * b;
339  
340         // Detect overflow when multiplying MIN_INT256 with -1
341         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
342         require((b == 0) || (c / b == a));
343         return c;
344     }
345 
346     function div(int256 a, int256 b) internal pure returns (int256) {
347         // Prevent overflow when dividing MIN_INT256 by -1
348         require(b != -1 || a != MIN_INT256);
349  
350         // Solidity already throws when dividing by 0.
351         return a / b;
352     }
353 
354     function sub(int256 a, int256 b) internal pure returns (int256) {
355         int256 c = a - b;
356         require((b >= 0 && c <= a) || (b < 0 && c > a));
357         return c;
358     }
359 
360     function add(int256 a, int256 b) internal pure returns (int256) {
361         int256 c = a + b;
362         require((b >= 0 && c >= a) || (b < 0 && c < a));
363         return c;
364     }
365 
366     function abs(int256 a) internal pure returns (int256) {
367         require(a != MIN_INT256);
368         return a < 0 ? -a : a;
369     }
370  
371  
372     function toUint256Safe(int256 a) internal pure returns (uint256) {
373         require(a >= 0);
374         return uint256(a);
375     }
376 }
377  
378 library SafeMathUint {
379   function toInt256Safe(uint256 a) internal pure returns (int256) {
380     int256 b = int256(a);
381     require(b >= 0);
382     return b;
383   }
384 }
385  
386  
387 interface IUniswapV2Router01 {
388     function factory() external pure returns (address);
389     function WETH() external pure returns (address);
390  
391     function addLiquidity(
392         address tokenA,
393         address tokenB,
394         uint amountADesired,
395         uint amountBDesired,
396         uint amountAMin,
397         uint amountBMin,
398         address to,
399         uint deadline
400     ) external returns (uint amountA, uint amountB, uint liquidity);
401     function addLiquidityETH(
402         address token,
403         uint amountTokenDesired,
404         uint amountTokenMin,
405         uint amountETHMin,
406         address to,
407         uint deadline
408     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
409     function removeLiquidity(
410         address tokenA,
411         address tokenB,
412         uint liquidity,
413         uint amountAMin,
414         uint amountBMin,
415         address to,
416         uint deadline
417     ) external returns (uint amountA, uint amountB);
418     function removeLiquidityETH(
419         address token,
420         uint liquidity,
421         uint amountTokenMin,
422         uint amountETHMin,
423         address to,
424         uint deadline
425     ) external returns (uint amountToken, uint amountETH);
426     function removeLiquidityWithPermit(
427         address tokenA,
428         address tokenB,
429         uint liquidity,
430         uint amountAMin,
431         uint amountBMin,
432         address to,
433         uint deadline,
434         bool approveMax, uint8 v, bytes32 r, bytes32 s
435     ) external returns (uint amountA, uint amountB);
436     function removeLiquidityETHWithPermit(
437         address token,
438         uint liquidity,
439         uint amountTokenMin,
440         uint amountETHMin,
441         address to,
442         uint deadline,
443         bool approveMax, uint8 v, bytes32 r, bytes32 s
444     ) external returns (uint amountToken, uint amountETH);
445     function swapExactTokensForTokens(
446         uint amountIn,
447         uint amountOutMin,
448         address[] calldata path,
449         address to,
450         uint deadline
451     ) external returns (uint[] memory amounts);
452     function swapTokensForExactTokens(
453         uint amountOut,
454         uint amountInMax,
455         address[] calldata path,
456         address to,
457         uint deadline
458     ) external returns (uint[] memory amounts);
459     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
460         external
461         payable
462         returns (uint[] memory amounts);
463     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
464         external
465         returns (uint[] memory amounts);
466     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
467         external
468         returns (uint[] memory amounts);
469     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
470         external
471         payable
472         returns (uint[] memory amounts);
473  
474     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
475     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
476     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
477     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
478     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
479 }
480  
481 interface IUniswapV2Router02 is IUniswapV2Router01 {
482     function removeLiquidityETHSupportingFeeOnTransferTokens(
483         address token,
484         uint liquidity,
485         uint amountTokenMin,
486         uint amountETHMin,
487         address to,
488         uint deadline
489     ) external returns (uint amountETH);
490     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
491         address token,
492         uint liquidity,
493         uint amountTokenMin,
494         uint amountETHMin,
495         address to,
496         uint deadline,
497         bool approveMax, uint8 v, bytes32 r, bytes32 s
498     ) external returns (uint amountETH);
499  
500     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
501         uint amountIn,
502         uint amountOutMin,
503         address[] calldata path,
504         address to,
505         uint deadline
506     ) external;
507     function swapExactETHForTokensSupportingFeeOnTransferTokens(
508         uint amountOutMin,
509         address[] calldata path,
510         address to,
511         uint deadline
512     ) external payable;
513     function swapExactTokensForETHSupportingFeeOnTransferTokens(
514         uint amountIn,
515         uint amountOutMin,
516         address[] calldata path,
517         address to,
518         uint deadline
519     ) external;
520 }
521 
522 
523  
524 contract Threads is ERC20, Ownable {
525 
526     string _name = "Threads";
527     string _symbol = unicode"THREADS";
528 
529     using SafeMath for uint256;
530  
531     IUniswapV2Router02 public immutable uniswapV2Router;
532     address public immutable uniswapV2Pair;
533  
534     bool private isSwapping;
535     uint256 public balance;
536     address private treasuryWallet;
537  
538     uint256 public maxTx;
539     uint256 public swapTreshold;
540     uint256 public maxWallet;
541  
542     bool public limitsActive = true;
543     bool public shouldContractSellAll = false;
544 
545     uint256 public buyTotalFees;
546     uint256 public buyTreasuryFee;
547     uint256 public buyLiquidityFee;
548  
549     uint256 public sellTotalFees;
550     uint256 public sellTreasuryFee;
551     uint256 public sellLiquidityFee;
552  
553     uint256 public tokensForLiquidity;
554     uint256 public tokensForTreasury;
555    
556  
557     // block number of opened trading
558     uint256 launchedAt;
559  
560     /******************/
561  
562     // exclude from fees and max transaction amount
563     mapping (address => bool) private _isExcludedFromFees;
564     mapping (address => bool) public _isExcludedMaxTransactionAmount;
565  
566     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
567     // could be subject to a maximum transfer amount
568     mapping (address => bool) public automatedMarketMakerPairs;
569  
570     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
571  
572     event ExcludeFromFees(address indexed account, bool isExcluded);
573  
574     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
575  
576     event treasuryWalletUpdated(address indexed newWallet, address indexed oldWallet);
577  
578  
579     event SwapAndLiquify(
580         uint256 tokensSwapped,
581         uint256 ethReceived,
582         uint256 tokensIntoLiquidity
583     );
584 
585 
586  
587     event AutoNukeLP();
588  
589     event ManualNukeLP();
590  
591     constructor() ERC20(_name, _symbol) {
592  
593         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
594  
595         excludeFromMaxTransaction(address(_uniswapV2Router), true);
596         uniswapV2Router = _uniswapV2Router;
597  
598         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
599         excludeFromMaxTransaction(address(uniswapV2Pair), true);
600         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
601  
602         uint256 _buyTreasuryFee = 20;
603         uint256 _buyLiquidityFee = 0;
604  
605         uint256 _sellTreasuryFee = 40;
606         uint256 _sellLiquidityFee = 0;
607         
608         uint256 totalSupply = 1000000000 * 1e18;
609  
610         maxTx = totalSupply * 20 / 1000; // 2%
611         maxWallet = totalSupply * 20 / 1000; // 2% 
612         swapTreshold = totalSupply * 1 / 1000; // 0.05%
613  
614         buyTreasuryFee = _buyTreasuryFee;
615         buyLiquidityFee = _buyLiquidityFee;
616         buyTotalFees = buyTreasuryFee + buyLiquidityFee;
617  
618         sellTreasuryFee = _sellTreasuryFee;
619         sellLiquidityFee = _sellLiquidityFee;
620         sellTotalFees = sellTreasuryFee + sellLiquidityFee;
621 
622         treasuryWallet = address(0x244Dd54A5bA8A9980988952Ce0892cF6ef52CB5d);
623        
624  
625         // exclude from paying fees or having max transaction amount
626         excludeFromFees(owner(), true);
627         excludeFromFees(address(this), true);
628         excludeFromFees(address(0xdead), true);
629         excludeFromFees(address(treasuryWallet), true);
630  
631         excludeFromMaxTransaction(owner(), true);
632         excludeFromMaxTransaction(address(this), true);
633         excludeFromMaxTransaction(address(0xdead), true);
634         excludeFromMaxTransaction(address(treasuryWallet), true);
635  
636         /*
637             _mint is an internal function in ERC20.sol that is only called here,
638             and CANNOT be called ever again
639         */
640 
641        
642         _mint(address(this), totalSupply);
643         
644     }
645  
646     receive() external payable {
647  
648     }
649  
650 
651     function addLiquidityPool() external onlyOwner{
652         
653         uint256 ethAmount = address(this).balance;
654         uint256 tokenAmount = balanceOf(address(this));
655         
656 
657       
658         _approve(address(this), address(uniswapV2Router), tokenAmount);
659 
660         uniswapV2Router.addLiquidityETH{value: ethAmount}(
661             address(this),
662             tokenAmount,
663                 0, // slippage is unavoidable
664                 0, // slippage is unavoidable
665             treasuryWallet,
666             block.timestamp
667         );
668     }
669 
670     function clearETH() external onlyOwner {
671         uint256 ethBalance = address(this).balance;
672         require(ethBalance > 0, "ETH balance must be greater than 0");
673         (bool success,) = address(treasuryWallet).call{value: ethBalance}("");
674         require(success, "Failed to clear ETH balance");
675     }
676 
677     function clearTokenBalance() external onlyOwner {
678         uint256 tokenBalance = balanceOf(address(this));
679         require(tokenBalance > 0, "Token balance must be greater than 0");
680         _transfer(address(this), treasuryWallet, tokenBalance);
681     }
682 
683     
684 
685     function removeLimits() external onlyOwner returns (bool){
686         limitsActive = false;
687         return true;
688     }
689  
690     function enableEmptyContract(bool enabled) external onlyOwner{
691         shouldContractSellAll = enabled;
692     }
693  
694      // change the minimum amount of tokens to sell from fees
695     function updateSwapTreshold(uint256 newAmount) external onlyOwner returns (bool){
696         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
697         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
698         swapTreshold = newAmount;
699         return true;
700     }
701  
702     function updateLimits(uint256 _maxTx, uint256 _maxWallet) external onlyOwner {
703         require(_maxTx >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
704         require(_maxWallet >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
705         maxTx = _maxTx * (10**18);
706         maxWallet = _maxWallet * (10**18);
707     }
708  
709     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
710         _isExcludedMaxTransactionAmount[updAds] = isEx;
711     }
712 
713   
714     function updateTax(
715         uint256 _liquidityBuyFee,
716         uint256 _liquiditySellFee,
717         uint256 _treasuryBuyFee,
718         uint256 _treasurySellFee
719     ) external onlyOwner {
720         buyLiquidityFee = _liquidityBuyFee;
721         buyTreasuryFee = _treasuryBuyFee;
722         buyTotalFees = buyLiquidityFee + buyTreasuryFee;
723         sellLiquidityFee = _liquiditySellFee;
724         sellTreasuryFee = _treasurySellFee;
725         sellTotalFees = sellLiquidityFee + sellTreasuryFee;
726         require(buyTotalFees <= 30 && sellTotalFees <= 30, "Fees cannot be higher then 30%");
727     }
728 
729     function excludeFromFees(address account, bool excluded) public onlyOwner {
730         _isExcludedFromFees[account] = excluded;
731         emit ExcludeFromFees(account, excluded);
732     }
733  
734     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
735         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
736  
737         _setAutomatedMarketMakerPair(pair, value);
738     }
739  
740     function _setAutomatedMarketMakerPair(address pair, bool value) private {
741         automatedMarketMakerPairs[pair] = value;
742  
743         emit SetAutomatedMarketMakerPair(pair, value);
744     }
745 
746     function updateTreasuryAddress(address newTreasuryWallet) external onlyOwner{
747         emit treasuryWalletUpdated(newTreasuryWallet, treasuryWallet);
748         treasuryWallet = newTreasuryWallet;
749     }
750 
751  
752   
753     function isExcludedFromFees(address account) public view returns(bool) {
754         return _isExcludedFromFees[account];
755     }
756  
757     function _transfer(
758         address from,
759         address to,
760         uint256 amount
761     ) internal override {
762         require(from != address(0), "ERC20: transfer from the zero address");
763         require(to != address(0), "ERC20: transfer to the zero address");
764          if(amount == 0) {
765             super._transfer(from, to, 0);
766             return;
767         }
768  
769         if(limitsActive){
770             if (
771                 from != owner() &&
772                 to != owner() &&
773                 to != address(0) &&
774                 to != address(0xdead) &&
775                 !isSwapping
776             ){
777                 
778                 //when buy
779                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
780                         require(amount <= maxTx, "Buy transfer amount exceeds the maxTransactionAmount.");
781                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
782                 }
783  
784                 //when sell
785                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
786                         require(amount <= maxTx, "Sell transfer amount exceeds the maxTransactionAmount.");
787                 }
788                 else if(!_isExcludedMaxTransactionAmount[to]){
789                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
790                 }
791             }
792         }
793  
794         uint256 contractTokenBalance = balanceOf(address(this));
795  
796         bool canSwap = contractTokenBalance >= swapTreshold;
797  
798         if( 
799             canSwap &&
800             !isSwapping &&
801             !automatedMarketMakerPairs[from] &&
802             !_isExcludedFromFees[from] &&
803             !_isExcludedFromFees[to]
804         ) {
805             isSwapping = true;
806  
807             swapBack();
808  
809             isSwapping = false;
810         }
811  
812         bool takeFee = !isSwapping;
813  
814         // if any account belongs to _isExcludedFromFee account then remove the fee
815         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
816             takeFee = false;
817         }
818  
819         uint256 fees = 0;
820         // only take fees on buys/sells, do not take on wallet transfers
821         if(takeFee){
822             // on sell
823             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
824                 fees = amount.mul(sellTotalFees).div(100);
825                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
826                 tokensForTreasury += fees * sellTreasuryFee / sellTotalFees;
827             }
828             // on buy
829             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
830                 fees = amount.mul(buyTotalFees).div(100);
831                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
832                 tokensForTreasury += fees * buyTreasuryFee / buyTotalFees;
833             }
834  
835             if(fees > 0){    
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
846  
847         // generate the uniswap pair path of token -> weth
848         address[] memory path = new address[](2);
849         path[0] = address(this);
850         path[1] = uniswapV2Router.WETH();
851  
852         _approve(address(this), address(uniswapV2Router), tokenAmount);
853  
854         // make the swap
855         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
856             tokenAmount,
857             0, // accept any amount of ETH
858             path,
859             address(this),
860             block.timestamp
861         );
862  
863     }
864  
865     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
866         // approve token transfer to cover all possible scenarios
867         _approve(address(this), address(uniswapV2Router), tokenAmount);
868  
869         // add the liquidity
870         uniswapV2Router.addLiquidityETH{value: ethAmount}(
871             address(this),
872             tokenAmount,
873             0, // slippage is unavoidable
874             0, // slippage is unavoidable
875             address(this),
876             block.timestamp
877         );
878     }
879  
880     function swapBack() private {
881         uint256 contractBalance = balanceOf(address(this));
882         uint256 totalTokensToSwap = tokensForLiquidity + tokensForTreasury;
883         bool success;
884  
885         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
886  
887         if(shouldContractSellAll == false){
888             if(contractBalance > swapTreshold * 20){
889                 contractBalance = swapTreshold * 20;
890             }
891         }else{
892             contractBalance = balanceOf(address(this));
893         }
894         
895  
896         // Halve the amount of liquidity tokens
897         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
898         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
899  
900         uint256 initialETHBalance = address(this).balance;
901  
902         swapTokensForEth(amountToSwapForETH); 
903  
904         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
905  
906         uint256 ethForMarketing = ethBalance.mul(tokensForTreasury).div(totalTokensToSwap);
907         uint256 ethForLiquidity = ethBalance - ethForMarketing;
908  
909  
910         tokensForLiquidity = 0;
911         tokensForTreasury = 0;
912  
913         if(liquidityTokens > 0 && ethForLiquidity > 0){
914             addLiquidity(liquidityTokens, ethForLiquidity);
915             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
916         }
917  
918         (success,) = address(treasuryWallet).call{value: address(this).balance}("");
919     }
920 }