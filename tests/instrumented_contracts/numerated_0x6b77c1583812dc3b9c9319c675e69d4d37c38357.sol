1 //http://bitcorneth.com
2 
3 // SPDX-License-Identifier: Unlicensed
4 
5 pragma solidity 0.8.11;
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
17 interface IUniswapV2Pair {
18     event Approval(address indexed owner, address indexed spender, uint value);
19     event Transfer(address indexed from, address indexed to, uint value);
20  
21     function name() external pure returns (string memory);
22     function symbol() external pure returns (string memory);
23     function decimals() external pure returns (uint8);
24     function totalSupply() external view returns (uint);
25     function balanceOf(address owner) external view returns (uint);
26     function allowance(address owner, address spender) external view returns (uint);
27  
28     function approve(address spender, uint value) external returns (bool);
29     function transfer(address to, uint value) external returns (bool);
30     function transferFrom(address from, address to, uint value) external returns (bool);
31  
32     function DOMAIN_SEPARATOR() external view returns (bytes32);
33     function PERMIT_TYPEHASH() external pure returns (bytes32);
34     function nonces(address owner) external view returns (uint);
35  
36     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
37  
38     event Mint(address indexed sender, uint amount0, uint amount1);
39     event Swap(
40         address indexed sender,
41         uint amount0In,
42         uint amount1In,
43         uint amount0Out,
44         uint amount1Out,
45         address indexed to
46     );
47     event Sync(uint112 reserve0, uint112 reserve1);
48  
49     function MINIMUM_LIQUIDITY() external pure returns (uint);
50     function factory() external view returns (address);
51     function token0() external view returns (address);
52     function token1() external view returns (address);
53     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
54     function price0CumulativeLast() external view returns (uint);
55     function price1CumulativeLast() external view returns (uint);
56     function kLast() external view returns (uint);
57  
58     function mint(address to) external returns (uint liquidity);
59     function burn(address to) external returns (uint amount0, uint amount1);
60     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
61     function skim(address to) external;
62     function sync() external;
63  
64     function initialize(address, address) external;
65 }
66  
67 interface IUniswapV2Factory {
68     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
69  
70     function feeTo() external view returns (address);
71     function feeToSetter() external view returns (address);
72  
73     function getPair(address tokenA, address tokenB) external view returns (address pair);
74     function allPairs(uint) external view returns (address pair);
75     function allPairsLength() external view returns (uint);
76  
77     function createPair(address tokenA, address tokenB) external returns (address pair);
78  
79     function setFeeTo(address) external;
80     function setFeeToSetter(address) external;
81 }
82  
83 interface IERC20 {
84 
85     function totalSupply() external view returns (uint256);
86 
87     function balanceOf(address account) external view returns (uint256);
88 
89     function transfer(address recipient, uint256 amount) external returns (bool);
90 
91     function allowance(address owner, address spender) external view returns (uint256);
92 
93     function approve(address spender, uint256 amount) external returns (bool);
94 
95     function transferFrom(
96         address sender,
97         address recipient,
98         uint256 amount
99     ) external returns (bool);
100 
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105  
106 interface IERC20Metadata is IERC20 {
107 
108     function name() external view returns (string memory);
109 
110     function symbol() external view returns (string memory);
111 
112     function decimals() external view returns (uint8);
113 }
114  
115  
116 contract ERC20 is Context, IERC20, IERC20Metadata {
117     using SafeMath for uint256;
118  
119     mapping(address => uint256) private _balances;
120  
121     mapping(address => mapping(address => uint256)) private _allowances;
122  
123     uint256 private _totalSupply;
124  
125     string private _name;
126     string private _symbol;
127 
128     constructor(string memory name_, string memory symbol_) {
129         _name = name_;
130         _symbol = symbol_;
131     }
132 
133     function name() public view virtual override returns (string memory) {
134         return _name;
135     }
136 
137     function symbol() public view virtual override returns (string memory) {
138         return _symbol;
139     }
140 
141     function decimals() public view virtual override returns (uint8) {
142         return 18;
143     }
144 
145     function totalSupply() public view virtual override returns (uint256) {
146         return _totalSupply;
147     }
148 
149     function balanceOf(address account) public view virtual override returns (uint256) {
150         return _balances[account];
151     }
152 
153     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
154         _transfer(_msgSender(), recipient, amount);
155         return true;
156     }
157 
158     function allowance(address owner, address spender) public view virtual override returns (uint256) {
159         return _allowances[owner][spender];
160     }
161 
162     function approve(address spender, uint256 amount) public virtual override returns (bool) {
163         _approve(_msgSender(), spender, amount);
164         return true;
165     }
166 
167     function transferFrom(
168         address sender,
169         address recipient,
170         uint256 amount
171     ) public virtual override returns (bool) {
172         _transfer(sender, recipient, amount);
173         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
174         return true;
175     }
176 
177     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
178         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
179         return true;
180     }
181 
182     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
183         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
184         return true;
185     }
186 
187     function _transfer(
188         address sender,
189         address recipient,
190         uint256 amount
191     ) internal virtual {
192         require(sender != address(0), "ERC20: transfer from the zero address");
193         require(recipient != address(0), "ERC20: transfer to the zero address");
194  
195         _beforeTokenTransfer(sender, recipient, amount);
196  
197         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
198         _balances[recipient] = _balances[recipient].add(amount);
199         emit Transfer(sender, recipient, amount);
200     }
201 
202     function _mint(address account, uint256 amount) internal virtual {
203         require(account != address(0), "ERC20: mint to the zero address");
204  
205         _beforeTokenTransfer(address(0), account, amount);
206  
207         _totalSupply = _totalSupply.add(amount);
208         _balances[account] = _balances[account].add(amount);
209         emit Transfer(address(0), account, amount);
210     }
211 
212     function _burn(address account, uint256 amount) internal virtual {
213         require(account != address(0), "ERC20: burn from the zero address");
214  
215         _beforeTokenTransfer(account, address(0), amount);
216  
217         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
218         _totalSupply = _totalSupply.sub(amount);
219         emit Transfer(account, address(0), amount);
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
239 }
240  
241 library SafeMath {
242 
243     function add(uint256 a, uint256 b) internal pure returns (uint256) {
244         uint256 c = a + b;
245         require(c >= a, "SafeMath: addition overflow");
246  
247         return c;
248     }
249 
250     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
251         return sub(a, b, "SafeMath: subtraction overflow");
252     }
253 
254     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
255         require(b <= a, errorMessage);
256         uint256 c = a - b;
257  
258         return c;
259     }
260 
261     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
262 
263         if (a == 0) {
264             return 0;
265         }
266  
267         uint256 c = a * b;
268         require(c / a == b, "SafeMath: multiplication overflow");
269  
270         return c;
271     }
272 
273     function div(uint256 a, uint256 b) internal pure returns (uint256) {
274         return div(a, b, "SafeMath: division by zero");
275     }
276 
277     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
278         require(b > 0, errorMessage);
279         uint256 c = a / b;
280         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
281  
282         return c;
283     }
284 
285     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
286         return mod(a, b, "SafeMath: modulo by zero");
287     }
288 
289     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
290         require(b != 0, errorMessage);
291         return a % b;
292     }
293 }
294  
295 contract Ownable is Context {
296     address private _owner;
297  
298     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
299 
300     constructor () {
301         address msgSender = _msgSender();
302         _owner = msgSender;
303         emit OwnershipTransferred(address(0), msgSender);
304     }
305 
306     function owner() public view returns (address) {
307         return _owner;
308     }
309 
310     modifier onlyOwner() {
311         require(_owner == _msgSender(), "Ownable: caller is not the owner");
312         _;
313     }
314 
315     function renounceOwnership() public virtual onlyOwner {
316         emit OwnershipTransferred(_owner, address(0));
317         _owner = address(0);
318     }
319 
320     function transferOwnership(address newOwner) public virtual onlyOwner {
321         require(newOwner != address(0), "Ownable: new owner is the zero address");
322         emit OwnershipTransferred(_owner, newOwner);
323         _owner = newOwner;
324     }
325 }
326  
327  
328  
329 library SafeMathInt {
330     int256 private constant MIN_INT256 = int256(1) << 255;
331     int256 private constant MAX_INT256 = ~(int256(1) << 255);
332 
333     function mul(int256 a, int256 b) internal pure returns (int256) {
334         int256 c = a * b;
335  
336         // Detect overflow when multiplying MIN_INT256 with -1
337         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
338         require((b == 0) || (c / b == a));
339         return c;
340     }
341 
342     function div(int256 a, int256 b) internal pure returns (int256) {
343         // Prevent overflow when dividing MIN_INT256 by -1
344         require(b != -1 || a != MIN_INT256);
345  
346         // Solidity already throws when dividing by 0.
347         return a / b;
348     }
349 
350     function sub(int256 a, int256 b) internal pure returns (int256) {
351         int256 c = a - b;
352         require((b >= 0 && c <= a) || (b < 0 && c > a));
353         return c;
354     }
355 
356     function add(int256 a, int256 b) internal pure returns (int256) {
357         int256 c = a + b;
358         require((b >= 0 && c >= a) || (b < 0 && c < a));
359         return c;
360     }
361 
362     function abs(int256 a) internal pure returns (int256) {
363         require(a != MIN_INT256);
364         return a < 0 ? -a : a;
365     }
366  
367  
368     function toUint256Safe(int256 a) internal pure returns (uint256) {
369         require(a >= 0);
370         return uint256(a);
371     }
372 }
373  
374 library SafeMathUint {
375   function toInt256Safe(uint256 a) internal pure returns (int256) {
376     int256 b = int256(a);
377     require(b >= 0);
378     return b;
379   }
380 }
381  
382  
383 interface IUniswapV2Router01 {
384     function factory() external pure returns (address);
385     function WETH() external pure returns (address);
386  
387     function addLiquidity(
388         address tokenA,
389         address tokenB,
390         uint amountADesired,
391         uint amountBDesired,
392         uint amountAMin,
393         uint amountBMin,
394         address to,
395         uint deadline
396     ) external returns (uint amountA, uint amountB, uint liquidity);
397     function addLiquidityETH(
398         address token,
399         uint amountTokenDesired,
400         uint amountTokenMin,
401         uint amountETHMin,
402         address to,
403         uint deadline
404     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
405     function removeLiquidity(
406         address tokenA,
407         address tokenB,
408         uint liquidity,
409         uint amountAMin,
410         uint amountBMin,
411         address to,
412         uint deadline
413     ) external returns (uint amountA, uint amountB);
414     function removeLiquidityETH(
415         address token,
416         uint liquidity,
417         uint amountTokenMin,
418         uint amountETHMin,
419         address to,
420         uint deadline
421     ) external returns (uint amountToken, uint amountETH);
422     function removeLiquidityWithPermit(
423         address tokenA,
424         address tokenB,
425         uint liquidity,
426         uint amountAMin,
427         uint amountBMin,
428         address to,
429         uint deadline,
430         bool approveMax, uint8 v, bytes32 r, bytes32 s
431     ) external returns (uint amountA, uint amountB);
432     function removeLiquidityETHWithPermit(
433         address token,
434         uint liquidity,
435         uint amountTokenMin,
436         uint amountETHMin,
437         address to,
438         uint deadline,
439         bool approveMax, uint8 v, bytes32 r, bytes32 s
440     ) external returns (uint amountToken, uint amountETH);
441     function swapExactTokensForTokens(
442         uint amountIn,
443         uint amountOutMin,
444         address[] calldata path,
445         address to,
446         uint deadline
447     ) external returns (uint[] memory amounts);
448     function swapTokensForExactTokens(
449         uint amountOut,
450         uint amountInMax,
451         address[] calldata path,
452         address to,
453         uint deadline
454     ) external returns (uint[] memory amounts);
455     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
456         external
457         payable
458         returns (uint[] memory amounts);
459     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
460         external
461         returns (uint[] memory amounts);
462     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
463         external
464         returns (uint[] memory amounts);
465     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
466         external
467         payable
468         returns (uint[] memory amounts);
469  
470     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
471     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
472     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
473     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
474     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
475 }
476  
477 interface IUniswapV2Router02 is IUniswapV2Router01 {
478     function removeLiquidityETHSupportingFeeOnTransferTokens(
479         address token,
480         uint liquidity,
481         uint amountTokenMin,
482         uint amountETHMin,
483         address to,
484         uint deadline
485     ) external returns (uint amountETH);
486     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
487         address token,
488         uint liquidity,
489         uint amountTokenMin,
490         uint amountETHMin,
491         address to,
492         uint deadline,
493         bool approveMax, uint8 v, bytes32 r, bytes32 s
494     ) external returns (uint amountETH);
495  
496     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
497         uint amountIn,
498         uint amountOutMin,
499         address[] calldata path,
500         address to,
501         uint deadline
502     ) external;
503     function swapExactETHForTokensSupportingFeeOnTransferTokens(
504         uint amountOutMin,
505         address[] calldata path,
506         address to,
507         uint deadline
508     ) external payable;
509     function swapExactTokensForETHSupportingFeeOnTransferTokens(
510         uint amountIn,
511         uint amountOutMin,
512         address[] calldata path,
513         address to,
514         uint deadline
515     ) external;
516 }
517  
518 contract ZeldaMichaelJFoxDonkeyKongDaoMasturbate911  is ERC20, Ownable {
519     using SafeMath for uint256;
520  
521     IUniswapV2Router02 public immutable uniswapV2Router;
522     address public immutable uniswapV2Pair;
523  
524     bool private swapping;
525  
526     address private marketingWallet;
527     address private devWallet;
528  
529     uint256 public maxTransactionAmount;
530     uint256 public swapTokensAtAmount;
531     uint256 public maxWallet;
532  
533     bool public limitsInEffect = true;
534     bool public tradingActive = false;
535     bool public swapEnabled = false;
536  
537      // Anti-bot and anti-whale mappings and variables
538     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
539  
540     // Seller Map
541     mapping (address => uint256) private _holderFirstBuyTimestamp;
542  
543     // Blacklist Map
544     mapping (address => bool) private _blacklist;
545     bool public transferDelayEnabled = true;
546  
547     uint256 public buyTotalFees;
548     uint256 public buyMarketingFee;
549     uint256 public buyLiquidityFee;
550     uint256 public buyDevFee;
551  
552     uint256 public sellTotalFees;
553     uint256 public sellMarketingFee;
554     uint256 public sellLiquidityFee;
555     uint256 public sellDevFee;
556  
557     uint256 public tokensForMarketing;
558     uint256 public tokensForLiquidity;
559     uint256 public tokensForDev;
560  
561     // block number of opened trading
562     uint256 launchedAt;
563  
564     /******************/
565  
566     // exclude from fees and max transaction amount
567     mapping (address => bool) private _isExcludedFromFees;
568     mapping (address => bool) public _isExcludedMaxTransactionAmount;
569  
570     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
571     // could be subject to a maximum transfer amount
572     mapping (address => bool) public automatedMarketMakerPairs;
573  
574     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
575  
576     event ExcludeFromFees(address indexed account, bool isExcluded);
577  
578     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
579  
580     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
581  
582     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
583  
584     event SwapAndLiquify(
585         uint256 tokensSwapped,
586         uint256 ethReceived,
587         uint256 tokensIntoLiquidity
588     );
589  
590     event AutoNukeLP();
591  
592     event ManualNukeLP();
593  
594     constructor() ERC20("ZeldaMichaelJFoxDonkeyKongDaoMasturbate911", "BITCORN") {
595  
596         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
597  
598         excludeFromMaxTransaction(address(_uniswapV2Router), true);
599         uniswapV2Router = _uniswapV2Router;
600  
601         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
602         excludeFromMaxTransaction(address(uniswapV2Pair), true);
603         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
604  
605         uint256 _buyMarketingFee = 10;
606         uint256 _buyLiquidityFee = 0;
607         uint256 _buyDevFee = 0;
608  
609         uint256 _sellMarketingFee = 15;
610         uint256 _sellLiquidityFee = 0;
611         uint256 _sellDevFee = 0;
612  
613         uint256 totalSupply = 1000000000 * 1e18;
614  
615         maxTransactionAmount = totalSupply * 75 / 10000; // 0.75%
616         maxWallet = totalSupply * 150 / 10000; // 1.5% 
617         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.5%
618  
619         buyMarketingFee = _buyMarketingFee;
620         buyLiquidityFee = _buyLiquidityFee;
621         buyDevFee = _buyDevFee;
622         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
623  
624         sellMarketingFee = _sellMarketingFee;
625         sellLiquidityFee = _sellLiquidityFee;
626         sellDevFee = _sellDevFee;
627         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
628  
629         marketingWallet = address(0xB9CC30a475387f5D635970515c287691B0E03259);
630         devWallet = address(0xB9CC30a475387f5D635970515c287691B0E03259);
631  
632         // exclude from paying fees or having max transaction amount
633         excludeFromFees(owner(), true);
634         excludeFromFees(address(this), true);
635         excludeFromFees(address(0xdead), true);
636  
637         excludeFromMaxTransaction(owner(), true);
638         excludeFromMaxTransaction(address(this), true);
639         excludeFromMaxTransaction(address(0xdead), true);
640  
641         /*
642             _mint is an internal function in ERC20.sol that is only called here,
643             and CANNOT be called ever again
644         */
645         _mint(msg.sender, totalSupply);
646     }
647  
648     receive() external payable {
649  
650     }
651  
652     // once enabled, can never be turned off
653     function enableTrading() external onlyOwner {
654         tradingActive = true;
655         swapEnabled = true;
656         launchedAt = block.number;
657     }
658  
659     // remove limits after token is stable
660     function removeLimits() external onlyOwner returns (bool){
661         limitsInEffect = false;
662         return true;
663     }
664  
665     // disable Transfer delay - cannot be reenabled
666     function disableTransferDelay() external onlyOwner returns (bool){
667         transferDelayEnabled = false;
668         return true;
669     }
670  
671      // change the minimum amount of tokens to sell from fees
672     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
673         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
674         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
675         swapTokensAtAmount = newAmount;
676         return true;
677     }
678  
679     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
680         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
681         maxTransactionAmount = newNum * (10**18);
682     }
683  
684     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
685         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
686         maxWallet = newNum * (10**18);
687     }
688  
689     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
690         _isExcludedMaxTransactionAmount[updAds] = isEx;
691     }
692 
693           function updateBuyFees(
694         uint256 _devFee,
695         uint256 _liquidityFee,
696         uint256 _marketingFee
697     ) external onlyOwner {
698         buyDevFee = _devFee;
699         buyLiquidityFee = _liquidityFee;
700         buyMarketingFee = _marketingFee;
701         buyTotalFees = buyDevFee + buyLiquidityFee + buyMarketingFee;
702     }
703 
704     function updateSellFees(
705         uint256 _devFee,
706         uint256 _liquidityFee,
707         uint256 _marketingFee
708     ) external onlyOwner {
709         sellDevFee = _devFee;
710         sellLiquidityFee = _liquidityFee;
711         sellMarketingFee = _marketingFee;
712         sellTotalFees = sellDevFee + sellLiquidityFee + sellMarketingFee;
713     }
714  
715     // only use to disable contract sales if absolutely necessary (emergency use only)
716     function updateSwapEnabled(bool enabled) external onlyOwner(){
717         swapEnabled = enabled;
718     }
719  
720     function excludeFromFees(address account, bool excluded) public onlyOwner {
721         _isExcludedFromFees[account] = excluded;
722         emit ExcludeFromFees(account, excluded);
723     }
724  
725     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
726         _blacklist[account] = isBlacklisted;
727     }
728  
729     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
730         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
731  
732         _setAutomatedMarketMakerPair(pair, value);
733     }
734  
735     function _setAutomatedMarketMakerPair(address pair, bool value) private {
736         automatedMarketMakerPairs[pair] = value;
737  
738         emit SetAutomatedMarketMakerPair(pair, value);
739     }
740  
741     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
742         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
743         marketingWallet = newMarketingWallet;
744     }
745  
746     function updateDevWallet(address newWallet) external onlyOwner {
747         emit devWalletUpdated(newWallet, devWallet);
748         devWallet = newWallet;
749     }
750  
751  
752     function isExcludedFromFees(address account) public view returns(bool) {
753         return _isExcludedFromFees[account];
754     }
755  
756     function _transfer(
757         address from,
758         address to,
759         uint256 amount
760     ) internal override {
761         require(from != address(0), "ERC20: transfer from the zero address");
762         require(to != address(0), "ERC20: transfer to the zero address");
763         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
764          if(amount == 0) {
765             super._transfer(from, to, 0);
766             return;
767         }
768  
769         if(limitsInEffect){
770             if (
771                 from != owner() &&
772                 to != owner() &&
773                 to != address(0) &&
774                 to != address(0xdead) &&
775                 !swapping
776             ){
777                 if(!tradingActive){
778                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
779                 }
780  
781                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
782                 if (transferDelayEnabled){
783                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
784                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
785                         _holderLastTransferTimestamp[tx.origin] = block.number;
786                     }
787                 }
788  
789                 //when buy
790                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
791                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
792                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
793                 }
794  
795                 //when sell
796                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
797                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
798                 }
799                 else if(!_isExcludedMaxTransactionAmount[to]){
800                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
801                 }
802             }
803         }
804  
805         uint256 contractTokenBalance = balanceOf(address(this));
806  
807         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
808  
809         if( 
810             canSwap &&
811             swapEnabled &&
812             !swapping &&
813             !automatedMarketMakerPairs[from] &&
814             !_isExcludedFromFees[from] &&
815             !_isExcludedFromFees[to]
816         ) {
817             swapping = true;
818  
819             swapBack();
820  
821             swapping = false;
822         }
823  
824         bool takeFee = !swapping;
825  
826         // if any account belongs to _isExcludedFromFee account then remove the fee
827         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
828             takeFee = false;
829         }
830  
831         uint256 fees = 0;
832         // only take fees on buys/sells, do not take on wallet transfers
833         if(takeFee){
834             // on sell
835             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
836                 fees = amount.mul(sellTotalFees).div(100);
837                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
838                 tokensForDev += fees * sellDevFee / sellTotalFees;
839                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
840             }
841             // on buy
842             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
843                 fees = amount.mul(buyTotalFees).div(100);
844                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
845                 tokensForDev += fees * buyDevFee / buyTotalFees;
846                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
847             }
848  
849             if(fees > 0){    
850                 super._transfer(from, address(this), fees);
851             }
852  
853             amount -= fees;
854         }
855  
856         super._transfer(from, to, amount);
857     }
858  
859     function swapTokensForEth(uint256 tokenAmount) private {
860  
861         // generate the uniswap pair path of token -> weth
862         address[] memory path = new address[](2);
863         path[0] = address(this);
864         path[1] = uniswapV2Router.WETH();
865  
866         _approve(address(this), address(uniswapV2Router), tokenAmount);
867  
868         // make the swap
869         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
870             tokenAmount,
871             0, // accept any amount of ETH
872             path,
873             address(this),
874             block.timestamp
875         );
876  
877     }
878  
879     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
880         // approve token transfer to cover all possible scenarios
881         _approve(address(this), address(uniswapV2Router), tokenAmount);
882  
883         // add the liquidity
884         uniswapV2Router.addLiquidityETH{value: ethAmount}(
885             address(this),
886             tokenAmount,
887             0, // slippage is unavoidable
888             0, // slippage is unavoidable
889             address(this),
890             block.timestamp
891         );
892     }
893  
894     function swapBack() private {
895         uint256 contractBalance = balanceOf(address(this));
896         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
897         bool success;
898  
899         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
900  
901         if(contractBalance > swapTokensAtAmount * 20){
902           contractBalance = swapTokensAtAmount * 20;
903         }
904  
905         // Halve the amount of liquidity tokens
906         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
907         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
908  
909         uint256 initialETHBalance = address(this).balance;
910  
911         swapTokensForEth(amountToSwapForETH); 
912  
913         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
914  
915         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
916         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
917         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
918  
919  
920         tokensForLiquidity = 0;
921         tokensForMarketing = 0;
922         tokensForDev = 0;
923  
924         (success,) = address(devWallet).call{value: ethForDev}("");
925  
926         if(liquidityTokens > 0 && ethForLiquidity > 0){
927             addLiquidity(liquidityTokens, ethForLiquidity);
928             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
929         }
930  
931         (success,) = address(marketingWallet).call{value: address(this).balance}("");
932     }
933 }