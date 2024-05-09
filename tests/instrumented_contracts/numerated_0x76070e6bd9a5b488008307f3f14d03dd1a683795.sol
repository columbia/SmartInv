1 /*
2 **
3 **         EIGHT ($8)
4 **         Website: https://www.eighttoken.com/
5 **         Telegram: https://t.me/EightEntry
6 **         Medium: https://medium.com/@EightToken
7 **         Twitter: https://twitter.com/8EightToken
8 */
9 
10 // SPDX-License-Identifier: Unlicensed
11 
12 pragma solidity 0.8.9;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18  
19     function _msgData() internal view virtual returns (bytes calldata) {
20         this;
21         return msg.data;
22     }
23 }
24  
25 interface IUniswapV2Pair {
26     event Approval(address indexed owner, address indexed spender, uint value);
27     event Transfer(address indexed from, address indexed to, uint value);
28  
29     function name() external pure returns (string memory);
30     function symbol() external pure returns (string memory);
31     function decimals() external pure returns (uint8);
32     function totalSupply() external view returns (uint);
33     function balanceOf(address owner) external view returns (uint);
34     function allowance(address owner, address spender) external view returns (uint);
35  
36     function approve(address spender, uint value) external returns (bool);
37     function transfer(address to, uint value) external returns (bool);
38     function transferFrom(address from, address to, uint value) external returns (bool);
39  
40     function DOMAIN_SEPARATOR() external view returns (bytes32);
41     function PERMIT_TYPEHASH() external pure returns (bytes32);
42     function nonces(address owner) external view returns (uint);
43  
44     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
45  
46     event Mint(address indexed sender, uint amount0, uint amount1);
47     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
48     event Swap(
49         address indexed sender,
50         uint amount0In,
51         uint amount1In,
52         uint amount0Out,
53         uint amount1Out,
54         address indexed to
55     );
56     event Sync(uint112 reserve0, uint112 reserve1);
57  
58     function MINIMUM_LIQUIDITY() external pure returns (uint);
59     function factory() external view returns (address);
60     function token0() external view returns (address);
61     function token1() external view returns (address);
62     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
63     function price0CumulativeLast() external view returns (uint);
64     function price1CumulativeLast() external view returns (uint);
65     function kLast() external view returns (uint);
66  
67     function mint(address to) external returns (uint liquidity);
68     function burn(address to) external returns (uint amount0, uint amount1);
69     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
70     function skim(address to) external;
71     function sync() external;
72  
73     function initialize(address, address) external;
74 }
75  
76 interface IUniswapV2Factory {
77     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
78  
79     function feeTo() external view returns (address);
80     function feeToSetter() external view returns (address);
81  
82     function getPair(address tokenA, address tokenB) external view returns (address pair);
83     function allPairs(uint) external view returns (address pair);
84     function allPairsLength() external view returns (uint);
85  
86     function createPair(address tokenA, address tokenB) external returns (address pair);
87  
88     function setFeeTo(address) external;
89     function setFeeToSetter(address) external;
90 }
91  
92 interface IERC20 {
93 
94     function totalSupply() external view returns (uint256);
95  
96     function balanceOf(address account) external view returns (uint256);
97  
98     function transfer(address recipient, uint256 amount) external returns (bool);
99  
100     function allowance(address owner, address spender) external view returns (uint256);
101  
102     function approve(address spender, uint256 amount) external returns (bool);
103  
104     function transferFrom(
105         address sender,
106         address recipient,
107         uint256 amount
108     ) external returns (bool);
109  
110     event Transfer(address indexed from, address indexed to, uint256 value);
111  
112     event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114  
115 interface IERC20Metadata is IERC20 {
116 
117     function name() external view returns (string memory);
118  
119     function symbol() external view returns (string memory);
120  
121     function decimals() external view returns (uint8);
122 }
123  
124  
125 contract ERC20 is Context, IERC20, IERC20Metadata {
126     using SafeMath for uint256;
127  
128     mapping(address => uint256) private _balances;
129  
130     mapping(address => mapping(address => uint256)) private _allowances;
131  
132     uint256 private _totalSupply;
133  
134     string private _name;
135     string private _symbol;
136  
137     constructor(string memory name_, string memory symbol_) {
138         _name = name_;
139         _symbol = symbol_;
140     }
141  
142     function name() public view virtual override returns (string memory) {
143         return _name;
144     }
145  
146     function symbol() public view virtual override returns (string memory) {
147         return _symbol;
148     }
149  
150     function decimals() public view virtual override returns (uint8) {
151         return 18;
152     }
153  
154     function totalSupply() public view virtual override returns (uint256) {
155         return _totalSupply;
156     }
157  
158     function balanceOf(address account) public view virtual override returns (uint256) {
159         return _balances[account];
160     }
161  
162     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
163         _transfer(_msgSender(), recipient, amount);
164         return true;
165     }
166  
167     function allowance(address owner, address spender) public view virtual override returns (uint256) {
168         return _allowances[owner][spender];
169     }
170  
171     function approve(address spender, uint256 amount) public virtual override returns (bool) {
172         _approve(_msgSender(), spender, amount);
173         return true;
174     }
175  
176     function transferFrom(
177         address sender,
178         address recipient,
179         uint256 amount
180     ) public virtual override returns (bool) {
181         _transfer(sender, recipient, amount);
182         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
183         return true;
184     }
185  
186     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
187         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
188         return true;
189     }
190  
191     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
192         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
193         return true;
194     }
195  
196     function _transfer(
197         address sender,
198         address recipient,
199         uint256 amount
200     ) internal virtual {
201         require(sender != address(0), "ERC20: transfer from the zero address");
202         require(recipient != address(0), "ERC20: transfer to the zero address");
203  
204         _beforeTokenTransfer(sender, recipient, amount);
205  
206         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
207         _balances[recipient] = _balances[recipient].add(amount);
208         emit Transfer(sender, recipient, amount);
209     }
210  
211     function _mint(address account, uint256 amount) internal virtual {
212         require(account != address(0), "ERC20: mint to the zero address");
213  
214         _beforeTokenTransfer(address(0), account, amount);
215  
216         _totalSupply = _totalSupply.add(amount);
217         _balances[account] = _balances[account].add(amount);
218         emit Transfer(address(0), account, amount);
219     }
220  
221     function _burn(address account, uint256 amount) internal virtual {
222         require(account != address(0), "ERC20: burn from the zero address");
223  
224         _beforeTokenTransfer(account, address(0), amount);
225  
226         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
227         _totalSupply = _totalSupply.sub(amount);
228         emit Transfer(account, address(0), amount);
229     }
230  
231     function _approve(
232         address owner,
233         address spender,
234         uint256 amount
235     ) internal virtual {
236         require(owner != address(0), "ERC20: approve from the zero address");
237         require(spender != address(0), "ERC20: approve to the zero address");
238  
239         _allowances[owner][spender] = amount;
240         emit Approval(owner, spender, amount);
241     }
242  
243     function _beforeTokenTransfer(
244         address from,
245         address to,
246         uint256 amount
247     ) internal virtual {}
248 }
249  
250 library SafeMath {
251 
252     function add(uint256 a, uint256 b) internal pure returns (uint256) {
253         uint256 c = a + b;
254         require(c >= a, "SafeMath: addition overflow");
255  
256         return c;
257     }
258  
259     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
260         return sub(a, b, "SafeMath: subtraction overflow");
261     }
262  
263     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b <= a, errorMessage);
265         uint256 c = a - b;
266  
267         return c;
268     }
269  
270     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
271         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
272         // benefit is lost if 'b' is also tested.
273         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
274         if (a == 0) {
275             return 0;
276         }
277  
278         uint256 c = a * b;
279         require(c / a == b, "SafeMath: multiplication overflow");
280  
281         return c;
282     }
283  
284     function div(uint256 a, uint256 b) internal pure returns (uint256) {
285         return div(a, b, "SafeMath: division by zero");
286     }
287  
288     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
289         require(b > 0, errorMessage);
290         uint256 c = a / b;
291         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
292  
293         return c;
294     }
295  
296     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
297         return mod(a, b, "SafeMath: modulo by zero");
298     }
299  
300     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
301         require(b != 0, errorMessage);
302         return a % b;
303     }
304 }
305  
306 contract Ownable is Context {
307     address private _owner;
308  
309     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
310  
311     constructor () {
312         address msgSender = _msgSender();
313         _owner = msgSender;
314         emit OwnershipTransferred(address(0), msgSender);
315     }
316  
317     function owner() public view returns (address) {
318         return _owner;
319     }
320  
321     modifier onlyOwner() {
322         require(_owner == _msgSender(), "Ownable: caller is not the owner");
323         _;
324     }
325  
326     function renounceOwnership() public virtual onlyOwner {
327         emit OwnershipTransferred(_owner, address(0));
328         _owner = address(0);
329     }
330  
331     function transferOwnership(address newOwner) public virtual onlyOwner {
332         require(newOwner != address(0), "Ownable: new owner is the zero address");
333         emit OwnershipTransferred(_owner, newOwner);
334         _owner = newOwner;
335     }
336 }
337  
338 library SafeMathInt {
339     int256 private constant MIN_INT256 = int256(1) << 255;
340     int256 private constant MAX_INT256 = ~(int256(1) << 255);
341  
342     function mul(int256 a, int256 b) internal pure returns (int256) {
343         int256 c = a * b;
344  
345         // Detect overflow when multiplying MIN_INT256 with -1
346         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
347         require((b == 0) || (c / b == a));
348         return c;
349     }
350 
351     function div(int256 a, int256 b) internal pure returns (int256) {
352         // Prevent overflow when dividing MIN_INT256 by -1
353         require(b != -1 || a != MIN_INT256);
354  
355         // Solidity already throws when dividing by 0.
356         return a / b;
357     }
358  
359     function sub(int256 a, int256 b) internal pure returns (int256) {
360         int256 c = a - b;
361         require((b >= 0 && c <= a) || (b < 0 && c > a));
362         return c;
363     }
364  
365     function add(int256 a, int256 b) internal pure returns (int256) {
366         int256 c = a + b;
367         require((b >= 0 && c >= a) || (b < 0 && c < a));
368         return c;
369     }
370  
371     function abs(int256 a) internal pure returns (int256) {
372         require(a != MIN_INT256);
373         return a < 0 ? -a : a;
374     }
375  
376  
377     function toUint256Safe(int256 a) internal pure returns (uint256) {
378         require(a >= 0);
379         return uint256(a);
380     }
381 }
382  
383 library SafeMathUint {
384   function toInt256Safe(uint256 a) internal pure returns (int256) {
385     int256 b = int256(a);
386     require(b >= 0);
387     return b;
388   }
389 }
390  
391  
392 interface IUniswapV2Router01 {
393     function factory() external pure returns (address);
394     function WETH() external pure returns (address);
395  
396     function addLiquidity(
397         address tokenA,
398         address tokenB,
399         uint amountADesired,
400         uint amountBDesired,
401         uint amountAMin,
402         uint amountBMin,
403         address to,
404         uint deadline
405     ) external returns (uint amountA, uint amountB, uint liquidity);
406     function addLiquidityETH(
407         address token,
408         uint amountTokenDesired,
409         uint amountTokenMin,
410         uint amountETHMin,
411         address to,
412         uint deadline
413     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
414     function removeLiquidity(
415         address tokenA,
416         address tokenB,
417         uint liquidity,
418         uint amountAMin,
419         uint amountBMin,
420         address to,
421         uint deadline
422     ) external returns (uint amountA, uint amountB);
423     function removeLiquidityETH(
424         address token,
425         uint liquidity,
426         uint amountTokenMin,
427         uint amountETHMin,
428         address to,
429         uint deadline
430     ) external returns (uint amountToken, uint amountETH);
431     function removeLiquidityWithPermit(
432         address tokenA,
433         address tokenB,
434         uint liquidity,
435         uint amountAMin,
436         uint amountBMin,
437         address to,
438         uint deadline,
439         bool approveMax, uint8 v, bytes32 r, bytes32 s
440     ) external returns (uint amountA, uint amountB);
441     function removeLiquidityETHWithPermit(
442         address token,
443         uint liquidity,
444         uint amountTokenMin,
445         uint amountETHMin,
446         address to,
447         uint deadline,
448         bool approveMax, uint8 v, bytes32 r, bytes32 s
449     ) external returns (uint amountToken, uint amountETH);
450     function swapExactTokensForTokens(
451         uint amountIn,
452         uint amountOutMin,
453         address[] calldata path,
454         address to,
455         uint deadline
456     ) external returns (uint[] memory amounts);
457     function swapTokensForExactTokens(
458         uint amountOut,
459         uint amountInMax,
460         address[] calldata path,
461         address to,
462         uint deadline
463     ) external returns (uint[] memory amounts);
464     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
465         external
466         payable
467         returns (uint[] memory amounts);
468     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
469         external
470         returns (uint[] memory amounts);
471     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
472         external
473         returns (uint[] memory amounts);
474     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
475         external
476         payable
477         returns (uint[] memory amounts);
478  
479     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
480     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
481     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
482     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
483     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
484 }
485  
486 interface IUniswapV2Router02 is IUniswapV2Router01 {
487     function removeLiquidityETHSupportingFeeOnTransferTokens(
488         address token,
489         uint liquidity,
490         uint amountTokenMin,
491         uint amountETHMin,
492         address to,
493         uint deadline
494     ) external returns (uint amountETH);
495     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
496         address token,
497         uint liquidity,
498         uint amountTokenMin,
499         uint amountETHMin,
500         address to,
501         uint deadline,
502         bool approveMax, uint8 v, bytes32 r, bytes32 s
503     ) external returns (uint amountETH);
504  
505     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
506         uint amountIn,
507         uint amountOutMin,
508         address[] calldata path,
509         address to,
510         uint deadline
511     ) external;
512     function swapExactETHForTokensSupportingFeeOnTransferTokens(
513         uint amountOutMin,
514         address[] calldata path,
515         address to,
516         uint deadline
517     ) external payable;
518     function swapExactTokensForETHSupportingFeeOnTransferTokens(
519         uint amountIn,
520         uint amountOutMin,
521         address[] calldata path,
522         address to,
523         uint deadline
524     ) external;
525 }
526  
527 contract EIGHT is ERC20, Ownable {
528     using SafeMath for uint256;
529  
530     IUniswapV2Router02 public immutable uniswapV2Router;
531     address public immutable uniswapV2Pair;
532     address public constant deadAddress = address(0xbC7b67140E5BAB7E94Cc970B966D43818b065471);
533  
534     bool private swapping;
535  
536     address public marketingWallet;
537     address public devWallet;
538  
539     uint256 public maxTransactionAmount;
540     uint256 public swapTokensAtAmount;
541     uint256 public maxWallet;
542  
543     uint256 public percentForLPBurn = 10; // 10 = .10%
544     bool public lpBurnEnabled = true;
545     uint256 public lpBurnFrequency = 7200 seconds;
546     uint256 public lastLpBurnTime;
547  
548     uint256 public manualBurnFrequency = 30 minutes;
549     uint256 public lastManualLpBurnTime;
550  
551     bool public limitsInEffect = true;
552     bool public tradingActive = false;
553     bool public swapEnabled = false;
554     bool public enableEarlySellTax = true;
555  
556      // Anti-bot and anti-whale mappings and variables
557     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
558  
559     // Seller Map
560     mapping (address => uint256) private _holderFirstBuyTimestamp;
561  
562     // Blacklist Map
563     mapping (address => bool) private _blacklist;
564     bool public transferDelayEnabled = true;
565  
566     uint256 public buyTotalFees;
567     uint256 public buyMarketingFee;
568     uint256 public buyLiquidityFee;
569     uint256 public buyDevFee;
570  
571     uint256 public sellTotalFees;
572     uint256 public sellMarketingFee;
573     uint256 public sellLiquidityFee;
574     uint256 public sellDevFee;
575  
576     uint256 public earlySellLiquidityFee;
577     uint256 public earlySellMarketingFee;
578  
579     uint256 public tokensForMarketing;
580     uint256 public tokensForLiquidity;
581     uint256 public tokensForDev;
582  
583     // block number of opened trading
584     uint256 launchedAt;
585  
586     /******************/
587  
588     // exclude from fees and max transaction amount
589     mapping (address => bool) private _isExcludedFromFees;
590     mapping (address => bool) public _isExcludedMaxTransactionAmount;
591  
592     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
593     // could be subject to a maximum transfer amount
594     mapping (address => bool) public automatedMarketMakerPairs;
595  
596     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
597  
598     event ExcludeFromFees(address indexed account, bool isExcluded);
599  
600     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
601  
602     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
603  
604     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
605  
606     event SwapAndLiquify(
607         uint256 tokensSwapped,
608         uint256 ethReceived,
609         uint256 tokensIntoLiquidity
610     );
611  
612     event AutoNukeLP();
613  
614     event ManualNukeLP();
615  
616     constructor() ERC20("EIGHT", "8") {
617  
618         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
619  
620         excludeFromMaxTransaction(address(_uniswapV2Router), true);
621         uniswapV2Router = _uniswapV2Router;
622  
623         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
624         excludeFromMaxTransaction(address(uniswapV2Pair), true);
625         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
626  
627         uint256 _buyMarketingFee = 2;
628         uint256 _buyLiquidityFee = 3;
629         uint256 _buyDevFee = 1;
630  
631         uint256 _sellMarketingFee = 2;
632         uint256 _sellLiquidityFee = 3;
633         uint256 _sellDevFee = 1;
634  
635         uint256 _earlySellLiquidityFee = 4;
636         uint256 _earlySellMarketingFee = 3;
637  
638         uint256 totalSupply = 1 * 1e12 * 1e18;
639  
640         maxTransactionAmount = totalSupply * 3 / 1000; // 0.3% maxTransactionAmountTxn
641         maxWallet = totalSupply * 10 / 1000; // 1% maxWallet
642         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
643  
644         buyMarketingFee = _buyMarketingFee;
645         buyLiquidityFee = _buyLiquidityFee;
646         buyDevFee = _buyDevFee;
647         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
648  
649         sellMarketingFee = _sellMarketingFee;
650         sellLiquidityFee = _sellLiquidityFee;
651         sellDevFee = _sellDevFee;
652         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
653  
654         earlySellLiquidityFee = _earlySellLiquidityFee;
655         earlySellMarketingFee = _earlySellMarketingFee;
656  
657         marketingWallet = address(owner()); // set as marketing wallet
658         devWallet = address(owner()); // set as dev wallet
659  
660         // exclude from paying fees or having max transaction amount
661         excludeFromFees(owner(), true);
662         excludeFromFees(address(this), true);
663         excludeFromFees(address(0xdead), true);
664  
665         excludeFromMaxTransaction(owner(), true);
666         excludeFromMaxTransaction(address(this), true);
667         excludeFromMaxTransaction(address(0xdead), true);
668  
669         /*
670             _mint is an internal function in ERC20.sol that is only called here,
671             and CANNOT be called ever again
672         */
673         _mint(msg.sender, totalSupply);
674     }
675  
676     receive() external payable {
677  
678   	}
679  
680     // once enabled, can never be turned off
681     function enableTrading() external onlyOwner {
682         tradingActive = true;
683         swapEnabled = true;
684         lastLpBurnTime = block.timestamp;
685         launchedAt = block.number;
686     }
687  
688     // remove limits after token is stable
689     function removeLimits() external onlyOwner returns (bool){
690         limitsInEffect = false;
691         return true;
692     }
693  
694     // disable Transfer delay - cannot be reenabled
695     function disableTransferDelay() external onlyOwner returns (bool){
696         transferDelayEnabled = false;
697         return true;
698     }
699  
700     function setEarlySellTax(bool onoff) external onlyOwner  {
701         enableEarlySellTax = onoff;
702     }
703  
704      // change the minimum amount of tokens to sell from fees
705     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
706   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
707   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
708   	    swapTokensAtAmount = newAmount;
709   	    return true;
710   	}
711  
712     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
713         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
714         maxTransactionAmount = newNum * (10**18);
715     }
716  
717     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
718         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
719         maxWallet = newNum * (10**18);
720     }
721  
722     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
723         _isExcludedMaxTransactionAmount[updAds] = isEx;
724     }
725  
726     // only use to disable contract sales if absolutely necessary (emergency use only)
727     function updateSwapEnabled(bool enabled) external onlyOwner(){
728         swapEnabled = enabled;
729     }
730  
731     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
732         buyMarketingFee = _marketingFee;
733         buyLiquidityFee = _liquidityFee;
734         buyDevFee = _devFee;
735         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
736         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
737     }
738  
739     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee) external onlyOwner {
740         sellMarketingFee = _marketingFee;
741         sellLiquidityFee = _liquidityFee;
742         sellDevFee = _devFee;
743         earlySellLiquidityFee = _earlySellLiquidityFee;
744         earlySellMarketingFee = _earlySellMarketingFee;
745         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
746         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
747     }
748  
749     function excludeFromFees(address account, bool excluded) public onlyOwner {
750         _isExcludedFromFees[account] = excluded;
751         emit ExcludeFromFees(account, excluded);
752     }
753  
754     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
755         _blacklist[account] = isBlacklisted;
756     }
757  
758     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
759         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
760  
761         _setAutomatedMarketMakerPair(pair, value);
762     }
763  
764     function _setAutomatedMarketMakerPair(address pair, bool value) private {
765         automatedMarketMakerPairs[pair] = value;
766  
767         emit SetAutomatedMarketMakerPair(pair, value);
768     }
769  
770     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
771         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
772         marketingWallet = newMarketingWallet;
773     }
774  
775     function updateDevWallet(address newWallet) external onlyOwner {
776         emit devWalletUpdated(newWallet, devWallet);
777         devWallet = newWallet;
778     }
779  
780  
781     function isExcludedFromFees(address account) public view returns(bool) {
782         return _isExcludedFromFees[account];
783     }
784  
785     event BoughtEarly(address indexed sniper);
786  
787     function _transfer(
788         address from,
789         address to,
790         uint256 amount
791     ) internal override {
792         require(from != address(0), "ERC20: transfer from the zero address");
793         require(to != address(0), "ERC20: transfer to the zero address");
794         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
795          if(amount == 0) {
796             super._transfer(from, to, 0);
797             return;
798         }
799  
800         if(limitsInEffect){
801             if (
802                 from != owner() &&
803                 to != owner() &&
804                 to != address(0) &&
805                 to != address(0xdead) &&
806                 !swapping
807             ){
808                 if(!tradingActive){
809                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
810                 }
811  
812                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
813                 if (transferDelayEnabled){
814                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
815                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
816                         _holderLastTransferTimestamp[tx.origin] = block.number;
817                     }
818                 }
819  
820                 //when buy
821                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
822                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
823                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
824                 }
825  
826                 //when sell
827                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
828                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
829                 }
830                 else if(!_isExcludedMaxTransactionAmount[to]){
831                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
832                 }
833             }
834         }
835  
836         // anti bot logic
837         if (block.number <= (launchedAt + 2) && 
838                 to != uniswapV2Pair && 
839                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
840             ) {
841             _blacklist[to] = true;
842         }
843  
844         // early sell logic
845         bool isBuy = from == uniswapV2Pair;
846         if (!isBuy && enableEarlySellTax) {
847             if (_holderFirstBuyTimestamp[from] != 0 &&
848                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
849                 sellLiquidityFee = earlySellLiquidityFee;
850                 sellMarketingFee = earlySellMarketingFee;
851                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
852             } else {
853                 sellLiquidityFee = 4;
854                 sellMarketingFee = 3;
855                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
856             }
857         } else {
858             if (_holderFirstBuyTimestamp[to] == 0) {
859                 _holderFirstBuyTimestamp[to] = block.timestamp;
860             }
861  
862             if (!enableEarlySellTax) {
863                 sellLiquidityFee = 3;
864                 sellMarketingFee = 2;
865                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
866             }
867         }
868  
869 		uint256 contractTokenBalance = balanceOf(address(this));
870  
871         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
872  
873         if( 
874             canSwap &&
875             swapEnabled &&
876             !swapping &&
877             !automatedMarketMakerPairs[from] &&
878             !_isExcludedFromFees[from] &&
879             !_isExcludedFromFees[to]
880         ) {
881             swapping = true;
882  
883             swapBack();
884  
885             swapping = false;
886         }
887  
888         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
889             autoBurnLiquidityPairTokens();
890         }
891  
892         bool takeFee = !swapping;
893  
894         // if any account belongs to _isExcludedFromFee account then remove the fee
895         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
896             takeFee = false;
897         }
898  
899         uint256 fees = 0;
900         // only take fees on buys/sells, do not take on wallet transfers
901         if(takeFee){
902             // on sell
903             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
904                 fees = amount.mul(sellTotalFees).div(100);
905                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
906                 tokensForDev += fees * sellDevFee / sellTotalFees;
907                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
908             }
909             // on buy
910             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
911         	    fees = amount.mul(buyTotalFees).div(100);
912         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
913                 tokensForDev += fees * buyDevFee / buyTotalFees;
914                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
915             }
916  
917             if(fees > 0){    
918                 super._transfer(from, address(this), fees);
919             }
920  
921         	amount -= fees;
922         }
923  
924         super._transfer(from, to, amount);
925     }
926  
927     function swapTokensForEth(uint256 tokenAmount) private {
928  
929         // generate the uniswap pair path of token -> weth
930         address[] memory path = new address[](2);
931         path[0] = address(this);
932         path[1] = uniswapV2Router.WETH();
933  
934         _approve(address(this), address(uniswapV2Router), tokenAmount);
935  
936         // make the swap
937         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
938             tokenAmount,
939             0, // accept any amount of ETH
940             path,
941             address(this),
942             block.timestamp
943         );
944     }
945  
946     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
947         // approve token transfer to cover all possible scenarios
948         _approve(address(this), address(uniswapV2Router), tokenAmount);
949  
950         // add the liquidity
951         uniswapV2Router.addLiquidityETH{value: ethAmount}(
952             address(this),
953             tokenAmount,
954             0, // slippage is unavoidable
955             0, // slippage is unavoidable
956             deadAddress,
957             block.timestamp
958         );
959     }
960  
961     function swapBack() private {
962         uint256 contractBalance = balanceOf(address(this));
963         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
964         bool success;
965  
966         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
967  
968         if(contractBalance > swapTokensAtAmount * 20){
969           contractBalance = swapTokensAtAmount * 20;
970         }
971  
972         // Halve the amount of liquidity tokens
973         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
974         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
975  
976         uint256 initialETHBalance = address(this).balance;
977  
978         swapTokensForEth(amountToSwapForETH); 
979  
980         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
981  
982         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
983         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
984  
985         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
986  
987         tokensForLiquidity = 0;
988         tokensForMarketing = 0;
989         tokensForDev = 0;
990  
991         (success,) = address(devWallet).call{value: ethForDev}("");
992  
993         if(liquidityTokens > 0 && ethForLiquidity > 0){
994             addLiquidity(liquidityTokens, ethForLiquidity);
995             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
996         }
997  
998         (success,) = address(marketingWallet).call{value: address(this).balance}("");
999     }
1000  
1001     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1002         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1003         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1004         lpBurnFrequency = _frequencyInSeconds;
1005         percentForLPBurn = _percent;
1006         lpBurnEnabled = _Enabled;
1007     }
1008  
1009     function autoBurnLiquidityPairTokens() internal returns (bool){
1010  
1011         lastLpBurnTime = block.timestamp;
1012  
1013         // get balance of liquidity pair
1014         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1015  
1016         // calculate amount to burn
1017         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1018  
1019         // pull tokens from pancakePair liquidity and move to dead address permanently
1020         if (amountToBurn > 0){
1021             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1022         }
1023  
1024         //sync price since this is not in a swap transaction!
1025         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1026         pair.sync();
1027         emit AutoNukeLP();
1028         return true;
1029     }
1030  
1031     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1032         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1033         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1034         lastManualLpBurnTime = block.timestamp;
1035  
1036         // get balance of liquidity pair
1037         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1038  
1039         // calculate amount to burn
1040         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1041  
1042         // pull tokens from pancakePair liquidity and move to dead address permanently
1043         if (amountToBurn > 0){
1044             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1045         }
1046  
1047         //sync price since this is not in a swap transaction!
1048         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1049         pair.sync();
1050         emit ManualNukeLP();
1051         return true;
1052     }
1053 }