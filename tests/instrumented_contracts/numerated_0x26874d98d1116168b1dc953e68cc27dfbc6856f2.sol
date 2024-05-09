1 /*
2 https://t.me/McWassie
3 https://twitter.com/McWassie_ERC20
4 Mcwassie.net
5 */
6 
7 // SPDX-License-Identifier: Unlicensed
8 
9 pragma solidity 0.8.11;
10  
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15  
16     function _msgData() internal view virtual returns (bytes calldata) {
17         return msg.data;
18     }
19 }
20  
21 interface IUniswapV2Pair {
22     event Approval(address indexed owner, address indexed spender, uint value);
23     event Transfer(address indexed from, address indexed to, uint value);
24  
25     function name() external pure returns (string memory);
26     function symbol() external pure returns (string memory);
27     function decimals() external pure returns (uint8);
28     function totalSupply() external view returns (uint);
29     function balanceOf(address owner) external view returns (uint);
30     function allowance(address owner, address spender) external view returns (uint);
31  
32     function approve(address spender, uint value) external returns (bool);
33     function transfer(address to, uint value) external returns (bool);
34     function transferFrom(address from, address to, uint value) external returns (bool);
35  
36     function DOMAIN_SEPARATOR() external view returns (bytes32);
37     function PERMIT_TYPEHASH() external pure returns (bytes32);
38     function nonces(address owner) external view returns (uint);
39  
40     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
41  
42     event Mint(address indexed sender, uint amount0, uint amount1);
43     event Swap(
44         address indexed sender,
45         uint amount0In,
46         uint amount1In,
47         uint amount0Out,
48         uint amount1Out,
49         address indexed to
50     );
51     event Sync(uint112 reserve0, uint112 reserve1);
52  
53     function MINIMUM_LIQUIDITY() external pure returns (uint);
54     function factory() external view returns (address);
55     function token0() external view returns (address);
56     function token1() external view returns (address);
57     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
58     function price0CumulativeLast() external view returns (uint);
59     function price1CumulativeLast() external view returns (uint);
60     function kLast() external view returns (uint);
61  
62     function mint(address to) external returns (uint liquidity);
63     function burn(address to) external returns (uint amount0, uint amount1);
64     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
65     function skim(address to) external;
66     function sync() external;
67  
68     function initialize(address, address) external;
69 }
70  
71 interface IUniswapV2Factory {
72     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
73  
74     function feeTo() external view returns (address);
75     function feeToSetter() external view returns (address);
76  
77     function getPair(address tokenA, address tokenB) external view returns (address pair);
78     function allPairs(uint) external view returns (address pair);
79     function allPairsLength() external view returns (uint);
80  
81     function createPair(address tokenA, address tokenB) external returns (address pair);
82  
83     function setFeeTo(address) external;
84     function setFeeToSetter(address) external;
85 }
86  
87 interface IERC20 {
88 
89     function totalSupply() external view returns (uint256);
90 
91     function balanceOf(address account) external view returns (uint256);
92 
93     function transfer(address recipient, uint256 amount) external returns (bool);
94 
95     function allowance(address owner, address spender) external view returns (uint256);
96 
97     function approve(address spender, uint256 amount) external returns (bool);
98 
99     function transferFrom(
100         address sender,
101         address recipient,
102         uint256 amount
103     ) external returns (bool);
104 
105     event Transfer(address indexed from, address indexed to, uint256 value);
106 
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109  
110 interface IERC20Metadata is IERC20 {
111 
112     function name() external view returns (string memory);
113 
114     function symbol() external view returns (string memory);
115 
116     function decimals() external view returns (uint8);
117 }
118  
119 contract ERC20 is Context, IERC20, IERC20Metadata {
120     using SafeMath for uint256;
121  
122     mapping(address => uint256) private _balances;
123  
124     mapping(address => mapping(address => uint256)) private _allowances;
125  
126     uint256 private _totalSupply;
127  
128     string private _name;
129     string private _symbol;
130 
131     constructor(string memory name_, string memory symbol_) {
132         _name = name_;
133         _symbol = symbol_;
134     }
135 
136     function name() public view virtual override returns (string memory) {
137         return _name;
138     }
139 
140     function symbol() public view virtual override returns (string memory) {
141         return _symbol;
142     }
143 
144     function decimals() public view virtual override returns (uint8) {
145         return 18;
146     }
147 
148     function totalSupply() public view virtual override returns (uint256) {
149         return _totalSupply;
150     }
151 
152     function balanceOf(address account) public view virtual override returns (uint256) {
153         return _balances[account];
154     }
155 
156     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
157         _transfer(_msgSender(), recipient, amount);
158         return true;
159     }
160 
161     function allowance(address owner, address spender) public view virtual override returns (uint256) {
162         return _allowances[owner][spender];
163     }
164 
165     function approve(address spender, uint256 amount) public virtual override returns (bool) {
166         _approve(_msgSender(), spender, amount);
167         return true;
168     }
169 
170     function transferFrom(
171         address sender,
172         address recipient,
173         uint256 amount
174     ) public virtual override returns (bool) {
175         _transfer(sender, recipient, amount);
176         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
177         return true;
178     }
179 
180     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
181         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
182         return true;
183     }
184 
185     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
186         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
187         return true;
188     }
189 
190     function _transfer(
191         address sender,
192         address recipient,
193         uint256 amount
194     ) internal virtual {
195         require(sender != address(0), "ERC20: transfer from the zero address");
196         require(recipient != address(0), "ERC20: transfer to the zero address");
197  
198         _beforeTokenTransfer(sender, recipient, amount);
199  
200         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
201         _balances[recipient] = _balances[recipient].add(amount);
202         emit Transfer(sender, recipient, amount);
203     }
204 
205     function _mint(address account, uint256 amount) internal virtual {
206         require(account != address(0), "ERC20: mint to the zero address");
207  
208         _beforeTokenTransfer(address(0), account, amount);
209  
210         _totalSupply = _totalSupply.add(amount);
211         _balances[account] = _balances[account].add(amount);
212         emit Transfer(address(0), account, amount);
213     }
214 
215     function _burn(address account, uint256 amount) internal virtual {
216         require(account != address(0), "ERC20: burn from the zero address");
217  
218         _beforeTokenTransfer(account, address(0), amount);
219  
220         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
221         _totalSupply = _totalSupply.sub(amount);
222         emit Transfer(account, address(0), amount);
223     }
224 
225     function _approve(
226         address owner,
227         address spender,
228         uint256 amount
229     ) internal virtual {
230         require(owner != address(0), "ERC20: approve from the zero address");
231         require(spender != address(0), "ERC20: approve to the zero address");
232  
233         _allowances[owner][spender] = amount;
234         emit Approval(owner, spender, amount);
235     }
236 
237     function _beforeTokenTransfer(
238         address from,
239         address to,
240         uint256 amount
241     ) internal virtual {}
242 }
243  
244 library SafeMath {
245 
246     function add(uint256 a, uint256 b) internal pure returns (uint256) {
247         uint256 c = a + b;
248         require(c >= a, "SafeMath: addition overflow");
249  
250         return c;
251     }
252 
253     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
254         return sub(a, b, "SafeMath: subtraction overflow");
255     }
256 
257     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         require(b <= a, errorMessage);
259         uint256 c = a - b;
260  
261         return c;
262     }
263 
264     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
265 
266         if (a == 0) {
267             return 0;
268         }
269  
270         uint256 c = a * b;
271         require(c / a == b, "SafeMath: multiplication overflow");
272  
273         return c;
274     }
275 
276     function div(uint256 a, uint256 b) internal pure returns (uint256) {
277         return div(a, b, "SafeMath: division by zero");
278     }
279 
280     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
281         require(b > 0, errorMessage);
282         uint256 c = a / b;
283         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
284  
285         return c;
286     }
287 
288     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
289         return mod(a, b, "SafeMath: modulo by zero");
290     }
291 
292     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
293         require(b != 0, errorMessage);
294         return a % b;
295     }
296 }
297  
298 contract Ownable is Context {
299     address private _owner;
300  
301     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
302 
303     constructor () {
304         address msgSender = _msgSender();
305         _owner = msgSender;
306         emit OwnershipTransferred(address(0), msgSender);
307     }
308 
309     function owner() public view returns (address) {
310         return _owner;
311     }
312 
313     modifier onlyOwner() {
314         require(_owner == _msgSender(), "Ownable: caller is not the owner");
315         _;
316     }
317 
318     function renounceOwnership() public virtual onlyOwner {
319         emit OwnershipTransferred(_owner, address(0));
320         _owner = address(0);
321     }
322 
323     function transferOwnership(address newOwner) public virtual onlyOwner {
324         require(newOwner != address(0), "Ownable: new owner is the zero address");
325         emit OwnershipTransferred(_owner, newOwner);
326         _owner = newOwner;
327     }
328 }
329  
330 library SafeMathInt {
331     int256 private constant MIN_INT256 = int256(1) << 255;
332     int256 private constant MAX_INT256 = ~(int256(1) << 255);
333 
334     function mul(int256 a, int256 b) internal pure returns (int256) {
335         int256 c = a * b;
336  
337         // Detect overflow when multiplying MIN_INT256 with -1
338         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
339         require((b == 0) || (c / b == a));
340         return c;
341     }
342 
343     function div(int256 a, int256 b) internal pure returns (int256) {
344         // Prevent overflow when dividing MIN_INT256 by -1
345         require(b != -1 || a != MIN_INT256);
346  
347         // Solidity already throws when dividing by 0.
348         return a / b;
349     }
350 
351     function sub(int256 a, int256 b) internal pure returns (int256) {
352         int256 c = a - b;
353         require((b >= 0 && c <= a) || (b < 0 && c > a));
354         return c;
355     }
356 
357     function add(int256 a, int256 b) internal pure returns (int256) {
358         int256 c = a + b;
359         require((b >= 0 && c >= a) || (b < 0 && c < a));
360         return c;
361     }
362 
363     function abs(int256 a) internal pure returns (int256) {
364         require(a != MIN_INT256);
365         return a < 0 ? -a : a;
366     }
367  
368  
369     function toUint256Safe(int256 a) internal pure returns (uint256) {
370         require(a >= 0);
371         return uint256(a);
372     }
373 }
374  
375 library SafeMathUint {
376   function toInt256Safe(uint256 a) internal pure returns (int256) {
377     int256 b = int256(a);
378     require(b >= 0);
379     return b;
380   }
381 }
382  
383  
384 interface IUniswapV2Router01 {
385     function factory() external pure returns (address);
386     function WETH() external pure returns (address);
387  
388     function addLiquidity(
389         address tokenA,
390         address tokenB,
391         uint amountADesired,
392         uint amountBDesired,
393         uint amountAMin,
394         uint amountBMin,
395         address to,
396         uint deadline
397     ) external returns (uint amountA, uint amountB, uint liquidity);
398     function addLiquidityETH(
399         address token,
400         uint amountTokenDesired,
401         uint amountTokenMin,
402         uint amountETHMin,
403         address to,
404         uint deadline
405     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
406     function removeLiquidity(
407         address tokenA,
408         address tokenB,
409         uint liquidity,
410         uint amountAMin,
411         uint amountBMin,
412         address to,
413         uint deadline
414     ) external returns (uint amountA, uint amountB);
415     function removeLiquidityETH(
416         address token,
417         uint liquidity,
418         uint amountTokenMin,
419         uint amountETHMin,
420         address to,
421         uint deadline
422     ) external returns (uint amountToken, uint amountETH);
423     function removeLiquidityWithPermit(
424         address tokenA,
425         address tokenB,
426         uint liquidity,
427         uint amountAMin,
428         uint amountBMin,
429         address to,
430         uint deadline,
431         bool approveMax, uint8 v, bytes32 r, bytes32 s
432     ) external returns (uint amountA, uint amountB);
433     function removeLiquidityETHWithPermit(
434         address token,
435         uint liquidity,
436         uint amountTokenMin,
437         uint amountETHMin,
438         address to,
439         uint deadline,
440         bool approveMax, uint8 v, bytes32 r, bytes32 s
441     ) external returns (uint amountToken, uint amountETH);
442     function swapExactTokensForTokens(
443         uint amountIn,
444         uint amountOutMin,
445         address[] calldata path,
446         address to,
447         uint deadline
448     ) external returns (uint[] memory amounts);
449     function swapTokensForExactTokens(
450         uint amountOut,
451         uint amountInMax,
452         address[] calldata path,
453         address to,
454         uint deadline
455     ) external returns (uint[] memory amounts);
456     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
457         external
458         payable
459         returns (uint[] memory amounts);
460     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
461         external
462         returns (uint[] memory amounts);
463     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
464         external
465         returns (uint[] memory amounts);
466     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
467         external
468         payable
469         returns (uint[] memory amounts);
470  
471     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
472     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
473     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
474     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
475     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
476 }
477  
478 interface IUniswapV2Router02 is IUniswapV2Router01 {
479     function removeLiquidityETHSupportingFeeOnTransferTokens(
480         address token,
481         uint liquidity,
482         uint amountTokenMin,
483         uint amountETHMin,
484         address to,
485         uint deadline
486     ) external returns (uint amountETH);
487     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
488         address token,
489         uint liquidity,
490         uint amountTokenMin,
491         uint amountETHMin,
492         address to,
493         uint deadline,
494         bool approveMax, uint8 v, bytes32 r, bytes32 s
495     ) external returns (uint amountETH);
496  
497     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
498         uint amountIn,
499         uint amountOutMin,
500         address[] calldata path,
501         address to,
502         uint deadline
503     ) external;
504     function swapExactETHForTokensSupportingFeeOnTransferTokens(
505         uint amountOutMin,
506         address[] calldata path,
507         address to,
508         uint deadline
509     ) external payable;
510     function swapExactTokensForETHSupportingFeeOnTransferTokens(
511         uint amountIn,
512         uint amountOutMin,
513         address[] calldata path,
514         address to,
515         uint deadline
516     ) external;
517 }
518  
519 contract WASSIE  is ERC20, Ownable {
520     using SafeMath for uint256;
521  
522     IUniswapV2Router02 public immutable uniswapV2Router;
523     address public immutable uniswapV2Pair;
524  
525     bool private swapping;
526  
527     address private marketingWallet;
528     address private devWallet;
529  
530     uint256 public maxTransactionAmount;
531     uint256 public swapTokensAtAmount;
532     uint256 public maxWallet;
533  
534     bool public limitsInEffect = true;
535     bool public tradingActive = false;
536     bool public swapEnabled = false;
537  
538      // Anti-bot and anti-whale mappings and variables
539     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
540  
541     // Seller Map
542     mapping (address => uint256) private _holderFirstBuyTimestamp;
543  
544     // Blacklist Map
545     mapping (address => bool) private _blacklist;
546     bool public transferDelayEnabled = true;
547  
548     uint256 public buyTotalFees;
549     uint256 public buyMarketingFee;
550     uint256 public buyLiquidityFee;
551     uint256 public buyDevFee;
552  
553     uint256 public sellTotalFees;
554     uint256 public sellMarketingFee;
555     uint256 public sellLiquidityFee;
556     uint256 public sellDevFee;
557  
558     uint256 public tokensForMarketing;
559     uint256 public tokensForLiquidity;
560     uint256 public tokensForDev;
561  
562     // block number of opened trading
563     uint256 launchedAt;
564  
565     /******************/
566  
567     // exclude from fees and max transaction amount
568     mapping (address => bool) private _isExcludedFromFees;
569     mapping (address => bool) public _isExcludedMaxTransactionAmount;
570  
571     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
572     // could be subject to a maximum transfer amount
573     mapping (address => bool) public automatedMarketMakerPairs;
574  
575     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
576  
577     event ExcludeFromFees(address indexed account, bool isExcluded);
578  
579     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
580  
581     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
582  
583     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
584  
585     event SwapAndLiquify(
586         uint256 tokensSwapped,
587         uint256 ethReceived,
588         uint256 tokensIntoLiquidity
589     );
590  
591     event AutoNukeLP();
592  
593     event ManualNukeLP();
594  
595     constructor() ERC20("McWassie", "WASSIE") {
596  
597         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
598  
599         excludeFromMaxTransaction(address(_uniswapV2Router), true);
600         uniswapV2Router = _uniswapV2Router;
601  
602         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
603         excludeFromMaxTransaction(address(uniswapV2Pair), true);
604         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
605  
606         uint256 _buyMarketingFee = 90;
607         uint256 _buyLiquidityFee = 0;
608         uint256 _buyDevFee = 0;
609  
610         uint256 _sellMarketingFee = 90;
611         uint256 _sellLiquidityFee = 0;
612         uint256 _sellDevFee = 0;
613  
614         uint256 totalSupply = 1000000000 * 1e18;
615  
616         maxTransactionAmount = totalSupply * 1 / 1000; 
617         maxWallet = totalSupply * 1 / 1000; // 0.1% 
618         swapTokensAtAmount = totalSupply * 4 / 10000; 
619  
620         buyMarketingFee = _buyMarketingFee;
621         buyLiquidityFee = _buyLiquidityFee;
622         buyDevFee = _buyDevFee;
623         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
624  
625         sellMarketingFee = _sellMarketingFee;
626         sellLiquidityFee = _sellLiquidityFee;
627         sellDevFee = _sellDevFee;
628         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
629  
630         marketingWallet = address(0x3aBab3e4e9C29e54c1E8B82D859F7b878Fa6de3d);
631         devWallet = address(0x3aBab3e4e9C29e54c1E8B82D859F7b878Fa6de3d);
632  
633         // exclude from paying fees or having max transaction amount
634         excludeFromFees(owner(), true);
635         excludeFromFees(address(this), true);
636         excludeFromFees(address(0xdead), true);
637  
638         excludeFromMaxTransaction(owner(), true);
639         excludeFromMaxTransaction(address(this), true);
640         excludeFromMaxTransaction(address(0xdead), true);
641  
642         /*
643             _mint is an internal function in ERC20.sol that is only called here,
644             and CANNOT be called ever again
645         */
646         _mint(msg.sender, totalSupply);
647     }
648  
649     receive() external payable {
650  
651     }
652  
653     // once enabled, can never be turned off
654     function enableTrading() external onlyOwner {
655         tradingActive = true;
656         swapEnabled = true;
657         launchedAt = block.number;
658     }
659  
660     // remove limits after token is stable
661     function removeLimits() external onlyOwner returns (bool){
662         limitsInEffect = false;
663         return true;
664     }
665  
666     // disable Transfer delay - cannot be reenabled
667     function disableTransferDelay() external onlyOwner returns (bool){
668         transferDelayEnabled = false;
669         return true;
670     }
671  
672      // change the minimum amount of tokens to sell from fees
673     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
674         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
675         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
676         swapTokensAtAmount = newAmount;
677         return true;
678     }
679  
680     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
681         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
682         maxTransactionAmount = newNum * (10**18);
683     }
684  
685     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
686         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
687         maxWallet = newNum * (10**18);
688     }
689  
690     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
691         _isExcludedMaxTransactionAmount[updAds] = isEx;
692     }
693 
694 
695     function updateBuyFees(
696         uint256 _devFee,
697         uint256 _liquidityFee,
698         uint256 _marketingFee
699     ) external onlyOwner {
700         buyDevFee = _devFee;
701         buyLiquidityFee = _liquidityFee;
702         buyMarketingFee = _marketingFee;
703         buyTotalFees = buyDevFee + buyLiquidityFee + buyMarketingFee;
704     }
705 
706     function updateSellFees(
707         uint256 _devFee,
708         uint256 _liquidityFee,
709         uint256 _marketingFee
710     ) external onlyOwner {
711         sellDevFee = _devFee;
712         sellLiquidityFee = _liquidityFee;
713         sellMarketingFee = _marketingFee;
714         sellTotalFees = sellDevFee + sellLiquidityFee + sellMarketingFee;
715     }
716  
717     // only use to disable contract sales if absolutely necessary (emergency use only)
718     function updateSwapEnabled(bool enabled) external onlyOwner(){
719         swapEnabled = enabled;
720     }
721  
722     function excludeFromFees(address account, bool excluded) public onlyOwner {
723         _isExcludedFromFees[account] = excluded;
724         emit ExcludeFromFees(account, excluded);
725     }
726  
727     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
728         _blacklist[account] = isBlacklisted;
729     }
730  
731     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
732         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
733  
734         _setAutomatedMarketMakerPair(pair, value);
735     }
736  
737     function _setAutomatedMarketMakerPair(address pair, bool value) private {
738         automatedMarketMakerPairs[pair] = value;
739  
740         emit SetAutomatedMarketMakerPair(pair, value);
741     }
742  
743     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
744         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
745         marketingWallet = newMarketingWallet;
746     }
747  
748     function updateDevWallet(address newWallet) external onlyOwner {
749         emit devWalletUpdated(newWallet, devWallet);
750         devWallet = newWallet;
751     }
752  
753     function isExcludedFromFees(address account) public view returns(bool) {
754         return _isExcludedFromFees[account];
755     }
756  
757     function _transfer(
758         address from,
759         address to,
760         uint256 amount
761     ) internal override {
762         require(from != address(0), "ERC20: transfer from the zero address");
763         require(to != address(0), "ERC20: transfer to the zero address");
764         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
765          if(amount == 0) {
766             super._transfer(from, to, 0);
767             return;
768         }
769  
770         if(limitsInEffect){
771             if (
772                 from != owner() &&
773                 to != owner() &&
774                 to != address(0) &&
775                 to != address(0xdead) &&
776                 !swapping
777             ){
778                 if(!tradingActive){
779                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
780                 }
781  
782                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
783                 if (transferDelayEnabled){
784                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
785                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
786                         _holderLastTransferTimestamp[tx.origin] = block.number;
787                     }
788                 }
789  
790                 //when buy
791                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
792                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
793                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
794                 }
795  
796                 //when sell
797                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
798                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
799                 }
800                 else if(!_isExcludedMaxTransactionAmount[to]){
801                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
802                 }
803             }
804         }
805  
806         uint256 contractTokenBalance = balanceOf(address(this));
807  
808         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
809  
810         if( 
811             canSwap &&
812             swapEnabled &&
813             !swapping &&
814             !automatedMarketMakerPairs[from] &&
815             !_isExcludedFromFees[from] &&
816             !_isExcludedFromFees[to]
817         ) {
818             swapping = true;
819  
820             swapBack();
821  
822             swapping = false;
823         }
824  
825         bool takeFee = !swapping;
826  
827         // if any account belongs to _isExcludedFromFee account then remove the fee
828         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
829             takeFee = false;
830         }
831  
832         uint256 fees = 0;
833         // only take fees on buys/sells, do not take on wallet transfers
834         if(takeFee){
835             // on sell
836             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
837                 fees = amount.mul(sellTotalFees).div(100);
838                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
839                 tokensForDev += fees * sellDevFee / sellTotalFees;
840                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
841             }
842             // on buy
843             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
844                 fees = amount.mul(buyTotalFees).div(100);
845                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
846                 tokensForDev += fees * buyDevFee / buyTotalFees;
847                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
848             }
849  
850             if(fees > 0){    
851                 super._transfer(from, address(this), fees);
852             }
853  
854             amount -= fees;
855         }
856  
857         super._transfer(from, to, amount);
858     }
859  
860     function swapTokensForEth(uint256 tokenAmount) private {
861  
862         // generate the uniswap pair path of token -> weth
863         address[] memory path = new address[](2);
864         path[0] = address(this);
865         path[1] = uniswapV2Router.WETH();
866  
867         _approve(address(this), address(uniswapV2Router), tokenAmount);
868  
869         // make the swap
870         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
871             tokenAmount,
872             0, // accept any amount of ETH
873             path,
874             address(this),
875             block.timestamp
876         );
877  
878     }
879  
880     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
881         // approve token transfer to cover all possible scenarios
882         _approve(address(this), address(uniswapV2Router), tokenAmount);
883  
884         // add the liquidity
885         uniswapV2Router.addLiquidityETH{value: ethAmount}(
886             address(this),
887             tokenAmount,
888             0, // slippage is unavoidable
889             0, // slippage is unavoidable
890             address(this),
891             block.timestamp
892         );
893     }
894  
895     function swapBack() private {
896         uint256 contractBalance = balanceOf(address(this));
897         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
898         bool success;
899  
900         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
901  
902         if(contractBalance > swapTokensAtAmount * 20){
903           contractBalance = swapTokensAtAmount * 20;
904         }
905  
906         // Halve the amount of liquidity tokens
907         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
908         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
909  
910         uint256 initialETHBalance = address(this).balance;
911  
912         swapTokensForEth(amountToSwapForETH); 
913  
914         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
915  
916         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
917         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
918         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
919  
920  
921         tokensForLiquidity = 0;
922         tokensForMarketing = 0;
923         tokensForDev = 0;
924  
925         (success,) = address(devWallet).call{value: ethForDev}("");
926  
927         if(liquidityTokens > 0 && ethForLiquidity > 0){
928             addLiquidity(liquidityTokens, ethForLiquidity);
929             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
930         }
931  
932         (success,) = address(marketingWallet).call{value: address(this).balance}("");
933     }
934 }