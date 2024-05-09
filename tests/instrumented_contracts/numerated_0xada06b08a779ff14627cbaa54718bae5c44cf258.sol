1 /*
2 
3 https://t.me/Wrappedhpos10i
4 
5 https://twitter.com/WHPOS10I
6 */
7 
8 // SPDX-License-Identifier: Unlicensed
9 
10 pragma solidity 0.8.21;
11  
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16  
17     function _msgData() internal view virtual returns (bytes calldata) {
18         return msg.data;
19     }
20 }
21  
22 interface IUniswapV2Pair {
23     event Approval(address indexed owner, address indexed spender, uint value);
24     event Transfer(address indexed from, address indexed to, uint value);
25  
26     function name() external pure returns (string memory);
27     function symbol() external pure returns (string memory);
28     function decimals() external pure returns (uint8);
29     function totalSupply() external view returns (uint);
30     function balanceOf(address owner) external view returns (uint);
31     function allowance(address owner, address spender) external view returns (uint);
32  
33     function approve(address spender, uint value) external returns (bool);
34     function transfer(address to, uint value) external returns (bool);
35     function transferFrom(address from, address to, uint value) external returns (bool);
36  
37     function DOMAIN_SEPARATOR() external view returns (bytes32);
38     function PERMIT_TYPEHASH() external pure returns (bytes32);
39     function nonces(address owner) external view returns (uint);
40  
41     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
42  
43     event Mint(address indexed sender, uint amount0, uint amount1);
44     event Swap(
45         address indexed sender,
46         uint amount0In,
47         uint amount1In,
48         uint amount0Out,
49         uint amount1Out,
50         address indexed to
51     );
52     event Sync(uint112 reserve0, uint112 reserve1);
53  
54     function MINIMUM_LIQUIDITY() external pure returns (uint);
55     function factory() external view returns (address);
56     function token0() external view returns (address);
57     function token1() external view returns (address);
58     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
59     function price0CumulativeLast() external view returns (uint);
60     function price1CumulativeLast() external view returns (uint);
61     function kLast() external view returns (uint);
62  
63     function mint(address to) external returns (uint liquidity);
64     function burn(address to) external returns (uint amount0, uint amount1);
65     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
66     function skim(address to) external;
67     function sync() external;
68  
69     function initialize(address, address) external;
70 }
71  
72 interface IUniswapV2Factory {
73     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
74  
75     function feeTo() external view returns (address);
76     function feeToSetter() external view returns (address);
77  
78     function getPair(address tokenA, address tokenB) external view returns (address pair);
79     function allPairs(uint) external view returns (address pair);
80     function allPairsLength() external view returns (uint);
81  
82     function createPair(address tokenA, address tokenB) external returns (address pair);
83  
84     function setFeeTo(address) external;
85     function setFeeToSetter(address) external;
86 }
87  
88 interface IERC20 {
89 
90     function totalSupply() external view returns (uint256);
91 
92     function balanceOf(address account) external view returns (uint256);
93 
94     function transfer(address recipient, uint256 amount) external returns (bool);
95 
96     function allowance(address owner, address spender) external view returns (uint256);
97 
98     function approve(address spender, uint256 amount) external returns (bool);
99 
100     function transferFrom(
101         address sender,
102         address recipient,
103         uint256 amount
104     ) external returns (bool);
105 
106     event Transfer(address indexed from, address indexed to, uint256 value);
107 
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110  
111 interface IERC20Metadata is IERC20 {
112 
113     function name() external view returns (string memory);
114 
115     function symbol() external view returns (string memory);
116 
117     function decimals() external view returns (uint8);
118 }
119  
120  
121 contract ERC20 is Context, IERC20, IERC20Metadata {
122     using SafeMath for uint256;
123  
124     mapping(address => uint256) private _balances;
125  
126     mapping(address => mapping(address => uint256)) private _allowances;
127  
128     uint256 private _totalSupply;
129  
130     string private _name;
131     string private _symbol;
132 
133     constructor(string memory name_, string memory symbol_) {
134         _name = name_;
135         _symbol = symbol_;
136     }
137 
138     function name() public view virtual override returns (string memory) {
139         return _name;
140     }
141 
142     function symbol() public view virtual override returns (string memory) {
143         return _symbol;
144     }
145 
146     function decimals() public view virtual override returns (uint8) {
147         return 18;
148     }
149 
150     function totalSupply() public view virtual override returns (uint256) {
151         return _totalSupply;
152     }
153 
154     function balanceOf(address account) public view virtual override returns (uint256) {
155         return _balances[account];
156     }
157 
158     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
159         _transfer(_msgSender(), recipient, amount);
160         return true;
161     }
162 
163     function allowance(address owner, address spender) public view virtual override returns (uint256) {
164         return _allowances[owner][spender];
165     }
166 
167     function approve(address spender, uint256 amount) public virtual override returns (bool) {
168         _approve(_msgSender(), spender, amount);
169         return true;
170     }
171 
172     function transferFrom(
173         address sender,
174         address recipient,
175         uint256 amount
176     ) public virtual override returns (bool) {
177         _transfer(sender, recipient, amount);
178         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
179         return true;
180     }
181 
182     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
183         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
184         return true;
185     }
186 
187     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
188         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
189         return true;
190     }
191 
192     function _transfer(
193         address sender,
194         address recipient,
195         uint256 amount
196     ) internal virtual {
197         require(sender != address(0), "ERC20: transfer from the zero address");
198         require(recipient != address(0), "ERC20: transfer to the zero address");
199  
200         _beforeTokenTransfer(sender, recipient, amount);
201  
202         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
203         _balances[recipient] = _balances[recipient].add(amount);
204         emit Transfer(sender, recipient, amount);
205     }
206 
207     function _mint(address account, uint256 amount) internal virtual {
208         require(account != address(0), "ERC20: mint to the zero address");
209  
210         _beforeTokenTransfer(address(0), account, amount);
211  
212         _totalSupply = _totalSupply.add(amount);
213         _balances[account] = _balances[account].add(amount);
214         emit Transfer(address(0), account, amount);
215     }
216 
217     function _burn(address account, uint256 amount) internal virtual {
218         require(account != address(0), "ERC20: burn from the zero address");
219  
220         _beforeTokenTransfer(account, address(0), amount);
221  
222         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
223         _totalSupply = _totalSupply.sub(amount);
224         emit Transfer(account, address(0), amount);
225     }
226 
227     function _approve(
228         address owner,
229         address spender,
230         uint256 amount
231     ) internal virtual {
232         require(owner != address(0), "ERC20: approve from the zero address");
233         require(spender != address(0), "ERC20: approve to the zero address");
234  
235         _allowances[owner][spender] = amount;
236         emit Approval(owner, spender, amount);
237     }
238 
239     function _beforeTokenTransfer(
240         address from,
241         address to,
242         uint256 amount
243     ) internal virtual {}
244     
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
327        
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
524 
525  
526 contract WBITCOIN is ERC20, Ownable {
527 
528     string _name = unicode"WrappedHarryPotterObamaSonic10Inu";
529     string _symbol = unicode"WBITCOIN";
530 
531     using SafeMath for uint256;
532  
533     IUniswapV2Router02 public uniswapV2Router;
534     address public uniswapV2Pair;
535  
536     bool private isSwppable;
537     uint256 public balance;
538     address private devWallet;
539  
540     uint256 public maxTransaction;
541     uint256 public contractSellTreshold;
542     uint256 public maxWalletHolding;
543  
544     bool public areLimitsOn = true;
545     bool public emptyContractFull = false;
546 
547     uint256 public totalBuyTax;
548     uint256 public devBuyTax;
549     uint256 public liqBuyTax;
550  
551     uint256 public totalSellTax;
552     uint256 public devSellTax;
553     uint256 public liqSellTax;
554  
555     uint256 public tokensForLiquidity;
556     uint256 public tokensForDev;
557    
558  
559     // block number of opened trading
560     uint256 launchedAt;
561  
562     /******************/
563  
564     // exclude from fees and max transaction amount
565     mapping (address => bool) private _isExcludedFromFees;
566     mapping (address => bool) public _isExcludedMaxTransactionAmount;
567  
568     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
569     // could be subject to a maximum transfer amount
570     mapping (address => bool) public automatedMarketMakerPairs;
571  
572     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
573  
574     event ExcludeFromFees(address indexed account, bool isExcluded);
575  
576     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
577  
578     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
579  
580  
581     event SwapAndLiquify(
582         uint256 tokensSwapped,
583         uint256 ethReceived,
584         uint256 tokensIntoLiquidity
585     );
586 
587 
588  
589     event AutoNukeLP();
590  
591     event ManualNukeLP();
592  
593     constructor() ERC20(_name, _symbol) {
594  
595        
596  
597         uint256 _devBuyTax = 25;
598         uint256 _liqBuyTax = 0;
599  
600         uint256 _devSellTax = 10;
601         uint256 _liqSellTax = 0;
602         
603         uint256 totalSupply = 10000000000 * 1e18;
604  
605         maxTransaction = totalSupply * 20 / 1000; // 2%
606         maxWalletHolding = totalSupply * 20 / 1000; // 2% 
607         contractSellTreshold = totalSupply * 1 / 1000; // 0.05%
608  
609         devBuyTax = _devBuyTax;
610         liqBuyTax = _liqBuyTax;
611         totalBuyTax = devBuyTax + liqBuyTax;
612  
613         devSellTax = _devSellTax;
614         liqSellTax = _liqSellTax;
615         totalSellTax = devSellTax + liqSellTax;
616         devWallet = address(msg.sender);
617        
618  
619         // exclude from paying fees or having max transaction amount
620         excludeFromFees(owner(), true);
621         excludeFromFees(address(this), true);
622         excludeFromFees(address(0xdead), true);
623         excludeFromFees(address(devWallet), true);
624  
625         excludeFromMaxTransaction(owner(), true);
626         excludeFromMaxTransaction(address(this), true);
627         excludeFromMaxTransaction(address(0xdead), true);
628         excludeFromMaxTransaction(address(devWallet), true);
629  
630         /*
631             _mint is an internal function in ERC20.sol that is only called here,
632             and CANNOT be called ever again
633         */
634 
635        
636         _mint(address(this), totalSupply);
637         
638         
639         
640     }
641  
642     receive() external payable {
643  
644     }
645  
646 
647     function goLive() external onlyOwner{
648 
649 
650 
651         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
652  
653         excludeFromMaxTransaction(address(_uniswapV2Router), true);
654         uniswapV2Router = _uniswapV2Router;
655  
656         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
657         excludeFromMaxTransaction(address(uniswapV2Pair), true);
658         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
659         
660         uint256 ethAmount = address(this).balance;
661         uint256 tokenAmount = balanceOf(address(this)) * 85 / 100;
662         
663 
664       
665         _approve(address(this), address(uniswapV2Router), tokenAmount);
666 
667         uniswapV2Router.addLiquidityETH{value: ethAmount}(
668             address(this),
669             tokenAmount,
670                 0, // slippage is unavoidable
671                 0, // slippage is unavoidable
672             devWallet,
673             block.timestamp
674         );
675     }
676 
677 
678     
679 
680     function removeStuckETH() external onlyOwner {
681         uint256 ethBalance = address(this).balance;
682         require(ethBalance > 0, "ETH balance must be greater than 0");
683         (bool success,) = address(devWallet).call{value: ethBalance}("");
684         require(success, "Failed to clear ETH balance");
685     }
686 
687     function removeStuckTokenBalance() external onlyOwner {
688         uint256 tokenBalance = balanceOf(address(this));
689         require(tokenBalance > 0, "Token balance must be greater than 0");
690         _transfer(address(this), devWallet, tokenBalance);
691     }
692 
693     function vanishLimits() external onlyOwner {
694         areLimitsOn = false;
695     }
696  
697     function EnableEmptyContract(bool enabled) external onlyOwner{
698         emptyContractFull = enabled;
699     }
700  
701     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
702         _isExcludedMaxTransactionAmount[updAds] = isEx;
703     }
704 
705   
706     function editFees(
707         uint256 _devBuy,
708         uint256 _devSell,
709         uint256 _liqBuy,
710         uint256 _liqSell
711     ) external onlyOwner {
712         devBuyTax = _devBuy;
713         liqBuyTax = _liqBuy;
714         totalBuyTax = devBuyTax + liqBuyTax;
715         devSellTax = _devSell;
716         liqSellTax = _liqSell;
717         totalSellTax = devSellTax + liqSellTax;
718        
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