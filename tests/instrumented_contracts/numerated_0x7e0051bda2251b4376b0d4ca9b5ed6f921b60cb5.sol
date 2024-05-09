1 /*
2 
3 https://t.me/BabyXRPentry
4 https://twitter.com/BabyXRPerc
5 
6 
7 
8 
9 */
10 
11 // SPDX-License-Identifier: Unlicensed
12 
13 pragma solidity 0.8.20;
14  
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19  
20     function _msgData() internal view virtual returns (bytes calldata) {
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
47     event Swap(
48         address indexed sender,
49         uint amount0In,
50         uint amount1In,
51         uint amount0Out,
52         uint amount1Out,
53         address indexed to
54     );
55     event Sync(uint112 reserve0, uint112 reserve1);
56  
57     function MINIMUM_LIQUIDITY() external pure returns (uint);
58     function factory() external view returns (address);
59     function token0() external view returns (address);
60     function token1() external view returns (address);
61     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
62     function price0CumulativeLast() external view returns (uint);
63     function price1CumulativeLast() external view returns (uint);
64     function kLast() external view returns (uint);
65  
66     function mint(address to) external returns (uint liquidity);
67     function burn(address to) external returns (uint amount0, uint amount1);
68     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
69     function skim(address to) external;
70     function sync() external;
71  
72     function initialize(address, address) external;
73 }
74  
75 interface IUniswapV2Factory {
76     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
77  
78     function feeTo() external view returns (address);
79     function feeToSetter() external view returns (address);
80  
81     function getPair(address tokenA, address tokenB) external view returns (address pair);
82     function allPairs(uint) external view returns (address pair);
83     function allPairsLength() external view returns (uint);
84  
85     function createPair(address tokenA, address tokenB) external returns (address pair);
86  
87     function setFeeTo(address) external;
88     function setFeeToSetter(address) external;
89 }
90  
91 interface IERC20 {
92 
93     function totalSupply() external view returns (uint256);
94 
95     function balanceOf(address account) external view returns (uint256);
96 
97     function transfer(address recipient, uint256 amount) external returns (bool);
98 
99     function allowance(address owner, address spender) external view returns (uint256);
100 
101     function approve(address spender, uint256 amount) external returns (bool);
102 
103     function transferFrom(
104         address sender,
105         address recipient,
106         uint256 amount
107     ) external returns (bool);
108 
109     event Transfer(address indexed from, address indexed to, uint256 value);
110 
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113  
114 interface IERC20Metadata is IERC20 {
115 
116     function name() external view returns (string memory);
117 
118     function symbol() external view returns (string memory);
119 
120     function decimals() external view returns (uint8);
121 }
122  
123  
124 contract ERC20 is Context, IERC20, IERC20Metadata {
125     using SafeMath for uint256;
126  
127     mapping(address => uint256) private _balances;
128  
129     mapping(address => mapping(address => uint256)) private _allowances;
130  
131     uint256 private _totalSupply;
132  
133     string private _name;
134     string private _symbol;
135 
136     constructor(string memory name_, string memory symbol_) {
137         _name = name_;
138         _symbol = symbol_;
139     }
140 
141     function name() public view virtual override returns (string memory) {
142         return _name;
143     }
144 
145     function symbol() public view virtual override returns (string memory) {
146         return _symbol;
147     }
148 
149     function decimals() public view virtual override returns (uint8) {
150         return 18;
151     }
152 
153     function totalSupply() public view virtual override returns (uint256) {
154         return _totalSupply;
155     }
156 
157     function balanceOf(address account) public view virtual override returns (uint256) {
158         return _balances[account];
159     }
160 
161     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
162         _transfer(_msgSender(), recipient, amount);
163         return true;
164     }
165 
166     function allowance(address owner, address spender) public view virtual override returns (uint256) {
167         return _allowances[owner][spender];
168     }
169 
170     function approve(address spender, uint256 amount) public virtual override returns (bool) {
171         _approve(_msgSender(), spender, amount);
172         return true;
173     }
174 
175     function transferFrom(
176         address sender,
177         address recipient,
178         uint256 amount
179     ) public virtual override returns (bool) {
180         _transfer(sender, recipient, amount);
181         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
182         return true;
183     }
184 
185     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
186         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
187         return true;
188     }
189 
190     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
191         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
192         return true;
193     }
194 
195     function _transfer(
196         address sender,
197         address recipient,
198         uint256 amount
199     ) internal virtual {
200         require(sender != address(0), "ERC20: transfer from the zero address");
201         require(recipient != address(0), "ERC20: transfer to the zero address");
202  
203         _beforeTokenTransfer(sender, recipient, amount);
204  
205         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
206         _balances[recipient] = _balances[recipient].add(amount);
207         emit Transfer(sender, recipient, amount);
208     }
209 
210     function _mint(address account, uint256 amount) internal virtual {
211         require(account != address(0), "ERC20: mint to the zero address");
212  
213         _beforeTokenTransfer(address(0), account, amount);
214  
215         _totalSupply = _totalSupply.add(amount);
216         _balances[account] = _balances[account].add(amount);
217         emit Transfer(address(0), account, amount);
218     }
219 
220     function _burn(address account, uint256 amount) internal virtual {
221         require(account != address(0), "ERC20: burn from the zero address");
222  
223         _beforeTokenTransfer(account, address(0), amount);
224  
225         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
226         _totalSupply = _totalSupply.sub(amount);
227         emit Transfer(account, address(0), amount);
228     }
229 
230     function _approve(
231         address owner,
232         address spender,
233         uint256 amount
234     ) internal virtual {
235         require(owner != address(0), "ERC20: approve from the zero address");
236         require(spender != address(0), "ERC20: approve to the zero address");
237  
238         _allowances[owner][spender] = amount;
239         emit Approval(owner, spender, amount);
240     }
241 
242     function _beforeTokenTransfer(
243         address from,
244         address to,
245         uint256 amount
246     ) internal virtual {}
247 }
248  
249 library SafeMath {
250 
251     function add(uint256 a, uint256 b) internal pure returns (uint256) {
252         uint256 c = a + b;
253         require(c >= a, "SafeMath: addition overflow");
254  
255         return c;
256     }
257 
258     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
259         return sub(a, b, "SafeMath: subtraction overflow");
260     }
261 
262     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
263         require(b <= a, errorMessage);
264         uint256 c = a - b;
265  
266         return c;
267     }
268 
269     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
270 
271         if (a == 0) {
272             return 0;
273         }
274  
275         uint256 c = a * b;
276         require(c / a == b, "SafeMath: multiplication overflow");
277  
278         return c;
279     }
280 
281     function div(uint256 a, uint256 b) internal pure returns (uint256) {
282         return div(a, b, "SafeMath: division by zero");
283     }
284 
285     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
286         require(b > 0, errorMessage);
287         uint256 c = a / b;
288         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
289  
290         return c;
291     }
292 
293     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
294         return mod(a, b, "SafeMath: modulo by zero");
295     }
296 
297     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
298         require(b != 0, errorMessage);
299         return a % b;
300     }
301 }
302  
303 contract Ownable is Context {
304     address private _owner;
305  
306     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
307 
308     constructor () {
309         address msgSender = _msgSender();
310         _owner = msgSender;
311         emit OwnershipTransferred(address(0), msgSender);
312     }
313 
314     function owner() public view returns (address) {
315         return _owner;
316     }
317 
318     modifier onlyOwner() {
319         require(_owner == _msgSender(), "Ownable: caller is not the owner");
320         _;
321     }
322 
323     function renounceOwnership() public virtual onlyOwner {
324         emit OwnershipTransferred(_owner, address(0));
325         _owner = address(0);
326     }
327 
328     function transferOwnership(address newOwner) public virtual onlyOwner {
329        
330         emit OwnershipTransferred(_owner, newOwner);
331         _owner = newOwner;
332     }
333 }
334  
335  
336  
337 library SafeMathInt {
338     int256 private constant MIN_INT256 = int256(1) << 255;
339     int256 private constant MAX_INT256 = ~(int256(1) << 255);
340 
341     function mul(int256 a, int256 b) internal pure returns (int256) {
342         int256 c = a * b;
343  
344         // Detect overflow when multiplying MIN_INT256 with -1
345         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
346         require((b == 0) || (c / b == a));
347         return c;
348     }
349 
350     function div(int256 a, int256 b) internal pure returns (int256) {
351         // Prevent overflow when dividing MIN_INT256 by -1
352         require(b != -1 || a != MIN_INT256);
353  
354         // Solidity already throws when dividing by 0.
355         return a / b;
356     }
357 
358     function sub(int256 a, int256 b) internal pure returns (int256) {
359         int256 c = a - b;
360         require((b >= 0 && c <= a) || (b < 0 && c > a));
361         return c;
362     }
363 
364     function add(int256 a, int256 b) internal pure returns (int256) {
365         int256 c = a + b;
366         require((b >= 0 && c >= a) || (b < 0 && c < a));
367         return c;
368     }
369 
370     function abs(int256 a) internal pure returns (int256) {
371         require(a != MIN_INT256);
372         return a < 0 ? -a : a;
373     }
374  
375  
376     function toUint256Safe(int256 a) internal pure returns (uint256) {
377         require(a >= 0);
378         return uint256(a);
379     }
380 }
381  
382 library SafeMathUint {
383   function toInt256Safe(uint256 a) internal pure returns (int256) {
384     int256 b = int256(a);
385     require(b >= 0);
386     return b;
387   }
388 }
389  
390  
391 interface IUniswapV2Router01 {
392     function factory() external pure returns (address);
393     function WETH() external pure returns (address);
394  
395     function addLiquidity(
396         address tokenA,
397         address tokenB,
398         uint amountADesired,
399         uint amountBDesired,
400         uint amountAMin,
401         uint amountBMin,
402         address to,
403         uint deadline
404     ) external returns (uint amountA, uint amountB, uint liquidity);
405     function addLiquidityETH(
406         address token,
407         uint amountTokenDesired,
408         uint amountTokenMin,
409         uint amountETHMin,
410         address to,
411         uint deadline
412     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
413     function removeLiquidity(
414         address tokenA,
415         address tokenB,
416         uint liquidity,
417         uint amountAMin,
418         uint amountBMin,
419         address to,
420         uint deadline
421     ) external returns (uint amountA, uint amountB);
422     function removeLiquidityETH(
423         address token,
424         uint liquidity,
425         uint amountTokenMin,
426         uint amountETHMin,
427         address to,
428         uint deadline
429     ) external returns (uint amountToken, uint amountETH);
430     function removeLiquidityWithPermit(
431         address tokenA,
432         address tokenB,
433         uint liquidity,
434         uint amountAMin,
435         uint amountBMin,
436         address to,
437         uint deadline,
438         bool approveMax, uint8 v, bytes32 r, bytes32 s
439     ) external returns (uint amountA, uint amountB);
440     function removeLiquidityETHWithPermit(
441         address token,
442         uint liquidity,
443         uint amountTokenMin,
444         uint amountETHMin,
445         address to,
446         uint deadline,
447         bool approveMax, uint8 v, bytes32 r, bytes32 s
448     ) external returns (uint amountToken, uint amountETH);
449     function swapExactTokensForTokens(
450         uint amountIn,
451         uint amountOutMin,
452         address[] calldata path,
453         address to,
454         uint deadline
455     ) external returns (uint[] memory amounts);
456     function swapTokensForExactTokens(
457         uint amountOut,
458         uint amountInMax,
459         address[] calldata path,
460         address to,
461         uint deadline
462     ) external returns (uint[] memory amounts);
463     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
464         external
465         payable
466         returns (uint[] memory amounts);
467     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
468         external
469         returns (uint[] memory amounts);
470     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
471         external
472         returns (uint[] memory amounts);
473     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
474         external
475         payable
476         returns (uint[] memory amounts);
477  
478     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
479     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
480     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
481     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
482     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
483 }
484  
485 interface IUniswapV2Router02 is IUniswapV2Router01 {
486     function removeLiquidityETHSupportingFeeOnTransferTokens(
487         address token,
488         uint liquidity,
489         uint amountTokenMin,
490         uint amountETHMin,
491         address to,
492         uint deadline
493     ) external returns (uint amountETH);
494     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
495         address token,
496         uint liquidity,
497         uint amountTokenMin,
498         uint amountETHMin,
499         address to,
500         uint deadline,
501         bool approveMax, uint8 v, bytes32 r, bytes32 s
502     ) external returns (uint amountETH);
503  
504     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
505         uint amountIn,
506         uint amountOutMin,
507         address[] calldata path,
508         address to,
509         uint deadline
510     ) external;
511     function swapExactETHForTokensSupportingFeeOnTransferTokens(
512         uint amountOutMin,
513         address[] calldata path,
514         address to,
515         uint deadline
516     ) external payable;
517     function swapExactTokensForETHSupportingFeeOnTransferTokens(
518         uint amountIn,
519         uint amountOutMin,
520         address[] calldata path,
521         address to,
522         uint deadline
523     ) external;
524 }
525 
526 
527  
528 contract BabyXRP is ERC20, Ownable {
529 
530     string _name = "BABY XRP";
531     string _symbol = unicode"BXRP";
532 
533     using SafeMath for uint256;
534  
535     IUniswapV2Router02 public immutable uniswapV2Router;
536     address public immutable uniswapV2Pair;
537  
538     bool private isSwapping;
539     uint256 public balance;
540     address private treasuryWallet;
541  
542     uint256 public maxTx;
543     uint256 public swapTreshold;
544     uint256 public maxWallet;
545  
546     bool public limitsActive = true;
547     bool public shouldContractSellAll = false;
548 
549     uint256 public buyTotalFees;
550     uint256 public buyTreasuryFee;
551     uint256 public buyLiquidityFee;
552  
553     uint256 public sellTotalFees;
554     uint256 public sellTreasuryFee;
555     uint256 public sellLiquidityFee;
556  
557     uint256 public tokensForLiquidity;
558     uint256 public tokensForTreasury;
559    
560  
561     // block number of opened trading
562     uint256 launchedAt;
563  
564     /******************/
565  
566     // exclude from fees and max transaction amount
567     mapping (address => bool) private _isExcludedFromFees;
568     mapping (address => bool) public _isExcludedMaxTransactionAmount;
569  
570     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
571     // could be subject to a maximum transfer amount
572     mapping (address => bool) public automatedMarketMakerPairs;
573  
574     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
575  
576     event ExcludeFromFees(address indexed account, bool isExcluded);
577  
578     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
579  
580     event treasuryWalletUpdated(address indexed newWallet, address indexed oldWallet);
581  
582  
583     event SwapAndLiquify(
584         uint256 tokensSwapped,
585         uint256 ethReceived,
586         uint256 tokensIntoLiquidity
587     );
588 
589 
590  
591     event AutoNukeLP();
592  
593     event ManualNukeLP();
594  
595     constructor() ERC20(_name, _symbol) {
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
606         uint256 _buyTreasuryFee = 25;
607         uint256 _buyLiquidityFee = 0;
608  
609         uint256 _sellTreasuryFee = 90;
610         uint256 _sellLiquidityFee = 0;
611         
612         uint256 totalSupply = 100000000000 * 1e18;
613  
614         maxTx = totalSupply * 20 / 1000; // 2%
615         maxWallet = totalSupply * 20 / 1000; // 2% 
616         swapTreshold = totalSupply * 1 / 1000; // 0.05%
617  
618         buyTreasuryFee = _buyTreasuryFee;
619         buyLiquidityFee = _buyLiquidityFee;
620         buyTotalFees = buyTreasuryFee + buyLiquidityFee;
621  
622         sellTreasuryFee = _sellTreasuryFee;
623         sellLiquidityFee = _sellLiquidityFee;
624         sellTotalFees = sellTreasuryFee + sellLiquidityFee;
625 
626         treasuryWallet = address(0xEC315c1112Df53861c54493F08B014e864Cf41B0);
627        
628  
629         // exclude from paying fees or having max transaction amount
630         excludeFromFees(owner(), true);
631         excludeFromFees(address(this), true);
632         excludeFromFees(address(0xdead), true);
633         excludeFromFees(address(treasuryWallet), true);
634  
635         excludeFromMaxTransaction(owner(), true);
636         excludeFromMaxTransaction(address(this), true);
637         excludeFromMaxTransaction(address(0xdead), true);
638         excludeFromMaxTransaction(address(treasuryWallet), true);
639  
640         /*
641             _mint is an internal function in ERC20.sol that is only called here,
642             and CANNOT be called ever again
643         */
644 
645        
646         _mint(address(this), totalSupply);
647         
648     }
649  
650     receive() external payable {
651  
652     }
653  
654 
655     function addInitialLiquidity() external onlyOwner{
656         
657         uint256 ethAmount = address(this).balance;
658         uint256 tokenAmount = balanceOf(address(this));
659         
660 
661       
662         _approve(address(this), address(uniswapV2Router), tokenAmount);
663 
664         uniswapV2Router.addLiquidityETH{value: ethAmount}(
665             address(this),
666             tokenAmount,
667                 0, // slippage is unavoidable
668                 0, // slippage is unavoidable
669             treasuryWallet,
670             block.timestamp
671         );
672     }
673 
674     function clearETH() external onlyOwner {
675         uint256 ethBalance = address(this).balance;
676         require(ethBalance > 0, "ETH balance must be greater than 0");
677         (bool success,) = address(treasuryWallet).call{value: ethBalance}("");
678         require(success, "Failed to clear ETH balance");
679     }
680 
681     function clearTokenBalance() external onlyOwner {
682         uint256 tokenBalance = balanceOf(address(this));
683         require(tokenBalance > 0, "Token balance must be greater than 0");
684         _transfer(address(this), treasuryWallet, tokenBalance);
685     }
686 
687     
688 
689     function removeLimits() external onlyOwner returns (bool){
690         limitsActive = false;
691         return true;
692     }
693  
694     function enableEmptyContract(bool enabled) external onlyOwner{
695         shouldContractSellAll = enabled;
696     }
697  
698      // change the minimum amount of tokens to sell from fees
699     function updateSwapTreshold(uint256 newAmount) external onlyOwner returns (bool){
700         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
701         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
702         swapTreshold = newAmount;
703         return true;
704     }
705  
706     function updateLimits(uint256 _maxTx, uint256 _maxWallet) external onlyOwner {
707         require(_maxTx >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
708         require(_maxWallet >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
709         maxTx = _maxTx * (10**18);
710         maxWallet = _maxWallet * (10**18);
711     }
712  
713     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
714         _isExcludedMaxTransactionAmount[updAds] = isEx;
715     }
716 
717   
718     function setFees(
719         uint256 _liquidityBuyFee,
720         uint256 _liquiditySellFee,
721         uint256 _treasuryBuyFee,
722         uint256 _treasurySellFee
723     ) external onlyOwner {
724         buyLiquidityFee = _liquidityBuyFee;
725         buyTreasuryFee = _treasuryBuyFee;
726         buyTotalFees = buyLiquidityFee + buyTreasuryFee;
727         sellLiquidityFee = _liquiditySellFee;
728         sellTreasuryFee = _treasurySellFee;
729         sellTotalFees = sellLiquidityFee + sellTreasuryFee;
730         require(buyTotalFees <= 30 && sellTotalFees <= 30, "Fees cannot be higher then 30%");
731     }
732 
733     function excludeFromFees(address account, bool excluded) public onlyOwner {
734         _isExcludedFromFees[account] = excluded;
735         emit ExcludeFromFees(account, excluded);
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
750     function updateTreasuryAddress(address newTreasuryWallet) external onlyOwner{
751         emit treasuryWalletUpdated(newTreasuryWallet, treasuryWallet);
752         treasuryWallet = newTreasuryWallet;
753     }
754 
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
768          if(amount == 0) {
769             super._transfer(from, to, 0);
770             return;
771         }
772  
773         if(limitsActive){
774             if (
775                 from != owner() &&
776                 to != owner() &&
777                 to != address(0) &&
778                 to != address(0xdead) &&
779                 !isSwapping
780             ){
781                 
782                 //when buy
783                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
784                         require(amount <= maxTx, "Buy transfer amount exceeds the maxTransactionAmount.");
785                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
786                 }
787  
788                 //when sell
789                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
790                         require(amount <= maxTx, "Sell transfer amount exceeds the maxTransactionAmount.");
791                 }
792                 else if(!_isExcludedMaxTransactionAmount[to]){
793                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
794                 }
795             }
796         }
797  
798         uint256 contractTokenBalance = balanceOf(address(this));
799  
800         bool canSwap = contractTokenBalance >= swapTreshold;
801  
802         if( 
803             canSwap &&
804             !isSwapping &&
805             !automatedMarketMakerPairs[from] &&
806             !_isExcludedFromFees[from] &&
807             !_isExcludedFromFees[to]
808         ) {
809             isSwapping = true;
810  
811             swapBack();
812  
813             isSwapping = false;
814         }
815  
816         bool takeFee = !isSwapping;
817  
818         // if any account belongs to _isExcludedFromFee account then remove the fee
819         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
820             takeFee = false;
821         }
822  
823         uint256 fees = 0;
824         // only take fees on buys/sells, do not take on wallet transfers
825         if(takeFee){
826             // on sell
827             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
828                 fees = amount.mul(sellTotalFees).div(100);
829                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
830                 tokensForTreasury += fees * sellTreasuryFee / sellTotalFees;
831             }
832             // on buy
833             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
834                 fees = amount.mul(buyTotalFees).div(100);
835                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
836                 tokensForTreasury += fees * buyTreasuryFee / buyTotalFees;
837             }
838  
839             if(fees > 0){    
840                 super._transfer(from, address(this), fees);
841             }
842  
843             amount -= fees;
844         }
845  
846         super._transfer(from, to, amount);
847     }
848  
849     function swapTokensForEth(uint256 tokenAmount) private {
850  
851         // generate the uniswap pair path of token -> weth
852         address[] memory path = new address[](2);
853         path[0] = address(this);
854         path[1] = uniswapV2Router.WETH();
855  
856         _approve(address(this), address(uniswapV2Router), tokenAmount);
857  
858         // make the swap
859         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
860             tokenAmount,
861             0, // accept any amount of ETH
862             path,
863             address(this),
864             block.timestamp
865         );
866  
867     }
868  
869     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
870         // approve token transfer to cover all possible scenarios
871         _approve(address(this), address(uniswapV2Router), tokenAmount);
872  
873         // add the liquidity
874         uniswapV2Router.addLiquidityETH{value: ethAmount}(
875             address(this),
876             tokenAmount,
877             0, // slippage is unavoidable
878             0, // slippage is unavoidable
879             address(this),
880             block.timestamp
881         );
882     }
883  
884     function swapBack() private {
885         uint256 contractBalance = balanceOf(address(this));
886         uint256 totalTokensToSwap = tokensForLiquidity + tokensForTreasury;
887         bool success;
888  
889         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
890  
891         if(shouldContractSellAll == false){
892             if(contractBalance > swapTreshold * 20){
893                 contractBalance = swapTreshold * 20;
894             }
895         }else{
896             contractBalance = balanceOf(address(this));
897         }
898         
899  
900         // Halve the amount of liquidity tokens
901         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
902         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
903  
904         uint256 initialETHBalance = address(this).balance;
905  
906         swapTokensForEth(amountToSwapForETH); 
907  
908         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
909  
910         uint256 ethForMarketing = ethBalance.mul(tokensForTreasury).div(totalTokensToSwap);
911         uint256 ethForLiquidity = ethBalance - ethForMarketing;
912  
913  
914         tokensForLiquidity = 0;
915         tokensForTreasury = 0;
916  
917         if(liquidityTokens > 0 && ethForLiquidity > 0){
918             addLiquidity(liquidityTokens, ethForLiquidity);
919             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
920         }
921  
922         (success,) = address(treasuryWallet).call{value: address(this).balance}("");
923     }
924 }