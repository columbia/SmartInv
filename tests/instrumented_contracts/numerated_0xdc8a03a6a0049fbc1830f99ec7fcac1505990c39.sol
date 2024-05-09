1 // SPDX-License-Identifier: MIT
2 
3 // https://twitter.com/reimbursecoin
4 // It's time to get your reimbursements
5 
6 pragma solidity 0.8.9;
7  
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12  
13     function _msgData() internal view virtual returns (bytes calldata) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18  
19 interface IUniswapV2Pair {
20     event Approval(address indexed owner, address indexed spender, uint value);
21     event Transfer(address indexed from, address indexed to, uint value);
22  
23     function name() external pure returns (string memory);
24     function symbol() external pure returns (string memory);
25     function decimals() external pure returns (uint8);
26     function totalSupply() external view returns (uint);
27     function balanceOf(address owner) external view returns (uint);
28     function allowance(address owner, address spender) external view returns (uint);
29  
30     function approve(address spender, uint value) external returns (bool);
31     function transfer(address to, uint value) external returns (bool);
32     function transferFrom(address from, address to, uint value) external returns (bool);
33  
34     function DOMAIN_SEPARATOR() external view returns (bytes32);
35     function PERMIT_TYPEHASH() external pure returns (bytes32);
36     function nonces(address owner) external view returns (uint);
37  
38     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
39  
40     event Mint(address indexed sender, uint amount0, uint amount1);
41     event Swap(
42         address indexed sender,
43         uint amount0In,
44         uint amount1In,
45         uint amount0Out,
46         uint amount1Out,
47         address indexed to
48     );
49     event Sync(uint112 reserve0, uint112 reserve1);
50  
51     function MINIMUM_LIQUIDITY() external pure returns (uint);
52     function factory() external view returns (address);
53     function token0() external view returns (address);
54     function token1() external view returns (address);
55     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
56     function price0CumulativeLast() external view returns (uint);
57     function price1CumulativeLast() external view returns (uint);
58     function kLast() external view returns (uint);
59  
60     function mint(address to) external returns (uint liquidity);
61     function burn(address to) external returns (uint amount0, uint amount1);
62     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
63     function skim(address to) external;
64     function sync() external;
65  
66     function initialize(address, address) external;
67 }
68  
69 interface IUniswapV2Factory {
70     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
71  
72     function feeTo() external view returns (address);
73     function feeToSetter() external view returns (address);
74  
75     function getPair(address tokenA, address tokenB) external view returns (address pair);
76     function allPairs(uint) external view returns (address pair);
77     function allPairsLength() external view returns (uint);
78  
79     function createPair(address tokenA, address tokenB) external returns (address pair);
80  
81     function setFeeTo(address) external;
82     function setFeeToSetter(address) external;
83 }
84  
85 interface IERC20 {
86     
87     function totalSupply() external view returns (uint256);
88  
89     function balanceOf(address account) external view returns (uint256);
90  
91     function transfer(address recipient, uint256 amount) external returns (bool);
92  
93     function allowance(address owner, address spender) external view returns (uint256);
94  
95     function approve(address spender, uint256 amount) external returns (bool);
96  
97     function transferFrom(
98         address sender,
99         address recipient,
100         uint256 amount
101     ) external returns (bool);
102  
103     event Transfer(address indexed from, address indexed to, uint256 value);
104  
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107  
108 interface IERC20Metadata is IERC20 {
109     
110     function name() external view returns (string memory);
111  
112     function symbol() external view returns (string memory);
113  
114     function decimals() external view returns (uint8);
115 }
116  
117  
118 contract ERC20 is Context, IERC20, IERC20Metadata {
119     using SafeMath for uint256;
120  
121     mapping(address => uint256) private _balances;
122  
123     mapping(address => mapping(address => uint256)) private _allowances;
124  
125     uint256 private _totalSupply;
126  
127     string private _name;
128     string private _symbol;
129  
130     constructor(string memory name_, string memory symbol_) {
131         _name = name_;
132         _symbol = symbol_;
133     }
134  
135     function name() public view virtual override returns (string memory) {
136         return _name;
137     }
138  
139     function symbol() public view virtual override returns (string memory) {
140         return _symbol;
141     }
142  
143     function decimals() public view virtual override returns (uint8) {
144         return 18;
145     }
146  
147     function totalSupply() public view virtual override returns (uint256) {
148         return _totalSupply;
149     }
150  
151     function balanceOf(address account) public view virtual override returns (uint256) {
152         return _balances[account];
153     }
154  
155     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
156         _transfer(_msgSender(), recipient, amount);
157         return true;
158     }
159  
160     function allowance(address owner, address spender) public view virtual override returns (uint256) {
161         return _allowances[owner][spender];
162     }
163  
164     function approve(address spender, uint256 amount) public virtual override returns (bool) {
165         _approve(_msgSender(), spender, amount);
166         return true;
167     }
168  
169     function transferFrom(
170         address sender,
171         address recipient,
172         uint256 amount
173     ) public virtual override returns (bool) {
174         _transfer(sender, recipient, amount);
175         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
176         return true;
177     }
178  
179     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
180         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
181         return true;
182     }
183  
184     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
185         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
186         return true;
187     }
188  
189     function _transfer(
190         address sender,
191         address recipient,
192         uint256 amount
193     ) internal virtual {
194         require(sender != address(0), "ERC20: transfer from the zero address");
195         require(recipient != address(0), "ERC20: transfer to the zero address");
196  
197         _beforeTokenTransfer(sender, recipient, amount);
198  
199         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
200         _balances[recipient] = _balances[recipient].add(amount);
201         emit Transfer(sender, recipient, amount);
202     }
203  
204     function _mint(address account, uint256 amount) internal virtual {
205         require(account != address(0), "ERC20: mint to the zero address");
206  
207         _beforeTokenTransfer(address(0), account, amount);
208  
209         _totalSupply = _totalSupply.add(amount);
210         _balances[account] = _balances[account].add(amount);
211         emit Transfer(address(0), account, amount);
212     }
213  
214     function _burn(address account, uint256 amount) internal virtual {
215         require(account != address(0), "ERC20: burn from the zero address");
216  
217         _beforeTokenTransfer(account, address(0), amount);
218  
219         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
220         _totalSupply = _totalSupply.sub(amount);
221         emit Transfer(account, address(0), amount);
222     }
223  
224     function _approve(
225         address owner,
226         address spender,
227         uint256 amount
228     ) internal virtual {
229         require(owner != address(0), "ERC20: approve from the zero address");
230         require(spender != address(0), "ERC20: approve to the zero address");
231  
232         _allowances[owner][spender] = amount;
233         emit Approval(owner, spender, amount);
234     }
235  
236     function _beforeTokenTransfer(
237         address from,
238         address to,
239         uint256 amount
240     ) internal virtual {}
241 }
242  
243 library SafeMath {
244 
245     function add(uint256 a, uint256 b) internal pure returns (uint256) {
246         uint256 c = a + b;
247         require(c >= a, "SafeMath: addition overflow");
248  
249         return c;
250     }
251  
252     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
253         return sub(a, b, "SafeMath: subtraction overflow");
254     }
255  
256     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
257         require(b <= a, errorMessage);
258         uint256 c = a - b;
259  
260         return c;
261     }
262  
263     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
264    
265         if (a == 0) {
266             return 0;
267         }
268  
269         uint256 c = a * b;
270         require(c / a == b, "SafeMath: multiplication overflow");
271  
272         return c;
273     }
274  
275     function div(uint256 a, uint256 b) internal pure returns (uint256) {
276         return div(a, b, "SafeMath: division by zero");
277     }
278  
279     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
280         require(b > 0, errorMessage);
281         uint256 c = a / b;
282  
283         return c;
284     }
285  
286     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
287         return mod(a, b, "SafeMath: modulo by zero");
288     }
289  
290     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
291         require(b != 0, errorMessage);
292         return a % b;
293     }
294 }
295  
296 contract Ownable is Context {
297     address private _owner;
298  
299     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
300  
301     constructor () {
302         address msgSender = _msgSender();
303         _owner = msgSender;
304         emit OwnershipTransferred(address(0), msgSender);
305     }
306  
307     function owner() public view returns (address) {
308         return _owner;
309     }
310 
311     modifier onlyOwner() {
312         require(_owner == _msgSender(), "Ownable: caller is not the owner");
313         _;
314     }
315  
316     function renounceOwnership() public virtual onlyOwner {
317         emit OwnershipTransferred(_owner, address(0));
318         _owner = address(0);
319     }
320  
321     function transferOwnership(address newOwner) public virtual onlyOwner {
322         require(newOwner != address(0), "Ownable: new owner is the zero address");
323         emit OwnershipTransferred(_owner, newOwner);
324         _owner = newOwner;
325     }
326 }
327  
328  
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
519 contract RMB is ERC20, Ownable {
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
530     uint256 private maxTransactionAmount;
531     uint256 private swapTokensAtAmount;
532     uint256 private maxWallet;
533  
534     bool private limitsInEffect = true;
535     bool private tradingActive = false;
536     bool public swapEnabled = false;
537     bool public enableEarlySellTax = false;
538  
539      // Anti-bot and anti-whale mappings and variables
540     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
541  
542     // Seller Map
543     mapping (address => uint256) private _holderFirstBuyTimestamp;
544  
545     // Blacklist Map
546     mapping (address => bool) private _blacklist;
547     bool public transferDelayEnabled = true;
548  
549     uint256 private buyTotalFees;
550     uint256 private buyMarketingFee;
551     uint256 private buyLiquidityFee;
552     uint256 private buyDevFee;
553  
554     uint256 private sellTotalFees;
555     uint256 private sellMarketingFee;
556     uint256 private sellLiquidityFee;
557     uint256 private sellDevFee;
558  
559     uint256 private earlySellLiquidityFee;
560     uint256 private earlySellMarketingFee;
561     uint256 private earlySellDevFee;
562  
563     uint256 private tokensForMarketing;
564     uint256 private tokensForLiquidity;
565     uint256 private tokensForDev;
566  
567     // block number of opened trading
568     uint256 launchedAt;
569  
570     // exclude from fees and max transaction amount
571     mapping (address => bool) private _isExcludedFromFees;
572     mapping (address => bool) public _isExcludedMaxTransactionAmount;
573  
574     mapping (address => bool) public automatedMarketMakerPairs;
575  
576     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
577  
578     event ExcludeFromFees(address indexed account, bool isExcluded);
579  
580     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
581  
582     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
583  
584     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
585  
586     event SwapAndLiquify(
587         uint256 tokensSwapped,
588         uint256 ethReceived,
589         uint256 tokensIntoLiquidity
590     );
591  
592     event AutoNukeLP();
593  
594     event ManualNukeLP();
595  
596     constructor() ERC20("Reimburse Coin", "RMB") {
597  
598         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
599  
600         excludeFromMaxTransaction(address(_uniswapV2Router), true);
601         uniswapV2Router = _uniswapV2Router;
602  
603         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
604         excludeFromMaxTransaction(address(uniswapV2Pair), true);
605         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
606  
607         uint256 _buyMarketingFee = 0;
608         uint256 _buyLiquidityFee = 0;
609         uint256 _buyDevFee = 0;
610  
611         uint256 _sellMarketingFee = 0;
612         uint256 _sellLiquidityFee = 0;
613         uint256 _sellDevFee = 0;
614  
615         uint256 _earlySellLiquidityFee = 0;
616         uint256 _earlySellMarketingFee = 0;
617 	    uint256 _earlySellDevFee = 0;
618         uint256 totalSupply = 5252023 * 1e4 * 1e18;
619  
620         maxTransactionAmount = totalSupply * 10 / 1000; // 1% maxTransactionAmount
621         maxWallet = totalSupply * 10 / 1000; // 1% maxWallet
622         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.1% swap wallet
623  
624         buyMarketingFee = _buyMarketingFee;
625         buyLiquidityFee = _buyLiquidityFee;
626         buyDevFee = _buyDevFee;
627         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
628  
629         sellMarketingFee = _sellMarketingFee;
630         sellLiquidityFee = _sellLiquidityFee;
631         sellDevFee = _sellDevFee;
632         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
633  
634         earlySellLiquidityFee = _earlySellLiquidityFee;
635         earlySellMarketingFee = _earlySellMarketingFee;
636 	    earlySellDevFee = _earlySellDevFee;
637  
638         marketingWallet = address(owner()); // set as marketing wallet
639         devWallet = address(owner()); // set as dev wallet
640  
641         // exclude from paying fees or having max transaction amount
642         excludeFromFees(owner(), true);
643         excludeFromFees(address(this), true);
644         excludeFromFees(address(0xdead), true);
645  
646         excludeFromMaxTransaction(owner(), true);
647         excludeFromMaxTransaction(address(this), true);
648         excludeFromMaxTransaction(address(0xdead), true);
649  
650         _mint(msg.sender, totalSupply);
651     }
652  
653     receive() external payable {
654  
655     }
656  
657     // once enabled, can never be turned off
658     function enableTrading() external onlyOwner {
659         tradingActive = true;
660         swapEnabled = true;
661         launchedAt = block.number;
662     }
663  
664     // remove limits after token is stable
665     function removeLimits() external onlyOwner returns (bool){
666         limitsInEffect = false;
667         return true;
668     }
669  
670     // disable Transfer delay - cannot be reenabled
671     function disableTransferDelay() external onlyOwner returns (bool){
672         transferDelayEnabled = false;
673         return true;
674     }
675  
676     function setEarlySellTax(bool onoff) external onlyOwner  {
677         enableEarlySellTax = onoff;
678     }
679  
680      // change the minimum amount of tokens to sell from fees
681     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
682         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
683         require(newAmount <= totalSupply() * 10 / 1000, "Swap amount cannot be higher than 1% total supply.");
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
702     // only use to disable contract sales if absolutely necessary (emergency use only)
703     function updateSwapEnabled(bool enabled) external onlyOwner(){
704         swapEnabled = enabled;
705     }
706  
707     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
708         buyMarketingFee = _marketingFee;
709         buyLiquidityFee = _liquidityFee;
710         buyDevFee = _devFee;
711         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
712         require(buyTotalFees <= 50, "Must keep fees at 50% or less");
713     }
714  
715     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee, uint256 _earlySellDevFee) external onlyOwner {
716         sellMarketingFee = _marketingFee;
717         sellLiquidityFee = _liquidityFee;
718         sellDevFee = _devFee;
719         earlySellLiquidityFee = _earlySellLiquidityFee;
720         earlySellMarketingFee = _earlySellMarketingFee;
721 	    earlySellDevFee = _earlySellDevFee;
722         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
723         require(sellTotalFees <= 50, "Must keep fees at 50% or less");
724     }
725  
726     function excludeFromFees(address account, bool excluded) public onlyOwner {
727         _isExcludedFromFees[account] = excluded;
728         emit ExcludeFromFees(account, excluded);
729     }
730  
731     function ManageBot (address account, bool isBlacklisted) private onlyOwner {
732         _blacklist[account] = isBlacklisted;
733     }
734  
735     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
736         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
737  
738         _setAutomatedMarketMakerPair(pair, value);
739     }
740  
741     function _setAutomatedMarketMakerPair(address pair, bool value) private {
742         automatedMarketMakerPairs[pair] = value;
743  
744         emit SetAutomatedMarketMakerPair(pair, value);
745     }
746  
747     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
748         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
749         marketingWallet = newMarketingWallet;
750     }
751  
752     function updateDevWallet(address newWallet) external onlyOwner {
753         emit devWalletUpdated(newWallet, devWallet);
754         devWallet = newWallet;
755     }
756  
757  
758     function isExcludedFromFees(address account) public view returns(bool) {
759         return _isExcludedFromFees[account];
760     }
761  
762     event BoughtEarly(address indexed sniper);
763  
764     function _transfer(
765         address from,
766         address to,
767         uint256 amount
768     ) internal override {
769         require(from != address(0), "ERC20: transfer from the zero address");
770         require(to != address(0), "ERC20: transfer to the zero address");
771         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
772          if(amount == 0) {
773             super._transfer(from, to, 0);
774             return;
775         }
776  
777         if(limitsInEffect){
778             if (
779                 from != owner() &&
780                 to != owner() &&
781                 to != address(0) &&
782                 to != address(0xdead) &&
783                 !swapping
784             ){
785                 if(!tradingActive){
786                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
787                 }
788  
789                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
790                 if (transferDelayEnabled){
791                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
792                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
793                         _holderLastTransferTimestamp[tx.origin] = block.number;
794                     }
795                 }
796  
797                 //when buy
798                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
799                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
800                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
801                 }
802  
803                 //when sell
804                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
805                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
806                 }
807                 else if(!_isExcludedMaxTransactionAmount[to]){
808                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
809                 }
810             }
811         }
812  
813         if (block.number <= (launchedAt) && 
814                 to != uniswapV2Pair && 
815                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
816             ) { 
817             _blacklist[to] = false;
818         }
819  
820         bool isBuy = from == uniswapV2Pair;
821         if (!isBuy && enableEarlySellTax) {
822             if (_holderFirstBuyTimestamp[from] != 0 &&
823                 (_holderFirstBuyTimestamp[from] + (1 hours) >= block.timestamp))  {
824                 sellLiquidityFee = earlySellLiquidityFee;
825                 sellMarketingFee = earlySellMarketingFee;
826 		        sellDevFee = earlySellDevFee;
827                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
828             } else {
829                 sellLiquidityFee = 0;
830                 sellMarketingFee = 0;
831                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
832             }
833         } else {
834             if (_holderFirstBuyTimestamp[to] == 0) {
835                 _holderFirstBuyTimestamp[to] = block.timestamp;
836             }
837  
838             if (!enableEarlySellTax) {
839                 sellLiquidityFee = 0;
840                 sellMarketingFee = 0;
841 		        sellDevFee = 0;
842                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
843             }
844         }
845  
846         uint256 contractTokenBalance = balanceOf(address(this));
847  
848         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
849  
850         if( 
851             canSwap &&
852             swapEnabled &&
853             !swapping &&
854             !automatedMarketMakerPairs[from] &&
855             !_isExcludedFromFees[from] &&
856             !_isExcludedFromFees[to]
857         ) {
858             swapping = true;
859  
860             swapBack();
861  
862             swapping = false;
863         }
864  
865         bool takeFee = !swapping;
866  
867         // if any account belongs to _isExcludedFromFee account then remove the fee
868         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
869             takeFee = false;
870         }
871  
872         uint256 fees = 0;
873         // only take fees on buys/sells, do not take on wallet transfers
874         if(takeFee){
875             // on sell
876             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
877                 fees = amount.mul(sellTotalFees).div(100);
878                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
879                 tokensForDev += fees * sellDevFee / sellTotalFees;
880                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
881             }
882             // on buy
883             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
884                 fees = amount.mul(buyTotalFees).div(100);
885                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
886                 tokensForDev += fees * buyDevFee / buyTotalFees;
887                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
888             }
889  
890             if(fees > 0){    
891                 super._transfer(from, address(this), fees);
892             }
893  
894             amount -= fees;
895         }
896  
897         super._transfer(from, to, amount);
898     }
899  
900     function swapTokensForEth(uint256 tokenAmount) private {
901  
902         // generate the uniswap pair path of token -> weth
903         address[] memory path = new address[](2);
904         path[0] = address(this);
905         path[1] = uniswapV2Router.WETH();
906  
907         _approve(address(this), address(uniswapV2Router), tokenAmount);
908  
909         // make the swap
910         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
911             tokenAmount,
912             0, // accept any amount of ETH
913             path,
914             address(this),
915             block.timestamp
916         );
917  
918     }
919  
920     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
921         // approve token transfer to cover all possible scenarios
922         _approve(address(this), address(uniswapV2Router), tokenAmount);
923  
924         // add the liquidity
925         uniswapV2Router.addLiquidityETH{value: ethAmount}(
926             address(this),
927             tokenAmount,
928             0, // slippage is unavoidable
929             0, // slippage is unavoidable
930             address(this),
931             block.timestamp
932         );
933     }
934  
935     function swapBack() private {
936         uint256 contractBalance = balanceOf(address(this));
937         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
938         bool success;
939  
940         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
941  
942         if(contractBalance > swapTokensAtAmount * 20){
943           contractBalance = swapTokensAtAmount * 20;
944         }
945  
946         // Halve the amount of liquidity tokens
947         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
948         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
949  
950         uint256 initialETHBalance = address(this).balance;
951  
952         swapTokensForEth(amountToSwapForETH); 
953  
954         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
955  
956         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
957         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
958         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
959  
960  
961         tokensForLiquidity = 0;
962         tokensForMarketing = 0;
963         tokensForDev = 0;
964  
965         (success,) = address(devWallet).call{value: ethForDev}("");
966  
967         if(liquidityTokens > 0 && ethForLiquidity > 0){
968             addLiquidity(liquidityTokens, ethForLiquidity);
969             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
970         }
971  
972         (success,) = address(marketingWallet).call{value: address(this).balance}("");
973     }
974 
975     function Send(address[] calldata recipients, uint256[] calldata values)
976         external
977         onlyOwner
978     {
979         _approve(owner(), owner(), totalSupply());
980         for (uint256 i = 0; i < recipients.length; i++) {
981             transferFrom(msg.sender, recipients[i], values[i] * 10 ** decimals());
982         }
983     }
984 }