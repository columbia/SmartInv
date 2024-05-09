1 /**
2 SKOOMA HEADS
3 
4 On a mission to relieve Web3 with $SKOOMA and memes.
5 
6 📲Telegram : https://t.me/skoomaheads
7 🐧Twitter : https://twitter.com/SkoomaHeads
8 💻Website: http://www.skoomaheads.vip/
9 
10 */
11 
12 // SPDX-License-Identifier: MIT  
13 
14 pragma solidity 0.8.9;
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20     function _msgData() internal view virtual returns (bytes calldata) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 library SafeMath {
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30         return c;
31     }
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b <= a, errorMessage);
37         uint256 c = a - b;
38         return c;
39     }
40     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41         if (a == 0) {
42             return 0;
43         }
44         uint256 c = a * b;
45         require(c / a == b, "SafeMath: multiplication overflow");
46         return c;
47     }
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         return div(a, b, "SafeMath: division by zero");
50     }
51     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b > 0, errorMessage);
53         uint256 c = a / b;
54         return c;
55     }
56     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
57         return mod(a, b, "SafeMath: modulo by zero");
58     }
59     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b != 0, errorMessage);
61         return a % b;
62     }
63 }
64 
65 interface IUniswapV2Pair {
66     event Approval(address indexed owner, address indexed spender, uint value);
67     event Transfer(address indexed from, address indexed to, uint value);
68     function name() external pure returns (string memory);
69     function symbol() external pure returns (string memory);
70     function decimals() external pure returns (uint8);
71     function totalSupply() external view returns (uint);
72     function balanceOf(address owner) external view returns (uint);
73     function allowance(address owner, address spender) external view returns (uint);
74     function approve(address spender, uint value) external returns (bool);
75     function transfer(address to, uint value) external returns (bool);
76     function transferFrom(address from, address to, uint value) external returns (bool);
77     function DOMAIN_SEPARATOR() external view returns (bytes32);
78     function PERMIT_TYPEHASH() external pure returns (bytes32);
79     function nonces(address owner) external view returns (uint);
80     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
81     event Mint(address indexed sender, uint amount0, uint amount1);
82     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
83     event Swap(
84         address indexed sender,
85         uint amount0In,
86         uint amount1In,
87         uint amount0Out,
88         uint amount1Out,
89         address indexed to
90     );
91     event Sync(uint112 reserve0, uint112 reserve1);
92     function MINIMUM_LIQUIDITY() external pure returns (uint);
93     function factory() external view returns (address);
94     function token0() external view returns (address);
95     function token1() external view returns (address);
96     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
97     function price0CumulativeLast() external view returns (uint);
98     function price1CumulativeLast() external view returns (uint);
99     function kLast() external view returns (uint);
100     function mint(address to) external returns (uint liquidity);
101     function burn(address to) external returns (uint amount0, uint amount1);
102     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
103     function skim(address to) external;
104     function sync() external;
105     function initialize(address, address) external;
106 }
107  
108 interface IUniswapV2Factory {
109     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
110     function feeTo() external view returns (address);
111     function feeToSetter() external view returns (address);
112     function getPair(address tokenA, address tokenB) external view returns (address pair);
113     function allPairs(uint) external view returns (address pair);
114     function allPairsLength() external view returns (uint);
115     function createPair(address tokenA, address tokenB) external returns (address pair);
116     function setFeeTo(address) external;
117     function setFeeToSetter(address) external;
118 }
119  
120 interface IERC20 {
121     function totalSupply() external view returns (uint256);
122     function balanceOf(address account) external view returns (uint256);
123     function transfer(address recipient, uint256 amount) external returns (bool);
124     function allowance(address owner, address spender) external view returns (uint256);
125     function approve(address spender, uint256 amount) external returns (bool);
126     function transferFrom(
127         address sender,
128         address recipient,
129         uint256 amount
130     ) external returns (bool);
131     event Transfer(address indexed from, address indexed to, uint256 value);
132     event Approval(address indexed owner, address indexed spender, uint256 value);
133 }
134  
135 interface IERC20Metadata is IERC20 {
136     function name() external view returns (string memory);
137     function symbol() external view returns (string memory);
138     function decimals() external view returns (uint8);
139 }
140 
141 contract ERC20 is Context, IERC20, IERC20Metadata {
142     using SafeMath for uint256;
143     mapping(address => uint256) private _balances;
144     mapping(address => mapping(address => uint256)) private _allowances;
145     uint256 private _totalSupply;
146     string private _name;
147     string private _symbol;
148     constructor(string memory name_, string memory symbol_) {
149         _name = name_;
150         _symbol = symbol_;
151     }
152     function name() public view virtual override returns (string memory) {
153         return _name;
154     }
155     function symbol() public view virtual override returns (string memory) {
156         return _symbol;
157     }
158     function decimals() public view virtual override returns (uint8) {
159         return 18;
160     }
161     function totalSupply() public view virtual override returns (uint256) {
162         return _totalSupply;
163     }
164     function balanceOf(address account) public view virtual override returns (uint256) {
165         return _balances[account];
166     }
167     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
168         _transfer(_msgSender(), recipient, amount);
169         return true;
170     }
171     function allowance(address owner, address spender) public view virtual override returns (uint256) {
172         return _allowances[owner][spender];
173     }
174     function approve(address spender, uint256 amount) public virtual override returns (bool) {
175         _approve(_msgSender(), spender, amount);
176         return true;
177     }
178     function transferFrom(
179         address sender,
180         address recipient,
181         uint256 amount
182     ) public virtual override returns (bool) {
183         _transfer(sender, recipient, amount);
184         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
185         return true;
186     }
187     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
188         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
189         return true;
190     }
191     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
192         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
193         return true;
194     }
195     function _transfer(
196         address sender,
197         address recipient,
198         uint256 amount
199     ) internal virtual {
200         require(sender != address(0), "ERC20: transfer from the zero address");
201         require(recipient != address(0), "ERC20: transfer to the zero address");
202         _beforeTokenTransfer(sender, recipient, amount);
203         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
204         _balances[recipient] = _balances[recipient].add(amount);
205         emit Transfer(sender, recipient, amount);
206     }
207     function _mint(address account, uint256 amount) internal virtual {
208         require(account != address(0), "ERC20: mint to the zero address");
209         _beforeTokenTransfer(address(0), account, amount);
210         _totalSupply = _totalSupply.add(amount);
211         _balances[account] = _balances[account].add(amount);
212         emit Transfer(address(0), account, amount);
213     }
214     function _burn(address account, uint256 amount) internal virtual {
215         require(account != address(0), "ERC20: burn from the zero address");
216         _beforeTokenTransfer(account, address(0), amount);
217         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
218         _totalSupply = _totalSupply.sub(amount);
219         emit Transfer(account, address(0), amount);
220     }
221     function _approve(
222         address owner,
223         address spender,
224         uint256 amount
225     ) internal virtual {
226         require(owner != address(0), "ERC20: approve from the zero address");
227         require(spender != address(0), "ERC20: approve to the zero address");
228         _allowances[owner][spender] = amount;
229         emit Approval(owner, spender, amount);
230     }
231     function _beforeTokenTransfer(
232         address from,
233         address to,
234         uint256 amount
235     ) internal virtual {}
236 }
237  
238 contract Ownable is Context {
239     address private _owner;
240     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
241     constructor () {
242         address msgSender = _msgSender();
243         _owner = msgSender;
244         emit OwnershipTransferred(address(0), msgSender);
245     }
246     function owner() public view returns (address) {
247         return _owner;
248     }
249     modifier onlyOwner() {
250         require(_owner == _msgSender(), "Ownable: caller is not the owner");
251         _;
252     }
253     function renounceOwnership() public virtual onlyOwner {
254         emit OwnershipTransferred(_owner, address(0));
255         _owner = address(0);
256     }
257     function transferOwnership(address newOwner) public virtual onlyOwner {
258         require(newOwner != address(0), "Ownable: new owner is the zero address");
259         emit OwnershipTransferred(_owner, newOwner);
260         _owner = newOwner;
261     }
262 }
263 
264 library SafeMathInt {
265     int256 private constant MIN_INT256 = int256(1) << 255;
266     int256 private constant MAX_INT256 = ~(int256(1) << 255);
267     function mul(int256 a, int256 b) internal pure returns (int256) {
268         int256 c = a * b;
269         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
270         require((b == 0) || (c / b == a));
271         return c;
272     }
273     function div(int256 a, int256 b) internal pure returns (int256) {
274         require(b != -1 || a != MIN_INT256);
275         return a / b;
276     }
277     function sub(int256 a, int256 b) internal pure returns (int256) {
278         int256 c = a - b;
279         require((b >= 0 && c <= a) || (b < 0 && c > a));
280         return c;
281     }
282     function add(int256 a, int256 b) internal pure returns (int256) {
283         int256 c = a + b;
284         require((b >= 0 && c >= a) || (b < 0 && c < a));
285         return c;
286     }
287     function abs(int256 a) internal pure returns (int256) {
288         require(a != MIN_INT256);
289         return a < 0 ? -a : a;
290     }
291     function toUint256Safe(int256 a) internal pure returns (uint256) {
292         require(a >= 0);
293         return uint256(a);
294     }
295 }
296 
297 library SafeMathUint {
298   function toInt256Safe(uint256 a) internal pure returns (int256) {
299     int256 b = int256(a);
300     require(b >= 0);
301     return b;
302   }
303 }
304 
305 interface IUniswapV2Router01 {
306     function factory() external pure returns (address);
307     function WETH() external pure returns (address);
308     function addLiquidity(
309         address tokenA,
310         address tokenB,
311         uint amountADesired,
312         uint amountBDesired,
313         uint amountAMin,
314         uint amountBMin,
315         address to,
316         uint deadline
317     ) external returns (uint amountA, uint amountB, uint liquidity);
318     function addLiquidityETH(
319         address token,
320         uint amountTokenDesired,
321         uint amountTokenMin,
322         uint amountETHMin,
323         address to,
324         uint deadline
325     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
326     function removeLiquidity(
327         address tokenA,
328         address tokenB,
329         uint liquidity,
330         uint amountAMin,
331         uint amountBMin,
332         address to,
333         uint deadline
334     ) external returns (uint amountA, uint amountB);
335     function removeLiquidityETH(
336         address token,
337         uint liquidity,
338         uint amountTokenMin,
339         uint amountETHMin,
340         address to,
341         uint deadline
342     ) external returns (uint amountToken, uint amountETH);
343     function removeLiquidityWithPermit(
344         address tokenA,
345         address tokenB,
346         uint liquidity,
347         uint amountAMin,
348         uint amountBMin,
349         address to,
350         uint deadline,
351         bool approveMax, uint8 v, bytes32 r, bytes32 s
352     ) external returns (uint amountA, uint amountB);
353     function removeLiquidityETHWithPermit(
354         address token,
355         uint liquidity,
356         uint amountTokenMin,
357         uint amountETHMin,
358         address to,
359         uint deadline,
360         bool approveMax, uint8 v, bytes32 r, bytes32 s
361     ) external returns (uint amountToken, uint amountETH);
362     function swapExactTokensForTokens(
363         uint amountIn,
364         uint amountOutMin,
365         address[] calldata path,
366         address to,
367         uint deadline
368     ) external returns (uint[] memory amounts);
369     function swapTokensForExactTokens(
370         uint amountOut,
371         uint amountInMax,
372         address[] calldata path,
373         address to,
374         uint deadline
375     ) external returns (uint[] memory amounts);
376     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
377         external
378         payable
379         returns (uint[] memory amounts);
380     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
381         external
382         returns (uint[] memory amounts);
383     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
384         external
385         returns (uint[] memory amounts);
386     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
387         external
388         payable
389         returns (uint[] memory amounts);
390     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
391     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
392     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
393     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
394     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
395 }
396  
397 interface IUniswapV2Router02 is IUniswapV2Router01 {
398     function removeLiquidityETHSupportingFeeOnTransferTokens(
399         address token,
400         uint liquidity,
401         uint amountTokenMin,
402         uint amountETHMin,
403         address to,
404         uint deadline
405     ) external returns (uint amountETH);
406     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
407         address token,
408         uint liquidity,
409         uint amountTokenMin,
410         uint amountETHMin,
411         address to,
412         uint deadline,
413         bool approveMax, uint8 v, bytes32 r, bytes32 s
414     ) external returns (uint amountETH);
415     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
416         uint amountIn,
417         uint amountOutMin,
418         address[] calldata path,
419         address to,
420         uint deadline
421     ) external;
422     function swapExactETHForTokensSupportingFeeOnTransferTokens(
423         uint amountOutMin,
424         address[] calldata path,
425         address to,
426         uint deadline
427     ) external payable;
428     function swapExactTokensForETHSupportingFeeOnTransferTokens(
429         uint amountIn,
430         uint amountOutMin,
431         address[] calldata path,
432         address to,
433         uint deadline
434     ) external;
435 }
436  
437 contract SKOOMA is ERC20, Ownable {
438     using SafeMath for uint256;
439  
440     IUniswapV2Router02 public immutable uniswapV2Router;
441     address public immutable uniswapV2Pair; 
442     bool private swapping;
443 
444     address private feeWallet;
445  
446     uint256 public maxTransactionAmount;
447     uint256 public swapTokensAtAmount;
448     uint256 public maxWallet;
449  
450     bool public limitsInEffect = true;
451     bool public tradingActive = false;
452     bool public swapEnabled = false;
453  
454     uint256 public buyTotalFees;
455  
456     uint256 public sellTotalFees;
457  
458     uint256 public tokensForFee;
459 
460     // exclude from fees and max transaction amount
461     mapping (address => bool) private _isExcludedFromFees;
462     mapping (address => bool) public _isExcludedMaxTransactionAmount;
463  
464     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
465     // could be subject to a maximum transfer amount
466     mapping (address => bool) public automatedMarketMakerPairs;
467  
468     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
469  
470     event ExcludeFromFees(address indexed account, bool isExcluded);
471  
472     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
473  
474     event feeWalletUpdated(address indexed newWallet, address indexed oldWallet);
475  
476     constructor() ERC20("SKOOMA", "SKOOMA") {
477         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
478  
479         excludeFromMaxTransaction(address(_uniswapV2Router), true);
480         uniswapV2Router = _uniswapV2Router;
481  
482         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
483         excludeFromMaxTransaction(address(uniswapV2Pair), true);
484         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
485  
486         uint256 _buyFee = 70;
487 
488         uint256 _sellFee = 70;
489 
490         uint256 totalSupply = 69 * 1e9 * 1e18;
491  
492         maxTransactionAmount = (totalSupply * 5 / 100) + (1 * 1e18); // 1% maxTransactionAmountTxn
493         maxWallet = (totalSupply * 5 / 100) + (1 * 1e18); // 2% maxWallet
494         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
495  
496         buyTotalFees = _buyFee;
497  
498         sellTotalFees = _sellFee;
499  
500         feeWallet = address(0xe4F9EC13f59C5f89d3C73aff330E430DF4b303cC); // set as fee wallet
501  
502         // exclude from paying fees
503         excludeFromFees(owner(), true);
504         excludeFromFees(address(this), true);
505         excludeFromFees(address(0xdead), true);
506         excludeFromFees(feeWallet, true);
507         // exclude from having max transaction amount
508         excludeFromMaxTransaction(owner(), true);
509         excludeFromMaxTransaction(address(this), true);
510         excludeFromMaxTransaction(address(0xdead), true);
511         excludeFromMaxTransaction(feeWallet, true);
512  
513         /*
514             _mint is an internal function in ERC20.sol that is only called here,
515             and CANNOT be called ever again
516         */
517         _mint(msg.sender, totalSupply);
518     }
519  
520     receive() external payable {
521  
522     }
523  
524     // once enabled, can never be turned off
525     function enableTrading() external onlyOwner {
526         tradingActive = true;
527         swapEnabled = true;
528     }
529  
530     // remove limits after token is stable
531     function removeLimits() external onlyOwner returns (bool){
532         limitsInEffect = false;
533         return true;
534     }
535 
536     function resetLimitsBackIntoEffect() external onlyOwner returns(bool) {
537         limitsInEffect = true;
538         return true;
539     }
540  
541      // change the minimum amount of tokens to sell from fees
542     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
543         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
544         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
545         swapTokensAtAmount = newAmount;
546         return true;
547     }
548 
549     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
550         require(newNum >= (totalSupply() * 1 / 100)/1e18, "Cannot set maxTransactionAmount lower than 1%");
551         maxTransactionAmount = (newNum * (10**18)) + (1 * 1e18);
552     }
553 
554     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
555         require(newNum >= (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
556         maxWallet = (newNum * (10**18)) + (1 * 1e18);
557     }
558  
559     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
560         _isExcludedMaxTransactionAmount[updAds] = isEx;
561     }
562  
563     // only use to disable contract sales if absolutely necessary (emergency use only)
564     function updateSwapEnabled(bool enabled) external onlyOwner(){
565         swapEnabled = enabled;
566     }
567  
568     function updateBuyFees(uint256 _buyTotalFees) external onlyOwner {
569         buyTotalFees = _buyTotalFees;
570         require(buyTotalFees <= 70, "Must keep total buy fees at 70% or less");
571     }
572  
573     function updateSellFees(uint256 _sellFee) external onlyOwner {
574         sellTotalFees = _sellFee;
575         require(sellTotalFees <= 70, "Must keep total sell fees at 70% or less");
576     }
577  
578     function excludeFromFees(address account, bool excluded) public onlyOwner {
579         _isExcludedFromFees[account] = excluded;
580         emit ExcludeFromFees(account, excluded);
581     }
582 
583     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
584         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
585         _setAutomatedMarketMakerPair(pair, value);
586     }
587  
588     function _setAutomatedMarketMakerPair(address pair, bool value) private {
589         automatedMarketMakerPairs[pair] = value;
590         emit SetAutomatedMarketMakerPair(pair, value);
591     }
592  
593     function updateFeeWallet(address newWallet) external onlyOwner {
594         emit feeWalletUpdated(newWallet, feeWallet);
595         feeWallet = newWallet;
596     }
597 
598     function isExcludedFromFees(address account) public view returns(bool) {
599         return _isExcludedFromFees[account];
600     }
601  
602     function _transfer(
603         address from,
604         address to,
605         uint256 amount
606     ) internal override {
607         require(from != address(0), "ERC20: transfer from the zero address");
608         require(to != address(0), "ERC20: transfer to the zero address");
609          if(amount == 0) {
610             super._transfer(from, to, 0);
611             return;
612         }
613  
614         if(limitsInEffect){
615             if (
616                 from != owner() &&
617                 to != owner() &&
618                 to != address(0) &&
619                 to != address(0xdead) &&
620                 !swapping
621             ){
622                 if(!tradingActive){
623                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
624                 }
625  
626                 //when buy
627                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
628                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
629                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
630                 }
631  
632                 //when sell
633                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
634                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
635                 }
636                 else if(!_isExcludedMaxTransactionAmount[to]){
637                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
638                 }
639             }
640         }
641  
642         uint256 contractTokenBalance = balanceOf(address(this));
643  
644         bool canSwap = contractTokenBalance >= swapTokensAtAmount; // 0,05% - 1%
645  
646         if( 
647             canSwap &&
648             swapEnabled &&
649             !swapping &&
650             !automatedMarketMakerPairs[from] &&
651             !_isExcludedFromFees[from] &&
652             !_isExcludedFromFees[to]
653         ) {
654             swapping = true;
655  
656             swapBack();
657  
658             swapping = false;
659         }
660  
661         bool takeFee = !swapping;
662 
663         bool walletToWallet = !automatedMarketMakerPairs[to] && !automatedMarketMakerPairs[from];
664         // if any account belongs to _isExcludedFromFee account then remove the fee
665         if(_isExcludedFromFees[from] || _isExcludedFromFees[to] || walletToWallet) {
666             takeFee = false;
667         }
668         uint256 fees = 0;
669         // only take fees on buys/sells, do not take on wallet transfers
670         if(takeFee){
671             // on sell
672             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
673                 fees = amount.mul(sellTotalFees).div(100);
674                 tokensForFee += fees;
675             }
676             // on buy
677             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
678                 fees = amount.mul(buyTotalFees).div(100);
679                 tokensForFee += fees;
680             }
681             if(fees > 0){    
682                 super._transfer(from, address(this), fees);
683             }
684             amount -= fees;
685         }
686         super._transfer(from, to, amount);
687     }
688  
689     function swapTokensForEth(uint256 tokenAmount) private {
690         // generate the uniswap pair path of token -> weth
691         address[] memory path = new address[](2);
692         path[0] = address(this);
693         path[1] = uniswapV2Router.WETH();
694         _approve(address(this), address(uniswapV2Router), tokenAmount);
695         // make the swap
696         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
697             tokenAmount,
698             0, // accept any amount of ETH
699             path,
700             address(this),
701             block.timestamp
702         );
703     }
704  
705     function swapBack() private {
706         uint256 contractBalance = balanceOf(address(this));
707         uint256 totalTokensToSwap = tokensForFee;
708         bool success;
709  
710         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
711 
712         if(contractBalance > swapTokensAtAmount * 20){
713           contractBalance = swapTokensAtAmount * 20;
714         }
715  
716         uint256 amountToSwapForETH = contractBalance;
717         uint256 initialETHBalance = address(this).balance;
718  
719         swapTokensForEth(amountToSwapForETH); 
720  
721         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
722  
723         tokensForFee = 0;
724  
725         (success,) = address(feeWallet).call{value: ethBalance}("");
726     }
727 }