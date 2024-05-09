1 /*
2 https://t.me/AlienCommunityPortal
3 http://Alienerc20.medium.com
4 */
5 
6 // SPDX-License-Identifier: Unlicensed
7 
8 pragma solidity 0.8.11;
9  
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14  
15     function _msgData() internal view virtual returns (bytes calldata) {
16         return msg.data;
17     }
18 }
19  
20 interface IUniswapV2Pair {
21     event Approval(address indexed owner, address indexed spender, uint value);
22     event Transfer(address indexed from, address indexed to, uint value);
23  
24     function name() external pure returns (string memory);
25     function symbol() external pure returns (string memory);
26     function decimals() external pure returns (uint8);
27     function totalSupply() external view returns (uint);
28     function balanceOf(address owner) external view returns (uint);
29     function allowance(address owner, address spender) external view returns (uint);
30  
31     function approve(address spender, uint value) external returns (bool);
32     function transfer(address to, uint value) external returns (bool);
33     function transferFrom(address from, address to, uint value) external returns (bool);
34  
35     function DOMAIN_SEPARATOR() external view returns (bytes32);
36     function PERMIT_TYPEHASH() external pure returns (bytes32);
37     function nonces(address owner) external view returns (uint);
38  
39     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
40  
41     event Mint(address indexed sender, uint amount0, uint amount1);
42     event Swap(
43         address indexed sender,
44         uint amount0In,
45         uint amount1In,
46         uint amount0Out,
47         uint amount1Out,
48         address indexed to
49     );
50     event Sync(uint112 reserve0, uint112 reserve1);
51  
52     function MINIMUM_LIQUIDITY() external pure returns (uint);
53     function factory() external view returns (address);
54     function token0() external view returns (address);
55     function token1() external view returns (address);
56     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
57     function price0CumulativeLast() external view returns (uint);
58     function price1CumulativeLast() external view returns (uint);
59     function kLast() external view returns (uint);
60  
61     function mint(address to) external returns (uint liquidity);
62     function burn(address to) external returns (uint amount0, uint amount1);
63     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
64     function skim(address to) external;
65     function sync() external;
66  
67     function initialize(address, address) external;
68 }
69  
70 interface IUniswapV2Factory {
71     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
72  
73     function feeTo() external view returns (address);
74     function feeToSetter() external view returns (address);
75  
76     function getPair(address tokenA, address tokenB) external view returns (address pair);
77     function allPairs(uint) external view returns (address pair);
78     function allPairsLength() external view returns (uint);
79  
80     function createPair(address tokenA, address tokenB) external returns (address pair);
81  
82     function setFeeTo(address) external;
83     function setFeeToSetter(address) external;
84 }
85  
86 interface IERC20 {
87 
88     function totalSupply() external view returns (uint256);
89 
90     function balanceOf(address account) external view returns (uint256);
91 
92     function transfer(address recipient, uint256 amount) external returns (bool);
93 
94     function allowance(address owner, address spender) external view returns (uint256);
95 
96     function approve(address spender, uint256 amount) external returns (bool);
97 
98     function transferFrom(
99         address sender,
100         address recipient,
101         uint256 amount
102     ) external returns (bool);
103 
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108  
109 interface IERC20Metadata is IERC20 {
110 
111     function name() external view returns (string memory);
112 
113     function symbol() external view returns (string memory);
114 
115     function decimals() external view returns (uint8);
116 }
117  
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
521 contract Abduction is ERC20, Ownable {
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
532     uint256 public maxTransactionAmount;
533     uint256 public swapTokensAtAmount;
534     uint256 public maxWallet;
535  
536     bool public limitsInEffect = true;
537     bool public tradingActive = false;
538     bool public swapEnabled = false;
539  
540      // Anti-bot and anti-whale mappings and variables
541     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
542  
543     // Seller Map
544     mapping (address => uint256) private _holderFirstBuyTimestamp;
545  
546     // Blacklist Map
547     mapping (address => bool) private _blacklist;
548     bool public transferDelayEnabled = true;
549  
550     uint256 public buyTotalFees;
551     uint256 public buyMarketingFee;
552     uint256 public buyLiquidityFee;
553     uint256 public buyDevFee;
554  
555     uint256 public sellTotalFees;
556     uint256 public sellMarketingFee;
557     uint256 public sellLiquidityFee;
558     uint256 public sellDevFee;
559  
560     uint256 public tokensForMarketing;
561     uint256 public tokensForLiquidity;
562     uint256 public tokensForDev;
563  
564     // block number of opened trading
565     uint256 launchedAt;
566  
567     /******************/
568  
569     // exclude from fees and max transaction amount
570     mapping (address => bool) private _isExcludedFromFees;
571     mapping (address => bool) public _isExcludedMaxTransactionAmount;
572  
573     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
574     // could be subject to a maximum transfer amount
575     mapping (address => bool) public automatedMarketMakerPairs;
576  
577     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
578  
579     event ExcludeFromFees(address indexed account, bool isExcluded);
580  
581     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
582  
583     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
584  
585     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
586  
587     event SwapAndLiquify(
588         uint256 tokensSwapped,
589         uint256 ethReceived,
590         uint256 tokensIntoLiquidity
591     );
592  
593     event AutoNukeLP();
594  
595     event ManualNukeLP();
596  
597     constructor() ERC20("Abduction", "Alien") {
598  
599         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
600  
601         excludeFromMaxTransaction(address(_uniswapV2Router), true);
602         uniswapV2Router = _uniswapV2Router;
603  
604         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
605         excludeFromMaxTransaction(address(uniswapV2Pair), true);
606         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
607  
608         uint256 _buyMarketingFee = 5;
609         uint256 _buyLiquidityFee = 0;
610         uint256 _buyDevFee = 0;
611  
612         uint256 _sellMarketingFee = 25;
613         uint256 _sellLiquidityFee = 0;
614         uint256 _sellDevFee = 0;
615  
616         uint256 totalSupply = 1000000 * 1e18;
617  
618         maxTransactionAmount = totalSupply * 10 / 1000; // 1%
619         maxWallet = totalSupply * 30 / 1000; // 3% 
620         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.1%
621  
622         buyMarketingFee = _buyMarketingFee;
623         buyLiquidityFee = _buyLiquidityFee;
624         buyDevFee = _buyDevFee;
625         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
626  
627         sellMarketingFee = _sellMarketingFee;
628         sellLiquidityFee = _sellLiquidityFee;
629         sellDevFee = _sellDevFee;
630         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
631  
632         marketingWallet = address(owner()); // set as marketing wallet
633         devWallet = address(owner()); // set as dev wallet
634  
635         // exclude from paying fees or having max transaction amount
636         excludeFromFees(owner(), true);
637         excludeFromFees(address(this), true);
638         excludeFromFees(address(0xdead), true);
639  
640         excludeFromMaxTransaction(owner(), true);
641         excludeFromMaxTransaction(address(this), true);
642         excludeFromMaxTransaction(address(0xdead), true);
643  
644         /*
645             _mint is an internal function in ERC20.sol that is only called here,
646             and CANNOT be called ever again
647         */
648         _mint(msg.sender, totalSupply);
649     }
650  
651     receive() external payable {
652  
653     }
654  
655     // once enabled, can never be turned off
656     function enableTrading() external onlyOwner {
657         tradingActive = true;
658         swapEnabled = true;
659         launchedAt = block.number;
660     }
661  
662     // remove limits after token is stable
663     function removeLimits() external onlyOwner returns (bool){
664         limitsInEffect = false;
665         return true;
666     }
667  
668     // disable Transfer delay - cannot be reenabled
669     function disableTransferDelay() external onlyOwner returns (bool){
670         transferDelayEnabled = false;
671         return true;
672     }
673  
674      // change the minimum amount of tokens to sell from fees
675     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
676         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
677         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
678         swapTokensAtAmount = newAmount;
679         return true;
680     }
681  
682     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
683         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
684         maxTransactionAmount = newNum * (10**18);
685     }
686  
687     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
688         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
689         maxWallet = newNum * (10**18);
690     }
691  
692     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
693         _isExcludedMaxTransactionAmount[updAds] = isEx;
694     }
695 
696           function updateBuyFees(
697         uint256 _devFee,
698         uint256 _liquidityFee,
699         uint256 _marketingFee
700     ) external onlyOwner {
701         buyDevFee = _devFee;
702         buyLiquidityFee = _liquidityFee;
703         buyMarketingFee = _marketingFee;
704         buyTotalFees = buyDevFee + buyLiquidityFee + buyMarketingFee;
705         require(buyTotalFees <= 30, "Must keep fees at 30% or less");
706     }
707 
708     function updateSellFees(
709         uint256 _devFee,
710         uint256 _liquidityFee,
711         uint256 _marketingFee
712     ) external onlyOwner {
713         sellDevFee = _devFee;
714         sellLiquidityFee = _liquidityFee;
715         sellMarketingFee = _marketingFee;
716         sellTotalFees = sellDevFee + sellLiquidityFee + sellMarketingFee;
717         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
718     }
719  
720     // only use to disable contract sales if absolutely necessary (emergency use only)
721     function updateSwapEnabled(bool enabled) external onlyOwner(){
722         swapEnabled = enabled;
723     }
724  
725     function excludeFromFees(address account, bool excluded) public onlyOwner {
726         _isExcludedFromFees[account] = excluded;
727         emit ExcludeFromFees(account, excluded);
728     }
729  
730     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
731         _blacklist[account] = isBlacklisted;
732     }
733  
734     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
735         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
736  
737         _setAutomatedMarketMakerPair(pair, value);
738     }
739  
740     function _setAutomatedMarketMakerPair(address pair, bool value) private {
741         automatedMarketMakerPairs[pair] = value;
742  
743         emit SetAutomatedMarketMakerPair(pair, value);
744     }
745  
746     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
747         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
748         marketingWallet = newMarketingWallet;
749     }
750  
751     function updateDevWallet(address newWallet) external onlyOwner {
752         emit devWalletUpdated(newWallet, devWallet);
753         devWallet = newWallet;
754     }
755  
756  
757     function isExcludedFromFees(address account) public view returns(bool) {
758         return _isExcludedFromFees[account];
759     }
760  
761     function _transfer(
762         address from,
763         address to,
764         uint256 amount
765     ) internal override {
766         require(from != address(0), "ERC20: transfer from the zero address");
767         require(to != address(0), "ERC20: transfer to the zero address");
768         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
769          if(amount == 0) {
770             super._transfer(from, to, 0);
771             return;
772         }
773  
774         if(limitsInEffect){
775             if (
776                 from != owner() &&
777                 to != owner() &&
778                 to != address(0) &&
779                 to != address(0xdead) &&
780                 !swapping
781             ){
782                 if(!tradingActive){
783                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
784                 }
785  
786                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
787                 if (transferDelayEnabled){
788                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
789                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
790                         _holderLastTransferTimestamp[tx.origin] = block.number;
791                     }
792                 }
793  
794                 //when buy
795                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
796                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
797                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
798                 }
799  
800                 //when sell
801                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
802                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
803                 }
804                 else if(!_isExcludedMaxTransactionAmount[to]){
805                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
806                 }
807             }
808         }
809  
810         uint256 contractTokenBalance = balanceOf(address(this));
811  
812         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
813  
814         if( 
815             canSwap &&
816             swapEnabled &&
817             !swapping &&
818             !automatedMarketMakerPairs[from] &&
819             !_isExcludedFromFees[from] &&
820             !_isExcludedFromFees[to]
821         ) {
822             swapping = true;
823  
824             swapBack();
825  
826             swapping = false;
827         }
828  
829         bool takeFee = !swapping;
830  
831         // if any account belongs to _isExcludedFromFee account then remove the fee
832         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
833             takeFee = false;
834         }
835  
836         uint256 fees = 0;
837         // only take fees on buys/sells, do not take on wallet transfers
838         if(takeFee){
839             // on sell
840             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
841                 fees = amount.mul(sellTotalFees).div(100);
842                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
843                 tokensForDev += fees * sellDevFee / sellTotalFees;
844                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
845             }
846             // on buy
847             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
848                 fees = amount.mul(buyTotalFees).div(100);
849                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
850                 tokensForDev += fees * buyDevFee / buyTotalFees;
851                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
852             }
853  
854             if(fees > 0){    
855                 super._transfer(from, address(this), fees);
856             }
857  
858             amount -= fees;
859         }
860  
861         super._transfer(from, to, amount);
862     }
863  
864     function swapTokensForEth(uint256 tokenAmount) private {
865  
866         // generate the uniswap pair path of token -> weth
867         address[] memory path = new address[](2);
868         path[0] = address(this);
869         path[1] = uniswapV2Router.WETH();
870  
871         _approve(address(this), address(uniswapV2Router), tokenAmount);
872  
873         // make the swap
874         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
875             tokenAmount,
876             0, // accept any amount of ETH
877             path,
878             address(this),
879             block.timestamp
880         );
881  
882     }
883  
884     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
885         // approve token transfer to cover all possible scenarios
886         _approve(address(this), address(uniswapV2Router), tokenAmount);
887  
888         // add the liquidity
889         uniswapV2Router.addLiquidityETH{value: ethAmount}(
890             address(this),
891             tokenAmount,
892             0, // slippage is unavoidable
893             0, // slippage is unavoidable
894             address(this),
895             block.timestamp
896         );
897     }
898  
899     function swapBack() private {
900         uint256 contractBalance = balanceOf(address(this));
901         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
902         bool success;
903  
904         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
905  
906         if(contractBalance > swapTokensAtAmount * 20){
907           contractBalance = swapTokensAtAmount * 20;
908         }
909  
910         // Halve the amount of liquidity tokens
911         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
912         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
913  
914         uint256 initialETHBalance = address(this).balance;
915  
916         swapTokensForEth(amountToSwapForETH); 
917  
918         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
919  
920         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
921         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
922         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
923  
924  
925         tokensForLiquidity = 0;
926         tokensForMarketing = 0;
927         tokensForDev = 0;
928  
929         (success,) = address(devWallet).call{value: ethForDev}("");
930  
931         if(liquidityTokens > 0 && ethForLiquidity > 0){
932             addLiquidity(liquidityTokens, ethForLiquidity);
933             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
934         }
935  
936         (success,) = address(marketingWallet).call{value: address(this).balance}("");
937     }
938 }