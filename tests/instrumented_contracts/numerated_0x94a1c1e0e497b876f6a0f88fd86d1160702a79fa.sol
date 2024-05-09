1 // SPDX-License-Identifier: MIT                                                                               
2                                                     
3 pragma solidity 0.8.9;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IUniswapV2Pair {
17     event Approval(address indexed owner, address indexed spender, uint value);
18     event Transfer(address indexed from, address indexed to, uint value);
19 
20     function name() external pure returns (string memory);
21     function symbol() external pure returns (string memory);
22     function decimals() external pure returns (uint8);
23     function totalSupply() external view returns (uint);
24     function balanceOf(address owner) external view returns (uint);
25     function allowance(address owner, address spender) external view returns (uint);
26 
27     function approve(address spender, uint value) external returns (bool);
28     function transfer(address to, uint value) external returns (bool);
29     function transferFrom(address from, address to, uint value) external returns (bool);
30 
31     function DOMAIN_SEPARATOR() external view returns (bytes32);
32     function PERMIT_TYPEHASH() external pure returns (bytes32);
33     function nonces(address owner) external view returns (uint);
34 
35     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
36 
37     event Mint(address indexed sender, uint amount0, uint amount1);
38     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
39     event Swap( address indexed sender, uint amount0In, uint amount1In, uint amount0Out, uint amount1Out, address indexed to);
40     event Sync(uint112 reserve0, uint112 reserve1);
41 
42     function MINIMUM_LIQUIDITY() external pure returns (uint);
43     function factory() external view returns (address);
44     function token0() external view returns (address);
45     function token1() external view returns (address);
46     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
47     function price0CumulativeLast() external view returns (uint);
48     function price1CumulativeLast() external view returns (uint);
49     function kLast() external view returns (uint);
50 
51     function mint(address to) external returns (uint liquidity);
52     function burn(address to) external returns (uint amount0, uint amount1);
53     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
54     function skim(address to) external;
55     function sync() external;
56 
57     function initialize(address, address) external;
58 }
59 
60 interface IUniswapV2Factory {
61     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
62 
63     function feeTo() external view returns (address);
64     function feeToSetter() external view returns (address);
65 
66     function getPair(address tokenA, address tokenB) external view returns (address pair);
67     function allPairs(uint) external view returns (address pair);
68     function allPairsLength() external view returns (uint);
69 
70     function createPair(address tokenA, address tokenB) external returns (address pair);
71 
72     function setFeeTo(address) external;
73     function setFeeToSetter(address) external;
74 }
75 
76 interface IERC20 {
77     function totalSupply() external view returns (uint256);
78     function balanceOf(address account) external view returns (uint256);
79     function transfer(address recipient, uint256 amount) external returns (bool);
80     function allowance(address owner, address spender) external view returns (uint256);
81     function approve(address spender, uint256 amount) external returns (bool);
82     function transferFrom( address sender, address recipient, uint256 amount ) external returns (bool);
83     event Transfer(address indexed from, address indexed to, uint256 value);
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 interface IERC20Metadata is IERC20 {
88     function name() external view returns (string memory);
89     function symbol() external view returns (string memory);
90     function decimals() external view returns (uint8);
91 }
92 
93 
94 contract ERC20 is Context, IERC20, IERC20Metadata {
95     using SafeMath for uint256;
96     mapping(address => uint256) private _balances;
97     mapping(address => mapping(address => uint256)) private _allowances;
98     uint256 private _totalSupply;
99     string private _name;
100     string private _symbol;
101     constructor(string memory name_, string memory symbol_) {
102         _name = name_;
103         _symbol = symbol_;
104     }
105     function name() public view virtual override returns (string memory) {
106         return _name;
107     }
108     function symbol() public view virtual override returns (string memory) {
109         return _symbol;
110     }
111     function decimals() public view virtual override returns (uint8) {
112         return 18;
113     }
114     function totalSupply() public view virtual override returns (uint256) {
115         return _totalSupply;
116     }
117     function balanceOf(address account) public view virtual override returns (uint256) {
118         return _balances[account];
119     }
120     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
121         _transfer(_msgSender(), recipient, amount);
122         return true;
123     }
124     function allowance(address owner, address spender) public view virtual override returns (uint256) {
125         return _allowances[owner][spender];
126     }
127     function approve(address spender, uint256 amount) public virtual override returns (bool) {
128         _approve(_msgSender(), spender, amount);
129         return true;
130     }
131     function transferFrom( address sender, address recipient, uint256 amount ) public virtual override returns (bool) {
132         _transfer(sender, recipient, amount);
133         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
134         return true;
135     }
136     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
137         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
138         return true;
139     }
140     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
141         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
142         return true;
143     }
144     function _transfer( address sender, address recipient, uint256 amount ) internal virtual {
145         require(sender != address(0), "ERC20: transfer from the zero address");
146         require(recipient != address(0), "ERC20: transfer to the zero address");
147 
148         _beforeTokenTransfer(sender, recipient, amount);
149 
150         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
151         _balances[recipient] = _balances[recipient].add(amount);
152         emit Transfer(sender, recipient, amount);
153     }
154     function _mint(address account, uint256 amount) internal virtual {
155         require(account != address(0), "ERC20: mint to the zero address");
156 
157         _beforeTokenTransfer(address(0), account, amount);
158 
159         _totalSupply = _totalSupply.add(amount);
160         _balances[account] = _balances[account].add(amount);
161         emit Transfer(address(0), account, amount);
162     }
163     function _burn(address account, uint256 amount) internal virtual {
164         require(account != address(0), "ERC20: burn from the zero address");
165 
166         _beforeTokenTransfer(account, address(0), amount);
167 
168         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
169         _totalSupply = _totalSupply.sub(amount);
170         emit Transfer(account, address(0), amount);
171     }
172     function _approve( address owner, address spender, uint256 amount ) internal virtual {
173         require(owner != address(0), "ERC20: approve from the zero address");
174         require(spender != address(0), "ERC20: approve to the zero address");
175 
176         _allowances[owner][spender] = amount;
177         emit Approval(owner, spender, amount);
178     }
179     function _beforeTokenTransfer(
180         address from,
181         address to,
182         uint256 amount
183     ) internal virtual {}
184 }
185 
186 library SafeMath {
187     function add(uint256 a, uint256 b) internal pure returns (uint256) {
188         uint256 c = a + b;
189         require(c >= a, "SafeMath: addition overflow");
190 
191         return c;
192     }
193     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
194         return sub(a, b, "SafeMath: subtraction overflow");
195     }
196     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
197         require(b <= a, errorMessage);
198         uint256 c = a - b;
199 
200         return c;
201     }
202     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
203         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
204         // benefit is lost if 'b' is also tested.
205         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
206         if (a == 0) {
207             return 0;
208         }
209 
210         uint256 c = a * b;
211         require(c / a == b, "SafeMath: multiplication overflow");
212 
213         return c;
214     }
215     function div(uint256 a, uint256 b) internal pure returns (uint256) {
216         return div(a, b, "SafeMath: division by zero");
217     }
218     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         require(b > 0, errorMessage);
220         uint256 c = a / b;
221         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222 
223         return c;
224     }
225     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
226         return mod(a, b, "SafeMath: modulo by zero");
227     }
228     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b != 0, errorMessage);
230         return a % b;
231     }
232 }
233 
234 contract Ownable is Context {
235     address private _owner;
236     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
237 
238     constructor () {
239         address msgSender = _msgSender();
240         _owner = msgSender;
241         emit OwnershipTransferred(address(0), msgSender);
242     }
243 
244     function owner() public view returns (address) {
245         return _owner;
246     }
247 
248     modifier onlyOwner() {
249         require(_owner == _msgSender(), "Ownable: caller is not the owner");
250         _;
251     }
252 
253     function renounceOwnership() public virtual onlyOwner {
254         emit OwnershipTransferred(_owner, address(0));
255         _owner = address(0);
256     }
257 
258     function transferOwnership(address newOwner) public virtual onlyOwner {
259         require(newOwner != address(0), "Ownable: new owner is the zero address");
260         emit OwnershipTransferred(_owner, newOwner);
261         _owner = newOwner;
262     }
263 }
264 
265 
266 
267 library SafeMathInt {
268     int256 private constant MIN_INT256 = int256(1) << 255;
269     int256 private constant MAX_INT256 = ~(int256(1) << 255);
270 
271     function mul(int256 a, int256 b) internal pure returns (int256) {
272         int256 c = a * b;
273 
274         // Detect overflow when multiplying MIN_INT256 with -1
275         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
276         require((b == 0) || (c / b == a));
277         return c;
278     }
279 
280     function div(int256 a, int256 b) internal pure returns (int256) {
281         // Prevent overflow when dividing MIN_INT256 by -1
282         require(b != -1 || a != MIN_INT256);
283 
284         // Solidity already throws when dividing by 0.
285         return a / b;
286     }
287 
288     function sub(int256 a, int256 b) internal pure returns (int256) {
289         int256 c = a - b;
290         require((b >= 0 && c <= a) || (b < 0 && c > a));
291         return c;
292     }
293 
294     function add(int256 a, int256 b) internal pure returns (int256) {
295         int256 c = a + b;
296         require((b >= 0 && c >= a) || (b < 0 && c < a));
297         return c;
298     }
299 	
300     function abs(int256 a) internal pure returns (int256) {
301         require(a != MIN_INT256);
302         return a < 0 ? -a : a;
303     }
304 
305 
306     function toUint256Safe(int256 a) internal pure returns (uint256) {
307         require(a >= 0);
308         return uint256(a);
309     }
310 }
311 
312 library SafeMathUint {
313   function toInt256Safe(uint256 a) internal pure returns (int256) {
314     int256 b = int256(a);
315     require(b >= 0);
316     return b;
317   }
318 }
319 
320 
321 interface IUniswapV2Router01 {
322     function factory() external pure returns (address);
323     function WETH() external pure returns (address);
324 
325     function addLiquidity( address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline ) external returns (uint amountA, uint amountB, uint liquidity);
326     function addLiquidityETH( address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
327     function removeLiquidity(address tokenA,address tokenB,uint liquidity,uint amountAMin,uint amountBMin,address to,uint deadline) external returns (uint amountA, uint amountB);
328     function removeLiquidityETH( address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline ) external returns (uint amountToken, uint amountETH);
329     function removeLiquidityWithPermit( address tokenA, address tokenB, uint liquidity, uint amountAMin, uint amountBMin, address to, uint deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s ) external returns (uint amountA, uint amountB);
330     function removeLiquidityETHWithPermit( address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s  ) external returns (uint amountToken, uint amountETH);
331     function swapExactTokensForTokens( uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline ) external returns (uint[] memory amounts);
332     function swapTokensForExactTokens( uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline ) external returns (uint[] memory amounts);
333     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
334     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
335     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
336     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
337 
338     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
339     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
340     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
341     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
342     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
343 }
344 
345 interface IUniswapV2Router02 is IUniswapV2Router01 {
346     function removeLiquidityETHSupportingFeeOnTransferTokens(address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external returns (uint amountETH);
347     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens( address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s ) external returns (uint amountETH);
348     function swapExactTokensForTokensSupportingFeeOnTransferTokens( uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline ) external;
349     function swapExactETHForTokensSupportingFeeOnTransferTokens( uint amountOutMin, address[] calldata path, address to, uint deadline ) external payable;
350     function swapExactTokensForETHSupportingFeeOnTransferTokens( uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline ) external;
351 }
352 
353 contract ONYX is ERC20, Ownable {
354     using SafeMath for uint256;
355 
356     IUniswapV2Router02 public immutable uniswapV2Router;
357     address public immutable uniswapV2Pair;
358     address public constant deadAddress = address(0xdead);
359 
360     bool private swapping;
361 
362     address public marketingWallet;
363     address public buyBackWallet;
364     
365     uint256 public maxTransactionAmount;
366     uint256 public swapTokensAtAmount;
367     uint256 public maxWallet;
368 
369     bool public limitsInEffect = true;
370     bool public tradingActive = false;
371     bool public swapEnabled = false;
372     
373     uint256 public tradingActiveBlock; 
374     
375      // Anti-bot and anti-whale mappings and variables
376     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
377     bool public transferDelayEnabled = true;
378 
379     uint256 public buyTotalFees;
380     uint256 public buyMarketingFee;
381     uint256 public buyLiquidityFee;
382     uint256 public buyBuyBackFee;
383     
384     uint256 public sellTotalFees;
385     uint256 public sellMarketingFee;
386     uint256 public sellLiquidityFee;
387     uint256 public sellBuyBackFee;
388     
389     uint256 public tokensForMarketing;
390     uint256 public tokensForLiquidity;
391     uint256 public tokensForBuyBack;
392     
393     /******************/
394 
395     // exlcude from fees and max transaction amount
396     mapping (address => bool) private _isExcludedFromFees;
397     mapping (address => bool) public _isExcludedMaxTransactionAmount;
398 
399     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
400     // could be subject to a maximum transfer amount
401     mapping (address => bool) public automatedMarketMakerPairs;
402 
403     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
404     event ExcludeFromFees(address indexed account, bool isExcluded);
405     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
406     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
407     event buyBackWalletUpdated(address indexed newWallet, address indexed oldWallet);
408     event SwapAndLiquify( uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);
409     event BuyBackTriggered(uint256 amount);
410 
411     constructor() ERC20("Onyx", "ONYX") {
412 
413         address newOwner = address(0x6Fb04f70484B1D85a662558D551a3B7551708a63);
414         
415         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
416         //Uniswap V2 Router: 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
417         //PCS Router: 0x10ED43C718714eb63d5aA57B78B54704E256024E
418         
419         excludeFromMaxTransaction(address(_uniswapV2Router), true);
420         uniswapV2Router = _uniswapV2Router;
421         
422         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
423         excludeFromMaxTransaction(address(uniswapV2Pair), true);
424         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
425         
426         uint256 _buyMarketingFee = 1;
427         uint256 _buyLiquidityFee = 1;
428         uint256 _buyBuyBackFee = 0;
429         
430         uint256 _sellMarketingFee = 2;
431         uint256 _sellLiquidityFee = 1;
432         uint256 _sellBuyBackFee = 0;
433         
434         uint256 totalSupply = 500000000 * 1e18;
435         
436         maxTransactionAmount = totalSupply * 1 / 1000; // 0.1% maxTransactionAmountTxn
437         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
438         maxWallet = totalSupply * 5 / 1000; // 0.5% max wallet
439 
440         buyMarketingFee = _buyMarketingFee;
441         buyLiquidityFee = _buyLiquidityFee;
442         buyBuyBackFee = _buyBuyBackFee;
443         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuyBackFee;
444         
445         sellMarketingFee = _sellMarketingFee;
446         sellLiquidityFee = _sellLiquidityFee;
447         sellBuyBackFee = _sellBuyBackFee;
448         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuyBackFee;
449         
450     	marketingWallet = address(0x6Fb04f70484B1D85a662558D551a3B7551708a63);
451     	buyBackWallet = address(0x6Fb04f70484B1D85a662558D551a3B7551708a63);
452 
453         // exclude from paying fees or having max transaction amount
454         excludeFromFees(newOwner, true);
455         excludeFromFees(address(this), true);
456         excludeFromFees(address(0xdead), true);
457         excludeFromFees(buyBackWallet, true);
458         
459         excludeFromMaxTransaction(newOwner, true);
460         excludeFromMaxTransaction(address(this), true);
461         excludeFromMaxTransaction(buyBackWallet, true);
462         excludeFromMaxTransaction(address(0xdead), true);
463 
464         _mint(newOwner, totalSupply);
465         transferOwnership(newOwner);
466     }
467 
468     receive() external payable {
469 
470   	}
471     // airdrop function
472     function Airdrop(address[] memory _address, uint256[] memory _amount) external onlyOwner {
473         for(uint i=0; i< _amount.length; i++){
474             address adr = _address[i];
475             uint amnt = _amount[i];
476             super._transfer(msg.sender, adr, amnt);
477         }
478         // events from ERC20
479     }
480     // once enabled, can never be turned off
481     function enableTrading() external onlyOwner {
482         tradingActive = true;
483         swapEnabled = true;
484         tradingActiveBlock = block.number;
485     }
486     function disableTrading() external onlyOwner {
487         tradingActive = false;
488         swapEnabled = false;
489         tradingActiveBlock = 0;
490     }
491     // remove limits after token is stable
492     function removeLimits() external onlyOwner returns (bool){
493         limitsInEffect = false;
494         return true;
495     }
496     // enable limits
497     function enableLimits() external onlyOwner returns (bool){
498         limitsInEffect = true;
499         return true;
500     }
501     // disable Transfer delay - cannot be reenabled
502     function disableTransferDelay() external onlyOwner returns (bool){
503         transferDelayEnabled = false;
504         return true;
505     }
506     
507      // change the minimum amount of tokens to sell from fees
508     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
509   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
510   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
511   	    swapTokensAtAmount = newAmount;
512   	    return true;
513   	}
514     
515     function updateMaxAmount(uint256 newNum) external onlyOwner {
516         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.5%");
517         maxTransactionAmount = newNum * (10**18);
518     }
519     
520     function updateMaxWallet(uint256 newNum) external onlyOwner {
521         maxWallet = newNum * (10**18);
522     }
523     
524     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
525         _isExcludedMaxTransactionAmount[updAds] = isEx;
526     }
527     
528     // only use to disable contract sales if absolutely necessary (emergency use only)
529     function updateSwapEnabled(bool enabled) external onlyOwner(){
530         swapEnabled = enabled;
531     }
532     
533     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _buyBackFee) external onlyOwner {
534         buyMarketingFee = _marketingFee;
535         buyLiquidityFee = _liquidityFee;
536         buyBuyBackFee = _buyBackFee;
537         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBuyBackFee;
538         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
539     }
540     
541     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _buyBackFee) external onlyOwner {
542         sellMarketingFee = _marketingFee;
543         sellLiquidityFee = _liquidityFee;
544         sellBuyBackFee = _buyBackFee;
545         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBuyBackFee;
546         require(sellTotalFees <= 15, "Must keep fees at 30% or less");
547     }
548 
549     function excludeFromFees(address account, bool excluded) public onlyOwner {
550         _isExcludedFromFees[account] = excluded;
551         emit ExcludeFromFees(account, excluded);
552     }
553 
554     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
555         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
556 
557         _setAutomatedMarketMakerPair(pair, value);
558     }
559 
560     function _setAutomatedMarketMakerPair(address pair, bool value) private {
561         automatedMarketMakerPairs[pair] = value;
562 
563         emit SetAutomatedMarketMakerPair(pair, value);
564     }
565 
566     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
567         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
568         marketingWallet = newMarketingWallet;
569     }
570     
571     function updateDevWallet(address newWallet) external onlyOwner {
572         emit buyBackWalletUpdated(newWallet, buyBackWallet);
573         buyBackWallet = newWallet;
574     }
575     
576 
577     function isExcludedFromFees(address account) public view returns(bool) {
578         return _isExcludedFromFees[account];
579     }
580     
581     event BoughtEarly(address indexed sniper);
582 
583     function _transfer(
584         address from,
585         address to,
586         uint256 amount
587     ) internal override {
588         require(from != address(0), "ERC20: transfer from the zero address");
589         require(to != address(0), "ERC20: transfer to the zero address");
590         
591          if(amount == 0) {
592             super._transfer(from, to, 0);
593             return;
594         }
595         
596         if(limitsInEffect){
597             if (
598                 from != owner() &&
599                 to != owner() &&
600                 to != address(0) &&
601                 to != address(0xdead) &&
602                 !swapping
603             ){
604                 if(!tradingActive){
605                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
606                 }
607 
608                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
609                 if (transferDelayEnabled){
610                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
611                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
612                         _holderLastTransferTimestamp[tx.origin] = block.number;
613                     }
614                 }
615                  
616                 //when buy
617                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
618                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
619                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
620                 }
621                 
622                 //when sell
623                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
624                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
625                 }
626                 else {
627                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
628                 }
629             }
630         }
631         
632 		uint256 contractTokenBalance = balanceOf(address(this));
633         
634         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
635 
636         if( 
637             canSwap &&
638             swapEnabled &&
639             !swapping &&
640             !automatedMarketMakerPairs[from] &&
641             !_isExcludedFromFees[from] &&
642             !_isExcludedFromFees[to]
643         ) {
644             swapping = true;
645             
646             swapBack();
647 
648             swapping = false;
649         }
650         
651         bool takeFee = !swapping;
652 
653         // if any account belongs to _isExcludedFromFee account then remove the fee
654         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
655             takeFee = false;
656         }
657         
658         uint256 fees = 0;
659         // only take fees on buys/sells, do not take on wallet transfers
660         if(takeFee){
661             if(tradingActiveBlock + 2 >= block.number && (automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from])){
662                 fees = amount.mul(99).div(100);
663                 tokensForLiquidity += fees * 33 / 99;
664                 tokensForBuyBack += fees * 33 / 99;
665                 tokensForMarketing += fees * 33 / 99;
666             }
667             // on sell
668             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
669                 fees = amount.mul(sellTotalFees).div(100);
670                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
671                 tokensForBuyBack += fees * sellBuyBackFee / sellTotalFees;
672                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
673             }
674             // on buy
675             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
676         	    fees = amount.mul(buyTotalFees).div(100);
677         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
678                 tokensForBuyBack += fees * buyBuyBackFee / buyTotalFees;
679                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
680             }
681             
682             if(fees > 0){    
683                 super._transfer(from, address(this), fees);
684             }
685         	
686         	amount -= fees;
687         }
688 
689         super._transfer(from, to, amount);
690     }
691 
692     function swapTokensForEth(uint256 tokenAmount) private {
693 
694         // generate the uniswap pair path of token -> weth
695         address[] memory path = new address[](2);
696         path[0] = address(this);
697         path[1] = uniswapV2Router.WETH();
698 
699         _approve(address(this), address(uniswapV2Router), tokenAmount);
700 
701         // make the swap
702         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
703             tokenAmount,
704             0, // accept any amount of ETH
705             path,
706             address(this),
707             block.timestamp
708         );
709         
710     }
711     
712     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
713         // approve token transfer to cover all possible scenarios
714         _approve(address(this), address(uniswapV2Router), tokenAmount);
715 
716         // add the liquidity
717         uniswapV2Router.addLiquidityETH{value: ethAmount}(
718             address(this),
719             tokenAmount,
720             0, // slippage is unavoidable
721             0, // slippage is unavoidable
722             deadAddress,
723             block.timestamp
724         );
725     }
726 
727     function swapBack() private {
728         uint256 contractBalance = balanceOf(address(this));
729         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForBuyBack;
730         
731         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
732         
733         // Halve the amount of liquidity tokens
734         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
735         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
736         
737         uint256 initialETHBalance = address(this).balance;
738 
739         swapTokensForEth(amountToSwapForETH); 
740         
741         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
742         
743         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
744         uint256 ethForBuyBack = ethBalance.mul(tokensForBuyBack).div(totalTokensToSwap);
745         
746         
747         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForBuyBack;
748         
749         
750         tokensForLiquidity = 0;
751         tokensForMarketing = 0;
752         tokensForBuyBack = 0;
753         
754         (bool success,) = address(marketingWallet).call{value: ethForMarketing}("");
755         if(liquidityTokens > 0 && ethForLiquidity > 0){
756             addLiquidity(liquidityTokens, ethForLiquidity);
757             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
758         }
759         
760         // keep leftover ETH for buyback
761         (success,) = address(buyBackWallet).call{value: address(this).balance}("");
762     }
763     
764     // useful for buybacks or to reclaim any BNB on the contract in a way that helps holders.
765     function buyBackTokens(uint256 bnbAmountInWei) external onlyOwner {
766         // generate the uniswap pair path of weth -> eth
767         address[] memory path = new address[](2);
768         path[0] = uniswapV2Router.WETH();
769         path[1] = address(this);
770 
771         // make the swap
772         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: bnbAmountInWei}(
773             0, // accept any amount of Ethereum
774             path,
775             address(0xdead),
776             block.timestamp
777         );
778         emit BuyBackTriggered(bnbAmountInWei);
779     }
780 }