1 // SPDX-License-Identifier: MIT                                                                               
2     /*
3 
4     $APEAI - APE Artificial Intelligence
5 
6     The AI solution for apes! APEAI allows its holders to intelligently analyze new contracts 
7     providing them with advice on whether to ape or not, alongside a wealth of information. 
8 
9     TG: https://t.me/apeaierc20
10     TW: https://twitter.com/aimev_eth
11     WEB: https://apeai.tech
12     MED: https://medium.com/@apeaierc20/
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
39 
40         function transfer(address to, uint value) external returns (bool);
41         function transferFrom(address from, address to, uint value) external returns (bool);
42         function DOMAIN_SEPARATOR() external view returns (bytes32);
43         function PERMIT_TYPEHASH() external pure returns (bytes32);
44         function nonces(address owner) external view returns (uint);
45         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
46 
47         event Mint(address indexed sender, uint amount0, uint amount1);
48         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
49         event Swap(
50             address indexed sender,
51             uint amount0In,
52             uint amount1In,
53             uint amount0Out,
54             uint amount1Out,
55             address indexed to
56         );
57         event Sync(uint112 reserve0, uint112 reserve1);
58 
59         function MINIMUM_LIQUIDITY() external pure returns (uint);
60         function factory() external view returns (address);
61         function token0() external view returns (address);
62         function token1() external view returns (address);
63         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
64         function price0CumulativeLast() external view returns (uint);
65         function price1CumulativeLast() external view returns (uint);
66         function kLast() external view returns (uint);
67         function mint(address to) external returns (uint liquidity);
68         function burn(address to) external returns (uint amount0, uint amount1);
69         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
70         function skim(address to) external;
71         function sync() external;
72         function initialize(address, address) external;
73 
74         }
75 
76     interface IUniswapV2Factory {
77         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
78         function feeTo() external view returns (address);
79         function feeToSetter() external view returns (address);
80         function getPair(address tokenA, address tokenB) external view returns (address pair);
81         function allPairs(uint) external view returns (address pair);
82         function allPairsLength() external view returns (uint);
83         function createPair(address tokenA, address tokenB) external returns (address pair);
84         function setFeeTo(address) external;
85         function setFeeToSetter(address) external;
86     }
87 
88     interface IERC20 {
89         function totalSupply() external view returns (uint256);
90         function balanceOf(address account) external view returns (uint256);
91         function transfer(address recipient, uint256 amount) external returns (bool);
92         function allowance(address owner, address spender) external view returns (uint256);
93         function approve(address spender, uint256 amount) external returns (bool);
94         function transferFrom(
95             address sender,
96             address recipient,
97             uint256 amount
98         ) external returns (bool);
99         event Transfer(address indexed from, address indexed to, uint256 value);
100         event Approval(address indexed owner, address indexed spender, uint256 value);
101     }
102 
103     interface IERC20Metadata is IERC20 {
104         function name() external view returns (string memory);
105 
106         function symbol() external view returns (string memory);
107         function decimals() external view returns (uint8);
108     }
109     contract ERC20 is Context, IERC20, IERC20Metadata {
110         using SafeMath for uint256;
111         mapping(address => uint256) private _balances;
112         mapping(address => mapping(address => uint256)) private _allowances;
113         uint256 private _totalSupply;
114         string private _name;
115 
116         string private _symbol;
117 
118         constructor(string memory name_, string memory symbol_) {
119             _name = name_;
120             _symbol = symbol_;
121         }
122 
123         function name() public view virtual override returns (string memory) {
124             return _name;
125         }
126 
127         function symbol() public view virtual override returns (string memory) {
128             return _symbol;
129         }
130 
131         function decimals() public view virtual override returns (uint8) {
132             return 9;
133         }
134 
135         function totalSupply() public view virtual override returns (uint256) {
136             return _totalSupply;
137         }
138 
139         function balanceOf(address account) public view virtual override returns (uint256) {
140             return _balances[account];
141         }
142 
143         function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
144 
145             _transfer(_msgSender(), recipient, amount);
146             return true;
147         }
148 
149 
150         function allowance(address owner, address spender) public view virtual override returns (uint256) {
151             return _allowances[owner][spender];
152         }
153 
154         function approve(address spender, uint256 amount) public virtual override returns (bool) {
155             _approve(_msgSender(), spender, amount);
156             return true;
157         }
158 
159         function transferFrom(
160             address sender,
161             address recipient,
162             uint256 amount
163         ) public virtual override returns (bool) {
164             _transfer(sender, recipient, amount);
165             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
166             return true;
167         }
168 
169         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
170             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
171             return true;
172         }
173 
174         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
175 
176             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
177             return true;
178 
179         }
180 
181         function _transfer(
182 
183             address sender,
184             address recipient,
185             uint256 amount
186             ) internal virtual {
187             require(sender != address(0), "ERC20: transfer from the zero address");
188             require(recipient != address(0), "ERC20: transfer to the zero address");
189             _beforeTokenTransfer(sender, recipient, amount);
190             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
191             _balances[recipient] = _balances[recipient].add(amount);
192             emit Transfer(sender, recipient, amount);
193         }
194 
195         function _mint(address account, uint256 amount) internal virtual {
196             require(account != address(0), "ERC20: mint to the zero address");
197 
198             _beforeTokenTransfer(address(0), account, amount);
199 
200             _totalSupply = _totalSupply.add(amount);
201             _balances[account] = _balances[account].add(amount);
202 
203             emit Transfer(address(0), account, amount);
204         }
205 
206         function _burn(address account, uint256 amount) internal virtual {
207 
208             require(account != address(0), "ERC20: burn from the zero address");
209     _beforeTokenTransfer(account, address(0), amount);
210 
211             _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
212             _totalSupply = _totalSupply.sub(amount);
213 
214             emit Transfer(account, address(0), amount);
215         }
216 
217         function _approve(
218             address owner,
219 
220             address spender,
221             uint256 amount
222         ) internal virtual {
223             require(owner != address(0), "ERC20: approve from the zero address");
224             require(spender != address(0), "ERC20: approve to the zero address");
225 
226             _allowances[owner][spender] = amount;
227             emit Approval(owner, spender, amount);
228         }
229 
230         function _beforeTokenTransfer(
231             address from,
232             address to,
233             uint256 amount
234         ) internal virtual {}
235 
236     }
237 
238     library SafeMath {
239         
240         function add(uint256 a, uint256 b) internal pure returns (uint256) {
241 
242             uint256 c = a + b;
243             require(c >= a, "SafeMath: addition overflow");
244 
245             return c;
246         }
247 
248         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
249             return sub(a, b, "SafeMath: subtraction overflow");
250         }
251 
252 
253         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
254             require(b <= a, errorMessage);
255             uint256 c = a - b;
256 
257             return c;
258 
259         }
260 
261         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
262             if (a == 0) {
263                 return 0;
264             }
265             uint256 c = a * b;
266             require(c / a == b, "SafeMath: multiplication overflow");
267 
268             return c;
269         }
270 
271         function div(uint256 a, uint256 b) internal pure returns (uint256) {
272 
273             return div(a, b, "SafeMath: division by zero");
274         }
275 
276         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
277             require(b > 0, errorMessage);
278             uint256 c = a / b;
279             return c;
280         }
281 
282         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
283             return mod(a, b, "SafeMath: modulo by zero");
284         }
285         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
286             require(b != 0, errorMessage);
287             return a % b;
288         }
289     }
290 
291 
292     contract Ownable is Context {
293         address private _owner;
294 
295         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
296 
297         constructor () {
298             address msgSender = _msgSender();
299             _owner = msgSender;
300             emit OwnershipTransferred(address(0), msgSender);
301         }
302 
303         function owner() public view returns (address) {
304             return _owner;
305         }
306 
307 
308         modifier onlyOwner() {
309             require(_owner == _msgSender(), "Ownable: caller is not the owner");
310             _;
311         }
312 
313         function renounceOwnership() public virtual onlyOwner {
314             emit OwnershipTransferred(_owner, address(0));
315             _owner = address(0);
316         }
317         function transferOwnership(address newOwner) public virtual onlyOwner {
318             require(newOwner != address(0), "Ownable: new owner is the zero address");
319             emit OwnershipTransferred(_owner, newOwner);
320             _owner = newOwner;
321         }
322     }
323 
324     library SafeMathInt {
325         int256 private constant MIN_INT256 = int256(1) << 255;
326         int256 private constant MAX_INT256 = ~(int256(1) << 255);
327 
328         function mul(int256 a, int256 b) internal pure returns (int256) {
329             int256 c = a * b;
330             require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
331             require((b == 0) || (c / b == a));
332             return c;
333         }
334 
335         function div(int256 a, int256 b) internal pure returns (int256) {
336             require(b != -1 || a != MIN_INT256);
337             return a / b;
338         }
339 
340         function sub(int256 a, int256 b) internal pure returns (int256) {
341 
342             int256 c = a - b;
343             require((b >= 0 && c <= a) || (b < 0 && c > a));
344             return c;
345         }
346 
347         function add(int256 a, int256 b) internal pure returns (int256) {
348             int256 c = a + b;
349             require((b >= 0 && c >= a) || (b < 0 && c < a));
350             return c;
351         }
352 
353         function abs(int256 a) internal pure returns (int256) {
354             require(a != MIN_INT256);
355             return a < 0 ? -a : a;
356         }
357         function toUint256Safe(int256 a) internal pure returns (uint256) {
358             require(a >= 0);
359             return uint256(a);
360         }
361     }
362 
363     library SafeMathUint {
364     function toInt256Safe(uint256 a) internal pure returns (int256) {
365         int256 b = int256(a);
366         require(b >= 0);
367         return b;
368     }
369     }
370 
371 
372     interface IUniswapV2Router01 {
373         function factory() external pure returns (address);
374         function WETH() external pure returns (address);
375         function addLiquidity(
376             address tokenA,
377             address tokenB,
378 
379             uint amountADesired,
380             uint amountBDesired,
381             uint amountAMin,
382             uint amountBMin,
383             address to,
384             uint deadline
385         ) external returns (uint amountA, uint amountB, uint liquidity);
386         function addLiquidityETH(
387             address token,
388             uint amountTokenDesired,
389             uint amountTokenMin,
390             uint amountETHMin,
391             address to,
392             uint deadline
393         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
394         function removeLiquidity(
395             address tokenA,
396             address tokenB,
397             uint liquidity,
398             uint amountAMin,
399             uint amountBMin,
400             address to,
401             uint deadline
402         ) external returns (uint amountA, uint amountB);
403 
404         function removeLiquidityETH(
405             address token,
406             uint liquidity,
407             uint amountTokenMin,
408             uint amountETHMin,
409             address to,
410             uint deadline
411         ) external returns (uint amountToken, uint amountETH);
412         function removeLiquidityWithPermit(
413             address tokenA,
414             address tokenB,
415 
416             uint liquidity,
417             uint amountAMin,
418             uint amountBMin,
419             address to,
420             uint deadline,
421             bool approveMax, uint8 v, bytes32 r, bytes32 s
422         ) external returns (uint amountA, uint amountB);
423         function removeLiquidityETHWithPermit(
424             address token,
425             uint liquidity,
426             uint amountTokenMin,
427             uint amountETHMin,
428             address to,
429             uint deadline,
430             bool approveMax, uint8 v, bytes32 r, bytes32 s
431         ) external returns (uint amountToken, uint amountETH);
432         function swapExactTokensForTokens(
433             uint amountIn,
434             uint amountOutMin,
435             address[] calldata path,
436             address to,
437             uint deadline
438         ) external returns (uint[] memory amounts);
439         function swapTokensForExactTokens(
440             uint amountOut,
441 
442             uint amountInMax,
443             address[] calldata path,
444             address to,
445             uint deadline
446         ) external returns (uint[] memory amounts);
447 
448         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
449             external
450             payable
451             returns (uint[] memory amounts);
452         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
453             external
454             returns (uint[] memory amounts);
455         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
456             external
457             returns (uint[] memory amounts);
458             function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
459             external
460             payable
461             returns (uint[] memory amounts);
462         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
463         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
464         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
465         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
466         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
467     }
468 
469 
470     interface IUniswapV2Router02 is IUniswapV2Router01 {
471         function removeLiquidityETHSupportingFeeOnTransferTokens(
472             address token,
473             uint liquidity,
474             uint amountTokenMin,
475             uint amountETHMin,
476             address to,
477             uint deadline
478 
479 
480         ) external returns (uint amountETH);
481         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
482             address token,
483             uint liquidity,
484             uint amountTokenMin,
485             uint amountETHMin,
486             address to,
487             uint deadline,
488             bool approveMax, uint8 v, bytes32 r, bytes32 s
489         ) external returns (uint amountETH);
490 
491         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
492             uint amountIn,
493             uint amountOutMin,
494             address[] calldata path,
495             address to,
496             uint deadline
497 
498         ) external;
499         function swapExactETHForTokensSupportingFeeOnTransferTokens(
500             uint amountOutMin,
501             address[] calldata path,
502             address to,
503             uint deadline
504             ) external payable;
505         function swapExactTokensForETHSupportingFeeOnTransferTokens(
506             uint amountIn,
507             uint amountOutMin,
508             address[] calldata path,
509             address to,
510             uint deadline
511         ) external;
512     }
513     contract APEAI is ERC20, Ownable {
514 
515         using SafeMath for uint256;
516 
517         IUniswapV2Router02 public immutable uniswapV2Router;
518 
519         address public immutable uniswapV2Pair;
520         address public constant deadAddress = address(0xdead);
521 
522         bool private swapping;
523         bool private botsShaken;
524 
525         address public marketingWallet;
526         address public lpLocker;
527         
528         uint256 public maxTransactionAmount;
529         uint256 public swapTokensAtAmount;
530 
531         uint256 public maxWallet;
532 
533         bool public swapEnabled = true;
534 
535         uint256 public buyTotalFees;
536         uint256 public buyMarketingFee;
537         uint256 public buyLiquidityFee;
538         uint256 public buyBurnFee;
539         
540         uint256 public sellTotalFees;
541         uint256 public sellMarketingFee;
542         uint256 public sellLiquidityFee;
543         uint256 public sellBurnFee;
544 
545         
546         uint256 public tokensForMarketing;
547         uint256 public tokensForLiquidity;
548         uint256 public tokensForBurn;
549 
550         mapping (address => bool) private _isExcludedFromFees;
551         mapping (address => bool) public _isExcludedMaxTransactionAmount;
552 
553         mapping (address => bool) public automatedMarketMakerPairs;
554         event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
555         event ExcludeFromFees(address indexed account, bool isExcluded);
556         event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
557         event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
558         event SwapAndLiquify(
559             uint256 tokensSwapped,
560             uint256 ethReceived,
561             uint256 tokensIntoLiquidity
562         );
563         event BuyBackTriggered(uint256 amount);
564 
565         constructor() ERC20("APE Artificial Intelligence", "APEAI") {
566             address newOwner = address(owner());
567             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
568             excludeFromMaxTransaction(address(_uniswapV2Router), true);
569             uniswapV2Router = _uniswapV2Router;
570             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
571             excludeFromMaxTransaction(address(uniswapV2Pair), true);
572 
573             _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
574             
575             uint256 _buyMarketingFee = 20;
576             uint256 _buyLiquidityFee = 0;
577             uint256 _buyBurnFee = 0;
578         
579             uint256 _sellMarketingFee = 45;
580             uint256 _sellLiquidityFee = 0;
581             uint256 _sellBurnFee = 0;
582             
583             uint256 totalSupply = 1 * 1e6 * 1e9;
584             
585             maxTransactionAmount = (totalSupply * 2 / 100) + (1 * 1e9); // 2% maxTransactionAmountTxn
586             swapTokensAtAmount = totalSupply * 25 / 100000; // 0.025% swap wallet
587             maxWallet = (totalSupply * 3 / 100) + (1 * 1e9); // 3% max wallet
588 
589             buyMarketingFee = _buyMarketingFee;
590             buyLiquidityFee = _buyLiquidityFee;
591             buyBurnFee = _buyBurnFee;
592             buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
593             
594             sellMarketingFee = _sellMarketingFee;
595             sellLiquidityFee = _sellLiquidityFee;
596             sellBurnFee = _sellBurnFee;
597             sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
598 
599             
600             marketingWallet = address(0x9e7F6DE793448B3849F5ebdCE44770b6e8E6286A); // Marketing / Development wallet
601             lpLocker = address(0x663A5C229c09b049E36dCc11a9B0d4a8Eb9db214); // LP Locker CA (Unicrypt)
602 
603             excludeFromFees(newOwner, true); // Owner address
604             excludeFromFees(address(this), true); // CA
605             excludeFromFees(address(0xdead), true); // Burn address
606             excludeFromFees(marketingWallet, true); // Marketing / Development wallet
607             excludeFromFees(lpLocker, true); // LP Locker
608             
609             excludeFromMaxTransaction(newOwner, true); // Owner address
610             excludeFromMaxTransaction(address(this), true); // CA
611             excludeFromMaxTransaction(address(0xdead), true); // Burn address
612             excludeFromMaxTransaction(marketingWallet, true); // Marketing / Development wallet
613             excludeFromMaxTransaction(lpLocker, true); // LP Locker
614 
615             _mint(newOwner, totalSupply);
616 
617             transferOwnership(newOwner);
618         }
619 
620         receive() external payable {
621         }
622 
623         function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
624             require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
625             require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
626             swapTokensAtAmount = newAmount;
627 
628             return true;
629             }
630         
631         function updateMaxTxAmount(uint256 newNum) external onlyOwner {
632             require(newNum >= (totalSupply() * 2 / 100)/1e9, "Cannot set maxTransactionAmount lower than 2%");
633             maxTransactionAmount = (newNum * 1e9) + (1 * 1e9) ;
634         }
635         
636         function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
637             require(newNum >= (totalSupply() * 3 / 100)/1e9, "Cannot set maxWalletAmount lower than 3%");
638             maxWallet = (newNum * 1e9) + (1 * 1e9);
639 
640         }
641 
642         function updateLimits(uint256 _maxTransactionAmount, uint256 _maxWallet) external onlyOwner {
643             require(_maxTransactionAmount >= (totalSupply() * 2 / 100)/1e9, "Cannot set maxTransactionAmount lower than 2%");
644             require(_maxWallet >= (totalSupply() * 3 / 100)/1e9, "Cannot set maxWallet lower than 3%");
645             maxTransactionAmount = (_maxTransactionAmount * 1e9) + (1 * 1e9) ;
646             maxWallet = (_maxWallet * 1e9) + (1 * 1e9);
647         }
648 
649         function removeLimits() external onlyOwner {
650             maxTransactionAmount = totalSupply();
651             maxWallet = totalSupply();
652         }
653         
654         function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
655             _isExcludedMaxTransactionAmount[updAds] = isEx;
656 
657         }
658 
659         function updateSwapEnabled(bool enabled) external onlyOwner(){
660             swapEnabled = enabled;
661         }
662 
663         function updateFees(uint256 _buyMarketingFee, uint256 _buyLiquidityFee, uint256 _buyBurnFee, uint256 _sellMarketingFee, 
664         uint256 _sellLiquidityFee, uint256 _sellBurnFee) external onlyOwner {
665             buyMarketingFee = _buyMarketingFee;
666             buyLiquidityFee = _buyLiquidityFee;
667             buyBurnFee = _buyBurnFee;
668             buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
669             sellMarketingFee = _sellMarketingFee;
670             sellLiquidityFee = _sellLiquidityFee;
671             sellBurnFee = _sellBurnFee;
672             sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
673             require(sellTotalFees <= 45, "Must keep sell fees at 45% or less");
674 
675             require(buyTotalFees <= 20, "Must keep buy fees at 20% or less");
676         }
677         function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _burnFee) external onlyOwner {
678             buyMarketingFee = _marketingFee;
679             buyLiquidityFee = _liquidityFee;
680             buyBurnFee = _burnFee;
681             buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
682             require(buyTotalFees <= 20, "Must keep buy fees at 20% or less");
683 
684         }
685 
686         function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _burnFee) external onlyOwner {
687             sellMarketingFee = _marketingFee;
688             sellLiquidityFee = _liquidityFee;
689             sellBurnFee = _burnFee;
690             sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
691             require(sellTotalFees <= 45, "Must keep sell fees at 45% or less");
692         }
693 
694         function shakeBots() external onlyOwner(){
695             sellMarketingFee = 99;
696             botsShaken = true;
697         }
698 
699         function unshakeBots() external onlyOwner(){
700             sellMarketingFee = 45;
701             require(botsShaken = true, "Must shake bots before unshake");
702         }
703 
704         function excludeFromFees(address account, bool excluded) public onlyOwner {
705             _isExcludedFromFees[account] = excluded;
706             emit ExcludeFromFees(account, excluded);
707         }
708 
709         function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
710 
711             require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
712             _setAutomatedMarketMakerPair(pair, value);
713         }
714 
715         function _setAutomatedMarketMakerPair(address pair, bool value) private {
716 
717             automatedMarketMakerPairs[pair] = value;
718             emit SetAutomatedMarketMakerPair(pair, value);
719         }
720 
721         function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
722             emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
723             marketingWallet = newMarketingWallet;
724         }
725 
726         function isExcludedFromFees(address account) public view returns(bool) {
727             return _isExcludedFromFees[account];
728         }
729 
730         function _transfer(
731             address from,
732             address to,
733             uint256 amount
734         ) internal override {
735             require(from != address(0), "ERC20: transfer from the zero address");
736             require(to != address(0), "ERC20: transfer to the zero address");
737             
738             if(amount == 0) {
739                 super._transfer(from, to, 0);
740                 return;
741             }
742                 if (
743                     from != owner() &&
744 
745                     to != owner() &&
746                     to != address(0) &&
747 
748                     to != address(0xdead) &&
749                     !swapping
750                 ){
751                     //when buy
752                     if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
753                             require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
754                             require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
755 
756                     }
757                     
758                     //when sell
759                     else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
760                             require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
761                     }
762                 }
763             uint256 contractTokenBalance = balanceOf(address(this));
764             bool canSwap = contractTokenBalance >= swapTokensAtAmount;
765 
766             if( 
767                 canSwap &&
768                 swapEnabled &&
769                 !swapping &&
770                 !automatedMarketMakerPairs[from] &&
771                 !_isExcludedFromFees[from] &&
772                 !_isExcludedFromFees[to]
773             ) {
774                 swapping = true; 
775                 swapBack();
776                 swapping = false;
777             }
778             bool takeFee = !swapping;
779 
780 
781             if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
782 
783                 takeFee = false;
784             }
785             uint256 fees = 0;
786             if(takeFee){
787                 if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
788                     fees = amount.mul(sellTotalFees).div(100);
789                     tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
790                     tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
791                     tokensForBurn += fees * sellBurnFee / sellTotalFees;
792                 }
793                 else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
794                     fees = amount.mul(buyTotalFees).div(100);
795                     tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
796                     tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
797                     tokensForBurn += fees * buyBurnFee / buyTotalFees;
798                 }
799                 
800                 if(fees > 0){    
801                     super._transfer(from, address(this), (fees - tokensForBurn));
802                 }
803 
804                 if(tokensForBurn > 0){
805                     super._transfer(from, deadAddress, tokensForBurn);
806                     tokensForBurn = 0;
807                 }
808                 amount -= fees;
809             }
810             super._transfer(from, to, amount);
811         }
812 
813         function swapTokensForEth(uint256 tokenAmount) private {
814             address[] memory path = new address[](2);
815 
816             path[0] = address(this);
817 
818             path[1] = uniswapV2Router.WETH();
819             _approve(address(this), address(uniswapV2Router), tokenAmount);
820             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
821                 tokenAmount,
822                 0,
823                 path,
824                 address(this),
825                 block.timestamp
826             );
827         }
828         function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
829             _approve(address(this), address(uniswapV2Router), tokenAmount);
830             uniswapV2Router.addLiquidityETH{value: ethAmount}(
831                 address(this),
832                 tokenAmount,
833                 0,
834                 0,
835                 deadAddress,
836                 block.timestamp
837             );
838         }
839 
840         function swapBack() private {
841             uint256 contractBalance = balanceOf(address(this));
842             uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
843             
844             if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
845             uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
846             uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
847             uint256 initialETHBalance = address(this).balance;
848             swapTokensForEth(amountToSwapForETH); 
849             uint256 ethBalance = address(this).balance.sub(initialETHBalance);
850             uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
851 
852 
853             uint256 ethForLiquidity = ethBalance - ethForMarketing;
854 
855             tokensForLiquidity = 0;
856             tokensForMarketing = 0;
857             
858             (bool success,) = address(marketingWallet).call{value: ethForMarketing}("");
859             if(liquidityTokens > 0 && ethForLiquidity > 0){
860                 addLiquidity(liquidityTokens, ethForLiquidity);
861                 emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
862             }
863 
864             (success,) = address(marketingWallet).call{value: address(this).balance}("");
865         }
866         
867     }