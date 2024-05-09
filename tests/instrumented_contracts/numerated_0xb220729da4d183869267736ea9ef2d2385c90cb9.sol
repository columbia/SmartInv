1 // SPDX-License-Identifier: MIT                                                                               
2     /*
3 
4     $VOLXY - Volxy Inu
5 
6     Volxy has a crazy crush for Volt Inu. On this Valentine's day, 
7     Volxy will go above and beyond for her crush 💕
8 
9     Twitter: https://twitter.com/volxyinu
10     Telegram: https://t.me/volxyinu
11     Medium: https://medium.com/@volxyinu/
12     Website: https://volxyinu.com/
13 
14     */
15     pragma solidity 0.8.9;
16 
17     abstract contract Context {
18         function _msgSender() internal view virtual returns (address) {
19             return msg.sender;
20         }
21 
22         function _msgData() internal view virtual returns (bytes calldata) {
23             this;
24             return msg.data;
25         }
26     }
27 
28     interface IUniswapV2Pair {
29         event Approval(address indexed owner, address indexed spender, uint value);
30         event Transfer(address indexed from, address indexed to, uint value);
31 
32         function name() external pure returns (string memory);
33         function symbol() external pure returns (string memory);
34         function decimals() external pure returns (uint8);
35         function totalSupply() external view returns (uint);
36         function balanceOf(address owner) external view returns (uint);
37         function allowance(address owner, address spender) external view returns (uint);
38         function approve(address spender, uint value) external returns (bool);
39         function transfer(address to, uint value) external returns (bool);
40         function transferFrom(address from, address to, uint value) external returns (bool);
41         function DOMAIN_SEPARATOR() external view returns (bytes32);
42         function PERMIT_TYPEHASH() external pure returns (bytes32);
43         function nonces(address owner) external view returns (uint);
44         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
45 
46         event Mint(address indexed sender, uint amount0, uint amount1);
47         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
48         event Swap(
49             address indexed sender,
50             uint amount0In,
51             uint amount1In,
52             uint amount0Out,
53             uint amount1Out,
54             address indexed to
55         );
56         event Sync(uint112 reserve0, uint112 reserve1);
57 
58         function MINIMUM_LIQUIDITY() external pure returns (uint);
59         function factory() external view returns (address);
60         function token0() external view returns (address);
61         function token1() external view returns (address);
62         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
63         function price0CumulativeLast() external view returns (uint);
64         function price1CumulativeLast() external view returns (uint);
65         function kLast() external view returns (uint);
66         function mint(address to) external returns (uint liquidity);
67         function burn(address to) external returns (uint amount0, uint amount1);
68         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
69         function skim(address to) external;
70         function sync() external;
71         function initialize(address, address) external;
72         }
73 
74     interface IUniswapV2Factory {
75         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
76         function feeTo() external view returns (address);
77         function feeToSetter() external view returns (address);
78         function getPair(address tokenA, address tokenB) external view returns (address pair);
79         function allPairs(uint) external view returns (address pair);
80         function allPairsLength() external view returns (uint);
81         function createPair(address tokenA, address tokenB) external returns (address pair);
82         function setFeeTo(address) external;
83         function setFeeToSetter(address) external;
84     }
85 
86     interface IERC20 {
87         function totalSupply() external view returns (uint256);
88         function balanceOf(address account) external view returns (uint256);
89         function transfer(address recipient, uint256 amount) external returns (bool);
90         function allowance(address owner, address spender) external view returns (uint256);
91         function approve(address spender, uint256 amount) external returns (bool);
92         function transferFrom(
93             address sender,
94             address recipient,
95             uint256 amount
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
129             return 9;
130         }
131 
132         function totalSupply() public view virtual override returns (uint256) {
133             return _totalSupply;
134         }
135 
136         function balanceOf(address account) public view virtual override returns (uint256) {
137             return _balances[account];
138         }
139 
140         function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
141             _transfer(_msgSender(), recipient, amount);
142             return true;
143         }
144 
145 
146         function allowance(address owner, address spender) public view virtual override returns (uint256) {
147             return _allowances[owner][spender];
148         }
149 
150         function approve(address spender, uint256 amount) public virtual override returns (bool) {
151             _approve(_msgSender(), spender, amount);
152             return true;
153         }
154 
155         function transferFrom(
156             address sender,
157             address recipient,
158             uint256 amount
159         ) public virtual override returns (bool) {
160             _transfer(sender, recipient, amount);
161             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
162             return true;
163         }
164 
165         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
166             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
167             return true;
168         }
169 
170         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
171             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
172             return true;
173 
174         }
175 
176         function _transfer(
177 
178             address sender,
179             address recipient,
180             uint256 amount
181             ) internal virtual {
182             require(sender != address(0), "ERC20: transfer from the zero address");
183             require(recipient != address(0), "ERC20: transfer to the zero address");
184             _beforeTokenTransfer(sender, recipient, amount);
185             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
186             _balances[recipient] = _balances[recipient].add(amount);
187             emit Transfer(sender, recipient, amount);
188         }
189 
190         function _mint(address account, uint256 amount) internal virtual {
191             require(account != address(0), "ERC20: mint to the zero address");
192 
193             _beforeTokenTransfer(address(0), account, amount);
194 
195             _totalSupply = _totalSupply.add(amount);
196             _balances[account] = _balances[account].add(amount);
197 
198             emit Transfer(address(0), account, amount);
199         }
200 
201         function _burn(address account, uint256 amount) internal virtual {
202             require(account != address(0), "ERC20: burn from the zero address");
203     _beforeTokenTransfer(account, address(0), amount);
204 
205             _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
206             _totalSupply = _totalSupply.sub(amount);
207 
208             emit Transfer(account, address(0), amount);
209         }
210 
211         function _approve(
212             address owner,
213 
214             address spender,
215             uint256 amount
216         ) internal virtual {
217             require(owner != address(0), "ERC20: approve from the zero address");
218             require(spender != address(0), "ERC20: approve to the zero address");
219 
220             _allowances[owner][spender] = amount;
221             emit Approval(owner, spender, amount);
222         }
223 
224         function _beforeTokenTransfer(
225             address from,
226             address to,
227             uint256 amount
228         ) internal virtual {}
229 
230     }
231 
232     library SafeMath {
233         
234         function add(uint256 a, uint256 b) internal pure returns (uint256) {
235             uint256 c = a + b;
236             require(c >= a, "SafeMath: addition overflow");
237 
238             return c;
239         }
240 
241         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
242             return sub(a, b, "SafeMath: subtraction overflow");
243         }
244 
245 
246         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
247             require(b <= a, errorMessage);
248             uint256 c = a - b;
249 
250             return c;
251 
252         }
253 
254         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
255             if (a == 0) {
256                 return 0;
257             }
258             uint256 c = a * b;
259             require(c / a == b, "SafeMath: multiplication overflow");
260 
261             return c;
262         }
263 
264         function div(uint256 a, uint256 b) internal pure returns (uint256) {
265             return div(a, b, "SafeMath: division by zero");
266         }
267 
268         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
269             require(b > 0, errorMessage);
270             uint256 c = a / b;
271             return c;
272         }
273 
274         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
275             return mod(a, b, "SafeMath: modulo by zero");
276         }
277         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
278             require(b != 0, errorMessage);
279             return a % b;
280         }
281     }
282 
283 
284     contract Ownable is Context {
285         address private _owner;
286 
287         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
288 
289         constructor () {
290             address msgSender = _msgSender();
291             _owner = msgSender;
292             emit OwnershipTransferred(address(0), msgSender);
293         }
294 
295         function owner() public view returns (address) {
296             return _owner;
297         }
298 
299         modifier onlyOwner() {
300             require(_owner == _msgSender(), "Ownable: caller is not the owner");
301             _;
302         }
303 
304         function renounceOwnership() public virtual onlyOwner {
305             emit OwnershipTransferred(_owner, address(0));
306             _owner = address(0);
307         }
308         function transferOwnership(address newOwner) public virtual onlyOwner {
309             require(newOwner != address(0), "Ownable: new owner is the zero address");
310             emit OwnershipTransferred(_owner, newOwner);
311             _owner = newOwner;
312         }
313     }
314 
315     library SafeMathInt {
316         int256 private constant MIN_INT256 = int256(1) << 255;
317         int256 private constant MAX_INT256 = ~(int256(1) << 255);
318 
319         function mul(int256 a, int256 b) internal pure returns (int256) {
320             int256 c = a * b;
321             require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
322             require((b == 0) || (c / b == a));
323             return c;
324         }
325 
326         function div(int256 a, int256 b) internal pure returns (int256) {
327             require(b != -1 || a != MIN_INT256);
328             return a / b;
329         }
330 
331         function sub(int256 a, int256 b) internal pure returns (int256) {
332             int256 c = a - b;
333             require((b >= 0 && c <= a) || (b < 0 && c > a));
334             return c;
335         }
336 
337         function add(int256 a, int256 b) internal pure returns (int256) {
338             int256 c = a + b;
339             require((b >= 0 && c >= a) || (b < 0 && c < a));
340             return c;
341         }
342 
343         function abs(int256 a) internal pure returns (int256) {
344             require(a != MIN_INT256);
345             return a < 0 ? -a : a;
346         }
347         function toUint256Safe(int256 a) internal pure returns (uint256) {
348             require(a >= 0);
349             return uint256(a);
350         }
351     }
352 
353     library SafeMathUint {
354     function toInt256Safe(uint256 a) internal pure returns (int256) {
355         int256 b = int256(a);
356         require(b >= 0);
357         return b;
358     }
359     }
360 
361 
362     interface IUniswapV2Router01 {
363         function factory() external pure returns (address);
364         function WETH() external pure returns (address);
365         function addLiquidity(
366             address tokenA,
367             address tokenB,
368             uint amountADesired,
369             uint amountBDesired,
370             uint amountAMin,
371             uint amountBMin,
372             address to,
373             uint deadline
374         ) external returns (uint amountA, uint amountB, uint liquidity);
375         function addLiquidityETH(
376             address token,
377             uint amountTokenDesired,
378             uint amountTokenMin,
379             uint amountETHMin,
380             address to,
381             uint deadline
382         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
383         function removeLiquidity(
384             address tokenA,
385             address tokenB,
386             uint liquidity,
387             uint amountAMin,
388             uint amountBMin,
389             address to,
390             uint deadline
391         ) external returns (uint amountA, uint amountB);
392 
393         function removeLiquidityETH(
394             address token,
395             uint liquidity,
396             uint amountTokenMin,
397             uint amountETHMin,
398             address to,
399             uint deadline
400         ) external returns (uint amountToken, uint amountETH);
401         function removeLiquidityWithPermit(
402             address tokenA,
403             address tokenB,
404             uint liquidity,
405             uint amountAMin,
406             uint amountBMin,
407             address to,
408             uint deadline,
409             bool approveMax, uint8 v, bytes32 r, bytes32 s
410         ) external returns (uint amountA, uint amountB);
411         function removeLiquidityETHWithPermit(
412             address token,
413             uint liquidity,
414             uint amountTokenMin,
415             uint amountETHMin,
416             address to,
417             uint deadline,
418             bool approveMax, uint8 v, bytes32 r, bytes32 s
419         ) external returns (uint amountToken, uint amountETH);
420         function swapExactTokensForTokens(
421             uint amountIn,
422             uint amountOutMin,
423             address[] calldata path,
424             address to,
425             uint deadline
426         ) external returns (uint[] memory amounts);
427         function swapTokensForExactTokens(
428             uint amountOut,
429 
430             uint amountInMax,
431             address[] calldata path,
432             address to,
433             uint deadline
434         ) external returns (uint[] memory amounts);
435         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
436             external
437             payable
438             returns (uint[] memory amounts);
439         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
440             external
441             returns (uint[] memory amounts);
442         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
443             external
444             returns (uint[] memory amounts);
445             function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
446             external
447             payable
448             returns (uint[] memory amounts);
449         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
450         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
451         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
452         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
453         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
454     }
455 
456 
457     interface IUniswapV2Router02 is IUniswapV2Router01 {
458         function removeLiquidityETHSupportingFeeOnTransferTokens(
459             address token,
460             uint liquidity,
461             uint amountTokenMin,
462             uint amountETHMin,
463             address to,
464             uint deadline
465 
466         ) external returns (uint amountETH);
467         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
468             address token,
469             uint liquidity,
470             uint amountTokenMin,
471             uint amountETHMin,
472             address to,
473             uint deadline,
474             bool approveMax, uint8 v, bytes32 r, bytes32 s
475         ) external returns (uint amountETH);
476 
477         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
478             uint amountIn,
479             uint amountOutMin,
480             address[] calldata path,
481             address to,
482             uint deadline
483 
484         ) external;
485         function swapExactETHForTokensSupportingFeeOnTransferTokens(
486             uint amountOutMin,
487             address[] calldata path,
488             address to,
489             uint deadline
490             ) external payable;
491         function swapExactTokensForETHSupportingFeeOnTransferTokens(
492             uint amountIn,
493             uint amountOutMin,
494             address[] calldata path,
495             address to,
496             uint deadline
497         ) external;
498     }
499     contract VOLXY is ERC20, Ownable {
500         using SafeMath for uint256;
501 
502         IUniswapV2Router02 public immutable uniswapV2Router;
503 
504         address public immutable uniswapV2Pair;
505         address public constant deadAddress = address(0xdead);
506 
507         bool private swapping;
508         bool private botsShaken;
509 
510         address public marketingWallet;
511         address public lpLocker;
512         
513         uint256 public maxTransactionAmount;
514         uint256 public swapTokensAtAmount;
515 
516         uint256 public maxWallet;
517 
518         bool public swapEnabled = true;
519 
520         uint256 public buyTotalFees;
521         uint256 public buyMarketingFee;
522         uint256 public buyLiquidityFee;
523         uint256 public buyBurnFee;
524         
525         uint256 public sellTotalFees;
526         uint256 public sellMarketingFee;
527         uint256 public sellLiquidityFee;
528         uint256 public sellBurnFee;
529         
530         uint256 public tokensForMarketing;
531         uint256 public tokensForLiquidity;
532         uint256 public tokensForBurn;
533 
534         mapping (address => bool) private _isExcludedFromFees;
535         mapping (address => bool) public _isExcludedMaxTransactionAmount;
536 
537         mapping (address => bool) public automatedMarketMakerPairs;
538         event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
539         event ExcludeFromFees(address indexed account, bool isExcluded);
540         event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
541         event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
542         event SwapAndLiquify(
543             uint256 tokensSwapped,
544             uint256 ethReceived,
545             uint256 tokensIntoLiquidity
546         );
547         event BuyBackTriggered(uint256 amount);
548 
549         constructor() ERC20("Volxy Inu", "VOLXY") {
550             address newOwner = address(owner());
551             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
552             excludeFromMaxTransaction(address(_uniswapV2Router), true);
553             uniswapV2Router = _uniswapV2Router;
554             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
555             excludeFromMaxTransaction(address(uniswapV2Pair), true);
556             _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
557             
558             uint256 _buyMarketingFee = 30;
559             uint256 _buyLiquidityFee = 0;
560             uint256 _buyBurnFee = 0;
561         
562             uint256 _sellMarketingFee = 45;
563             uint256 _sellLiquidityFee = 0;
564             uint256 _sellBurnFee = 0;
565             
566             uint256 totalSupply = 1 * 1e6 * 1e9;
567             
568             maxTransactionAmount = (totalSupply * 1 / 100) + (1 * 1e9); // 1% maxTransactionAmountTxn
569             swapTokensAtAmount = totalSupply * 25 / 100000; // 0.025% swap wallet
570             maxWallet = (totalSupply * 2 / 100) + (1 * 1e9); // 2% max wallet
571 
572             buyMarketingFee = _buyMarketingFee;
573             buyLiquidityFee = _buyLiquidityFee;
574             buyBurnFee = _buyBurnFee;
575             buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
576             
577             sellMarketingFee = _sellMarketingFee;
578             sellLiquidityFee = _sellLiquidityFee;
579             sellBurnFee = _sellBurnFee;
580             sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
581             
582             marketingWallet = address(0x56bb502e559A4b74981d3093c81747CE2F3fe312); // Marketing / Development wallet
583             lpLocker = address(0x663A5C229c09b049E36dCc11a9B0d4a8Eb9db214); // LP Locker CA (Unicrypt)
584 
585             excludeFromFees(newOwner, true); // Owner address
586             excludeFromFees(address(this), true); // CA
587             excludeFromFees(address(0xdead), true); // Burn address
588             excludeFromFees(marketingWallet, true); // Marketing / Development wallet
589             excludeFromFees(lpLocker, true); // LP Locker
590             
591             excludeFromMaxTransaction(newOwner, true); // Owner address
592             excludeFromMaxTransaction(address(this), true); // CA
593             excludeFromMaxTransaction(address(0xdead), true); // Burn address
594             excludeFromMaxTransaction(marketingWallet, true); // Marketing / Development wallet
595             excludeFromMaxTransaction(lpLocker, true); // LP Locker
596 
597             _mint(newOwner, totalSupply);
598 
599             transferOwnership(newOwner);
600         }
601 
602         receive() external payable {
603         }
604 
605         function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
606             require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
607             require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
608             swapTokensAtAmount = newAmount;
609             return true;
610             }
611         
612         function updateMaxTxAmount(uint256 newNum) external onlyOwner {
613             require(newNum >= (totalSupply() * 1 / 100)/1e9, "Cannot set maxTransactionAmount lower than 1%");
614             maxTransactionAmount = (newNum * 1e9) + (1 * 1e9) ;
615         }
616         
617         function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
618             require(newNum >= (totalSupply() * 2 / 100)/1e9, "Cannot set maxWalletAmount lower than 2%");
619             maxWallet = (newNum * 1e9) + (1 * 1e9);
620 
621         }
622 
623         function updateLimits(uint256 _maxTransactionAmount, uint256 _maxWallet) external onlyOwner {
624             require(_maxTransactionAmount >= (totalSupply() * 1 / 100)/1e9, "Cannot set maxTransactionAmount lower than 1%");
625             require(_maxWallet >= (totalSupply() * 2 / 100)/1e9, "Cannot set maxWallet lower than 2%");
626             maxTransactionAmount = (_maxTransactionAmount * 1e9) + (1 * 1e9) ;
627             maxWallet = (_maxWallet * 1e9) + (1 * 1e9);
628         }
629 
630         function removeLimits() external onlyOwner {
631             maxTransactionAmount = totalSupply();
632             maxWallet = totalSupply();
633         }
634         
635         function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
636             _isExcludedMaxTransactionAmount[updAds] = isEx;
637         }
638 
639         function updateSwapEnabled(bool enabled) external onlyOwner(){
640             swapEnabled = enabled;
641         }
642 
643         function updateFees(uint256 _buyMarketingFee, uint256 _buyLiquidityFee, uint256 _buyBurnFee, uint256 _sellMarketingFee, 
644         uint256 _sellLiquidityFee, uint256 _sellBurnFee) external onlyOwner {
645             buyMarketingFee = _buyMarketingFee;
646             buyLiquidityFee = _buyLiquidityFee;
647             buyBurnFee = _buyBurnFee;
648             buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
649             sellMarketingFee = _sellMarketingFee;
650             sellLiquidityFee = _sellLiquidityFee;
651             sellBurnFee = _sellBurnFee;
652             sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
653             require(sellTotalFees <= 45, "Must keep sell fees at 45% or less");
654 
655             require(buyTotalFees <= 30, "Must keep buy fees at 30% or less");
656         }
657         function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _burnFee) external onlyOwner {
658             buyMarketingFee = _marketingFee;
659             buyLiquidityFee = _liquidityFee;
660             buyBurnFee = _burnFee;
661             buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
662             require(buyTotalFees <= 30, "Must keep buy fees at 30% or less");
663         }
664 
665         function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _burnFee) external onlyOwner {
666             sellMarketingFee = _marketingFee;
667             sellLiquidityFee = _liquidityFee;
668             sellBurnFee = _burnFee;
669             sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
670             require(sellTotalFees <= 45, "Must keep sell fees at 45% or less");
671         }
672 
673         function excludeFromFees(address account, bool excluded) public onlyOwner {
674             _isExcludedFromFees[account] = excluded;
675             emit ExcludeFromFees(account, excluded);
676         }
677 
678         function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
679 
680             require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
681             _setAutomatedMarketMakerPair(pair, value);
682         }
683 
684         function _setAutomatedMarketMakerPair(address pair, bool value) private {
685             automatedMarketMakerPairs[pair] = value;
686             emit SetAutomatedMarketMakerPair(pair, value);
687         }
688 
689         function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
690             emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
691             marketingWallet = newMarketingWallet;
692         }
693 
694         function isExcludedFromFees(address account) public view returns(bool) {
695             return _isExcludedFromFees[account];
696         }
697 
698         function _transfer(
699             address from,
700             address to,
701             uint256 amount
702         ) internal override {
703             require(from != address(0), "ERC20: transfer from the zero address");
704             require(to != address(0), "ERC20: transfer to the zero address");
705             
706             if(amount == 0) {
707                 super._transfer(from, to, 0);
708                 return;
709             }
710                 if (
711                     from != owner() &&
712 
713                     to != owner() &&
714                     to != address(0) &&
715                     to != address(0xdead) &&
716                     !swapping
717                 ){
718                     //when buy
719                     if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
720                             require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
721                             require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
722 
723                     }
724                     
725                     //when sell
726                     else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
727                             require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
728                     }
729                 }
730             uint256 contractTokenBalance = balanceOf(address(this));
731             bool canSwap = contractTokenBalance >= swapTokensAtAmount;
732 
733             if( 
734                 canSwap &&
735                 swapEnabled &&
736                 !swapping &&
737                 !automatedMarketMakerPairs[from] &&
738                 !_isExcludedFromFees[from] &&
739                 !_isExcludedFromFees[to]
740             ) {
741                 swapping = true; 
742                 swapBack();
743                 swapping = false;
744             }
745             bool takeFee = !swapping;
746 
747 
748             if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
749                 takeFee = false;
750             }
751             uint256 fees = 0;
752             if(takeFee){
753                 if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
754                     fees = amount.mul(sellTotalFees).div(100);
755                     tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
756                     tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
757                     tokensForBurn += fees * sellBurnFee / sellTotalFees;
758                 }
759                 else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
760                     fees = amount.mul(buyTotalFees).div(100);
761                     tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
762                     tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
763                     tokensForBurn += fees * buyBurnFee / buyTotalFees;
764                 }
765                 
766                 if(fees > 0){    
767                     super._transfer(from, address(this), (fees - tokensForBurn));
768                 }
769 
770                 if(tokensForBurn > 0){
771                     super._transfer(from, deadAddress, tokensForBurn);
772                     tokensForBurn = 0;
773                 }
774                 amount -= fees;
775             }
776             super._transfer(from, to, amount);
777         }
778 
779         function swapTokensForEth(uint256 tokenAmount) private {
780             address[] memory path = new address[](2);
781             path[0] = address(this);
782 
783             path[1] = uniswapV2Router.WETH();
784             _approve(address(this), address(uniswapV2Router), tokenAmount);
785             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
786                 tokenAmount,
787                 0,
788                 path,
789                 address(this),
790                 block.timestamp
791             );
792         }
793         function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
794             _approve(address(this), address(uniswapV2Router), tokenAmount);
795             uniswapV2Router.addLiquidityETH{value: ethAmount}(
796                 address(this),
797                 tokenAmount,
798                 0,
799                 0,
800                 deadAddress,
801                 block.timestamp
802             );
803         }
804 
805         function swapBack() private {
806             uint256 contractBalance = balanceOf(address(this));
807             uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
808             
809             if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
810             uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
811             uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
812             uint256 initialETHBalance = address(this).balance;
813             swapTokensForEth(amountToSwapForETH); 
814             uint256 ethBalance = address(this).balance.sub(initialETHBalance);
815             uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
816 
817             uint256 ethForLiquidity = ethBalance - ethForMarketing;
818 
819             tokensForLiquidity = 0;
820             tokensForMarketing = 0;
821             
822             (bool success,) = address(marketingWallet).call{value: ethForMarketing}("");
823             if(liquidityTokens > 0 && ethForLiquidity > 0){
824                 addLiquidity(liquidityTokens, ethForLiquidity);
825                 emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
826             }
827 
828             (success,) = address(marketingWallet).call{value: address(this).balance}("");
829         }
830         
831     }