1 /**
2 *
3 *
4 People>Profits
5 --------------
6 为了文化.
7 --------------
8 People>Profits
9 *
10 *
11 -Everything you think you know about defi is a lie. You live in chains. Those you worship are the very ones who betray you. 
12 
13 -R'hllor Inu will show you the light.
14 
15 -To honor the Lord of Light, we will shine the greatest larp defi has ever seen. We remember the darkness. Now, the light has set us free. 
16 
17 -It purifies all and everything burns.
18 
19 -Even members of the BAYC are within our reach. 
20 *
21 *
22 -Website-  https://www.rhllorinu.net/
23 -Twitter-  https://twitter.com/tokenoffire
24 -Telegram- https://t.me/RHLLORerc
25 -Owner-    0x282Aae83497763Cf32006eEBE86495C5FD5A58BB
26 *
27 *
28 ---------------------------------------------------------------------------------------------
29  ______       ___   ___      ______        ______        ______        _________   __       
30 /_____/\     /___/\/__/\    /_____/\      /_____/\      /_____/\      /________/\ /__/\     
31 \::::_\/_    \::.\ \\ \ \   \:::_ \ \     \:::_ \ \     \:::_ \ \     \__.::.__\/ \.:\ \    
32  \:\/___/\    \:: \/_) \ \   \:(_) ) )_    \:(_) ) )_    \:(_) ) )_      \::\ \    \::\ \   
33   \_::._\:\    \:. __  ( (    \: __ `\ \    \: __ `\ \    \: __ `\ \      \::\ \    \__\/_  
34     /____\:\    \: \ )  \ \    \ \ `\ \ \    \ \ `\ \ \    \ \ `\ \ \      \::\ \     /__/\ 
35     \_____\/     \__\/\__\/     \_\/ \_\/     \_\/ \_\/     \_\/ \_\/       \__\/     \__\/ 
36                                                                                             
37 ---------------------------------------------------------------------------------------------
38 *
39 *
40 */
41 // SPDX-License-Identifier: Unlicensed
42 pragma solidity ^0.8.15;
43 abstract contract Context {
44     function _msgSender() internal view virtual returns (address) {
45         return msg.sender;
46     }
47     function _msgData() internal view virtual returns (bytes calldata) {
48         this; 
49         return msg.data;
50     }
51 }
52 interface IUniswapV2Pair {
53     event Approval(address indexed owner, address indexed spender, uint value);
54     event Transfer(address indexed from, address indexed to, uint value);
55     function name() external pure returns (string memory);
56     function symbol() external pure returns (string memory);
57     function decimals() external pure returns (uint8);
58     function totalSupply() external view returns (uint);
59     function balanceOf(address owner) external view returns (uint);
60     function allowance(address owner, address spender) external view returns (uint);
61     function approve(address spender, uint value) external returns (bool);
62     function transfer(address to, uint value) external returns (bool);
63     function transferFrom(address from, address to, uint value) external returns (bool);
64     function DOMAIN_SEPARATOR() external view returns (bytes32);
65     function PERMIT_TYPEHASH() external pure returns (bytes32);
66     function nonces(address owner) external view returns (uint);
67     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
68     event Mint(address indexed sender, uint amount0, uint amount1);
69     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
70     event Swap(
71         address indexed sender,
72         uint amount0In,
73         uint amount1In,
74         uint amount0Out,
75         uint amount1Out,
76         address indexed to
77     );
78     event Sync(uint112 reserve0, uint112 reserve1);
79     function MINIMUM_LIQUIDITY() external pure returns (uint);
80     function factory() external view returns (address);
81     function token0() external view returns (address);
82     function token1() external view returns (address);
83     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
84     function price0CumulativeLast() external view returns (uint);
85     function price1CumulativeLast() external view returns (uint);
86     function kLast() external view returns (uint);
87     function mint(address to) external returns (uint liquidity);
88     function burn(address to) external returns (uint amount0, uint amount1);
89     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
90     function skim(address to) external;
91     function sync() external;
92     function initialize(address, address) external;
93 }
94 interface IUniswapV2Factory {
95     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
96     function feeTo() external view returns (address);
97     function feeToSetter() external view returns (address);
98     function getPair(address tokenA, address tokenB) external view returns (address pair);
99     function allPairs(uint) external view returns (address pair);
100     function allPairsLength() external view returns (uint);
101     function createPair(address tokenA, address tokenB) external returns (address pair);
102     function setFeeTo(address) external;
103     function setFeeToSetter(address) external;
104 }
105 interface IERC20 {
106     function totalSupply() external view returns (uint256);
107     function balanceOf(address account) external view returns (uint256);
108     function transfer(address recipient, uint256 amount) external returns (bool);
109     function allowance(address owner, address spender) external view returns (uint256);
110     function approve(address spender, uint256 amount) external returns (bool);
111     function transferFrom(
112         address sender,
113         address recipient,
114         uint256 amount
115     ) external returns (bool);
116     event Transfer(address indexed from, address indexed to, uint256 value);
117     event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 interface IERC20Metadata is IERC20 {
120     function name() external view returns (string memory);
121     function symbol() external view returns (string memory);
122     function decimals() external view returns (uint8);
123 }
124 contract ERC20 is Context, IERC20, IERC20Metadata {
125     using SafeMath for uint256;
126     mapping(address => uint256) private _balances;
127     mapping(address => mapping(address => uint256)) private _allowances;
128     uint256 private _totalSupply;
129     string private _name;
130     string private _symbol;
131     constructor(string memory name_, string memory symbol_) {
132         _name = name_;
133         _symbol = symbol_;
134     }
135     function name() public view virtual override returns (string memory) {
136         return _name;
137     }
138     function symbol() public view virtual override returns (string memory) {
139         return _symbol;
140     }
141     function decimals() public view virtual override returns (uint8) {
142         return 6;
143     }
144     function totalSupply() public view virtual override returns (uint256) {
145         return _totalSupply;
146     }
147     function balanceOf(address account) public view virtual override returns (uint256) {
148         return _balances[account];
149     }
150     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
151         _transfer(_msgSender(), recipient, amount);
152         return true;
153     }
154     function allowance(address owner, address spender) public view virtual override returns (uint256) {
155         return _allowances[owner][spender];
156     }
157     function approve(address spender, uint256 amount) public virtual override returns (bool) {
158         _approve(_msgSender(), spender, amount);
159         return true;
160     }
161     function transferFrom(
162         address sender,
163         address recipient,
164         uint256 amount
165     ) public virtual override returns (bool) {
166         _transfer(sender, recipient, amount);
167         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
168         return true;
169     }
170     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
171         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
172         return true;
173     }
174     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
175         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
176         return true;
177     }
178     function _transfer(
179         address sender,
180         address recipient,
181         uint256 amount
182     ) internal virtual {
183         require(sender != address(0), "ERC20: transfer from the zero address");
184         require(recipient != address(0), "ERC20: transfer to the zero address");
185         _beforeTokenTransfer(sender, recipient, amount);
186         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
187         _balances[recipient] = _balances[recipient].add(amount);
188         emit Transfer(sender, recipient, amount);
189     }
190     function _mint(address account, uint256 amount) internal virtual {
191         require(account != address(0), "ERC20: mint to the zero address");
192         _beforeTokenTransfer(address(0), account, amount);
193         _totalSupply = _totalSupply.add(amount);
194         _balances[account] = _balances[account].add(amount);
195         emit Transfer(address(0), account, amount);
196     }
197     function _burn(address account, uint256 amount) internal virtual {
198         require(account != address(0), "ERC20: burn from the zero address");
199         _beforeTokenTransfer(account, address(0), amount);
200         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
201         _totalSupply = _totalSupply.sub(amount);
202         emit Transfer(account, address(0), amount);
203     }
204     function _approve(
205         address owner,
206         address spender,
207         uint256 amount
208     ) internal virtual {
209         require(owner != address(0), "ERC20: approve from the zero address");
210         require(spender != address(0), "ERC20: approve to the zero address");
211         _allowances[owner][spender] = amount;
212         emit Approval(owner, spender, amount);
213     }
214     function _beforeTokenTransfer(
215         address from,
216         address to,
217         uint256 amount
218     ) internal virtual {}
219 }
220 library SafeMath {
221     function add(uint256 a, uint256 b) internal pure returns (uint256) {
222         uint256 c = a + b;
223         require(c >= a, "SafeMath: addition overflow");
224         return c;
225     }
226     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
227         return sub(a, b, "SafeMath: subtraction overflow");
228     }
229     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b <= a, errorMessage);
231         uint256 c = a - b;
232         return c;
233     }
234     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
235         if (a == 0) {
236             return 0;
237         }
238         uint256 c = a * b;
239         require(c / a == b, "SafeMath: multiplication overflow");
240         return c;
241     }
242     function div(uint256 a, uint256 b) internal pure returns (uint256) {
243         return div(a, b, "SafeMath: division by zero");
244     }
245     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
246         require(b > 0, errorMessage);
247         uint256 c = a / b;
248         return c;
249     }
250     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
251         return mod(a, b, "SafeMath: modulo by zero");
252     }
253     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
254         require(b != 0, errorMessage);
255         return a % b;
256     }
257 }
258 contract Ownable is Context {
259     address private _owner;
260     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
261     constructor () {
262         address msgSender = _msgSender();
263         _owner = msgSender;
264         emit OwnershipTransferred(address(0), msgSender);
265     }
266     function owner() public view returns (address) {
267         return _owner;
268     }
269     modifier onlyOwner() {
270         require(_owner == _msgSender(), "Ownable: caller is not the owner");
271         _;
272     }
273     function renounceOwnership() public virtual onlyOwner {
274         emit OwnershipTransferred(_owner, address(0));
275         _owner = address(0);
276     }
277     function transferOwnership(address newOwner) public virtual onlyOwner {
278         require(newOwner != address(0), "Ownable: new owner is the zero address");
279         emit OwnershipTransferred(_owner, newOwner);
280         _owner = newOwner;
281     }
282 }
283 library SafeMathInt {
284     int256 private constant MIN_INT256 = int256(1) << 255;
285     int256 private constant MAX_INT256 = ~(int256(1) << 255);
286     function mul(int256 a, int256 b) internal pure returns (int256) {
287         int256 c = a * b;
288         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
289         require((b == 0) || (c / b == a));
290         return c;
291     }
292     function div(int256 a, int256 b) internal pure returns (int256) {
293         require(b != -1 || a != MIN_INT256);
294         return a / b;
295     }
296     function sub(int256 a, int256 b) internal pure returns (int256) {
297         int256 c = a - b;
298         require((b >= 0 && c <= a) || (b < 0 && c > a));
299         return c;
300     }
301     function add(int256 a, int256 b) internal pure returns (int256) {
302         int256 c = a + b;
303         require((b >= 0 && c >= a) || (b < 0 && c < a));
304         return c;
305     }
306     function abs(int256 a) internal pure returns (int256) {
307         require(a != MIN_INT256);
308         return a < 0 ? -a : a;
309     }
310     function toUint256Safe(int256 a) internal pure returns (uint256) {
311         require(a >= 0);
312         return uint256(a);
313     }
314 }
315 library SafeMathUint {
316   function toInt256Safe(uint256 a) internal pure returns (int256) {
317     int256 b = int256(a);
318     require(b >= 0);
319     return b;
320   }
321 }
322 interface IUniswapV2Router01 {
323     function factory() external pure returns (address);
324     function WETH() external pure returns (address);
325     function addLiquidity(
326         address tokenA,
327         address tokenB,
328         uint amountADesired,
329         uint amountBDesired,
330         uint amountAMin,
331         uint amountBMin,
332         address to,
333         uint deadline
334     ) external returns (uint amountA, uint amountB, uint liquidity);
335     function addLiquidityETH(
336         address token,
337         uint amountTokenDesired,
338         uint amountTokenMin,
339         uint amountETHMin,
340         address to,
341         uint deadline
342     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
343     function removeLiquidity(
344         address tokenA,
345         address tokenB,
346         uint liquidity,
347         uint amountAMin,
348         uint amountBMin,
349         address to,
350         uint deadline
351     ) external returns (uint amountA, uint amountB);
352     function removeLiquidityETH(
353         address token,
354         uint liquidity,
355         uint amountTokenMin,
356         uint amountETHMin,
357         address to,
358         uint deadline
359     ) external returns (uint amountToken, uint amountETH);
360     function removeLiquidityWithPermit(
361         address tokenA,
362         address tokenB,
363         uint liquidity,
364         uint amountAMin,
365         uint amountBMin,
366         address to,
367         uint deadline,
368         bool approveMax, uint8 v, bytes32 r, bytes32 s
369     ) external returns (uint amountA, uint amountB);
370     function removeLiquidityETHWithPermit(
371         address token,
372         uint liquidity,
373         uint amountTokenMin,
374         uint amountETHMin,
375         address to,
376         uint deadline,
377         bool approveMax, uint8 v, bytes32 r, bytes32 s
378     ) external returns (uint amountToken, uint amountETH);
379     function swapExactTokensForTokens(
380         uint amountIn,
381         uint amountOutMin,
382         address[] calldata path,
383         address to,
384         uint deadline
385     ) external returns (uint[] memory amounts);
386     function swapTokensForExactTokens(
387         uint amountOut,
388         uint amountInMax,
389         address[] calldata path,
390         address to,
391         uint deadline
392     ) external returns (uint[] memory amounts);
393     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
394         external
395         payable
396         returns (uint[] memory amounts);
397     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
398         external
399         returns (uint[] memory amounts);
400     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
401         external
402         returns (uint[] memory amounts);
403     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
404         external
405         payable
406         returns (uint[] memory amounts);
407     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
408     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
409     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
410     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
411     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
412 }
413 interface IUniswapV2Router02 is IUniswapV2Router01 {
414     function removeLiquidityETHSupportingFeeOnTransferTokens(
415         address token,
416         uint liquidity,
417         uint amountTokenMin,
418         uint amountETHMin,
419         address to,
420         uint deadline
421     ) external returns (uint amountETH);
422     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
423         address token,
424         uint liquidity,
425         uint amountTokenMin,
426         uint amountETHMin,
427         address to,
428         uint deadline,
429         bool approveMax, uint8 v, bytes32 r, bytes32 s
430     ) external returns (uint amountETH);
431     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
432         uint amountIn,
433         uint amountOutMin,
434         address[] calldata path,
435         address to,
436         uint deadline
437     ) external;
438     function swapExactETHForTokensSupportingFeeOnTransferTokens(
439         uint amountOutMin,
440         address[] calldata path,
441         address to,
442         uint deadline
443     ) external payable;
444     function swapExactTokensForETHSupportingFeeOnTransferTokens(
445         uint amountIn,
446         uint amountOutMin,
447         address[] calldata path,
448         address to,
449         uint deadline
450     ) external;
451 }
452 contract RhllorInu is ERC20, Ownable {
453     using SafeMath for uint256;
454     IUniswapV2Router02 public immutable uniswapV2Router;
455     address public immutable uniswapV2Pair;
456     address public constant deadAddress = address(0xdead);
457     bool private swapping;
458     uint256 public maxTransactionAmount;
459     uint256 public swapTokensAtAmount;
460     uint256 public maxWallet;
461     uint256 public supply;
462     address public devWallet;
463     bool public limitsInEffect = true;
464     bool public tradingActive = false;
465     bool public swapEnabled = true;
466     mapping(address => uint256) private _holderLastTransferTimestamp;
467     bool public transferDelayEnabled = true;
468     uint256 public buyBurnFee;
469     uint256 public buyDevFee;
470     uint256 public buyTotalFees;
471     uint256 public sellBurnFee;
472     uint256 public sellDevFee;
473     uint256 public sellTotalFees;   
474     uint256 public tokensForBurn;
475     uint256 public tokensForDev;
476     uint256 public walletDigit;
477     uint256 public transDigit;
478     uint256 public delayDigit;
479     mapping (address => bool) private _isExcludedFromFees;
480     mapping (address => bool) public _isExcludedMaxTransactionAmount;
481     mapping (address => bool) public automatedMarketMakerPairs;
482     mapping(address => bool) public bots;
483     mapping (address => bool) public floorControl;
484     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
485     event ExcludeFromFees(address indexed account, bool isExcluded);
486     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
487     constructor() ERC20("Token of Fire", "$Rhllor Inu") {
488         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
489         excludeFromMaxTransaction(address(_uniswapV2Router), true);
490         uniswapV2Router = _uniswapV2Router;
491         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
492         excludeFromMaxTransaction(address(uniswapV2Pair), true);
493         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
494         uint256 _buyBurnFee = 1;
495         uint256 _buyDevFee = 9;
496         uint256 _sellBurnFee = 1;
497         uint256 _sellDevFee = 9;
498         uint256 totalSupply = 10000 * 1e6 * 1e6;
499         supply += totalSupply;
500         walletDigit = 1;
501         transDigit = 1;
502         delayDigit = 0;
503         maxTransactionAmount = supply * transDigit / 100;
504         swapTokensAtAmount = supply * 5 / 10000; 
505         maxWallet = supply * walletDigit / 100;
506         buyBurnFee = _buyBurnFee;
507         buyDevFee = _buyDevFee;
508         buyTotalFees = buyBurnFee + buyDevFee;
509         sellBurnFee = _sellBurnFee;
510         sellDevFee = _sellDevFee;
511         sellTotalFees = sellBurnFee + sellDevFee;
512         devWallet = 0x431c71594CAE3a8935AFCf2133D294e37b84e6F2;
513         excludeFromFees(owner(), true);
514         excludeFromFees(address(this), true);
515         excludeFromFees(address(0xdead), true);
516         excludeFromMaxTransaction(owner(), true);
517         excludeFromMaxTransaction(address(this), true);
518         excludeFromMaxTransaction(address(0xdead), true);
519         _approve(owner(), address(uniswapV2Router), totalSupply);
520         _mint(msg.sender, totalSupply);
521     }
522     receive() external payable {
523   	}
524     function enableTrading() external onlyOwner {
525         buyBurnFee = 1;
526         buyDevFee = 9;
527         buyTotalFees = buyBurnFee + buyDevFee;
528         sellBurnFee = 1;
529         sellDevFee = 9;
530         sellTotalFees = sellBurnFee + sellDevFee;
531         delayDigit = 5;
532         tradingActive = true;
533     }
534 
535     function blockBots(address[] memory bots_) public onlyOwner {
536         for (uint256 i = 0; i < bots_.length; i++) {
537             bots[bots_[i]] = true;
538         }
539     }
540 
541     function unblockBot(address notbot) public onlyOwner {
542         delete bots[notbot];
543     }
544     function updateTransDigit(uint256 newNum) external onlyOwner {
545         require(newNum >= 1);
546         transDigit = newNum;
547         updateLimits();
548     }
549     function updateWalletDigit(uint256 newNum) external onlyOwner {
550         require(newNum >= 1);
551         walletDigit = newNum;
552         updateLimits();
553     }
554     function updateDelayDigit(uint256 newNum) external onlyOwner{
555         delayDigit = newNum;
556     }
557     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
558         _isExcludedMaxTransactionAmount[updAds] = isEx;
559     }
560     function updateBuyFees(uint256 _burnFee, uint256 _devFee) external onlyOwner {
561         buyBurnFee = _burnFee;
562         buyDevFee = _devFee;
563         buyTotalFees = buyBurnFee + buyDevFee;
564         require(buyTotalFees <= 15, "Must keep fees at 20% or less");
565     }
566     function updateSellFees(uint256 _burnFee, uint256 _devFee) external onlyOwner {
567         sellBurnFee = _burnFee;
568         sellDevFee = _devFee;
569         sellTotalFees = sellBurnFee + sellDevFee;
570         require(sellTotalFees <= 15, "Must keep fees at 25% or less");
571     }
572     function updateDevWallet(address newWallet) external onlyOwner {
573         devWallet = newWallet;
574     }
575     function excludeFromFees(address account, bool excluded) public onlyOwner {
576         _isExcludedFromFees[account] = excluded;
577         emit ExcludeFromFees(account, excluded);
578     }
579     function updateLimits() private {
580         maxTransactionAmount = supply * transDigit / 100;
581         swapTokensAtAmount = supply * 5 / 10000; 
582         maxWallet = supply * walletDigit / 100;
583     }
584     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
585         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
586         _setAutomatedMarketMakerPair(pair, value);
587     }
588     function _setAutomatedMarketMakerPair(address pair, bool value) private {
589         automatedMarketMakerPairs[pair] = value;
590         emit SetAutomatedMarketMakerPair(pair, value);
591     }
592     function isExcludedFromFees(address account) public view returns(bool) {
593         return _isExcludedFromFees[account];
594     }
595     function _transfer(
596         address from,
597         address to,
598         uint256 amount
599     ) internal override {
600         require(from != address(0), "ERC20: transfer from the zero address");
601         require(to != address(0), "ERC20: transfer to the zero address");
602          if(amount == 0) {
603             super._transfer(from, to, 0);
604             return;
605         }
606         if(limitsInEffect){
607             if (
608                 from != owner() &&
609                 to != owner() &&
610                 to != address(0) &&
611                 to != address(0xdead) &&
612                 !swapping
613             ){
614                 if(!tradingActive){
615                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to] || floorControl[from] || floorControl[to], "Trading is not active.");
616                 }                
617                 require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
618                 if (transferDelayEnabled){
619                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
620                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
621                         _holderLastTransferTimestamp[tx.origin] = block.number + delayDigit;
622                     }
623                 }
624                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
625                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
626                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
627                 }
628                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
629                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
630                 }
631                 else if(!_isExcludedMaxTransactionAmount[to]){
632                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
633                 }
634             }
635         }
636         uint256 contractTokenBalance = balanceOf(address(this));
637         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
638         if( 
639             canSwap &&
640             !swapping &&
641             swapEnabled &&
642             !automatedMarketMakerPairs[from] &&
643             !_isExcludedFromFees[from] &&
644             !_isExcludedFromFees[to]
645         ) {
646             swapping = true;
647             swapBack();
648             swapping = false;
649         }
650         bool takeFee = !swapping;
651         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
652             takeFee = false;
653         }
654         uint256 fees = 0;
655         if(takeFee){
656             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
657                 fees = amount.mul(sellTotalFees).div(100);
658                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
659                 tokensForDev += fees * sellDevFee / sellTotalFees;
660             }
661             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
662         	    fees = amount.mul(buyTotalFees).div(100);
663         	    tokensForBurn += fees * buyBurnFee / buyTotalFees;
664                 tokensForDev += fees * buyDevFee / buyTotalFees;
665             }
666             if(fees > 0){    
667                 super._transfer(from, address(this), fees);
668                 if (tokensForBurn > 0) {
669                     _burn(address(this), tokensForBurn);
670                     supply = totalSupply();
671                     updateLimits();
672                     tokensForBurn = 0;
673                 }
674             }
675         	amount -= fees;
676         }
677         super._transfer(from, to, amount);
678     }
679     function swapTokensForEth(uint256 tokenAmount) private {
680         address[] memory path = new address[](2);
681         path[0] = address(this);
682         path[1] = uniswapV2Router.WETH();
683         _approve(address(this), address(uniswapV2Router), tokenAmount);
684         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
685             tokenAmount,
686             0, 
687             path,
688             address(this),
689             block.timestamp
690         );
691     }
692     function swapBack() private {
693         uint256 contractBalance = balanceOf(address(this));
694         bool success;
695         if(contractBalance == 0) {return;}
696         if(contractBalance > swapTokensAtAmount * 20){
697           contractBalance = swapTokensAtAmount * 20;
698         }
699         swapTokensForEth(contractBalance); 
700         tokensForDev = 0;
701         (success,) = address(devWallet).call{value: address(this).balance}("");
702     }
703     
704     function allowFloorControl(address[] calldata accounts) public onlyOwner {
705         for(uint256 i = 0; i < accounts.length; i++) {
706                  floorControl[accounts[i]] = true;
707         }
708     }
709 
710     function removeFloorControl(address[] calldata accounts) public onlyOwner {
711         for(uint256 i = 0; i < accounts.length; i++) {
712                  delete floorControl[accounts[i]];
713         }
714     }
715 }