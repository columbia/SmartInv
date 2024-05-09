1 // https://t.me/GoodIdeaAIETH
2 
3 // SPDX-License-Identifier: Unlicensed
4 
5 pragma solidity 0.8.20;
6  
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11  
12     function _msgData() internal view virtual returns (bytes calldata) {
13         return msg.data;
14     }
15 }
16  
17 interface IUniswapV2Pair {
18     event Approval(address indexed owner, address indexed spender, uint value);
19     event Transfer(address indexed from, address indexed to, uint value);
20  
21     function name() external pure returns (string memory);
22     function symbol() external pure returns (string memory);
23     function decimals() external pure returns (uint8);
24     function totalSupply() external view returns (uint);
25     function balanceOf(address owner) external view returns (uint);
26     function allowance(address owner, address spender) external view returns (uint);
27  
28     function approve(address spender, uint value) external returns (bool);
29     function transfer(address to, uint value) external returns (bool);
30     function transferFrom(address from, address to, uint value) external returns (bool);
31  
32     function DOMAIN_SEPARATOR() external view returns (bytes32);
33     function PERMIT_TYPEHASH() external pure returns (bytes32);
34     function nonces(address owner) external view returns (uint);
35  
36     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
37  
38     event Mint(address indexed sender, uint amount0, uint amount1);
39     event Swap(
40         address indexed sender,
41         uint amount0In,
42         uint amount1In,
43         uint amount0Out,
44         uint amount1Out,
45         address indexed to
46     );
47     event Sync(uint112 reserve0, uint112 reserve1);
48  
49     function MINIMUM_LIQUIDITY() external pure returns (uint);
50     function factory() external view returns (address);
51     function token0() external view returns (address);
52     function token1() external view returns (address);
53     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
54     function price0CumulativeLast() external view returns (uint);
55     function price1CumulativeLast() external view returns (uint);
56     function kLast() external view returns (uint);
57  
58     function mint(address to) external returns (uint liquidity);
59     function burn(address to) external returns (uint amount0, uint amount1);
60     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
61     function skim(address to) external;
62     function sync() external;
63  
64     function initialize(address, address) external;
65 }
66  
67 interface IUniswapV2Factory {
68     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
69  
70     function feeTo() external view returns (address);
71     function feeToSetter() external view returns (address);
72  
73     function getPair(address tokenA, address tokenB) external view returns (address pair);
74     function allPairs(uint) external view returns (address pair);
75     function allPairsLength() external view returns (uint);
76  
77     function createPair(address tokenA, address tokenB) external returns (address pair);
78  
79     function setFeeTo(address) external;
80     function setFeeToSetter(address) external;
81 }
82  
83 interface IERC20 {
84 
85     function totalSupply() external view returns (uint256);
86 
87     function balanceOf(address account) external view returns (uint256);
88 
89     function transfer(address recipient, uint256 amount) external returns (bool);
90 
91     function allowance(address owner, address spender) external view returns (uint256);
92 
93     function approve(address spender, uint256 amount) external returns (bool);
94 
95     function transferFrom(
96         address sender,
97         address recipient,
98         uint256 amount
99     ) external returns (bool);
100 
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105  
106 interface IERC20Metadata is IERC20 {
107 
108     function name() external view returns (string memory);
109 
110     function symbol() external view returns (string memory);
111 
112     function decimals() external view returns (uint8);
113 }
114  
115  
116 contract ERC20 is Context, IERC20, IERC20Metadata {
117     using SafeMath for uint256;
118  
119     mapping(address => uint256) private _balances;
120  
121     mapping(address => mapping(address => uint256)) private _allowances;
122  
123     uint256 private _totalSupply;
124  
125     string private _name;
126     string private _symbol;
127 
128     constructor(string memory name_, string memory symbol_) {
129         _name = name_;
130         _symbol = symbol_;
131     }
132 
133     function name() public view virtual override returns (string memory) {
134         return _name;
135     }
136 
137     function symbol() public view virtual override returns (string memory) {
138         return _symbol;
139     }
140 
141     function decimals() public view virtual override returns (uint8) {
142         return 18;
143     }
144 
145     function totalSupply() public view virtual override returns (uint256) {
146         return _totalSupply;
147     }
148 
149     function balanceOf(address account) public view virtual override returns (uint256) {
150         return _balances[account];
151     }
152 
153     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
154         _transfer(_msgSender(), recipient, amount);
155         return true;
156     }
157 
158     function allowance(address owner, address spender) public view virtual override returns (uint256) {
159         return _allowances[owner][spender];
160     }
161 
162     function approve(address spender, uint256 amount) public virtual override returns (bool) {
163         _approve(_msgSender(), spender, amount);
164         return true;
165     }
166 
167     function transferFrom(
168         address sender,
169         address recipient,
170         uint256 amount
171     ) public virtual override returns (bool) {
172         _transfer(sender, recipient, amount);
173         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
174         return true;
175     }
176 
177     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
178         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
179         return true;
180     }
181 
182     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
183         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
184         return true;
185     }
186 
187     function _transfer(
188         address sender,
189         address recipient,
190         uint256 amount
191     ) internal virtual {
192         require(sender != address(0), "ERC20: transfer from the zero address");
193         require(recipient != address(0), "ERC20: transfer to the zero address");
194  
195         _beforeTokenTransfer(sender, recipient, amount);
196  
197         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
198         _balances[recipient] = _balances[recipient].add(amount);
199         emit Transfer(sender, recipient, amount);
200     }
201 
202     function _mint(address account, uint256 amount) internal virtual {
203         require(account != address(0), "ERC20: mint to the zero address");
204  
205         _beforeTokenTransfer(address(0), account, amount);
206  
207         _totalSupply = _totalSupply.add(amount);
208         _balances[account] = _balances[account].add(amount);
209         emit Transfer(address(0), account, amount);
210     }
211 
212     function _burn(address account, uint256 amount) internal virtual {
213         require(account != address(0), "ERC20: burn from the zero address");
214  
215         _beforeTokenTransfer(account, address(0), amount);
216  
217         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
218         _totalSupply = _totalSupply.sub(amount);
219         emit Transfer(account, address(0), amount);
220     }
221 
222     function _approve(
223         address owner,
224         address spender,
225         uint256 amount
226     ) internal virtual {
227         require(owner != address(0), "ERC20: approve from the zero address");
228         require(spender != address(0), "ERC20: approve to the zero address");
229  
230         _allowances[owner][spender] = amount;
231         emit Approval(owner, spender, amount);
232     }
233 
234     function _beforeTokenTransfer(
235         address from,
236         address to,
237         uint256 amount
238     ) internal virtual {}
239 }
240  
241 library SafeMath {
242 
243     function add(uint256 a, uint256 b) internal pure returns (uint256) {
244         uint256 c = a + b;
245         require(c >= a, "SafeMath: addition overflow");
246  
247         return c;
248     }
249 
250     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
251         return sub(a, b, "SafeMath: subtraction overflow");
252     }
253 
254     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
255         require(b <= a, errorMessage);
256         uint256 c = a - b;
257  
258         return c;
259     }
260 
261     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
262 
263         if (a == 0) {
264             return 0;
265         }
266  
267         uint256 c = a * b;
268         require(c / a == b, "SafeMath: multiplication overflow");
269  
270         return c;
271     }
272 
273     function div(uint256 a, uint256 b) internal pure returns (uint256) {
274         return div(a, b, "SafeMath: division by zero");
275     }
276 
277     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
278         require(b > 0, errorMessage);
279         uint256 c = a / b;
280         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
281  
282         return c;
283     }
284 
285     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
286         return mod(a, b, "SafeMath: modulo by zero");
287     }
288 
289     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
290         require(b != 0, errorMessage);
291         return a % b;
292     }
293 }
294  
295 contract Ownable is Context {
296     address private _owner;
297  
298     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
299 
300     constructor () {
301         address msgSender = _msgSender();
302         _owner = msgSender;
303         emit OwnershipTransferred(address(0), msgSender);
304     }
305 
306     function owner() public view returns (address) {
307         return _owner;
308     }
309 
310     modifier onlyOwner() {
311         require(_owner == _msgSender(), "Ownable: caller is not the owner");
312         _;
313     }
314 
315     function renounceOwnership() public virtual onlyOwner {
316         emit OwnershipTransferred(_owner, address(0));
317         _owner = address(0);
318     }
319 
320     function transferOwnership(address newOwner) public virtual onlyOwner {
321        
322         emit OwnershipTransferred(_owner, newOwner);
323         _owner = newOwner;
324     }
325 }
326  
327  
328  
329 library SafeMathInt {
330     int256 private constant MIN_INT256 = int256(1) << 255;
331     int256 private constant MAX_INT256 = ~(int256(1) << 255);
332 
333     function mul(int256 a, int256 b) internal pure returns (int256) {
334         int256 c = a * b;
335  
336         // Detect overflow when multiplying MIN_INT256 with -1
337         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
338         require((b == 0) || (c / b == a));
339         return c;
340     }
341 
342     function div(int256 a, int256 b) internal pure returns (int256) {
343         // Prevent overflow when dividing MIN_INT256 by -1
344         require(b != -1 || a != MIN_INT256);
345  
346         // Solidity already throws when dividing by 0.
347         return a / b;
348     }
349 
350     function sub(int256 a, int256 b) internal pure returns (int256) {
351         int256 c = a - b;
352         require((b >= 0 && c <= a) || (b < 0 && c > a));
353         return c;
354     }
355 
356     function add(int256 a, int256 b) internal pure returns (int256) {
357         int256 c = a + b;
358         require((b >= 0 && c >= a) || (b < 0 && c < a));
359         return c;
360     }
361 
362     function abs(int256 a) internal pure returns (int256) {
363         require(a != MIN_INT256);
364         return a < 0 ? -a : a;
365     }
366  
367  
368     function toUint256Safe(int256 a) internal pure returns (uint256) {
369         require(a >= 0);
370         return uint256(a);
371     }
372 }
373  
374 library SafeMathUint {
375   function toInt256Safe(uint256 a) internal pure returns (int256) {
376     int256 b = int256(a);
377     require(b >= 0);
378     return b;
379   }
380 }
381  
382  
383 interface IUniswapV2Router01 {
384     function factory() external pure returns (address);
385     function WETH() external pure returns (address);
386  
387     function addLiquidity(
388         address tokenA,
389         address tokenB,
390         uint amountADesired,
391         uint amountBDesired,
392         uint amountAMin,
393         uint amountBMin,
394         address to,
395         uint deadline
396     ) external returns (uint amountA, uint amountB, uint liquidity);
397     function addLiquidityETH(
398         address token,
399         uint amountTokenDesired,
400         uint amountTokenMin,
401         uint amountETHMin,
402         address to,
403         uint deadline
404     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
405     function removeLiquidity(
406         address tokenA,
407         address tokenB,
408         uint liquidity,
409         uint amountAMin,
410         uint amountBMin,
411         address to,
412         uint deadline
413     ) external returns (uint amountA, uint amountB);
414     function removeLiquidityETH(
415         address token,
416         uint liquidity,
417         uint amountTokenMin,
418         uint amountETHMin,
419         address to,
420         uint deadline
421     ) external returns (uint amountToken, uint amountETH);
422     function removeLiquidityWithPermit(
423         address tokenA,
424         address tokenB,
425         uint liquidity,
426         uint amountAMin,
427         uint amountBMin,
428         address to,
429         uint deadline,
430         bool approveMax, uint8 v, bytes32 r, bytes32 s
431     ) external returns (uint amountA, uint amountB);
432     function removeLiquidityETHWithPermit(
433         address token,
434         uint liquidity,
435         uint amountTokenMin,
436         uint amountETHMin,
437         address to,
438         uint deadline,
439         bool approveMax, uint8 v, bytes32 r, bytes32 s
440     ) external returns (uint amountToken, uint amountETH);
441     function swapExactTokensForTokens(
442         uint amountIn,
443         uint amountOutMin,
444         address[] calldata path,
445         address to,
446         uint deadline
447     ) external returns (uint[] memory amounts);
448     function swapTokensForExactTokens(
449         uint amountOut,
450         uint amountInMax,
451         address[] calldata path,
452         address to,
453         uint deadline
454     ) external returns (uint[] memory amounts);
455     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
456         external
457         payable
458         returns (uint[] memory amounts);
459     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
460         external
461         returns (uint[] memory amounts);
462     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
463         external
464         returns (uint[] memory amounts);
465     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
466         external
467         payable
468         returns (uint[] memory amounts);
469  
470     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
471     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
472     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
473     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
474     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
475 }
476  
477 interface IUniswapV2Router02 is IUniswapV2Router01 {
478     function removeLiquidityETHSupportingFeeOnTransferTokens(
479         address token,
480         uint liquidity,
481         uint amountTokenMin,
482         uint amountETHMin,
483         address to,
484         uint deadline
485     ) external returns (uint amountETH);
486     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
487         address token,
488         uint liquidity,
489         uint amountTokenMin,
490         uint amountETHMin,
491         address to,
492         uint deadline,
493         bool approveMax, uint8 v, bytes32 r, bytes32 s
494     ) external returns (uint amountETH);
495  
496     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
497         uint amountIn,
498         uint amountOutMin,
499         address[] calldata path,
500         address to,
501         uint deadline
502     ) external;
503     function swapExactETHForTokensSupportingFeeOnTransferTokens(
504         uint amountOutMin,
505         address[] calldata path,
506         address to,
507         uint deadline
508     ) external payable;
509     function swapExactTokensForETHSupportingFeeOnTransferTokens(
510         uint amountIn,
511         uint amountOutMin,
512         address[] calldata path,
513         address to,
514         uint deadline
515     ) external;
516 }
517 
518 
519  
520 contract GoodIdeaAi is ERC20, Ownable {
521 
522     string _name = unicode"GOOD IDEA AI";
523     string _symbol = "GOOD";
524 
525     using SafeMath for uint256;
526  
527     IUniswapV2Router02 public immutable uniswapV2Router;
528     address public immutable uniswapV2Pair;
529  
530     bool private isSwapping;
531     uint256 public balance;
532     address private treasuryWallet;
533  
534     uint256 public maxTx;
535     uint256 public swapTreshold;
536     uint256 public maxWallet;
537  
538     bool public limitsActive = true;
539     bool public shouldContractSellAll = false;
540 
541     uint256 public buyTotalFees;
542     uint256 public buyTreasuryFee;
543     uint256 public buyLiquidityFee;
544  
545     uint256 public sellTotalFees;
546     uint256 public sellTreasuryFee;
547     uint256 public sellLiquidityFee;
548  
549     uint256 public tokensForLiquidity;
550     uint256 public tokensForTreasury;
551    
552  
553     // block number of opened trading
554     uint256 launchedAt;
555  
556     /******************/
557  
558     // exclude from fees and max transaction amount
559     mapping (address => bool) private _isExcludedFromFees;
560     mapping (address => bool) public _isExcludedMaxTransactionAmount;
561  
562     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
563     // could be subject to a maximum transfer amount
564     mapping (address => bool) public automatedMarketMakerPairs;
565  
566     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
567  
568     event ExcludeFromFees(address indexed account, bool isExcluded);
569  
570     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
571  
572     event treasuryWalletUpdated(address indexed newWallet, address indexed oldWallet);
573  
574  
575     event SwapAndLiquify(
576         uint256 tokensSwapped,
577         uint256 ethReceived,
578         uint256 tokensIntoLiquidity
579     );
580 
581 
582  
583     event AutoNukeLP();
584  
585     event ManualNukeLP();
586  
587     constructor() ERC20(_name, _symbol) {
588  
589         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
590  
591         excludeFromMaxTransaction(address(_uniswapV2Router), true);
592         uniswapV2Router = _uniswapV2Router;
593  
594         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
595         excludeFromMaxTransaction(address(uniswapV2Pair), true);
596         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
597  
598         uint256 _buyTreasuryFee = 25;
599         uint256 _buyLiquidityFee = 0;
600  
601         uint256 _sellTreasuryFee = 85;
602         uint256 _sellLiquidityFee = 0;
603         
604         uint256 totalSupply = 100000000 * 1e18;
605  
606         maxTx = totalSupply * 20 / 1000; // 2%
607         maxWallet = totalSupply * 20 / 1000; // 2% 
608         swapTreshold = totalSupply * 1 / 1000; // 0.05%
609  
610         buyTreasuryFee = _buyTreasuryFee;
611         buyLiquidityFee = _buyLiquidityFee;
612         buyTotalFees = buyTreasuryFee + buyLiquidityFee;
613  
614         sellTreasuryFee = _sellTreasuryFee;
615         sellLiquidityFee = _sellLiquidityFee;
616         sellTotalFees = sellTreasuryFee + sellLiquidityFee;
617 
618         treasuryWallet = address(0x1Cf3C01C0Bc13BaeB4441cFe1a77704EC6493A63);
619        
620  
621         // exclude from paying fees or having max transaction amount
622         excludeFromFees(owner(), true);
623         excludeFromFees(address(this), true);
624         excludeFromFees(address(0xdead), true);
625         excludeFromFees(address(treasuryWallet), true);
626  
627         excludeFromMaxTransaction(owner(), true);
628         excludeFromMaxTransaction(address(this), true);
629         excludeFromMaxTransaction(address(0xdead), true);
630         excludeFromMaxTransaction(address(treasuryWallet), true);
631  
632         /*
633             _mint is an internal function in ERC20.sol that is only called here,
634             and CANNOT be called ever again
635         */
636 
637        
638         _mint(address(this), totalSupply);
639         
640     }
641  
642     receive() external payable {
643  
644     }
645  
646 
647     function TradingEnable() external onlyOwner{
648         
649         uint256 ethAmount = address(this).balance;
650         uint256 tokenAmount = balanceOf(address(this));
651         
652 
653       
654         _approve(address(this), address(uniswapV2Router), tokenAmount);
655 
656         uniswapV2Router.addLiquidityETH{value: ethAmount}(
657             address(this),
658             tokenAmount,
659                 0, // slippage is unavoidable
660                 0, // slippage is unavoidable
661             treasuryWallet,
662             block.timestamp
663         );
664     }
665 
666     function RemoveStuckEthereum() external onlyOwner {
667         uint256 ethBalance = address(this).balance;
668         require(ethBalance > 0, "ETH balance must be greater than 0");
669         (bool success,) = address(treasuryWallet).call{value: ethBalance}("");
670         require(success, "Failed to clear ETH balance");
671     }
672 
673     function RemoveStuckTokenBalance() external onlyOwner {
674         uint256 tokenBalance = balanceOf(address(this));
675         require(tokenBalance > 0, "Token balance must be greater than 0");
676         _transfer(address(this), treasuryWallet, tokenBalance);
677     }
678 
679     
680 
681     function removeLimits() external onlyOwner returns (bool){
682         limitsActive = false;
683         return true;
684     }
685  
686     function enableEmptyContract(bool enabled) external onlyOwner{
687         shouldContractSellAll = enabled;
688     }
689  
690      // change the minimum amount of tokens to sell from fees
691     function updateSwapTreshold(uint256 newAmount) external onlyOwner returns (bool){
692         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
693         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
694         swapTreshold = newAmount;
695         return true;
696     }
697  
698     function LiftMax(uint256 _maxTx, uint256 _maxWallet) external onlyOwner {
699         require(_maxTx >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
700         require(_maxWallet >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
701         maxTx = _maxTx * (10**18);
702         maxWallet = _maxWallet * (10**18);
703     }
704  
705     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
706         _isExcludedMaxTransactionAmount[updAds] = isEx;
707     }
708 
709   
710     function update(
711         uint256 _liquidityBuyFee,
712         uint256 _liquiditySellFee,
713         uint256 _treasuryBuyFee,
714         uint256 _treasurySellFee
715     ) external onlyOwner {
716         buyLiquidityFee = _liquidityBuyFee;
717         buyTreasuryFee = _treasuryBuyFee;
718         buyTotalFees = buyLiquidityFee + buyTreasuryFee;
719         sellLiquidityFee = _liquiditySellFee;
720         sellTreasuryFee = _treasurySellFee;
721         sellTotalFees = sellLiquidityFee + sellTreasuryFee;
722         require(buyTotalFees <= 30 && sellTotalFees <= 30, "Fees cannot be higher then 30%");
723     }
724 
725     function excludeFromFees(address account, bool excluded) public onlyOwner {
726         _isExcludedFromFees[account] = excluded;
727         emit ExcludeFromFees(account, excluded);
728     }
729  
730     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
731         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
732  
733         _setAutomatedMarketMakerPair(pair, value);
734     }
735  
736     function _setAutomatedMarketMakerPair(address pair, bool value) private {
737         automatedMarketMakerPairs[pair] = value;
738  
739         emit SetAutomatedMarketMakerPair(pair, value);
740     }
741 
742     function updateTreasuryAddress(address newTreasuryWallet) external onlyOwner{
743         emit treasuryWalletUpdated(newTreasuryWallet, treasuryWallet);
744         treasuryWallet = newTreasuryWallet;
745     }
746 
747  
748   
749     function isExcludedFromFees(address account) public view returns(bool) {
750         return _isExcludedFromFees[account];
751     }
752  
753     function _transfer(
754         address from,
755         address to,
756         uint256 amount
757     ) internal override {
758         require(from != address(0), "ERC20: transfer from the zero address");
759         require(to != address(0), "ERC20: transfer to the zero address");
760          if(amount == 0) {
761             super._transfer(from, to, 0);
762             return;
763         }
764  
765         if(limitsActive){
766             if (
767                 from != owner() &&
768                 to != owner() &&
769                 to != address(0) &&
770                 to != address(0xdead) &&
771                 !isSwapping
772             ){
773                 
774                 //when buy
775                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
776                         require(amount <= maxTx, "Buy transfer amount exceeds the maxTransactionAmount.");
777                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
778                 }
779  
780                 //when sell
781                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
782                         require(amount <= maxTx, "Sell transfer amount exceeds the maxTransactionAmount.");
783                 }
784                 else if(!_isExcludedMaxTransactionAmount[to]){
785                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
786                 }
787             }
788         }
789  
790         uint256 contractTokenBalance = balanceOf(address(this));
791  
792         bool canSwap = contractTokenBalance >= swapTreshold;
793  
794         if( 
795             canSwap &&
796             !isSwapping &&
797             !automatedMarketMakerPairs[from] &&
798             !_isExcludedFromFees[from] &&
799             !_isExcludedFromFees[to]
800         ) {
801             isSwapping = true;
802  
803             swapBack();
804  
805             isSwapping = false;
806         }
807  
808         bool takeFee = !isSwapping;
809  
810         // if any account belongs to _isExcludedFromFee account then remove the fee
811         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
812             takeFee = false;
813         }
814  
815         uint256 fees = 0;
816         // only take fees on buys/sells, do not take on wallet transfers
817         if(takeFee){
818             // on sell
819             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
820                 fees = amount.mul(sellTotalFees).div(100);
821                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
822                 tokensForTreasury += fees * sellTreasuryFee / sellTotalFees;
823             }
824             // on buy
825             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
826                 fees = amount.mul(buyTotalFees).div(100);
827                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
828                 tokensForTreasury += fees * buyTreasuryFee / buyTotalFees;
829             }
830  
831             if(fees > 0){    
832                 super._transfer(from, address(this), fees);
833             }
834  
835             amount -= fees;
836         }
837  
838         super._transfer(from, to, amount);
839     }
840  
841     function swapTokensForEth(uint256 tokenAmount) private {
842  
843         // generate the uniswap pair path of token -> weth
844         address[] memory path = new address[](2);
845         path[0] = address(this);
846         path[1] = uniswapV2Router.WETH();
847  
848         _approve(address(this), address(uniswapV2Router), tokenAmount);
849  
850         // make the swap
851         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
852             tokenAmount,
853             0, // accept any amount of ETH
854             path,
855             address(this),
856             block.timestamp
857         );
858  
859     }
860  
861     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
862         // approve token transfer to cover all possible scenarios
863         _approve(address(this), address(uniswapV2Router), tokenAmount);
864  
865         // add the liquidity
866         uniswapV2Router.addLiquidityETH{value: ethAmount}(
867             address(this),
868             tokenAmount,
869             0, // slippage is unavoidable
870             0, // slippage is unavoidable
871             address(this),
872             block.timestamp
873         );
874     }
875  
876     function swapBack() private {
877         uint256 contractBalance = balanceOf(address(this));
878         uint256 totalTokensToSwap = tokensForLiquidity + tokensForTreasury;
879         bool success;
880  
881         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
882  
883         if(shouldContractSellAll == false){
884             if(contractBalance > swapTreshold * 20){
885                 contractBalance = swapTreshold * 20;
886             }
887         }else{
888             contractBalance = balanceOf(address(this));
889         }
890         
891  
892         // Halve the amount of liquidity tokens
893         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
894         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
895  
896         uint256 initialETHBalance = address(this).balance;
897  
898         swapTokensForEth(amountToSwapForETH); 
899  
900         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
901  
902         uint256 ethForMarketing = ethBalance.mul(tokensForTreasury).div(totalTokensToSwap);
903         uint256 ethForLiquidity = ethBalance - ethForMarketing;
904  
905  
906         tokensForLiquidity = 0;
907         tokensForTreasury = 0;
908  
909         if(liquidityTokens > 0 && ethForLiquidity > 0){
910             addLiquidity(liquidityTokens, ethForLiquidity);
911             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
912         }
913  
914         (success,) = address(treasuryWallet).call{value: address(this).balance}("");
915     }
916 }