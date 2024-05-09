1 // Website: https://hpot8i.com/ 🏃‍♂️
2 
3 // Twitter: https://twitter.com/HP0T8I 🦊
4 
5 // Telegram: https://t.me/HP0T8I 🦊
6 
7 // SPDX-License-Identifier: Unlicensed
8 
9 pragma solidity 0.8.11;
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
325         require(newOwner != address(0), "Ownable: new owner is the zero address");
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
522 contract HarryPotterObamaTails8Inu  is ERC20, Ownable {
523     using SafeMath for uint256;
524  
525     IUniswapV2Router02 public immutable uniswapV2Router;
526     address public immutable uniswapV2Pair;
527  
528     bool private swapping;
529  
530     address private marketingWallet;
531     address private devWallet;
532  
533     uint256 public maxTransactionAmount;
534     uint256 public swapTokensAtAmount;
535     uint256 public maxWallet;
536  
537     bool public limitsInEffect = true;
538     bool public tradingActive = false;
539     bool public swapEnabled = false;
540  
541      // Anti-bot and anti-whale mappings and variables
542     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
543  
544     // Seller Map
545     mapping (address => uint256) private _holderFirstBuyTimestamp;
546  
547     // Blacklist Map
548     mapping (address => bool) private _blacklist;
549     bool public transferDelayEnabled = true;
550  
551     uint256 public buyTotalFees;
552     uint256 public buyMarketingFee;
553     uint256 public buyLiquidityFee;
554     uint256 public buyDevFee;
555  
556     uint256 public sellTotalFees;
557     uint256 public sellMarketingFee;
558     uint256 public sellLiquidityFee;
559     uint256 public sellDevFee;
560  
561     uint256 public tokensForMarketing;
562     uint256 public tokensForLiquidity;
563     uint256 public tokensForDev;
564  
565     // block number of opened trading
566     uint256 launchedAt;
567  
568     /******************/
569  
570     // exclude from fees and max transaction amount
571     mapping (address => bool) private _isExcludedFromFees;
572     mapping (address => bool) public _isExcludedMaxTransactionAmount;
573  
574     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
575     // could be subject to a maximum transfer amount
576     mapping (address => bool) public automatedMarketMakerPairs;
577  
578     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
579  
580     event ExcludeFromFees(address indexed account, bool isExcluded);
581  
582     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
583  
584     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
585  
586     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
587  
588     event SwapAndLiquify(
589         uint256 tokensSwapped,
590         uint256 ethReceived,
591         uint256 tokensIntoLiquidity
592     );
593  
594     event AutoNukeLP();
595  
596     event ManualNukeLP();
597  
598     constructor() ERC20("HarryPotterObamaTails8Inu", "BNB") {
599  
600         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
601  
602         excludeFromMaxTransaction(address(_uniswapV2Router), true);
603         uniswapV2Router = _uniswapV2Router;
604  
605         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
606         excludeFromMaxTransaction(address(uniswapV2Pair), true);
607         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
608  
609         uint256 _buyMarketingFee = 15;
610         uint256 _buyLiquidityFee = 0;
611         uint256 _buyDevFee = 5;
612  
613         uint256 _sellMarketingFee = 27;
614         uint256 _sellLiquidityFee = 0;
615         uint256 _sellDevFee = 8;
616  
617         uint256 totalSupply = 1000000000 * 1e18;
618  
619         maxTransactionAmount = totalSupply * 1 / 100; // 1%
620         maxWallet = totalSupply * 1 / 100; // 1% 
621         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.5%
622  
623         buyMarketingFee = _buyMarketingFee;
624         buyLiquidityFee = _buyLiquidityFee;
625         buyDevFee = _buyDevFee;
626         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
627  
628         sellMarketingFee = _sellMarketingFee;
629         sellLiquidityFee = _sellLiquidityFee;
630         sellDevFee = _sellDevFee;
631         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
632  
633         marketingWallet = address(0x9CCdD99dcB3CD10634F7AE710c131672DD6b9422);
634         devWallet = address(0x67e168Fbd9572446F8Ec286628bA80D3E48e653b);
635  
636         // exclude from paying fees or having max transaction amount
637         excludeFromFees(owner(), true);
638         excludeFromFees(address(this), true);
639         excludeFromFees(address(0xdead), true);
640  
641         excludeFromMaxTransaction(owner(), true);
642         excludeFromMaxTransaction(address(this), true);
643         excludeFromMaxTransaction(address(0xdead), true);
644  
645         /*
646             _mint is an internal function in ERC20.sol that is only called here,
647             and CANNOT be called ever again
648         */
649         _mint(msg.sender, totalSupply);
650     }
651  
652     receive() external payable {
653  
654     }
655  
656     // once enabled, can never be turned off
657     function enableTrading() external onlyOwner {
658         tradingActive = true;
659         swapEnabled = true;
660         launchedAt = block.number;
661     }
662  
663     // remove limits after token is stable
664     function removeLimits() external onlyOwner returns (bool){
665         limitsInEffect = false;
666         return true;
667     }
668  
669     // disable Transfer delay - cannot be reenabled
670     function disableTransferDelay() external onlyOwner returns (bool){
671         transferDelayEnabled = false;
672         return true;
673     }
674  
675      // change the minimum amount of tokens to sell from fees
676     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
677         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
678         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
679         swapTokensAtAmount = newAmount;
680         return true;
681     }
682  
683     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
684         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
685         maxTransactionAmount = newNum * (10**18);
686     }
687  
688     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
689         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
690         maxWallet = newNum * (10**18);
691     }
692  
693     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
694         _isExcludedMaxTransactionAmount[updAds] = isEx;
695     }
696 
697           function updateBuyFees(
698         uint256 _devFee,
699         uint256 _liquidityFee,
700         uint256 _marketingFee
701     ) external onlyOwner {
702         buyDevFee = _devFee;
703         buyLiquidityFee = _liquidityFee;
704         buyMarketingFee = _marketingFee;
705         buyTotalFees = buyDevFee + buyLiquidityFee + buyMarketingFee;
706     }
707 
708     function updateSellFees(
709         uint256 _devFee,
710         uint256 _liquidityFee,
711         uint256 _marketingFee
712     ) external onlyOwner {
713         sellDevFee = _devFee;
714         sellLiquidityFee = _liquidityFee;
715         sellMarketingFee = _marketingFee;
716         sellTotalFees = sellDevFee + sellLiquidityFee + sellMarketingFee;
717     }
718  
719     // only use to disable contract sales if absolutely necessary (emergency use only)
720     function updateSwapEnabled(bool enabled) external onlyOwner(){
721         swapEnabled = enabled;
722     }
723  
724     function excludeFromFees(address account, bool excluded) public onlyOwner {
725         _isExcludedFromFees[account] = excluded;
726         emit ExcludeFromFees(account, excluded);
727     }
728  
729     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
730         _blacklist[account] = isBlacklisted;
731     }
732  
733     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
734         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
735  
736         _setAutomatedMarketMakerPair(pair, value);
737     }
738  
739     function _setAutomatedMarketMakerPair(address pair, bool value) private {
740         automatedMarketMakerPairs[pair] = value;
741  
742         emit SetAutomatedMarketMakerPair(pair, value);
743     }
744  
745     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
746         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
747         marketingWallet = newMarketingWallet;
748     }
749  
750     function updateDevWallet(address newWallet) external onlyOwner {
751         emit devWalletUpdated(newWallet, devWallet);
752         devWallet = newWallet;
753     }
754  
755  
756     function isExcludedFromFees(address account) public view returns(bool) {
757         return _isExcludedFromFees[account];
758     }
759  
760     function _transfer(
761         address from,
762         address to,
763         uint256 amount
764     ) internal override {
765         require(from != address(0), "ERC20: transfer from the zero address");
766         require(to != address(0), "ERC20: transfer to the zero address");
767         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
768          if(amount == 0) {
769             super._transfer(from, to, 0);
770             return;
771         }
772  
773         if(limitsInEffect){
774             if (
775                 from != owner() &&
776                 to != owner() &&
777                 to != address(0) &&
778                 to != address(0xdead) &&
779                 !swapping
780             ){
781                 if(!tradingActive){
782                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
783                 }
784  
785                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
786                 if (transferDelayEnabled){
787                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
788                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
789                         _holderLastTransferTimestamp[tx.origin] = block.number;
790                     }
791                 }
792  
793                 //when buy
794                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
795                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
796                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
797                 }
798  
799                 //when sell
800                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
801                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
802                 }
803                 else if(!_isExcludedMaxTransactionAmount[to]){
804                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
805                 }
806             }
807         }
808  
809         uint256 contractTokenBalance = balanceOf(address(this));
810  
811         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
812  
813         if( 
814             canSwap &&
815             swapEnabled &&
816             !swapping &&
817             !automatedMarketMakerPairs[from] &&
818             !_isExcludedFromFees[from] &&
819             !_isExcludedFromFees[to]
820         ) {
821             swapping = true;
822  
823             swapBack();
824  
825             swapping = false;
826         }
827  
828         bool takeFee = !swapping;
829  
830         // if any account belongs to _isExcludedFromFee account then remove the fee
831         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
832             takeFee = false;
833         }
834  
835         uint256 fees = 0;
836         // only take fees on buys/sells, do not take on wallet transfers
837         if(takeFee){
838             // on sell
839             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
840                 fees = amount.mul(sellTotalFees).div(100);
841                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
842                 tokensForDev += fees * sellDevFee / sellTotalFees;
843                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
844             }
845             // on buy
846             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
847                 fees = amount.mul(buyTotalFees).div(100);
848                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
849                 tokensForDev += fees * buyDevFee / buyTotalFees;
850                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
851             }
852  
853             if(fees > 0){    
854                 super._transfer(from, address(this), fees);
855             }
856  
857             amount -= fees;
858         }
859  
860         super._transfer(from, to, amount);
861     }
862  
863     function swapTokensForEth(uint256 tokenAmount) private {
864  
865         // generate the uniswap pair path of token -> weth
866         address[] memory path = new address[](2);
867         path[0] = address(this);
868         path[1] = uniswapV2Router.WETH();
869  
870         _approve(address(this), address(uniswapV2Router), tokenAmount);
871  
872         // make the swap
873         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
874             tokenAmount,
875             0, // accept any amount of ETH
876             path,
877             address(this),
878             block.timestamp
879         );
880  
881     }
882  
883     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
884         // approve token transfer to cover all possible scenarios
885         _approve(address(this), address(uniswapV2Router), tokenAmount);
886  
887         // add the liquidity
888         uniswapV2Router.addLiquidityETH{value: ethAmount}(
889             address(this),
890             tokenAmount,
891             0, // slippage is unavoidable
892             0, // slippage is unavoidable
893             address(this),
894             block.timestamp
895         );
896     }
897  
898     function swapBack() private {
899         uint256 contractBalance = balanceOf(address(this));
900         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
901         bool success;
902  
903         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
904  
905         if(contractBalance > swapTokensAtAmount * 20){
906           contractBalance = swapTokensAtAmount * 20;
907         }
908  
909         // Halve the amount of liquidity tokens
910         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
911         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
912  
913         uint256 initialETHBalance = address(this).balance;
914  
915         swapTokensForEth(amountToSwapForETH); 
916  
917         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
918  
919         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
920         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
921         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
922  
923  
924         tokensForLiquidity = 0;
925         tokensForMarketing = 0;
926         tokensForDev = 0;
927  
928         (success,) = address(devWallet).call{value: ethForDev}("");
929  
930         if(liquidityTokens > 0 && ethForLiquidity > 0){
931             addLiquidity(liquidityTokens, ethForLiquidity);
932             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
933         }
934  
935         (success,) = address(marketingWallet).call{value: address(this).balance}("");
936     }
937 }