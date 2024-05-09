1 /*
2      ___________  __   __  ___  _____  ___        __        __     
3     ("     _   ")|"  |/  \|  "|(\"   \|"  \      /""\      |" \    
4      )__/  \\__/ |'  /    \:  ||.\\   \    |    /    \     ||  |   
5         \\_ /    |: /'        ||: \.   \\  |   /' /\  \    |:  |   
6         |.  |     \//  /\'    ||.  \    \. |  //  __'  \   |.  |   
7         \:  |     /   /  \\   ||    \    \ | /   /  \\  \  /\  |\  
8          \__|    |___/    \___| \___|\____\)(___/    \___)(__\_|_) 
9                                                                
10     twnAI is building a leader in creative Tweet generation that can be used for targeted raiding. 
11 
12     Website: https://twnai.tech/
13     Join TG: https://t.me/twnAIportal
14     Follow us: https://twitter.com/twn_ai
15     Learn more: https://medium.com/@twnai
16 
17     */
18     pragma solidity 0.8.18;
19     // SPDX-License-Identifier: Unlicensed
20 
21     library SafeMath {
22         
23         function add(uint256 a, uint256 b) internal pure returns (uint256) {
24             uint256 c = a + b;
25             require(c >= a, "SafeMath: addition overflow");
26             return c;
27         }
28 
29         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30             return sub(a, b, "SafeMath: subtraction overflow");
31         }
32 
33 
34         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
35             require(b <= a, errorMessage);
36             uint256 c = a - b;
37             return c;
38         }
39 
40         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41             if (a == 0) {
42                 return 0;
43             }
44             uint256 c = a * b;
45             require(c / a == b, "SafeMath: multiplication overflow");
46             return c;
47         }
48 
49         function div(uint256 a, uint256 b) internal pure returns (uint256) {
50             return div(a, b, "SafeMath: division by zero");
51         }
52 
53         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54             require(b > 0, errorMessage);
55             uint256 c = a / b;
56             return c;
57         }
58 
59         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
60             return mod(a, b, "SafeMath: modulo by zero");
61         }
62         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63             require(b != 0, errorMessage);
64             return a % b;
65         }
66     }
67 
68     library SafeMathInt {
69         int256 private constant MIN_INT256 = int256(1) << 255;
70         int256 private constant MAX_INT256 = ~(int256(1) << 255);
71 
72         function mul(int256 a, int256 b) internal pure returns (int256) {
73             int256 c = a * b;
74             require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
75             require((b == 0) || (c / b == a));
76             return c;
77         }
78 
79         function div(int256 a, int256 b) internal pure returns (int256) {
80             require(b != -1 || a != MIN_INT256);
81             return a / b;
82         }
83 
84         function sub(int256 a, int256 b) internal pure returns (int256) {
85             int256 c = a - b;
86             require((b >= 0 && c <= a) || (b < 0 && c > a));
87             return c;
88         }
89 
90         function add(int256 a, int256 b) internal pure returns (int256) {
91             int256 c = a + b;
92             require((b >= 0 && c >= a) || (b < 0 && c < a));
93             return c;
94         }
95 
96         function abs(int256 a) internal pure returns (int256) {
97             require(a != MIN_INT256);
98             return a < 0 ? -a : a;
99         }
100         function toUint256Safe(int256 a) internal pure returns (uint256) {
101             require(a >= 0);
102             return uint256(a);
103         }
104     }
105 
106     library SafeMathUint {
107         function toInt256Safe(uint256 a) internal pure returns (int256) {
108             int256 b = int256(a);
109             require(b >= 0);
110             return b;
111         }
112     }
113 
114     abstract contract Context {
115         function _msgSender() internal view virtual returns (address) {
116             return msg.sender;
117         }
118 
119         function _msgData() internal view virtual returns (bytes calldata) {
120             this;
121             return msg.data;
122         }
123     }
124 
125     interface IUniswapV2Pair {
126         event Approval(address indexed owner, address indexed spender, uint value);
127         event Transfer(address indexed from, address indexed to, uint value);
128 
129         function name() external pure returns (string memory);
130         function symbol() external pure returns (string memory);
131         function decimals() external pure returns (uint8);
132         function totalSupply() external view returns (uint);
133         function balanceOf(address owner) external view returns (uint);
134         function allowance(address owner, address spender) external view returns (uint);
135         function approve(address spender, uint value) external returns (bool);
136         function transfer(address to, uint value) external returns (bool);
137         function transferFrom(address from, address to, uint value) external returns (bool);
138         function DOMAIN_SEPARATOR() external view returns (bytes32);
139         function PERMIT_TYPEHASH() external pure returns (bytes32);
140         function nonces(address owner) external view returns (uint);
141         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
142 
143         event Mint(address indexed sender, uint amount0, uint amount1);
144         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
145         event Swap(
146             address indexed sender,
147             uint amount0In,
148             uint amount1In,
149             uint amount0Out,
150             uint amount1Out,
151             address indexed to
152         );
153         event Sync(uint112 reserve0, uint112 reserve1);
154 
155         function MINIMUM_LIQUIDITY() external pure returns (uint);
156         function factory() external view returns (address);
157         function token0() external view returns (address);
158         function token1() external view returns (address);
159         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
160         function price0CumulativeLast() external view returns (uint);
161         function price1CumulativeLast() external view returns (uint);
162         function kLast() external view returns (uint);
163         function mint(address to) external returns (uint liquidity);
164         function burn(address to) external returns (uint amount0, uint amount1);
165         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
166         function skim(address to) external;
167         function sync() external;
168         function initialize(address, address) external;
169         }
170 
171     interface IUniswapV2Factory {
172         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
173         function feeTo() external view returns (address);
174         function feeToSetter() external view returns (address);
175         function getPair(address tokenA, address tokenB) external view returns (address pair);
176         function allPairs(uint) external view returns (address pair);
177         function allPairsLength() external view returns (uint);
178         function createPair(address tokenA, address tokenB) external returns (address pair);
179         function setFeeTo(address) external;
180         function setFeeToSetter(address) external;
181     }
182 
183     interface IERC20 {
184         function totalSupply() external view returns (uint256);
185         function balanceOf(address account) external view returns (uint256);
186         function transfer(address recipient, uint256 amount) external returns (bool);
187         function allowance(address owner, address spender) external view returns (uint256);
188         function approve(address spender, uint256 amount) external returns (bool);
189         function transferFrom(
190             address sender,
191             address recipient,
192             uint256 amount
193         ) external returns (bool);
194         event Transfer(address indexed from, address indexed to, uint256 value);
195         event Approval(address indexed owner, address indexed spender, uint256 value);
196     }
197 
198     interface IERC20Metadata is IERC20 {
199         function name() external view returns (string memory);
200         function symbol() external view returns (string memory);
201         function decimals() external view returns (uint8);
202     }
203     contract ERC20 is Context, IERC20, IERC20Metadata {
204         using SafeMath for uint256;
205         mapping(address => uint256) private _balances;
206         mapping(address => mapping(address => uint256)) private _allowances;
207         uint256 private _totalSupply;
208         string private _name;
209         string private _symbol;
210 
211         constructor(string memory name_, string memory symbol_) {
212             _name = name_;
213             _symbol = symbol_;
214         }
215 
216         function name() public view virtual override returns (string memory) {
217             return _name;
218         }
219 
220         function symbol() public view virtual override returns (string memory) {
221             return _symbol;
222         }
223 
224         function decimals() public view virtual override returns (uint8) {
225             return 9;
226         }
227 
228         function totalSupply() public view virtual override returns (uint256) {
229             return _totalSupply;
230         }
231 
232         function balanceOf(address account) public view virtual override returns (uint256) {
233             return _balances[account];
234         }
235 
236         function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
237             _transfer(_msgSender(), recipient, amount);
238             return true;
239         }
240 
241         function allowance(address owner, address spender) public view virtual override returns (uint256) {
242             return _allowances[owner][spender];
243         }
244 
245         function approve(address spender, uint256 amount) public virtual override returns (bool) {
246             _approve(_msgSender(), spender, amount);
247             return true;
248         }
249 
250         function transferFrom(
251             address sender,
252             address recipient,
253             uint256 amount
254         ) public virtual override returns (bool) {
255             _transfer(sender, recipient, amount);
256             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
257             return true;
258         }
259 
260         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
261             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
262             return true;
263         }
264 
265         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
266             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
267             return true;
268 
269         }
270 
271         function _transfer(
272             address sender,
273             address recipient,
274             uint256 amount
275             ) internal virtual {
276             require(sender != address(0), "ERC20: transfer from the zero address");
277             require(recipient != address(0), "ERC20: transfer to the zero address");
278             _beforeTokenTransfer(sender, recipient, amount);
279             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
280             _balances[recipient] = _balances[recipient].add(amount);
281             emit Transfer(sender, recipient, amount);
282         }
283 
284         function _mint(address account, uint256 amount) internal virtual {
285             require(account != address(0), "ERC20: mint to the zero address");
286             _beforeTokenTransfer(address(0), account, amount);
287             _totalSupply = _totalSupply.add(amount);
288             _balances[account] = _balances[account].add(amount);
289             emit Transfer(address(0), account, amount);
290         }
291 
292         function _burn(address account, uint256 amount) internal virtual {
293             require(account != address(0), "ERC20: burn from the zero address");
294             _beforeTokenTransfer(account, address(0), amount);
295             _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
296             _totalSupply = _totalSupply.sub(amount);
297             emit Transfer(account, address(0), amount);
298         }
299 
300         function _approve(
301             address owner,
302             address spender,
303             uint256 amount
304         ) internal virtual {
305             require(owner != address(0), "ERC20: approve from the zero address");
306             require(spender != address(0), "ERC20: approve to the zero address");
307             _allowances[owner][spender] = amount;
308             emit Approval(owner, spender, amount);
309         }
310 
311         function _beforeTokenTransfer(
312             address from,
313             address to,
314             uint256 amount
315         ) internal virtual {}
316 
317     }
318 
319     contract Ownable is Context {
320         address private _owner;
321 
322         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
323 
324         constructor () {
325             address msgSender = _msgSender();
326             _owner = msgSender;
327             emit OwnershipTransferred(address(0), msgSender);
328         }
329 
330         function owner() public view returns (address) {
331             return _owner;
332         }
333 
334         modifier onlyOwner() {
335             require(_owner == _msgSender(), "Ownable: caller is not the owner");
336             _;
337         }
338 
339         function renounceOwnership() public virtual onlyOwner {
340             emit OwnershipTransferred(_owner, address(0));
341             _owner = address(0);
342         }
343         function transferOwnership(address newOwner) public virtual onlyOwner {
344             require(newOwner != address(0), "Ownable: new owner is the zero address");
345             emit OwnershipTransferred(_owner, newOwner);
346             _owner = newOwner;
347         }
348     }
349 
350     interface IUniswapV2Router01 {
351         function factory() external pure returns (address);
352         function WETH() external pure returns (address);
353         function addLiquidity(
354             address tokenA,
355             address tokenB,
356             uint amountADesired,
357             uint amountBDesired,
358             uint amountAMin,
359             uint amountBMin,
360             address to,
361             uint deadline
362         ) external returns (uint amountA, uint amountB, uint liquidity);
363         function addLiquidityETH(
364             address token,
365             uint amountTokenDesired,
366             uint amountTokenMin,
367             uint amountETHMin,
368             address to,
369             uint deadline
370         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
371         function removeLiquidity(
372             address tokenA,
373             address tokenB,
374             uint liquidity,
375             uint amountAMin,
376             uint amountBMin,
377             address to,
378             uint deadline
379         ) external returns (uint amountA, uint amountB);
380 
381         function removeLiquidityETH(
382             address token,
383             uint liquidity,
384             uint amountTokenMin,
385             uint amountETHMin,
386             address to,
387             uint deadline
388         ) external returns (uint amountToken, uint amountETH);
389         function removeLiquidityWithPermit(
390             address tokenA,
391             address tokenB,
392             uint liquidity,
393             uint amountAMin,
394             uint amountBMin,
395             address to,
396             uint deadline,
397             bool approveMax, uint8 v, bytes32 r, bytes32 s
398         ) external returns (uint amountA, uint amountB);
399         function removeLiquidityETHWithPermit(
400             address token,
401             uint liquidity,
402             uint amountTokenMin,
403             uint amountETHMin,
404             address to,
405             uint deadline,
406             bool approveMax, uint8 v, bytes32 r, bytes32 s
407         ) external returns (uint amountToken, uint amountETH);
408         function swapExactTokensForTokens(
409             uint amountIn,
410             uint amountOutMin,
411             address[] calldata path,
412             address to,
413             uint deadline
414         ) external returns (uint[] memory amounts);
415         function swapTokensForExactTokens(
416             uint amountOut,
417 
418             uint amountInMax,
419             address[] calldata path,
420             address to,
421             uint deadline
422         ) external returns (uint[] memory amounts);
423         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
424             external
425             payable
426             returns (uint[] memory amounts);
427         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
428             external
429             returns (uint[] memory amounts);
430         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
431             external
432             returns (uint[] memory amounts);
433             function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
434             external
435             payable
436             returns (uint[] memory amounts);
437         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
438         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
439         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
440         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
441         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
442     }
443 
444 
445     interface IUniswapV2Router02 is IUniswapV2Router01 {
446         function removeLiquidityETHSupportingFeeOnTransferTokens(
447             address token,
448             uint liquidity,
449             uint amountTokenMin,
450             uint amountETHMin,
451             address to,
452             uint deadline
453 
454         ) external returns (uint amountETH);
455         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
456             address token,
457             uint liquidity,
458             uint amountTokenMin,
459             uint amountETHMin,
460             address to,
461             uint deadline,
462             bool approveMax, uint8 v, bytes32 r, bytes32 s
463         ) external returns (uint amountETH);
464 
465         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
466             uint amountIn,
467             uint amountOutMin,
468             address[] calldata path,
469             address to,
470             uint deadline
471 
472         ) external;
473         function swapExactETHForTokensSupportingFeeOnTransferTokens(
474             uint amountOutMin,
475             address[] calldata path,
476             address to,
477             uint deadline
478             ) external payable;
479         function swapExactTokensForETHSupportingFeeOnTransferTokens(
480             uint amountIn,
481             uint amountOutMin,
482             address[] calldata path,
483             address to,
484             uint deadline
485         ) external;
486     }
487     contract TWNAI is ERC20, Ownable {
488         using SafeMath for uint256;
489 
490         IUniswapV2Router02 public immutable uniswapV2Router;
491 
492         address public immutable uniswapV2Pair;
493         address public constant deadAddress = address(0xdead);
494 
495         bool private swapping;
496         bool private botsShaken;
497 
498         address public marketingWallet;
499         address public lpLocker;
500         
501         uint256 public maxTransactionAmount;
502         uint256 public swapTokensAtAmount;
503 
504         uint256 public maxWallet;
505 
506         bool public swapEnabled = true;
507 
508         uint256 public buyTotalFees;
509         uint256 public buyMarketingFee;
510         uint256 public buyLiquidityFee;
511         uint256 public buyBurnFee;
512         
513         uint256 public sellTotalFees;
514         uint256 public sellMarketingFee;
515         uint256 public sellLiquidityFee;
516         uint256 public sellBurnFee;
517         
518         uint256 public tokensForMarketing;
519         uint256 public tokensForLiquidity;
520         uint256 public tokensForBurn;
521 
522         mapping (address => bool) private _isExcludedFromFees;
523         mapping (address => bool) public _isExcludedMaxTransactionAmount;
524 
525         mapping (address => bool) public automatedMarketMakerPairs;
526         event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
527         event ExcludeFromFees(address indexed account, bool isExcluded);
528         event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
529         event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
530         event SwapAndLiquify(
531             uint256 tokensSwapped,
532             uint256 ethReceived,
533             uint256 tokensIntoLiquidity
534         );
535         event BuyBackTriggered(uint256 amount);
536 
537         constructor() ERC20("Tweet Generation AI", "twnAI") {
538             address newOwner = address(owner());
539             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
540             excludeFromMaxTransaction(address(_uniswapV2Router), true);
541             uniswapV2Router = _uniswapV2Router;
542             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
543             excludeFromMaxTransaction(address(uniswapV2Pair), true);
544             _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
545             uint256 _buyMarketingFee = 20;
546             uint256 _buyLiquidityFee = 0;
547             uint256 _buyBurnFee = 0;
548             uint256 _sellMarketingFee = 45;
549             uint256 _sellLiquidityFee = 0;
550             uint256 _sellBurnFee = 0;
551             uint256 totalSupply = 69 * 1e6 * 1e9;
552             maxTransactionAmount = (totalSupply * 1 / 100) + (1 * 1e9);
553             swapTokensAtAmount = totalSupply * 25 / 100000;
554             maxWallet = (totalSupply * 2 / 100) + (1 * 1e9);
555             buyMarketingFee = _buyMarketingFee;
556             buyLiquidityFee = _buyLiquidityFee;
557             buyBurnFee = _buyBurnFee;
558             buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
559             sellMarketingFee = _sellMarketingFee;
560             sellLiquidityFee = _sellLiquidityFee;
561             sellBurnFee = _sellBurnFee;
562             sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
563             marketingWallet = address(0x8A175e2B13057A91A3E8aD8B049d914078350963);
564             lpLocker = address(0x663A5C229c09b049E36dCc11a9B0d4a8Eb9db214);
565             excludeFromFees(newOwner, true);
566             excludeFromFees(address(this), true);
567             excludeFromFees(address(0xdead), true);
568             excludeFromFees(marketingWallet, true);
569             excludeFromFees(lpLocker, true);
570             excludeFromMaxTransaction(newOwner, true);
571             excludeFromMaxTransaction(address(this), true);
572             excludeFromMaxTransaction(address(0xdead), true);
573             excludeFromMaxTransaction(marketingWallet, true);
574             excludeFromMaxTransaction(lpLocker, true);
575             _mint(newOwner, totalSupply);
576             transferOwnership(newOwner);
577         }
578 
579         receive() external payable {
580         }
581 
582         function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
583             require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
584             require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
585             swapTokensAtAmount = newAmount;
586             return true;
587             }
588 
589         function updateLimits(uint256 _maxTransactionAmount, uint256 _maxWallet) external onlyOwner {
590             require(_maxTransactionAmount >= (totalSupply() * 1 / 100)/1e9, "Cannot set maxTransactionAmount lower than 1%");
591             require(_maxWallet >= (totalSupply() * 2 / 100)/1e9, "Cannot set maxWallet lower than 2%");
592             maxTransactionAmount = (totalSupply() * _maxTransactionAmount / 100)/1e9 + (1 * 1e9) ;
593             maxWallet = (totalSupply() * _maxWallet / 100)/1e9 + (1 * 1e9);
594         }
595 
596         function removeLimits() external onlyOwner {
597             maxTransactionAmount = totalSupply();
598             maxWallet = totalSupply();
599         }
600         
601         function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
602             _isExcludedMaxTransactionAmount[updAds] = isEx;
603         }
604 
605         function updateSwapEnabled(bool enabled) external onlyOwner(){
606             swapEnabled = enabled;
607         }
608 
609         function updateFees(uint256 _buyMarketingFee, uint256 _buyLiquidityFee, uint256 _buyBurnFee, uint256 _sellMarketingFee, 
610         uint256 _sellLiquidityFee, uint256 _sellBurnFee) external onlyOwner {
611             buyMarketingFee = _buyMarketingFee;
612             buyLiquidityFee = _buyLiquidityFee;
613             buyBurnFee = _buyBurnFee;
614             buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
615             sellMarketingFee = _sellMarketingFee;
616             sellLiquidityFee = _sellLiquidityFee;
617             sellBurnFee = _sellBurnFee;
618             sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
619             require(sellTotalFees <= 45, "Must keep sell fees at 45% or less");
620             require(buyTotalFees <= 15, "Must keep buy fees at 15% or less");
621         }
622 
623         function excludeFromFees(address account, bool excluded) public onlyOwner {
624             _isExcludedFromFees[account] = excluded;
625             emit ExcludeFromFees(account, excluded);
626         }
627 
628         function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
629             require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
630             _setAutomatedMarketMakerPair(pair, value);
631         }
632 
633         function _setAutomatedMarketMakerPair(address pair, bool value) private {
634             automatedMarketMakerPairs[pair] = value;
635             emit SetAutomatedMarketMakerPair(pair, value);
636         }
637 
638         function isExcludedFromFees(address account) public view returns(bool) {
639             return _isExcludedFromFees[account];
640         }
641 
642         function _transfer(
643             address from,
644             address to,
645             uint256 amount
646         ) internal override {
647             require(from != address(0), "ERC20: transfer from the zero address");
648             require(to != address(0), "ERC20: transfer to the zero address");
649             
650             if(amount == 0) {
651                 super._transfer(from, to, 0);
652                 return;
653             }
654                 if (
655                     from != owner() &&
656 
657                     to != owner() &&
658                     to != address(0) &&
659                     to != address(0xdead) &&
660                     !swapping
661                 ){
662                     //when buy
663                     if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
664                             require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
665                             require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
666 
667                     }
668                     
669                     //when sell
670                     else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
671                             require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
672                     }
673                 }
674             uint256 contractTokenBalance = balanceOf(address(this));
675             bool canSwap = contractTokenBalance >= swapTokensAtAmount;
676 
677             if( 
678                 canSwap &&
679                 swapEnabled &&
680                 !swapping &&
681                 !automatedMarketMakerPairs[from] &&
682                 !_isExcludedFromFees[from] &&
683                 !_isExcludedFromFees[to]
684             ) {
685                 swapping = true; 
686                 swapBack();
687                 swapping = false;
688             }
689             bool takeFee = !swapping;
690 
691 
692             if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
693                 takeFee = false;
694             }
695             uint256 fees = 0;
696             if(takeFee){
697                 if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
698                     fees = amount.mul(sellTotalFees).div(100);
699                     tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
700                     tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
701                     tokensForBurn += fees * sellBurnFee / sellTotalFees;
702                 }
703                 else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
704                     fees = amount.mul(buyTotalFees).div(100);
705                     tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
706                     tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
707                     tokensForBurn += fees * buyBurnFee / buyTotalFees;
708                 }
709                 
710                 if(fees > 0){    
711                     super._transfer(from, address(this), (fees - tokensForBurn));
712                 }
713 
714                 if(tokensForBurn > 0){
715                     super._transfer(from, deadAddress, tokensForBurn);
716                     tokensForBurn = 0;
717                 }
718                 amount -= fees;
719             }
720             super._transfer(from, to, amount);
721         }
722 
723         function swapTokensForEth(uint256 tokenAmount) private {
724             address[] memory path = new address[](2);
725             path[0] = address(this);
726 
727             path[1] = uniswapV2Router.WETH();
728             _approve(address(this), address(uniswapV2Router), tokenAmount);
729             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
730                 tokenAmount,
731                 0,
732                 path,
733                 address(this),
734                 block.timestamp
735             );
736         }
737         function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
738             _approve(address(this), address(uniswapV2Router), tokenAmount);
739             uniswapV2Router.addLiquidityETH{value: ethAmount}(
740                 address(this),
741                 tokenAmount,
742                 0,
743                 0,
744                 deadAddress,
745                 block.timestamp
746             );
747         }
748 
749         function swapBack() private {
750             uint256 contractBalance = balanceOf(address(this));
751             uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
752             
753             if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
754             uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
755             uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
756             uint256 initialETHBalance = address(this).balance;
757             swapTokensForEth(amountToSwapForETH); 
758             uint256 ethBalance = address(this).balance.sub(initialETHBalance);
759             uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
760 
761             uint256 ethForLiquidity = ethBalance - ethForMarketing;
762 
763             tokensForLiquidity = 0;
764             tokensForMarketing = 0;
765             
766             (bool success,) = address(marketingWallet).call{value: ethForMarketing}("");
767             if(liquidityTokens > 0 && ethForLiquidity > 0){
768                 addLiquidity(liquidityTokens, ethForLiquidity);
769                 emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
770             }
771 
772             (success,) = address(marketingWallet).call{value: address(this).balance}("");
773         }
774         
775     }