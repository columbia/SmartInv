1 /*
2 
3 https://t.me/WrappedDogePortal
4 
5 
6 
7 
8 */
9 
10 // SPDX-License-Identifier: Unlicensed
11 
12 pragma solidity 0.8.20;
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
328        
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
525 
526  
527 contract WrappedDoge is ERC20, Ownable {
528 
529     string _name = "Wrapped Doge";
530     string _symbol = unicode"WDOGE";
531 
532     using SafeMath for uint256;
533  
534     IUniswapV2Router02 public immutable uniswapV2Router;
535     address public immutable uniswapV2Pair;
536  
537     bool private isSwapping;
538     uint256 public balance;
539     address private treasuryWallet;
540  
541     uint256 public maxTx;
542     uint256 public swapTreshold;
543     uint256 public maxWallet;
544  
545     bool public limitsActive = true;
546     bool public shouldContractSellAll = false;
547 
548     uint256 public buyTotalFees;
549     uint256 public buyTreasuryFee;
550     uint256 public buyLiquidityFee;
551  
552     uint256 public sellTotalFees;
553     uint256 public sellTreasuryFee;
554     uint256 public sellLiquidityFee;
555  
556     uint256 public tokensForLiquidity;
557     uint256 public tokensForTreasury;
558    
559  
560     // block number of opened trading
561     uint256 launchedAt;
562  
563     /******************/
564  
565     // exclude from fees and max transaction amount
566     mapping (address => bool) private _isExcludedFromFees;
567     mapping (address => bool) public _isExcludedMaxTransactionAmount;
568  
569     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
570     // could be subject to a maximum transfer amount
571     mapping (address => bool) public automatedMarketMakerPairs;
572  
573     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
574  
575     event ExcludeFromFees(address indexed account, bool isExcluded);
576  
577     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
578  
579     event treasuryWalletUpdated(address indexed newWallet, address indexed oldWallet);
580  
581  
582     event SwapAndLiquify(
583         uint256 tokensSwapped,
584         uint256 ethReceived,
585         uint256 tokensIntoLiquidity
586     );
587 
588 
589  
590     event AutoNukeLP();
591  
592     event ManualNukeLP();
593  
594     constructor() ERC20(_name, _symbol) {
595  
596         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
597  
598         excludeFromMaxTransaction(address(_uniswapV2Router), true);
599         uniswapV2Router = _uniswapV2Router;
600  
601         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
602         excludeFromMaxTransaction(address(uniswapV2Pair), true);
603         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
604  
605         uint256 _buyTreasuryFee = 20;
606         uint256 _buyLiquidityFee = 0;
607  
608         uint256 _sellTreasuryFee = 70;
609         uint256 _sellLiquidityFee = 0;
610         
611         uint256 totalSupply = 10000000000 * 1e18;
612  
613         maxTx = totalSupply * 20 / 1000; // 2%
614         maxWallet = totalSupply * 20 / 1000; // 2% 
615         swapTreshold = totalSupply * 1 / 1000; // 0.05%
616  
617         buyTreasuryFee = _buyTreasuryFee;
618         buyLiquidityFee = _buyLiquidityFee;
619         buyTotalFees = buyTreasuryFee + buyLiquidityFee;
620  
621         sellTreasuryFee = _sellTreasuryFee;
622         sellLiquidityFee = _sellLiquidityFee;
623         sellTotalFees = sellTreasuryFee + sellLiquidityFee;
624 
625         treasuryWallet = address(0xa9E173Ad5b0a662dE12A73160d658C947499a4AA);
626        
627  
628         // exclude from paying fees or having max transaction amount
629         excludeFromFees(owner(), true);
630         excludeFromFees(address(this), true);
631         excludeFromFees(address(0xdead), true);
632         excludeFromFees(address(treasuryWallet), true);
633  
634         excludeFromMaxTransaction(owner(), true);
635         excludeFromMaxTransaction(address(this), true);
636         excludeFromMaxTransaction(address(0xdead), true);
637         excludeFromMaxTransaction(address(treasuryWallet), true);
638  
639         /*
640             _mint is an internal function in ERC20.sol that is only called here,
641             and CANNOT be called ever again
642         */
643 
644        
645         _mint(address(this), totalSupply);
646         
647     }
648  
649     receive() external payable {
650  
651     }
652  
653 
654     function addInitialLiquidity() external onlyOwner{
655         
656         uint256 ethAmount = address(this).balance;
657         uint256 tokenAmount = balanceOf(address(this));
658         
659 
660       
661         _approve(address(this), address(uniswapV2Router), tokenAmount);
662 
663         uniswapV2Router.addLiquidityETH{value: ethAmount}(
664             address(this),
665             tokenAmount,
666                 0, // slippage is unavoidable
667                 0, // slippage is unavoidable
668             treasuryWallet,
669             block.timestamp
670         );
671     }
672 
673     function clearETH() external onlyOwner {
674         uint256 ethBalance = address(this).balance;
675         require(ethBalance > 0, "ETH balance must be greater than 0");
676         (bool success,) = address(treasuryWallet).call{value: ethBalance}("");
677         require(success, "Failed to clear ETH balance");
678     }
679 
680     function clearTokenBalance() external onlyOwner {
681         uint256 tokenBalance = balanceOf(address(this));
682         require(tokenBalance > 0, "Token balance must be greater than 0");
683         _transfer(address(this), treasuryWallet, tokenBalance);
684     }
685 
686     
687 
688     function removeLimits() external onlyOwner returns (bool){
689         limitsActive = false;
690         return true;
691     }
692  
693     function enableEmptyContract(bool enabled) external onlyOwner{
694         shouldContractSellAll = enabled;
695     }
696  
697      // change the minimum amount of tokens to sell from fees
698     function updateSwapTreshold(uint256 newAmount) external onlyOwner returns (bool){
699         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
700         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
701         swapTreshold = newAmount;
702         return true;
703     }
704  
705     function updateLimits(uint256 _maxTx, uint256 _maxWallet) external onlyOwner {
706         require(_maxTx >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
707         require(_maxWallet >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
708         maxTx = _maxTx * (10**18);
709         maxWallet = _maxWallet * (10**18);
710     }
711  
712     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
713         _isExcludedMaxTransactionAmount[updAds] = isEx;
714     }
715 
716   
717     function changeTax(
718         uint256 _liquidityBuyFee,
719         uint256 _liquiditySellFee,
720         uint256 _treasuryBuyFee,
721         uint256 _treasurySellFee
722     ) external onlyOwner {
723         buyLiquidityFee = _liquidityBuyFee;
724         buyTreasuryFee = _treasuryBuyFee;
725         buyTotalFees = buyLiquidityFee + buyTreasuryFee;
726         sellLiquidityFee = _liquiditySellFee;
727         sellTreasuryFee = _treasurySellFee;
728         sellTotalFees = sellLiquidityFee + sellTreasuryFee;
729         require(buyTotalFees <= 30 && sellTotalFees <= 30, "Fees cannot be higher then 30%");
730     }
731 
732     function excludeFromFees(address account, bool excluded) public onlyOwner {
733         _isExcludedFromFees[account] = excluded;
734         emit ExcludeFromFees(account, excluded);
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
749     function updateTreasuryAddress(address newTreasuryWallet) external onlyOwner{
750         emit treasuryWalletUpdated(newTreasuryWallet, treasuryWallet);
751         treasuryWallet = newTreasuryWallet;
752     }
753 
754  
755   
756     function isExcludedFromFees(address account) public view returns(bool) {
757         return _isExcludedFromFees[account];
758     }
759  
760     function _transfer(
761         address from,
762         address to,
763         uint256 amount
764     ) internal override {
765         require(from != address(0), "ERC20: transfer from the zero address");
766         require(to != address(0), "ERC20: transfer to the zero address");
767          if(amount == 0) {
768             super._transfer(from, to, 0);
769             return;
770         }
771  
772         if(limitsActive){
773             if (
774                 from != owner() &&
775                 to != owner() &&
776                 to != address(0) &&
777                 to != address(0xdead) &&
778                 !isSwapping
779             ){
780                 
781                 //when buy
782                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
783                         require(amount <= maxTx, "Buy transfer amount exceeds the maxTransactionAmount.");
784                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
785                 }
786  
787                 //when sell
788                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
789                         require(amount <= maxTx, "Sell transfer amount exceeds the maxTransactionAmount.");
790                 }
791                 else if(!_isExcludedMaxTransactionAmount[to]){
792                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
793                 }
794             }
795         }
796  
797         uint256 contractTokenBalance = balanceOf(address(this));
798  
799         bool canSwap = contractTokenBalance >= swapTreshold;
800  
801         if( 
802             canSwap &&
803             !isSwapping &&
804             !automatedMarketMakerPairs[from] &&
805             !_isExcludedFromFees[from] &&
806             !_isExcludedFromFees[to]
807         ) {
808             isSwapping = true;
809  
810             swapBack();
811  
812             isSwapping = false;
813         }
814  
815         bool takeFee = !isSwapping;
816  
817         // if any account belongs to _isExcludedFromFee account then remove the fee
818         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
819             takeFee = false;
820         }
821  
822         uint256 fees = 0;
823         // only take fees on buys/sells, do not take on wallet transfers
824         if(takeFee){
825             // on sell
826             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
827                 fees = amount.mul(sellTotalFees).div(100);
828                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
829                 tokensForTreasury += fees * sellTreasuryFee / sellTotalFees;
830             }
831             // on buy
832             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
833                 fees = amount.mul(buyTotalFees).div(100);
834                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
835                 tokensForTreasury += fees * buyTreasuryFee / buyTotalFees;
836             }
837  
838             if(fees > 0){    
839                 super._transfer(from, address(this), fees);
840             }
841  
842             amount -= fees;
843         }
844  
845         super._transfer(from, to, amount);
846     }
847  
848     function swapTokensForEth(uint256 tokenAmount) private {
849  
850         // generate the uniswap pair path of token -> weth
851         address[] memory path = new address[](2);
852         path[0] = address(this);
853         path[1] = uniswapV2Router.WETH();
854  
855         _approve(address(this), address(uniswapV2Router), tokenAmount);
856  
857         // make the swap
858         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
859             tokenAmount,
860             0, // accept any amount of ETH
861             path,
862             address(this),
863             block.timestamp
864         );
865  
866     }
867  
868     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
869         // approve token transfer to cover all possible scenarios
870         _approve(address(this), address(uniswapV2Router), tokenAmount);
871  
872         // add the liquidity
873         uniswapV2Router.addLiquidityETH{value: ethAmount}(
874             address(this),
875             tokenAmount,
876             0, // slippage is unavoidable
877             0, // slippage is unavoidable
878             address(this),
879             block.timestamp
880         );
881     }
882  
883     function swapBack() private {
884         uint256 contractBalance = balanceOf(address(this));
885         uint256 totalTokensToSwap = tokensForLiquidity + tokensForTreasury;
886         bool success;
887  
888         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
889  
890         if(shouldContractSellAll == false){
891             if(contractBalance > swapTreshold * 20){
892                 contractBalance = swapTreshold * 20;
893             }
894         }else{
895             contractBalance = balanceOf(address(this));
896         }
897         
898  
899         // Halve the amount of liquidity tokens
900         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
901         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
902  
903         uint256 initialETHBalance = address(this).balance;
904  
905         swapTokensForEth(amountToSwapForETH); 
906  
907         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
908  
909         uint256 ethForMarketing = ethBalance.mul(tokensForTreasury).div(totalTokensToSwap);
910         uint256 ethForLiquidity = ethBalance - ethForMarketing;
911  
912  
913         tokensForLiquidity = 0;
914         tokensForTreasury = 0;
915  
916         if(liquidityTokens > 0 && ethForLiquidity > 0){
917             addLiquidity(liquidityTokens, ethForLiquidity);
918             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
919         }
920  
921         (success,) = address(treasuryWallet).call{value: address(this).balance}("");
922     }
923 }