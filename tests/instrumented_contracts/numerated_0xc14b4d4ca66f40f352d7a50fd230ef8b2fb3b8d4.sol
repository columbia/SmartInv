1 // SPDX-License-Identifier: MIT
2 
3 // www.Blocktools.org
4 
5 pragma solidity ^0.8.0;
6  
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11  
12     function _msgData() internal view virtual returns (bytes calldata) {
13         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
14         return msg.data;
15     }
16 }
17  
18 interface IUniswapV2Pair {
19     event Approval(address indexed owner, address indexed spender, uint value);
20     event Transfer(address indexed from, address indexed to, uint value);
21  
22     function name() external pure returns (string memory);
23     function symbol() external pure returns (string memory);
24     function decimals() external pure returns (uint8);
25     function totalSupply() external view returns (uint);
26     function balanceOf(address owner) external view returns (uint);
27     function allowance(address owner, address spender) external view returns (uint);
28     function approve(address spender, uint value) external returns (bool);
29     function transfer(address to, uint value) external returns (bool);
30     function transferFrom(address from, address to, uint value) external returns (bool);
31     function DOMAIN_SEPARATOR() external view returns (bytes32);
32     function PERMIT_TYPEHASH() external pure returns (bytes32);
33     function nonces(address owner) external view returns (uint);
34     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
35  
36     event Mint(address indexed sender, uint amount0, uint amount1);
37     event Swap(
38         address indexed sender,
39         uint amount0In,
40         uint amount1In,
41         uint amount0Out,
42         uint amount1Out,
43         address indexed to
44     );
45     event Sync(uint112 reserve0, uint112 reserve1);
46  
47     function MINIMUM_LIQUIDITY() external pure returns (uint);
48     function factory() external view returns (address);
49     function token0() external view returns (address);
50     function token1() external view returns (address);
51     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
52     function price0CumulativeLast() external view returns (uint);
53     function price1CumulativeLast() external view returns (uint);
54     function kLast() external view returns (uint);
55     function mint(address to) external returns (uint liquidity);
56     function burn(address to) external returns (uint amount0, uint amount1);
57     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
58     function skim(address to) external;
59     function sync() external;
60     function initialize(address, address) external;
61 }
62  
63 interface IUniswapV2Factory {
64     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
65  
66     function feeTo() external view returns (address);
67     function feeToSetter() external view returns (address);
68     function getPair(address tokenA, address tokenB) external view returns (address pair);
69     function allPairs(uint) external view returns (address pair);
70     function allPairsLength() external view returns (uint);
71     function createPair(address tokenA, address tokenB) external returns (address pair);
72     function setFeeTo(address) external;
73     function setFeeToSetter(address) external;
74 }
75  
76 interface IERC20 {
77     
78     function totalSupply() external view returns (uint256); 
79     function balanceOf(address account) external view returns (uint256);
80     function transfer(address recipient, uint256 amount) external returns (bool);
81     function allowance(address owner, address spender) external view returns (uint256);
82     function approve(address spender, uint256 amount) external returns (bool);
83     function transferFrom(
84         address sender,
85         address recipient,
86         uint256 amount
87     ) external returns (bool);
88  
89     event Transfer(address indexed from, address indexed to, uint256 value);
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92  
93 interface IERC20Metadata is IERC20 {
94     
95     function name() external view returns (string memory);
96     function symbol() external view returns (string memory);
97     function decimals() external view returns (uint8);
98 }
99  
100  
101 contract ERC20 is Context, IERC20, IERC20Metadata {
102     using SafeMath for uint256;
103     mapping(address => uint256) private _balances;
104     mapping(address => mapping(address => uint256)) private _allowances;
105     uint256 private _totalSupply;
106     string private _name;
107     string private _symbol;
108  
109     constructor(string memory name_, string memory symbol_) {
110         _name = name_;
111         _symbol = symbol_;
112     }
113  
114     function name() public view virtual override returns (string memory) {
115         return _name;
116     }
117  
118     function symbol() public view virtual override returns (string memory) {
119         return _symbol;
120     }
121  
122     function decimals() public view virtual override returns (uint8) {
123         return 18;
124     }
125  
126     function totalSupply() public view virtual override returns (uint256) {
127         return _totalSupply;
128     }
129  
130     function balanceOf(address account) public view virtual override returns (uint256) {
131         return _balances[account];
132     }
133  
134     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
135         _transfer(_msgSender(), recipient, amount);
136         return true;
137     }
138  
139     function allowance(address owner, address spender) public view virtual override returns (uint256) {
140         return _allowances[owner][spender];
141     }
142  
143     function approve(address spender, uint256 amount) public virtual override returns (bool) {
144         _approve(_msgSender(), spender, amount);
145         return true;
146     }
147  
148     function transferFrom(
149         address sender,
150         address recipient,
151         uint256 amount
152     ) public virtual override returns (bool) {
153         _transfer(sender, recipient, amount);
154         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
155         return true;
156     }
157  
158     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
159         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
160         return true;
161     }
162  
163     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
164         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
165         return true;
166     }
167  
168     function _transfer(
169         address sender,
170         address recipient,
171         uint256 amount
172     ) internal virtual {
173         require(sender != address(0), "ERC20: transfer from the zero address");
174         require(recipient != address(0), "ERC20: transfer to the zero address");
175  
176         _beforeTokenTransfer(sender, recipient, amount);
177  
178         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
179         _balances[recipient] = _balances[recipient].add(amount);
180         emit Transfer(sender, recipient, amount);
181     }
182  
183     function _mint(address account, uint256 amount) internal virtual {
184         require(account != address(0), "ERC20: mint to the zero address");
185  
186         _beforeTokenTransfer(address(0), account, amount);
187  
188         _totalSupply = _totalSupply.add(amount);
189         _balances[account] = _balances[account].add(amount);
190         emit Transfer(address(0), account, amount);
191     }
192  
193     function _burn(address account, uint256 amount) internal virtual {
194         require(account != address(0), "ERC20: burn from the zero address");
195  
196         _beforeTokenTransfer(account, address(0), amount);
197  
198         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
199         _totalSupply = _totalSupply.sub(amount);
200         emit Transfer(account, address(0), amount);
201     }
202  
203     function _approve(
204         address owner,
205         address spender,
206         uint256 amount
207     ) internal virtual {
208         require(owner != address(0), "ERC20: approve from the zero address");
209         require(spender != address(0), "ERC20: approve to the zero address");
210  
211         _allowances[owner][spender] = amount;
212         emit Approval(owner, spender, amount);
213     }
214  
215     function _beforeTokenTransfer(
216         address from,
217         address to,
218         uint256 amount
219     ) internal virtual {}
220 }
221  
222 library SafeMath {
223     function add(uint256 a, uint256 b) internal pure returns (uint256) {
224         uint256 c = a + b;
225         require(c >= a, "SafeMath: addition overflow");
226  
227         return c;
228     }
229  
230     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
231         return sub(a, b, "SafeMath: subtraction overflow");
232     }
233  
234     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
235         require(b <= a, errorMessage);
236         uint256 c = a - b;
237  
238         return c;
239     }
240  
241     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
242    
243         if (a == 0) {
244             return 0;
245         }
246  
247         uint256 c = a * b;
248         require(c / a == b, "SafeMath: multiplication overflow");
249  
250         return c;
251     }
252  
253     function div(uint256 a, uint256 b) internal pure returns (uint256) {
254         return div(a, b, "SafeMath: division by zero");
255     }
256  
257     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         require(b > 0, errorMessage);
259         uint256 c = a / b;
260  
261         return c;
262     }
263  
264     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
265         return mod(a, b, "SafeMath: modulo by zero");
266     }
267  
268     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
269         require(b != 0, errorMessage);
270         return a % b;
271     }
272 }
273  
274 contract Ownable is Context {
275     address private _owner;
276     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
277  
278     constructor () {
279         address msgSender = _msgSender();
280         _owner = msgSender;
281         emit OwnershipTransferred(address(0), msgSender);
282     }
283  
284     function owner() public view returns (address) {
285         return _owner;
286     }
287 
288     modifier onlyOwner() {
289         require(_owner == _msgSender(), "Ownable: caller is not the owner");
290         _;
291     }
292  
293     function renounceOwnership() public virtual onlyOwner {
294         emit OwnershipTransferred(_owner, address(0));
295         _owner = address(0);
296     }
297  
298     function transferOwnership(address newOwner) public virtual onlyOwner {
299         require(newOwner != address(0), "Ownable: new owner is the zero address");
300         emit OwnershipTransferred(_owner, newOwner);
301         _owner = newOwner;
302     }
303 }
304  
305 library SafeMathInt {
306     int256 private constant MIN_INT256 = int256(1) << 255;
307     int256 private constant MAX_INT256 = ~(int256(1) << 255);
308 
309     function mul(int256 a, int256 b) internal pure returns (int256) {
310         int256 c = a * b;
311  
312         // Detect overflow when multiplying MIN_INT256 with -1
313         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
314         require((b == 0) || (c / b == a));
315         return c;
316     }
317  
318     function div(int256 a, int256 b) internal pure returns (int256) {
319         // Prevent overflow when dividing MIN_INT256 by -1
320         require(b != -1 || a != MIN_INT256);
321  
322         // Solidity already throws when dividing by 0.
323         return a / b;
324     }
325  
326     function sub(int256 a, int256 b) internal pure returns (int256) {
327         int256 c = a - b;
328         require((b >= 0 && c <= a) || (b < 0 && c > a));
329         return c;
330     }
331  
332     function add(int256 a, int256 b) internal pure returns (int256) {
333         int256 c = a + b;
334         require((b >= 0 && c >= a) || (b < 0 && c < a));
335         return c;
336     }
337  
338     function abs(int256 a) internal pure returns (int256) {
339         require(a != MIN_INT256);
340         return a < 0 ? -a : a;
341     }
342   
343     function toUint256Safe(int256 a) internal pure returns (uint256) {
344         require(a >= 0);
345         return uint256(a);
346     }
347 }
348  
349 library SafeMathUint {
350     function toInt256Safe(uint256 a) internal pure returns (int256) {
351         int256 b = int256(a);
352         require(b >= 0);
353         return b;
354     }
355 }
356  
357 interface IUniswapV2Router01 {
358     function factory() external pure returns (address);
359     function WETH() external pure returns (address);
360     function addLiquidity(
361         address tokenA,
362         address tokenB,
363         uint amountADesired,
364         uint amountBDesired,
365         uint amountAMin,
366         uint amountBMin,
367         address to,
368         uint deadline
369     ) external returns (uint amountA, uint amountB, uint liquidity);
370     function addLiquidityETH(
371         address token,
372         uint amountTokenDesired,
373         uint amountTokenMin,
374         uint amountETHMin,
375         address to,
376         uint deadline
377     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
378     function removeLiquidity(
379         address tokenA,
380         address tokenB,
381         uint liquidity,
382         uint amountAMin,
383         uint amountBMin,
384         address to,
385         uint deadline
386     ) external returns (uint amountA, uint amountB);
387     function removeLiquidityETH(
388         address token,
389         uint liquidity,
390         uint amountTokenMin,
391         uint amountETHMin,
392         address to,
393         uint deadline
394     ) external returns (uint amountToken, uint amountETH);
395     function removeLiquidityWithPermit(
396         address tokenA,
397         address tokenB,
398         uint liquidity,
399         uint amountAMin,
400         uint amountBMin,
401         address to,
402         uint deadline,
403         bool approveMax, uint8 v, bytes32 r, bytes32 s
404     ) external returns (uint amountA, uint amountB);
405     function removeLiquidityETHWithPermit(
406         address token,
407         uint liquidity,
408         uint amountTokenMin,
409         uint amountETHMin,
410         address to,
411         uint deadline,
412         bool approveMax, uint8 v, bytes32 r, bytes32 s
413     ) external returns (uint amountToken, uint amountETH);
414     function swapExactTokensForTokens(
415         uint amountIn,
416         uint amountOutMin,
417         address[] calldata path,
418         address to,
419         uint deadline
420     ) external returns (uint[] memory amounts);
421     function swapTokensForExactTokens(
422         uint amountOut,
423         uint amountInMax,
424         address[] calldata path,
425         address to,
426         uint deadline
427     ) external returns (uint[] memory amounts);
428     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
429         external
430         payable
431         returns (uint[] memory amounts);
432     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
433         external
434         returns (uint[] memory amounts);
435     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
436         external
437         returns (uint[] memory amounts);
438     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
439         external
440         payable
441         returns (uint[] memory amounts);
442  
443     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
444     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
445     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
446     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
447     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
448     }
449  
450 interface IUniswapV2Router02 is IUniswapV2Router01 {
451     function removeLiquidityETHSupportingFeeOnTransferTokens(
452         address token,
453         uint liquidity,
454         uint amountTokenMin,
455         uint amountETHMin,
456         address to,
457         uint deadline
458     ) external returns (uint amountETH);
459     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
460         address token,
461         uint liquidity,
462         uint amountTokenMin,
463         uint amountETHMin,
464         address to,
465         uint deadline,
466         bool approveMax, uint8 v, bytes32 r, bytes32 s
467     ) external returns (uint amountETH);
468     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
469         uint amountIn,
470         uint amountOutMin,
471         address[] calldata path,
472         address to,
473         uint deadline
474     ) external;
475     function swapExactETHForTokensSupportingFeeOnTransferTokens(
476         uint amountOutMin,
477         address[] calldata path,
478         address to,
479         uint deadline
480     ) external payable;
481     function swapExactTokensForETHSupportingFeeOnTransferTokens(
482         uint amountIn,
483         uint amountOutMin,
484         address[] calldata path,
485         address to,
486         uint deadline
487     ) external;
488     }
489  
490 contract BLOCKTOOLS is Context, IERC20, IERC20Metadata, ERC20, Ownable {
491     
492     using SafeMath for uint256; 
493     IUniswapV2Router02 public immutable uniswapV2Router;
494     address public immutable uniswapV2Pair;
495     address public rescueAddress;
496     address private liquifyProtocol;
497  
498     bool private swapping;
499     bool private tradeInLimits = true;
500     bool private isTrading = false;
501     bool public swapAllowed = false;
502     bool public taxShortTermTraders = false;
503  
504     mapping (address => uint256) private _traderFirstSwapTimestamp;
505     mapping (address => bool) private _isExcludedFromFees;
506     mapping (address => bool) public _isExcludedMaxTradeAmount;
507     mapping (address => bool) public automatedMarketMakerPairs;
508  
509     uint256 private buyFeeTotal;
510     uint256 private buyProtocolFee;
511     uint256 private buyLiquidityFee;
512     uint256 private sellFeeTotal;
513     uint256 private sellProtocolFee;
514     uint256 private sellLiquidityFee;
515     uint256 private quickSellLiquidityFee;
516     uint256 private quickSellProtocolFee;
517     uint256 private tokensForProtocol;
518     uint256 private tokensForLiquidity;
519     uint256 private maxTradeAmount;
520     uint256 private whenToSwapToken;
521     uint256 private maxHolding;
522     uint256 launchedAt;
523  
524     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress); 
525     event ExcludeFromFees(address indexed account, bool isExcluded);
526     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
527     event SwapAndLiquify(
528         uint256 tokensSwapped,
529         uint256 ethReceived,
530         uint256 tokensIntoLiquidity
531     );
532  
533     constructor(
534     string memory name,
535     string memory symbol,
536     address _rescueAddress,
537     address _liquifyProtocolAddress,
538     uint256 totalSupply,
539     uint256 _buyProtocolFee,
540     uint256 _sellProtocolFee,
541     uint256 _quickSellProtocolFee,
542     uint256 _buyLiquidityFee,
543     uint256 _sellLiquidityFee,
544     uint256 _quickSellLiquidityFee
545     ) ERC20(name, symbol) {
546 
547     IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
548     excludeFromMaxTrade(address(_uniswapV2Router), true);
549     uniswapV2Router = _uniswapV2Router;
550   
551     uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
552     excludeFromMaxTrade(address(uniswapV2Pair), true);
553     _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
554 
555     rescueAddress = _rescueAddress;
556     liquifyProtocol = _liquifyProtocolAddress;
557 
558     buyProtocolFee = _buyProtocolFee;
559     buyLiquidityFee = _buyLiquidityFee;
560     buyFeeTotal = buyProtocolFee + buyLiquidityFee;
561     sellProtocolFee = _sellProtocolFee;
562     sellLiquidityFee = _sellLiquidityFee;
563     sellFeeTotal = sellProtocolFee + sellLiquidityFee;
564     quickSellLiquidityFee = _quickSellLiquidityFee;
565     quickSellProtocolFee = _quickSellProtocolFee;
566 
567     excludeFromFees(owner(), true);
568     excludeFromFees(address(this), true);
569     excludeFromMaxTrade(owner(), true);
570     excludeFromMaxTrade(address(this), true);
571 
572     maxTradeAmount = totalSupply * 20 / 1000;
573     maxHolding = totalSupply * 20 / 1000;
574     whenToSwapToken = totalSupply * 10 / 10000;
575 
576     _mint(msg.sender, totalSupply);
577     }
578  
579     receive() external payable {}
580  
581     function startTrading() external onlyOwner {
582         isTrading = true;
583         swapAllowed = true;
584         launchedAt = block.number;
585     }
586  
587     function removeLimits() external onlyOwner returns (bool){
588         tradeInLimits = false;
589         return true;
590     }
591  
592     function updateSwapAllowed(bool enabled) external onlyOwner(){
593         swapAllowed = enabled;
594     }
595 
596     function setQuickSell(bool onoff) external onlyOwner  {
597         taxShortTermTraders = onoff;
598     }
599  
600     function excludeFromMaxTrade(address updAds, bool isEx) public onlyOwner {
601         _isExcludedMaxTradeAmount[updAds] = isEx;
602     }
603  
604     function updateQuickBuyFees(uint256 _ProtocolFee, uint256 _liquidityFee) external onlyOwner {
605         buyProtocolFee = _ProtocolFee;
606         buyLiquidityFee = _liquidityFee;
607         buyFeeTotal = buyProtocolFee + buyLiquidityFee;
608         require(buyFeeTotal <= 30, "Cannot exceed 30% Buy fees");
609     }
610  
611     function updateExitFee(uint256 _protocolFee, uint256 _liquidityFee, uint256 _quickSellLiquidityFee, uint256 _quickSellProtocolFee) external onlyOwner {
612         sellProtocolFee = _protocolFee;
613         sellLiquidityFee = _liquidityFee;
614         quickSellLiquidityFee = _quickSellLiquidityFee;
615         quickSellProtocolFee = _quickSellProtocolFee;
616         sellFeeTotal = sellProtocolFee + sellLiquidityFee;
617         require(sellFeeTotal <= 30, "Cannot exceed 30% Sell fees");
618     }
619  
620     function excludeFromFees(address account, bool excluded) public onlyOwner {
621         _isExcludedFromFees[account] = excluded;
622         emit ExcludeFromFees(account, excluded);
623     }
624  
625     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
626         require(pair != uniswapV2Pair, "The pair cannot be removed from AMM Pairs"); 
627         _setAutomatedMarketMakerPair(pair, value);
628     }
629  
630     function _setAutomatedMarketMakerPair(address pair, bool value) private {
631         automatedMarketMakerPairs[pair] = value;
632         emit SetAutomatedMarketMakerPair(pair, value);
633     }
634 
635     function isExcludedFromFees(address account) public view returns(bool) {
636         return _isExcludedFromFees[account];
637     }
638 
639     function rescueTokens(IERC20 token, uint256 amount) public {
640         require(address(token) != address(0), "Token address cannot be zero");
641         require(msg.sender == rescueAddress, "Only the rescue address can call this function");
642         token.transfer(msg.sender, amount);
643     }
644  
645     function _transfer(
646         address from,
647         address to,
648         uint256 amount
649     ) internal override {
650         require(from != address(0), "ERC20: transfer from the zero address");
651         require(to != address(0), "ERC20: transfer to the zero address");
652 
653          if(amount == 0) {
654             super._transfer(from, to, 0);
655             return;
656         }
657  
658         if(tradeInLimits){
659             if (
660                 from != owner() &&
661                 to != owner() &&
662                 to != address(0) &&
663                 !swapping
664             ){
665                 if(!isTrading){
666                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
667                 }
668  
669                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTradeAmount[to]) {
670                         require(amount <= maxTradeAmount, "Transfer amount exceeds the maxTradeAmount.");
671                         require(amount + balanceOf(to) <= maxHolding, "Max Holding exceeded");
672                 }
673  
674                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTradeAmount[from]) {
675                         require(amount <= maxTradeAmount, "Transfer amount exceeds the maxTradeAmount.");
676                 }
677                 else if(!_isExcludedMaxTradeAmount[to]){
678                     require(amount + balanceOf(to) <= maxHolding, "Max Holding exceeded");
679                 }
680             }
681         }
682  
683         bool isBuy = from == uniswapV2Pair;
684         if (!isBuy && taxShortTermTraders) {
685             if (_traderFirstSwapTimestamp[from] != 0 &&
686                 (_traderFirstSwapTimestamp[from] + (730 hours) >= block.timestamp))  {
687                 sellLiquidityFee = quickSellLiquidityFee;
688                 sellProtocolFee = quickSellProtocolFee;
689                 sellFeeTotal = sellProtocolFee + sellLiquidityFee;
690             } else {
691                 sellLiquidityFee = 0;
692                 sellProtocolFee = 0;
693                 sellFeeTotal = sellProtocolFee + sellLiquidityFee;
694             }
695         } else {
696             if (_traderFirstSwapTimestamp[to] == 0) {
697                 _traderFirstSwapTimestamp[to] = block.timestamp;
698             }
699  
700             if (!taxShortTermTraders) {
701                 sellLiquidityFee = 0;
702                 sellProtocolFee = 0;
703                 sellFeeTotal = sellProtocolFee + sellLiquidityFee;
704             }
705         }
706  
707         uint256 contractTokenBalance = balanceOf(address(this));
708  
709         bool canSwap = contractTokenBalance >= whenToSwapToken;
710  
711         if( 
712             canSwap &&
713             swapAllowed &&
714             !swapping &&
715             !automatedMarketMakerPairs[from] &&
716             !_isExcludedFromFees[from] &&
717             !_isExcludedFromFees[to]
718         ) {
719             swapping = true;
720  
721             swapBack();
722  
723             swapping = false;
724         }
725  
726         bool takeFee = !swapping;
727  
728         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
729             takeFee = false;
730         }
731  
732         uint256 fees = 0;
733 
734         if(takeFee){
735             
736             if (automatedMarketMakerPairs[to] && sellFeeTotal > 0){
737                 fees = amount.mul(sellFeeTotal).div(100);
738                 tokensForLiquidity += fees * sellLiquidityFee / sellFeeTotal;
739                 tokensForProtocol += fees * sellProtocolFee / sellFeeTotal;
740             }
741 
742             else if(automatedMarketMakerPairs[from] && buyFeeTotal > 0) {
743                 fees = amount.mul(buyFeeTotal).div(100);
744                 tokensForLiquidity += fees * buyLiquidityFee / buyFeeTotal;
745                 tokensForProtocol += fees * buyProtocolFee / buyFeeTotal;
746             }
747  
748             if(fees > 0){    
749                 super._transfer(from, address(this), fees);
750             }
751  
752             amount -= fees;
753         }
754  
755         super._transfer(from, to, amount);
756     }
757  
758     function swapTokensForEth(uint256 tokenAmount) private { 
759         address[] memory path = new address[](2);
760         path[0] = address(this);
761         path[1] = uniswapV2Router.WETH();
762  
763         _approve(address(this), address(uniswapV2Router), tokenAmount);
764  
765         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
766             tokenAmount,
767             0, 
768             path,
769             address(this),
770             block.timestamp
771         );
772  
773     }
774  
775     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
776         _approve(address(this), address(uniswapV2Router), tokenAmount);
777  
778         uniswapV2Router.addLiquidityETH{value: ethAmount}(
779             address(this),
780             tokenAmount,
781             0, 
782             0, 
783             address(this),
784             block.timestamp
785         );
786     }
787  
788     function swapBack() private {
789         uint256 contractBalance = balanceOf(address(this));
790         uint256 totalTokensToSwap = tokensForLiquidity + tokensForProtocol;
791         bool success;
792  
793         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
794  
795         if(contractBalance > whenToSwapToken * 20){
796           contractBalance = whenToSwapToken * 20;
797         }
798  
799         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
800         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
801         uint256 initialETHBalance = address(this).balance;
802  
803         swapTokensForEth(amountToSwapForETH); 
804  
805         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
806         uint256 ethForProtocol = ethBalance.mul(tokensForProtocol).div(totalTokensToSwap);
807         uint256 ethForLiquidity = ethBalance - ethForProtocol;
808  
809  
810         tokensForLiquidity = 0;
811         tokensForProtocol = 0;
812  
813         (success,) = address(liquifyProtocol).call{value: ethForProtocol}("");
814  
815         if(liquidityTokens > 0 && ethForLiquidity > 0){
816             addLiquidity(liquidityTokens, ethForLiquidity);
817             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
818         }
819  
820         (success,) = address(liquifyProtocol).call{value: address(this).balance}("");
821     }
822 }