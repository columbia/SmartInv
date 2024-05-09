1 /*
2 
3 https://t.me/AraAraPortal
4 https://twitter.com/AraAraCoin
5 https://araara.lol/
6 
7 */
8 
9 
10 // SPDX-License-Identifier: Unlicensed
11 
12 pragma solidity 0.8.20;
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
24 interface IUniswapV2Pair {
25     event Approval(address indexed owner, address indexed spender, uint value);
26     event Transfer(address indexed from, address indexed to, uint value);
27  
28     function name() external pure returns (string memory);
29     function symbol() external pure returns (string memory);
30     function decimals() external pure returns (uint8);
31     function totalSupply() external view returns (uint);
32     function balanceOf(address owner) external view returns (uint);
33     function allowance(address owner, address spender) external view returns (uint);
34  
35     function approve(address spender, uint value) external returns (bool);
36     function transfer(address to, uint value) external returns (bool);
37     function transferFrom(address from, address to, uint value) external returns (bool);
38  
39     function DOMAIN_SEPARATOR() external view returns (bytes32);
40     function PERMIT_TYPEHASH() external pure returns (bytes32);
41     function nonces(address owner) external view returns (uint);
42  
43     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
44  
45     event Mint(address indexed sender, uint amount0, uint amount1);
46     event Swap(
47         address indexed sender,
48         uint amount0In,
49         uint amount1In,
50         uint amount0Out,
51         uint amount1Out,
52         address indexed to
53     );
54     event Sync(uint112 reserve0, uint112 reserve1);
55  
56     function MINIMUM_LIQUIDITY() external pure returns (uint);
57     function factory() external view returns (address);
58     function token0() external view returns (address);
59     function token1() external view returns (address);
60     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
61     function price0CumulativeLast() external view returns (uint);
62     function price1CumulativeLast() external view returns (uint);
63     function kLast() external view returns (uint);
64  
65     function mint(address to) external returns (uint liquidity);
66     function burn(address to) external returns (uint amount0, uint amount1);
67     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
68     function skim(address to) external;
69     function sync() external;
70  
71     function initialize(address, address) external;
72 }
73  
74 interface IUniswapV2Factory {
75     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
76  
77     function feeTo() external view returns (address);
78     function feeToSetter() external view returns (address);
79  
80     function getPair(address tokenA, address tokenB) external view returns (address pair);
81     function allPairs(uint) external view returns (address pair);
82     function allPairsLength() external view returns (uint);
83  
84     function createPair(address tokenA, address tokenB) external returns (address pair);
85  
86     function setFeeTo(address) external;
87     function setFeeToSetter(address) external;
88 }
89  
90 interface IERC20 {
91 
92     function totalSupply() external view returns (uint256);
93 
94     function balanceOf(address account) external view returns (uint256);
95 
96     function transfer(address recipient, uint256 amount) external returns (bool);
97 
98     function allowance(address owner, address spender) external view returns (uint256);
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
110     event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112  
113 interface IERC20Metadata is IERC20 {
114 
115     function name() external view returns (string memory);
116 
117     function symbol() external view returns (string memory);
118 
119     function decimals() external view returns (uint8);
120 }
121  
122  
123 contract ERC20 is Context, IERC20, IERC20Metadata {
124     using SafeMath for uint256;
125  
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
149         return 18;
150     }
151 
152     function totalSupply() public view virtual override returns (uint256) {
153         return _totalSupply;
154     }
155 
156     function balanceOf(address account) public view virtual override returns (uint256) {
157         return _balances[account];
158     }
159 
160     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
161         _transfer(_msgSender(), recipient, amount);
162         return true;
163     }
164 
165     function allowance(address owner, address spender) public view virtual override returns (uint256) {
166         return _allowances[owner][spender];
167     }
168 
169     function approve(address spender, uint256 amount) public virtual override returns (bool) {
170         _approve(_msgSender(), spender, amount);
171         return true;
172     }
173 
174     function transferFrom(
175         address sender,
176         address recipient,
177         uint256 amount
178     ) public virtual override returns (bool) {
179         _transfer(sender, recipient, amount);
180         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
181         return true;
182     }
183 
184     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
185         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
186         return true;
187     }
188 
189     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
190         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
191         return true;
192     }
193 
194     function _transfer(
195         address sender,
196         address recipient,
197         uint256 amount
198     ) internal virtual {
199         require(sender != address(0), "ERC20: transfer from the zero address");
200         require(recipient != address(0), "ERC20: transfer to the zero address");
201  
202         _beforeTokenTransfer(sender, recipient, amount);
203  
204         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
205         _balances[recipient] = _balances[recipient].add(amount);
206         emit Transfer(sender, recipient, amount);
207     }
208 
209     function _mint(address account, uint256 amount) internal virtual {
210         require(account != address(0), "ERC20: mint to the zero address");
211  
212         _beforeTokenTransfer(address(0), account, amount);
213  
214         _totalSupply = _totalSupply.add(amount);
215         _balances[account] = _balances[account].add(amount);
216         emit Transfer(address(0), account, amount);
217     }
218 
219     function _burn(address account, uint256 amount) internal virtual {
220         require(account != address(0), "ERC20: burn from the zero address");
221  
222         _beforeTokenTransfer(account, address(0), amount);
223  
224         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
225         _totalSupply = _totalSupply.sub(amount);
226         emit Transfer(account, address(0), amount);
227     }
228 
229     function _approve(
230         address owner,
231         address spender,
232         uint256 amount
233     ) internal virtual {
234         require(owner != address(0), "ERC20: approve from the zero address");
235         require(spender != address(0), "ERC20: approve to the zero address");
236  
237         _allowances[owner][spender] = amount;
238         emit Approval(owner, spender, amount);
239     }
240 
241     function _beforeTokenTransfer(
242         address from,
243         address to,
244         uint256 amount
245     ) internal virtual {}
246 }
247  
248 library SafeMath {
249 
250     function add(uint256 a, uint256 b) internal pure returns (uint256) {
251         uint256 c = a + b;
252         require(c >= a, "SafeMath: addition overflow");
253  
254         return c;
255     }
256 
257     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
258         return sub(a, b, "SafeMath: subtraction overflow");
259     }
260 
261     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
262         require(b <= a, errorMessage);
263         uint256 c = a - b;
264  
265         return c;
266     }
267 
268     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
269 
270         if (a == 0) {
271             return 0;
272         }
273  
274         uint256 c = a * b;
275         require(c / a == b, "SafeMath: multiplication overflow");
276  
277         return c;
278     }
279 
280     function div(uint256 a, uint256 b) internal pure returns (uint256) {
281         return div(a, b, "SafeMath: division by zero");
282     }
283 
284     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
285         require(b > 0, errorMessage);
286         uint256 c = a / b;
287         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
288  
289         return c;
290     }
291 
292     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
293         return mod(a, b, "SafeMath: modulo by zero");
294     }
295 
296     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
297         require(b != 0, errorMessage);
298         return a % b;
299     }
300 }
301  
302 contract Ownable is Context {
303     address private _owner;
304  
305     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
306 
307     constructor () {
308         address msgSender = _msgSender();
309         _owner = msgSender;
310         emit OwnershipTransferred(address(0), msgSender);
311     }
312 
313     function owner() public view returns (address) {
314         return _owner;
315     }
316 
317     modifier onlyOwner() {
318         require(_owner == _msgSender(), "Ownable: caller is not the owner");
319         _;
320     }
321 
322     function renounceOwnership() public virtual onlyOwner {
323         emit OwnershipTransferred(_owner, address(0));
324         _owner = address(0);
325     }
326 
327     function transferOwnership(address newOwner) public virtual onlyOwner {
328         require(newOwner != address(0), "Ownable: new owner is the zero address");
329         emit OwnershipTransferred(_owner, newOwner);
330         _owner = newOwner;
331     }
332 }
333  
334  
335  
336 library SafeMathInt {
337     int256 private constant MIN_INT256 = int256(1) << 255;
338     int256 private constant MAX_INT256 = ~(int256(1) << 255);
339 
340     function mul(int256 a, int256 b) internal pure returns (int256) {
341         int256 c = a * b;
342  
343         // Detect overflow when multiplying MIN_INT256 with -1
344         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
345         require((b == 0) || (c / b == a));
346         return c;
347     }
348 
349     function div(int256 a, int256 b) internal pure returns (int256) {
350         // Prevent overflow when dividing MIN_INT256 by -1
351         require(b != -1 || a != MIN_INT256);
352  
353         // Solidity already throws when dividing by 0.
354         return a / b;
355     }
356 
357     function sub(int256 a, int256 b) internal pure returns (int256) {
358         int256 c = a - b;
359         require((b >= 0 && c <= a) || (b < 0 && c > a));
360         return c;
361     }
362 
363     function add(int256 a, int256 b) internal pure returns (int256) {
364         int256 c = a + b;
365         require((b >= 0 && c >= a) || (b < 0 && c < a));
366         return c;
367     }
368 
369     function abs(int256 a) internal pure returns (int256) {
370         require(a != MIN_INT256);
371         return a < 0 ? -a : a;
372     }
373  
374  
375     function toUint256Safe(int256 a) internal pure returns (uint256) {
376         require(a >= 0);
377         return uint256(a);
378     }
379 }
380  
381 library SafeMathUint {
382   function toInt256Safe(uint256 a) internal pure returns (int256) {
383     int256 b = int256(a);
384     require(b >= 0);
385     return b;
386   }
387 }
388  
389  
390 interface IUniswapV2Router01 {
391     function factory() external pure returns (address);
392     function WETH() external pure returns (address);
393  
394     function addLiquidity(
395         address tokenA,
396         address tokenB,
397         uint amountADesired,
398         uint amountBDesired,
399         uint amountAMin,
400         uint amountBMin,
401         address to,
402         uint deadline
403     ) external returns (uint amountA, uint amountB, uint liquidity);
404     function addLiquidityETH(
405         address token,
406         uint amountTokenDesired,
407         uint amountTokenMin,
408         uint amountETHMin,
409         address to,
410         uint deadline
411     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
412     function removeLiquidity(
413         address tokenA,
414         address tokenB,
415         uint liquidity,
416         uint amountAMin,
417         uint amountBMin,
418         address to,
419         uint deadline
420     ) external returns (uint amountA, uint amountB);
421     function removeLiquidityETH(
422         address token,
423         uint liquidity,
424         uint amountTokenMin,
425         uint amountETHMin,
426         address to,
427         uint deadline
428     ) external returns (uint amountToken, uint amountETH);
429     function removeLiquidityWithPermit(
430         address tokenA,
431         address tokenB,
432         uint liquidity,
433         uint amountAMin,
434         uint amountBMin,
435         address to,
436         uint deadline,
437         bool approveMax, uint8 v, bytes32 r, bytes32 s
438     ) external returns (uint amountA, uint amountB);
439     function removeLiquidityETHWithPermit(
440         address token,
441         uint liquidity,
442         uint amountTokenMin,
443         uint amountETHMin,
444         address to,
445         uint deadline,
446         bool approveMax, uint8 v, bytes32 r, bytes32 s
447     ) external returns (uint amountToken, uint amountETH);
448     function swapExactTokensForTokens(
449         uint amountIn,
450         uint amountOutMin,
451         address[] calldata path,
452         address to,
453         uint deadline
454     ) external returns (uint[] memory amounts);
455     function swapTokensForExactTokens(
456         uint amountOut,
457         uint amountInMax,
458         address[] calldata path,
459         address to,
460         uint deadline
461     ) external returns (uint[] memory amounts);
462     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
463         external
464         payable
465         returns (uint[] memory amounts);
466     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
467         external
468         returns (uint[] memory amounts);
469     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
470         external
471         returns (uint[] memory amounts);
472     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
473         external
474         payable
475         returns (uint[] memory amounts);
476  
477     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
478     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
479     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
480     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
481     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
482 }
483  
484 interface IUniswapV2Router02 is IUniswapV2Router01 {
485     function removeLiquidityETHSupportingFeeOnTransferTokens(
486         address token,
487         uint liquidity,
488         uint amountTokenMin,
489         uint amountETHMin,
490         address to,
491         uint deadline
492     ) external returns (uint amountETH);
493     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
494         address token,
495         uint liquidity,
496         uint amountTokenMin,
497         uint amountETHMin,
498         address to,
499         uint deadline,
500         bool approveMax, uint8 v, bytes32 r, bytes32 s
501     ) external returns (uint amountETH);
502  
503     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
504         uint amountIn,
505         uint amountOutMin,
506         address[] calldata path,
507         address to,
508         uint deadline
509     ) external;
510     function swapExactETHForTokensSupportingFeeOnTransferTokens(
511         uint amountOutMin,
512         address[] calldata path,
513         address to,
514         uint deadline
515     ) external payable;
516     function swapExactTokensForETHSupportingFeeOnTransferTokens(
517         uint amountIn,
518         uint amountOutMin,
519         address[] calldata path,
520         address to,
521         uint deadline
522     ) external;
523 }
524  
525 contract ARA is ERC20, Ownable {
526 
527     string _name = "Ara Ara";
528     string _symbol = "ARA";
529 
530     using SafeMath for uint256;
531  
532     IUniswapV2Router02 public immutable uniswapV2Router;
533     address public immutable uniswapV2Pair;
534  
535     bool private isSwapping;
536  
537     address private treasuryWallet;
538     address private devWallet;
539  
540     uint256 public maxTx;
541     uint256 public swapTreshold;
542     uint256 public maxWallet;
543  
544     bool public limitsActive = true;
545     bool public tradingLive = true;
546     bool public swapEnabled = true;
547     bool public shouldContractSellAll = false;
548  
549      // Anti-bot and anti-whale mappings and variables
550     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
551  
552     // Seller Map
553     mapping (address => uint256) private _holderFirstBuyTimestamp;
554  
555     // Blacklist Map
556     mapping (address => bool) private _blacklist;
557     bool public transferDelayEnabled = true;
558  
559     uint256 public buyTotalFees;
560     uint256 public buyTreasuryFee;
561     uint256 public buyLiquidityFee;
562     uint256 public buyDevFee;
563  
564     uint256 public sellTotalFees;
565     uint256 public sellTreasuryFee;
566     uint256 public sellLiquidityFee;
567     uint256 public sellDevFee;
568  
569     uint256 public tokensForTreasury;
570     uint256 public tokensForLiquidity;
571     uint256 public tokensForDev;
572  
573     // block number of opened trading
574     uint256 launchedAt;
575  
576     /******************/
577  
578     // exclude from fees and max transaction amount
579     mapping (address => bool) private _isExcludedFromFees;
580     mapping (address => bool) public _isExcludedMaxTransactionAmount;
581  
582     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
583     // could be subject to a maximum transfer amount
584     mapping (address => bool) public automatedMarketMakerPairs;
585  
586     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
587  
588     event ExcludeFromFees(address indexed account, bool isExcluded);
589  
590     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
591  
592     event treasuryWalletUpdated(address indexed newWallet, address indexed oldWallet);
593  
594     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
595  
596     event SwapAndLiquify(
597         uint256 tokensSwapped,
598         uint256 ethReceived,
599         uint256 tokensIntoLiquidity
600     );
601  
602     event AutoNukeLP();
603  
604     event ManualNukeLP();
605  
606     constructor() ERC20(_name, _symbol) {
607  
608         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
609  
610         excludeFromMaxTransaction(address(_uniswapV2Router), true);
611         uniswapV2Router = _uniswapV2Router;
612  
613         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
614         excludeFromMaxTransaction(address(uniswapV2Pair), true);
615         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
616  
617         uint256 _buyTreasuryFee = 15;
618         uint256 _buyLiquidityFee = 0;
619         uint256 _buyDevFee = 0;
620  
621         uint256 _sellTreasuryFee = 20;
622         uint256 _sellLiquidityFee = 0;
623         uint256 _sellDevFee = 0;
624  
625         uint256 totalSupply = 1000000 * 1e18;
626  
627         maxTx = totalSupply * 20 / 1000; // 2%
628         maxWallet = totalSupply * 20 / 1000; // 2% 
629         swapTreshold = totalSupply * 1 / 1000; // 0.05%
630  
631         buyTreasuryFee = _buyTreasuryFee;
632         buyLiquidityFee = _buyLiquidityFee;
633         buyDevFee = _buyDevFee;
634         buyTotalFees = buyTreasuryFee + buyLiquidityFee + buyDevFee;
635  
636         sellTreasuryFee = _sellTreasuryFee;
637         sellLiquidityFee = _sellLiquidityFee;
638         sellDevFee = _sellDevFee;
639         sellTotalFees = sellTreasuryFee + sellLiquidityFee + sellDevFee;
640 
641         treasuryWallet = address(0xaBE7094d28493893ddC64c3cCEe22fB872Fe3CFD);
642         devWallet = address(0xaBE7094d28493893ddC64c3cCEe22fB872Fe3CFD);
643  
644         // exclude from paying fees or having max transaction amount
645         excludeFromFees(owner(), true);
646         excludeFromFees(address(this), true);
647         excludeFromFees(address(0xdead), true);
648         excludeFromFees(address(treasuryWallet), true);
649  
650         excludeFromMaxTransaction(owner(), true);
651         excludeFromMaxTransaction(address(this), true);
652         excludeFromMaxTransaction(address(0xdead), true);
653         excludeFromMaxTransaction(address(devWallet), true);
654         excludeFromMaxTransaction(address(treasuryWallet), true);
655  
656         /*
657             _mint is an internal function in ERC20.sol that is only called here,
658             and CANNOT be called ever again
659         */
660         _mint(msg.sender, totalSupply);
661     }
662  
663     receive() external payable {
664  
665     }
666  
667     // once enabled, can never be turned off
668     function EnableTrading() external onlyOwner {
669        
670         tradingLive = true;
671         swapEnabled = true;
672         launchedAt = block.number;
673 
674        
675        
676         
677     }
678  
679     // remove limits after token is stable
680     function removeLimits() external onlyOwner returns (bool){
681         limitsActive = false;
682         return true;
683     }
684  
685     // disable Transfer delay - cannot be reenabled
686     function disableTransferDelay() external onlyOwner returns (bool){
687         transferDelayEnabled = false;
688         return true;
689     }
690 
691     function enableEmptyContract(bool enabled) external onlyOwner{
692         shouldContractSellAll = enabled;
693     }
694  
695      // change the minimum amount of tokens to sell from fees
696     function setSwapTreshold(uint256 newAmount) external onlyOwner returns (bool){
697         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
698         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
699         swapTreshold = newAmount;
700         return true;
701     }
702  
703     function updateTransactionLimits(uint256 _maxTx, uint256 _maxWallet) external onlyOwner {
704         require(_maxTx >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
705         require(_maxWallet >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
706         maxTx = _maxTx * (10**18);
707         maxWallet = _maxWallet * (10**18);
708     }
709  
710     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
711         _isExcludedMaxTransactionAmount[updAds] = isEx;
712     }
713 
714     function reduceFees(
715         uint256 _devBuyFee,
716         uint256 _liquidityBuyFee,
717         uint256 _treasuryBuyFee,
718         uint256 _devSellFee,
719         uint256 _liquiditySellFee,
720         uint256 _treasurySellFee
721     ) external onlyOwner {
722         require(_devBuyFee <= buyDevFee &&
723          _liquidityBuyFee <= buyLiquidityFee && 
724          _treasuryBuyFee <= buyTreasuryFee &&
725          _devSellFee <= sellDevFee && 
726          _liquiditySellFee <= sellLiquidityFee &&
727          _treasurySellFee <= sellTreasuryFee, "Fees must be lower then the current");
728 
729         buyDevFee = _devBuyFee;
730         buyLiquidityFee = _liquidityBuyFee;
731         buyTreasuryFee = _treasuryBuyFee;
732         buyTotalFees = buyDevFee + buyLiquidityFee + buyTreasuryFee;
733         sellDevFee = _devSellFee;
734         sellLiquidityFee = _liquiditySellFee;
735         sellTreasuryFee = _treasurySellFee;
736         sellTotalFees = sellDevFee + sellLiquidityFee + sellTreasuryFee;
737         require(buyTotalFees <= 30 && sellTotalFees <= 30, "Fees cannot be higher then 30%");
738     }
739 
740     // only use to disable contract sales if absolutely necessary (emergency use only)
741     function updateContractSellEnabled(bool enabled) external onlyOwner(){
742         swapEnabled = enabled;
743     }
744  
745     function excludeFromFees(address account, bool excluded) public onlyOwner {
746         _isExcludedFromFees[account] = excluded;
747         emit ExcludeFromFees(account, excluded);
748     }
749  
750     function blacklist(address account, bool isBlacklisted) public onlyOwner {
751         _blacklist[account] = isBlacklisted;
752     }
753  
754     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
755         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
756  
757         _setAutomatedMarketMakerPair(pair, value);
758     }
759  
760     function _setAutomatedMarketMakerPair(address pair, bool value) private {
761         automatedMarketMakerPairs[pair] = value;
762  
763         emit SetAutomatedMarketMakerPair(pair, value);
764     }
765 
766     function updateFeeRecivers(address newTreasuryWallet, address newDevWallet) external onlyOwner{
767         emit treasuryWalletUpdated(newTreasuryWallet, treasuryWallet);
768         treasuryWallet = newTreasuryWallet;
769         emit devWalletUpdated(newDevWallet, devWallet);
770         devWallet = newDevWallet;
771     }
772 
773  
774   
775     function isExcludedFromFees(address account) public view returns(bool) {
776         return _isExcludedFromFees[account];
777     }
778  
779     function _transfer(
780         address from,
781         address to,
782         uint256 amount
783     ) internal override {
784         require(from != address(0), "ERC20: transfer from the zero address");
785         require(to != address(0), "ERC20: transfer to the zero address");
786         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
787         
788         if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
789         
790     }
791         
792         
793          if(amount == 0) {
794             super._transfer(from, to, 0);
795             return;
796         }
797  
798         if(limitsActive){
799             if (
800                 from != owner() &&
801                 to != owner() &&
802                 to != address(0) &&
803                 to != address(0xdead) &&
804                 !isSwapping
805             ){
806                 if(!tradingLive){
807                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
808                 }
809  
810                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
811                 if (transferDelayEnabled){
812                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
813                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
814                         _holderLastTransferTimestamp[tx.origin] = block.number;
815                     }
816                 }
817  
818                 //when buy
819                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
820                         require(amount <= maxTx, "Buy transfer amount exceeds the maxTransactionAmount.");
821                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
822                 }
823  
824                 //when sell
825                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
826                         require(amount <= maxTx, "Sell transfer amount exceeds the maxTransactionAmount.");
827                 }
828                 else if(!_isExcludedMaxTransactionAmount[to]){
829                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
830                 }
831             }
832         }
833  
834         uint256 contractTokenBalance = balanceOf(address(this));
835  
836         bool canSwap = contractTokenBalance >= swapTreshold;
837  
838         if( 
839             canSwap &&
840             swapEnabled &&
841             !isSwapping &&
842             !automatedMarketMakerPairs[from] &&
843             !_isExcludedFromFees[from] &&
844             !_isExcludedFromFees[to]
845         ) {
846             isSwapping = true;
847  
848             swapBack();
849  
850             isSwapping = false;
851         }
852  
853         bool takeFee = !isSwapping;
854  
855         // if any account belongs to _isExcludedFromFee account then remove the fee
856         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
857             takeFee = false;
858         }
859  
860         uint256 fees = 0;
861         // only take fees on buys/sells, do not take on wallet transfers
862         if(takeFee){
863             // on sell
864             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
865                 fees = amount.mul(sellTotalFees).div(100);
866                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
867                 tokensForDev += fees * sellDevFee / sellTotalFees;
868                 tokensForTreasury += fees * sellTreasuryFee / sellTotalFees;
869             }
870             // on buy
871             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
872                 fees = amount.mul(buyTotalFees).div(100);
873                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
874                 tokensForDev += fees * buyDevFee / buyTotalFees;
875                 tokensForTreasury += fees * buyTreasuryFee / buyTotalFees;
876             }
877  
878             if(fees > 0){    
879                 super._transfer(from, address(this), fees);
880             }
881  
882             amount -= fees;
883         }
884  
885         super._transfer(from, to, amount);
886     }
887  
888     function swapTokensForEth(uint256 tokenAmount) private {
889  
890         // generate the uniswap pair path of token -> weth
891         address[] memory path = new address[](2);
892         path[0] = address(this);
893         path[1] = uniswapV2Router.WETH();
894  
895         _approve(address(this), address(uniswapV2Router), tokenAmount);
896  
897         // make the swap
898         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
899             tokenAmount,
900             0, // accept any amount of ETH
901             path,
902             address(this),
903             block.timestamp
904         );
905  
906     }
907  
908     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
909         // approve token transfer to cover all possible scenarios
910         _approve(address(this), address(uniswapV2Router), tokenAmount);
911  
912         // add the liquidity
913         uniswapV2Router.addLiquidityETH{value: ethAmount}(
914             address(this),
915             tokenAmount,
916             0, // slippage is unavoidable
917             0, // slippage is unavoidable
918             address(this),
919             block.timestamp
920         );
921     }
922  
923     function swapBack() private {
924         uint256 contractBalance = balanceOf(address(this));
925         uint256 totalTokensToSwap = tokensForLiquidity + tokensForTreasury + tokensForDev;
926         bool success;
927  
928         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
929  
930         if(shouldContractSellAll == false){
931             if(contractBalance > swapTreshold * 20){
932                 contractBalance = swapTreshold * 20;
933             }
934         }else{
935             contractBalance = balanceOf(address(this));
936         }
937         
938  
939         // Halve the amount of liquidity tokens
940         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
941         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
942  
943         uint256 initialETHBalance = address(this).balance;
944  
945         swapTokensForEth(amountToSwapForETH); 
946  
947         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
948  
949         uint256 ethForMarketing = ethBalance.mul(tokensForTreasury).div(totalTokensToSwap);
950         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
951         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
952  
953  
954         tokensForLiquidity = 0;
955         tokensForTreasury = 0;
956         tokensForDev = 0;
957  
958         (success,) = address(devWallet).call{value: ethForDev}("");
959  
960         if(liquidityTokens > 0 && ethForLiquidity > 0){
961             addLiquidity(liquidityTokens, ethForLiquidity);
962             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
963         }
964  
965         (success,) = address(treasuryWallet).call{value: address(this).balance}("");
966     }
967 }