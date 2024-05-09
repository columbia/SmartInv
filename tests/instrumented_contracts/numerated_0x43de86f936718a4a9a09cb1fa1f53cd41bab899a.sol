1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity 0.8.11;
4  
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9  
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14  
15 interface IUniswapV2Pair {
16     event Approval(address indexed owner, address indexed spender, uint value);
17     event Transfer(address indexed from, address indexed to, uint value);
18  
19     function name() external pure returns (string memory);
20     function symbol() external pure returns (string memory);
21     function decimals() external pure returns (uint8);
22     function totalSupply() external view returns (uint);
23     function balanceOf(address owner) external view returns (uint);
24     function allowance(address owner, address spender) external view returns (uint);
25  
26     function approve(address spender, uint value) external returns (bool);
27     function transfer(address to, uint value) external returns (bool);
28     function transferFrom(address from, address to, uint value) external returns (bool);
29  
30     function DOMAIN_SEPARATOR() external view returns (bytes32);
31     function PERMIT_TYPEHASH() external pure returns (bytes32);
32     function nonces(address owner) external view returns (uint);
33  
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
55  
56     function mint(address to) external returns (uint liquidity);
57     function burn(address to) external returns (uint amount0, uint amount1);
58     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
59     function skim(address to) external;
60     function sync() external;
61  
62     function initialize(address, address) external;
63 }
64  
65 interface IUniswapV2Factory {
66     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
67  
68     function feeTo() external view returns (address);
69     function feeToSetter() external view returns (address);
70  
71     function getPair(address tokenA, address tokenB) external view returns (address pair);
72     function allPairs(uint) external view returns (address pair);
73     function allPairsLength() external view returns (uint);
74  
75     function createPair(address tokenA, address tokenB) external returns (address pair);
76  
77     function setFeeTo(address) external;
78     function setFeeToSetter(address) external;
79 }
80  
81 interface IERC20 {
82 
83     function totalSupply() external view returns (uint256);
84 
85     function balanceOf(address account) external view returns (uint256);
86 
87     function transfer(address recipient, uint256 amount) external returns (bool);
88 
89     function allowance(address owner, address spender) external view returns (uint256);
90 
91     function approve(address spender, uint256 amount) external returns (bool);
92 
93     function transferFrom(
94         address sender,
95         address recipient,
96         uint256 amount
97     ) external returns (bool);
98 
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103  
104 interface IERC20Metadata is IERC20 {
105 
106     function name() external view returns (string memory);
107 
108     function symbol() external view returns (string memory);
109 
110     function decimals() external view returns (uint8);
111 }
112  
113  
114 contract ERC20 is Context, IERC20, IERC20Metadata {
115     using SafeMath for uint256;
116  
117     mapping(address => uint256) private _balances;
118  
119     mapping(address => mapping(address => uint256)) private _allowances;
120  
121     uint256 private _totalSupply;
122  
123     string private _name;
124     string private _symbol;
125 
126     constructor(string memory name_, string memory symbol_) {
127         _name = name_;
128         _symbol = symbol_;
129     }
130 
131     function name() public view virtual override returns (string memory) {
132         return _name;
133     }
134 
135     function symbol() public view virtual override returns (string memory) {
136         return _symbol;
137     }
138 
139     function decimals() public view virtual override returns (uint8) {
140         return 18;
141     }
142 
143     function totalSupply() public view virtual override returns (uint256) {
144         return _totalSupply;
145     }
146 
147     function balanceOf(address account) public view virtual override returns (uint256) {
148         return _balances[account];
149     }
150 
151     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
152         _transfer(_msgSender(), recipient, amount);
153         return true;
154     }
155 
156     function allowance(address owner, address spender) public view virtual override returns (uint256) {
157         return _allowances[owner][spender];
158     }
159 
160     function approve(address spender, uint256 amount) public virtual override returns (bool) {
161         _approve(_msgSender(), spender, amount);
162         return true;
163     }
164 
165     function transferFrom(
166         address sender,
167         address recipient,
168         uint256 amount
169     ) public virtual override returns (bool) {
170         _transfer(sender, recipient, amount);
171         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
172         return true;
173     }
174 
175     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
176         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
177         return true;
178     }
179 
180     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
181         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
182         return true;
183     }
184 
185     function _transfer(
186         address sender,
187         address recipient,
188         uint256 amount
189     ) internal virtual {
190         require(sender != address(0), "ERC20: transfer from the zero address");
191         require(recipient != address(0), "ERC20: transfer to the zero address");
192  
193         _beforeTokenTransfer(sender, recipient, amount);
194  
195         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
196         _balances[recipient] = _balances[recipient].add(amount);
197         emit Transfer(sender, recipient, amount);
198     }
199 
200     function _mint(address account, uint256 amount) internal virtual {
201         require(account != address(0), "ERC20: mint to the zero address");
202  
203         _beforeTokenTransfer(address(0), account, amount);
204  
205         _totalSupply = _totalSupply.add(amount);
206         _balances[account] = _balances[account].add(amount);
207         emit Transfer(address(0), account, amount);
208     }
209 
210     function _burn(address account, uint256 amount) internal virtual {
211         require(account != address(0), "ERC20: burn from the zero address");
212  
213         _beforeTokenTransfer(account, address(0), amount);
214  
215         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
216         _totalSupply = _totalSupply.sub(amount);
217         emit Transfer(account, address(0), amount);
218     }
219 
220     function _approve(
221         address owner,
222         address spender,
223         uint256 amount
224     ) internal virtual {
225         require(owner != address(0), "ERC20: approve from the zero address");
226         require(spender != address(0), "ERC20: approve to the zero address");
227  
228         _allowances[owner][spender] = amount;
229         emit Approval(owner, spender, amount);
230     }
231 
232     function _beforeTokenTransfer(
233         address from,
234         address to,
235         uint256 amount
236     ) internal virtual {}
237 }
238  
239 library SafeMath {
240 
241     function add(uint256 a, uint256 b) internal pure returns (uint256) {
242         uint256 c = a + b;
243         require(c >= a, "SafeMath: addition overflow");
244  
245         return c;
246     }
247 
248     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
249         return sub(a, b, "SafeMath: subtraction overflow");
250     }
251 
252     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
253         require(b <= a, errorMessage);
254         uint256 c = a - b;
255  
256         return c;
257     }
258 
259     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
260 
261         if (a == 0) {
262             return 0;
263         }
264  
265         uint256 c = a * b;
266         require(c / a == b, "SafeMath: multiplication overflow");
267  
268         return c;
269     }
270 
271     function div(uint256 a, uint256 b) internal pure returns (uint256) {
272         return div(a, b, "SafeMath: division by zero");
273     }
274 
275     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
276         require(b > 0, errorMessage);
277         uint256 c = a / b;
278         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
279  
280         return c;
281     }
282 
283     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
284         return mod(a, b, "SafeMath: modulo by zero");
285     }
286 
287     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
288         require(b != 0, errorMessage);
289         return a % b;
290     }
291 }
292  
293 contract Ownable is Context {
294     address private _owner;
295  
296     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
297 
298     constructor () {
299         address msgSender = _msgSender();
300         _owner = msgSender;
301         emit OwnershipTransferred(address(0), msgSender);
302     }
303 
304     function owner() public view returns (address) {
305         return _owner;
306     }
307 
308     modifier onlyOwner() {
309         require(_owner == _msgSender(), "Ownable: caller is not the owner");
310         _;
311     }
312 
313     function renounceOwnership() public virtual onlyOwner {
314         emit OwnershipTransferred(_owner, address(0));
315         _owner = address(0);
316     }
317 
318     function transferOwnership(address newOwner) public virtual onlyOwner {
319         require(newOwner != address(0), "Ownable: new owner is the zero address");
320         emit OwnershipTransferred(_owner, newOwner);
321         _owner = newOwner;
322     }
323 }
324  
325  
326  
327 library SafeMathInt {
328     int256 private constant MIN_INT256 = int256(1) << 255;
329     int256 private constant MAX_INT256 = ~(int256(1) << 255);
330 
331     function mul(int256 a, int256 b) internal pure returns (int256) {
332         int256 c = a * b;
333  
334         // Detect overflow when multiplying MIN_INT256 with -1
335         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
336         require((b == 0) || (c / b == a));
337         return c;
338     }
339 
340     function div(int256 a, int256 b) internal pure returns (int256) {
341         // Prevent overflow when dividing MIN_INT256 by -1
342         require(b != -1 || a != MIN_INT256);
343  
344         // Solidity already throws when dividing by 0.
345         return a / b;
346     }
347 
348     function sub(int256 a, int256 b) internal pure returns (int256) {
349         int256 c = a - b;
350         require((b >= 0 && c <= a) || (b < 0 && c > a));
351         return c;
352     }
353 
354     function add(int256 a, int256 b) internal pure returns (int256) {
355         int256 c = a + b;
356         require((b >= 0 && c >= a) || (b < 0 && c < a));
357         return c;
358     }
359 
360     function abs(int256 a) internal pure returns (int256) {
361         require(a != MIN_INT256);
362         return a < 0 ? -a : a;
363     }
364  
365  
366     function toUint256Safe(int256 a) internal pure returns (uint256) {
367         require(a >= 0);
368         return uint256(a);
369     }
370 }
371  
372 library SafeMathUint {
373   function toInt256Safe(uint256 a) internal pure returns (int256) {
374     int256 b = int256(a);
375     require(b >= 0);
376     return b;
377   }
378 }
379  
380  
381 interface IUniswapV2Router01 {
382     function factory() external pure returns (address);
383     function WETH() external pure returns (address);
384  
385     function addLiquidity(
386         address tokenA,
387         address tokenB,
388         uint amountADesired,
389         uint amountBDesired,
390         uint amountAMin,
391         uint amountBMin,
392         address to,
393         uint deadline
394     ) external returns (uint amountA, uint amountB, uint liquidity);
395     function addLiquidityETH(
396         address token,
397         uint amountTokenDesired,
398         uint amountTokenMin,
399         uint amountETHMin,
400         address to,
401         uint deadline
402     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
403     function removeLiquidity(
404         address tokenA,
405         address tokenB,
406         uint liquidity,
407         uint amountAMin,
408         uint amountBMin,
409         address to,
410         uint deadline
411     ) external returns (uint amountA, uint amountB);
412     function removeLiquidityETH(
413         address token,
414         uint liquidity,
415         uint amountTokenMin,
416         uint amountETHMin,
417         address to,
418         uint deadline
419     ) external returns (uint amountToken, uint amountETH);
420     function removeLiquidityWithPermit(
421         address tokenA,
422         address tokenB,
423         uint liquidity,
424         uint amountAMin,
425         uint amountBMin,
426         address to,
427         uint deadline,
428         bool approveMax, uint8 v, bytes32 r, bytes32 s
429     ) external returns (uint amountA, uint amountB);
430     function removeLiquidityETHWithPermit(
431         address token,
432         uint liquidity,
433         uint amountTokenMin,
434         uint amountETHMin,
435         address to,
436         uint deadline,
437         bool approveMax, uint8 v, bytes32 r, bytes32 s
438     ) external returns (uint amountToken, uint amountETH);
439     function swapExactTokensForTokens(
440         uint amountIn,
441         uint amountOutMin,
442         address[] calldata path,
443         address to,
444         uint deadline
445     ) external returns (uint[] memory amounts);
446     function swapTokensForExactTokens(
447         uint amountOut,
448         uint amountInMax,
449         address[] calldata path,
450         address to,
451         uint deadline
452     ) external returns (uint[] memory amounts);
453     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
454         external
455         payable
456         returns (uint[] memory amounts);
457     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
458         external
459         returns (uint[] memory amounts);
460     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
461         external
462         returns (uint[] memory amounts);
463     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
464         external
465         payable
466         returns (uint[] memory amounts);
467  
468     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
469     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
470     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
471     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
472     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
473 }
474  
475 interface IUniswapV2Router02 is IUniswapV2Router01 {
476     function removeLiquidityETHSupportingFeeOnTransferTokens(
477         address token,
478         uint liquidity,
479         uint amountTokenMin,
480         uint amountETHMin,
481         address to,
482         uint deadline
483     ) external returns (uint amountETH);
484     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
485         address token,
486         uint liquidity,
487         uint amountTokenMin,
488         uint amountETHMin,
489         address to,
490         uint deadline,
491         bool approveMax, uint8 v, bytes32 r, bytes32 s
492     ) external returns (uint amountETH);
493  
494     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
495         uint amountIn,
496         uint amountOutMin,
497         address[] calldata path,
498         address to,
499         uint deadline
500     ) external;
501     function swapExactETHForTokensSupportingFeeOnTransferTokens(
502         uint amountOutMin,
503         address[] calldata path,
504         address to,
505         uint deadline
506     ) external payable;
507     function swapExactTokensForETHSupportingFeeOnTransferTokens(
508         uint amountIn,
509         uint amountOutMin,
510         address[] calldata path,
511         address to,
512         uint deadline
513     ) external;
514 }
515  
516 contract Carbon is ERC20, Ownable {
517     using SafeMath for uint256;
518  
519     IUniswapV2Router02 public immutable uniswapV2Router;
520     address public immutable uniswapV2Pair;
521  
522     bool private swapping;
523  
524     address private marketingWallet;
525     address private prizepoolWallet;
526  
527     uint256 public maxTransactionAmount;
528     uint256 public swapTokensAtAmount;
529     uint256 public maxWallet;
530  
531     bool public limitsInEffect = true;
532     bool public tradingActive = false;
533     bool public swapEnabled = false;
534  
535      // Anti-bot and anti-whale mappings and variables
536     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
537  
538     // Seller Map
539     mapping (address => uint256) private _holderFirstBuyTimestamp;
540  
541     // Blacklist Map
542     mapping (address => bool) private _blacklist;
543     bool public transferDelayEnabled = true;
544  
545     uint256 public buyTotalFees;
546     uint256 public buyMarketingFee;
547     uint256 public buyLiquidityFee;
548     uint256 public buyPrizepoolFee;
549  
550     uint256 public sellTotalFees;
551     uint256 public sellMarketingFee;
552     uint256 public sellLiquidityFee;
553     uint256 public sellPrizepoolFee;
554  
555     uint256 public tokensForMarketing;
556     uint256 public tokensForLiquidity;
557     uint256 public tokensForDev;
558  
559     // block number of opened trading
560     uint256 launchedAt;
561  
562     /******************/
563  
564     // exclude from fees and max transaction amount
565     mapping (address => bool) private _isExcludedFromFees;
566     mapping (address => bool) public _isExcludedMaxTransactionAmount;
567  
568     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
569     // could be subject to a maximum transfer amount
570     mapping (address => bool) public automatedMarketMakerPairs;
571  
572     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
573  
574     event ExcludeFromFees(address indexed account, bool isExcluded);
575  
576     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
577  
578     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
579  
580     event prizepoolWalletUpdated(address indexed newWallet, address indexed oldWallet);
581  
582     event SwapAndLiquify(
583         uint256 tokensSwapped,
584         uint256 ethReceived,
585         uint256 tokensIntoLiquidity
586     );
587  
588     event AutoNukeLP();
589  
590     event ManualNukeLP();
591  
592     constructor() ERC20("Carbon", "C") {
593  
594         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
595  
596         excludeFromMaxTransaction(address(_uniswapV2Router), true);
597         uniswapV2Router = _uniswapV2Router;
598  
599         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
600         excludeFromMaxTransaction(address(uniswapV2Pair), true);
601         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
602  
603         uint256 _buyMarketingFee = 4;
604         uint256 _buyLiquidityFee = 1;
605         uint256 _buyPrizepoolFee = 1;
606  
607         uint256 _sellMarketingFee = 4;
608         uint256 _sellLiquidityFee = 1;
609         uint256 _sellPrizepoolFee = 1;
610  
611         uint256 totalSupply = 612011 * 1e18;
612  
613         maxTransactionAmount = totalSupply * 20 / 1000; // 2%
614         maxWallet = totalSupply * 20 / 1000; // 2% 
615         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.1%
616  
617         buyMarketingFee = _buyMarketingFee;
618         buyLiquidityFee = _buyLiquidityFee;
619         buyPrizepoolFee = _buyPrizepoolFee;
620         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyPrizepoolFee;
621  
622         sellMarketingFee = _sellMarketingFee;
623         sellLiquidityFee = _sellLiquidityFee;
624         sellPrizepoolFee = _sellPrizepoolFee;
625         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellPrizepoolFee;
626  
627         marketingWallet = address(owner()); // set as marketing wallet
628         prizepoolWallet = address(owner()); // set as prizepool wallet
629  
630         // exclude from paying fees or having max transaction amount
631         excludeFromFees(owner(), true);
632         excludeFromFees(address(this), true);
633         excludeFromFees(address(0xdead), true);
634  
635         excludeFromMaxTransaction(owner(), true);
636         excludeFromMaxTransaction(address(this), true);
637         excludeFromMaxTransaction(address(0xdead), true);
638  
639         /*
640             _mint is an internal function in ERC20.sol that is only called here,
641             and CANNOT be called ever again
642         */
643         _mint(msg.sender, totalSupply);
644     }
645  
646     receive() external payable {
647  
648     }
649  
650     // once enabled, can never be turned off
651     function enableTrading() external onlyOwner {
652         tradingActive = true;
653         swapEnabled = true;
654         launchedAt = block.number;
655     }
656  
657     // remove limits after token is stable
658     function removeLimits() external onlyOwner returns (bool){
659         limitsInEffect = false;
660         return true;
661     }
662  
663     // disable Transfer delay - cannot be reenabled
664     function disableTransferDelay() external onlyOwner returns (bool){
665         transferDelayEnabled = false;
666         return true;
667     }
668  
669      // change the minimum amount of tokens to sell from fees
670     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
671         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
672         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
673         swapTokensAtAmount = newAmount;
674         return true;
675     }
676  
677     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
678         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
679         maxTransactionAmount = newNum * (10**18);
680     }
681  
682     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
683         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
684         maxWallet = newNum * (10**18);
685     }
686  
687     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
688         _isExcludedMaxTransactionAmount[updAds] = isEx;
689     }
690 
691           function updateBuyFees(
692         uint256 _prizepoolFee,
693         uint256 _liquidityFee,
694         uint256 _marketingFee
695     ) external onlyOwner {
696         buyPrizepoolFee = _prizepoolFee;
697         buyLiquidityFee = _liquidityFee;
698         buyMarketingFee = _marketingFee;
699         buyTotalFees = buyPrizepoolFee + buyLiquidityFee + buyMarketingFee;
700         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
701     }
702 
703     function updateSellFees(
704         uint256 _prizepoolFee,
705         uint256 _liquidityFee,
706         uint256 _marketingFee
707     ) external onlyOwner {
708         sellPrizepoolFee = _prizepoolFee;
709         sellLiquidityFee = _liquidityFee;
710         sellMarketingFee = _marketingFee;
711         sellTotalFees = sellPrizepoolFee + sellLiquidityFee + sellMarketingFee;
712         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
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
746     function updatePrizepoolWallet(address newWallet) external onlyOwner {
747         emit prizepoolWalletUpdated(newWallet, prizepoolWallet);
748         prizepoolWallet = newWallet;
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
838                 tokensForDev += fees * sellPrizepoolFee / sellTotalFees;
839                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
840             }
841             // on buy
842             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
843                 fees = amount.mul(buyTotalFees).div(100);
844                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
845                 tokensForDev += fees * buyPrizepoolFee / buyTotalFees;
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
924         (success,) = address(prizepoolWallet).call{value: ethForDev}("");
925  
926         if(liquidityTokens > 0 && ethForLiquidity > 0){
927             addLiquidity(liquidityTokens, ethForLiquidity);
928             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
929         }
930  
931         (success,) = address(marketingWallet).call{value: address(this).balance}("");
932     }
933 }