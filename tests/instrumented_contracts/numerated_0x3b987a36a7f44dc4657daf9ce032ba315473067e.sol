1 /*
2 https://twitter.com/waifucoindex
3 https://t.me/WaifuUniversePortal
4 https://www.waifuuniverse.xyz/
5 */
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
522 contract waifu is ERC20, Ownable {
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
598     constructor() ERC20("Waifu", "WAIFU") {
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
609         uint256 _buyMarketingFee = 25;
610         uint256 _buyLiquidityFee = 0;
611         uint256 _buyDevFee = 0;
612  
613         uint256 _sellMarketingFee = 45;
614         uint256 _sellLiquidityFee = 0;
615         uint256 _sellDevFee = 0;
616  
617         uint256 totalSupply = 1000000000 * 1e18;
618  
619         maxTransactionAmount = totalSupply * 5 / 1000; // 0.5%
620         maxWallet = totalSupply * 10 / 1000; // 1% 
621         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05%
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
633         marketingWallet = address(0xC4c6a53AD131D4a76C449b82E063e9F8E3A466Ad);
634         devWallet = address(0xC4c6a53AD131D4a76C449b82E063e9F8E3A466Ad);
635  
636         // exclude from paying fees or having max transaction amount
637         excludeFromFees(owner(), true);
638         excludeFromFees(address(this), true);
639         excludeFromFees(address(0xdead), true);
640         excludeFromFees(address(marketingWallet), true);
641  
642         excludeFromMaxTransaction(owner(), true);
643         excludeFromMaxTransaction(address(this), true);
644         excludeFromMaxTransaction(address(0xdead), true);
645         excludeFromMaxTransaction(address(devWallet), true);
646         excludeFromMaxTransaction(address(marketingWallet), true);
647  
648         /*
649             _mint is an internal function in ERC20.sol that is only called here,
650             and CANNOT be called ever again
651         */
652         _mint(msg.sender, totalSupply);
653     }
654  
655     receive() external payable {
656  
657     }
658  
659     // once enabled, can never be turned off
660     function enableTrading() external onlyOwner {
661         tradingActive = true;
662         swapEnabled = true;
663         launchedAt = block.number;
664     }
665  
666     // remove limits after token is stable
667     function removeLimits() external onlyOwner returns (bool){
668         limitsInEffect = false;
669         return true;
670     }
671  
672     // disable Transfer delay - cannot be reenabled
673     function disableTransferDelay() external onlyOwner returns (bool){
674         transferDelayEnabled = false;
675         return true;
676     }
677  
678      // change the minimum amount of tokens to sell from fees
679     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
680         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
681         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
682         swapTokensAtAmount = newAmount;
683         return true;
684     }
685  
686     function updateMaxTxn(uint256 newNum) external onlyOwner {
687         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
688         maxTransactionAmount = newNum * (10**18);
689     }
690  
691     function updateMaxWallet(uint256 newNum) external onlyOwner {
692         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
693         maxWallet = newNum * (10**18);
694     }
695  
696     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
697         _isExcludedMaxTransactionAmount[updAds] = isEx;
698     }
699 
700     function updateBuyFees(
701         uint256 _devFee,
702         uint256 _liquidityFee,
703         uint256 _marketingFee
704     ) external onlyOwner {
705         buyDevFee = _devFee;
706         buyLiquidityFee = _liquidityFee;
707         buyMarketingFee = _marketingFee;
708         buyTotalFees = buyDevFee + buyLiquidityFee + buyMarketingFee;
709     }
710 
711     function updateSellFees(
712         uint256 _devFee,
713         uint256 _liquidityFee,
714         uint256 _marketingFee
715     ) external onlyOwner {
716         sellDevFee = _devFee;
717         sellLiquidityFee = _liquidityFee;
718         sellMarketingFee = _marketingFee;
719         sellTotalFees = sellDevFee + sellLiquidityFee + sellMarketingFee;
720     }
721  
722     // only use to disable contract sales if absolutely necessary (emergency use only)
723     function updateSwapEnabled(bool enabled) external onlyOwner(){
724         swapEnabled = enabled;
725     }
726  
727     function excludeFromFees(address account, bool excluded) public onlyOwner {
728         _isExcludedFromFees[account] = excluded;
729         emit ExcludeFromFees(account, excluded);
730     }
731  
732     function setbot (address account, bool isBlacklisted) public onlyOwner {
733         _blacklist[account] = isBlacklisted;
734     }
735  
736     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
737         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
738  
739         _setAutomatedMarketMakerPair(pair, value);
740     }
741  
742     function _setAutomatedMarketMakerPair(address pair, bool value) private {
743         automatedMarketMakerPairs[pair] = value;
744  
745         emit SetAutomatedMarketMakerPair(pair, value);
746     }
747  
748     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
749         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
750         marketingWallet = newMarketingWallet;
751     }
752  
753     function updateDevWallet(address newWallet) external onlyOwner {
754         emit devWalletUpdated(newWallet, devWallet);
755         devWallet = newWallet;
756     }
757  
758  
759     function isExcludedFromFees(address account) public view returns(bool) {
760         return _isExcludedFromFees[account];
761     }
762  
763     function _transfer(
764         address from,
765         address to,
766         uint256 amount
767     ) internal override {
768         require(from != address(0), "ERC20: transfer from the zero address");
769         require(to != address(0), "ERC20: transfer to the zero address");
770         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
771          if(amount == 0) {
772             super._transfer(from, to, 0);
773             return;
774         }
775  
776         if(limitsInEffect){
777             if (
778                 from != owner() &&
779                 to != owner() &&
780                 to != address(0) &&
781                 to != address(0xdead) &&
782                 !swapping
783             ){
784                 if(!tradingActive){
785                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
786                 }
787  
788                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
789                 if (transferDelayEnabled){
790                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
791                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
792                         _holderLastTransferTimestamp[tx.origin] = block.number;
793                     }
794                 }
795  
796                 //when buy
797                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
798                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
799                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
800                 }
801  
802                 //when sell
803                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
804                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
805                 }
806                 else if(!_isExcludedMaxTransactionAmount[to]){
807                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
808                 }
809             }
810         }
811  
812         uint256 contractTokenBalance = balanceOf(address(this));
813  
814         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
815  
816         if( 
817             canSwap &&
818             swapEnabled &&
819             !swapping &&
820             !automatedMarketMakerPairs[from] &&
821             !_isExcludedFromFees[from] &&
822             !_isExcludedFromFees[to]
823         ) {
824             swapping = true;
825  
826             swapBack();
827  
828             swapping = false;
829         }
830  
831         bool takeFee = !swapping;
832  
833         // if any account belongs to _isExcludedFromFee account then remove the fee
834         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
835             takeFee = false;
836         }
837  
838         uint256 fees = 0;
839         // only take fees on buys/sells, do not take on wallet transfers
840         if(takeFee){
841             // on sell
842             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
843                 fees = amount.mul(sellTotalFees).div(100);
844                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
845                 tokensForDev += fees * sellDevFee / sellTotalFees;
846                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
847             }
848             // on buy
849             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
850                 fees = amount.mul(buyTotalFees).div(100);
851                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
852                 tokensForDev += fees * buyDevFee / buyTotalFees;
853                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
854             }
855  
856             if(fees > 0){    
857                 super._transfer(from, address(this), fees);
858             }
859  
860             amount -= fees;
861         }
862  
863         super._transfer(from, to, amount);
864     }
865  
866     function swapTokensForEth(uint256 tokenAmount) private {
867  
868         // generate the uniswap pair path of token -> weth
869         address[] memory path = new address[](2);
870         path[0] = address(this);
871         path[1] = uniswapV2Router.WETH();
872  
873         _approve(address(this), address(uniswapV2Router), tokenAmount);
874  
875         // make the swap
876         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
877             tokenAmount,
878             0, // accept any amount of ETH
879             path,
880             address(this),
881             block.timestamp
882         );
883  
884     }
885  
886     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
887         // approve token transfer to cover all possible scenarios
888         _approve(address(this), address(uniswapV2Router), tokenAmount);
889  
890         // add the liquidity
891         uniswapV2Router.addLiquidityETH{value: ethAmount}(
892             address(this),
893             tokenAmount,
894             0, // slippage is unavoidable
895             0, // slippage is unavoidable
896             address(this),
897             block.timestamp
898         );
899     }
900  
901     function swapBack() private {
902         uint256 contractBalance = balanceOf(address(this));
903         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
904         bool success;
905  
906         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
907  
908         if(contractBalance > swapTokensAtAmount * 20){
909           contractBalance = swapTokensAtAmount * 20;
910         }
911  
912         // Halve the amount of liquidity tokens
913         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
914         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
915  
916         uint256 initialETHBalance = address(this).balance;
917  
918         swapTokensForEth(amountToSwapForETH); 
919  
920         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
921  
922         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
923         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
924         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
925  
926  
927         tokensForLiquidity = 0;
928         tokensForMarketing = 0;
929         tokensForDev = 0;
930  
931         (success,) = address(devWallet).call{value: ethForDev}("");
932  
933         if(liquidityTokens > 0 && ethForLiquidity > 0){
934             addLiquidity(liquidityTokens, ethForLiquidity);
935             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
936         }
937  
938         (success,) = address(marketingWallet).call{value: address(this).balance}("");
939     }
940 }