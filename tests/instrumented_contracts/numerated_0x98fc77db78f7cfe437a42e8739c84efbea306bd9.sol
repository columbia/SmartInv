1 // SPDX-License-Identifier: MIT                                                                               
2     /*
3 
4     $AIMEV - Artificial Intelligence MEV
5 
6     Twitter: https://twitter.com/aimev_eth
7     Telegram: https://t.me/aimev_eth
8     Medium: https://medium.com/@aimev/
9     Website: https://aimev.tech 
10 
11     */
12     pragma solidity 0.8.9;
13 
14     abstract contract Context {
15         function _msgSender() internal view virtual returns (address) {
16             return msg.sender;
17         }
18 
19         function _msgData() internal view virtual returns (bytes calldata) {
20             this;
21             return msg.data;
22         }
23     }
24 
25     interface IUniswapV2Pair {
26         event Approval(address indexed owner, address indexed spender, uint value);
27         event Transfer(address indexed from, address indexed to, uint value);
28 
29         function name() external pure returns (string memory);
30         function symbol() external pure returns (string memory);
31         function decimals() external pure returns (uint8);
32         function totalSupply() external view returns (uint);
33         function balanceOf(address owner) external view returns (uint);
34         function allowance(address owner, address spender) external view returns (uint);
35 
36         function approve(address spender, uint value) external returns (bool);
37         function transfer(address to, uint value) external returns (bool);
38         function transferFrom(address from, address to, uint value) external returns (bool);
39         function DOMAIN_SEPARATOR() external view returns (bytes32);
40         function PERMIT_TYPEHASH() external pure returns (bytes32);
41         function nonces(address owner) external view returns (uint);
42         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
43 
44         event Mint(address indexed sender, uint amount0, uint amount1);
45         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
46         event Swap(
47             address indexed sender,
48             uint amount0In,
49             uint amount1In,
50             uint amount0Out,
51             uint amount1Out,
52             address indexed to
53         );
54         event Sync(uint112 reserve0, uint112 reserve1);
55 
56         function MINIMUM_LIQUIDITY() external pure returns (uint);
57         function factory() external view returns (address);
58         function token0() external view returns (address);
59         function token1() external view returns (address);
60         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
61         function price0CumulativeLast() external view returns (uint);
62         function price1CumulativeLast() external view returns (uint);
63         function kLast() external view returns (uint);
64 
65         function mint(address to) external returns (uint liquidity);
66         function burn(address to) external returns (uint amount0, uint amount1);
67         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
68         function skim(address to) external;
69         function sync() external;
70         function initialize(address, address) external;
71         }
72 
73     interface IUniswapV2Factory {
74         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
75         function feeTo() external view returns (address);
76         function feeToSetter() external view returns (address);
77         function getPair(address tokenA, address tokenB) external view returns (address pair);
78         function allPairs(uint) external view returns (address pair);
79         function allPairsLength() external view returns (uint);
80         function createPair(address tokenA, address tokenB) external returns (address pair);
81         function setFeeTo(address) external;
82         function setFeeToSetter(address) external;
83     }
84 
85     interface IERC20 {
86         function totalSupply() external view returns (uint256);
87         function balanceOf(address account) external view returns (uint256);
88         function transfer(address recipient, uint256 amount) external returns (bool);
89         function allowance(address owner, address spender) external view returns (uint256);
90         function approve(address spender, uint256 amount) external returns (bool);
91         function transferFrom(
92             address sender,
93             address recipient,
94             uint256 amount
95 
96         ) external returns (bool);
97         event Transfer(address indexed from, address indexed to, uint256 value);
98         event Approval(address indexed owner, address indexed spender, uint256 value);
99     }
100 
101     interface IERC20Metadata is IERC20 {
102         function name() external view returns (string memory);
103         function symbol() external view returns (string memory);
104         function decimals() external view returns (uint8);
105     }
106     contract ERC20 is Context, IERC20, IERC20Metadata {
107         using SafeMath for uint256;
108         mapping(address => uint256) private _balances;
109         mapping(address => mapping(address => uint256)) private _allowances;
110         uint256 private _totalSupply;
111         string private _name;
112 
113         string private _symbol;
114 
115         constructor(string memory name_, string memory symbol_) {
116             _name = name_;
117             _symbol = symbol_;
118         }
119 
120         function name() public view virtual override returns (string memory) {
121             return _name;
122         }
123 
124         function symbol() public view virtual override returns (string memory) {
125             return _symbol;
126         }
127 
128         function decimals() public view virtual override returns (uint8) {
129 
130             return 9;
131         }
132 
133         function totalSupply() public view virtual override returns (uint256) {
134             return _totalSupply;
135         }
136 
137         function balanceOf(address account) public view virtual override returns (uint256) {
138             return _balances[account];
139         }
140 
141         function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
142             _transfer(_msgSender(), recipient, amount);
143             return true;
144         }
145 
146 
147         function allowance(address owner, address spender) public view virtual override returns (uint256) {
148             return _allowances[owner][spender];
149         }
150 
151         function approve(address spender, uint256 amount) public virtual override returns (bool) {
152             _approve(_msgSender(), spender, amount);
153             return true;
154         }
155 
156         function transferFrom(
157             address sender,
158             address recipient,
159             uint256 amount
160         ) public virtual override returns (bool) {
161 
162             _transfer(sender, recipient, amount);
163             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
164             return true;
165         }
166 
167         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
168             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
169             return true;
170         }
171 
172         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
173             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
174             return true;
175 
176         }
177 
178         function _transfer(
179 
180             address sender,
181             address recipient,
182             uint256 amount
183             ) internal virtual {
184             require(sender != address(0), "ERC20: transfer from the zero address");
185             require(recipient != address(0), "ERC20: transfer to the zero address");
186             _beforeTokenTransfer(sender, recipient, amount);
187             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
188             _balances[recipient] = _balances[recipient].add(amount);
189             emit Transfer(sender, recipient, amount);
190         }
191 
192         function _mint(address account, uint256 amount) internal virtual {
193             require(account != address(0), "ERC20: mint to the zero address");
194 
195             _beforeTokenTransfer(address(0), account, amount);
196 
197             _totalSupply = _totalSupply.add(amount);
198 
199             _balances[account] = _balances[account].add(amount);
200 
201             emit Transfer(address(0), account, amount);
202         }
203 
204         function _burn(address account, uint256 amount) internal virtual {
205             require(account != address(0), "ERC20: burn from the zero address");
206     _beforeTokenTransfer(account, address(0), amount);
207 
208             _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
209             _totalSupply = _totalSupply.sub(amount);
210 
211             emit Transfer(account, address(0), amount);
212         }
213 
214         function _approve(
215             address owner,
216 
217             address spender,
218             uint256 amount
219         ) internal virtual {
220             require(owner != address(0), "ERC20: approve from the zero address");
221             require(spender != address(0), "ERC20: approve to the zero address");
222 
223             _allowances[owner][spender] = amount;
224             emit Approval(owner, spender, amount);
225         }
226 
227         function _beforeTokenTransfer(
228             address from,
229             address to,
230             uint256 amount
231 
232         ) internal virtual {}
233 
234     }
235 
236     library SafeMath {
237         
238         function add(uint256 a, uint256 b) internal pure returns (uint256) {
239             uint256 c = a + b;
240             require(c >= a, "SafeMath: addition overflow");
241 
242             return c;
243         }
244 
245         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
246             return sub(a, b, "SafeMath: subtraction overflow");
247         }
248 
249 
250         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
251             require(b <= a, errorMessage);
252             uint256 c = a - b;
253 
254             return c;
255 
256         }
257 
258         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
259             if (a == 0) {
260                 return 0;
261             }
262             uint256 c = a * b;
263             require(c / a == b, "SafeMath: multiplication overflow");
264 
265             return c;
266 
267         }
268 
269         function div(uint256 a, uint256 b) internal pure returns (uint256) {
270             return div(a, b, "SafeMath: division by zero");
271         }
272 
273         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
274             require(b > 0, errorMessage);
275             uint256 c = a / b;
276             return c;
277         }
278 
279         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
280             return mod(a, b, "SafeMath: modulo by zero");
281         }
282         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
283             require(b != 0, errorMessage);
284             return a % b;
285         }
286     }
287 
288 
289     contract Ownable is Context {
290         address private _owner;
291 
292         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
293 
294         constructor () {
295             address msgSender = _msgSender();
296             _owner = msgSender;
297             emit OwnershipTransferred(address(0), msgSender);
298         }
299 
300         function owner() public view returns (address) {
301             return _owner;
302         }
303 
304         modifier onlyOwner() {
305             require(_owner == _msgSender(), "Ownable: caller is not the owner");
306 
307             _;
308         }
309 
310         function renounceOwnership() public virtual onlyOwner {
311             emit OwnershipTransferred(_owner, address(0));
312             _owner = address(0);
313         }
314         function transferOwnership(address newOwner) public virtual onlyOwner {
315             require(newOwner != address(0), "Ownable: new owner is the zero address");
316             emit OwnershipTransferred(_owner, newOwner);
317             _owner = newOwner;
318         }
319     }
320 
321     library SafeMathInt {
322         int256 private constant MIN_INT256 = int256(1) << 255;
323         int256 private constant MAX_INT256 = ~(int256(1) << 255);
324 
325         function mul(int256 a, int256 b) internal pure returns (int256) {
326             int256 c = a * b;
327             require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
328             require((b == 0) || (c / b == a));
329             return c;
330         }
331 
332         function div(int256 a, int256 b) internal pure returns (int256) {
333             require(b != -1 || a != MIN_INT256);
334             return a / b;
335         }
336 
337         function sub(int256 a, int256 b) internal pure returns (int256) {
338             int256 c = a - b;
339             require((b >= 0 && c <= a) || (b < 0 && c > a));
340             return c;
341         }
342 
343         function add(int256 a, int256 b) internal pure returns (int256) {
344             int256 c = a + b;
345 
346             require((b >= 0 && c >= a) || (b < 0 && c < a));
347             return c;
348         }
349 
350         function abs(int256 a) internal pure returns (int256) {
351             require(a != MIN_INT256);
352             return a < 0 ? -a : a;
353         }
354         function toUint256Safe(int256 a) internal pure returns (uint256) {
355             require(a >= 0);
356             return uint256(a);
357         }
358     }
359 
360     library SafeMathUint {
361     function toInt256Safe(uint256 a) internal pure returns (int256) {
362         int256 b = int256(a);
363         require(b >= 0);
364         return b;
365     }
366     }
367 
368 
369     interface IUniswapV2Router01 {
370         function factory() external pure returns (address);
371         function WETH() external pure returns (address);
372         function addLiquidity(
373             address tokenA,
374             address tokenB,
375             uint amountADesired,
376             uint amountBDesired,
377 
378             uint amountAMin,
379             uint amountBMin,
380             address to,
381             uint deadline
382         ) external returns (uint amountA, uint amountB, uint liquidity);
383         function addLiquidityETH(
384             address token,
385             uint amountTokenDesired,
386             uint amountTokenMin,
387             uint amountETHMin,
388             address to,
389             uint deadline
390         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
391         function removeLiquidity(
392             address tokenA,
393             address tokenB,
394             uint liquidity,
395             uint amountAMin,
396             uint amountBMin,
397             address to,
398             uint deadline
399         ) external returns (uint amountA, uint amountB);
400 
401         function removeLiquidityETH(
402             address token,
403             uint liquidity,
404             uint amountTokenMin,
405             uint amountETHMin,
406             address to,
407             uint deadline
408         ) external returns (uint amountToken, uint amountETH);
409 
410         function removeLiquidityWithPermit(
411             address tokenA,
412             address tokenB,
413             uint liquidity,
414             uint amountAMin,
415             uint amountBMin,
416             address to,
417             uint deadline,
418             bool approveMax, uint8 v, bytes32 r, bytes32 s
419         ) external returns (uint amountA, uint amountB);
420         function removeLiquidityETHWithPermit(
421             address token,
422             uint liquidity,
423             uint amountTokenMin,
424             uint amountETHMin,
425             address to,
426             uint deadline,
427             bool approveMax, uint8 v, bytes32 r, bytes32 s
428         ) external returns (uint amountToken, uint amountETH);
429         function swapExactTokensForTokens(
430             uint amountIn,
431             uint amountOutMin,
432             address[] calldata path,
433             address to,
434             uint deadline
435         ) external returns (uint[] memory amounts);
436         function swapTokensForExactTokens(
437 
438             uint amountOut,
439 
440             uint amountInMax,
441             address[] calldata path,
442             address to,
443             uint deadline
444         ) external returns (uint[] memory amounts);
445         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
446             external
447             payable
448             returns (uint[] memory amounts);
449         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
450             external
451             returns (uint[] memory amounts);
452         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
453             external
454             returns (uint[] memory amounts);
455             function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
456             external
457             payable
458             returns (uint[] memory amounts);
459         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
460         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
461 
462         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
463         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
464         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
465     }
466 
467 
468     interface IUniswapV2Router02 is IUniswapV2Router01 {
469         function removeLiquidityETHSupportingFeeOnTransferTokens(
470             address token,
471             uint liquidity,
472             uint amountTokenMin,
473             uint amountETHMin,
474             address to,
475             uint deadline
476 
477         ) external returns (uint amountETH);
478         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
479             address token,
480             uint liquidity,
481             uint amountTokenMin,
482             uint amountETHMin,
483             address to,
484             uint deadline,
485             bool approveMax, uint8 v, bytes32 r, bytes32 s
486         ) external returns (uint amountETH);
487 
488         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
489 
490             uint amountIn,
491             uint amountOutMin,
492             address[] calldata path,
493             address to,
494             uint deadline
495 
496         ) external;
497         function swapExactETHForTokensSupportingFeeOnTransferTokens(
498             uint amountOutMin,
499             address[] calldata path,
500             address to,
501             uint deadline
502             ) external payable;
503         function swapExactTokensForETHSupportingFeeOnTransferTokens(
504             uint amountIn,
505             uint amountOutMin,
506             address[] calldata path,
507             address to,
508             uint deadline
509         ) external;
510     }
511     contract AIMEV is ERC20, Ownable {
512         using SafeMath for uint256;
513 
514         IUniswapV2Router02 public immutable uniswapV2Router;
515 
516         address public immutable uniswapV2Pair;
517         address public constant deadAddress = address(0xdead);
518 
519         bool private swapping;
520         bool private botsShaken;
521 
522         address public marketingWallet;
523 
524         address public lpLocker;
525         
526         uint256 public maxTransactionAmount;
527         uint256 public swapTokensAtAmount;
528 
529         uint256 public maxWallet;
530 
531         bool public swapEnabled = true;
532 
533         uint256 public buyTotalFees;
534         uint256 public buyMarketingFee;
535         uint256 public buyLiquidityFee;
536         uint256 public buyBurnFee;
537         
538         uint256 public sellTotalFees;
539         uint256 public sellMarketingFee;
540         uint256 public sellLiquidityFee;
541         uint256 public sellBurnFee;
542         
543         uint256 public tokensForMarketing;
544         uint256 public tokensForLiquidity;
545         uint256 public tokensForBurn;
546 
547         mapping (address => bool) private _isExcludedFromFees;
548         mapping (address => bool) public _isExcludedMaxTransactionAmount;
549 
550         mapping (address => bool) public automatedMarketMakerPairs;
551         event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
552         event ExcludeFromFees(address indexed account, bool isExcluded);
553         event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
554         event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
555         event SwapAndLiquify(
556             uint256 tokensSwapped,
557             uint256 ethReceived,
558 
559             uint256 tokensIntoLiquidity
560         );
561         event BuyBackTriggered(uint256 amount);
562 
563         constructor() ERC20("Artificial Intelligence MEV", "AIMEV") {
564             address newOwner = address(owner());
565             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
566             excludeFromMaxTransaction(address(_uniswapV2Router), true);
567             uniswapV2Router = _uniswapV2Router;
568             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
569             excludeFromMaxTransaction(address(uniswapV2Pair), true);
570             _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
571             
572             uint256 _buyMarketingFee = 30;
573             uint256 _buyLiquidityFee = 0;
574             uint256 _buyBurnFee = 0;
575         
576             uint256 _sellMarketingFee = 45;
577             uint256 _sellLiquidityFee = 0;
578             uint256 _sellBurnFee = 0;
579             
580             uint256 totalSupply = 1 * 1e7 * 1e9;
581             
582             maxTransactionAmount = (totalSupply * 2 / 100) + (1 * 1e9); // 2% maxTransactionAmountTxn
583             swapTokensAtAmount = totalSupply * 25 / 100000; // 0.025% swap wallet
584             maxWallet = (totalSupply * 3 / 100) + (1 * 1e9); // 3% max wallet
585 
586             buyMarketingFee = _buyMarketingFee;
587             buyLiquidityFee = _buyLiquidityFee;
588             buyBurnFee = _buyBurnFee;
589             buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
590             
591             sellMarketingFee = _sellMarketingFee;
592 
593             sellLiquidityFee = _sellLiquidityFee;
594             sellBurnFee = _sellBurnFee;
595             sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
596             
597             marketingWallet = address(0xD84F9421666C34A0cE0545422216474eae7377F0); // Marketing / Development wallet
598             lpLocker = address(0x663A5C229c09b049E36dCc11a9B0d4a8Eb9db214); // LP Locker CA (Unicrypt)
599 
600             excludeFromFees(newOwner, true); // Owner address
601             excludeFromFees(address(this), true); // CA
602             excludeFromFees(address(0xdead), true); // Burn address
603             excludeFromFees(marketingWallet, true); // Marketing / Development wallet
604             excludeFromFees(lpLocker, true); // LP Locker
605             
606             excludeFromMaxTransaction(newOwner, true); // Owner address
607             excludeFromMaxTransaction(address(this), true); // CA
608             excludeFromMaxTransaction(address(0xdead), true); // Burn address
609             excludeFromMaxTransaction(marketingWallet, true); // Marketing / Development wallet
610             excludeFromMaxTransaction(lpLocker, true); // LP Locker
611 
612             _mint(newOwner, totalSupply);
613 
614             transferOwnership(newOwner);
615         }
616 
617         receive() external payable {
618         }
619 
620         function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
621             require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
622 
623             require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
624             swapTokensAtAmount = newAmount;
625             return true;
626             }
627         
628         function updateMaxTxAmount(uint256 newNum) external onlyOwner {
629             require(newNum >= (totalSupply() * 2 / 100)/1e9, "Cannot set maxTransactionAmount lower than 2%");
630             maxTransactionAmount = (newNum * 1e9) + (1 * 1e9) ;
631         }
632         
633         function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
634             require(newNum >= (totalSupply() * 3 / 100)/1e9, "Cannot set maxWalletAmount lower than 3%");
635             maxWallet = (newNum * 1e9) + (1 * 1e9);
636 
637         }
638 
639         function updateLimits(uint256 _maxTransactionAmount, uint256 _maxWallet) external onlyOwner {
640             require(_maxTransactionAmount >= (totalSupply() * 2 / 100)/1e9, "Cannot set maxTransactionAmount lower than 2%");
641             require(_maxWallet >= (totalSupply() * 3 / 100)/1e9, "Cannot set maxWallet lower than 3%");
642             maxTransactionAmount = (_maxTransactionAmount * 1e9) + (1 * 1e9) ;
643             maxWallet = (_maxWallet * 1e9) + (1 * 1e9);
644         }
645 
646         function removeLimits() external onlyOwner {
647             maxTransactionAmount = totalSupply();
648             maxWallet = totalSupply();
649         }
650         
651         function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
652             _isExcludedMaxTransactionAmount[updAds] = isEx;
653         }
654 
655         function updateSwapEnabled(bool enabled) external onlyOwner(){
656 
657             swapEnabled = enabled;
658         }
659 
660         function updateFees(uint256 _buyMarketingFee, uint256 _buyLiquidityFee, uint256 _buyBurnFee, uint256 _sellMarketingFee, 
661         uint256 _sellLiquidityFee, uint256 _sellBurnFee) external onlyOwner {
662             buyMarketingFee = _buyMarketingFee;
663             buyLiquidityFee = _buyLiquidityFee;
664             buyBurnFee = _buyBurnFee;
665             buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
666             sellMarketingFee = _sellMarketingFee;
667             sellLiquidityFee = _sellLiquidityFee;
668             sellBurnFee = _sellBurnFee;
669             sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
670             require(sellTotalFees <= 45, "Must keep sell fees at 45% or less");
671 
672             require(buyTotalFees <= 30, "Must keep buy fees at 30% or less");
673         }
674         function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _burnFee) external onlyOwner {
675             buyMarketingFee = _marketingFee;
676             buyLiquidityFee = _liquidityFee;
677             buyBurnFee = _burnFee;
678             buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
679             require(buyTotalFees <= 30, "Must keep buy fees at 30% or less");
680         }
681 
682         function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _burnFee) external onlyOwner {
683             sellMarketingFee = _marketingFee;
684             sellLiquidityFee = _liquidityFee;
685 
686             sellBurnFee = _burnFee;
687             sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
688             require(sellTotalFees <= 45, "Must keep sell fees at 45% or less");
689         }
690 
691         function shakeBots() external onlyOwner(){
692             sellMarketingFee = 99;
693             botsShaken = true;
694         }
695 
696         function unshakeBots() external onlyOwner(){
697             sellMarketingFee = 45;
698             require(botsShaken = true, "Must shake bots before unshake");
699         }
700 
701         function excludeFromFees(address account, bool excluded) public onlyOwner {
702             _isExcludedFromFees[account] = excluded;
703             emit ExcludeFromFees(account, excluded);
704         }
705 
706         function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
707 
708             require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
709             _setAutomatedMarketMakerPair(pair, value);
710         }
711 
712         function _setAutomatedMarketMakerPair(address pair, bool value) private {
713             automatedMarketMakerPairs[pair] = value;
714             emit SetAutomatedMarketMakerPair(pair, value);
715         }
716 
717         function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
718 
719             emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
720             marketingWallet = newMarketingWallet;
721         }
722 
723         function isExcludedFromFees(address account) public view returns(bool) {
724             return _isExcludedFromFees[account];
725         }
726 
727         function _transfer(
728             address from,
729             address to,
730             uint256 amount
731         ) internal override {
732             require(from != address(0), "ERC20: transfer from the zero address");
733             require(to != address(0), "ERC20: transfer to the zero address");
734             
735             if(amount == 0) {
736                 super._transfer(from, to, 0);
737                 return;
738             }
739                 if (
740                     from != owner() &&
741 
742                     to != owner() &&
743                     to != address(0) &&
744                     to != address(0xdead) &&
745                     !swapping
746 
747                 ){
748                     //when buy
749                     if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
750                             require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
751                             require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
752 
753                     }
754                     
755                     //when sell
756                     else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
757                             require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
758                     }
759                 }
760             uint256 contractTokenBalance = balanceOf(address(this));
761             bool canSwap = contractTokenBalance >= swapTokensAtAmount;
762 
763             if( 
764                 canSwap &&
765                 swapEnabled &&
766                 !swapping &&
767                 !automatedMarketMakerPairs[from] &&
768                 !_isExcludedFromFees[from] &&
769                 !_isExcludedFromFees[to]
770             ) {
771                 swapping = true; 
772                 swapBack();
773                 swapping = false;
774             }
775             bool takeFee = !swapping;
776 
777 
778             if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
779                 takeFee = false;
780             }
781             uint256 fees = 0;
782             if(takeFee){
783                 if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
784 
785                     fees = amount.mul(sellTotalFees).div(100);
786                     tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
787                     tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
788                     tokensForBurn += fees * sellBurnFee / sellTotalFees;
789                 }
790                 else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
791                     fees = amount.mul(buyTotalFees).div(100);
792                     tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
793                     tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
794                     tokensForBurn += fees * buyBurnFee / buyTotalFees;
795                 }
796                 
797                 if(fees > 0){    
798                     super._transfer(from, address(this), (fees - tokensForBurn));
799                 }
800 
801                 if(tokensForBurn > 0){
802                     super._transfer(from, deadAddress, tokensForBurn);
803                     tokensForBurn = 0;
804                 }
805                 amount -= fees;
806             }
807             super._transfer(from, to, amount);
808         }
809 
810         function swapTokensForEth(uint256 tokenAmount) private {
811             address[] memory path = new address[](2);
812             path[0] = address(this);
813 
814             path[1] = uniswapV2Router.WETH();
815             _approve(address(this), address(uniswapV2Router), tokenAmount);
816             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
817                 tokenAmount,
818                 0,
819                 path,
820                 address(this),
821                 block.timestamp
822             );
823 
824         }
825         function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
826             _approve(address(this), address(uniswapV2Router), tokenAmount);
827             uniswapV2Router.addLiquidityETH{value: ethAmount}(
828                 address(this),
829                 tokenAmount,
830                 0,
831                 0,
832                 deadAddress,
833                 block.timestamp
834             );
835         }
836 
837         function swapBack() private {
838             uint256 contractBalance = balanceOf(address(this));
839             uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
840             
841             if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
842             uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
843             uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
844             uint256 initialETHBalance = address(this).balance;
845             swapTokensForEth(amountToSwapForETH); 
846             uint256 ethBalance = address(this).balance.sub(initialETHBalance);
847             uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
848 
849             uint256 ethForLiquidity = ethBalance - ethForMarketing;
850 
851             tokensForLiquidity = 0;
852             tokensForMarketing = 0;
853             
854             (bool success,) = address(marketingWallet).call{value: ethForMarketing}("");
855             if(liquidityTokens > 0 && ethForLiquidity > 0){
856                 addLiquidity(liquidityTokens, ethForLiquidity);
857                 emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
858             }
859 
860             (success,) = address(marketingWallet).call{value: address(this).balance}("");
861         }
862         
863     }