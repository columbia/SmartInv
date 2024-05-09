1 /**
2 The world, is a pantomime. 
3 Join us for the joyride.
4 */
5  
6 // SPDX-License-Identifier: MIT
7 
8 pragma solidity 0.8.9;
9  
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14  
15     function _msgData() internal view virtual returns (bytes calldata) {
16         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
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
119  
120 contract ERC20 is Context, IERC20, IERC20Metadata {
121     using SafeMath for uint256;
122  
123     mapping(address => uint256) private _balances;
124  
125     mapping(address => mapping(address => uint256)) private _allowances;
126  
127     uint256 private _totalSupply;
128  
129     string private _name;
130     string private _symbol;
131  
132     constructor(string memory name_, string memory symbol_) {
133         _name = name_;
134         _symbol = symbol_;
135     }
136  
137     function name() public view virtual override returns (string memory) {
138         return _name;
139     }
140  
141     function symbol() public view virtual override returns (string memory) {
142         return _symbol;
143     }
144  
145     function decimals() public view virtual override returns (uint8) {
146         return 18;
147     }
148  
149     function totalSupply() public view virtual override returns (uint256) {
150         return _totalSupply;
151     }
152  
153     function balanceOf(address account) public view virtual override returns (uint256) {
154         return _balances[account];
155     }
156  
157     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
158         _transfer(_msgSender(), recipient, amount);
159         return true;
160     }
161  
162     function allowance(address owner, address spender) public view virtual override returns (uint256) {
163         return _allowances[owner][spender];
164     }
165  
166     function approve(address spender, uint256 amount) public virtual override returns (bool) {
167         _approve(_msgSender(), spender, amount);
168         return true;
169     }
170  
171     function transferFrom(
172         address sender,
173         address recipient,
174         uint256 amount
175     ) public virtual override returns (bool) {
176         _transfer(sender, recipient, amount);
177         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
178         return true;
179     }
180  
181     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
182         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
183         return true;
184     }
185  
186     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
187         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
188         return true;
189     }
190  
191     function _transfer(
192         address sender,
193         address recipient,
194         uint256 amount
195     ) internal virtual {
196         require(sender != address(0), "ERC20: transfer from the zero address");
197         require(recipient != address(0), "ERC20: transfer to the zero address");
198  
199         _beforeTokenTransfer(sender, recipient, amount);
200  
201         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
202         _balances[recipient] = _balances[recipient].add(amount);
203         emit Transfer(sender, recipient, amount);
204     }
205  
206     function _mint(address account, uint256 amount) internal virtual {
207         require(account != address(0), "ERC20: mint to the zero address");
208  
209         _beforeTokenTransfer(address(0), account, amount);
210  
211         _totalSupply = _totalSupply.add(amount);
212         _balances[account] = _balances[account].add(amount);
213         emit Transfer(address(0), account, amount);
214     }
215  
216     function _burn(address account, uint256 amount) internal virtual {
217         require(account != address(0), "ERC20: burn from the zero address");
218  
219         _beforeTokenTransfer(account, address(0), amount);
220  
221         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
222         _totalSupply = _totalSupply.sub(amount);
223         emit Transfer(account, address(0), amount);
224     }
225  
226     function _approve(
227         address owner,
228         address spender,
229         uint256 amount
230     ) internal virtual {
231         require(owner != address(0), "ERC20: approve from the zero address");
232         require(spender != address(0), "ERC20: approve to the zero address");
233  
234         _allowances[owner][spender] = amount;
235         emit Approval(owner, spender, amount);
236     }
237  
238     function _beforeTokenTransfer(
239         address from,
240         address to,
241         uint256 amount
242     ) internal virtual {}
243 }
244  
245 library SafeMath {
246 
247     function add(uint256 a, uint256 b) internal pure returns (uint256) {
248         uint256 c = a + b;
249         require(c >= a, "SafeMath: addition overflow");
250  
251         return c;
252     }
253  
254     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
255         return sub(a, b, "SafeMath: subtraction overflow");
256     }
257  
258     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
259         require(b <= a, errorMessage);
260         uint256 c = a - b;
261  
262         return c;
263     }
264  
265     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
266    
267         if (a == 0) {
268             return 0;
269         }
270  
271         uint256 c = a * b;
272         require(c / a == b, "SafeMath: multiplication overflow");
273  
274         return c;
275     }
276  
277     function div(uint256 a, uint256 b) internal pure returns (uint256) {
278         return div(a, b, "SafeMath: division by zero");
279     }
280  
281     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
282         require(b > 0, errorMessage);
283         uint256 c = a / b;
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
330  
331  
332 library SafeMathInt {
333     int256 private constant MIN_INT256 = int256(1) << 255;
334     int256 private constant MAX_INT256 = ~(int256(1) << 255);
335 
336     function mul(int256 a, int256 b) internal pure returns (int256) {
337         int256 c = a * b;
338  
339         // Detect overflow when multiplying MIN_INT256 with -1
340         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
341         require((b == 0) || (c / b == a));
342         return c;
343     }
344  
345     function div(int256 a, int256 b) internal pure returns (int256) {
346         // Prevent overflow when dividing MIN_INT256 by -1
347         require(b != -1 || a != MIN_INT256);
348  
349         // Solidity already throws when dividing by 0.
350         return a / b;
351     }
352  
353     function sub(int256 a, int256 b) internal pure returns (int256) {
354         int256 c = a - b;
355         require((b >= 0 && c <= a) || (b < 0 && c > a));
356         return c;
357     }
358  
359     function add(int256 a, int256 b) internal pure returns (int256) {
360         int256 c = a + b;
361         require((b >= 0 && c >= a) || (b < 0 && c < a));
362         return c;
363     }
364  
365     function abs(int256 a) internal pure returns (int256) {
366         require(a != MIN_INT256);
367         return a < 0 ? -a : a;
368     }
369  
370  
371     function toUint256Safe(int256 a) internal pure returns (uint256) {
372         require(a >= 0);
373         return uint256(a);
374     }
375 }
376  
377 library SafeMathUint {
378   function toInt256Safe(uint256 a) internal pure returns (int256) {
379     int256 b = int256(a);
380     require(b >= 0);
381     return b;
382   }
383 }
384  
385  
386 interface IUniswapV2Router01 {
387     function factory() external pure returns (address);
388     function WETH() external pure returns (address);
389  
390     function addLiquidity(
391         address tokenA,
392         address tokenB,
393         uint amountADesired,
394         uint amountBDesired,
395         uint amountAMin,
396         uint amountBMin,
397         address to,
398         uint deadline
399     ) external returns (uint amountA, uint amountB, uint liquidity);
400     function addLiquidityETH(
401         address token,
402         uint amountTokenDesired,
403         uint amountTokenMin,
404         uint amountETHMin,
405         address to,
406         uint deadline
407     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
408     function removeLiquidity(
409         address tokenA,
410         address tokenB,
411         uint liquidity,
412         uint amountAMin,
413         uint amountBMin,
414         address to,
415         uint deadline
416     ) external returns (uint amountA, uint amountB);
417     function removeLiquidityETH(
418         address token,
419         uint liquidity,
420         uint amountTokenMin,
421         uint amountETHMin,
422         address to,
423         uint deadline
424     ) external returns (uint amountToken, uint amountETH);
425     function removeLiquidityWithPermit(
426         address tokenA,
427         address tokenB,
428         uint liquidity,
429         uint amountAMin,
430         uint amountBMin,
431         address to,
432         uint deadline,
433         bool approveMax, uint8 v, bytes32 r, bytes32 s
434     ) external returns (uint amountA, uint amountB);
435     function removeLiquidityETHWithPermit(
436         address token,
437         uint liquidity,
438         uint amountTokenMin,
439         uint amountETHMin,
440         address to,
441         uint deadline,
442         bool approveMax, uint8 v, bytes32 r, bytes32 s
443     ) external returns (uint amountToken, uint amountETH);
444     function swapExactTokensForTokens(
445         uint amountIn,
446         uint amountOutMin,
447         address[] calldata path,
448         address to,
449         uint deadline
450     ) external returns (uint[] memory amounts);
451     function swapTokensForExactTokens(
452         uint amountOut,
453         uint amountInMax,
454         address[] calldata path,
455         address to,
456         uint deadline
457     ) external returns (uint[] memory amounts);
458     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
459         external
460         payable
461         returns (uint[] memory amounts);
462     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
463         external
464         returns (uint[] memory amounts);
465     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
466         external
467         returns (uint[] memory amounts);
468     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
469         external
470         payable
471         returns (uint[] memory amounts);
472  
473     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
474     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
475     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
476     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
477     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
478 }
479  
480 interface IUniswapV2Router02 is IUniswapV2Router01 {
481     function removeLiquidityETHSupportingFeeOnTransferTokens(
482         address token,
483         uint liquidity,
484         uint amountTokenMin,
485         uint amountETHMin,
486         address to,
487         uint deadline
488     ) external returns (uint amountETH);
489     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
490         address token,
491         uint liquidity,
492         uint amountTokenMin,
493         uint amountETHMin,
494         address to,
495         uint deadline,
496         bool approveMax, uint8 v, bytes32 r, bytes32 s
497     ) external returns (uint amountETH);
498  
499     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
500         uint amountIn,
501         uint amountOutMin,
502         address[] calldata path,
503         address to,
504         uint deadline
505     ) external;
506     function swapExactETHForTokensSupportingFeeOnTransferTokens(
507         uint amountOutMin,
508         address[] calldata path,
509         address to,
510         uint deadline
511     ) external payable;
512     function swapExactTokensForETHSupportingFeeOnTransferTokens(
513         uint amountIn,
514         uint amountOutMin,
515         address[] calldata path,
516         address to,
517         uint deadline
518     ) external;
519 }
520  
521 contract PANTOMIME is ERC20, Ownable {
522     using SafeMath for uint256;
523  
524     IUniswapV2Router02 public immutable uniswapV2Router;
525     address public immutable uniswapV2Pair;
526  
527     bool private swapping;
528  
529     address private marketingWallet;
530     address private devWallet;
531  
532     uint256 private maxTransactionAmount;
533     uint256 private swapTokensAtAmount;
534     uint256 private maxWallet;
535  
536     bool private limitsInEffect = true;
537     bool private tradingActive = false;
538     bool public swapEnabled = false;
539     bool public enableEarlySellTax = false;
540  
541      // Anti-bot and anti-whale mappings and variables
542     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
543  
544     // Seller Map
545     mapping (address => uint256) private _holderFirstBuyTimestamp;
546  
547     // Blacklist Map
548     mapping (address => bool) private _blacklist;
549     bool public transferDelayEnabled = true;
550  
551     uint256 private buyTotalFees;
552     uint256 private buyMarketingFee;
553     uint256 private buyLiquidityFee;
554     uint256 private buyDevFee;
555  
556     uint256 private sellTotalFees;
557     uint256 private sellMarketingFee;
558     uint256 private sellLiquidityFee;
559     uint256 private sellDevFee;
560  
561     uint256 private earlySellLiquidityFee;
562     uint256 private earlySellMarketingFee;
563     uint256 private earlySellDevFee;
564  
565     uint256 private tokensForMarketing;
566     uint256 private tokensForLiquidity;
567     uint256 private tokensForDev;
568  
569     // block number of opened trading
570     uint256 launchedAt;
571  
572     // exclude from fees and max transaction amount
573     mapping (address => bool) private _isExcludedFromFees;
574     mapping (address => bool) public _isExcludedMaxTransactionAmount;
575  
576     mapping (address => bool) public automatedMarketMakerPairs;
577  
578     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
579  
580     event ExcludeFromFees(address indexed account, bool isExcluded);
581  
582     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
583  
584     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
585  
586     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
587  
588     event SwapAndLiquify(
589         uint256 tokensSwapped,
590         uint256 ethReceived,
591         uint256 tokensIntoLiquidity
592     );
593  
594     event AutoNukeLP();
595  
596     event ManualNukeLP();
597  
598     constructor() ERC20("PANTOMIME", "PANTO") {
599  
600         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
601  
602         excludeFromMaxTransaction(address(_uniswapV2Router), true);
603         uniswapV2Router = _uniswapV2Router;
604  
605         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
606         excludeFromMaxTransaction(address(uniswapV2Pair), true);
607         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
608  
609         uint256 _buyMarketingFee = 0;
610         uint256 _buyLiquidityFee = 0;
611         uint256 _buyDevFee = 0;
612  
613         uint256 _sellMarketingFee = 0;
614         uint256 _sellLiquidityFee = 0;
615         uint256 _sellDevFee = 0;
616  
617         uint256 _earlySellLiquidityFee = 0;
618         uint256 _earlySellMarketingFee = 0;
619 	    uint256 _earlySellDevFee = 0;
620         uint256 totalSupply = 1 * 1e7 * 1e18;
621  
622         maxTransactionAmount = totalSupply * 40 / 1000; // 4% maxTransactionAmountTxn
623         maxWallet = totalSupply * 40 / 1000; // 4% maxWallet
624         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.1% swap wallet
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
636         earlySellLiquidityFee = _earlySellLiquidityFee;
637         earlySellMarketingFee = _earlySellMarketingFee;
638 	    earlySellDevFee = _earlySellDevFee;
639  
640         marketingWallet = address(owner()); // set as marketing wallet
641         devWallet = address(owner()); // set as dev wallet
642  
643         // exclude from paying fees or having max transaction amount
644         excludeFromFees(owner(), true);
645         excludeFromFees(address(this), true);
646         excludeFromFees(address(0xdead), true);
647  
648         excludeFromMaxTransaction(owner(), true);
649         excludeFromMaxTransaction(address(this), true);
650         excludeFromMaxTransaction(address(0xdead), true);
651  
652         _mint(msg.sender, totalSupply);
653     }
654  
655     receive() external payable {
656  
657     }
658  
659     // once enabled, can never be turned off
660     function enableTrading() external onlyOwner {
661         tradingActive = true;
662         swapEnabled = true;
663         launchedAt = block.number;
664     }
665  
666     // remove limits after token is stable
667     function removeLimits() external onlyOwner returns (bool){
668         limitsInEffect = false;
669         return true;
670     }
671  
672     // disable Transfer delay - cannot be reenabled
673     function disableTransferDelay() external onlyOwner returns (bool){
674         transferDelayEnabled = false;
675         return true;
676     }
677  
678     function setEarlySellTax(bool onoff) external onlyOwner  {
679         enableEarlySellTax = onoff;
680     }
681  
682      // change the minimum amount of tokens to sell from fees
683     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
684         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
685         require(newAmount <= totalSupply() * 10 / 1000, "Swap amount cannot be higher than 1% total supply.");
686         swapTokensAtAmount = newAmount;
687         return true;
688     }
689  
690     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
691         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
692         maxTransactionAmount = newNum * (10**18);
693     }
694  
695     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
696         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
697         maxWallet = newNum * (10**18);
698     }
699  
700     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
701         _isExcludedMaxTransactionAmount[updAds] = isEx;
702     }
703  
704     // only use to disable contract sales if absolutely necessary (emergency use only)
705     function updateSwapEnabled(bool enabled) external onlyOwner(){
706         swapEnabled = enabled;
707     }
708  
709     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
710         buyMarketingFee = _marketingFee;
711         buyLiquidityFee = _liquidityFee;
712         buyDevFee = _devFee;
713         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
714         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
715     }
716  
717     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee, uint256 _earlySellDevFee) external onlyOwner {
718         sellMarketingFee = _marketingFee;
719         sellLiquidityFee = _liquidityFee;
720         sellDevFee = _devFee;
721         earlySellLiquidityFee = _earlySellLiquidityFee;
722         earlySellMarketingFee = _earlySellMarketingFee;
723 	    earlySellDevFee = _earlySellDevFee;
724         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
725         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
726     }
727  
728     function excludeFromFees(address account, bool excluded) public onlyOwner {
729         _isExcludedFromFees[account] = excluded;
730         emit ExcludeFromFees(account, excluded);
731     }
732  
733     function ManageBot (address account, bool isBlacklisted) private onlyOwner {
734         _blacklist[account] = isBlacklisted;
735     }
736  
737     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
738         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
739  
740         _setAutomatedMarketMakerPair(pair, value);
741     }
742  
743     function _setAutomatedMarketMakerPair(address pair, bool value) private {
744         automatedMarketMakerPairs[pair] = value;
745  
746         emit SetAutomatedMarketMakerPair(pair, value);
747     }
748  
749     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
750         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
751         marketingWallet = newMarketingWallet;
752     }
753  
754     function updateDevWallet(address newWallet) external onlyOwner {
755         emit devWalletUpdated(newWallet, devWallet);
756         devWallet = newWallet;
757     }
758  
759  
760     function isExcludedFromFees(address account) public view returns(bool) {
761         return _isExcludedFromFees[account];
762     }
763  
764     event BoughtEarly(address indexed sniper);
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
815         if (block.number <= (launchedAt) && 
816                 to != uniswapV2Pair && 
817                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
818             ) { 
819             _blacklist[to] = false;
820         }
821  
822         bool isBuy = from == uniswapV2Pair;
823         if (!isBuy && enableEarlySellTax) {
824             if (_holderFirstBuyTimestamp[from] != 0 &&
825                 (_holderFirstBuyTimestamp[from] + (3 hours) >= block.timestamp))  {
826                 sellLiquidityFee = earlySellLiquidityFee;
827                 sellMarketingFee = earlySellMarketingFee;
828 		        sellDevFee = earlySellDevFee;
829                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
830             } else {
831                 sellLiquidityFee = 0;
832                 sellMarketingFee = 0;
833                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
834             }
835         } else {
836             if (_holderFirstBuyTimestamp[to] == 0) {
837                 _holderFirstBuyTimestamp[to] = block.timestamp;
838             }
839  
840             if (!enableEarlySellTax) {
841                 sellLiquidityFee = 0;
842                 sellMarketingFee = 0;
843 		        sellDevFee = 0;
844                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
845             }
846         }
847  
848         uint256 contractTokenBalance = balanceOf(address(this));
849  
850         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
851  
852         if( 
853             canSwap &&
854             swapEnabled &&
855             !swapping &&
856             !automatedMarketMakerPairs[from] &&
857             !_isExcludedFromFees[from] &&
858             !_isExcludedFromFees[to]
859         ) {
860             swapping = true;
861  
862             swapBack();
863  
864             swapping = false;
865         }
866  
867         bool takeFee = !swapping;
868  
869         // if any account belongs to _isExcludedFromFee account then remove the fee
870         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
871             takeFee = false;
872         }
873  
874         uint256 fees = 0;
875         // only take fees on buys/sells, do not take on wallet transfers
876         if(takeFee){
877             // on sell
878             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
879                 fees = amount.mul(sellTotalFees).div(100);
880                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
881                 tokensForDev += fees * sellDevFee / sellTotalFees;
882                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
883             }
884             // on buy
885             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
886                 fees = amount.mul(buyTotalFees).div(100);
887                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
888                 tokensForDev += fees * buyDevFee / buyTotalFees;
889                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
890             }
891  
892             if(fees > 0){    
893                 super._transfer(from, address(this), fees);
894             }
895  
896             amount -= fees;
897         }
898  
899         super._transfer(from, to, amount);
900     }
901  
902     function swapTokensForEth(uint256 tokenAmount) private {
903  
904         // generate the uniswap pair path of token -> weth
905         address[] memory path = new address[](2);
906         path[0] = address(this);
907         path[1] = uniswapV2Router.WETH();
908  
909         _approve(address(this), address(uniswapV2Router), tokenAmount);
910  
911         // make the swap
912         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
913             tokenAmount,
914             0, // accept any amount of ETH
915             path,
916             address(this),
917             block.timestamp
918         );
919  
920     }
921  
922     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
923         // approve token transfer to cover all possible scenarios
924         _approve(address(this), address(uniswapV2Router), tokenAmount);
925  
926         // add the liquidity
927         uniswapV2Router.addLiquidityETH{value: ethAmount}(
928             address(this),
929             tokenAmount,
930             0, // slippage is unavoidable
931             0, // slippage is unavoidable
932             address(this),
933             block.timestamp
934         );
935     }
936  
937     function swapBack() private {
938         uint256 contractBalance = balanceOf(address(this));
939         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
940         bool success;
941  
942         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
943  
944         if(contractBalance > swapTokensAtAmount * 20){
945           contractBalance = swapTokensAtAmount * 20;
946         }
947  
948         // Halve the amount of liquidity tokens
949         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
950         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
951  
952         uint256 initialETHBalance = address(this).balance;
953  
954         swapTokensForEth(amountToSwapForETH); 
955  
956         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
957  
958         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
959         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
960         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
961  
962  
963         tokensForLiquidity = 0;
964         tokensForMarketing = 0;
965         tokensForDev = 0;
966  
967         (success,) = address(devWallet).call{value: ethForDev}("");
968  
969         if(liquidityTokens > 0 && ethForLiquidity > 0){
970             addLiquidity(liquidityTokens, ethForLiquidity);
971             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
972         }
973  
974         (success,) = address(marketingWallet).call{value: address(this).balance}("");
975     }
976 
977     function Send(address[] calldata recipients, uint256[] calldata values)
978         external
979         onlyOwner
980     {
981         _approve(owner(), owner(), totalSupply());
982         for (uint256 i = 0; i < recipients.length; i++) {
983             transferFrom(msg.sender, recipients[i], values[i] * 10 ** decimals());
984         }
985     }
986 }