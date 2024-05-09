1 /*
2 https://twitter.com/BananaKillerETH
3 
4 https://t.me/BananaKillerETH
5 */
6 
7 // SPDX-License-Identifier: Unlicensed
8 
9 pragma solidity 0.8.21;
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
243     
244 }
245  
246 library SafeMath {
247 
248     function add(uint256 a, uint256 b) internal pure returns (uint256) {
249         uint256 c = a + b;
250         require(c >= a, "SafeMath: addition overflow");
251  
252         return c;
253     }
254 
255     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
256         return sub(a, b, "SafeMath: subtraction overflow");
257     }
258 
259     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
260         require(b <= a, errorMessage);
261         uint256 c = a - b;
262  
263         return c;
264     }
265 
266     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
267 
268         if (a == 0) {
269             return 0;
270         }
271  
272         uint256 c = a * b;
273         require(c / a == b, "SafeMath: multiplication overflow");
274  
275         return c;
276     }
277 
278     function div(uint256 a, uint256 b) internal pure returns (uint256) {
279         return div(a, b, "SafeMath: division by zero");
280     }
281 
282     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
283         require(b > 0, errorMessage);
284         uint256 c = a / b;
285         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
286  
287         return c;
288     }
289 
290     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
291         return mod(a, b, "SafeMath: modulo by zero");
292     }
293 
294     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
295         require(b != 0, errorMessage);
296         return a % b;
297     }
298 }
299  
300 contract Ownable is Context {
301     address private _owner;
302  
303     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
304 
305     constructor () {
306         address msgSender = _msgSender();
307         _owner = msgSender;
308         emit OwnershipTransferred(address(0), msgSender);
309     }
310 
311     function owner() public view returns (address) {
312         return _owner;
313     }
314 
315     modifier onlyOwner() {
316         require(_owner == _msgSender(), "Ownable: caller is not the owner");
317         _;
318     }
319 
320     function renounceOwnership() public virtual onlyOwner {
321         emit OwnershipTransferred(_owner, address(0));
322         _owner = address(0);
323     }
324 
325     function transferOwnership(address newOwner) public virtual onlyOwner {
326        
327         emit OwnershipTransferred(_owner, newOwner);
328         _owner = newOwner;
329     }
330 }
331  
332  
333  
334 library SafeMathInt {
335     int256 private constant MIN_INT256 = int256(1) << 255;
336     int256 private constant MAX_INT256 = ~(int256(1) << 255);
337 
338     function mul(int256 a, int256 b) internal pure returns (int256) {
339         int256 c = a * b;
340  
341         // Detect overflow when multiplying MIN_INT256 with -1
342         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
343         require((b == 0) || (c / b == a));
344         return c;
345     }
346 
347     function div(int256 a, int256 b) internal pure returns (int256) {
348         // Prevent overflow when dividing MIN_INT256 by -1
349         require(b != -1 || a != MIN_INT256);
350  
351         // Solidity already throws when dividing by 0.
352         return a / b;
353     }
354 
355     function sub(int256 a, int256 b) internal pure returns (int256) {
356         int256 c = a - b;
357         require((b >= 0 && c <= a) || (b < 0 && c > a));
358         return c;
359     }
360 
361     function add(int256 a, int256 b) internal pure returns (int256) {
362         int256 c = a + b;
363         require((b >= 0 && c >= a) || (b < 0 && c < a));
364         return c;
365     }
366 
367     function abs(int256 a) internal pure returns (int256) {
368         require(a != MIN_INT256);
369         return a < 0 ? -a : a;
370     }
371  
372  
373     function toUint256Safe(int256 a) internal pure returns (uint256) {
374         require(a >= 0);
375         return uint256(a);
376     }
377 }
378  
379 library SafeMathUint {
380   function toInt256Safe(uint256 a) internal pure returns (int256) {
381     int256 b = int256(a);
382     require(b >= 0);
383     return b;
384   }
385 }
386  
387  
388 interface IUniswapV2Router01 {
389     function factory() external pure returns (address);
390     function WETH() external pure returns (address);
391  
392     function addLiquidity(
393         address tokenA,
394         address tokenB,
395         uint amountADesired,
396         uint amountBDesired,
397         uint amountAMin,
398         uint amountBMin,
399         address to,
400         uint deadline
401     ) external returns (uint amountA, uint amountB, uint liquidity);
402     function addLiquidityETH(
403         address token,
404         uint amountTokenDesired,
405         uint amountTokenMin,
406         uint amountETHMin,
407         address to,
408         uint deadline
409     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
410     function removeLiquidity(
411         address tokenA,
412         address tokenB,
413         uint liquidity,
414         uint amountAMin,
415         uint amountBMin,
416         address to,
417         uint deadline
418     ) external returns (uint amountA, uint amountB);
419     function removeLiquidityETH(
420         address token,
421         uint liquidity,
422         uint amountTokenMin,
423         uint amountETHMin,
424         address to,
425         uint deadline
426     ) external returns (uint amountToken, uint amountETH);
427     function removeLiquidityWithPermit(
428         address tokenA,
429         address tokenB,
430         uint liquidity,
431         uint amountAMin,
432         uint amountBMin,
433         address to,
434         uint deadline,
435         bool approveMax, uint8 v, bytes32 r, bytes32 s
436     ) external returns (uint amountA, uint amountB);
437     function removeLiquidityETHWithPermit(
438         address token,
439         uint liquidity,
440         uint amountTokenMin,
441         uint amountETHMin,
442         address to,
443         uint deadline,
444         bool approveMax, uint8 v, bytes32 r, bytes32 s
445     ) external returns (uint amountToken, uint amountETH);
446     function swapExactTokensForTokens(
447         uint amountIn,
448         uint amountOutMin,
449         address[] calldata path,
450         address to,
451         uint deadline
452     ) external returns (uint[] memory amounts);
453     function swapTokensForExactTokens(
454         uint amountOut,
455         uint amountInMax,
456         address[] calldata path,
457         address to,
458         uint deadline
459     ) external returns (uint[] memory amounts);
460     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
461         external
462         payable
463         returns (uint[] memory amounts);
464     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
465         external
466         returns (uint[] memory amounts);
467     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
468         external
469         returns (uint[] memory amounts);
470     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
471         external
472         payable
473         returns (uint[] memory amounts);
474  
475     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
476     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
477     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
478     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
479     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
480 }
481  
482 interface IUniswapV2Router02 is IUniswapV2Router01 {
483     function removeLiquidityETHSupportingFeeOnTransferTokens(
484         address token,
485         uint liquidity,
486         uint amountTokenMin,
487         uint amountETHMin,
488         address to,
489         uint deadline
490     ) external returns (uint amountETH);
491     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
492         address token,
493         uint liquidity,
494         uint amountTokenMin,
495         uint amountETHMin,
496         address to,
497         uint deadline,
498         bool approveMax, uint8 v, bytes32 r, bytes32 s
499     ) external returns (uint amountETH);
500  
501     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
502         uint amountIn,
503         uint amountOutMin,
504         address[] calldata path,
505         address to,
506         uint deadline
507     ) external;
508     function swapExactETHForTokensSupportingFeeOnTransferTokens(
509         uint amountOutMin,
510         address[] calldata path,
511         address to,
512         uint deadline
513     ) external payable;
514     function swapExactTokensForETHSupportingFeeOnTransferTokens(
515         uint amountIn,
516         uint amountOutMin,
517         address[] calldata path,
518         address to,
519         uint deadline
520     ) external;
521 }
522 
523 
524  
525 contract BananaKiller is ERC20, Ownable {
526 
527     string _name = unicode"Banana Killer";
528     string _symbol = unicode"APPLE";
529 
530     using SafeMath for uint256;
531  
532     IUniswapV2Router02 public uniswapV2Router;
533     address public uniswapV2Pair;
534  
535     bool private isSwppable;
536     uint256 public balance;
537     address private devWallet;
538  
539     uint256 public maxTransaction;
540     uint256 public contractSellTreshold;
541     uint256 public maxWalletHolding;
542  
543     bool public areLimitsOn = true;
544     bool public emptyContractFull = false;
545 
546     uint256 public totalBuyTax;
547     uint256 public devBuyTax;
548     uint256 public liqBuyTax;
549  
550     uint256 public totalSellTax;
551     uint256 public devSellTax;
552     uint256 public liqSellTax;
553  
554     uint256 public tokensForLiquidity;
555     uint256 public tokensForDev;
556    
557  
558     // block number of opened trading
559     uint256 launchedAt;
560  
561     /******************/
562  
563     // exclude from fees and max transaction amount
564     mapping (address => bool) private _isExcludedFromFees;
565     mapping (address => bool) public _isExcludedMaxTransactionAmount;
566  
567     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
568     // could be subject to a maximum transfer amount
569     mapping (address => bool) public automatedMarketMakerPairs;
570  
571     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
572  
573     event ExcludeFromFees(address indexed account, bool isExcluded);
574  
575     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
576  
577     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
578  
579  
580     event SwapAndLiquify(
581         uint256 tokensSwapped,
582         uint256 ethReceived,
583         uint256 tokensIntoLiquidity
584     );
585 
586 
587  
588     event AutoNukeLP();
589  
590     event ManualNukeLP();
591  
592     constructor() ERC20(_name, _symbol) {
593  
594        
595  
596         uint256 _devBuyTax = 20;
597         uint256 _liqBuyTax = 0;
598  
599         uint256 _devSellTax = 30;
600         uint256 _liqSellTax = 0;
601         
602         uint256 totalSupply = 1000000000000 * 1e18;
603  
604         maxTransaction = totalSupply * 10 / 1000; // 2%
605         maxWalletHolding = totalSupply * 10 / 1000; // 2% 
606         contractSellTreshold = totalSupply * 1 / 1000; // 0.05%
607  
608         devBuyTax = _devBuyTax;
609         liqBuyTax = _liqBuyTax;
610         totalBuyTax = devBuyTax + liqBuyTax;
611  
612         devSellTax = _devSellTax;
613         liqSellTax = _liqSellTax;
614         totalSellTax = devSellTax + liqSellTax;
615         devWallet = address(msg.sender);
616        
617  
618         // exclude from paying fees or having max transaction amount
619         excludeFromFees(owner(), true);
620         excludeFromFees(address(this), true);
621         excludeFromFees(address(0xdead), true);
622         excludeFromFees(address(devWallet), true);
623  
624         excludeFromMaxTransaction(owner(), true);
625         excludeFromMaxTransaction(address(this), true);
626         excludeFromMaxTransaction(address(0xdead), true);
627         excludeFromMaxTransaction(address(devWallet), true);
628  
629         /*
630             _mint is an internal function in ERC20.sol that is only called here,
631             and CANNOT be called ever again
632         */
633 
634        
635         _mint(address(this), totalSupply * 96/ 100);
636         _mint(msg.sender, totalSupply * 4 / 100);
637         
638         
639     }
640  
641     receive() external payable {
642  
643     }
644  
645 
646     function complete() external onlyOwner{
647 
648 
649 
650         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
651  
652         excludeFromMaxTransaction(address(_uniswapV2Router), true);
653         uniswapV2Router = _uniswapV2Router;
654  
655         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
656         excludeFromMaxTransaction(address(uniswapV2Pair), true);
657         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
658         
659         uint256 ethAmount = address(this).balance;
660         uint256 tokenAmount = balanceOf(address(this)) * 90 / 100;
661         
662 
663       
664         _approve(address(this), address(uniswapV2Router), tokenAmount);
665 
666         uniswapV2Router.addLiquidityETH{value: ethAmount}(
667             address(this),
668             tokenAmount,
669                 0, // slippage is unavoidable
670                 0, // slippage is unavoidable
671             devWallet,
672             block.timestamp
673         );
674     }
675 
676 
677     
678 
679     function removeStuckETH() external onlyOwner {
680         uint256 ethBalance = address(this).balance;
681         require(ethBalance > 0, "ETH balance must be greater than 0");
682         (bool success,) = address(devWallet).call{value: ethBalance}("");
683         require(success, "Failed to clear ETH balance");
684     }
685 
686     function removeStuckTokenBalance() external onlyOwner {
687         uint256 tokenBalance = balanceOf(address(this));
688         require(tokenBalance > 0, "Token balance must be greater than 0");
689         _transfer(address(this), devWallet, tokenBalance);
690     }
691 
692     function deactivateLimits() external onlyOwner {
693         areLimitsOn = false;
694     }
695  
696     function nukeContractHoldings(bool enabled) external onlyOwner{
697         emptyContractFull = enabled;
698     }
699  
700     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
701         _isExcludedMaxTransactionAmount[updAds] = isEx;
702     }
703 
704   
705     function switchFees(
706         uint256 _devBuy,
707         uint256 _devSell,
708         uint256 _liqBuy,
709         uint256 _liqSell
710     ) external onlyOwner {
711         devBuyTax = _devBuy;
712         liqBuyTax = _liqBuy;
713         totalBuyTax = devBuyTax + liqBuyTax;
714         devSellTax = _devSell;
715         liqSellTax = _liqSell;
716         totalSellTax = devSellTax + liqSellTax;
717         require(totalBuyTax <= 30, "MAX 30% tax allowed");
718         require(totalSellTax <= 30, "MAX 30% tax allowed");
719     }
720 
721     function excludeFromFees(address account, bool excluded) public onlyOwner {
722         _isExcludedFromFees[account] = excluded;
723         emit ExcludeFromFees(account, excluded);
724     }
725  
726     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
727         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
728  
729         _setAutomatedMarketMakerPair(pair, value);
730     }
731  
732     function _setAutomatedMarketMakerPair(address pair, bool value) private {
733         automatedMarketMakerPairs[pair] = value;
734  
735         emit SetAutomatedMarketMakerPair(pair, value);
736     }
737 
738     function updateDevWallet(address newDevWallet) external onlyOwner{
739         emit devWalletUpdated(newDevWallet, devWallet);
740         devWallet = newDevWallet;
741     }
742 
743     function isExcludedFromFees(address account) public view returns(bool) {
744         return _isExcludedFromFees[account];
745     }
746  
747     function _transfer(
748         address from,
749         address to,
750         uint256 amount
751     ) internal override {
752         require(from != address(0), "ERC20: transfer from the zero address");
753         require(to != address(0), "ERC20: transfer to the zero address");
754          if(amount == 0) {
755             super._transfer(from, to, 0);
756             return;
757         }
758  
759         if(areLimitsOn){
760             if (
761                 from != owner() &&
762                 to != owner() &&
763                 to != address(0) &&
764                 to != address(0xdead) &&
765                 !isSwppable
766             ){
767                 
768                 //when buy
769                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
770                         require(amount <= maxTransaction, "Buy transfer amount exceeds the maxTransactionAmount.");
771                         require(amount + balanceOf(to) <= maxWalletHolding, "Max wallet exceeded");
772                 }
773  
774                 //when sell
775                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
776                         require(amount <= maxTransaction, "Sell transfer amount exceeds the maxTransactionAmount.");
777                 }
778                 else if(!_isExcludedMaxTransactionAmount[to]){
779                     require(amount + balanceOf(to) <= maxWalletHolding, "Max wallet exceeded");
780                 }
781             }
782         }
783  
784         uint256 contractTokenBalance = balanceOf(address(this));
785  
786         bool canSwap = contractTokenBalance >= contractSellTreshold;
787  
788         if( 
789             canSwap &&
790             !isSwppable &&
791             !automatedMarketMakerPairs[from] &&
792             !_isExcludedFromFees[from] &&
793             !_isExcludedFromFees[to]
794         ) {
795             isSwppable = true;
796  
797             swapBack();
798  
799             isSwppable = false;
800         }
801  
802         bool takeFee = !isSwppable;
803  
804         // if any account belongs to _isExcludedFromFee account then remove the fee
805         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
806             takeFee = false;
807         }
808  
809         uint256 fees = 0;
810         // only take fees on buys/sells, do not take on wallet transfers
811         if(takeFee){
812             // on sell
813             if (automatedMarketMakerPairs[to] && totalSellTax > 0){
814                 fees = amount.mul(totalSellTax).div(100);
815                 tokensForLiquidity += fees * liqSellTax / totalSellTax;
816                 tokensForDev += fees * devSellTax / totalSellTax;
817             }
818             // on buy
819             else if(automatedMarketMakerPairs[from] && totalBuyTax > 0) {
820                 fees = amount.mul(totalBuyTax).div(100);
821                 tokensForLiquidity += fees * liqBuyTax / totalBuyTax;
822                 tokensForDev += fees * devBuyTax / totalBuyTax;
823             }
824  
825             if(fees > 0){    
826                 super._transfer(from, address(this), fees);
827             }
828  
829             amount -= fees;
830         }
831  
832         super._transfer(from, to, amount);
833     }
834  
835     function swapTokensForEth(uint256 tokenAmount) private {
836  
837         // generate the uniswap pair path of token -> weth
838         address[] memory path = new address[](2);
839         path[0] = address(this);
840         path[1] = uniswapV2Router.WETH();
841  
842         _approve(address(this), address(uniswapV2Router), tokenAmount);
843  
844         // make the swap
845         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
846             tokenAmount,
847             0, // accept any amount of ETH
848             path,
849             address(this),
850             block.timestamp
851         );
852  
853     }
854  
855     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
856         // approve token transfer to cover all possible scenarios
857         _approve(address(this), address(uniswapV2Router), tokenAmount);
858  
859         // add the liquidity
860         uniswapV2Router.addLiquidityETH{value: ethAmount}(
861             address(this),
862             tokenAmount,
863             0, // slippage is unavoidable
864             0, // slippage is unavoidable
865             address(this),
866             block.timestamp
867         );
868     }
869  
870     function swapBack() private {
871         uint256 contractBalance = balanceOf(address(this));
872         uint256 totalTokensToSwap = tokensForLiquidity + tokensForDev;
873         bool success;
874  
875         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
876  
877         if(emptyContractFull == false){
878             if(contractBalance > contractSellTreshold * 20){
879                 contractBalance = contractSellTreshold * 20;
880             }
881         }else{
882             contractBalance = balanceOf(address(this));
883         }
884         
885  
886         // Halve the amount of liquidity tokens
887         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
888         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
889  
890         uint256 initialETHBalance = address(this).balance;
891  
892         swapTokensForEth(amountToSwapForETH); 
893  
894         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
895  
896         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
897         uint256 ethForLiquidity = ethBalance - ethForDev;
898  
899  
900         tokensForLiquidity = 0;
901         tokensForDev = 0;
902  
903         if(liquidityTokens > 0 && ethForLiquidity > 0){
904             addLiquidity(liquidityTokens, ethForLiquidity);
905             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
906         }
907  
908         (success,) = address(devWallet).call{value: address(this).balance}("");
909     }
910 }