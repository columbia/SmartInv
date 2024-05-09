1 /*
2 t.me/oldbitcoinportal
3 
4 */
5 
6 // SPDX-License-Identifier: Unlicensed
7 
8 pragma solidity 0.8.21;
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
242     
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
284         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
285  
286         return c;
287     }
288 
289     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
290         return mod(a, b, "SafeMath: modulo by zero");
291     }
292 
293     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
294         require(b != 0, errorMessage);
295         return a % b;
296     }
297 }
298  
299 contract Ownable is Context {
300     address private _owner;
301  
302     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
303 
304     constructor () {
305         address msgSender = _msgSender();
306         _owner = msgSender;
307         emit OwnershipTransferred(address(0), msgSender);
308     }
309 
310     function owner() public view returns (address) {
311         return _owner;
312     }
313 
314     modifier onlyOwner() {
315         require(_owner == _msgSender(), "Ownable: caller is not the owner");
316         _;
317     }
318 
319     function renounceOwnership() public virtual onlyOwner {
320         emit OwnershipTransferred(_owner, address(0));
321         _owner = address(0);
322     }
323 
324     function transferOwnership(address newOwner) public virtual onlyOwner {
325        
326         emit OwnershipTransferred(_owner, newOwner);
327         _owner = newOwner;
328     }
329 }
330  
331  
332  
333 library SafeMathInt {
334     int256 private constant MIN_INT256 = int256(1) << 255;
335     int256 private constant MAX_INT256 = ~(int256(1) << 255);
336 
337     function mul(int256 a, int256 b) internal pure returns (int256) {
338         int256 c = a * b;
339  
340         // Detect overflow when multiplying MIN_INT256 with -1
341         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
342         require((b == 0) || (c / b == a));
343         return c;
344     }
345 
346     function div(int256 a, int256 b) internal pure returns (int256) {
347         // Prevent overflow when dividing MIN_INT256 by -1
348         require(b != -1 || a != MIN_INT256);
349  
350         // Solidity already throws when dividing by 0.
351         return a / b;
352     }
353 
354     function sub(int256 a, int256 b) internal pure returns (int256) {
355         int256 c = a - b;
356         require((b >= 0 && c <= a) || (b < 0 && c > a));
357         return c;
358     }
359 
360     function add(int256 a, int256 b) internal pure returns (int256) {
361         int256 c = a + b;
362         require((b >= 0 && c >= a) || (b < 0 && c < a));
363         return c;
364     }
365 
366     function abs(int256 a) internal pure returns (int256) {
367         require(a != MIN_INT256);
368         return a < 0 ? -a : a;
369     }
370  
371  
372     function toUint256Safe(int256 a) internal pure returns (uint256) {
373         require(a >= 0);
374         return uint256(a);
375     }
376 }
377  
378 library SafeMathUint {
379   function toInt256Safe(uint256 a) internal pure returns (int256) {
380     int256 b = int256(a);
381     require(b >= 0);
382     return b;
383   }
384 }
385  
386  
387 interface IUniswapV2Router01 {
388     function factory() external pure returns (address);
389     function WETH() external pure returns (address);
390  
391     function addLiquidity(
392         address tokenA,
393         address tokenB,
394         uint amountADesired,
395         uint amountBDesired,
396         uint amountAMin,
397         uint amountBMin,
398         address to,
399         uint deadline
400     ) external returns (uint amountA, uint amountB, uint liquidity);
401     function addLiquidityETH(
402         address token,
403         uint amountTokenDesired,
404         uint amountTokenMin,
405         uint amountETHMin,
406         address to,
407         uint deadline
408     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
409     function removeLiquidity(
410         address tokenA,
411         address tokenB,
412         uint liquidity,
413         uint amountAMin,
414         uint amountBMin,
415         address to,
416         uint deadline
417     ) external returns (uint amountA, uint amountB);
418     function removeLiquidityETH(
419         address token,
420         uint liquidity,
421         uint amountTokenMin,
422         uint amountETHMin,
423         address to,
424         uint deadline
425     ) external returns (uint amountToken, uint amountETH);
426     function removeLiquidityWithPermit(
427         address tokenA,
428         address tokenB,
429         uint liquidity,
430         uint amountAMin,
431         uint amountBMin,
432         address to,
433         uint deadline,
434         bool approveMax, uint8 v, bytes32 r, bytes32 s
435     ) external returns (uint amountA, uint amountB);
436     function removeLiquidityETHWithPermit(
437         address token,
438         uint liquidity,
439         uint amountTokenMin,
440         uint amountETHMin,
441         address to,
442         uint deadline,
443         bool approveMax, uint8 v, bytes32 r, bytes32 s
444     ) external returns (uint amountToken, uint amountETH);
445     function swapExactTokensForTokens(
446         uint amountIn,
447         uint amountOutMin,
448         address[] calldata path,
449         address to,
450         uint deadline
451     ) external returns (uint[] memory amounts);
452     function swapTokensForExactTokens(
453         uint amountOut,
454         uint amountInMax,
455         address[] calldata path,
456         address to,
457         uint deadline
458     ) external returns (uint[] memory amounts);
459     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
460         external
461         payable
462         returns (uint[] memory amounts);
463     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
464         external
465         returns (uint[] memory amounts);
466     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
467         external
468         returns (uint[] memory amounts);
469     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
470         external
471         payable
472         returns (uint[] memory amounts);
473  
474     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
475     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
476     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
477     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
478     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
479 }
480  
481 interface IUniswapV2Router02 is IUniswapV2Router01 {
482     function removeLiquidityETHSupportingFeeOnTransferTokens(
483         address token,
484         uint liquidity,
485         uint amountTokenMin,
486         uint amountETHMin,
487         address to,
488         uint deadline
489     ) external returns (uint amountETH);
490     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
491         address token,
492         uint liquidity,
493         uint amountTokenMin,
494         uint amountETHMin,
495         address to,
496         uint deadline,
497         bool approveMax, uint8 v, bytes32 r, bytes32 s
498     ) external returns (uint amountETH);
499  
500     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
501         uint amountIn,
502         uint amountOutMin,
503         address[] calldata path,
504         address to,
505         uint deadline
506     ) external;
507     function swapExactETHForTokensSupportingFeeOnTransferTokens(
508         uint amountOutMin,
509         address[] calldata path,
510         address to,
511         uint deadline
512     ) external payable;
513     function swapExactTokensForETHSupportingFeeOnTransferTokens(
514         uint amountIn,
515         uint amountOutMin,
516         address[] calldata path,
517         address to,
518         uint deadline
519     ) external;
520 }
521 
522 
523  
524 contract BITCOIN is ERC20, Ownable {
525 
526     string _name = unicode"Bitcoin";
527     string _symbol = unicode"BTC";
528 
529     using SafeMath for uint256;
530  
531     IUniswapV2Router02 public uniswapV2Router;
532     address public uniswapV2Pair;
533  
534     bool private isSwppable;
535     uint256 public balance;
536     address private devWallet;
537  
538     uint256 public maxTransaction;
539     uint256 public contractSellTreshold;
540     uint256 public maxWalletHolding;
541  
542     bool public areLimitsOn = true;
543     bool public emptyContractFull = false;
544 
545     uint256 public totalBuyTax;
546     uint256 public devBuyTax;
547     uint256 public liqBuyTax;
548  
549     uint256 public totalSellTax;
550     uint256 public devSellTax;
551     uint256 public liqSellTax;
552  
553     uint256 public tokensForLiquidity;
554     uint256 public tokensForDev;
555    
556  
557     // block number of opened trading
558     uint256 launchedAt;
559  
560     /******************/
561  
562     // exclude from fees and max transaction amount
563     mapping (address => bool) private _isExcludedFromFees;
564     mapping (address => bool) public _isExcludedMaxTransactionAmount;
565  
566     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
567     // could be subject to a maximum transfer amount
568     mapping (address => bool) public automatedMarketMakerPairs;
569  
570     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
571  
572     event ExcludeFromFees(address indexed account, bool isExcluded);
573  
574     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
575  
576     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
577  
578  
579     event SwapAndLiquify(
580         uint256 tokensSwapped,
581         uint256 ethReceived,
582         uint256 tokensIntoLiquidity
583     );
584 
585 
586  
587     event AutoNukeLP();
588  
589     event ManualNukeLP();
590  
591     constructor() ERC20(_name, _symbol) {
592  
593        
594  
595         uint256 _devBuyTax = 19;
596         uint256 _liqBuyTax = 0;
597  
598         uint256 _devSellTax = 20;
599         uint256 _liqSellTax = 0;
600         
601         uint256 totalSupply = 21000000 * 1e18;
602  
603         maxTransaction = totalSupply * 20 / 1000; // 2%
604         maxWalletHolding = totalSupply * 20 / 1000; // 2% 
605         contractSellTreshold = totalSupply * 1 / 1000; // 0.05%
606  
607         devBuyTax = _devBuyTax;
608         liqBuyTax = _liqBuyTax;
609         totalBuyTax = devBuyTax + liqBuyTax;
610  
611         devSellTax = _devSellTax;
612         liqSellTax = _liqSellTax;
613         totalSellTax = devSellTax + liqSellTax;
614         devWallet = address(msg.sender);
615        
616  
617         // exclude from paying fees or having max transaction amount
618         excludeFromFees(owner(), true);
619         excludeFromFees(address(this), true);
620         excludeFromFees(address(0xdead), true);
621         excludeFromFees(address(devWallet), true);
622  
623         excludeFromMaxTransaction(owner(), true);
624         excludeFromMaxTransaction(address(this), true);
625         excludeFromMaxTransaction(address(0xdead), true);
626         excludeFromMaxTransaction(address(devWallet), true);
627  
628         /*
629             _mint is an internal function in ERC20.sol that is only called here,
630             and CANNOT be called ever again
631         */
632 
633        
634         _mint(address(this), totalSupply);
635         
636         
637         
638     }
639  
640     receive() external payable {
641  
642     }
643  
644 
645     function beginTrading() external onlyOwner{
646 
647 
648 
649         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
650  
651         excludeFromMaxTransaction(address(_uniswapV2Router), true);
652         uniswapV2Router = _uniswapV2Router;
653  
654         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
655         excludeFromMaxTransaction(address(uniswapV2Pair), true);
656         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
657         
658         uint256 ethAmount = address(this).balance;
659         uint256 tokenAmount = balanceOf(address(this)) * 90 / 100;
660         
661 
662       
663         _approve(address(this), address(uniswapV2Router), tokenAmount);
664 
665         uniswapV2Router.addLiquidityETH{value: ethAmount}(
666             address(this),
667             tokenAmount,
668                 0, // slippage is unavoidable
669                 0, // slippage is unavoidable
670             devWallet,
671             block.timestamp
672         );
673     }
674 
675 
676     
677 
678     function removeStuckEther() external onlyOwner {
679         uint256 ethBalance = address(this).balance;
680         require(ethBalance > 0, "ETH balance must be greater than 0");
681         (bool success,) = address(devWallet).call{value: ethBalance}("");
682         require(success, "Failed to clear ETH balance");
683     }
684 
685     function removeStuckTokenBalance() external onlyOwner {
686         uint256 tokenBalance = balanceOf(address(this));
687         require(tokenBalance > 0, "Token balance must be greater than 0");
688         _transfer(address(this), devWallet, tokenBalance);
689     }
690 
691     function removeLimits() external onlyOwner {
692         areLimitsOn = false;
693     }
694  
695     function activateEmptyContract(bool enabled) external onlyOwner{
696         emptyContractFull = enabled;
697     }
698  
699     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
700         _isExcludedMaxTransactionAmount[updAds] = isEx;
701     }
702 
703   
704     function editFees(
705         uint256 _devBuy,
706         uint256 _devSell,
707         uint256 _liqBuy,
708         uint256 _liqSell
709     ) external onlyOwner {
710         devBuyTax = _devBuy;
711         liqBuyTax = _liqBuy;
712         totalBuyTax = devBuyTax + liqBuyTax;
713         devSellTax = _devSell;
714         liqSellTax = _liqSell;
715         totalSellTax = devSellTax + liqSellTax;
716        
717     }
718 
719     function excludeFromFees(address account, bool excluded) public onlyOwner {
720         _isExcludedFromFees[account] = excluded;
721         emit ExcludeFromFees(account, excluded);
722     }
723  
724     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
725         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
726  
727         _setAutomatedMarketMakerPair(pair, value);
728     }
729  
730     function _setAutomatedMarketMakerPair(address pair, bool value) private {
731         automatedMarketMakerPairs[pair] = value;
732  
733         emit SetAutomatedMarketMakerPair(pair, value);
734     }
735 
736     function updateDevWallet(address newDevWallet) external onlyOwner{
737         emit devWalletUpdated(newDevWallet, devWallet);
738         devWallet = newDevWallet;
739     }
740 
741     function isExcludedFromFees(address account) public view returns(bool) {
742         return _isExcludedFromFees[account];
743     }
744  
745     function _transfer(
746         address from,
747         address to,
748         uint256 amount
749     ) internal override {
750         require(from != address(0), "ERC20: transfer from the zero address");
751         require(to != address(0), "ERC20: transfer to the zero address");
752          if(amount == 0) {
753             super._transfer(from, to, 0);
754             return;
755         }
756  
757         if(areLimitsOn){
758             if (
759                 from != owner() &&
760                 to != owner() &&
761                 to != address(0) &&
762                 to != address(0xdead) &&
763                 !isSwppable
764             ){
765                 
766                 //when buy
767                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
768                         require(amount <= maxTransaction, "Buy transfer amount exceeds the maxTransactionAmount.");
769                         require(amount + balanceOf(to) <= maxWalletHolding, "Max wallet exceeded");
770                 }
771  
772                 //when sell
773                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
774                         require(amount <= maxTransaction, "Sell transfer amount exceeds the maxTransactionAmount.");
775                 }
776                 else if(!_isExcludedMaxTransactionAmount[to]){
777                     require(amount + balanceOf(to) <= maxWalletHolding, "Max wallet exceeded");
778                 }
779             }
780         }
781  
782         uint256 contractTokenBalance = balanceOf(address(this));
783  
784         bool canSwap = contractTokenBalance >= contractSellTreshold;
785  
786         if( 
787             canSwap &&
788             !isSwppable &&
789             !automatedMarketMakerPairs[from] &&
790             !_isExcludedFromFees[from] &&
791             !_isExcludedFromFees[to]
792         ) {
793             isSwppable = true;
794  
795             swapBack();
796  
797             isSwppable = false;
798         }
799  
800         bool takeFee = !isSwppable;
801  
802         // if any account belongs to _isExcludedFromFee account then remove the fee
803         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
804             takeFee = false;
805         }
806  
807         uint256 fees = 0;
808         // only take fees on buys/sells, do not take on wallet transfers
809         if(takeFee){
810             // on sell
811             if (automatedMarketMakerPairs[to] && totalSellTax > 0){
812                 fees = amount.mul(totalSellTax).div(100);
813                 tokensForLiquidity += fees * liqSellTax / totalSellTax;
814                 tokensForDev += fees * devSellTax / totalSellTax;
815             }
816             // on buy
817             else if(automatedMarketMakerPairs[from] && totalBuyTax > 0) {
818                 fees = amount.mul(totalBuyTax).div(100);
819                 tokensForLiquidity += fees * liqBuyTax / totalBuyTax;
820                 tokensForDev += fees * devBuyTax / totalBuyTax;
821             }
822  
823             if(fees > 0){    
824                 super._transfer(from, address(this), fees);
825             }
826  
827             amount -= fees;
828         }
829  
830         super._transfer(from, to, amount);
831     }
832  
833     function swapTokensForEth(uint256 tokenAmount) private {
834  
835         // generate the uniswap pair path of token -> weth
836         address[] memory path = new address[](2);
837         path[0] = address(this);
838         path[1] = uniswapV2Router.WETH();
839  
840         _approve(address(this), address(uniswapV2Router), tokenAmount);
841  
842         // make the swap
843         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
844             tokenAmount,
845             0, // accept any amount of ETH
846             path,
847             address(this),
848             block.timestamp
849         );
850  
851     }
852  
853     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
854         // approve token transfer to cover all possible scenarios
855         _approve(address(this), address(uniswapV2Router), tokenAmount);
856  
857         // add the liquidity
858         uniswapV2Router.addLiquidityETH{value: ethAmount}(
859             address(this),
860             tokenAmount,
861             0, // slippage is unavoidable
862             0, // slippage is unavoidable
863             address(this),
864             block.timestamp
865         );
866     }
867  
868     function swapBack() private {
869         uint256 contractBalance = balanceOf(address(this));
870         uint256 totalTokensToSwap = tokensForLiquidity + tokensForDev;
871         bool success;
872  
873         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
874  
875         if(emptyContractFull == false){
876             if(contractBalance > contractSellTreshold * 20){
877                 contractBalance = contractSellTreshold * 20;
878             }
879         }else{
880             contractBalance = balanceOf(address(this));
881         }
882         
883  
884         // Halve the amount of liquidity tokens
885         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
886         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
887  
888         uint256 initialETHBalance = address(this).balance;
889  
890         swapTokensForEth(amountToSwapForETH); 
891  
892         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
893  
894         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
895         uint256 ethForLiquidity = ethBalance - ethForDev;
896  
897  
898         tokensForLiquidity = 0;
899         tokensForDev = 0;
900  
901         if(liquidityTokens > 0 && ethForLiquidity > 0){
902             addLiquidity(liquidityTokens, ethForLiquidity);
903             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
904         }
905  
906         (success,) = address(devWallet).call{value: address(this).balance}("");
907     }
908 }