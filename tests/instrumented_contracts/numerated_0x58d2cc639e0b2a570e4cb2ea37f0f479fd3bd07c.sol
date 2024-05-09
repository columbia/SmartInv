1 /*
2  Don't be a schnook, be a goodfella!
3 
4  https://www.fellascoin.vip/
5  https://twitter.com/goodfellascoin
6  https://t.me/goodfellascoin
7 
8 */
9 
10 // SPDX-License-Identifier: Unlicensed
11 
12 pragma solidity 0.8.11;
13  
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18  
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23  
24 interface IUniswapV2Pair {
25     event Approval(address indexed owner, address indexed spender, uint value);
26     event Transfer(address indexed from, address indexed to, uint value);
27  
28     function name() external pure returns (string memory);
29     function symbol() external pure returns (string memory);
30     function decimals() external pure returns (uint8);
31     function totalSupply() external view returns (uint);
32     function balanceOf(address owner) external view returns (uint);
33     function allowance(address owner, address spender) external view returns (uint);
34  
35     function approve(address spender, uint value) external returns (bool);
36     function transfer(address to, uint value) external returns (bool);
37     function transferFrom(address from, address to, uint value) external returns (bool);
38  
39     function DOMAIN_SEPARATOR() external view returns (bytes32);
40     function PERMIT_TYPEHASH() external pure returns (bytes32);
41     function nonces(address owner) external view returns (uint);
42  
43     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
44  
45     event Mint(address indexed sender, uint amount0, uint amount1);
46     event Swap(
47         address indexed sender,
48         uint amount0In,
49         uint amount1In,
50         uint amount0Out,
51         uint amount1Out,
52         address indexed to
53     );
54     event Sync(uint112 reserve0, uint112 reserve1);
55  
56     function MINIMUM_LIQUIDITY() external pure returns (uint);
57     function factory() external view returns (address);
58     function token0() external view returns (address);
59     function token1() external view returns (address);
60     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
61     function price0CumulativeLast() external view returns (uint);
62     function price1CumulativeLast() external view returns (uint);
63     function kLast() external view returns (uint);
64  
65     function mint(address to) external returns (uint liquidity);
66     function burn(address to) external returns (uint amount0, uint amount1);
67     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
68     function skim(address to) external;
69     function sync() external;
70  
71     function initialize(address, address) external;
72 }
73  
74 interface IUniswapV2Factory {
75     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
76  
77     function feeTo() external view returns (address);
78     function feeToSetter() external view returns (address);
79  
80     function getPair(address tokenA, address tokenB) external view returns (address pair);
81     function allPairs(uint) external view returns (address pair);
82     function allPairsLength() external view returns (uint);
83  
84     function createPair(address tokenA, address tokenB) external returns (address pair);
85  
86     function setFeeTo(address) external;
87     function setFeeToSetter(address) external;
88 }
89  
90 interface IERC20 {
91 
92     function totalSupply() external view returns (uint256);
93 
94     function balanceOf(address account) external view returns (uint256);
95 
96     function transfer(address recipient, uint256 amount) external returns (bool);
97 
98     function allowance(address owner, address spender) external view returns (uint256);
99 
100     function approve(address spender, uint256 amount) external returns (bool);
101 
102     function transferFrom(
103         address sender,
104         address recipient,
105         uint256 amount
106     ) external returns (bool);
107 
108     event Transfer(address indexed from, address indexed to, uint256 value);
109 
110     event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112  
113 interface IERC20Metadata is IERC20 {
114 
115     function name() external view returns (string memory);
116 
117     function symbol() external view returns (string memory);
118 
119     function decimals() external view returns (uint8);
120 }
121  
122  
123 contract ERC20 is Context, IERC20, IERC20Metadata {
124     using SafeMath for uint256;
125  
126     mapping(address => uint256) private _balances;
127  
128     mapping(address => mapping(address => uint256)) private _allowances;
129  
130     uint256 private _totalSupply;
131  
132     string private _name;
133     string private _symbol;
134 
135     constructor(string memory name_, string memory symbol_) {
136         _name = name_;
137         _symbol = symbol_;
138     }
139 
140     function name() public view virtual override returns (string memory) {
141         return _name;
142     }
143 
144     function symbol() public view virtual override returns (string memory) {
145         return _symbol;
146     }
147 
148     function decimals() public view virtual override returns (uint8) {
149         return 18;
150     }
151 
152     function totalSupply() public view virtual override returns (uint256) {
153         return _totalSupply;
154     }
155 
156     function balanceOf(address account) public view virtual override returns (uint256) {
157         return _balances[account];
158     }
159 
160     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
161         _transfer(_msgSender(), recipient, amount);
162         return true;
163     }
164 
165     function allowance(address owner, address spender) public view virtual override returns (uint256) {
166         return _allowances[owner][spender];
167     }
168 
169     function approve(address spender, uint256 amount) public virtual override returns (bool) {
170         _approve(_msgSender(), spender, amount);
171         return true;
172     }
173 
174     function transferFrom(
175         address sender,
176         address recipient,
177         uint256 amount
178     ) public virtual override returns (bool) {
179         _transfer(sender, recipient, amount);
180         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
181         return true;
182     }
183 
184     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
185         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
186         return true;
187     }
188 
189     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
190         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
191         return true;
192     }
193 
194     function _transfer(
195         address sender,
196         address recipient,
197         uint256 amount
198     ) internal virtual {
199         require(sender != address(0), "ERC20: transfer from the zero address");
200         require(recipient != address(0), "ERC20: transfer to the zero address");
201  
202         _beforeTokenTransfer(sender, recipient, amount);
203  
204         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
205         _balances[recipient] = _balances[recipient].add(amount);
206         emit Transfer(sender, recipient, amount);
207     }
208 
209     function _mint(address account, uint256 amount) internal virtual {
210         require(account != address(0), "ERC20: mint to the zero address");
211  
212         _beforeTokenTransfer(address(0), account, amount);
213  
214         _totalSupply = _totalSupply.add(amount);
215         _balances[account] = _balances[account].add(amount);
216         emit Transfer(address(0), account, amount);
217     }
218 
219     function _burn(address account, uint256 amount) internal virtual {
220         require(account != address(0), "ERC20: burn from the zero address");
221  
222         _beforeTokenTransfer(account, address(0), amount);
223  
224         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
225         _totalSupply = _totalSupply.sub(amount);
226         emit Transfer(account, address(0), amount);
227     }
228 
229     function _approve(
230         address owner,
231         address spender,
232         uint256 amount
233     ) internal virtual {
234         require(owner != address(0), "ERC20: approve from the zero address");
235         require(spender != address(0), "ERC20: approve to the zero address");
236  
237         _allowances[owner][spender] = amount;
238         emit Approval(owner, spender, amount);
239     }
240 
241     function _beforeTokenTransfer(
242         address from,
243         address to,
244         uint256 amount
245     ) internal virtual {}
246 }
247  
248 library SafeMath {
249 
250     function add(uint256 a, uint256 b) internal pure returns (uint256) {
251         uint256 c = a + b;
252         require(c >= a, "SafeMath: addition overflow");
253  
254         return c;
255     }
256 
257     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
258         return sub(a, b, "SafeMath: subtraction overflow");
259     }
260 
261     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
262         require(b <= a, errorMessage);
263         uint256 c = a - b;
264  
265         return c;
266     }
267 
268     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
269 
270         if (a == 0) {
271             return 0;
272         }
273  
274         uint256 c = a * b;
275         require(c / a == b, "SafeMath: multiplication overflow");
276  
277         return c;
278     }
279 
280     function div(uint256 a, uint256 b) internal pure returns (uint256) {
281         return div(a, b, "SafeMath: division by zero");
282     }
283 
284     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
285         require(b > 0, errorMessage);
286         uint256 c = a / b;
287         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
288  
289         return c;
290     }
291 
292     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
293         return mod(a, b, "SafeMath: modulo by zero");
294     }
295 
296     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
297         require(b != 0, errorMessage);
298         return a % b;
299     }
300 }
301  
302 contract Ownable is Context {
303     address private _owner;
304  
305     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
306 
307     constructor () {
308         address msgSender = _msgSender();
309         _owner = msgSender;
310         emit OwnershipTransferred(address(0), msgSender);
311     }
312 
313     function owner() public view returns (address) {
314         return _owner;
315     }
316 
317     modifier onlyOwner() {
318         require(_owner == _msgSender(), "Ownable: caller is not the owner");
319         _;
320     }
321 
322     function renounceOwnership() public virtual onlyOwner {
323         emit OwnershipTransferred(_owner, address(0));
324         _owner = address(0);
325     }
326 
327     function transferOwnership(address newOwner) public virtual onlyOwner {
328         require(newOwner != address(0), "Ownable: new owner is the zero address");
329         emit OwnershipTransferred(_owner, newOwner);
330         _owner = newOwner;
331     }
332 }
333  
334  
335  
336 library SafeMathInt {
337     int256 private constant MIN_INT256 = int256(1) << 255;
338     int256 private constant MAX_INT256 = ~(int256(1) << 255);
339 
340     function mul(int256 a, int256 b) internal pure returns (int256) {
341         int256 c = a * b;
342  
343         // Detect overflow when multiplying MIN_INT256 with -1
344         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
345         require((b == 0) || (c / b == a));
346         return c;
347     }
348 
349     function div(int256 a, int256 b) internal pure returns (int256) {
350         // Prevent overflow when dividing MIN_INT256 by -1
351         require(b != -1 || a != MIN_INT256);
352  
353         // Solidity already throws when dividing by 0.
354         return a / b;
355     }
356 
357     function sub(int256 a, int256 b) internal pure returns (int256) {
358         int256 c = a - b;
359         require((b >= 0 && c <= a) || (b < 0 && c > a));
360         return c;
361     }
362 
363     function add(int256 a, int256 b) internal pure returns (int256) {
364         int256 c = a + b;
365         require((b >= 0 && c >= a) || (b < 0 && c < a));
366         return c;
367     }
368 
369     function abs(int256 a) internal pure returns (int256) {
370         require(a != MIN_INT256);
371         return a < 0 ? -a : a;
372     }
373  
374  
375     function toUint256Safe(int256 a) internal pure returns (uint256) {
376         require(a >= 0);
377         return uint256(a);
378     }
379 }
380  
381 library SafeMathUint {
382   function toInt256Safe(uint256 a) internal pure returns (int256) {
383     int256 b = int256(a);
384     require(b >= 0);
385     return b;
386   }
387 }
388  
389  
390 interface IUniswapV2Router01 {
391     function factory() external pure returns (address);
392     function WETH() external pure returns (address);
393  
394     function addLiquidity(
395         address tokenA,
396         address tokenB,
397         uint amountADesired,
398         uint amountBDesired,
399         uint amountAMin,
400         uint amountBMin,
401         address to,
402         uint deadline
403     ) external returns (uint amountA, uint amountB, uint liquidity);
404     function addLiquidityETH(
405         address token,
406         uint amountTokenDesired,
407         uint amountTokenMin,
408         uint amountETHMin,
409         address to,
410         uint deadline
411     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
412     function removeLiquidity(
413         address tokenA,
414         address tokenB,
415         uint liquidity,
416         uint amountAMin,
417         uint amountBMin,
418         address to,
419         uint deadline
420     ) external returns (uint amountA, uint amountB);
421     function removeLiquidityETH(
422         address token,
423         uint liquidity,
424         uint amountTokenMin,
425         uint amountETHMin,
426         address to,
427         uint deadline
428     ) external returns (uint amountToken, uint amountETH);
429     function removeLiquidityWithPermit(
430         address tokenA,
431         address tokenB,
432         uint liquidity,
433         uint amountAMin,
434         uint amountBMin,
435         address to,
436         uint deadline,
437         bool approveMax, uint8 v, bytes32 r, bytes32 s
438     ) external returns (uint amountA, uint amountB);
439     function removeLiquidityETHWithPermit(
440         address token,
441         uint liquidity,
442         uint amountTokenMin,
443         uint amountETHMin,
444         address to,
445         uint deadline,
446         bool approveMax, uint8 v, bytes32 r, bytes32 s
447     ) external returns (uint amountToken, uint amountETH);
448     function swapExactTokensForTokens(
449         uint amountIn,
450         uint amountOutMin,
451         address[] calldata path,
452         address to,
453         uint deadline
454     ) external returns (uint[] memory amounts);
455     function swapTokensForExactTokens(
456         uint amountOut,
457         uint amountInMax,
458         address[] calldata path,
459         address to,
460         uint deadline
461     ) external returns (uint[] memory amounts);
462     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
463         external
464         payable
465         returns (uint[] memory amounts);
466     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
467         external
468         returns (uint[] memory amounts);
469     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
470         external
471         returns (uint[] memory amounts);
472     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
473         external
474         payable
475         returns (uint[] memory amounts);
476  
477     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
478     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
479     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
480     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
481     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
482 }
483  
484 interface IUniswapV2Router02 is IUniswapV2Router01 {
485     function removeLiquidityETHSupportingFeeOnTransferTokens(
486         address token,
487         uint liquidity,
488         uint amountTokenMin,
489         uint amountETHMin,
490         address to,
491         uint deadline
492     ) external returns (uint amountETH);
493     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
494         address token,
495         uint liquidity,
496         uint amountTokenMin,
497         uint amountETHMin,
498         address to,
499         uint deadline,
500         bool approveMax, uint8 v, bytes32 r, bytes32 s
501     ) external returns (uint amountETH);
502  
503     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
504         uint amountIn,
505         uint amountOutMin,
506         address[] calldata path,
507         address to,
508         uint deadline
509     ) external;
510     function swapExactETHForTokensSupportingFeeOnTransferTokens(
511         uint amountOutMin,
512         address[] calldata path,
513         address to,
514         uint deadline
515     ) external payable;
516     function swapExactTokensForETHSupportingFeeOnTransferTokens(
517         uint amountIn,
518         uint amountOutMin,
519         address[] calldata path,
520         address to,
521         uint deadline
522     ) external;
523 }
524  
525 contract fellas is ERC20, Ownable {
526     using SafeMath for uint256;
527  
528     IUniswapV2Router02 public immutable uniswapV2Router;
529     address public immutable uniswapV2Pair;
530  
531     bool private swapping;
532  
533     address private marketingWallet;
534     address private devWallet;
535  
536     uint256 public maxTransactionAmount;
537     uint256 public swapTokensAtAmount;
538     uint256 public maxWallet;
539  
540     bool public limitsInEffect = true;
541     bool public tradingActive = false;
542     bool public swapEnabled = false;
543  
544      // Anti-bot and anti-whale mappings and variables
545     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
546  
547     // Seller Map
548     mapping (address => uint256) private _holderFirstBuyTimestamp;
549  
550     // Blacklist Map
551     mapping (address => bool) private _blacklist;
552     bool public transferDelayEnabled = true;
553  
554     uint256 public buyTotalFees;
555     uint256 public buyMarketingFee;
556     uint256 public buyLiquidityFee;
557     uint256 public buyDevFee;
558  
559     uint256 public sellTotalFees;
560     uint256 public sellMarketingFee;
561     uint256 public sellLiquidityFee;
562     uint256 public sellDevFee;
563  
564     uint256 public tokensForMarketing;
565     uint256 public tokensForLiquidity;
566     uint256 public tokensForDev;
567  
568     // block number of opened trading
569     uint256 launchedAt;
570  
571     /******************/
572  
573     // exclude from fees and max transaction amount
574     mapping (address => bool) private _isExcludedFromFees;
575     mapping (address => bool) public _isExcludedMaxTransactionAmount;
576  
577     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
578     // could be subject to a maximum transfer amount
579     mapping (address => bool) public automatedMarketMakerPairs;
580  
581     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
582  
583     event ExcludeFromFees(address indexed account, bool isExcluded);
584  
585     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
586  
587     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
588  
589     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
590  
591     event SwapAndLiquify(
592         uint256 tokensSwapped,
593         uint256 ethReceived,
594         uint256 tokensIntoLiquidity
595     );
596  
597     event AutoNukeLP();
598  
599     event ManualNukeLP();
600  
601     constructor() ERC20("GoodFellas", "FELLAS") {
602  
603         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
604  
605         excludeFromMaxTransaction(address(_uniswapV2Router), true);
606         uniswapV2Router = _uniswapV2Router;
607  
608         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
609         excludeFromMaxTransaction(address(uniswapV2Pair), true);
610         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
611  
612         uint256 _buyMarketingFee = 15;
613         uint256 _buyLiquidityFee = 0;
614         uint256 _buyDevFee = 0;
615  
616         uint256 _sellMarketingFee = 20;
617         uint256 _sellLiquidityFee = 0;
618         uint256 _sellDevFee = 0;
619  
620         uint256 totalSupply = 69420000000000 * 1e18;
621  
622         maxTransactionAmount = totalSupply * 5 / 1000; // .5%
623         maxWallet = totalSupply * 10 / 1000; // 1% 
624         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05%
625  
626         buyMarketingFee = _buyMarketingFee;
627         buyLiquidityFee = _buyLiquidityFee;
628         buyDevFee = _buyDevFee;
629         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
630  
631         sellMarketingFee = _sellMarketingFee;
632         sellLiquidityFee = _sellLiquidityFee;
633         sellDevFee = _sellDevFee;
634         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
635  
636         marketingWallet = address(0x94f3B2e258b4D80e2734dB4252DD4ef769EB9F08);
637         devWallet = address(0x94f3B2e258b4D80e2734dB4252DD4ef769EB9F08);
638  
639         // exclude from paying fees or having max transaction amount
640         excludeFromFees(owner(), true);
641         excludeFromFees(address(this), true);
642         excludeFromFees(address(0xdead), true);
643         excludeFromFees(address(marketingWallet), true);
644  
645         excludeFromMaxTransaction(owner(), true);
646         excludeFromMaxTransaction(address(this), true);
647         excludeFromMaxTransaction(address(0xdead), true);
648         excludeFromMaxTransaction(address(devWallet), true);
649         excludeFromMaxTransaction(address(marketingWallet), true);
650  
651         /*
652             _mint is an internal function in ERC20.sol that is only called here,
653             and CANNOT be called ever again
654         */
655         _mint(msg.sender, totalSupply);
656     }
657  
658     receive() external payable {
659  
660     }
661  
662     // once enabled, can never be turned off
663     function enableTrading() external onlyOwner {
664         tradingActive = true;
665         swapEnabled = true;
666         launchedAt = block.number;
667     }
668  
669     // remove limits after token is stable
670     function removeLimits() external onlyOwner returns (bool){
671         limitsInEffect = false;
672         return true;
673     }
674  
675     // disable Transfer delay - cannot be reenabled
676     function disableTransferDelay() external onlyOwner returns (bool){
677         transferDelayEnabled = false;
678         return true;
679     }
680  
681      // change the minimum amount of tokens to sell from fees
682     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
683         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
684         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
685         swapTokensAtAmount = newAmount;
686         return true;
687     }
688  
689     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
690         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
691         maxTransactionAmount = newNum * (10**18);
692     }
693  
694     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
695         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
696         maxWallet = newNum * (10**18);
697     }
698  
699     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
700         _isExcludedMaxTransactionAmount[updAds] = isEx;
701     }
702 
703     function updateBuyFees(
704         uint256 _devFee,
705         uint256 _liquidityFee,
706         uint256 _marketingFee
707     ) external onlyOwner {
708         buyDevFee = _devFee;
709         buyLiquidityFee = _liquidityFee;
710         buyMarketingFee = _marketingFee;
711         buyTotalFees = buyDevFee + buyLiquidityFee + buyMarketingFee;
712     }
713 
714     function updateSellFees(
715         uint256 _devFee,
716         uint256 _liquidityFee,
717         uint256 _marketingFee
718     ) external onlyOwner {
719         sellDevFee = _devFee;
720         sellLiquidityFee = _liquidityFee;
721         sellMarketingFee = _marketingFee;
722         sellTotalFees = sellDevFee + sellLiquidityFee + sellMarketingFee;
723     }
724  
725     // only use to disable contract sales if absolutely necessary (emergency use only)
726     function updateSwapEnabled(bool enabled) external onlyOwner(){
727         swapEnabled = enabled;
728     }
729  
730     function excludeFromFees(address account, bool excluded) public onlyOwner {
731         _isExcludedFromFees[account] = excluded;
732         emit ExcludeFromFees(account, excluded);
733     }
734  
735     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
736         _blacklist[account] = isBlacklisted;
737     }
738  
739     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
740         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
741  
742         _setAutomatedMarketMakerPair(pair, value);
743     }
744  
745     function _setAutomatedMarketMakerPair(address pair, bool value) private {
746         automatedMarketMakerPairs[pair] = value;
747  
748         emit SetAutomatedMarketMakerPair(pair, value);
749     }
750  
751     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
752         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
753         marketingWallet = newMarketingWallet;
754     }
755  
756     function updateDevWallet(address newWallet) external onlyOwner {
757         emit devWalletUpdated(newWallet, devWallet);
758         devWallet = newWallet;
759     }
760  
761  
762     function isExcludedFromFees(address account) public view returns(bool) {
763         return _isExcludedFromFees[account];
764     }
765  
766     function _transfer(
767         address from,
768         address to,
769         uint256 amount
770     ) internal override {
771         require(from != address(0), "ERC20: transfer from the zero address");
772         require(to != address(0), "ERC20: transfer to the zero address");
773         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
774          if(amount == 0) {
775             super._transfer(from, to, 0);
776             return;
777         }
778  
779         if(limitsInEffect){
780             if (
781                 from != owner() &&
782                 to != owner() &&
783                 to != address(0) &&
784                 to != address(0xdead) &&
785                 !swapping
786             ){
787                 if(!tradingActive){
788                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
789                 }
790  
791                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
792                 if (transferDelayEnabled){
793                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
794                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
795                         _holderLastTransferTimestamp[tx.origin] = block.number;
796                     }
797                 }
798  
799                 //when buy
800                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
801                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
802                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
803                 }
804  
805                 //when sell
806                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
807                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
808                 }
809                 else if(!_isExcludedMaxTransactionAmount[to]){
810                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
811                 }
812             }
813         }
814  
815         uint256 contractTokenBalance = balanceOf(address(this));
816  
817         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
818  
819         if( 
820             canSwap &&
821             swapEnabled &&
822             !swapping &&
823             !automatedMarketMakerPairs[from] &&
824             !_isExcludedFromFees[from] &&
825             !_isExcludedFromFees[to]
826         ) {
827             swapping = true;
828  
829             swapBack();
830  
831             swapping = false;
832         }
833  
834         bool takeFee = !swapping;
835  
836         // if any account belongs to _isExcludedFromFee account then remove the fee
837         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
838             takeFee = false;
839         }
840  
841         uint256 fees = 0;
842         // only take fees on buys/sells, do not take on wallet transfers
843         if(takeFee){
844             // on sell
845             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
846                 fees = amount.mul(sellTotalFees).div(100);
847                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
848                 tokensForDev += fees * sellDevFee / sellTotalFees;
849                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
850             }
851             // on buy
852             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
853                 fees = amount.mul(buyTotalFees).div(100);
854                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
855                 tokensForDev += fees * buyDevFee / buyTotalFees;
856                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
857             }
858  
859             if(fees > 0){    
860                 super._transfer(from, address(this), fees);
861             }
862  
863             amount -= fees;
864         }
865  
866         super._transfer(from, to, amount);
867     }
868  
869     function swapTokensForEth(uint256 tokenAmount) private {
870  
871         // generate the uniswap pair path of token -> weth
872         address[] memory path = new address[](2);
873         path[0] = address(this);
874         path[1] = uniswapV2Router.WETH();
875  
876         _approve(address(this), address(uniswapV2Router), tokenAmount);
877  
878         // make the swap
879         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
880             tokenAmount,
881             0, // accept any amount of ETH
882             path,
883             address(this),
884             block.timestamp
885         );
886  
887     }
888  
889     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
890         // approve token transfer to cover all possible scenarios
891         _approve(address(this), address(uniswapV2Router), tokenAmount);
892  
893         // add the liquidity
894         uniswapV2Router.addLiquidityETH{value: ethAmount}(
895             address(this),
896             tokenAmount,
897             0, // slippage is unavoidable
898             0, // slippage is unavoidable
899             address(this),
900             block.timestamp
901         );
902     }
903  
904     function swapBack() private {
905         uint256 contractBalance = balanceOf(address(this));
906         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
907         bool success;
908  
909         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
910  
911         if(contractBalance > swapTokensAtAmount * 20){
912           contractBalance = swapTokensAtAmount * 20;
913         }
914  
915         // Halve the amount of liquidity tokens
916         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
917         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
918  
919         uint256 initialETHBalance = address(this).balance;
920  
921         swapTokensForEth(amountToSwapForETH); 
922  
923         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
924  
925         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
926         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
927         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
928  
929  
930         tokensForLiquidity = 0;
931         tokensForMarketing = 0;
932         tokensForDev = 0;
933  
934         (success,) = address(devWallet).call{value: ethForDev}("");
935  
936         if(liquidityTokens > 0 && ethForLiquidity > 0){
937             addLiquidity(liquidityTokens, ethForLiquidity);
938             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
939         }
940  
941         (success,) = address(marketingWallet).call{value: address(this).balance}("");
942     }
943 }