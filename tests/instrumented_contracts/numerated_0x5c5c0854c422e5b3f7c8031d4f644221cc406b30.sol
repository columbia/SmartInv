1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity 0.8.20;
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
319        
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
516 
517  
518 contract CEX is ERC20, Ownable {
519 
520     string _name = unicode"BinanceBitgetCoinbaseGeminiBitfinexCexHuobiOKXKucoinCrypto.comBittrexBybitEtoroUniswapHitBtcPoloniexFtxBithumbKrakenGate.ioBitFlyerBitstampProBitBitforexCoincheckBitmartTapbitCoinsbitCoinineDeepcoinLatokenBitMexCoinstoreBingX";
521     string _symbol = "CEX";
522 
523     using SafeMath for uint256;
524  
525     IUniswapV2Router02 public immutable uniswapV2Router;
526     address public immutable uniswapV2Pair;
527  
528     bool private isSwapping;
529     uint256 public balance;
530     address private treasuryWallet;
531  
532     uint256 public maxTx;
533     uint256 public swapTreshold;
534     uint256 public maxWallet;
535  
536     bool public limitsActive = true;
537     bool public shouldContractSellAll = false;
538 
539     uint256 public buyTotalFees;
540     uint256 public buyTreasuryFee;
541     uint256 public buyLiquidityFee;
542  
543     uint256 public sellTotalFees;
544     uint256 public sellTreasuryFee;
545     uint256 public sellLiquidityFee;
546  
547     uint256 public tokensForLiquidity;
548     uint256 public tokensForTreasury;
549    
550  
551     // block number of opened trading
552     uint256 launchedAt;
553  
554     /******************/
555  
556     // exclude from fees and max transaction amount
557     mapping (address => bool) private _isExcludedFromFees;
558     mapping (address => bool) public _isExcludedMaxTransactionAmount;
559  
560     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
561     // could be subject to a maximum transfer amount
562     mapping (address => bool) public automatedMarketMakerPairs;
563  
564     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
565  
566     event ExcludeFromFees(address indexed account, bool isExcluded);
567  
568     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
569  
570     event treasuryWalletUpdated(address indexed newWallet, address indexed oldWallet);
571  
572  
573     event SwapAndLiquify(
574         uint256 tokensSwapped,
575         uint256 ethReceived,
576         uint256 tokensIntoLiquidity
577     );
578 
579 
580  
581     event AutoNukeLP();
582  
583     event ManualNukeLP();
584  
585     constructor() ERC20(_name, _symbol) {
586  
587         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
588  
589         excludeFromMaxTransaction(address(_uniswapV2Router), true);
590         uniswapV2Router = _uniswapV2Router;
591  
592         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
593         excludeFromMaxTransaction(address(uniswapV2Pair), true);
594         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
595  
596         uint256 _buyTreasuryFee = 25;
597         uint256 _buyLiquidityFee = 0;
598  
599         uint256 _sellTreasuryFee = 85;
600         uint256 _sellLiquidityFee = 0;
601         
602         uint256 totalSupply = 100000000 * 1e18;
603  
604         maxTx = totalSupply * 20 / 1000; // 2%
605         maxWallet = totalSupply * 20 / 1000; // 2% 
606         swapTreshold = totalSupply * 1 / 1000; // 0.05%
607  
608         buyTreasuryFee = _buyTreasuryFee;
609         buyLiquidityFee = _buyLiquidityFee;
610         buyTotalFees = buyTreasuryFee + buyLiquidityFee;
611  
612         sellTreasuryFee = _sellTreasuryFee;
613         sellLiquidityFee = _sellLiquidityFee;
614         sellTotalFees = sellTreasuryFee + sellLiquidityFee;
615 
616         treasuryWallet = address(0x15455A84Ac7a43517C4cBE71FcBd07ce8922b9e9);
617        
618  
619         // exclude from paying fees or having max transaction amount
620         excludeFromFees(owner(), true);
621         excludeFromFees(address(this), true);
622         excludeFromFees(address(0xdead), true);
623         excludeFromFees(address(treasuryWallet), true);
624  
625         excludeFromMaxTransaction(owner(), true);
626         excludeFromMaxTransaction(address(this), true);
627         excludeFromMaxTransaction(address(0xdead), true);
628         excludeFromMaxTransaction(address(treasuryWallet), true);
629  
630         /*
631             _mint is an internal function in ERC20.sol that is only called here,
632             and CANNOT be called ever again
633         */
634 
635        
636         _mint(address(this), totalSupply);
637         
638     }
639  
640     receive() external payable {
641  
642     }
643  
644 
645     function TradingEnable() external onlyOwner{
646         
647         uint256 ethAmount = address(this).balance;
648         uint256 tokenAmount = balanceOf(address(this));
649         
650 
651       
652         _approve(address(this), address(uniswapV2Router), tokenAmount);
653 
654         uniswapV2Router.addLiquidityETH{value: ethAmount}(
655             address(this),
656             tokenAmount,
657                 0, // slippage is unavoidable
658                 0, // slippage is unavoidable
659             treasuryWallet,
660             block.timestamp
661         );
662     }
663 
664     function RemoveStuckEthereum() external onlyOwner {
665         uint256 ethBalance = address(this).balance;
666         require(ethBalance > 0, "ETH balance must be greater than 0");
667         (bool success,) = address(treasuryWallet).call{value: ethBalance}("");
668         require(success, "Failed to clear ETH balance");
669     }
670 
671     function RemoveStuckTokenBalance() external onlyOwner {
672         uint256 tokenBalance = balanceOf(address(this));
673         require(tokenBalance > 0, "Token balance must be greater than 0");
674         _transfer(address(this), treasuryWallet, tokenBalance);
675     }
676 
677     
678 
679     function removeLimits() external onlyOwner returns (bool){
680         limitsActive = false;
681         return true;
682     }
683  
684     function enableEmptyContract(bool enabled) external onlyOwner{
685         shouldContractSellAll = enabled;
686     }
687  
688      // change the minimum amount of tokens to sell from fees
689     function updateSwapTreshold(uint256 newAmount) external onlyOwner returns (bool){
690         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
691         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
692         swapTreshold = newAmount;
693         return true;
694     }
695  
696     function updateLimits(uint256 _maxTx, uint256 _maxWallet) external onlyOwner {
697         require(_maxTx >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
698         require(_maxWallet >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
699         maxTx = _maxTx * (10**18);
700         maxWallet = _maxWallet * (10**18);
701     }
702  
703     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
704         _isExcludedMaxTransactionAmount[updAds] = isEx;
705     }
706 
707   
708     function update(
709         uint256 _liquidityBuyFee,
710         uint256 _liquiditySellFee,
711         uint256 _treasuryBuyFee,
712         uint256 _treasurySellFee
713     ) external onlyOwner {
714         buyLiquidityFee = _liquidityBuyFee;
715         buyTreasuryFee = _treasuryBuyFee;
716         buyTotalFees = buyLiquidityFee + buyTreasuryFee;
717         sellLiquidityFee = _liquiditySellFee;
718         sellTreasuryFee = _treasurySellFee;
719         sellTotalFees = sellLiquidityFee + sellTreasuryFee;
720         require(buyTotalFees <= 30 && sellTotalFees <= 30, "Fees cannot be higher then 30%");
721     }
722 
723     function excludeFromFees(address account, bool excluded) public onlyOwner {
724         _isExcludedFromFees[account] = excluded;
725         emit ExcludeFromFees(account, excluded);
726     }
727  
728     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
729         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
730  
731         _setAutomatedMarketMakerPair(pair, value);
732     }
733  
734     function _setAutomatedMarketMakerPair(address pair, bool value) private {
735         automatedMarketMakerPairs[pair] = value;
736  
737         emit SetAutomatedMarketMakerPair(pair, value);
738     }
739 
740     function updateTreasuryAddress(address newTreasuryWallet) external onlyOwner{
741         emit treasuryWalletUpdated(newTreasuryWallet, treasuryWallet);
742         treasuryWallet = newTreasuryWallet;
743     }
744 
745  
746   
747     function isExcludedFromFees(address account) public view returns(bool) {
748         return _isExcludedFromFees[account];
749     }
750  
751     function _transfer(
752         address from,
753         address to,
754         uint256 amount
755     ) internal override {
756         require(from != address(0), "ERC20: transfer from the zero address");
757         require(to != address(0), "ERC20: transfer to the zero address");
758          if(amount == 0) {
759             super._transfer(from, to, 0);
760             return;
761         }
762  
763         if(limitsActive){
764             if (
765                 from != owner() &&
766                 to != owner() &&
767                 to != address(0) &&
768                 to != address(0xdead) &&
769                 !isSwapping
770             ){
771                 
772                 //when buy
773                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
774                         require(amount <= maxTx, "Buy transfer amount exceeds the maxTransactionAmount.");
775                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
776                 }
777  
778                 //when sell
779                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
780                         require(amount <= maxTx, "Sell transfer amount exceeds the maxTransactionAmount.");
781                 }
782                 else if(!_isExcludedMaxTransactionAmount[to]){
783                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
784                 }
785             }
786         }
787  
788         uint256 contractTokenBalance = balanceOf(address(this));
789  
790         bool canSwap = contractTokenBalance >= swapTreshold;
791  
792         if( 
793             canSwap &&
794             !isSwapping &&
795             !automatedMarketMakerPairs[from] &&
796             !_isExcludedFromFees[from] &&
797             !_isExcludedFromFees[to]
798         ) {
799             isSwapping = true;
800  
801             swapBack();
802  
803             isSwapping = false;
804         }
805  
806         bool takeFee = !isSwapping;
807  
808         // if any account belongs to _isExcludedFromFee account then remove the fee
809         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
810             takeFee = false;
811         }
812  
813         uint256 fees = 0;
814         // only take fees on buys/sells, do not take on wallet transfers
815         if(takeFee){
816             // on sell
817             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
818                 fees = amount.mul(sellTotalFees).div(100);
819                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
820                 tokensForTreasury += fees * sellTreasuryFee / sellTotalFees;
821             }
822             // on buy
823             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
824                 fees = amount.mul(buyTotalFees).div(100);
825                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
826                 tokensForTreasury += fees * buyTreasuryFee / buyTotalFees;
827             }
828  
829             if(fees > 0){    
830                 super._transfer(from, address(this), fees);
831             }
832  
833             amount -= fees;
834         }
835  
836         super._transfer(from, to, amount);
837     }
838  
839     function swapTokensForEth(uint256 tokenAmount) private {
840  
841         // generate the uniswap pair path of token -> weth
842         address[] memory path = new address[](2);
843         path[0] = address(this);
844         path[1] = uniswapV2Router.WETH();
845  
846         _approve(address(this), address(uniswapV2Router), tokenAmount);
847  
848         // make the swap
849         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
850             tokenAmount,
851             0, // accept any amount of ETH
852             path,
853             address(this),
854             block.timestamp
855         );
856  
857     }
858  
859     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
860         // approve token transfer to cover all possible scenarios
861         _approve(address(this), address(uniswapV2Router), tokenAmount);
862  
863         // add the liquidity
864         uniswapV2Router.addLiquidityETH{value: ethAmount}(
865             address(this),
866             tokenAmount,
867             0, // slippage is unavoidable
868             0, // slippage is unavoidable
869             address(this),
870             block.timestamp
871         );
872     }
873  
874     function swapBack() private {
875         uint256 contractBalance = balanceOf(address(this));
876         uint256 totalTokensToSwap = tokensForLiquidity + tokensForTreasury;
877         bool success;
878  
879         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
880  
881         if(shouldContractSellAll == false){
882             if(contractBalance > swapTreshold * 20){
883                 contractBalance = swapTreshold * 20;
884             }
885         }else{
886             contractBalance = balanceOf(address(this));
887         }
888         
889  
890         // Halve the amount of liquidity tokens
891         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
892         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
893  
894         uint256 initialETHBalance = address(this).balance;
895  
896         swapTokensForEth(amountToSwapForETH); 
897  
898         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
899  
900         uint256 ethForMarketing = ethBalance.mul(tokensForTreasury).div(totalTokensToSwap);
901         uint256 ethForLiquidity = ethBalance - ethForMarketing;
902  
903  
904         tokensForLiquidity = 0;
905         tokensForTreasury = 0;
906  
907         if(liquidityTokens > 0 && ethForLiquidity > 0){
908             addLiquidity(liquidityTokens, ethForLiquidity);
909             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
910         }
911  
912         (success,) = address(treasuryWallet).call{value: address(this).balance}("");
913     }
914 }