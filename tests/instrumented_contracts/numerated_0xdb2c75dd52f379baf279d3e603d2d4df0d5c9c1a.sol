1 /*
2  * Diamond Hands - $💎🙌 is here to restore order to the once proud & noble enterprise of meme-based investing.
3  *
4  * https://www.diamondhandstoken.io/
5  * https://t.me/DiamondHandsTkn
6  * https://twitter.com/DiamondHandsTkn
7 */
8 
9 // SPDX-License-Identifier: Unlicensed
10 
11 pragma solidity 0.8.11;
12  
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17  
18     function _msgData() internal view virtual returns (bytes calldata) {
19         return msg.data;
20     }
21 }
22  
23 interface IUniswapV2Pair {
24     event Approval(address indexed owner, address indexed spender, uint value);
25     event Transfer(address indexed from, address indexed to, uint value);
26  
27     function name() external pure returns (string memory);
28     function symbol() external pure returns (string memory);
29     function decimals() external pure returns (uint8);
30     function totalSupply() external view returns (uint);
31     function balanceOf(address owner) external view returns (uint);
32     function allowance(address owner, address spender) external view returns (uint);
33  
34     function approve(address spender, uint value) external returns (bool);
35     function transfer(address to, uint value) external returns (bool);
36     function transferFrom(address from, address to, uint value) external returns (bool);
37  
38     function DOMAIN_SEPARATOR() external view returns (bytes32);
39     function PERMIT_TYPEHASH() external pure returns (bytes32);
40     function nonces(address owner) external view returns (uint);
41  
42     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
43  
44     event Mint(address indexed sender, uint amount0, uint amount1);
45     event Swap(
46         address indexed sender,
47         uint amount0In,
48         uint amount1In,
49         uint amount0Out,
50         uint amount1Out,
51         address indexed to
52     );
53     event Sync(uint112 reserve0, uint112 reserve1);
54  
55     function MINIMUM_LIQUIDITY() external pure returns (uint);
56     function factory() external view returns (address);
57     function token0() external view returns (address);
58     function token1() external view returns (address);
59     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
60     function price0CumulativeLast() external view returns (uint);
61     function price1CumulativeLast() external view returns (uint);
62     function kLast() external view returns (uint);
63  
64     function mint(address to) external returns (uint liquidity);
65     function burn(address to) external returns (uint amount0, uint amount1);
66     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
67     function skim(address to) external;
68     function sync() external;
69  
70     function initialize(address, address) external;
71 }
72  
73 interface IUniswapV2Factory {
74     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
75  
76     function feeTo() external view returns (address);
77     function feeToSetter() external view returns (address);
78  
79     function getPair(address tokenA, address tokenB) external view returns (address pair);
80     function allPairs(uint) external view returns (address pair);
81     function allPairsLength() external view returns (uint);
82  
83     function createPair(address tokenA, address tokenB) external returns (address pair);
84  
85     function setFeeTo(address) external;
86     function setFeeToSetter(address) external;
87 }
88  
89 interface IERC20 {
90 
91     function totalSupply() external view returns (uint256);
92 
93     function balanceOf(address account) external view returns (uint256);
94 
95     function transfer(address recipient, uint256 amount) external returns (bool);
96 
97     function allowance(address owner, address spender) external view returns (uint256);
98 
99     function approve(address spender, uint256 amount) external returns (bool);
100 
101     function transferFrom(
102         address sender,
103         address recipient,
104         uint256 amount
105     ) external returns (bool);
106 
107     event Transfer(address indexed from, address indexed to, uint256 value);
108 
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111  
112 interface IERC20Metadata is IERC20 {
113 
114     function name() external view returns (string memory);
115 
116     function symbol() external view returns (string memory);
117 
118     function decimals() external view returns (uint8);
119 }
120  
121  
122 contract ERC20 is Context, IERC20, IERC20Metadata {
123     using SafeMath for uint256;
124  
125     mapping(address => uint256) private _balances;
126  
127     mapping(address => mapping(address => uint256)) private _allowances;
128  
129     uint256 private _totalSupply;
130  
131     string private _name;
132     string private _symbol;
133 
134     constructor(string memory name_, string memory symbol_) {
135         _name = name_;
136         _symbol = symbol_;
137     }
138 
139     function name() public view virtual override returns (string memory) {
140         return _name;
141     }
142 
143     function symbol() public view virtual override returns (string memory) {
144         return _symbol;
145     }
146 
147     function decimals() public view virtual override returns (uint8) {
148         return 18;
149     }
150 
151     function totalSupply() public view virtual override returns (uint256) {
152         return _totalSupply;
153     }
154 
155     function balanceOf(address account) public view virtual override returns (uint256) {
156         return _balances[account];
157     }
158 
159     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
160         _transfer(_msgSender(), recipient, amount);
161         return true;
162     }
163 
164     function allowance(address owner, address spender) public view virtual override returns (uint256) {
165         return _allowances[owner][spender];
166     }
167 
168     function approve(address spender, uint256 amount) public virtual override returns (bool) {
169         _approve(_msgSender(), spender, amount);
170         return true;
171     }
172 
173     function transferFrom(
174         address sender,
175         address recipient,
176         uint256 amount
177     ) public virtual override returns (bool) {
178         _transfer(sender, recipient, amount);
179         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
180         return true;
181     }
182 
183     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
184         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
185         return true;
186     }
187 
188     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
189         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
190         return true;
191     }
192 
193     function _transfer(
194         address sender,
195         address recipient,
196         uint256 amount
197     ) internal virtual {
198         require(sender != address(0), "ERC20: transfer from the zero address");
199         require(recipient != address(0), "ERC20: transfer to the zero address");
200  
201         _beforeTokenTransfer(sender, recipient, amount);
202  
203         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
204         _balances[recipient] = _balances[recipient].add(amount);
205         emit Transfer(sender, recipient, amount);
206     }
207 
208     function _mint(address account, uint256 amount) internal virtual {
209         require(account != address(0), "ERC20: mint to the zero address");
210  
211         _beforeTokenTransfer(address(0), account, amount);
212  
213         _totalSupply = _totalSupply.add(amount);
214         _balances[account] = _balances[account].add(amount);
215         emit Transfer(address(0), account, amount);
216     }
217 
218     function _burn(address account, uint256 amount) internal virtual {
219         require(account != address(0), "ERC20: burn from the zero address");
220  
221         _beforeTokenTransfer(account, address(0), amount);
222  
223         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
224         _totalSupply = _totalSupply.sub(amount);
225         emit Transfer(account, address(0), amount);
226     }
227 
228     function _approve(
229         address owner,
230         address spender,
231         uint256 amount
232     ) internal virtual {
233         require(owner != address(0), "ERC20: approve from the zero address");
234         require(spender != address(0), "ERC20: approve to the zero address");
235  
236         _allowances[owner][spender] = amount;
237         emit Approval(owner, spender, amount);
238     }
239 
240     function _beforeTokenTransfer(
241         address from,
242         address to,
243         uint256 amount
244     ) internal virtual {}
245 }
246  
247 library SafeMath {
248 
249     function add(uint256 a, uint256 b) internal pure returns (uint256) {
250         uint256 c = a + b;
251         require(c >= a, "SafeMath: addition overflow");
252  
253         return c;
254     }
255 
256     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
257         return sub(a, b, "SafeMath: subtraction overflow");
258     }
259 
260     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
261         require(b <= a, errorMessage);
262         uint256 c = a - b;
263  
264         return c;
265     }
266 
267     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
268 
269         if (a == 0) {
270             return 0;
271         }
272  
273         uint256 c = a * b;
274         require(c / a == b, "SafeMath: multiplication overflow");
275  
276         return c;
277     }
278 
279     function div(uint256 a, uint256 b) internal pure returns (uint256) {
280         return div(a, b, "SafeMath: division by zero");
281     }
282 
283     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
284         require(b > 0, errorMessage);
285         uint256 c = a / b;
286         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
287  
288         return c;
289     }
290 
291     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
292         return mod(a, b, "SafeMath: modulo by zero");
293     }
294 
295     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
296         require(b != 0, errorMessage);
297         return a % b;
298     }
299 }
300  
301 contract Ownable is Context {
302     address private _owner;
303  
304     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
305 
306     constructor () {
307         address msgSender = _msgSender();
308         _owner = msgSender;
309         emit OwnershipTransferred(address(0), msgSender);
310     }
311 
312     function owner() public view returns (address) {
313         return _owner;
314     }
315 
316     modifier onlyOwner() {
317         require(_owner == _msgSender(), "Ownable: caller is not the owner");
318         _;
319     }
320 
321     function renounceOwnership() public virtual onlyOwner {
322         emit OwnershipTransferred(_owner, address(0));
323         _owner = address(0);
324     }
325 
326     function transferOwnership(address newOwner) public virtual onlyOwner {
327         require(newOwner != address(0), "Ownable: new owner is the zero address");
328         emit OwnershipTransferred(_owner, newOwner);
329         _owner = newOwner;
330     }
331 }
332  
333  
334  
335 library SafeMathInt {
336     int256 private constant MIN_INT256 = int256(1) << 255;
337     int256 private constant MAX_INT256 = ~(int256(1) << 255);
338 
339     function mul(int256 a, int256 b) internal pure returns (int256) {
340         int256 c = a * b;
341  
342         // Detect overflow when multiplying MIN_INT256 with -1
343         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
344         require((b == 0) || (c / b == a));
345         return c;
346     }
347 
348     function div(int256 a, int256 b) internal pure returns (int256) {
349         // Prevent overflow when dividing MIN_INT256 by -1
350         require(b != -1 || a != MIN_INT256);
351  
352         // Solidity already throws when dividing by 0.
353         return a / b;
354     }
355 
356     function sub(int256 a, int256 b) internal pure returns (int256) {
357         int256 c = a - b;
358         require((b >= 0 && c <= a) || (b < 0 && c > a));
359         return c;
360     }
361 
362     function add(int256 a, int256 b) internal pure returns (int256) {
363         int256 c = a + b;
364         require((b >= 0 && c >= a) || (b < 0 && c < a));
365         return c;
366     }
367 
368     function abs(int256 a) internal pure returns (int256) {
369         require(a != MIN_INT256);
370         return a < 0 ? -a : a;
371     }
372  
373  
374     function toUint256Safe(int256 a) internal pure returns (uint256) {
375         require(a >= 0);
376         return uint256(a);
377     }
378 }
379  
380 library SafeMathUint {
381   function toInt256Safe(uint256 a) internal pure returns (int256) {
382     int256 b = int256(a);
383     require(b >= 0);
384     return b;
385   }
386 }
387  
388  
389 interface IUniswapV2Router01 {
390     function factory() external pure returns (address);
391     function WETH() external pure returns (address);
392  
393     function addLiquidity(
394         address tokenA,
395         address tokenB,
396         uint amountADesired,
397         uint amountBDesired,
398         uint amountAMin,
399         uint amountBMin,
400         address to,
401         uint deadline
402     ) external returns (uint amountA, uint amountB, uint liquidity);
403     function addLiquidityETH(
404         address token,
405         uint amountTokenDesired,
406         uint amountTokenMin,
407         uint amountETHMin,
408         address to,
409         uint deadline
410     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
411     function removeLiquidity(
412         address tokenA,
413         address tokenB,
414         uint liquidity,
415         uint amountAMin,
416         uint amountBMin,
417         address to,
418         uint deadline
419     ) external returns (uint amountA, uint amountB);
420     function removeLiquidityETH(
421         address token,
422         uint liquidity,
423         uint amountTokenMin,
424         uint amountETHMin,
425         address to,
426         uint deadline
427     ) external returns (uint amountToken, uint amountETH);
428     function removeLiquidityWithPermit(
429         address tokenA,
430         address tokenB,
431         uint liquidity,
432         uint amountAMin,
433         uint amountBMin,
434         address to,
435         uint deadline,
436         bool approveMax, uint8 v, bytes32 r, bytes32 s
437     ) external returns (uint amountA, uint amountB);
438     function removeLiquidityETHWithPermit(
439         address token,
440         uint liquidity,
441         uint amountTokenMin,
442         uint amountETHMin,
443         address to,
444         uint deadline,
445         bool approveMax, uint8 v, bytes32 r, bytes32 s
446     ) external returns (uint amountToken, uint amountETH);
447     function swapExactTokensForTokens(
448         uint amountIn,
449         uint amountOutMin,
450         address[] calldata path,
451         address to,
452         uint deadline
453     ) external returns (uint[] memory amounts);
454     function swapTokensForExactTokens(
455         uint amountOut,
456         uint amountInMax,
457         address[] calldata path,
458         address to,
459         uint deadline
460     ) external returns (uint[] memory amounts);
461     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
462         external
463         payable
464         returns (uint[] memory amounts);
465     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
466         external
467         returns (uint[] memory amounts);
468     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
469         external
470         returns (uint[] memory amounts);
471     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
472         external
473         payable
474         returns (uint[] memory amounts);
475  
476     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
477     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
478     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
479     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
480     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
481 }
482  
483 interface IUniswapV2Router02 is IUniswapV2Router01 {
484     function removeLiquidityETHSupportingFeeOnTransferTokens(
485         address token,
486         uint liquidity,
487         uint amountTokenMin,
488         uint amountETHMin,
489         address to,
490         uint deadline
491     ) external returns (uint amountETH);
492     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
493         address token,
494         uint liquidity,
495         uint amountTokenMin,
496         uint amountETHMin,
497         address to,
498         uint deadline,
499         bool approveMax, uint8 v, bytes32 r, bytes32 s
500     ) external returns (uint amountETH);
501  
502     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
503         uint amountIn,
504         uint amountOutMin,
505         address[] calldata path,
506         address to,
507         uint deadline
508     ) external;
509     function swapExactETHForTokensSupportingFeeOnTransferTokens(
510         uint amountOutMin,
511         address[] calldata path,
512         address to,
513         uint deadline
514     ) external payable;
515     function swapExactTokensForETHSupportingFeeOnTransferTokens(
516         uint amountIn,
517         uint amountOutMin,
518         address[] calldata path,
519         address to,
520         uint deadline
521     ) external;
522 }
523  
524 contract diamondhands is ERC20, Ownable {
525     using SafeMath for uint256;
526  
527     IUniswapV2Router02 public immutable uniswapV2Router;
528     address public immutable uniswapV2Pair;
529  
530     bool private swapping;
531  
532     address private marketingWallet;
533     address private devWallet;
534  
535     uint256 public maxTransactionAmount;
536     uint256 public swapTokensAtAmount;
537     uint256 public maxWallet;
538  
539     bool public limitsInEffect = true;
540     bool public tradingActive = false;
541     bool public swapEnabled = false;
542  
543      // Anti-bot and anti-whale mappings and variables
544     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
545  
546     // Seller Map
547     mapping (address => uint256) private _holderFirstBuyTimestamp;
548  
549     // Blacklist Map
550     mapping (address => bool) private _blacklist;
551     bool public transferDelayEnabled = true;
552  
553     uint256 public buyTotalFees;
554     uint256 public buyMarketingFee;
555     uint256 public buyLiquidityFee;
556     uint256 public buyDevFee;
557  
558     uint256 public sellTotalFees;
559     uint256 public sellMarketingFee;
560     uint256 public sellLiquidityFee;
561     uint256 public sellDevFee;
562  
563     uint256 public tokensForMarketing;
564     uint256 public tokensForLiquidity;
565     uint256 public tokensForDev;
566  
567     // block number of opened trading
568     uint256 launchedAt;
569  
570     /******************/
571  
572     // exclude from fees and max transaction amount
573     mapping (address => bool) private _isExcludedFromFees;
574     mapping (address => bool) public _isExcludedMaxTransactionAmount;
575  
576     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
577     // could be subject to a maximum transfer amount
578     mapping (address => bool) public automatedMarketMakerPairs;
579  
580     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
581  
582     event ExcludeFromFees(address indexed account, bool isExcluded);
583  
584     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
585  
586     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
587  
588     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
589  
590     event SwapAndLiquify(
591         uint256 tokensSwapped,
592         uint256 ethReceived,
593         uint256 tokensIntoLiquidity
594     );
595  
596     event AutoNukeLP();
597  
598     event ManualNukeLP();
599  
600     constructor() ERC20("Diamond Hands", unicode"💎🙌") {
601  
602         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
603  
604         excludeFromMaxTransaction(address(_uniswapV2Router), true);
605         uniswapV2Router = _uniswapV2Router;
606  
607         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
608         excludeFromMaxTransaction(address(uniswapV2Pair), true);
609         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
610  
611         uint256 _buyMarketingFee = 25;
612         uint256 _buyLiquidityFee = 0;
613         uint256 _buyDevFee = 0;
614  
615         uint256 _sellMarketingFee = 25;
616         uint256 _sellLiquidityFee = 0;
617         uint256 _sellDevFee = 0;
618  
619         uint256 totalSupply = 69000000000000 * 1e18;
620  
621         maxTransactionAmount = totalSupply * 5 / 1000; // .5%
622         maxWallet = totalSupply * 10 / 1000; // 1% 
623         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05%
624  
625         buyMarketingFee = _buyMarketingFee;
626         buyLiquidityFee = _buyLiquidityFee;
627         buyDevFee = _buyDevFee;
628         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
629  
630         sellMarketingFee = _sellMarketingFee;
631         sellLiquidityFee = _sellLiquidityFee;
632         sellDevFee = _sellDevFee;
633         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
634  
635         marketingWallet = address(0x1785c384692b127aCd31B2A993A9c5D28D3499E3);
636         devWallet = address(0xa34EF54174abBa8B719A847f255A9c57d2a32732);
637  
638         // exclude from paying fees or having max transaction amount
639         excludeFromFees(owner(), true);
640         excludeFromFees(address(this), true);
641         excludeFromFees(address(0xdead), true);
642         excludeFromFees(address(marketingWallet), true);
643  
644         excludeFromMaxTransaction(owner(), true);
645         excludeFromMaxTransaction(address(this), true);
646         excludeFromMaxTransaction(address(0xdead), true);
647         excludeFromMaxTransaction(address(devWallet), true);
648         excludeFromMaxTransaction(address(marketingWallet), true);
649  
650         /*
651             _mint is an internal function in ERC20.sol that is only called here,
652             and CANNOT be called ever again
653         */
654         _mint(msg.sender, totalSupply);
655     }
656  
657     receive() external payable {
658  
659     }
660  
661     // once enabled, can never be turned off
662     function enableTrading() external onlyOwner {
663         tradingActive = true;
664         swapEnabled = true;
665         launchedAt = block.number;
666     }
667  
668     // remove limits after token is stable
669     function removeLimits() external onlyOwner returns (bool){
670         limitsInEffect = false;
671         return true;
672     }
673  
674     // disable Transfer delay - cannot be reenabled
675     function disableTransferDelay() external onlyOwner returns (bool){
676         transferDelayEnabled = false;
677         return true;
678     }
679  
680      // change the minimum amount of tokens to sell from fees
681     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
682         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
683         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
684         swapTokensAtAmount = newAmount;
685         return true;
686     }
687  
688     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
689         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
690         maxTransactionAmount = newNum * (10**18);
691     }
692  
693     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
694         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
695         maxWallet = newNum * (10**18);
696     }
697  
698     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
699         _isExcludedMaxTransactionAmount[updAds] = isEx;
700     }
701 
702     function updateBuyFees(
703         uint256 _devFee,
704         uint256 _liquidityFee,
705         uint256 _marketingFee
706     ) external onlyOwner {
707         buyDevFee = _devFee;
708         buyLiquidityFee = _liquidityFee;
709         buyMarketingFee = _marketingFee;
710         buyTotalFees = buyDevFee + buyLiquidityFee + buyMarketingFee;
711     }
712 
713     function updateSellFees(
714         uint256 _devFee,
715         uint256 _liquidityFee,
716         uint256 _marketingFee
717     ) external onlyOwner {
718         sellDevFee = _devFee;
719         sellLiquidityFee = _liquidityFee;
720         sellMarketingFee = _marketingFee;
721         sellTotalFees = sellDevFee + sellLiquidityFee + sellMarketingFee;
722     }
723  
724     // only use to disable contract sales if absolutely necessary (emergency use only)
725     function updateSwapEnabled(bool enabled) external onlyOwner(){
726         swapEnabled = enabled;
727     }
728  
729     function excludeFromFees(address account, bool excluded) public onlyOwner {
730         _isExcludedFromFees[account] = excluded;
731         emit ExcludeFromFees(account, excluded);
732     }
733  
734     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
735         _blacklist[account] = isBlacklisted;
736     }
737  
738     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
739         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
740  
741         _setAutomatedMarketMakerPair(pair, value);
742     }
743  
744     function _setAutomatedMarketMakerPair(address pair, bool value) private {
745         automatedMarketMakerPairs[pair] = value;
746  
747         emit SetAutomatedMarketMakerPair(pair, value);
748     }
749  
750     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
751         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
752         marketingWallet = newMarketingWallet;
753     }
754  
755     function updateDevWallet(address newWallet) external onlyOwner {
756         emit devWalletUpdated(newWallet, devWallet);
757         devWallet = newWallet;
758     }
759  
760  
761     function isExcludedFromFees(address account) public view returns(bool) {
762         return _isExcludedFromFees[account];
763     }
764  
765     function _transfer(
766         address from,
767         address to,
768         uint256 amount
769     ) internal override {
770         require(from != address(0), "ERC20: transfer from the zero address");
771         require(to != address(0), "ERC20: transfer to the zero address");
772         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
773          if(amount == 0) {
774             super._transfer(from, to, 0);
775             return;
776         }
777  
778         if(limitsInEffect){
779             if (
780                 from != owner() &&
781                 to != owner() &&
782                 to != address(0) &&
783                 to != address(0xdead) &&
784                 !swapping
785             ){
786                 if(!tradingActive){
787                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
788                 }
789  
790                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
791                 if (transferDelayEnabled){
792                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
793                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
794                         _holderLastTransferTimestamp[tx.origin] = block.number;
795                     }
796                 }
797  
798                 //when buy
799                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
800                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
801                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
802                 }
803  
804                 //when sell
805                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
806                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
807                 }
808                 else if(!_isExcludedMaxTransactionAmount[to]){
809                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
810                 }
811             }
812         }
813  
814         uint256 contractTokenBalance = balanceOf(address(this));
815  
816         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
817  
818         if( 
819             canSwap &&
820             swapEnabled &&
821             !swapping &&
822             !automatedMarketMakerPairs[from] &&
823             !_isExcludedFromFees[from] &&
824             !_isExcludedFromFees[to]
825         ) {
826             swapping = true;
827  
828             swapBack();
829  
830             swapping = false;
831         }
832  
833         bool takeFee = !swapping;
834  
835         // if any account belongs to _isExcludedFromFee account then remove the fee
836         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
837             takeFee = false;
838         }
839  
840         uint256 fees = 0;
841         // only take fees on buys/sells, do not take on wallet transfers
842         if(takeFee){
843             // on sell
844             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
845                 fees = amount.mul(sellTotalFees).div(100);
846                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
847                 tokensForDev += fees * sellDevFee / sellTotalFees;
848                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
849             }
850             // on buy
851             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
852                 fees = amount.mul(buyTotalFees).div(100);
853                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
854                 tokensForDev += fees * buyDevFee / buyTotalFees;
855                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
856             }
857  
858             if(fees > 0){    
859                 super._transfer(from, address(this), fees);
860             }
861  
862             amount -= fees;
863         }
864  
865         super._transfer(from, to, amount);
866     }
867  
868     function swapTokensForEth(uint256 tokenAmount) private {
869  
870         // generate the uniswap pair path of token -> weth
871         address[] memory path = new address[](2);
872         path[0] = address(this);
873         path[1] = uniswapV2Router.WETH();
874  
875         _approve(address(this), address(uniswapV2Router), tokenAmount);
876  
877         // make the swap
878         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
879             tokenAmount,
880             0, // accept any amount of ETH
881             path,
882             address(this),
883             block.timestamp
884         );
885  
886     }
887  
888     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
889         // approve token transfer to cover all possible scenarios
890         _approve(address(this), address(uniswapV2Router), tokenAmount);
891  
892         // add the liquidity
893         uniswapV2Router.addLiquidityETH{value: ethAmount}(
894             address(this),
895             tokenAmount,
896             0, // slippage is unavoidable
897             0, // slippage is unavoidable
898             address(this),
899             block.timestamp
900         );
901     }
902  
903     function swapBack() private {
904         uint256 contractBalance = balanceOf(address(this));
905         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
906         bool success;
907  
908         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
909  
910         if(contractBalance > swapTokensAtAmount * 20){
911           contractBalance = swapTokensAtAmount * 20;
912         }
913  
914         // Halve the amount of liquidity tokens
915         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
916         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
917  
918         uint256 initialETHBalance = address(this).balance;
919  
920         swapTokensForEth(amountToSwapForETH); 
921  
922         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
923  
924         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
925         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
926         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
927  
928  
929         tokensForLiquidity = 0;
930         tokensForMarketing = 0;
931         tokensForDev = 0;
932  
933         (success,) = address(devWallet).call{value: ethForDev}("");
934  
935         if(liquidityTokens > 0 && ethForLiquidity > 0){
936             addLiquidity(liquidityTokens, ethForLiquidity);
937             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
938         }
939  
940         (success,) = address(marketingWallet).call{value: address(this).balance}("");
941     }
942 }